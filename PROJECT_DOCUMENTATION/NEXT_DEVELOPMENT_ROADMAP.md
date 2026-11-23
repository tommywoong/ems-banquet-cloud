# NEXT DEVELOPMENT ROADMAP: ĐỊNH HƯỚNG PHÁT TRIỂN TIẾP THEO

> **LỘ TRÌNH KẾ THỪA VÀ PHÁT TRIỂN HỆ THỐNG EMS BANQUET**  
> *Phiên bản: 2.0 (Verified by Technical Lead Audit)*  
> *Được lập dựa trên hiện trạng vận hành thực tế và kết quả đối chiếu CSDL gốc `stMenu`.*

---

## 1. TÌNH TRẠNG VẬN HÀNH HIỆN TẠI (CURRENT STATUS)

* **Trạng thái phân hệ cốt lõi**: **HOÀN THÀNH 100% CÁC YÊU CẦU ĐÃ ĐẶT RA**
  * Toàn bộ 2 phân hệ Web (Cổng 8090) và Analytics (Cổng 8088) đã chạy ổn định vĩnh viễn trên máy chủ `10.17.10.12` dưới dạng Windows Services.
  * Lịch Sảnh Tiệc (Scheduler Matrix đa ngày), Quản lý Đơn tiệc, Soạn & In BEO 9 bộ phận, 20 Danh mục Items A - T (phân cấp chuẩn Customer & Function Room), Hệ thống Nhật ký thao tác (Audit Trail) đều đã kiểm thử và hoạt động hoàn hảo.
  * Không có lỗi tồn đọng cản trở công việc hàng ngày của khách sạn.

---

## 2. PHÂN LOẠI CÁC HẠNG MỤC PHÁT TRIỂN TIẾP THEO

### Nhóm 1: Các Chức Năng Desktop Gốc Có Thể Chuyển Đổi Bổ Sung (Khi Người Dùng Yêu Cầu)
> **Lưu ý cho AI Agent**: Đây là các form/menu có trên Desktop cũ (`stMenu`), hiện tại trên Web chưa có giao diện. Khi người dùng yêu cầu mới được triển khai:

1. **`LEGACY-01`: Màn hình Quản lý Phân quyền chi tiết (`frmRightAccess`)**:
   * *Mục đích*: Cho phép Admin tích chọn quyền xem/sửa/xóa theo từng vai trò hoặc nhóm người dùng trên giao diện Web.
   * *Trạng thái*: **Chờ người dùng duyệt**.
2. **`LEGACY-02`: Màn hình Tự Đổi Mật Khẩu (`frmChangePw`)**:
   * *Mục đích*: Cho phép nhân viên tự đổi mật khẩu tài khoản trực tiếp trên giao diện Web.
   * *Trạng thái*: **Chờ người dùng duyệt**.
3. **`LEGACY-03`: Báo cáo Từ chối Tiệc (`frmTurndown_Bussiness`)**:
   * *Mục đích*: Thống kê các lý do khách hủy tiệc hoặc khách sạn từ chối nhận tiệc do trùng sảnh.
   * *Trạng thái*: **Chờ người dùng duyệt**.
4. **`LEGACY-04`: Báo cáo Sảnh / Phòng miễn phí (`frmDsachPhong_notCharges`)**:
   * *Mục đích*: Thống kê các tiệc nội bộ, tiệc FOC (Free of Charge) không tính phí thuê sảnh.
   * *Trạng thái*: **Chờ người dùng duyệt**.
5. **`LEGACY-05`: Báo cáo Xếp hạng Khách hàng Thân thiết (`frmTop_FrequentCustomer`)**:
   * *Mục đích*: Thống kê top khách hàng đặt tiệc nhiều nhất theo năm/quý.
   * *Trạng thái*: **Chờ người dùng duyệt**.

---

### Nhóm 2: Các Tính Năng Tiện Ích Mở Rộng Tiềm Năng (Future Enhancements)
1. **Phân hệ Trợ lý AI Agent & AI Lab (Cổng riêng 8092)**:
   * *Mục đích*: Cổng thí nghiệm và trợ lý AI thông minh độc lập trên Port 8092, tách biệt hoàn toàn với hệ thống sản xuất 8090/8088.
   * *Bảo mật*: Khóa Master `LuanTam@233267` (mã hóa SHA-256 + Salt), hỗ trợ giao diện đổi mật khẩu tự phục vụ, chống brute-force.
   * *Kết nối Agent*: Tích hợp linh hoạt Google Gemini Pro (2M context), DeepSeek V3/R1, Claude 3.5 Sonnet, Local/Groq.
   * *Cơ chế an toàn*: Đọc tri thức `AI_AGENT_KNOWLEDGE_BASE.json`, Diff Preview so sánh trước khi sửa code, 1-Click Rollback dựa trên hệ thống Snapshot kép tự động.
   * *Trạng thái*: **ĐÃ PHÊ DUYỆT THIẾT KẾ - CHỜ TRIỂN KHAI THEO LỆNH NGƯỜI DÙNG**.

2. **Xuất báo cáo và danh sách ra file Excel (`.xlsx`)**:
   * *Mục đích*: Cho phép nhân viên tải danh sách đơn tiệc, danh bạ khách hàng CRM hoặc bảng kê BEO ra file Excel.
   * *Trạng thái*: **Chờ người dùng duyệt**.
3. **Thông báo tự động qua Email / Zalo (ZNS / SMTP)**:
   * *Mục đích*: Tự động gửi email/zalo cho các bộ phận Bếp, F&B, Kỹ thuật khi có tiệc chốt hoặc dời lịch.
   * *Trạng thái*: **Chờ người dùng duyệt**.
4. **`ENH-03`: Quản lý Trạng thái No-Show (Khách Không Đến) & Tự Động Nhận Diện Tiệc Quá Hạn Chưa Lập BEO**:
   * *Mục đích*: Quản lý và thống kê các đơn tiệc đã chốt giữ sảnh (Definite - D) nhưng đến khi qua ngày sự kiện mà không tổ chức/không phát hành BEO.
   * *Khảo sát kỹ thuật & Dữ liệu CSDL*: Bảng danh mục gốc `stBooking_Status` trong SQL Server `EMS_KHAIVY` đã có sẵn mã `'N'` (No-Show, Order 5). Cột `stBooking.fcStatus_BkRoom` hỗ trợ lưu trực tiếp không cần sửa đổi bảng hay kiểu dữ liệu, bảo đảm an toàn 100% cho CSDL và phần mềm Desktop cũ.
   * *Nguyên tắc nghiệp vụ*: Doanh thu tiệc ẩm thực tính bằng 0 (tránh ảo doanh thu); bảo toàn tiền cọc `fnDatCoc` để kiểm soát phạt cọc; hiển thị badge màu tím/xám trên Lịch sảnh Scheduler.
   * *Phương án xử lý*: Đã phân tích 2 phương án (Lựa chọn 1: Gợi ý duyệt 1-Click cho Quản lý / Lựa chọn 2: Tự động gán cờ ngầm theo ngày).
   * *Trạng thái*: **ĐÃ HOÀN THÀNH PHÂN TÍCH KỸ THUẬT - ĐANG LƯU HỒ SƠ CHỜ NGƯỜI DÙNG PHÊ DUYỆT PHƯƠNG ÁN**.
5. **`USER-01`: Phân Hệ Quản Trị Người Dùng & Phân Quyền Admin Tối Cao (adminems & NTTL) Đồng Bộ SQL Server**:
   * *Mục đích*: Tạo tài khoản quản trị tối cao `adminems` trên CSDL SQL Server, nâng toàn quyền Admin cho `NTTL`, xây dựng màn hình Quản trị Tài khoản trên Dashboard riêng cho 2 tài khoản này, và chuẩn bị cơ chế quản lý mật khẩu theo từng giai đoạn an toàn.
   * *Quy định vận hành & Lộ trình triển khai (Theo chỉ đạo ngày 21/11/2026)*:
     - **Tài khoản `adminems`**: Tạo trong `stUser` với mật khẩu băm `PWDENCRYPT('LuanTam@233267')`, gán nhóm `G017` (ADMIN SUPPORT) trong `stUserGroup`. Toàn quyền quản trị hệ thống trên cả EMS Web và Cana Desktop.
     - **Tài khoản `NTTL`**: Cấp toàn quyền Quản trị tối cao ngang hàng với `adminems` và `ADMIN`, cập nhật nhóm `G017` trong `stUserGroup`.
     - **Màn hình Quản Trị Tài Khoản (User & Role Management)**: Chỉ xuất hiện trên thanh menu Dashboard khi `adminems` hoặc `NTTL` đăng nhập. Cho phép xem danh sách nhân sự, phân nhóm quyền (`stUserGroup`), cập nhật thông tin và chủ động thiết lập mật khẩu (`stUser.fcPassword`).
     - **Chính sách Mật khẩu theo từng giai đoạn (Phased Security Rollout)**:
       + *Hiện tại*: Giữ nguyên cơ chế đăng nhập thuận tiện như hiện nay cho nhân viên, tuyệt đối không gây gián đoạn công việc của khách sạn.
       + *Sau này*: Chỉ sau khi `adminems` hoặc `NTTL` chủ động set password cho tài khoản trong phần quản trị, hệ thống mới bắt đầu áp dụng chế độ bắt buộc nhập mật khẩu. Mật khẩu được mã hóa trực tiếp bằng `PWDENCRYPT` của SQL Server, đảm bảo đồng bộ hoàn hảo trên cả EMS Web và Cana Desktop.
   * *Trạng thái*: **HOÀN THÀNH 100% & ĐÃ KIỂM THỬ XÁC THỰC BẰNG CHỨNG (COMPLETED)**. Bằng chứng Playwright: `verified_adminems_user_management.png`, `verified_nttl_admin_access.png`, `verified_staff_lvh_hidden_admin_menu.png`.

---

### Nhóm 3: Công Tác Bảo Trì & Giám Sát Định Kỳ
1. **Bảo trì file `audit.db` (SQLite)**:
   * Theo dõi dung lượng file sau mỗi 6 tháng - 1 năm. Nếu vượt quá 500MB, xây dựng tính năng nén và lưu trữ lịch sử (Archiving).
2. **Tối ưu hóa phân trang danh bạ khách hàng CRM**:
   * Khi số lượng khách hàng trong `stKhachHang` vượt quá 5.000 khách, bổ sung cơ chế phân trang phía máy chủ (`Server-side Pagination`) cho endpoint `/api/items/customer_guest`.
