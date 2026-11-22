# HƯỚNG DẪN CÀI ĐẶT VÀ VẬN HÀNH HỆ THỐNG EMS BANQUET
## Gói Portable Trọn Gói (Phương Án B - Chuẩn Doanh Nghiệp MerPerle / Khải Vy Hotel)

---

## 1. TỔNG QUAN GÓI CÀI ĐẶT PORTABLE

Gói **EMS_Banquet_Portable_Bundle** là giải pháp đóng gói độc lập toàn diện, cho phép triển khai hệ thống quản lý tiệc cưới & sự kiện **EMS Banquet** lên bất kỳ máy tính Windows nào (máy trạm mới, máy chủ chi nhánh hoặc laptop cá nhân) chỉ trong vài phút.

### Các ưu điểm vượt trội:
* 🚀 **Cài đặt cực nhanh trong 30 giây**: Tích hợp sẵn Web Setup Wizard trực quan trên cổng 5888 (chuẩn 127.0.0.1 chống nghẽn mạng).
* 📦 **Tích hợp sẵn Python Runtime (Zero-Config)**: Đã nhúng sẵn `python_runtime/` chứa Python 3.12 và toàn bộ thư viện cần thiết. Máy chủ hoặc máy tính mới **HOÀN TOÀN KHÔNG CẦN CÀI PYTHON**.
* 🔍 **Hệ Thống Tự Động Quét Cổng & Chống Xung Đột (Dải Cổng An Toàn 5xxx)**: Mặc định sử dụng dải cổng `5xxx` (Web 5090, Analytics 5088, AI 5092, Wizard 5888), hoàn toàn không xung đột với các dịch vụ đang chạy trên dải 8xxx.
* 💾 **Hỗ trợ 2 chế độ lưu trữ**:
  1. **Microsoft SQL Server**: Tương thích 100% với CSDL EMS Desktop cũ, hỗ trợ mạng nội bộ LAN.
  2. **Pure Google Sheets**: Chạy ngay trên nền tảng đám mây Google Drive, không cần cài đặt SQL Server.
* 🤖 **Tích hợp Phân hệ AI Coding Agent độc lập (Cổng 5092)**: Tự động sao lưu snapshot, xem trước diff, kiểm tra cú pháp trước khi lưu code và hỗ trợ rollback 1-click.
* 🛡️ **An toàn tuyệt đối**: Chạy hoàn toàn độc lập, không làm ảnh hưởng đến hệ thống đang vận hành trên máy chủ chính.

---

## 2. CẤU TRÚC THƯ MỤC BỘ CÀI ĐẶT

```text
EMS_Banquet_Portable_Bundle/
├── EMS_Setup_Wizard.bat        # [1-CLICK] Tự dò cổng trống và mở Trình cài đặt trên cổng 5888
├── start_system.bat            # Khởi động cùng lúc cả 3 phân hệ theo cổng trong config.json (5090, 5088, 5092)
├── run_services.py             # Engine khởi động và giám sát socket dịch vụ
├── stop_system.bat             # Dừng tất cả các dịch vụ đang chạy an toàn
├── force_kill_ports.bat        # [1-CLICK] Dừng triệt để toàn bộ tiến trình và giải phóng sạch cổng 5xxx
├── stop_services.py            # Engine đọc động config.json và giải phóng sạch 100% cổng mạng
├── quan_ly_cong.bat            # [MỚI] Công cụ quét & cho phép chọn tắt riêng từng cổng đang chiếm dụng
├── manage_ports.py             # Engine quét chi tiết PID, Process Name và giải phóng cổng có chọn lọc
├── start_silent.vbs            # [MỚI] Khởi động hệ thống ngầm 100% không bung cửa sổ dòng lệnh CMD
├── install_windows_services.bat# [NÂNG CẤP] Cài đặt Windows Services tự chạy ngầm 100% và tự khởi động lại khi bật máy
├── uninstall_windows_services.bat # Gỡ bỏ Windows Services sạch sẽ
├── tools/
│   └── nssm.exe                # Trình quản lý Windows Service chuyên nghiệp
├── config.json                 # File cấu hình trung tâm (Tên thương hiệu, Database, Cổng 5xxx, Master AI)
├── HUONG_DAN_CAI_DAT_VA_VAN_HANH.md # Tài liệu hướng dẫn này
│
├── python_runtime/             # MÔI TRƯỜNG PYTHON 3.12 PORTABLE ĐÓNG GÓI SẴN (Không cần cài đặt)
│   ├── python.exe
│   ├── DLLs/
│   └── Lib/site-packages/      # Đầy đủ FastAPI, Uvicorn, PyODBC, Pandas, OpenPyXL...
│
├── database_templates/         # Bộ tài nguyên CSDL trích xuất 100% nguyên bản
│   ├── 01_sql_schema_full.sql      # DDL toàn diện 77 bảng, 20 Views, 33 Functions, 90 Procedures
│   ├── 02_sql_master_data.sql      # Dữ liệu danh mục chuẩn & Phân quyền đầy đủ (stGroup, stUserGroup, stUser...)
│   ├── 03_sql_sample_bookings.sql  # 5 Đơn tiệc & BEO mẫu kiểm thử ngắt trang
│   ├── 04_google_sheet_template.json # Template cấu trúc 19 bảng đầy đủ cho Pure Google Sheets
│   └── 04_EMS_Banquet_GoogleSheet_Master_Data.xlsx # File mẫu Excel 19 Tabs có sẵn Master Data để import Google Drive
│
├── setup_wizard/               # Ứng dụng Web Setup Wizard & Port Scanner Engine
│   ├── wizard_app.py
│   └── static/index.html
│
├── ems-web/                    # Phân hệ Web Chính & Soạn BEO
│   ├── app.py
│   ├── data/
│   └── static/
│
├── ems-analytics/              # Phân hệ Báo cáo Doanh thu & Phân tích
│   ├── app.py
│   └── static/
│
└── ems-ai/                     # Phân hệ AI Coding Agent
    ├── app.py
    ├── ai_coder_engine.py
    └── static/index.html
```

---

## 3. HƯỚNG DẪN CÀI ĐẶT TỪNG BƯỚC (QUAN TRỌNG)

### BƯỚC 1: KHỞI ĐỘNG TRÌNH KÍCH HOẠT SETUP WIZARD
1. Nhấp đúp chuột vào file **`EMS_Setup_Wizard.bat`**.
2. Cửa sổ dòng lệnh sẽ tự động khởi động máy chủ cài đặt trên cổng **8888** và mở trình duyệt tại địa chỉ:  
   👉 `http://localhost:8888`

### BƯỚC 2: CHỌN MÔ HÌNH LƯU TRỮ
* **Nếu chọn Microsoft SQL Server (Mô hình Doanh nghiệp)**:
  1. Nhập địa chỉ SQL Server (ví dụ `localhost\MSSQLSERVER2016` hoặc IP máy chủ).
  2. Nhập tên Database muốn tạo (ví dụ `EMS_BANQUET` hoặc `EMS_KHAIVY`).
  3. Nhập tài khoản `sa` và Mật khẩu.
  4. Nhấn **"Kiểm tra kết nối SQL"** -> Khi báo thành công, nhấn **"Tự động Tạo Bảng & Nạp Dữ Liệu"**.  
     *Hệ thống sẽ tự động thực thi 3 file `01_sql_schema_full.sql`, `02_sql_master_data.sql` và `03_sql_sample_bookings.sql`.*
* **Nếu chọn Pure Google Sheets (Mô hình Cloud Miễn phí)**:
  1. Tạo 1 file Google Spreadsheet mới trên Google Drive của bạn.
  2. Sao chép Spreadsheet ID từ URL (đoạn ký tự giữa `/d/` và `/edit`).
  3. Nhập vào ô Google Spreadsheet ID và nhấn **"Khởi tạo Cấu trúc Bảng trên Google Sheet"**.

### BƯỚC 3: CẤU HÌNH CỔNG VÀ MẬT KHẨU AI AGENT (TỰ ĐỘNG CHỐNG TRÙNG CỔNG)
* **Cổng mặc định**: Web (`8090`), Analytics (`8088`), AI Coding Agent (`8092`).
* **Cơ chế Tự Động Quét Cổng (Port Scanner)**:
  - Ngay khi chuyển sang Bước 3, hệ thống sẽ tự động quét trực tiếp trên máy chủ.
  - Cổng khả dụng sẽ hiện màu xanh: `✓ Cổng khả dụng (Sẵn sàng)`.
  - Cổng đang bận sẽ hiện màu đỏ: `⚠ Cổng đang bị chiếm bởi: [Tên tiến trình / PID]`.
  - Nếu có cổng bị chiếm, chỉ cần bấm nút **"⚡ Quét Server & Gợi Ý Cổng Trống"**, hệ thống sẽ tự động tìm và điền các cổng an toàn nhất.
* **Master Password**: Mặc định `Admin@EMS2026` (bảo vệ quyền truy cập AI).
* Nhấn **"Lưu Cấu Hình"**.

### BƯỚC 4: KHỞI ĐỘNG HỆ THỐNG
* Nhấn nút **"KHỞI ĐỘNG HỆ THỐNG NGAY BÂY GIỜ"** hoặc chạy file **`start_system.bat`**.

---

## 4. ĐỊA CHỈ TRUY CẬP VÀ SỬ DỤNG HỆ THỐNG

Sau khi khởi động, người dùng có thể truy cập bằng trình duyệt web theo dải cổng an toàn `5xxx`:

| Phân hệ | Cổng | Đường dẫn | Chức năng chính |
| :--- | :---: | :--- | :--- |
| **EMS Banquet Web** | `5090` | `http://localhost:5090` | Lịch Sảnh, Soạn BEO, Danh mục 20 nhóm A-T, In BEO 2 chiều |
| **EMS Analytics** | `5088` | `http://localhost:5088` | Báo cáo doanh thu đa chiều, Biểu đồ Sảnh, Chi tiết dịch vụ |
| **EMS AI Coding Agent** | `5092` | `http://localhost:5092` | Quản trị mã nguồn, Diff preview, Tự động snapshot & rollback |

---

## 5. HƯỚNG DẪN SỬ DỤNG PHÂN HỆ AI CODING AGENT (CỔNG 5092)

Phân hệ AI Coding Agent chạy độc lập trên Cổng 5092, giúp các kỹ sư và quản trị viên phát triển, kiểm thử mà không lo lỗi sập hệ thống:

1. **Đăng nhập**: Truy cập `http://localhost:5092`, nhập Master Password (mặc định: `Admin@EMS2026`).
2. **Khám phá mã nguồn**: Cây thư mục bên trái liệt kê tất cả các file trong gói dự án. Click vào bất kỳ file nào để nạp nội dung.
3. **Chỉnh sửa & Xem trước Diff (So sánh thay đổi)**:
   - Sửa đổi nội dung trong tab **Code Editor**.
   - Nhấn **"Xem Diff"** -> Hệ thống hiển thị dòng thêm mới màu xanh, dòng xóa màu đỏ.
4. **Áp dụng an toàn (Tự động Snapshot)**:
   - Nhấn **"Áp dụng an toàn"** -> Hệ thống tự động kiểm tra cú pháp Python (`ast.parse`) / JSON. Nếu có lỗi cú pháp, hệ thống sẽ chặn không cho lưu.
   - Trước khi ghi đè, hệ thống tự động tạo 1 bản sao lưu trong thư mục ngầm `.ai_snapshots/` kèm timestamp chính xác.
5. **Khôi phục (Rollback 1-Click)**:
   - Chuyển sang tab **"Lịch Sử Rollback"**, xem danh sách các lần chỉnh sửa và nhấn **"Khôi phục"** để hoàn tác lập tức về trạng thái trước đó.

---

## 6. ĐĂNG KÝ CHẠY TỰ ĐỘNG CÙNG WINDOWS (WINDOWS SERVICES CHẠY NGẦM 100%)

Để hệ thống tự động chạy ngầm mỗi khi bật máy tính mà **hoàn toàn không hiện cửa sổ dòng lệnh (CMD)**:
1. Nhấp chuột phải vào file **`install_windows_services.bat`** -> Chọn **"Run as administrator"**.
2. Hệ thống sử dụng công cụ chuyên nghiệp `tools\nssm.exe` tự động đăng ký 3 dịch vụ Windows với chế độ `SERVICE_AUTO_START`:
   - `EMS_Banquet_Web` (Cổng 5090)
   - `EMS_Banquet_Analytics` (Cổng 5088)
   - `EMS_Banquet_AI` (Cổng 5092)
3. **Đặc điểm nổi bật**:
   - Chạy ngầm 100% dưới nền hệ điều hành (không hiện bất kỳ cửa sổ CMD nào).
   - Tự động chạy lại ngay khi bật/khởi động lại máy tính (kể cả khi chưa đăng nhập Windows).
   - Tự động hồi phục (auto-restart) nếu dịch vụ gặp sự cố đột ngột.
   - Toàn bộ log vận hành được lưu tự động tại thư mục `logs/`.
4. Nếu muốn tắt hoặc gỡ bỏ dịch vụ: Nhấp chuột phải vào **`uninstall_windows_services.bat`** -> Chọn **"Run as administrator"**.

---

## 7. CÔNG CỤ QUẢN LÝ VÀ CHỌN TẮT CỔNG CHỌN LỌC (SELECTIVE PORT MANAGER)

Khi cần giải phóng cổng mà không muốn tắt nhầm các ứng dụng khác của hệ thống:
1. **Cách 1 (Giao diện Web Setup Wizard)**:
   - Truy cập Bước 3 của Wizard (`http://localhost:5888`).
   - Bảng trạng thái cổng sẽ tự động quét danh sách các cổng đang chạy, kèm tên tiến trình và PID.
   - Bấm nút **[🔴 Giải phóng]** bên cạnh đúng cổng bạn muốn tắt.
2. **Cách 2 (Công cụ Console Tương Tác `quan_ly_cong.bat`)**:
   - Chạy file `quan_ly_cong.bat` (khuyến nghị Run as Administrator).
   - Màn hình sẽ hiển thị bảng danh sách các cổng đang bị chiếm, số hiệu PID và Process Name.
   - Bạn chỉ cần gõ số thứ tự `[1]`, `[2]...` hoặc gõ `[A]` để nhập một cổng bất kỳ (ví dụ 5123) và xác nhận `Y` để tắt chính xác tiến trình đó.
3. Khi muốn gỡ bỏ dịch vụ: Nhấp chuột phải vào **`uninstall_windows_services.bat`** -> Chọn **"Run as administrator"**.

---

## 7. XỬ LÝ SỰ CỐ THƯỜNG GẶP (TROUBLESHOOTING)

1. **Trùng cổng (Port in use - 8090 / 8088 / 8092)**:
   - Nhấp đúp chuột vào file **`stop_system.bat`** để giải phóng cổng.
   - Sau đó chạy lại **`start_system.bat`**.
2. **Không kết nối được SQL Server**:
   - Kiểm tra xem dịch vụ SQL Server (MSSQLSERVER hoặc SQLEXPRESS) trong `services.msc` đã ở trạng thái **Running** chưa.
   - Kiểm tra SQL Server Configuration Manager đã bật giao thức **TCP/IP** (Port 1433) chưa.
3. **Font chữ tiếng Việt trong file .bat**:
   - Tất cả các script `.bat` đã tích hợp lệnh `chcp 65001` để hiển thị tiếng Việt UTF-8 chuẩn xác.
