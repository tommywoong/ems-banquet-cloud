# DEVELOPMENT PRINCIPLES: NGUYÊN TẮC PHÁT TRIỂN & BẢO TOÀN DỰ ÁN EMS

> **BỘ QUY TẮC BẤT BIẾN DÀNH CHO LẬP TRÌNH VIÊN VÀ AI AGENT**  
> *Được đúc kết từ toàn bộ quá trình phát triển, các lần sửa lỗi và các chỉ đạo trực tiếp của người dùng.*

---

## 1. NGUYÊN TẮC BẢO TOÀN HỆ THỐNG CŨ (SỐNG CÒN)

1. **Tuyệt đối không xóa, không làm hỏng chức năng cũ**:
   Khi bổ sung tính năng mới hoặc sửa một tính năng bất kỳ, phải bảo đảm 100% các tính năng khác đã hoàn thành (như Lịch sảnh, Tra cứu đơn tiệc, Soạn BEO, Danh mục Items, Thống kê Analytics) tiếp tục hoạt động bình thường.
2. **Không tự ý refactor hay viết lại từ đầu**:
   Mọi module đang chạy tốt (FastAPI backend, SPA frontend, SQLite audit) phải được kế thừa. Không được tự ý thay thế công nghệ, không chuyển đổi framework khi chưa có yêu cầu và sự đồng ý bằng văn bản của người dùng.
3. **Không tự ý loại bỏ code hay các trường dữ liệu**:
   Không xóa bất kỳ API endpoint, bảng dữ liệu, cột CSDL hay hàm xử lý nghiệp vụ nào với suy đoán cá nhân rằng "chắc không cần tới".

---

## 2. NGUYÊN TẮC CƠ SỞ DỮ LIỆU SQL SERVER GỐC

1. **Bảo vệ toàn vẹn CSDL `EMS_KHAIVY`**:
   Phần mềm Desktop EMS cũ vẫn có thể được mở và sử dụng tại khách sạn. Vì vậy:
   * **CẤM** chạy lệnh `ALTER TABLE`, `DROP TABLE`, `DROP COLUMN` trên database `EMS_KHAIVY`.
   * **CẤM** đổi tên bảng, đổi tên cột hoặc thay đổi kiểu dữ liệu đã có.
   * **CẤM** thêm các bảng hoặc cột lạ vào CSDL gốc. Nếu hệ thống Web cần lưu trữ bổ sung (ví dụ: Audit Log, Session Cache), bắt buộc phải lưu ở kho lưu trữ riêng (như file SQLite `audit.db`).
2. **Tuân thủ quy ước tên cột và khóa chính của phần mềm gốc**:
   * Khóa chính của bảng khách hàng `stKhachHang` là `fcMa`.
   * Khóa chính của `stDatTiec` là `fcMa`.
   * Các bảng danh mục loại phòng, loại khách, kiểu setup dùng `fcCode` hoặc `fcMa` tùy bảng, phải kiểm tra kỹ schema trước khi viết câu truy vấn.

---

## 3. NGUYÊN TẮC NGHIỆP VỤ & TÍNH TOÁN

1. **Quy tắc Trạng thái Hủy ('C')**:
   Đơn tiệc có trạng thái `'C'` (`Cancelled`) **tuyệt đối không được tính vào doanh thu**. Khi thống kê, phải lọc điều kiện `fcStatus != 'C'` hoặc `fcStatus IN ('D', 'T')` tùy loại báo cáo.
2. **Quy tắc Phân biệt Doanh Thu**:
   * Bắt buộc phải hiển thị tách biệt 2 cột: **Doanh thu tiệc** (`fnDoanhThu_Tiec` / `banquet_rev`) và **Tổng doanh thu** (`fnDoanhThu_Tong` / `total_rev`).
   * Tuyệt đối không được gộp chung thành một số duy nhất.
3. **Quy tắc Ghi nhận Doanh Thu theo Nhân Viên**:
   Doanh thu tiệc được tính cho **Người phụ trách làm BEO** (`fcMaNV_BEO`), không được tính cho người chỉ thao tác bấm nút khóa tiệc (`fcUserLock`).
4. **Quy tắc Kéo thả Lịch Sảnh Tiệc (Scheduler)**:
   Khi dời lịch hoặc đổi sảnh bằng thao tác kéo thả (Drag & Drop), hệ thống **bắt buộc phải kiểm tra xung đột khung giờ và sảnh tiệc**. Nếu khung giờ mới bị trùng với một tiệc khác đang có tại sảnh đó, hệ thống phải phát cảnh báo từ chối và tự động hoàn trả thẻ tiệc về vị trí ban đầu.
5. **Quy tắc 9 Bộ Phận Chỉ Đạo BEO**:
   Lệnh BEO bắt buộc phải có đầy đủ 9 bộ phận:
   1. Nhà hàng (F&B - 001)
   2. Buồng phòng (Housekeeping - HK - 002)
   3. Bảo trì (Maintenance - 003)
   4. Ban sự kiện (BQT - 004)
   5. Tiền sảnh (Front Office - 006)
   6. Bếp (Kitchen - 008)
   7. ATAS (Âm thanh - Ánh sáng - 010)
   8. Kỹ thuật * IT (013)
   9. Thu ngân (Cashier - 015)

---

## 4. NGUYÊN TẮC GIAO DIỆN & TRẢI NGHIỆM NGƯỜI DÙNG (UI/UX)

1. **Màn hình Đăng Nhập thuần thủ công**:
   Chỉ cho phép người dùng gõ mã nhân viên và mật khẩu thủ công. **Không dùng ô chọn nhanh dropdown, không dùng thẻ `<datalist>` gợi ý tài khoản đè lên giao diện.**
2. **Bảo tồn Phong cách Thẩm mỹ Luxury Dark Theme**:
   Mục 3. Items và các phân hệ quản trị sử dụng bảng màu **Navy / Indigo Gradient kết hợp viền ánh vàng kim (Amber Gold)** sang trọng, tạo cảm giác chuyên nghiệp cho phần mềm khách sạn cao cấp.
3. **Tổ chức Phân cấp Menu Chuẩn Desktop Dropdown**:
   * Mục `A. Customer` và `B. Function Room` chỉ chiếm đúng 1 ô tiêu chuẩn trong lưới 20 danh mục (A – T).
   * **Bình thường KHÔNG được bung các menu con ra ngoài màn hình.**
   * Chỉ khi người dùng click vào mới xổ xuống menu popup kính tối nổi bật. Khi chọn xong, menu tự đóng lại và ô cha sáng đèn highlight.
4. **Tối ưu hóa hiển thị cho mọi dòng Laptop / Desktop**:
   Chiều cao của các thanh điều hướng phải được giữ ở mức vừa vặn, đảm bảo trên các màn hình laptop phổ thông (1366x768 hoặc màn hình 14 inch) người dùng vẫn nhìn thấy trọn vẹn Bảng Dữ Liệu mà không phải cuộn chuột tìm kiếm.

---

## 5. NGUYÊN TẮC VẬN HÀNH & KIỂM THỬ

1. **Cấm báo cáo PASS nếu chưa thực tế chạy kiểm thử**:
   Mọi thay đổi code bắt buộc phải được kiểm thử tự động (bằng Playwright hoặc script kiểm tra) và chụp ảnh lưu vào Artifacts làm bằng chứng trước khi báo cáo hoàn thành cho người dùng.
2. **Cách thức vận hành trên Server `10.17.10.12`**:
   * Ứng dụng chạy dưới dạng Windows Services vĩnh viễn (NSSM).
   * **Không mở các cửa sổ cmd/terminal chạy file `.py` thủ công trên máy client**.
   * Mọi cập nhật code phải được đồng bộ sang `\\10.17.10.12\emsmdh` và ra lệnh khởi động lại service qua `sync_and_restart.py`.

---

## 6. NHỮNG TRƯỜNG HỢP BẮT BUỘC PHẢI HỎI Ý KIẾN NGƯỜI DÙNG

1. Khi phát hiện yêu cầu mới có xung đột với nguyên tắc cũ đã thống nhất.
2. Khi cần xóa hoặc điều chỉnh một quy trình nghiệp vụ đã có.
3. Khi cần bổ sung một bảng mới hoặc thay đổi kiến trúc hạ tầng mạng/cổng dịch vụ.
4. Khi có sự khác biệt giữa tài liệu đặc tả và thói quen thao tác thực tế của nhân viên khách sạn.
