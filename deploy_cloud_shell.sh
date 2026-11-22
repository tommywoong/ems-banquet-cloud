#!/usr/bin/env bash
# ==============================================================================
# [FREE 1C] SCRIPT TRIỂN KHAI 1-CHẠM TRÊN GOOGLE CLOUD SHELL (TRÌNH DUYỆT WEB)
# (Không cần cài đặt bất kỳ phần mềm nào vào máy tính cá nhân!)
# ==============================================================================
set -e

echo "========================================================================"
echo "  🚀 TRIỂN KHAI EMS BANQUET LÊN GOOGLE CLOUD RUN TỪ CLOUD SHELL (FREE 1C)"
echo "========================================================================"
echo ""

read -p "1. Nhập Google Cloud Project ID (VD: ems-banquet-hotel): " GCP_PROJECT
read -p "2. Nhập Google Spreadsheet ID (đoạn mã giữa /d/ và /edit): " GSHEET_ID
read -p "3. Nhập Google Apps Script Webhook URL (https://script.google.com/...): " GSHEET_WEBHOOK

echo ""
echo "[*] Đang cấu hình Project [$GCP_PROJECT]..."
gcloud config set project "$GCP_PROJECT"

echo ""
echo "[*] Đang kích hoạt Cloud Run API & Cloud Build API..."
gcloud services enable run.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com

echo ""
echo "[*] Đang đóng gói & triển khai hệ thống lên Google Cloud Run (Singapore)..."
cd "$(dirname "$0")"

gcloud run deploy ems-banquet-cloud \
    --source . \
    --region asia-southeast1 \
    --allow-unauthenticated \
    --memory 1Gi \
    --cpu 1 \
    --min-instances 0 \
    --max-instances 3 \
    --set-env-vars "EMS_DB_MODE=google_sheets,EMS_GSHEET_ID=$GSHEET_ID,EMS_GSHEET_WEBHOOK_URL=$GSHEET_WEBHOOK"

echo ""
echo "========================================================================"
echo "🎉 HOÀN TẤT! Hệ thống EMS Banquet đã hoạt động 24/7 trên Google Cloud!"
echo "Hãy lưu đường link Service URL ở trên để truy cập từ Điện thoại và Máy tính."
echo "========================================================================"
