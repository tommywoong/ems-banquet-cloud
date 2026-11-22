# -*- coding: utf-8 -*-
"""
Dừng triệt để tất cả các tiến trình và giải phóng toàn bộ cổng mạng của EMS Banquet Portable.
Đọc động cấu hình config.json và quét toàn diện các tiến trình python_runtime.
"""
import os
import sys
import json
import subprocess
from pathlib import Path

BUNDLE_ROOT = Path(__file__).resolve().parent
CONFIG_PATH = BUNDLE_ROOT / "config.json"

def get_configured_ports():
    ports = set([5090, 5088, 5092, 5888, 5123, 5255, 8090, 8088, 8092, 8888, 8999, 8091, 8089, 8093])
    if CONFIG_PATH.exists():
        try:
            with open(CONFIG_PATH, "r", encoding="utf-8") as f:
                cfg = json.load(f)
            for k in ["port_web", "port_analytics", "port_ai", "port_wizard", "port"]:
                v = cfg.get(k)
                if v and isinstance(v, int):
                    ports.add(v)
        except Exception:
            pass
    return sorted(list(ports))

def kill_pids_on_ports(ports):
    killed_pids = set()
    for port in ports:
        try:
            cmd = f'netstat -ano | findstr ":{port} "'
            res = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=3)
            for line in res.stdout.strip().splitlines():
                if "LISTENING" in line:
                    parts = line.split()
                    pid = parts[-1]
                    if pid.isdigit() and int(pid) > 4 and pid not in killed_pids:
                        print(f"  -> Giải phóng cổng {port} (tiến trình PID {pid})...")
                        subprocess.run(f"taskkill /F /PID {pid}", shell=True, capture_output=True)
                        killed_pids.add(pid)
        except Exception:
            pass

def kill_bundle_python_processes():
    bundle_str = str(BUNDLE_ROOT).lower()
    my_pid = os.getpid()
    try:
        # Query wmic or powershell for python processes running from bundle folder
        cmd = 'powershell -Command "Get-CimInstance Win32_Process -Filter \\"Name=\'python.exe\'\\" | Select-Object ProcessId, ExecutablePath, CommandLine | ConvertTo-Json"'
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=5)
        if res.stdout.strip():
            raw = res.stdout.strip()
            data = json.loads(raw)
            if isinstance(data, dict):
                data = [data]
            for p in data:
                pid = p.get("ProcessId")
                exe = str(p.get("ExecutablePath") or "").lower()
                cmdline = str(p.get("CommandLine") or "").lower()
                if pid and int(pid) != my_pid and (bundle_str in exe or bundle_str in cmdline):
                    print(f"  -> Đóng tiến trình EMS Python nội bộ (PID {pid})...")
                    subprocess.run(f"taskkill /F /PID {pid}", shell=True, capture_output=True)
    except Exception:
        pass

def main():
    print("===============================================================================")
    print("         EMS BANQUET SYSTEM - DỪNG VÀ GIẢI PHÓNG TOÀN BỘ DỊCH VỤ")
    print("===============================================================================")
    ports = get_configured_ports()
    print(f"[*] Quét và giải phóng các cổng mạng: {ports}")
    kill_pids_on_ports(ports)
    print("[*] Quét và đóng các tiến trình Python thuộc gói Portable...")
    kill_bundle_python_processes()
    print("\n✓ ĐÃ DỪNG TOÀN BỘ TIẾN TRÌNH VÀ GIẢI PHÓNG TẤT CẢ CÁC CỔNG THÀNH CÔNG!")
    print("===============================================================================\n")

if __name__ == "__main__":
    main()
