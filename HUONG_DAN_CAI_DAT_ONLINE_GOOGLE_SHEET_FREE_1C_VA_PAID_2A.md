# HƯỚNG DẪN CHI TIẾT TỪNG BƯỚC: TRIỂN KHAI EMS BANQUET ONLINE 24/7 QUA GOOGLE SHEETS
## (Phương Án Miễn Phí FREE 1C Trực Tuyến & Phương Án Trả Phí PAID 2A — Không Cần Dùng Máy Tính Cá Nhân Làm Server)

> **TÀI LIỆU CẨM NANG CẦM TAY CHỈ VIỆC DÀNH CHO BỘ CÀI ĐẶT PORTABLE (Phiên bản 3.3)**  
> *Áp dụng độc lập cho gói: `EMS_Banquet_Portable_Bundle`*  
> *Cam kết: **100% White-Label** (Tự do cấu hình tên khách sạn / trung tâm tiệc cưới riêng của bạn, không dính bất kỳ tên thương hiệu cũ nào).*  
> *Giải pháp Free 1C: **Chuyển sang nền tảng Render.com — Miễn phí 0đ, TUYỆT ĐỐI KHÔNG CẦN THẺ VISA / MASTERCARD**.*

---

## MỤC LỤC
1. [Phần 1: Chuẩn Bị Cơ Sở Dữ Liệu Google Sheets 38 Bảng & Lấy Link Webhook](#phần-1-chuẩn-bị-cơ-sở-dữ-liệu-google-sheets-38-bảng--lấy-link-webhook)
2. [Phần 2: Phương Án Miễn Phí FREE 1C: Triển Khai Lên Render.com (0đ/Tháng — Không Cần Thẻ Tín Dụng)](#phần-2-phương-án-miễn-phí-free-1c-triển-khai-lên-rendercom-0đtháng--không-cần-thẻ-tín-dụng)
3. [Phần 3: Phương Án Trả Phí PAID 2A: Cloud VPS Việt Nam 24/7 (Thanh Toán Momo/VietQR) + Cloudflare Tunnel](#phần-3-phương-án-trả-phí-paid-2a-cloud-vps-việt-nam-247-thanh-toán-momovietqr--cloudflare-tunnel)
4. [Phần 4: Hướng Dẫn Tự Cấu Hình Tên Riêng Trên Báo Cáo & Phiếu In BEO](#phần-4-hướng-dẫn-tự-cấu-hình-tên-riêng-trên-báo-cáo--phiếu-in-beo)
5. [Phần 5: Phụ Lục — Cách Xử Lý Lỗi Khi Triển Khai Trên Google Cloud Run (Nếu Có Thẻ)](#phần-5-phụ-lục--cách-xử-lý-lỗi-khi-triển-khai-trên-google-cloud-run-nếu-có-thẻ)

---

## PHẦN 1: CHUẨN BỊ CƠ SỞ DỮ LIỆU GOOGLE SHEETS 38 BẢNG & LẤY LINK WEBHOOK
*(Thời gian thực hiện: 3 phút — Miễn phí 100% trên tài khoản Google của bạn)*

### Bước 1.1: Tải File Mẫu Excel Lên Google Drive & Lưu Dưới Dạng Google Trang Tính
1. Mở thư mục: `EMS_Banquet_Portable_Bundle\database_templates\`.
2. Lấy file **`04_EMS_Banquet_GoogleSheet_Master_Data.xlsx`** (Đã nạp sẵn đầy đủ 38 bảng nghiệp vụ tiệc cưới, hội nghị, BEO 9 bộ phận).
3. Truy cập [Google Drive](https://drive.google.com) bằng tài khoản Gmail của bạn $\rightarrow$ Bấm nút **[+ Mới]** $\rightarrow$ **Tải tệp lên** $\rightarrow$ Chọn file `04_EMS_Banquet_GoogleSheet_Master_Data.xlsx`.
4. Nhấp đúp mở file vừa tải lên $\rightarrow$ Trên thanh menu trên cùng, bấm:  
   👉 **Tệp (File)** $\rightarrow$ **Lưu dưới dạng Google Trang tính (Save as Google Sheets)**.
5. Google sẽ mở ra một tab mới là Google Trang tính chính thức. Bạn hãy nhìn lên thanh địa chỉ của trình duyệt:
   ```text
   https://docs.google.com/spreadsheets/d/ 1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms /edit#gid=0
                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                             ĐÂY CHÍNH LÀ GOOGLE SPREADSHEET ID
   ```
   👉 Hãy sao chép chuỗi ký tự nằm giữa `/d/` và `/edit` để dùng ở các bước sau (Đây là **`GOOGLE_SPREADSHEET_ID`**).

---

### Bước 1.2: Cài Đặt Google Apps Script Webhook (Đồng Bộ 2 Chiều Không Cần Service Account)
1. Ngay trên tab Google Trang tính vừa tạo ở Bước 1.1, bấm menu:  
   👉 **Tiện ích mở rộng (Extensions)** $\rightarrow$ **Apps Script**.
2. Một cửa sổ soạn thảo code sẽ hiện ra. Bạn hãy xóa sạch đoạn code mặc định `function myFunction() {}` trong file `Code.gs`.
3. Mở file: `EMS_Banquet_Portable_Bundle\cloud_deploy\free_1c_google_ecosystem\Google_Apps_Script_Backend.gs` bằng Notepad:
   * Nhấn **Ctrl + A** (chọn tất cả) $\rightarrow$ **Ctrl + C** (sao chép).
   * Quay lại cửa sổ Apps Script trên trình duyệt, nhấn **Ctrl + V** (dán vào).
   * Bấm biểu tượng đĩa mềm hoặc nhấn **Ctrl + S** để Lưu.
4. Ở góc trên bên phải màn hình Apps Script, bấm nút màu xanh:  
   👉 **Triển khai (Deploy)** $\rightarrow$ **Tùy chọn triển khai mới (New deployment)**.
5. Cửa sổ thiết lập hiện ra:
   * Bấm vào biểu tượng bánh răng ⚙️ cạnh chữ *Chọn loại (Select type)* $\rightarrow$ Chọn **Ứng dụng web (Web app)**.
   * Ô *Mô tả (Description)*: Nhập `EMS Banquet Engine v3.3`.
   * Ô *Thực thi dưới dạng (Execute as)*: Chọn **Tôi (Me / email của bạn)**.
   * Ô *Ai có quyền truy cập (Who has access)*: Chọn **Bất kỳ ai (Anyone)** *(Bắt buộc chọn Anyone để Web có thể gửi/nhận dữ liệu)*.
   * Bấm nút màu xanh **Triển khai (Deploy)**.
6. **Cấp quyền truy cập (Làm đúng các bước sau)**:
   * Google sẽ hiện hộp thoại: Bấm nút **Ủy quyền truy cập (Authorize access)** $\rightarrow$ Chọn tài khoản Gmail của bạn.
   * Màn hình cảnh báo màu đỏ *"Google chưa xác minh ứng dụng này"*:  
     👉 Bấm vào chữ **Nâng cao (Advanced)** ở góc dưới bên trái $\rightarrow$ Bấm tiếp vào dòng chữ nhỏ: **Đi tới Dự án không có tiêu đề (không an toàn) / Go to Untitled project (unsafe)**.
   * Bấm nút **Cho phép (Allow)**.
7. Sau khi cấp quyền xong, màn hình sẽ hiển thị mục:  
   **URL ứng dụng web (Web App URL)** có dạng:  
   `https://script.google.com/macros/s/AKfycb.../exec`  
   👉 Hãy bấm **Sao chép (Copy)** đường link này (Đây chính là **`EMS_GSHEET_WEBHOOK_URL`**).

---

### Bước 1.3: Kiểm Tra Đường Link Apps Script Webhook Trong 1 Giây
1. Mở một tab mới trên Chrome / Edge.
2. Dán đường link Webhook vừa copy vào thanh địa chỉ và thêm `?action=status` vào đuôi:  
   `https://script.google.com/macros/s/AKfycb.../exec?action=status`
3. Nhấn Enter. Nếu màn hình hiển thị JSON như sau:
   ```json
   {
     "success": true,
     "service": "EMS Banquet Google Sheets Cloud Engine (Free 1C)",
     "total_tabs": 38
   }
   ```
   🎉 **Chúc mừng bạn! CSDL Google Sheet 38 bảng đã thông suốt và sẵn sàng 100%!**

---

## PHẦN 2: PHƯƠNG ÁN MIỄN PHÍ FREE 1C: TRIỂN KHAI LÊN RENDER.COM (0Đ/THÁNG — KHÔNG CẦN THẺ TÍN DỤNG)

> **Vì sao Render.com là giải pháp tối ưu số 1 hiện nay?**
> * **100% MIỄN PHÍ (0đ/tháng)** vĩnh viễn trên gói Free Tier.
> * **TUYỆT ĐỐI KHÔNG YÊU CẦU THẺ VISA / MASTERCARD (Không hỏi thẻ, không lo bị từ chối hạn mức)**.
> * Đăng ký 1 chạm bằng chính tài khoản Google (Gmail) hoặc GitHub.
> * Tự động build và chạy trực tiếp file `Dockerfile` của bộ cài.
> * Cấp link HTTPS chứng chỉ bảo mật SSL miễn phí: `https://ems-banquet-xxxx.onrender.com`.

---

### Bước 2.1: Đăng Ký Tài Khoản Miễn Phí Trên Render.com
1. Truy cập: [https://dashboard.render.com/register](https://dashboard.render.com/register).
2. Bấm nút **Google (Sign up with Google)** hoặc **GitHub (Sign up with GitHub)** để đăng nhập trong 5 giây (Không cần điền form, không bị hỏi thẻ tín dụng).

---

### Bước 2.2: Đưa Mã Nguồn Bộ Cài Lên GitHub

Bạn chọn 1 trong 2 cách cực kỳ đơn giản sau:

#### CÁCH A: DÙNG SCRIPT 1-CLICK TỰ ĐỘNG (Nhanh nhất nếu máy tính có Git):
1. Đăng nhập [https://github.com](https://github.com) $\rightarrow$ Bấm nút dấu cộng `[+]` ở góc trên bên phải $\rightarrow$ Chọn **New repository**.
2. Đặt tên: `ems-banquet-cloud` $\rightarrow$ Chọn **Public** (hoặc Private) $\rightarrow$ Bấm **Create repository**.
3. Copy đường link repo có dạng: `https://github.com/<username>/ems-banquet-cloud.git`.
4. Trên máy tính của bạn, vào thư mục:  
   `EMS_Banquet_Portable_Bundle\cloud_deploy\free_1c_render_cloud\`.
5. Nhấp đúp chạy file: **`push_to_github_for_render.bat`**.
6. Dán link repo vào và nhấn Enter $\rightarrow$ Script sẽ tự động đóng gói và đẩy code lên GitHub trong 30 giây!

#### CÁCH B: TẢI LÊN TRỰC TIẾP QUA TRÌNH DUYỆT (Nếu máy tính không cài Git):
1. Vào [https://github.com/new](https://github.com/new), tạo repo mới tên `ems-banquet-cloud`.
2. Tại màn hình repo vừa tạo, bấm vào dòng chữ nhỏ: **"uploading an existing file"**.
3. Kéo thả các file trong thư mục `EMS_Banquet_Portable_Bundle` lên trình duyệt $\rightarrow$ Bấm **Commit changes**.

---

### Bước 2.3: Tạo Dịch Vụ Web Service Trên Render.com & Nhận Link HTTPS
1. Trên [Render Dashboard](https://dashboard.render.com), bấm nút màu xanh: **New +** (ở góc trên bên phải) $\rightarrow$ Chọn **Web Service**.
2. Chọn mục **Build and deploy from a Git repository** $\rightarrow$ Bấm **Next**.
3. Kết nối với tài khoản GitHub của bạn và chọn repository **`ems-banquet-cloud`** $\rightarrow$ Bấm **Connect**.
4. Điền các thông tin cấu hình cực kỳ đơn giản:
   * **Name**: `ems-banquet-cloud` (hoặc tên khách sạn của bạn).
   * **Region**: Chọn **Singapore** (để tốc độ tải tại Việt Nam mượt nhất).
   * **Language / Environment**: Chọn **Docker** *(Render sẽ tự động dùng file `Dockerfile` đã được cấu hình tối ưu sẵn)*.
   * **Instance Type**: Chọn gói **Free ($0/month)**.
5. Cuộn xuống mục **Environment Variables (Biến môi trường)** $\rightarrow$ Bấm nút **Add Environment Variable** để thêm 3 dòng:
   * Dòng 1: Key = `EMS_DB_MODE` | Value = `google_sheets`
   * Dòng 2: Key = `EMS_GSHEET_ID` | Value = *(Dán Google Spreadsheet ID lấy ở Bước 1.1)*
   * Dòng 3: Key = `EMS_GSHEET_WEBHOOK_URL` | Value = *(Dán link Webhook lấy ở Bước 1.2)*
6. Bấm nút màu xanh: **Deploy Web Service**.
7. Render sẽ tự động build container trong khoảng 2 phút. Khi hoàn tất, màn hình sẽ hiển thị trạng thái màu xanh: **`Live`**.
8. Ngay dưới tên dịch vụ sẽ hiển thị đường link HTTPS chính thức:  
   👉 **`https://ems-banquet-cloud.onrender.com`**

🎉 **BÂY GIỜ HỆ THỐNG CỦA BẠN ĐÃ CHẠY 24/7 ONLINE VĨNH VIỄN!**
* **Giao diện Web máy tính**: `https://ems-banquet-cloud.onrender.com/`
* **Giao diện Di động Smartphone**: `https://ems-banquet-cloud.onrender.com/m`
* **Báo cáo Doanh thu Analytics**: `https://ems-banquet-cloud.onrender.com/analytics`

---

## PHẦN 3: PHƯƠNG ÁN TRẢ PHÍ PAID 2A: CLOUD VPS VIỆT NAM 24/7 (THANH TOÁN MOMO/VIETQR) + CLOUDFLARE TUNNEL

> **Khuyên dùng cho đơn vị kinh doanh lớn, cần tốc độ cực nhanh (ping 5ms - 10ms tại Việt Nam)**:
> * **Không cần thẻ quốc tế**: Thanh toán quét mã VietQR ngân hàng hoặc ví MoMo.
> * Chi phí: Chỉ từ **100.000đ - 180.000đ / tháng** tại các nhà cung cấp uy tín VN: **AZDIGI, Viettel IDC, FPT Cloud, TinoHost**.
> * Gắn Tên Miền Riêng HTTPS khóa xanh bảo mật (VD: `https://ems.tenkhachsan.vn`) qua Cloudflare Tunnel miễn phí.

### Bước 3.1: Hướng Dẫn Thuê Cloud VPS Tại Việt Nam
1. Truy cập các trang web nhà cung cấp VPS: **AZDIGI** (Gói Pro VPS 1) hoặc **Viettel IDC**, **TinoHost**.
2. Chọn cấu hình khuyến nghị:
   * CPU: 2 Core (vCPU).
   * RAM: 2GB đến 4GB.
   * Ổ cứng: 30GB SSD / NVMe.
   * Hệ điều hành: **Windows Server 2019 Datacenter** hoặc **Windows Server 2022**.
3. Thanh toán bằng cách quét mã QR ngân hàng hoặc MoMo. Sau 1 phút bạn sẽ nhận được Email chứa: **Địa chỉ IP**, **Username: Administrator**, và **Mật khẩu**.

---

### Bước 3.2: Đăng Nhập Vào VPS Và Đưa Bộ Cài Lên VPS
1. Trên máy tính của bạn: Bấm phím `Windows + R` $\rightarrow$ gõ `mstsc` $\rightarrow$ Nhấn Enter để mở **Remote Desktop Connection**.
2. Nhập IP của VPS $\rightarrow$ Bấm **Connect** $\rightarrow$ Nhập User `Administrator` và Mật khẩu.
3. Trên máy tính của bạn: Copy thư mục `EMS_Banquet_Portable_Bundle` (Ctrl + C) $\rightarrow$ Sang màn hình Remote Desktop của VPS bấm Paste (Ctrl + V) vào ổ đĩa `C:\EMS_Banquet_Portable_Bundle`.

---

### Bước 3.3: Cài Đặt 1-Click Chạy Vĩnh Viễn Trên VPS
1. Trên màn hình VPS, mở thư mục `C:\EMS_Banquet_Portable_Bundle\cloud_deploy\paid_2a_cloud_vps\`.
2. Nhấp chuột phải vào file **`install_vps_windows_1click.bat`** $\rightarrow$ Chọn **Run as administrator**.
3. Script sẽ tự động mở tường lửa, cài 3 dịch vụ Windows 24/7 và bật trang **Setup Wizard** (`http://127.0.0.1:5888`).
4. Trên Setup Wizard: Bạn chọn kết nối với **Google Sheets** (theo Bước 1) hoặc **Microsoft SQL Server**.

---

### Bước 3.4: Gắn Tên Miền Riêng HTTPS Bảo Mật Qua Cloudflare Zero Trust Tunnel
1. Vào [one.dash.cloudflare.com](https://one.dash.cloudflare.com) $\rightarrow$ Chọn **Networks** $\rightarrow$ **Tunnels** $\rightarrow$ Bấm **Create a tunnel**.
2. Đặt tên: `EMS-Banquet-VPS` $\rightarrow$ Chọn hệ điều hành **Windows** $\rightarrow$ Copy đoạn mã Token.
3. Trên màn hình VPS: Nhấp chuột phải vào file `setup_cloudflare_https_tunnel.bat` $\rightarrow$ Chọn **Run as administrator** $\rightarrow$ Dán mã Token vào và nhấn Enter.
4. Trạng thái Tunnel trên Cloudflare sẽ chuyển sang màu xanh: **HEALTHY**.
5. Bấm tab **Public Hostname** trên Cloudflare trỏ:
   * `ems.tenkhachsan.vn` $\rightarrow$ `HTTP` `localhost:5090`.
   * `analytics.tenkhachsan.vn` $\rightarrow$ `HTTP` `localhost:5088`.
6. 🎉 **Hoàn tất**: Bạn đã có hệ thống riêng với địa chỉ web HTTPS chuyên nghiệp!

---

## PHẦN 4: HƯỚNG DẪN TỰ CẤU HÌNH TÊN RIÊNG TRÊN BÁO CÁO & PHIẾU IN BEO

Bộ cài đặt `EMS_Banquet_Portable_Bundle` là phiên bản **White-Label 100%**:
1. **Đổi Tên Đơn Vị Cố Định Trên Hệ Thống**:
   * Mở file `config.json` bằng Notepad:
     ```json
     {
       "hotel_name": "TRUNG TÂM TIỆC CƯỚI & SỰ KIỆN HOÀNG GIA",
       "hotel_subtitle": "Hệ Thống Quản Lý Tiệc Cưới & Hội Nghị",
       "logo_url": ""
     }
     ```
   * Sửa `"hotel_name"` thành tên thương hiệu của bạn và bấm Lưu.
   * Toàn bộ thanh tiêu đề, menu và trang báo cáo sẽ tự động hiển thị tên riêng của bạn!

2. **Đổi Tên Đơn Vị Trực Tiếp Trên Phiếu In BEO**:
   * Mở tab **2. Soạn Thảo & In Phiếu BEO**.
   * Nhìn vào ô: **Tên Đơn Vị In Header BEO (Brand)** (nằm cạnh ô Tiêu Đề BEO):
     * Bạn có thể gõ bất kỳ tên nào (Ví dụ: *Diamond Convention Center*).
   * Bấm nút màu đen: **`[In Phiếu BEO (Khổ A4 Chuẩn)]`**.
   * Bản in BEO sẽ hiển thị ngay lập tức tên thương hiệu bạn vừa gõ ở góc trên bên trái đầu trang mà không còn bất kỳ dấu vết nào của thương hiệu khác!

---

## PHẦN 5: PHỤ LỤC — CÁCH XỬ LÝ LỖI KHI TRIỂN KHAI TRÊN GOOGLE CLOUD RUN (NẾU CÓ THẺ)

Nếu bạn vẫn muốn triển khai trên **Google Cloud Run** và gặp lỗi:
`FAILED_PRECONDITION: Billing account for project is not found. reason: UREQ_PROJECT_BILLING_NOT_FOUND`
hoặc lỗi thẻ từ chối:
`INSUFFICIENT CREDIT LIMIT - REJECTED`

👉 **Nguyên nhân**: Khi gắn thẻ vào Google Cloud, Google sẽ tạm trừ thử **\$1 (~24.000đ - 50.000đ)** để xác thực thẻ còn hoạt động và hoàn lại ngay sau đó. Nếu tài khoản thẻ Visa của bạn số dư khả dụng dưới 50.000đ, ngân hàng sẽ chặn giao dịch.  
👉 **Cách khắc phục**:
1. Dùng ứng dụng ngân hàng nạp tối thiểu **50.000đ - 100.000đ** vào tài khoản thẻ Visa.
2. Vào [console.cloud.google.com/billing](https://console.cloud.google.com/billing) liên kết lại thẻ.
3. Khi thẻ xác thực thành công, quay lại Google Cloud Shell gõ: `bash deploy_cloud_shell.sh` là sẽ hoàn thành ngay lập tức!
