#!/usr/bin/env bash
# ==============================================================================
# [PAID 2A] SCRIPT CÀI ĐẶT TỰ ĐỘNG 1-CLICK TRÊN CLOUD VPS UBUNTU / LINUX
# (Chi phí VPS chỉ từ 100.000đ - 150.000đ/tháng tại Viettel IDC, AZDIGI, Vultr)
# ==============================================================================
set -e

echo "======================================================================"
echo "  CÀI ĐẶT TỰ ĐỘNG EMS BANQUET CLOUD TRÊN VPS LINUX UBUNTU (PAID 2A)"
echo "======================================================================"

if ! command -v docker &> /dev/null; then
    echo "[1/3] Đang cài đặt Docker & Docker Compose..."
    curl -fsSL https://get.docker.com | sh
fi

echo "[2/3] Đang khởi tạo và chạy container EMS Banquet 24/7 (restart: always)..."
cd "$(dirname "$0")"
docker compose up -d --build

echo "[3/3] Hoàn tất! Hệ thống EMS Banquet đang chạy tại:"
echo "  - EMS Banquet Web:       http://$(hostname -I | awk '{print $1}'):5090/"
echo "  - EMS Mobile (/m):       http://$(hostname -I | awk '{print $1}'):5090/m"
echo "  - EMS Analytics:         http://$(hostname -I | awk '{print $1}'):5090/analytics"
echo "  - EMS AI Coding Agent:   http://$(hostname -I | awk '{print $1}'):5090/ai"
echo "  - EMS Setup Wizard:      http://$(hostname -I | awk '{print $1}'):5090/setup"
