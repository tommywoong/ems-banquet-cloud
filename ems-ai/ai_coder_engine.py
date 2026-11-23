import os
import sys
import difflib
import datetime
import shutil
import ast
import json
import re
import urllib.request
import urllib.error
from pathlib import Path

BUNDLE_ROOT = Path(__file__).resolve().parent.parent
SNAPSHOT_DIR = BUNDLE_ROOT / ".ai_snapshots"

class AICoderEngine:
    def __init__(self, root_dir: Path = BUNDLE_ROOT):
        self.root_dir = root_dir
        self.snapshot_dir = SNAPSHOT_DIR
        self.snapshot_dir.mkdir(parents=True, exist_ok=True)

    def resolve_path(self, relative_path: str) -> Path:
        """Resolves and protects against path traversal."""
        clean_rel = relative_path.replace("\\", "/").lstrip("/")
        full_path = (self.root_dir / clean_rel).resolve()
        # Ensure path is within bundle root
        if not str(full_path).startswith(str(self.root_dir.resolve())):
            raise ValueError("Đường dẫn không hợp lệ (nằm ngoài thư mục dự án)!")
        return full_path

    def list_files(self, sub_dir: str = ""):
        """Lists files available for inspection."""
        target_dir = self.resolve_path(sub_dir) if sub_dir else self.root_dir
        result = []
        for root, dirs, files in os.walk(target_dir):
            # Ignore hidden folders
            dirs[:] = [d for d in dirs if not d.startswith(".") and d not in ["__pycache__", "venv", "node_modules"]]
            for f in files:
                if f.endswith((".py", ".html", ".js", ".css", ".json", ".sql", ".bat", ".md")):
                    p = Path(root) / f
                    rel = p.relative_to(self.root_dir)
                    result.append({
                        "path": str(rel).replace("\\", "/"),
                        "name": f,
                        "size": p.stat().st_size,
                        "modified": datetime.datetime.fromtimestamp(p.stat().st_mtime).strftime("%Y-%m-%d %H:%M:%S")
                    })
        return sorted(result, key=lambda x: x["path"])

    def read_file(self, relative_path: str) -> str:
        """Reads file content."""
        target = self.resolve_path(relative_path)
        if not target.exists():
            raise FileNotFoundError(f"Không tìm thấy file: {relative_path}")
        with open(target, "r", encoding="utf-8", errors="replace") as f:
            return f.read()

    def generate_diff(self, relative_path: str, new_content: str) -> str:
        """Generates unified diff between current content and proposed new content."""
        old_content = ""
        target = self.resolve_path(relative_path)
        if target.exists():
            with open(target, "r", encoding="utf-8", errors="replace") as f:
                old_content = f.read()

        old_lines = old_content.splitlines(keepends=True)
        new_lines = new_content.splitlines(keepends=True)
        diff = difflib.unified_diff(
            old_lines, new_lines,
            fromfile=f"a/{relative_path}",
            tofile=f"b/{relative_path}",
            lineterm=""
        )
        return "".join(diff)

    def verify_syntax(self, file_path: str, content: str):
        """Verifies syntax for Python/JSON files."""
        if file_path.endswith(".py"):
            try:
                ast.parse(content)
            except SyntaxError as e:
                raise ValueError(f"Lỗi cú pháp Python ở dòng {e.lineno}: {e.msg}")
        elif file_path.endswith(".json"):
            try:
                json.loads(content)
            except Exception as e:
                raise ValueError(f"Lỗi định dạng JSON: {str(e)}")

    def create_snapshot(self, relative_path: str, note: str = "") -> str:
        """Creates a timestamped snapshot of a file before editing."""
        target = self.resolve_path(relative_path)
        if not target.exists():
            return ""
        
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        safe_rel = relative_path.replace("/", "_").replace("\\", "_")
        snapshot_name = f"{timestamp}_{safe_rel}"
        snapshot_path = self.snapshot_dir / snapshot_name
        
        shutil.copy2(target, snapshot_path)
        
        # Save metadata
        meta_file = self.snapshot_dir / f"{snapshot_name}.meta.json"
        with open(meta_file, "w", encoding="utf-8") as f:
            json.dump({
                "original_path": relative_path,
                "timestamp": timestamp,
                "note": note or "Tự động sao lưu trước khi áp dụng thay đổi"
            }, f, ensure_ascii=False, indent=2)
            
        return snapshot_name

    def write_file(self, relative_path: str, content: str, note: str = "") -> dict:
        """Verifies syntax, creates snapshot, and safely writes file."""
        self.verify_syntax(relative_path, content)
        snapshot_name = self.create_snapshot(relative_path, note)
        
        target = self.resolve_path(relative_path)
        target.parent.mkdir(parents=True, exist_ok=True)
        
        with open(target, "w", encoding="utf-8") as f:
            f.write(content)
            
        return {
            "success": True,
            "path": relative_path,
            "snapshot": snapshot_name,
            "message": f"Đã cập nhật file {relative_path} thành công an toàn."
        }

    def list_snapshots(self):
        """Lists all snapshots."""
        results = []
        for meta_file in sorted(self.snapshot_dir.glob("*.meta.json"), reverse=True):
            try:
                with open(meta_file, "r", encoding="utf-8") as f:
                    meta = json.load(f)
                snap_id = meta_file.name.replace(".meta.json", "")
                results.append({
                    "id": snap_id,
                    "original_path": meta.get("original_path", ""),
                    "timestamp": meta.get("timestamp", ""),
                    "note": meta.get("note", "")
                })
            except Exception:
                continue
        return results

    def rollback(self, snapshot_id: str) -> dict:
        """Restores file from snapshot."""
        meta_file = self.snapshot_dir / f"{snapshot_id}.meta.json"
        snap_file = self.snapshot_dir / snapshot_id
        if not meta_file.exists() or not snap_file.exists():
            raise FileNotFoundError("Không tìm thấy bản snapshot yêu cầu!")
            
        with open(meta_file, "r", encoding="utf-8") as f:
            meta = json.load(f)
            
        target = self.resolve_path(meta["original_path"])
        shutil.copy2(snap_file, target)
        
        return {
            "success": True,
            "restored_path": meta["original_path"],
            "message": f"Đã khôi phục thành công file {meta['original_path']} từ snapshot {snapshot_id}."
        }


# ==============================================================================
# AI PROVIDER MANAGER: MULTI-PROVIDER AI & KNOWLEDGE BASE INTEGRATION
# Hỗ trợ Gemini, Antigravity, DeepSeek, OpenAI, Claude, OpenRouter, Ollama Offline
# ==============================================================================

class AIProviderManager:
    PROVIDER_DEFAULTS = {
        "gemini": {
            "name": "Google Gemini (Khuyên dùng)",
            "base_url": "https://generativelanguage.googleapis.com/v1beta/openai",
            "default_model": "gemini-2.0-flash",
            "models": ["gemini-2.0-flash", "gemini-1.5-pro", "gemini-1.5-flash", "gemini-2.0-pro-exp"],
            "env_key": "GEMINI_API_KEY",
            "requires_key": True,
            "description": "Tốc độ phản hồi cực nhanh, miễn phí qua Google AI Studio API Key."
        },
        "antigravity": {
            "name": "Google Antigravity Agent",
            "base_url": "https://generativelanguage.googleapis.com/v1beta/openai",
            "default_model": "gemini-2.0-flash",
            "models": ["gemini-2.0-flash", "gemini-1.5-pro", "gemini-2.5-pro"],
            "env_key": "ANTIGRAVITY_API_KEY",
            "requires_key": True,
            "description": "Nền tảng AI chuyên sâu của Google DeepMind cho phát triển phần mềm."
        },
        "deepseek": {
            "name": "DeepSeek AI",
            "base_url": "https://api.deepseek.com/v1",
            "default_model": "deepseek-chat",
            "models": ["deepseek-chat", "deepseek-reasoner"],
            "env_key": "DEEPSEEK_API_KEY",
            "requires_key": True,
            "description": "Mô hình lập trình thông minh, chi phí cực rẻ, tối ưu cho kỹ sư phần mềm."
        },
        "openai": {
            "name": "OpenAI (ChatGPT)",
            "base_url": "https://api.openai.com/v1",
            "default_model": "gpt-4o",
            "models": ["gpt-4o", "gpt-4o-mini", "o3-mini"],
            "env_key": "OPENAI_API_KEY",
            "requires_key": True,
            "description": "Mô hình GPT-4o hàng đầu thế giới từ OpenAI."
        },
        "claude": {
            "name": "Anthropic Claude (qua OpenRouter)",
            "base_url": "https://openrouter.ai/api/v1",
            "default_model": "anthropic/claude-3.5-sonnet",
            "models": ["anthropic/claude-3.5-sonnet", "anthropic/claude-3.7-sonnet", "anthropic/claude-3-haiku"],
            "env_key": "OPENROUTER_API_KEY",
            "requires_key": True,
            "description": "Mô hình Claude 3.5 / 3.7 Sonnet với năng lực tư duy logic và viết code vượt trội."
        },
        "openrouter": {
            "name": "OpenRouter (200+ Models)",
            "base_url": "https://openrouter.ai/api/v1",
            "default_model": "google/gemini-2.0-flash-001",
            "models": ["google/gemini-2.0-flash-001", "deepseek/deepseek-chat", "openai/gpt-4o-mini", "meta-llama/llama-3.3-70b-instruct"],
            "env_key": "OPENROUTER_API_KEY",
            "requires_key": True,
            "description": "Cổng kết nối duy nhất truy cập mọi mô hình AI thế giới."
        },
        "ollama": {
            "name": "Local Ollama (100% Offline LAN)",
            "base_url": "http://localhost:11434/v1",
            "default_model": "qwen2.5-coder",
            "models": ["qwen2.5-coder", "deepseek-r1:8b", "llama3.1", "codellama"],
            "env_key": "",
            "requires_key": False,
            "description": "Chạy hoàn toàn nội bộ trên máy chủ hoặc mạng LAN khách sạn, không cần Internet."
        },
        "custom": {
            "name": "Custom OpenAI-Compatible API",
            "base_url": "http://localhost:8000/v1",
            "default_model": "custom-model",
            "models": ["custom-model"],
            "env_key": "",
            "requires_key": False,
            "description": "Tùy biến máy chủ AI Proxy, vLLM hoặc gateway riêng của đơn vị."
        }
    }

    def __init__(self, root_dir: Path = BUNDLE_ROOT):
        self.root_dir = root_dir
        self.config_file = root_dir / "config.json"

    def get_knowledge_base_content(self) -> str:
        """Reads AGENTS.md and core documentation to inject into AI System Prompt."""
        knowledge = []
        agents_file = self.root_dir / "AGENTS.md"
        if agents_file.exists():
            try:
                with open(agents_file, "r", encoding="utf-8") as f:
                    knowledge.append(f"=== BỘ QUY TẮC BẮT BUỘC DỰ ÁN (AGENTS.MD) ===\n{f.read()}\n")
            except Exception:
                pass

        principles_file = self.root_dir / "PROJECT_DOCUMENTATION" / "DEVELOPMENT_PRINCIPLES.md"
        if principles_file.exists():
            try:
                with open(principles_file, "r", encoding="utf-8") as f:
                    knowledge.append(f"=== NGUYÊN TẮC PHÁT TRIỂN KỸ THUẬT CỐT LÕI ===\n{f.read()}\n")
            except Exception:
                pass

        if not knowledge:
            return (
                "QUY TẮC BẤT BIẾN DỰ ÁN MERPERLE BANQUET:\n"
                "1. Không refactor từ đầu, kế thừa và mở rộng trên hệ thống đang chạy production.\n"
                "2. Không sửa cấu trúc SQL Server gốc (EMS_KHAIVY).\n"
                "3. Không làm hỏng chức năng cũ (Lịch sảnh 8090, Analytics 8088, Soạn BEO, Items A-T).\n"
                "4. Không báo cáo pass nếu chưa test.\n"
                "5. Tuân thủ quy trình 8 bước chuẩn: Đọc -> Phân tích -> Đánh giá tác động -> Đề xuất -> Thực hiện -> Kiểm thử -> Cập nhật bộ nhớ -> Báo cáo."
            )
        return "\n".join(knowledge)

    def load_config(self) -> dict:
        """Loads AI config from config.json with fallback to environment variables."""
        cfg_data = {}
        if self.config_file.exists():
            try:
                with open(self.config_file, "r", encoding="utf-8") as f:
                    cfg_data = json.load(f)
            except Exception:
                pass

        ai_cfg = cfg_data.get("ai_provider_config", {})
        provider = ai_cfg.get("provider") or os.getenv("AI_PROVIDER", "gemini")
        if provider not in self.PROVIDER_DEFAULTS:
            provider = "gemini"

        default_def = self.PROVIDER_DEFAULTS[provider]
        
        # Resolve API Key
        env_key_name = default_def.get("env_key")
        api_key = ai_cfg.get("api_key") or (os.getenv(env_key_name, "") if env_key_name else "")
        if not api_key and provider == "gemini":
            api_key = os.getenv("GEMINI_API_KEY", "") or os.getenv("GOOGLE_API_KEY", "")

        model = ai_cfg.get("model") or os.getenv("AI_MODEL", default_def["default_model"])
        base_url = ai_cfg.get("base_url") or default_def["base_url"]
        system_prompt_custom = ai_cfg.get("custom_system_prompt", "")

        return {
            "provider": provider,
            "provider_name": default_def["name"],
            "model": model,
            "api_key": api_key,
            "base_url": base_url,
            "custom_system_prompt": system_prompt_custom,
            "requires_key": default_def["requires_key"]
        }

    def save_config(self, provider: str, model: str, api_key: str, base_url: str = "", custom_system_prompt: str = "") -> dict:
        """Saves AI provider settings into config.json."""
        if provider not in self.PROVIDER_DEFAULTS:
            raise ValueError(f"Nhà cung cấp không hợp lệ: {provider}")

        default_def = self.PROVIDER_DEFAULTS[provider]
        clean_model = model.strip() if model else default_def["default_model"]
        clean_base_url = base_url.strip() if base_url else default_def["base_url"]
        
        # Load existing config
        all_cfg = {}
        if self.config_file.exists():
            try:
                with open(self.config_file, "r", encoding="utf-8") as f:
                    all_cfg = json.load(f)
            except Exception:
                all_cfg = {}

        # Preserve existing key if user sent masked or empty key
        existing_ai = all_cfg.get("ai_provider_config", {})
        final_api_key = api_key.strip()
        if (not final_api_key or "***" in final_api_key) and existing_ai.get("provider") == provider:
            final_api_key = existing_ai.get("api_key", "")

        all_cfg["ai_provider_config"] = {
            "provider": provider,
            "model": clean_model,
            "api_key": final_api_key,
            "base_url": clean_base_url,
            "custom_system_prompt": custom_system_prompt.strip(),
            "updated_at": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        }

        with open(self.config_file, "w", encoding="utf-8") as f:
            json.dump(all_cfg, f, ensure_ascii=False, indent=2)

        return self.get_masked_config()

    def get_masked_config(self) -> dict:
        """Returns active config with masked key for secure frontend display."""
        cfg = self.load_config()
        raw_key = cfg.get("api_key", "")
        if raw_key and len(raw_key) > 8:
            masked = raw_key[:4] + "*" * (len(raw_key) - 8) + raw_key[-4:]
        elif raw_key:
            masked = "****"
        else:
            masked = ""

        cfg["api_key"] = masked
        cfg["api_key_masked"] = masked
        cfg["has_key"] = bool(raw_key)
        cfg["providers"] = self.PROVIDER_DEFAULTS
        return cfg

    def _execute_chat_request(self, base_url: str, api_key: str, payload: dict, timeout: int = 60) -> dict:
        """Executes an OpenAI-compatible HTTP chat completion request using urllib."""
        endpoint = base_url.rstrip("/")
        if not endpoint.endswith("/chat/completions"):
            endpoint += "/chat/completions"

        headers = {
            "Content-Type": "application/json",
            "User-Agent": "EMSAICodingAgent/2.4"
        }
        if api_key:
            headers["Authorization"] = f"Bearer {api_key}"

        body_bytes = json.dumps(payload).encode("utf-8")
        req = urllib.request.Request(endpoint, data=body_bytes, headers=headers, method="POST")

        try:
            with urllib.request.urlopen(req, timeout=timeout) as response:
                resp_data = response.read().decode("utf-8")
                return json.loads(resp_data)
        except urllib.error.HTTPError as e:
            err_body = e.read().decode("utf-8", errors="replace")
            try:
                err_json = json.loads(err_body)
                msg = err_json.get("error", {}).get("message") or err_json.get("message") or str(err_json)
            except Exception:
                msg = err_body[:300]
            raise RuntimeError(f"HTTP {e.code}: {msg}")
        except Exception as e:
            raise RuntimeError(f"Lỗi kết nối máy chủ AI: {str(e)}")

    def test_connection(self, provider: str, model: str, api_key: str = "", base_url: str = "") -> dict:
        """Sends a lightweight ping to verify connection with the given settings."""
        cfg = self.load_config()
        active_provider = provider or cfg["provider"]
        default_def = self.PROVIDER_DEFAULTS.get(active_provider, self.PROVIDER_DEFAULTS["gemini"])
        
        target_model = model or cfg["model"] or default_def["default_model"]
        target_base = base_url or cfg["base_url"] or default_def["base_url"]
        target_key = api_key if (api_key and "***" not in api_key) else cfg["api_key"]

        if default_def["requires_key"] and not target_key:
            return {
                "success": False,
                "error": f"Nhà cung cấp {default_def['name']} yêu cầu API Key! Vui lòng nhập API Key để tiếp tục."
            }

        test_payload = {
            "model": target_model,
            "messages": [
                {"role": "user", "content": "Xin chào, phản hồi ngắn 'OK' để xác nhận kết nối."}
            ],
            "max_tokens": 15,
            "temperature": 0.1
        }

        try:
            start_t = datetime.datetime.now()
            res = self._execute_chat_request(target_base, target_key, test_payload, timeout=20)
            elapsed = (datetime.datetime.now() - start_t).total_seconds()
            
            choices = res.get("choices", [])
            reply = choices[0].get("message", {}).get("content", "").strip() if choices else "Kết nối thành công"
            
            return {
                "success": True,
                "provider": active_provider,
                "model": target_model,
                "latency_sec": round(elapsed, 2),
                "message": f"Kết nối thành công tới {default_def['name']} ({target_model})! Độ trễ: {round(elapsed, 2)}s. Phản hồi: '{reply}'"
            }
        except Exception as e:
            return {
                "success": False,
                "provider": active_provider,
                "model": target_model,
                "error": str(e)
            }

    def chat(self, prompt: str, current_file_path: str = "", current_file_content: str = "", chat_history: list = None) -> dict:
        """
        Orchestrates an interactive chat turn:
        1. Injects complete AGENTS.md & project principles into System Prompt.
        2. Adds file context if provided.
        3. Appends conversation history.
        4. Calls AI and parses response & proposed code blocks.
        """
        cfg = self.load_config()
        if cfg["requires_key"] and not cfg["api_key"]:
            raise ValueError(f"Chưa cấu hình API Key cho nhà cung cấp {cfg['provider_name']}! Vui lòng bấm 'Cấu hình AI' trên thanh công cụ để nhập API Key.")

        # 1. System Prompt with AGENTS.md injection
        kb_text = self.get_knowledge_base_content()
        system_instruction = (
            "Bạn là Trợ Lý Kỹ Sư AI Chuyên Sâu của Hệ Thống Quản Lý Tiệc MerPerle / Khải Vy Hotel (EMS Banquet System).\n"
            "BẠN BẮT BUỘC PHẢI TUÂN THỦ 100% CÁC NGUYÊN TẮC BẤT BIẾN SAU ĐÂY:\n"
            "1. ⛔ KHÔNG ĐƯỢC TỰ Ý REFACTOR / VIẾT LẠI TỪ ĐẦU: Hệ thống đang vận hành production trên 10.17.10.12. Mọi giải pháp phải kế thừa và mở rộng.\n"
            "2. ⛔ KHÔNG ĐƯỢC SỬA ĐỔI DATABASE SQL SERVER GỐC (EMS_KHAIVY): Tuyệt đối không ALTER TABLE, không thêm cột lạ, không đổi kiểu dữ liệu.\n"
            "3. ⛔ KHÔNG ĐƯỢC LÀM HỎNG CHỨC NĂNG CŨ: Giữ vững tính ổn định của Lịch sảnh (8090), BEO, Items, Analytics (8088), Audit Trail (audit.db).\n"
            "4. ⛔ KHÔNG ĐƯỢC PHÉP BÁO CÁO PASS NẾU CHƯA TEST.\n"
            "5. Tuân thủ nghiêm ngặt Quy trình 8 bước chuẩn: Đọc -> Phân tích -> Đánh giá tác động -> Đề xuất -> Thực hiện -> Kiểm thử -> Cập nhật bộ nhớ -> Báo cáo.\n\n"
            f"{kb_text}\n\n"
            "KHI ĐỀ XUẤT VIẾT HOẶC CHỈNH SỬA CODE:\n"
            "- Hãy đặt code trong các khối fenced markdown code blocks rõ ràng với ngôn ngữ tương ứng (```python, ```html, ```javascript, ```sql).\n"
            "- Nêu rõ file đang thao tác và giải thích ngắn gọn, súc tích thay đổi.\n"
        )
        if cfg.get("custom_system_prompt"):
            system_instruction += f"\n\n=== CHỈ ĐẠO BỔ SUNG CỦA QUẢN TRỊ VIÊN ===\n{cfg['custom_system_prompt']}"

        messages = [{"role": "system", "content": system_instruction}]

        # 2. Append Chat History
        if chat_history:
            for item in chat_history[-6:]:  # Keep recent 6 turns for context
                role = item.get("role")
                content = item.get("content")
                if role in ["user", "assistant"] and content:
                    messages.append({"role": role, "content": content})

        # 3. Construct user prompt with file context
        user_content_parts = []
        if current_file_path and current_file_content:
            # Include file snapshot (limit to 30KB to avoid excessive token consumption)
            truncated_content = current_file_content[:32000]
            if len(current_file_content) > 32000:
                truncated_content += "\n... [Nội dung file được rút gọn do kích thước lớn] ..."
            user_content_parts.append(
                f"[FILE ĐANG MỞ: {current_file_path}]\n```\n{truncated_content}\n```\n"
            )

        user_content_parts.append(prompt)
        messages.append({"role": "user", "content": "\n\n".join(user_content_parts)})

        payload = {
            "model": cfg["model"],
            "messages": messages,
            "temperature": 0.2,
            "max_tokens": 4096
        }

        start_t = datetime.datetime.now()
        res = self._execute_chat_request(cfg["base_url"], cfg["api_key"], payload, timeout=120)
        elapsed = (datetime.datetime.now() - start_t).total_seconds()

        choices = res.get("choices", [])
        if not choices:
            raise RuntimeError("Máy chủ AI không trả về nội dung lựa chọn nào.")

        ai_reply = choices[0].get("message", {}).get("content", "").strip()

        # 4. Extract code blocks
        code_blocks = []
        pattern = r"```([a-zA-Z0-9_\-+]*)\n([\s\S]*?)```"
        for match in re.finditer(pattern, ai_reply):
            lang = match.group(1).lower()
            code_body = match.group(2).strip()
            if code_body:
                code_blocks.append({
                    "language": lang,
                    "code": code_body
                })

        return {
            "success": True,
            "provider": cfg["provider"],
            "model": cfg["model"],
            "response": ai_reply,
            "code_blocks": code_blocks,
            "latency_sec": round(elapsed, 2)
        }
