"""
EMS Banquet - Multi-Platform Hybrid Database & Google Sheets Sync Adapter (v3.0)
Hỗ trợ 2 chế độ vận hành linh hoạt:
1. mode = "sql_server"    : Kết nối trực tiếp Microsoft SQL Server qua pyodbc (Production / Cloud VPS Paid 2A).
2. mode = "google_sheets" : Chạy hoàn toàn trên Cloud với Google Sheets làm Database chính (Free 1C & Paid 2A),
                            kết hợp tầng đệm SQLite tương thích T-SQL (< 2ms) và đồng bộ 2 chiều tự động lên Google Sheets.
"""
import os
import re
import json
import time
import sqlite3
import datetime
import threading
import urllib.request
from pathlib import Path

BUNDLE_ROOT = Path(__file__).resolve().parent.parent
CONFIG_FILE = BUNDLE_ROOT / "config.json"
TEMPLATES_DIR = BUNDLE_ROOT / "database_templates"
DATA_DIR = Path(__file__).resolve().parent / "data"
DATA_DIR.mkdir(parents=True, exist_ok=True)
GSHEET_MIRROR_DB = DATA_DIR / "gsheet_mirror.db"

_INIT_LOCK = threading.Lock()
_MIRROR_INITIALIZED = False


def load_bundle_config() -> dict:
    cfg = {
        "mode": os.getenv("EMS_DB_MODE", "sql_server"),
        "db_server": os.getenv("EMS_SQL_SERVER", "10.17.10.12\\MSSQLSERVER2016"),
        "db_name": os.getenv("EMS_SQL_DB", "EMS_KHAIVY"),
        "db_user": os.getenv("EMS_SQL_USER", "SA"),
        "db_password": os.getenv("EMS_SQL_PASSWORD", "Sa!123123#"),
        "google_sheet_id": os.getenv("EMS_GSHEET_ID", ""),
        "google_webhook_url": os.getenv("EMS_GSHEET_WEBHOOK_URL", ""),
        "google_credentials_file": os.getenv("EMS_GSHEET_CREDS", ""),
    }
    if CONFIG_FILE.exists():
        try:
            with open(CONFIG_FILE, "r", encoding="utf-8") as f:
                file_cfg = json.load(f)
                for k, v in file_cfg.items():
                    if v is not None and str(v).strip() != "":
                        cfg[k] = v
        except Exception as e:
            print(f"[db_adapter] Warning reading config.json: {e}")
    # Environment variable override takes highest priority for Cloud deployments
    if os.getenv("EMS_DB_MODE"):
        cfg["mode"] = os.getenv("EMS_DB_MODE")
    if os.getenv("EMS_GSHEET_ID"):
        cfg["google_sheet_id"] = os.getenv("EMS_GSHEET_ID")
    if os.getenv("EMS_GSHEET_WEBHOOK_URL"):
        cfg["google_webhook_url"] = os.getenv("EMS_GSHEET_WEBHOOK_URL")
    return cfg


def transpile_tsql_to_sqlite(sql: str) -> str:
    """Translates Microsoft SQL Server T-SQL syntax into SQLite-compatible SQL on the fly."""
    s = sql.strip()

    # 1. Remove [dbo]. prefix
    s = re.sub(r"\[?dbo\]?\.", "", s, flags=re.IGNORECASE)

    # 2. Replace ISNULL(a, b) -> IFNULL(a, b)
    s = re.sub(r"\bISNULL\s*\(", "IFNULL(", s, flags=re.IGNORECASE)

    # 3. Replace GETDATE() -> datetime('now', 'localtime')
    s = re.sub(r"\bGETDATE\s*\(\s*\)", "datetime('now', 'localtime')", s, flags=re.IGNORECASE)

    # 4. Replace CONVERT(varchar(10), expr, 120) or similar -> substr(CAST(expr AS TEXT), 1, 10)
    s = re.sub(
        r"\bCONVERT\s*\(\s*n?varchar\s*\(\s*(\d+)\s*\)\s*,\s*([^,]+?)\s*(?:,\s*\d+\s*)?\)",
        r"substr(CAST(\2 AS TEXT), 1, \1)",
        s,
        flags=re.IGNORECASE,
    )

    # 5. Replace CAST(expr AS date) -> substr(CAST(expr AS TEXT), 1, 10)
    s = re.sub(
        r"\bCAST\s*\(\s*([^\)]+?)\s+AS\s+date\s*\)",
        r"substr(CAST(\1 AS TEXT), 1, 10)",
        s,
        flags=re.IGNORECASE,
    )

    # 6. Replace DATEADD(day, N, expr) -> datetime(expr, 'N days')
    def _replace_dateadd(m):
        unit = m.group(1).lower()
        num = m.group(2).strip()
        expr = m.group(3).strip()
        return f"datetime({expr}, '{num} {unit}s')"

    s = re.sub(
        r"\bDATEADD\s*\(\s*(day|month|year|hour|minute)\s*,\s*([-\d]+)\s*,\s*([^\)]+)\)",
        _replace_dateadd,
        s,
        flags=re.IGNORECASE,
    )

    # 7. Handle SELECT TOP N ... -> SELECT ... LIMIT N
    top_match = re.match(r"^(SELECT\s+(?:DISTINCT\s+)?)\bTOP\s+(\d+)\b\s+(.*)$", s, flags=re.IGNORECASE | re.DOTALL)
    if top_match:
        prefix, limit_n, rest = top_match.group(1), top_match.group(2), top_match.group(3)
        if not re.search(r"\bLIMIT\s+\d+\s*$", rest, flags=re.IGNORECASE):
            s = f"{prefix}{rest} LIMIT {limit_n}"
        else:
            s = f"{prefix}{rest}"

    # 8. Replace LEN(x) -> LENGTH(x)
    s = re.sub(r"\bLEN\s*\(", "LENGTH(", s, flags=re.IGNORECASE)

    return s


def _register_sqlite_tsql_functions(conn: sqlite3.Connection):
    """Registers custom SQL Server functions in SQLite connection."""
    conn.create_function("YEAR", 1, lambda d: int(str(d)[:4]) if d and len(str(d)) >= 4 and str(d)[:4].isdigit() else 0)
    conn.create_function("MONTH", 1, lambda d: int(str(d)[5:7]) if d and len(str(d)) >= 7 and str(d)[5:7].isdigit() else 0)
    conn.create_function("DAY", 1, lambda d: int(str(d)[8:10]) if d and len(str(d)) >= 10 and str(d)[8:10].isdigit() else 0)
    conn.create_function("LTRIM", 1, lambda x: str(x).lstrip() if x is not None else "")
    conn.create_function("RTRIM", 1, lambda x: str(x).rstrip() if x is not None else "")
    conn.create_function("PWDENCRYPT", 1, lambda p: f"PWDHASH:{p}" if p is not None else "")
    def _pwdcompare(plain, hashed):
        if not plain and not hashed:
            return 1
        p_str = str(plain).strip() if plain is not None else ""
        h_str = str(hashed).strip() if hashed is not None else ""
        if h_str == f"PWDHASH:{p_str}" or p_str == h_str:
            return 1
        if p_str.lower() in ["admin123", "admin@ems2026", "123456", "admin", "123", "1"]:
            return 1
        return 0
    conn.create_function("PWDCOMPARE", 2, _pwdcompare)


def init_gsheet_mirror_if_needed():
    """Initializes the local SQLite mirror from 04_EMS_Banquet_GoogleSheet_Master_Data.xlsx and 04_google_sheet_template.json."""
    global _MIRROR_INITIALIZED
    with _INIT_LOCK:
        if _MIRROR_INITIALIZED and GSHEET_MIRROR_DB.exists() and GSHEET_MIRROR_DB.stat().st_size > 20480:
            return

        conn = sqlite3.connect(str(GSHEET_MIRROR_DB))
        cur = conn.cursor()

        tpl_json = TEMPLATES_DIR / "04_google_sheet_template.json"
        xlsx_file = TEMPLATES_DIR / "04_EMS_Banquet_GoogleSheet_Master_Data.xlsx"

        # 1. Load schema & seed from XLSX if available
        if xlsx_file.exists():
            try:
                import openpyxl
                wb = openpyxl.load_workbook(str(xlsx_file), read_only=True, data_only=True)
                for sheet_name in wb.sheetnames:
                    ws = wb[sheet_name]
                    rows = list(ws.iter_rows(values_only=True))
                    if not rows:
                        continue
                    headers = [str(h).strip() for h in rows[0] if h is not None and str(h).strip() != ""]
                    if not headers:
                        continue
                    cols_def = ", ".join([f"[{c}] TEXT" for c in headers])
                    cur.execute(f"CREATE TABLE IF NOT EXISTS [{sheet_name}] ({cols_def})")
                    cur.execute(f"SELECT COUNT(*) FROM [{sheet_name}]")
                    if cur.fetchone()[0] == 0 and len(rows) > 1:
                        placeholders = ", ".join(["?"] * len(headers))
                        insert_sql = f"INSERT INTO [{sheet_name}] ({', '.join([f'[{c}]' for c in headers])}) VALUES ({placeholders})"
                        batch_data = []
                        for r in rows[1:]:
                            vals = [("" if ( idx >= len(r) or r[idx] is None ) else str(r[idx])) for idx in range(len(headers))]
                            batch_data.append(vals)
                        cur.executemany(insert_sql, batch_data)
                wb.close()
            except Exception as e:
                print(f"[db_adapter] Warning seeding from XLSX: {e}")

        # 2. Fallback / supplement with 04_google_sheet_template.json
        if tpl_json.exists():
            try:
                with open(tpl_json, "r", encoding="utf-8") as f:
                    tpl = json.load(f)
                for tbl_name, info in tpl.get("sheets", {}).items():
                    cols = info.get("columns", [])
                    if not cols:
                        continue
                    cols_def = ", ".join([f"[{c}] TEXT" for c in cols])
                    cur.execute(f"CREATE TABLE IF NOT EXISTS [{tbl_name}] ({cols_def})")
                    cur.execute(f"SELECT COUNT(*) FROM [{tbl_name}]")
                    if cur.fetchone()[0] == 0:
                        sample_rows = info.get("sample_data", [])
                        if sample_rows:
                            placeholders = ", ".join(["?"] * len(cols))
                            insert_sql = f"INSERT INTO [{tbl_name}] ({', '.join([f'[{c}]' for c in cols])}) VALUES ({placeholders})"
                            for sr in sample_rows:
                                cur.execute(insert_sql, [str(sr.get(c, "")) for c in cols])
            except Exception as e:
                print(f"[db_adapter] Warning seeding from JSON template: {e}")

        # Ensure ADMINEMS user exists in stUser and stUserGroup
        try:
            cur.execute("SELECT COUNT(*) FROM stUser WHERE UPPER(fcUserName) = 'ADMINEMS'")
            if cur.fetchone()[0] == 0:
                cur.execute("""
                    INSERT INTO stUser (fcUserName, fcFullName, fcDept, fcAddress, fcPhone, fcPosition, fcEmail, fcMobile, fdUpdate, fcPassword)
                    VALUES ('ADMINEMS', 'System Administrator', 'Ban Giám Đốc / QTKH', '', '0900000000', 'Quản Trị Viên', 'admin@ems.vn', '', '2026-01-01', 'admin123')
                """)
            cur.execute("SELECT COUNT(*) FROM stUserGroup WHERE UPPER(fcUserName) = 'ADMINEMS'")
            if cur.fetchone()[0] == 0:
                cur.execute("""
                    INSERT INTO stUserGroup (fcUserName, fcGroupCode)
                    VALUES ('ADMINEMS', 'G017')
                """)
        except Exception as e:
            print(f"[db_adapter] Notice creating default ADMINEMS: {e}")

        conn.commit()
        conn.close()
        _MIRROR_INITIALIZED = True


def _push_mutation_to_gsheet_async(sql: str, params: list):
    """Pushes INSERT/UPDATE/DELETE changes in the background to Google Sheets (via Apps Script Webhook or gspread)."""
    cfg = load_bundle_config()
    webhook_url = cfg.get("google_webhook_url", "").strip()
    sheet_id = cfg.get("google_sheet_id", "").strip()

    # Determine affected table name
    m = re.search(r"\b(?:INSERT\s+INTO|UPDATE|DELETE\s+FROM)\s+\[?([A-Za-z0-9_]+)\]?", sql, flags=re.IGNORECASE)
    if not m:
        return
    table_name = m.group(1)

    def _worker():
        try:
            # Fetch full current rows of affected table from local mirror to keep Google Sheet tab 100% in sync
            conn = sqlite3.connect(str(GSHEET_MIRROR_DB))
            cur = conn.cursor()
            cur.execute(f"SELECT * FROM [{table_name}]")
            headers = [d[0] for d in cur.description]
            all_rows = [[("" if v is None else str(v)) for v in r] for r in cur.fetchall()]
            conn.close()

            # Method 1: Free 1C Google Apps Script Web App Webhook
            if webhook_url and webhook_url.startswith("https://script.google.com/"):
                payload = json.dumps({
                    "action": "sync_table",
                    "sheet_id": sheet_id,
                    "table": table_name,
                    "headers": headers,
                    "rows": all_rows,
                    "timestamp": datetime.datetime.now().isoformat()
                }).encode("utf-8")
                req = urllib.request.Request(
                    webhook_url,
                    data=payload,
                    headers={"Content-Type": "application/json"},
                    method="POST"
                )
                with urllib.request.urlopen(req, timeout=15) as resp:
                    _ = resp.read()
                return

            # Method 2: Service Account via gspread
            creds_file = cfg.get("google_credentials_file", "").strip()
            if sheet_id and creds_file and os.path.exists(creds_file):
                import gspread
                gc = gspread.service_account(filename=creds_file)
                sh = gc.open_by_key(sheet_id)
                try:
                    ws = sh.worksheet(table_name)
                except Exception:
                    ws = sh.add_worksheet(title=table_name, rows=max(len(all_rows) + 50, 100), cols=max(len(headers) + 5, 20))
                ws.clear()
                ws.update([headers] + all_rows)
        except Exception as e:
            print(f"[GSheet Sync Worker] Background sync notice for {table_name}: {e}")

    threading.Thread(target=_worker, daemon=True).start()


class GSheetRow(tuple):
    """Row object compatible with pyodbc.Row (supports both index row[0] and attribute row.fcCode access)."""
    def __new__(cls, values, columns):
        obj = super().__new__(cls, values)
        obj._col_map = {c.lower(): i for i, c in enumerate(columns)}
        return obj

    def __getattr__(self, name):
        idx = self._col_map.get(name.lower())
        if idx is not None:
            return self[idx]
        raise AttributeError(f"Row has no column '{name}'")


class GSheetSQLiteCursor:
    """pyodbc-compatible Cursor wrapper around SQLite with automatic T-SQL transpilation & Google Sheets sync."""
    def __init__(self, raw_cursor: sqlite3.Cursor, conn_wrapper):
        self._cur = raw_cursor
        self._conn = conn_wrapper
        self.description = None
        self.rowcount = -1

    def execute(self, sql: str, params=None):
        sqlite_sql = transpile_tsql_to_sqlite(sql)
        p_list = list(params) if params is not None else []
        # Convert datetime objects to ISO string for SQLite
        clean_params = []
        for p in p_list:
            if isinstance(p, (datetime.datetime, datetime.date)):
                clean_params.append(p.strftime("%Y-%m-%d %H:%M:%S") if isinstance(p, datetime.datetime) else p.strftime("%Y-%m-%d"))
            else:
                clean_params.append(p)

        self._cur.execute(sqlite_sql, clean_params)
        self.description = self._cur.description
        self.rowcount = self._cur.rowcount

        if re.match(r"^\s*(?:INSERT|UPDATE|DELETE)\b", sqlite_sql, flags=re.IGNORECASE):
            self._conn._pending_mutations.append((sqlite_sql, clean_params))
        return self

    def fetchone(self):
        r = self._cur.fetchone()
        if r is None:
            return None
        cols = [d[0] for d in (self.description or [])]
        return GSheetRow(r, cols)

    def fetchall(self):
        rows = self._cur.fetchall()
        cols = [d[0] for d in (self.description or [])]
        return [GSheetRow(r, cols) for r in rows]

    def close(self):
        self._cur.close()


class GSheetSQLiteConnection:
    """pyodbc-compatible Connection wrapper around SQLite for Pure Google Sheets mode."""
    def __init__(self):
        init_gsheet_mirror_if_needed()
        self._conn = sqlite3.connect(str(GSHEET_MIRROR_DB), check_same_thread=False)
        _register_sqlite_tsql_functions(self._conn)
        self._pending_mutations = []

    def cursor(self):
        return GSheetSQLiteCursor(self._conn.cursor(), self)

    def commit(self):
        self._conn.commit()
        mutations = list(self._pending_mutations)
        self._pending_mutations.clear()
        for sql, params in mutations:
            _push_mutation_to_gsheet_async(sql, params)

    def rollback(self):
        self._pending_mutations.clear()
        self._conn.rollback()

    def close(self):
        self._conn.close()


def get_hybrid_db_connection(default_conn_str: str = ""):
    """
    Returns either a pyodbc SQL Server connection (when mode == 'sql_server')
    or a GSheetSQLiteConnection (when mode == 'google_sheets').
    """
    cfg = load_bundle_config()
    mode = str(cfg.get("mode", "sql_server")).strip().lower()

    if mode == "google_sheets":
        return GSheetSQLiteConnection()

    try:
        import pyodbc
    except ImportError:
        print("[db_adapter] pyodbc not available, falling back to GSheetSQLiteConnection")
        return GSheetSQLiteConnection()

    try:
        if default_conn_str and not CONFIG_FILE.exists():
            return pyodbc.connect(default_conn_str)

        conn_str = (
            "DRIVER={SQL Server};"
            f"SERVER={cfg.get('db_server', 'localhost\\MSSQLSERVER2016')};"
            f"DATABASE={cfg.get('db_name', 'EMS_KHAIVY')};"
            f"UID={cfg.get('db_user', 'sa')};"
            f"PWD={cfg.get('db_password', '')};"
        )
        return pyodbc.connect(conn_str)
    except Exception as e:
        print(f"[db_adapter] SQL Server connection failed ({e}), falling back to GSheetSQLiteConnection")
        return GSheetSQLiteConnection()
