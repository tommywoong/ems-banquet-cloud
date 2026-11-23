import os
import sys
import json
from pathlib import Path
from fastapi import FastAPI, HTTPException, Header, Depends
from fastapi.responses import HTMLResponse, JSONResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from typing import Optional

from ai_coder_engine import AICoderEngine, AIProviderManager

app = FastAPI(title="EMS Banquet AI Coding Agent (Port 8092)")

BUNDLE_ROOT = Path(__file__).resolve().parent.parent
CONFIG_FILE = BUNDLE_ROOT / "config.json"
engine = AICoderEngine(BUNDLE_ROOT)
ai_manager = AIProviderManager(BUNDLE_ROOT)

def get_master_passwords():
    passwords = {"admin@ems2026", "luantam@233267"}
    if CONFIG_FILE.exists():
        try:
            with open(CONFIG_FILE, "r", encoding="utf-8") as f:
                cfg = json.load(f)
                val = cfg.get("ai_master_password")
                if val:
                    passwords.add(str(val).strip().lower())
        except Exception:
            pass
    return passwords

def verify_token(x_master_pass: Optional[str] = Header(None)):
    if not x_master_pass or x_master_pass.strip().lower() not in get_master_passwords():
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

class AIConfigRequest(BaseModel):
    provider: str
    model: str
    api_key: Optional[str] = ""
    base_url: Optional[str] = ""
    custom_system_prompt: Optional[str] = ""

class AITestRequest(BaseModel):
    provider: str
    model: str
    api_key: Optional[str] = ""
    base_url: Optional[str] = ""

class AIChatRequest(BaseModel):
    prompt: str
    current_file_path: Optional[str] = ""
    current_file_content: Optional[str] = ""
    chat_history: Optional[list] = []

@app.post("/api/auth")
def auth(req: AuthRequest):
    pwd_clean = (req.password or "").strip()
    if pwd_clean.lower() in get_master_passwords():
        return {"success": True, "token": pwd_clean, "message": "Xác thực thành công"}
    raise HTTPException(status_code=401, detail="Sai mật khẩu Master! Vui lòng thử lại.")

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

# ==============================================================================
# AI PROVIDER & CHAT ASSISTANT ENDPOINTS
# ==============================================================================

@app.get("/api/ai/config")
def get_ai_config(authorized: bool = Depends(verify_token)):
    """Returns active AI provider settings with masked API key."""
    try:
        return {"success": True, "config": ai_manager.get_masked_config()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/ai/config")
def save_ai_config(req: AIConfigRequest, authorized: bool = Depends(verify_token)):
    """Saves AI provider settings into config.json."""
    try:
        res = ai_manager.save_config(
            provider=req.provider,
            model=req.model,
            api_key=req.api_key,
            base_url=req.base_url,
            custom_system_prompt=req.custom_system_prompt
        )
        return {"success": True, "config": res, "message": "Đã lưu cấu hình AI thành công!"}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/api/ai/test")
def test_ai_connection(req: AITestRequest, authorized: bool = Depends(verify_token)):
    """Tests connection to the specified AI model/provider."""
    try:
        res = ai_manager.test_connection(
            provider=req.provider,
            model=req.model,
            api_key=req.api_key,
            base_url=req.base_url
        )
        return res
    except Exception as e:
        return {"success": False, "error": str(e)}

@app.post("/api/ai/chat")
def chat_with_ai(req: AIChatRequest, authorized: bool = Depends(verify_token)):
    """Sends a chat message to the configured AI agent with full project rules injection."""
    try:
        res = ai_manager.chat(
            prompt=req.prompt,
            current_file_path=req.current_file_path,
            current_file_content=req.current_file_content,
            chat_history=req.chat_history
        )
        return res
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/ai/knowledge")
def get_ai_knowledge(authorized: bool = Depends(verify_token)):
    """Returns active Project Rules and AGENTS.md content."""
    try:
        content = ai_manager.get_knowledge_base_content()
        return {"success": True, "content": content}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

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
