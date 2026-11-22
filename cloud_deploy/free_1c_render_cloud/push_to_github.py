# -*- coding: utf-8 -*-
"""
EMS Banquet Cloud - GitHub Upload Helper for Render.com (Free 1C - 0đ Không Cần Thẻ)
Hỗ trợ đưa mã nguồn lên GitHub để kết nối trực tiếp với Render.com.
"""
import os
import sys
import shutil
import subprocess
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
BUNDLE_DIR = SCRIPT_DIR.parent.parent

def print_banner():
    print("=" * 72)
    print("  🚀 [FREE 1C] CHUẨN BỊ MÃ NGUỒN ĐẨY LÊN GITHUB ĐỂ DEPLOY RENDER.COM")
    print("  (Hoàn toàn miễn phí 0đ - Tuyệt đối không yêu cầu thẻ Visa / Mastercard)")
    print("=" * 72)
    print()

def main():
    print_banner()

    if not shutil.which("git"):
        print("⚠️ Máy tính của bạn chưa có công cụ Git.")
        print("-" * 72)
        print("HƯỚNG DẪN TẢI LÊN GITHUB DỄ DÀNG BẰNG TRÌNH DUYỆT (KHÔNG CẦN CÀI GIT):")
        print("1. Truy cập https://github.com và đăng nhập tài khoản của bạn.")
        print("2. Bấm nút dấu cộng [+] góc trên bên phải -> Chọn 'New repository'.")
        print("3. Đặt tên: ems-banquet-cloud -> Chọn 'Private' hoặc 'Public' -> Bấm 'Create repository'.")
        print("4. Tại trang repo mới, bấm vào dòng chữ: 'uploading an existing file'.")
        print("5. Kéo thả các file trong thư mục EMS_Banquet_Portable_Bundle lên và bấm 'Commit changes'.")
        print("-" * 72)
        input("Bấm ENTER để đóng..."); return

    print("HƯỚNG DẪN 1-CLICK TỰ ĐỘNG ĐẨY LÊN GITHUB:")
    print("1. Mở https://github.com -> Bấm [+ New repository] -> Đặt tên: ems-banquet-cloud")
    print("2. Copy đường link repo có dạng: https://github.com/username/ems-banquet-cloud.git")
    print("-" * 72)
    repo_url = input("Dán đường link GitHub repository của bạn vào đây: ").strip()

    if not repo_url:
        print("❌ Bạn chưa nhập link repo.")
        input("Bấm ENTER để đóng..."); return

    print()
    print("[1/4] Đang khởi tạo Git trong bộ cài...")
    subprocess.run(["git", "init"], cwd=str(BUNDLE_DIR))
    
    print("[2/4] Đang thêm các tệp tin cần thiết...")
    # Tạo .gitignore nhẹ để không đẩy python_runtime và tools nặng
    gitignore_path = BUNDLE_DIR / ".gitignore"
    if not gitignore_path.exists():
        with open(gitignore_path, "w", encoding="utf-8") as f:
            f.write("python_runtime/\ntools/nssm.exe\n__pycache__/\n*.pyc\n*.log\n")

    subprocess.run(["git", "add", "."], cwd=str(BUNDLE_DIR))
    subprocess.run(["git", "commit", "-m", "Deploy EMS Banquet Cloud to Render (v3.2)"], cwd=str(BUNDLE_DIR))
    subprocess.run(["git", "branch", "-M", "main"], cwd=str(BUNDLE_DIR))

    print("[3/4] Đang kết nối với GitHub...")
    subprocess.run(["git", "remote", "remove", "origin"], cwd=str(BUNDLE_DIR), stderr=subprocess.DEVNULL)
    subprocess.run(["git", "remote", "add", "origin", repo_url], cwd=str(BUNDLE_DIR))

    print("[4/4] Đang đẩy mã nguồn lên GitHub...")
    res = subprocess.run(["git", "push", "-u", "origin", "main", "--force"], cwd=str(BUNDLE_DIR))

    if res.returncode == 0:
        print()
        print("=" * 72)
        print("🎉 [HOÀN TẤT] ĐÃ ĐẨY MÃ NGUỒN LÊN GITHUB THÀNH CÔNG!")
        print()
        print("BƯỚC TIẾP THEO TRÊN RENDER.COM (CHỈ MẤT 1 PHÚT):")
        print("1. Truy cập https://dashboard.render.com (Đăng nhập bằng GitHub hoặc Google).")
        print("2. Bấm nút 'New +' ở góc phải -> Chọn 'Web Service'.")
        print("3. Chọn repository 'ems-banquet-cloud' vừa đẩy lên.")
        print("4. Tại mục Environment, chọn: 'Docker'.")
        print("5. Thêm 2 biến môi trường (Environment Variables):")
        print("   - EMS_DB_MODE: google_sheets")
        print("   - EMS_GSHEET_WEBHOOK_URL: (Link Webhook Apps Script đã lấy)")
        print("6. Bấm nút 'Create Web Service' -> Hoàn tất! Render sẽ cấp link HTTPS vĩnh viễn.")
        print("=" * 72)
    else:
        print("\n❌ Có lỗi khi push lên GitHub. Bạn hãy kiểm tra lại quyền đăng nhập GitHub của mình.")

    input("Bấm ENTER để kết thúc...")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"\nLỗi: {e}")
        input("Bấm ENTER để đóng...")
