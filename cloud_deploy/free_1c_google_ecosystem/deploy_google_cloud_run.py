# -*- coding: utf-8 -*-
"""
EMS Banquet Cloud - Google Cloud Run Deployment Engine (Free 1C)
Tự động đóng gói & đẩy hệ thống lên Google Cloud Run kết nối với Google Sheets.
"""
import os
import sys
import shutil
import subprocess
import urllib.request
import json
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
BUNDLE_DIR = SCRIPT_DIR.parent.parent

def print_banner():
    print("=" * 72)
    print("  🚀 [FREE 1C] TRIỂN KHAI EMS BANQUET LÊN GOOGLE CLOUD RUN (0đ/THÁNG)")
    print("  Hệ thống chạy 24/7 trên hạ tầng Google Cloud + Cơ sở dữ liệu Google Sheets")
    print("=" * 72)
    print()

def check_gcloud():
    return shutil.which("gcloud") is not None

def test_webhook_url(url: str):
    """Kiểm tra xem link Webhook Google Apps Script đã thông với Google Sheet hay chưa."""
    if not url or not url.startswith("http"):
        return False, "Đường dẫn Webhook không hợp lệ (phải bắt đầu bằng https://script.google.com/...)"
    try:
        test_url = url + ("&action=status" if "?" in url else "?action=status")
        req = urllib.request.Request(test_url, headers={"User-Agent": "EMS-Banquet-Deployer/3.0"})
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            if data.get("success"):
                total_tabs = data.get("total_tabs", 0)
                sheet_name = data.get("spreadsheet_name", "Google Sheet")
                return True, f"Kết nối THÀNH CÔNG tới Google Sheet [{sheet_name}] (Đã nhận {total_tabs} tabs CSDL)!"
            else:
                return False, f"Google Sheet phản hồi lỗi: {data.get('error')}"
    except Exception as e:
        return False, f"Không thể kết nối Webhook: {e}"

def run_deployment():
    print_banner()

    # 1. Kiểm tra gcloud CLI
    if not check_gcloud():
        print("⚠️  MÁY TÍNH CỦA BẠN CHƯA CÀI ĐẶT CÔNG CỤ 'gcloud CLI'.")
        print("-" * 72)
        print("BẠN CÓ 2 CÁCH TRIỂN KHAI RẤT DỄ DÀNG:")
        print()
        print("👉 CÁCH 1 (KHUYÊN DÙNG - KHÔNG CẦN CÀI GÌ VÀO MÁY TÍNH):")
        print("   1. Mở trình duyệt truy cập Google Cloud Shell miễn phí tại:")
        print("      🌐 https://shell.cloud.google.com")
        print("   2. Kéo thả thư mục EMS_Banquet_Portable_Bundle lên cửa sổ Cloud Shell.")
        print("   3. Gõ lệnh: bash deploy.sh để hệ thống tự động đưa lên mạng trong 1 phút!")
        print()
        print("👉 CÁCH 2 (TRIỂN KHAI TỪ MÁY TÍNH):")
        print("   1. Tải và cài đặt Google Cloud SDK cho Windows tại:")
        print("      🌐 https://cloud.google.com/sdk/docs/install")
        print("   2. Mở CMD gõ: gcloud auth login để đăng nhập tài khoản Google của bạn.")
        print("   3. Sau đó nhấp đúp chạy lại file này.")
        print("-" * 72)
        input("Bấm phím ENTER để đóng cửa sổ...")
        return

    # 2. Thu thập thông tin cấu hình
    print("Vui lòng cung cấp 3 thông tin để triển khai:")
    print()
    gcp_project = input("1. Nhập Google Cloud Project ID của bạn (VD: ems-banquet-hotel): ").strip()
    if not gcp_project:
        print("❌ Lỗi: Bạn chưa nhập Project ID.")
        input("Bấm ENTER để thoát..."); return

    gsheet_id = input("2. Nhập Google Spreadsheet ID (đoạn mã giữa /d/ và /edit): ").strip()
    if not gsheet_id:
        print("❌ Lỗi: Bạn chưa nhập Spreadsheet ID.")
        input("Bấm ENTER để thoát..."); return

    print()
    print("Lưu ý về Webhook URL: Là link sau khi bạn Deploy Web App trong Google Apps Script:")
    print("Ví dụ: https://script.google.com/macros/s/AKfycb.../exec")
    gsheet_webhook = input("3. Nhập Google Apps Script Webhook URL: ").strip()

    # 3. Test ping Webhook trước khi deploy
    print()
    print("[*] Đang kiểm tra kết nối với Google Sheet của bạn...")
    ok, msg = test_webhook_url(gsheet_webhook)
    if ok:
        print(f"✅ {msg}")
    else:
        print(f"⚠️ Cảnh báo: {msg}")
        choice = input("Bạn có muốn tiếp tục triển khai không? (y/n): ").strip().lower()
        if choice != 'y':
            return

    # 4. Kích hoạt API cần thiết trên Google Cloud
    print()
    print(f"[*] Đang thiết lập Project [{gcp_project}]...")
    subprocess.run(["gcloud", "config", "set", "project", gcp_project], check=True)

    print()
    print("[*] Đang kích hoạt các dịch vụ Cloud Run API & Artifact Registry...")
    subprocess.run([
        "gcloud", "services", "enable",
        "run.googleapis.com",
        "artifactregistry.googleapis.com",
        "cloudbuild.googleapis.com"
    ], check=True)

    # 5. Triển khai Cloud Run
    print()
    print("[*] Đang đóng gói và đẩy hệ thống lên Google Cloud Run (asia-southeast1 - Singapore)...")
    cmd = [
        "gcloud", "run", "deploy", "ems-banquet-cloud",
        "--source", str(BUNDLE_DIR),
        "--region", "asia-southeast1",
        "--allow-unauthenticated",
        "--memory", "1Gi",
        "--cpu", "1",
        "--min-instances", "0",
        "--max-instances", "3",
        "--set-env-vars", f"EMS_DB_MODE=google_sheets,EMS_GSHEET_ID={gsheet_id},EMS_GSHEET_WEBHOOK_URL={gsheet_webhook}"
    ]

    res = subprocess.run(cmd)
    if res.returncode == 0:
        print()
        print("=" * 72)
        print("🎉 [HOÀN TẤT] HỆ THỐNG EMS BANQUET ĐÃ ĐƯỢC TRIỂN KHAI LÊN GOOGLE CLOUD THÀNH CÔNG!")
        print("Bạn có thể truy cập đường link Service URL hiển thị ở trên từ Điện thoại, iPad, Laptop")
        print("mọi lúc mọi nơi 24/7 mà không cần bật máy tính cá nhân!")
        print("=" * 72)
    else:
        print()
        print("❌ Có lỗi xảy ra trong quá trình deploy. Vui lòng kiểm tra lại thông báo ở trên.")

    input("Bấm ENTER để kết thúc...")

if __name__ == "__main__":
    try:
        run_deployment()
    except KeyboardInterrupt:
        print("\nĐã hủy bỏ thao tác.")
    except Exception as e:
        print(f"\nLỗi phát sinh: {e}")
        input("Bấm ENTER để đóng...")
