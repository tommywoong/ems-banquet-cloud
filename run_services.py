import os
import sys
import json
import time
import socket
import subprocess
import webbrowser
from pathlib import Path

BUNDLE_ROOT = Path(__file__).resolve().parent
CONFIG_FILE = BUNDLE_ROOT / "config.json"

def check_port_listening(port: int, host: str = "127.0.0.1") -> bool:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.settimeout(0.3)
        return s.connect_ex((host, port)) == 0

def load_config():
    if CONFIG_FILE.exists():
        try:
            with open(CONFIG_FILE, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception as e:
            print(f"Warning reading config.json: {e}")
    return {}

def main():
    cfg = load_config()
    port_web = int(cfg.get("port_web", 5090))
    port_analytics = int(cfg.get("port_analytics", 5088))
    port_ai = int(cfg.get("port_ai", 5092))

    py_exe = sys.executable

    print("===============================================================================")
    print("         EMS BANQUET SYSTEM - KHOI DONG DICH VU HE THONG")
    print("         Khach san MerPerle / Khai Vy Hotel - Phien ban 2.1.0 Portable")
    print("===============================================================================\n")

    print(f"[1/3] Khoi dong EMS Banquet Web tren cong {port_web}...")
    web_proc = subprocess.Popen(
        [py_exe, "app.py"],
        cwd=str(BUNDLE_ROOT / "ems-web"),
        env={**os.environ, "PORT": str(port_web)}
    )

    print(f"[2/3] Khoi dong EMS Banquet Analytics tren cong {port_analytics}...")
    ana_proc = subprocess.Popen(
        [py_exe, "app.py"],
        cwd=str(BUNDLE_ROOT / "ems-analytics"),
        env={**os.environ, "PORT": str(port_analytics)}
    )

    print(f"[3/3] Khoi dong EMS AI Coding Agent tren cong {port_ai}...\n")
    ai_proc = subprocess.Popen(
        [py_exe, "app.py"],
        cwd=str(BUNDLE_ROOT / "ems-ai"),
        env={**os.environ, "PORT": str(port_ai)}
    )

    print("Dang kiem tra trang thai cac dich vu...")
    time.sleep(2.5)

    web_ok = check_port_listening(port_web)
    ana_ok = check_port_listening(port_analytics)
    ai_ok = check_port_listening(port_ai)

    print("\n===============================================================================")
    print("  HE THONG DA KHOI DONG XONG! TRANG THAI CAC PHAN HE:")
    print("===============================================================================")
    print(f"  1. EMS Banquet Web:       http://localhost:{port_web}  [{'ONLINE' if web_ok else 'DANG KHOI DONG'}]")
    print(f"  2. EMS Banquet Analytics: http://localhost:{port_analytics}  [{'ONLINE' if ana_ok else 'DANG KHOI DONG'}]")
    print(f"  3. EMS AI Coding Agent:   http://localhost:{port_ai}  [{'ONLINE' if ai_ok else 'DANG KHOI DONG'}]")
    print("===============================================================================\n")
    print("  Giu nguyen cua so nay de duy tri cac dich vu hoat dong.")
    print("  Nhan Ctrl+C de dung toan bo he thong.\n")

    # Open main browser
    webbrowser.open(f"http://localhost:{port_web}")

    try:
        # Keep alive
        while True:
            time.sleep(1)
            if web_proc.poll() is not None and ana_proc.poll() is not None:
                break
    except KeyboardInterrupt:
        print("\nDang dung cac tien trinh...")
        for p in [web_proc, ana_proc, ai_proc]:
            try:
                p.terminate()
            except Exception:
                pass
        print("Da dung toan bo he thong.")

if __name__ == "__main__":
    main()
