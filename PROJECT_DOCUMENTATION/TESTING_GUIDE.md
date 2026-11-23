# TESTING GUIDE: HƯỚNG DẪN KIỂM THỬ HỆ THỐNG EMS BANQUET

> **QUY CHUẨN KIỂM THỬ HỒI QUY (REGRESSION TESTING) & KIỂM THỬ TỰ ĐỘNG BẰNG PLAYWRIGHT**

---

## 1. CÁCH KHỞI ĐỘNG VÀ VẬN HÀNH DỰ ÁN

### 1.1. Môi trường Sản xuất (Server `10.17.10.12`)
Hệ thống chạy tự động vĩnh viễn dưới dạng **Windows Services**. Không cần chạy lệnh tay.
* **EMS Banquet Web**: `http://10.17.10.12:8090`
* **EMS Banquet Analytics**: `http://10.17.10.12:8088`

### 1.2. Kiểm tra tình trạng sức khỏe dịch vụ (Health Check)
Chạy script kiểm tra từ máy bất kỳ trong mạng LAN:
```python
import urllib.request
for name, url in [('Web', 'http://10.17.10.12:8090/api/health'), ('Analytics', 'http://10.17.10.12:8088/api/health')]:
    try:
        with urllib.request.urlopen(url, timeout=3) as resp:
            print(f"{name}: {resp.status} OK")
    except Exception as e:
        print(f"{name} Error: {e}")
```

### 1.3. Lệnh đồng bộ code và Restart Services sau khi sửa file
Từ thư mục dự án `d:\DATTIEC\`, chạy lệnh:
```powershell
python d:\DATTIEC\sync_and_restart.py
```
Hoặc click đúp chuột vào file:
```cmd
d:\DATTIEC\deploy_to_server.bat
```

---

## 2. BỘ KỊCH BẢN KIỂM THỬ BẮT BUỘC (REGRESSION TEST SUITE)

Mỗi khi có bất kỳ thay đổi nào trong mã nguồn, bắt buộc phải chạy các kịch bản kiểm thử sau:

### Kịch bản 1: Màn hình Đăng Nhập Thủ Công (TC-AUTH)
1. Mở trang `http://10.17.10.12:8090`.
2. Kiểm tra:
   * Form đăng nhập xuất hiện sạch sẽ.
   * **KHÔNG CÓ** dropdown chọn nhanh tài khoản.
   * **KHÔNG CÓ** danh sách gợi ý datalist đè lên màn hình.
3. Nhập `Username`: `NTTL`, `Password`: để trống.
4. Bấm `Đăng nhập vào hệ thống`.
5. *Kỳ vọng*: Đăng nhập thành công, góc trên bên phải hiển thị tên `NGUYỄN THỊ THANH LAM (NTTL)`.

### Kịch bản 2: Ma trận Lịch Sảnh Tiệc (TC-SCHED)
1. Truy cập tab `1. Lịch Sảnh Tiệc (Scheduler)`.
2. Kiểm tra:
   * Ma trận đa ngày tải dữ liệu của 12 sảnh tiệc.
   * Các ca tiệc (Sáng, Trưa, Tối) hiển thị đúng màu trạng thái: Đã chốt (Xanh lá - Definite), Giữ chỗ (Vàng cam - Tentative).
   * Thanh cuộn ngang dính mép dưới hoạt động mượt mà.
3. Kéo thử một tiệc sang sảnh khác:
   * Nếu ô đích không trùng giờ: Tiệc được di chuyển, ghi nhận vào audit log.
   * Nếu ô đích bị trùng giờ với tiệc khác: Hệ thống phát cảnh báo và hoàn lại vị trí cũ.

### Kịch bản 3: Tra cứu & Kiểm tra Doanh Thu Đơn Tiệc (TC-BOOK)
1. Truy cập tab `2. Quản Lý Đơn Tiệc`.
2. Chọn khoảng ngày tìm kiếm (ví dụ: Tháng 11/2026).
3. Kiểm tra:
   * Bảng hiển thị tách biệt 2 cột: **Doanh thu tiệc** và **Tổng doanh thu**.
   * Đơn tiệc có trạng thái hủy (`C`) không được cộng vào tổng doanh thu.
4. Bấm vào nút `Xem / Sửa` của 1 tiệc bất kỳ:
   * Popup chi tiết mở ra đủ 4 Tab (Khách hàng CRM, Lịch sảnh, Bảng kê chi phí, BEO & Chỉ đạo).

### Kịch bản 4: Soạn thảo & In ấn Lệnh BEO (TC-BEO)
1. Truy cập tab `3. Lập & In Lệnh BEO`.
2. Chọn đơn tiệc `MINH TRÍ THÀNH (11/11/2026)`.
3. Kiểm tra:
   * Đủ 9 ô phân công chỉ đạo bộ phận (F&B, Buồng phòng, Bảo trì, BQT, Tiền sảnh, Bếp, ATAS, Kỹ thuật * IT, Thu ngân).
   * Bảng kê chi phí có nút chọn nhanh (Teabreak 130k, Thuê sảnh, LED P3,...).
   * Dropdown 87 loại dịch vụ từ SQL Server tải đầy đủ.
4. Bấm nút `In Lệnh BEO`: Mẫu in chuẩn A4 hiện ra sắc nét, không bị tràn dòng.

### Kịch bản 5: Quản lý 20 Danh mục Chuẩn (TC-ITEMS)
1. Truy cập tab `3. Items (Danh Mục A - T)`.
2. Kiểm tra:
   * Lưới 20 danh mục hiển thị đủ 4 hàng x 5 cột = 20 ô vuông vức.
   * Mục `A. Customer` và `B. Function Room` **KHÔNG BUNG** 3 mục con ra ngoài màn hình.
3. Bấm vào `A. Customer`:
   * Menu popup kính tối xổ xuống gồm đúng 3 mục: `a. Guest Info.`, `b. Kind of Guests`, `c. Market Segmentation`.
4. Bấm chọn `b. Kind of Guests`:
   * Popup tự đóng, ô Customer sáng đèn highlight vàng kim.
   * Bảng dữ liệu tải đủ 11 bản ghi từ bảng `stKhachHang_Loai`.
5. Bấm nút `Thêm Mới`: Modal tạo item mở ra với đúng các trường `Mã loại khách`, `Tên loại khách`, `Ghi chú`.

### Kịch bản 6: Hệ thống Báo cáo Phân tích Analytics (TC-ANA)
1. Truy cập `http://10.17.10.12:8088`.
2. Kiểm tra:
   * Thống kê theo phân khúc thị trường (Market Segment).
   * Thống kê tần suất và doanh thu từng sảnh tiệc.
   * Doanh thu loại trừ các đơn hủy trạng thái `C`.
   * Bấm `In Báo Cáo Thống Kê`: Trang in chuẩn format phục vụ ban giám đốc.

### Kịch bản 7: Kiểm thử BEO Sự Kiện Nhiều Ngày (TC-MULTIDAY-BEO)
1. Truy cập tab `3. Lập & In Lệnh BEO`.
2. Chọn đơn sự kiện nhiều ngày (ví dụ `MINH TRÍ THÀNH 73299 - NLMT26_1000000036`).
3. Kiểm tra:
   * Thanh điều hướng `SỰ KIỆN NHIỀU NGÀY (MULTI-DAY BEO)` hiển thị trên đầu BEO.
   * Đủ 6 nút chọn ngày con: `[Ngày 1 (15/11/2026)] [Ngày 2 (16/11/2026)] ... [Ngày 6 (20/11/2026)]`.
   * Bấm sang `Ngày 2`: Giao diện nạp đúng lệnh con `20261112130818349_02`, đúng 3 ca của ngày 16/11.
   * Bấm `In Phiếu BEO (Chuẩn MerPerle A4)`: Mẫu in xuất ra đúng 3 ca của ngày đó, không bị dồn 18 ca.

### Kịch bản 8: Kiểm thử Hồi Quy Toàn Diện & Chống Cache Mọi Trình Duyệt (TC-REGRESSION-FULL)
Chạy script kiểm thử hồi quy 11 kịch bản tích hợp:
```bash
python d:\DATTIEC\regression_test_full.py
```
Script này tự động:
1. Xác minh Header HTTP `Cache-Control: no-store, no-cache...` trên cả 8090 và 8088.
2. Kiểm tra API `/api/system/version` trả về đúng phiên bản build `2026.11.20.02`.
3. Kiểm tra tính sẵn sàng của 4 bộ thư viện vendor nội bộ (`tailwind`, `lucide`, `xlsx`, `chart.js`).
4. Kiểm tra chức năng Đăng nhập thủ công (`/api/auth/login`).
5. Kiểm tra tải ma trận Lịch sảnh Scheduler (`/api/scheduler`).
6. Kiểm tra truy vấn danh sách 1.705 đơn tiệc (`/api/bookings/list`).
7. Kiểm tra tách BEO nhiều ngày riêng từng ngày (`/api/beo/...`).
8. Kiểm tra nạp 26 danh mục cấu hình Items (`/api/items/config`).
9. Kiểm tra báo cáo doanh thu & phân khúc Analytics (`/api/summary`, `/api/stats/segments`).
10. Chạy trình duyệt Playwright headless kiểm tra render giao diện và chụp ảnh lưu Artifacts.

---

## 3. FILE SCRIPT KIỂM THỬ TỰ ĐỘNG PLAYWRIGHT CÓ SẴN

Hệ thống đã có sẵn file script kiểm thử tự động toàn diện:
```bash
python d:\DATTIEC\verify_luxury_dark_ui.py
```
Script này tự động:
* Khởi động trình duyệt Chromium mô phỏng màn hình laptop 1366x768.
* Tự động đăng nhập với tài khoản `NTTL`.
* Điều hướng vào tab Items, kiểm tra trạng thái popup `Customer` (đảm bảo `hidden=True` ban đầu).
* Tự động click mở popup, kiểm tra 3 mục con, chọn `b. Kind of Guests`, đếm 11 dòng dữ liệu.
* Chụp ảnh màn hình lưu vào Artifacts làm bằng chứng kiểm toán.
