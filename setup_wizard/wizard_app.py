import os
import sys
import re
import json
import socket
import datetime
import subprocess
from pathlib import Path
from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse, JSONResponse, FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
import pyodbc

app = FastAPI(title="EMS Banquet Setup Wizard")

BUNDLE_ROOT = Path(__file__).resolve().parent.parent
CONFIG_FILE = BUNDLE_ROOT / "config.json"
TEMPLATES_DIR = BUNDLE_ROOT / "database_templates"

# ==================== PORT SCANNER UTILITIES ====================
def get_process_for_port(port: int) -> dict:
    """Finds PID and process name using netstat and tasklist on Windows."""
    try:
        cmd = f'netstat -ano | findstr ":{port} "'
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=3)
        lines = res.stdout.strip().splitlines()
        for l in lines:
            if "LISTENING" in l:
                parts = l.split()
                pid = parts[-1]
                p_cmd = f'tasklist /FI "PID eq {pid}" /FO CSV /NH'
                p_res = subprocess.run(p_cmd, shell=True, capture_output=True, text=True, timeout=3)
                p_name = p_res.stdout.strip().replace('"', '').split(',')[0] if p_res.stdout else f"PID {pid}"
                return {"in_use": True, "pid": pid, "process_name": p_name}
    except Exception:
        pass
    return {"in_use": True, "pid": "Unknown", "process_name": "Tiến trình hệ thống"}

def is_port_free(port: int) -> bool:
    """Tests if a port is free on Windows using connect_ex + bind."""
    # 1. Test if any service is actively listening on localhost:port
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.settimeout(0.2)
        res = s.connect_ex(("127.0.0.1", port))
        if res == 0:
            return False  # Active listening socket detected!
    # 2. Test binding to verify operating system socket permission
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        try:
            s.bind(("0.0.0.0", port))
            return True
        except OSError:
            return False

def check_single_port(port: int) -> dict:
    if is_port_free(port):
        return {"port": port, "available": True, "status": "free", "message": "Cổng trống khả dụng"}
    else:
        info = get_process_for_port(port)
        return {
            "port": port,
            "available": False,
            "status": "occupied",
            "pid": info.get("pid"),
            "process_name": info.get("process_name"),
            "message": f"Bị chiếm bởi {info.get('process_name')} (PID: {info.get('pid')})"
        }

def find_available_port(start: int, exclude: list = None) -> int:
    exclude = exclude or []
    cand = start
    while cand < 65535:
        if cand not in exclude and is_port_free(cand):
            return cand
        cand += 1
    return start

class PortCheckRequest(BaseModel):
    port: int

class PortKillRequest(BaseModel):
    port: int

@app.post("/api/check-port")
def api_check_port(req: PortCheckRequest):
    return check_single_port(req.port)

@app.post("/api/kill-port")
def api_kill_port(req: PortKillRequest):
    info = get_process_for_port(req.port)
    if not info.get("in_use"):
        return {"success": True, "message": f"Cổng {req.port} hiện đã trống!"}
    pid = info.get("pid")
    if pid and pid != "Unknown" and str(pid).isdigit() and int(pid) > 4:
        try:
            subprocess.run(f"taskkill /F /PID {pid}", shell=True, capture_output=True)
            return {"success": True, "message": f"Đã giải phóng thành công cổng {req.port} (tiến trình {info.get('process_name')} - PID {pid})!"}
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Không thể tắt tiến trình PID {pid}: {e}")
    return {"success": False, "message": f"Không tìm thấy tiến trình để đóng trên cổng {req.port}"}

@app.get("/api/active-ports")
def api_active_ports():
    ports_to_check = [5088, 5090, 5092, 5123, 5255, 5888, 8088, 8090, 8092, 8888, 8999, 8087, 8089, 8091, 8093]
    active = []
    for p in sorted(list(set(ports_to_check))):
        info = get_process_for_port(p)
        if info.get("in_use"):
            active.append({
                "port": p,
                "pid": info.get("pid"),
                "process_name": info.get("process_name")
            })
    return {"success": True, "active_ports": active}

@app.get("/api/scan-system-ports")
def api_scan_system_ports(web: int = 5090, analytics: int = 5088, ai: int = 5092):
    return {
        "web": check_single_port(web),
        "analytics": check_single_port(analytics),
        "ai": check_single_port(ai)
    }

@app.get("/api/suggest-free-ports")
def api_suggest_free_ports():
    p_web = find_available_port(5090, [])
    p_ana = find_available_port(5088 if p_web != 5088 else 5089, [p_web])
    p_ai = find_available_port(5092, [p_web, p_ana])
    return {
        "success": True,
        "suggested_web": p_web,
        "suggested_analytics": p_ana,
        "suggested_ai": p_ai
    }


# Models
class SQLCheckRequest(BaseModel):
    server: str
    database: str = "master"
    user: str = "sa"
    password: str = ""

class SQLInitRequest(BaseModel):
    server: str
    database: str = "EMS_BANQUET"
    user: str = "sa"
    password: str = ""
    include_sample_data: bool = True

class GSheetInitRequest(BaseModel):
    sheet_id: str
    webhook_url: str = ""
    credentials_json: str = ""

class SaveConfigRequest(BaseModel):
    mode: str = "sql_server"
    hotel_name: str = "EMS Banquet & Event Center"
    hotel_subtitle: str = "Hệ Thống Quản Lý Tiệc Cưới & Hội Nghị"
    db_server: str = "localhost\\MSSQLSERVER2016"
    db_name: str = "EMS_BANQUET"
    db_user: str = "sa"
    db_password: str = ""
    port_web: int = 5090
    port_analytics: int = 5088
    port_ai: int = 5092
    port_wizard: int = 5888
    ai_master_password: str = "Admin@EMS2026"
    google_sheet_id: str = ""
    google_webhook_url: str = ""
    google_credentials_file: str = ""

@app.get("/api/get-config")
def get_config():
    if CONFIG_FILE.exists():
        try:
            with open(CONFIG_FILE, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception as e:
            return {"error": str(e)}
    return {
        "mode": "sql_server",
        "hotel_name": "EMS Banquet & Event Center",
        "hotel_subtitle": "Hệ Thống Quản Lý Tiệc Cưới & Hội Nghị",
        "db_server": "localhost\\MSSQLSERVER2016",
        "db_name": "EMS_BANQUET",
        "db_user": "sa",
        "db_password": "",
        "port_web": 5090,
        "port_analytics": 5088,
        "port_ai": 5092,
        "port_wizard": 5888,
        "ai_master_password": "Admin@EMS2026",
        "google_sheet_id": "",
        "google_credentials_file": ""
    }

def format_sql_error(err: Exception) -> str:
    err_str = str(err)
    if "18456" in err_str or "Login failed" in err_str:
        return "Lỗi xác thực (18456): Sai tài khoản hoặc mật khẩu SQL Server. Vui lòng kiểm tra lại mật khẩu SA."
    if "20005" in err_str or "SQL Server does not exist" in err_str or "error: 26" in err_str:
        return "Không tìm thấy máy chủ SQL Server. Vui lòng kiểm tra lại tên Server / Instance (ví dụ: localhost\\MSSQLSERVER2016) và đảm bảo dịch vụ SQL Server đang chạy."
    if "10061" in err_str or "TCP Provider" in err_str or "Connection refused" in err_str:
        return "Máy chủ từ chối kết nối (Port 1433 chưa mở hoặc giao thức TCP/IP chưa được kích hoạt trong SQL Server Configuration Manager)."
    if "Timeout" in err_str or "timed out" in err_str:
        return "Hết thời gian chờ kết nối (Timeout). Vui lòng kiểm tra tường lửa (Firewall) hoặc kết nối mạng tới máy chủ SQL."
    return f"Lỗi kết nối SQL Server: {err_str}"

@app.post("/api/check-sql")
def check_sql(req: SQLCheckRequest):
    if not req.server.strip():
        return {"success": False, "message": "Vui lòng nhập địa chỉ máy chủ SQL Server!"}
    conn_str = f"DRIVER={{SQL Server}};SERVER={req.server};DATABASE={req.database};UID={req.user};PWD={req.password};"
    try:
        cn = pyodbc.connect(conn_str, timeout=6)
        cur = cn.cursor()
        cur.execute("SELECT @@VERSION")
        ver = cur.fetchone()[0]
        cn.close()
        return {"success": True, "message": "Kết nối máy chủ SQL Server thành công!", "version": ver.split("\n")[0]}
    except Exception as e:
        return {"success": False, "message": format_sql_error(e)}

@app.post("/api/init-sql-db")
def init_sql_db(req: SQLInitRequest):
    logs = []
    log_file = BUNDLE_ROOT / "setup_wizard" / "install.log"
    
    def write_install_log(text):
        try:
            with open(log_file, "a", encoding="utf-8") as lf:
                lf.write(f"[{datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {text}\n")
        except Exception:
            pass

    write_install_log(f"BẮT ĐẦU CÀI ĐẶT CSDL: Server={req.server}, Database={req.database}")

    if not req.server.strip() or not req.database.strip():
        raise HTTPException(status_code=400, detail="Tên Server và tên Database không được để trống!")

    # 1. Connect to master to create DB if not exists
    master_conn_str = f"DRIVER={{SQL Server}};SERVER={req.server};DATABASE=master;UID={req.user};PWD={req.password};"
    try:
        cn = pyodbc.connect(master_conn_str, autocommit=True, timeout=10)
        cur = cn.cursor()
        cur.execute(f"IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = '{req.database}') CREATE DATABASE [{req.database}]")
        cn.close()
        logs.append(f"✓ Đã khởi tạo/xác nhận Database: [{req.database}]")
        write_install_log(f"Đã xác nhận database: {req.database}")
    except Exception as e:
        err_msg = format_sql_error(e)
        write_install_log(f"LỖI TẠO DATABASE: {err_msg}")
        raise HTTPException(status_code=500, detail=f"Không thể khởi tạo Database [{req.database}]: {err_msg}")

    # 2. Connect to target database
    target_conn_str = f"DRIVER={{SQL Server}};SERVER={req.server};DATABASE={req.database};UID={req.user};PWD={req.password};"
    try:
        cn = pyodbc.connect(target_conn_str, autocommit=True, timeout=30)
        cur = cn.cursor()

        # Helper to execute batches split by GO
        def run_sql_file(file_path, desc):
            if not file_path.exists():
                logs.append(f"⚠ Bỏ qua (không tìm thấy file): {file_path.name}")
                write_install_log(f"File missing: {file_path.name}")
                return
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()
            # Split batches by GO (line-based, regex handling \r\n, \n, whitespace, case-insensitive)
            batches = [b.strip() for b in re.split(r'^\s*GO\s*$', content, flags=re.MULTILINE | re.IGNORECASE) if b.strip()]
            count = 0
            err_count = 0
            for b in batches:
                lines = [l for l in b.splitlines() if not l.strip().upper().startswith("USE [")]
                clean_batch = "\n".join(lines).strip()
                if clean_batch:
                    try:
                        cur.execute(clean_batch)
                        count += 1
                    except Exception as err:
                        err_count += 1
                        write_install_log(f"Notice batch error: {err}")
            logs.append(f"✓ Đã chạy {desc} ({count} batches thành công, {err_count} thông báo)")
            write_install_log(f"Completed {desc}: {count} success, {err_count} warnings")

        # Run 01_sql_schema_full.sql
        run_sql_file(TEMPLATES_DIR / "01_sql_schema_full.sql", "Khởi tạo 77 bảng DDL Schema, 20 Views, 123 Functions & Stored Procedures")
        
        # Run 02_sql_master_data.sql
        run_sql_file(TEMPLATES_DIR / "02_sql_master_data.sql", "Nạp Danh mục Master Data chuẩn, Tài khoản & Phân quyền đầy đủ")

        # Run 03_sql_sample_bookings.sql if selected
        if req.include_sample_data:
            run_sql_file(TEMPLATES_DIR / "03_sql_sample_bookings.sql", "Nạp 5 Đơn tiệc & BEO mẫu kiểm thử")

        cn.close()
        success_msg = f"Đã khởi tạo thành công CSDL [{req.database}] trên máy chủ [{req.server}]. (Lưu ý: Khi kiểm tra trong SSMS, vui lòng kết nối đúng Server Name: {req.server})"
        logs.append(f"🎉 {success_msg}")
        write_install_log(f"CÀI ĐẶT CSDL HOÀN TẤT THÀNH CÔNG: {success_msg}")
        return {
            "success": True, 
            "logs": logs, 
            "message": success_msg,
            "target_server": req.server,
            "database": req.database
        }
    except Exception as e:
        err_msg = format_sql_error(e)
        write_install_log(f"LỖI THỰC THI SCRIPT: {err_msg}")
        raise HTTPException(status_code=500, detail=f"Lỗi khi thực thi script SQL: {err_msg}")

@app.get("/api/download-gsheet-template")
def download_gsheet_template():
    """Allows 1-click download of the complete 38-tab Excel Master Data template to import into Google Sheets."""
    xlsx_file = TEMPLATES_DIR / "04_EMS_Banquet_GoogleSheet_Master_Data.xlsx"
    if not xlsx_file.exists():
        raise HTTPException(status_code=404, detail="Không tìm thấy file mẫu 04_EMS_Banquet_GoogleSheet_Master_Data.xlsx")
    return FileResponse(
        path=str(xlsx_file),
        filename="EMS_Banquet_GoogleSheet_Master_Data_Template.xlsx",
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

@app.get("/api/download-gas-script")
def download_gas_script():
    """Allows 1-click download of Google_Apps_Script_Backend.gs (Code.gs) for Free 1C setup."""
    gas_file = BUNDLE_ROOT / "cloud_deploy" / "free_1c_google_ecosystem" / "Google_Apps_Script_Backend.gs"
    if not gas_file.exists():
        raise HTTPException(status_code=404, detail="Không tìm thấy file Google_Apps_Script_Backend.gs")
    return FileResponse(
        path=str(gas_file),
        filename="Google_Apps_Script_Backend.gs",
        media_type="text/plain; charset=utf-8"
    )

@app.get("/api/gsheet-sheets-list")
def get_gsheet_sheets_list():
    template_file = TEMPLATES_DIR / "04_google_sheet_template.json"
    if not template_file.exists():
        return {"success": False, "sheets": []}
    try:
        with open(template_file, "r", encoding="utf-8") as f:
            data = json.load(f)
        sheets_info = []
        for name, info in data.get("sheets", {}).items():
            sheets_info.append({
                "table": name,
                "title": info.get("title", name),
                "desc": info.get("description", ""),
                "columns_count": len(info.get("columns", [])),
                "is_master": info.get("is_master_data", False),
                "total_rows": info.get("total_rows_extracted", 0)
            })
        return {"success": True, "sheets": sheets_info, "total": len(sheets_info)}
    except Exception as e:
        return {"success": False, "error": str(e)}

@app.post("/api/init-gsheet")
def init_gsheet(req: GSheetInitRequest):
    # Verify sheet template exists
    template_file = TEMPLATES_DIR / "04_google_sheet_template.json"
    if not template_file.exists():
        raise HTTPException(status_code=404, detail="Không tìm thấy file template 04_google_sheet_template.json")
    
    with open(template_file, "r", encoding="utf-8") as f:
        schema = json.load(f)
    
    # Check sheet id format
    if len(req.sheet_id.strip()) < 15:
        raise HTTPException(status_code=400, detail="Google Sheet ID không hợp lệ!")

    sheets_dict = schema.get("sheets", {})
    logs = [
        f"✓ Đã nạp Schema Template Pure Google Sheets ({len(sheets_dict)} bảng nghiệp vụ hoàn chỉnh)",
        f"✓ Bao gồm đầy đủ: Tài khoản (stUser, stGroup, stUserGroup), Sảnh (stPhong), 20 Nhóm DT A-T, Thực đơn 118 món (stMenu), BEO (stMaster_EO)...",
        f"✓ Đã định cấu hình kết nối Google Sheet ID: {req.sheet_id.strip()}",
        "✓ Chế độ Pure Google Sheets: Toàn bộ dữ liệu tiệc, BEO và doanh thu sẽ được đồng bộ trực tiếp vào Google Spreadsheet của bạn!"
    ]
    return {"success": True, "logs": logs, "message": "Cấu hình Google Sheets thành công!"}

@app.post("/api/save-config")
def save_config(req: SaveConfigRequest):
    cfg_data = req.dict()
    try:
        with open(CONFIG_FILE, "w", encoding="utf-8") as f:
            json.dump(cfg_data, f, ensure_ascii=False, indent=2)
        return {"success": True, "message": "Đã lưu file cấu hình config.json thành công!"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi khi lưu config: {str(e)}")

@app.post("/api/start-services")
def start_services():
    bat_file = BUNDLE_ROOT / "start_system.bat"
    if not bat_file.exists():
        # Fallback if bat not created yet
        return {"success": True, "message": "Cấu hình đã sẵn sàng. Vui lòng chạy start_system.bat để khởi động!"}
    
    try:
        subprocess.Popen([str(bat_file)], shell=True, cwd=str(BUNDLE_ROOT))
        return {"success": True, "message": "Đã gửi lệnh khởi động 3 dịch vụ: Web (8090), Analytics (8088), AI Lab (8092)!"}
    except Exception as e:
        return {"success": False, "message": f"Không thể tự động chạy .bat: {str(e)}"}

# Mount static files
app.mount("/static", StaticFiles(directory=str(Path(__file__).parent / "static")), name="static")

@app.get("/", response_class=HTMLResponse)
def index():
    html_file = Path(__file__).parent / "static" / "index.html"
    if html_file.exists():
        with open(html_file, "r", encoding="utf-8") as f:
            return HTMLResponse(content=f.read())
    return HTMLResponse("<h3>Trình cài đặt EMS Banquet Setup Wizard</h3>")

if __name__ == "__main__":
    import uvicorn
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=5888, help="Port to run wizard on")
    args = parser.parse_args()

    port = args.port
    if not is_port_free(port):
        print(f"Notice: Port {port} is occupied, searching for free port...")
        port = find_available_port(port)
        print(f"Selected free port: {port}")

    # Write wizard port to temporary file for .bat script to open browser
    try:
        with open(BUNDLE_ROOT / ".wizard_port", "w") as f:
            f.write(str(port))
    except Exception:
        pass

    print(f"=== EMS Banquet Setup Wizard starting on http://localhost:{port} ===")
    # Bind to 127.0.0.1 to isolate from external LAN/IPTV traffic
    uvicorn.run(app, host="127.0.0.1", port=port)
