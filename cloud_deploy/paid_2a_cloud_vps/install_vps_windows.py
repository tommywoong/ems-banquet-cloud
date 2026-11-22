# -*- coding: utf-8 -*-
"""
EMS Banquet Cloud - Cloud VPS Windows 1-Click Installer (Paid 2A)
Tự động cấu hình tường lửa, dịch vụ Windows 24/7 và kích hoạt hệ thống.
"""
import os
import sys
import ctypes
import subprocess
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
BUNDLE_DIR = SCRIPT_DIR.parent.parent

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin() != 0
    except Exception:
        return False

def print_banner():
    print("=" * 72)
    print("  🖥️  [PAID 2A] CÀI ĐẶT TỰ ĐỘNG EMS BANQUET TRÊN CLOUD VPS WINDOWS (24/7)")
    print("  Hệ thống vận hành doanh nghiệp 24/7 trên VPS Viettel / FPT / AZDIGI / Vultr")
    print("=" * 72)
    print()

def run_installer():
    print_banner()

    if not is_admin():
        print("❌ LỖI: CẦN QUYỀN ADMINISTRATOR ĐỂ CÀI ĐẶT DỊCH VỤ WINDOWS.")
        print("-" * 72)
        print("Vui lòng nhấp chuột phải vào file:")
        print("👉 'install_vps_windows_1click.bat' -> Chọn 'Run as administrator'")
        print("-" * 72)
        input("Bấm ENTER để đóng..."); sys.exit(1)

    print("[1/4] Đang cấu hình Windows Firewall mở các cổng kết nối (5090, 5088, 5092, 5888)...")
    try:
        subprocess.run(["netsh", "advfirewall", "firewall", "delete", "rule", "name=EMS_Banquet_Cloud_Ports"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        subprocess.run([
            "netsh", "advfirewall", "firewall", "add", "rule",
            "name=EMS_Banquet_Cloud_Ports", "dir=in", "action=allow",
            "protocol=TCP", "localport=5088,5090,5092,5888,8088,8090,8092"
        ], stdout=subprocess.DEVNULL, check=True)
        print("  -> Mở cổng Firewall thành công!")
    except Exception as e:
        print(f"  -> Cảnh báo cấu hình Firewall: {e}")

    print()
    print("[2/4] Đang đăng ký 3 dịch vụ Windows Services chạy ngầm vĩnh viễn qua NSSM...")
    install_bat = BUNDLE_DIR / "install_windows_services.bat"
    if install_bat.exists():
        subprocess.run([str(install_bat)], cwd=str(BUNDLE_DIR))

    print()
    print("[3/4] Kiểm tra trạng thái hoạt động của các dịch vụ...")
    for svc in ["EMS_Banquet_Web", "EMS_Banquet_Analytics", "EMS_Banquet_AI"]:
        res = subprocess.run(["sc", "query", svc], capture_output=True, text=True)
        if "RUNNING" in res.stdout:
            print(f"  - {svc}: ĐANG CHẠY (RUNNING) ✅")
        else:
            print(f"  - {svc}: KHỞI TẠO (STARTING / STOPPED) ⏳")

    print()
    print("[4/4] Đang mở trình cấu hình trực quan Setup Wizard...")
    import webbrowser
    webbrowser.open("http://127.0.0.1:5888")

    print()
    print("=" * 72)
    print("🎉 [HOÀN TẤT] Cài đặt trên Cloud VPS Windows thành công!")
    print("Trình duyệt đã mở trang Setup Wizard tại: http://127.0.0.1:5888")
    print("Bạn có thể chọn chế độ Google Sheets (miễn phí) hoặc SQL Server (nội bộ).")
    print("Để gắn Tên Miền Riêng HTTPS (VD: https://ems.tenkhachsan.vn), hãy chạy tiếp:")
    print("👉 'setup_cloudflare_https_tunnel.bat'")
    print("=" * 72)
    input("Bấm ENTER để kết thúc...")

if __name__ == "__main__":
    try:
        run_installer()
    except Exception as e:
        print(f"\nLỗi phát sinh: {e}")
        input("Bấm ENTER để đóng...")
