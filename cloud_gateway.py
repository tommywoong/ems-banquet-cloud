"""
EMS Banquet - Unified Single-Port Cloud Gateway (v3.0)
Dành cho triển khai Cloud Online (Google Cloud Run Free 1C, Docker Cloud, VPS Paid 2A):
Gom toàn bộ các phân hệ chạy chung trên 1 cổng HTTPS duy nhất (mặc định PORT=8080):
- /            -> EMS Banquet Web (Lịch sảnh, Đơn tiệc, BEO, Khách hàng CRM, Items)
- /m           -> EMS Mobile & Tablet Web App
- /analytics   -> EMS Banquet Analytics (Báo cáo doanh thu & Biểu đồ)
- /ai          -> EMS AI Coding Agent (In-Browser AI Developer & Rollback)
- /setup       -> EMS Web Setup Wizard (Cấu hình Google Sheets & Hệ thống trực tuyến)
"""
import os
import sys
import importlib.util
from pathlib import Path
from fastapi import FastAPI
from fastapi.responses import RedirectResponse
from starlette.routing import Mount, Route
import uvicorn

BUNDLE_ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(BUNDLE_ROOT / "ems-web"))

# Default to google_sheets mode on serverless cloud unless explicitly configured
if not os.getenv("EMS_DB_MODE") and not (BUNDLE_ROOT / "config.json").exists():
    os.environ["EMS_DB_MODE"] = "google_sheets"

# Import primary EMS Web app
import app as ems_web_module
main_app: FastAPI = ems_web_module.app


def redirect_to_analytics_slash(request):
    return RedirectResponse(url="/analytics/", status_code=307)


def redirect_to_ai_slash(request):
    return RedirectResponse(url="/ai/", status_code=307)


def redirect_to_setup_slash(request):
    return RedirectResponse(url="/setup/", status_code=307)


def _mount_sub_apps():
    """Mounts Analytics, AI Lab, and Setup Wizard as sub-applications under /analytics, /ai, /setup."""
    sub_configs = [
        ("/analytics", BUNDLE_ROOT / "ems-analytics" / "app.py", "ems_analytics_sub"),
        ("/ai", BUNDLE_ROOT / "ems-ai" / "app.py", "ems_ai_sub"),
        ("/setup", BUNDLE_ROOT / "setup_wizard" / "wizard_app.py", "ems_wizard_sub"),
    ]
    # Thêm redirects an toàn cho sub-apps
    main_app.routes.insert(0, Route("/setup", redirect_to_setup_slash))
    main_app.routes.insert(0, Route("/ai", redirect_to_ai_slash))
    main_app.routes.insert(0, Route("/analytics", redirect_to_analytics_slash))

    for prefix, file_path, mod_name in sub_configs:
        if file_path.exists():
            try:
                spec = importlib.util.spec_from_file_location(mod_name, str(file_path))
                mod = importlib.util.module_from_spec(spec)
                sys.path.insert(0, str(file_path.parent))
                spec.loader.exec_module(mod)
                if hasattr(mod, "app"):
                    # Chèn Mount lên đầu danh sách router để ưu tiên trước catch-all static ""
                    main_app.routes.insert(1, Mount(prefix, app=mod.app))
                    print(f"[Cloud Gateway] Mounted {mod_name} at {prefix}")
            except Exception as e:
                print(f"[Cloud Gateway] Notice mounting {prefix}: {e}")


_mount_sub_apps()

if __name__ == "__main__":
    port = int(os.getenv("PORT", "8080"))
    print(f"=== EMS Banquet Unified Cloud Gateway starting on port {port} ===")
    uvicorn.run(main_app, host="0.0.0.0", port=port, timeout_keep_alive=65)
