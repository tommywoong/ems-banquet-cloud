import os
import sys
import json
from pathlib import Path
from fastapi import FastAPI, HTTPException, Header, Depends
from fastapi.responses import HTMLResponse, JSONResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from typing import Optional

from ai_coder_engine import AICoderEngine

app = FastAPI(title="EMS Banquet AI Coding Agent (Port 8092)")

BUNDLE_ROOT = Path(__file__).resolve().parent.parent
CONFIG_FILE = BUNDLE_ROOT / "config.json"
engine = AICoderEngine(BUNDLE_ROOT)

def get_master_password():
    if CONFIG_FILE.exists():
        try:
            with open(CONFIG_FILE, "r", encoding="utf-8") as f:
                cfg = json.load(f)
                return cfg.get("ai_master_password", "Admin@EMS2026")
        except Exception:
            pass
    return "Admin@EMS2026"

def verify_token(x_master_pass: Optional[str] = Header(None)):
    expected = get_master_password()
    if not x_master_pass or x_master_pass != expected:
        raise HTTPException(status_code=401, detail="Mật khẩu Master Pass không chính xác!")
    return True

# Models
class AuthRequest(BaseModel):
    password: str

class ReadFileRequest(BaseModel):
    path: str

class DiffRequest(BaseModel):
    path: str
    content: str

class ApplyRequest(BaseModel):
    path: str
    content: str
    note: Optional[str] = ""

class RollbackRequest(BaseModel):
    snapshot_id: str

@app.post("/api/auth")
def auth(req: AuthRequest):
    if req.password == get_master_password():
        return {"success": True, "token": req.password, "message": "Xác thực thành công"}
    raise HTTPException(status_code=401, detail="Sai mật khẩu Master!")

@app.get("/api/files")
def list_files(sub_dir: str = "", authorized: bool = Depends(verify_token)):
    try:
        files = engine.list_files(sub_dir)
        return {"success": True, "files": files}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/api/file")
def get_file(path: str, authorized: bool = Depends(verify_token)):
    try:
        content = engine.read_file(path)
        return {"success": True, "path": path, "content": content}
    except Exception as e:
        raise HTTPException(status_code=404, detail=str(e))

@app.post("/api/diff")
def preview_diff(req: DiffRequest, authorized: bool = Depends(verify_token)):
    try:
        diff_text = engine.generate_diff(req.path, req.content)
        return {"success": True, "path": req.path, "diff": diff_text}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/api/apply")
def apply_changes(req: ApplyRequest, authorized: bool = Depends(verify_token)):
    try:
        result = engine.write_file(req.path, req.content, req.note)
        return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/api/snapshots")
def get_snapshots(authorized: bool = Depends(verify_token)):
    snaps = engine.list_snapshots()
    return {"success": True, "snapshots": snaps}

@app.post("/api/rollback")
def rollback(req: RollbackRequest, authorized: bool = Depends(verify_token)):
    try:
        res = engine.rollback(req.snapshot_id)
        return res
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/api/status")
def get_status():
    return {
        "status": "online",
        "service": "EMS Banquet AI Coding Agent",
        "port": 8092,
        "bundle_root": str(BUNDLE_ROOT),
        "version": "1.0.0"
    }

# Mount static files
static_dir = Path(__file__).parent / "static"
static_dir.mkdir(parents=True, exist_ok=True)
app.mount("/static", StaticFiles(directory=str(static_dir)), name="static")

@app.get("/", response_class=HTMLResponse)
def index():
    html_file = static_dir / "index.html"
    if html_file.exists():
        with open(html_file, "r", encoding="utf-8") as f:
            return HTMLResponse(content=f.read())
    return HTMLResponse("<h3>EMS Banquet AI Coding Agent Dashboard</h3>")

if __name__ == "__main__":
    import uvicorn
    # Resolve dynamic port from config.json or environment (Default: 8092 for Production/Dev)
    ai_port = 8092
    if CONFIG_FILE.exists():
        try:
            with open(CONFIG_FILE, "r", encoding="utf-8") as _f:
                _data = json.load(_f)
                ai_port = int(_data.get("port_ai", 8092))
        except Exception:
            pass
    if "PORT" in os.environ:
        try:
            ai_port = int(os.environ["PORT"])
        except ValueError:
            pass
    print(f"=== Starting EMS Banquet AI Coding Agent on Port {ai_port} ===")
    uvicorn.run(app, host="0.0.0.0", port=ai_port)
