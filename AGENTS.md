# AGENTS.MD: HƯỚNG DẪN BẮT BUỘC DÀNH CHO AI AGENT & KỸ SƯ PHÁT TRIỂN

> **QUAN TRỌNG NHẤT**: Đây là dự án thực tế đang vận hành tại khách sạn **MerPerle / Khải Vy Hotel**.  
> Mọi AI Agent (Gemini, Claude, GPT, v.v.) hoặc Lập trình viên khi tiếp nhận phiên làm việc mới **BẮT BUỘC PHẢI TUÂN THỦ NGHIÊM NGẶT CÁC QUY TẮC DƯỚI ĐÂY**.

---

## 1. THỨ TỰ ĐỌC TÀI LIỆU BẮT BUỘC (TRƯỚC KHI LÀM BẤT KỲ VIỆC GÌ)

Trước khi viết bất kỳ dòng code nào hoặc trả lời người dùng, bạn PHẢI đọc theo thứ tự:
1. **`AGENTS.md`** (File này)
2. **`PROJECT_DOCUMENTATION/MASTER_PROJECT_CONTEXT.md`** (Bộ nhớ trung tâm của dự án)
3. **`PROJECT_DOCUMENTATION/DEVELOPMENT_PRINCIPLES.md`** (Các nguyên tắc bất biến)
4. **`PROJECT_DOCUMENTATION/FEATURE_INVENTORY.md`** (Danh mục tính năng & trạng thái)
5. **`PROJECT_DOCUMENTATION/KNOWN_ISSUES.md`** (Lỗi đã biết & tránh lặp lại)
6. Các tài liệu kỹ thuật khác trong `PROJECT_DOCUMENTATION/` liên quan trực tiếp đến nhiệm vụ.

---

## 2. NGUYÊN TẮC BẢO VỆ DỰ ÁN CỐT LÕI

* ⛔ **KHÔNG ĐƯỢC TỰ Ý REFACTOR / VIẾT LẠI TỪ ĐẦU**: Hệ thống đang vận hành production ổn định trên server `10.17.10.12`. Mọi phát triển phải kế thừa và mở rộng.
* ⛔ **KHÔNG ĐƯỢC SỬA ĐỔI DATABASE SQL SERVER GỐC (`EMS_KHAIVY`)**: Tuyệt đối không `ALTER TABLE`, không thêm cột lạ, không đổi kiểu dữ liệu. Phần mềm Desktop cũ vẫn đang chạy song song.
* ⛔ **KHÔNG ĐƯỢC LÀM HỎNG CHỨC NĂNG CŨ**: Sau mỗi lần sửa đổi, bắt buộc phải kiểm tra hồi quy (Regression Test) các tính năng: Lịch Sảnh, Tra cứu đơn tiệc, Soạn BEO, Danh mục Items, Đăng nhập và Analytics.
* ⛔ **KHÔNG ĐƯỢC PHÉP BÁO CÁO PASS NẾU CHƯA TEST**: Không được tự tạo kết quả giả lập. Phải chạy kiểm thử thực tế và có bằng chứng xác nhận.
* ⛔ **KHÔNG TỰ Ý CHUYỂN Ý TƯỞNG THÀNH TÍNH NĂNG ĐÃ DUYỆT**: Nếu người dùng chưa yêu cầu, chỉ được ghi nhận dưới dạng ý tưởng chờ phê duyệt.

---

## 3. QUY TRÌNH THỰC HIỆN MỖI KHI CÓ YÊU CẦU MỚI (8 BƯỚC CHUẨN)

1. **BƯỚC 1: ĐỌC** ➔ Đọc `MASTER_PROJECT_CONTEXT.md` và các tài liệu liên quan.
2. **BƯỚC 2: PHÂN TÍCH** ➔ Kiểm tra mã nguồn hiện tại, xác định chính xác vị trí cần can thiệp.
3. **BƯỚC 3: ĐÁNH GIÁ TÁC ĐỘNG** ➔ Liệt kê những gì sẽ đổi, những gì giữ nguyên, rủi ro tiềm ẩn.
4. **BƯỚC 4: ĐỀ XUẤT** ➔ Đưa ra giải pháp an toàn nhất, ít rủi ro nhất, xin ý kiến người dùng nếu cần.
5. **BƯỚC 5: THỰC HIỆN** ➔ Chỉ thực hiện sau khi phương án rõ ràng. Giữ nguyên định dạng và comment.
6. **BƯỚC 6: KIỂM THỬ** ➔ Chạy script kiểm thử Playwright hoặc script tự động, chụp ảnh lưu Artifacts.
7. **BƯỚC 7: CẬP NHẬT BỘ NHỚ** ➔ Cập nhật lại các file trong `PROJECT_DOCUMENTATION/`.
8. **BƯỚC 8: BÁO CÁO** ➔ Nêu rõ các file đã sửa, bằng chứng kiểm thử và những lưu ý cho người dùng.

---

## 4. HẠ TẦNG VÀ ĐỊA CHỈ TRUY CẬP HỆ THỐNG

* **Máy chủ Production**: `10.17.10.12`
* **EMS Banquet Web**: `http://10.17.10.12:8090` (Dịch vụ Windows: `EMS_Banquet_Web`)
* **EMS Banquet Analytics**: `http://10.17.10.12:8088` (Dịch vụ Windows: `EMS_Banquet_Analytics`)
* **Lệnh đồng bộ và Restart sau khi code**: `python d:\DATTIEC\sync_and_restart.py`
