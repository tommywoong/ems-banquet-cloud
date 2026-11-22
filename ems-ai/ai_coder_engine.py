import os
import sys
import difflib
import datetime
import shutil
import ast
import json
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
