import os
import sys
import subprocess
import re

COMMON_PORTS = [5088, 5090, 5092, 5123, 5255, 5888, 8088, 8090, 8092, 8888, 8999]

def get_process_name(pid):
    try:
        res = subprocess.run(["tasklist", "/FI", f"PID eq {pid}", "/FO", "CSV", "/NH"],
                             capture_output=True, text=True, timeout=5)
        out = res.stdout.strip()
        if out and "," in out:
            return out.split(",")[0].replace('"', "").strip()
    except Exception:
        pass
    return "Unknown"

def scan_ports(port_list):
    active = []
    try:
        res = subprocess.run(["netstat", "-ano", "-p", "tcp"],
                             capture_output=True, text=True, timeout=10)
        lines = res.stdout.splitlines()
        seen_pids = set()
        for line in lines:
            line = line.strip()
            if "LISTENING" not in line:
                continue
            parts = re.split(r"\s+", line)
            if len(parts) >= 5:
                local_addr = parts[1]
                pid = parts[-1]
                if ":" in local_addr:
                    port_str = local_addr.split(":")[-1]
                    try:
                        port = int(port_str)
                        if port in port_list:
                            key = (port, pid)
                            if key not in seen_pids:
                                seen_pids.add(key)
                                pname = get_process_name(pid)
                                active.append({
                                    "port": port,
                                    "pid": pid,
                                    "pname": pname
                                })
                    except ValueError:
                        pass
    except Exception as e:
        print(f"[!] Lỗi khi quét netstat: {e}")
    return sorted(active, key=lambda x: x["port"])

def kill_pid(pid, port, pname):
    print(f"\n[*] Đang gửi lệnh đóng tiến trình {pname} (PID: {pid}) trên cổng {port}...")
    try:
        res = subprocess.run(["taskkill", "/F", "/PID", str(pid)],
                             capture_output=True, text=True, timeout=5)
        if res.returncode == 0:
            print(f"[+] ĐÃ TẮT THÀNH CÔNG tiến trình {pname} (PID: {pid}). Cổng {port} hiện đã được giải phóng!")
        else:
            print(f"[-] Không thể tắt tiến trình: {res.stderr.strip()}")
    except Exception as e:
        print(f"[!] Lỗi khi tắt PID: {e}")

def main():
    while True:
        os.system("cls" if os.name == "nt" else "clear")
        print("=" * 65)
        print("   EMS BANQUET - CÔNG CỤ QUÉT & QUẢN LÝ CỔNG (CHỌN LỌC)")
        print("=" * 65)
        print(" Quét các cổng phổ biến của hệ thống EMS:")
        print(f" {', '.join(str(p) for p in COMMON_PORTS)}")
        print("-" * 65)
        
        active = scan_ports(COMMON_PORTS)
        if not active:
            print(" [OK] Tất cả các cổng EMS phổ biến hiện đều ĐANG RẢNH (Không có xung đột)!")
        else:
            print(" DANH SÁCH CÁC CỔNG ĐANG CÓ TIẾN TRÌNH CHIẾM DỤNG:")
            print(f" {'STT':<5} | {'CỔNG':<7} | {'PID':<8} | {'TIẾN TRÌNH (PROCESS)':<30}")
            print("-" * 65)
            for idx, item in enumerate(active, 1):
                print(f" [{idx:<2}]  | {item['port']:<7} | {item['pid']:<8} | {item['pname']:<30}")

        print("-" * 65)
        print(" LỰA CHỌN THAO TÁC:")
        if active:
            print("  [1..{}] : Nhập số thứ tự để TẮT RIÊNG cổng đó".format(len(active)))
        print("  [A]     : Nhập số cổng bất kỳ (custom port) để kiểm tra & tắt")
        print("  [R]     : Quét lại danh sách (Refresh)")
        print("  [Q]     : Thoát công cụ")
        print("=" * 65)

        choice = input(" Vui lòng nhập lựa chọn của bạn: ").strip().upper()
        if choice == "Q":
            print("\nĐã thoát.")
            break
        elif choice == "R" or choice == "":
            continue
        elif choice == "A":
            custom_port_str = input(" Nhập số cổng bạn muốn kiểm tra (ví dụ 5123, 8090): ").strip()
            try:
                cport = int(custom_port_str)
                c_active = scan_ports([cport])
                if not c_active:
                    print(f"\n[OK] Cổng {cport} đang hoàn toàn RẢNH!")
                else:
                    item = c_active[0]
                    print(f"\n[!] Cổng {cport} đang bị chiếm bởi {item['pname']} (PID: {item['pid']})")
                    cf = input(f" Bạn có muốn tắt tiến trình này không? (Y/N): ").strip().upper()
                    if cf == "Y":
                        kill_pid(item["pid"], item["port"], item["pname"])
            except ValueError:
                print("[!] Số cổng không hợp lệ!")
            input("\nBấm Enter để tiếp tục...")
        else:
            try:
                num = int(choice)
                if 1 <= num <= len(active):
                    target = active[num - 1]
                    cf = input(f" Xác nhận tắt tiến trình {target['pname']} (PID: {target['pid']}) tại cổng {target['port']}? (Y/N): ").strip().upper()
                    if cf == "Y":
                        kill_pid(target["pid"], target["port"], target["pname"])
                    else:
                        print(" Đã hủy thao tác.")
                else:
                    print("[!] Số thứ tự ngoài danh sách.")
            except ValueError:
                print("[!] Lựa chọn không hợp lệ.")
            input("\nBấm Enter để tiếp tục...")

if __name__ == "__main__":
    main()
