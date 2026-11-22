# -*- coding: utf-8 -*-
"""
EMS Banquet Cloud - Cloudflare HTTPS Tunnel Setup Engine (Paid 2A)
Kết nối Cloudflare Zero Trust Tunnel để cấp chứng chỉ SSL HTTPS miễn phí cho tên miền riêng.
"""
import os
import sys
import ctypes
import shutil
import subprocess
import urllib.request
from pathlib import Path

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin() != 0
    except Exception:
        return False

def print_banner():
    print("=" * 72)
    print("  🔒 [PAID 2A] KẾT NỐI TÊN MIỀN RIÊNG HTTPS BẢO MẬT QUA CLOUDFLARE TUNNEL")
    print("  Tự động cấp SSL HTTPS miễn phí, chống DDoS, ẩn IP VPS, không cần mở port")
    print("=" * 72)
    print()

def run_tunnel_setup():
    print_banner()

    if not is_admin():
        print("❌ LỖI: CẦN QUYỀN ADMINISTRATOR ĐỂ CÀI ĐẶT DỊCH VỤ CLOUDFLARED.")
        print("-" * 72)
        print("Vui lòng nhấp chuột phải vào file:")
        print("👉 'setup_cloudflare_https_tunnel.bat' -> Chọn 'Run as administrator'")
        print("-" * 72)
        input("Bấm ENTER để đóng..."); sys.exit(1)

    # 1. Kiểm tra / tải cloudflared
    cloudflared_path = shutil.which("cloudflared")
    if not cloudflared_path:
        print("[*] Đang tải công cụ cloudflared chính thức từ Cloudflare...")
        msi_url = "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.msi"
        temp_msi = Path(os.environ.get("TEMP", "C:\\Temp")) / "cloudflared.msi"
        try:
            urllib.request.urlretrieve(msi_url, temp_msi)
            print("[*] Đang cài đặt cloudflared chạy ngầm trên Windows...")
            subprocess.run(["msiexec", "/i", str(temp_msi), "/quiet"], check=True)
            os.environ["PATH"] += ";C:\\Program Files (x86)\\cloudflared;C:\\Program Files\\cloudflared"
            print("  -> Cài đặt cloudflared thành công!")
        except Exception as e:
            print(f"❌ Lỗi cài đặt cloudflared: {e}")
            input("Bấm ENTER để đóng..."); return

    print()
    print("HƯỚNG DẪN LẤY TOKEN TRÊN CLOUDFLARE ZERO TRUST DASHBOARD:")
    print("1. Truy cập https://one.dash.cloudflare.com -> Chọn 'Networks' -> 'Tunnels'")
    print("2. Bấm 'Create a Tunnel' -> Đặt tên: EMS-Banquet-VPS -> Bấm 'Save tunnel'")
    print("3. Chọn hệ điều hành: 'Windows' -> Nhìn xuống ô lệnh 'Install and run a connector'")
    print("4. Sao chép đoạn mã Token (chuỗi ký tự dài nằm sau chữ 'service install ...')")
    print("-" * 72)
    token = input("Dán Cloudflare Tunnel Token của bạn vào đây: ").strip()

    if not token:
        print("❌ Bạn chưa nhập Token.")
        input("Bấm ENTER để đóng..."); return

    # Nếu người dùng copy cả câu lệnh, tự động trích xuất token
    if "service install" in token:
        token = token.split("service install")[-1].strip()

    print()
    print("[*] Đang cài đặt dịch vụ Cloudflare Tunnel chạy ngầm 24/7...")
    try:
        subprocess.run(["cloudflared", "service", "install", token], check=True)
        subprocess.run(["net", "start", "cloudflared"], check=False)
        print()
        print("=" * 72)
        print("🎉 [HOÀN TẤT] Đã kết nối Cloudflare HTTPS Tunnel thành công!")
        print("Trạng thái trên trang Cloudflare Dashboard sẽ chuyển sang 'HEALTHY' (Màu xanh).")
        print()
        print("BƯỚC TIẾP THEO: Trên Cloudflare Dashboard (Mục Public Hostname), hãy thêm 2 đường dẫn:")
        print("1. Subdomain: ems            -> Type: HTTP | URL: localhost:5090")
        print("2. Subdomain: analytics      -> Type: HTTP | URL: localhost:5088")
        print()
        print("👉 Bây giờ bạn có thể truy cập hệ thống bằng tên miền riêng HTTPS an toàn tuyệt đối:")
        print("   🌐 https://ems.tenkhachsan.vn")
        print("   🌐 https://analytics.tenkhachsan.vn")
        print("=" * 72)
    except Exception as e:
        print(f"❌ Lỗi khi khởi động dịch vụ: {e}")

    input("Bấm ENTER để kết thúc...")

if __name__ == "__main__":
    try:
        run_tunnel_setup()
    except Exception as e:
        print(f"\nLỗi phát sinh: {e}")
        input("Bấm ENTER để đóng...")
