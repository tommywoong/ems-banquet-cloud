/**
 * ============================================================================
 * EMS BANQUET CLOUD - GOOGLE APPS SCRIPT 2-WAY SYNC & API ENGINE (FREE 1C)
 * ============================================================================
 * Hướng dẫn sử dụng:
 * 1. Import file `04_EMS_Banquet_GoogleSheet_Master_Data.xlsx` lên Google Drive
 *    và mở bằng Google Sheets (Tệp -> Lưu dưới dạng Google Trang tính).
 * 2. Trên thanh menu Google Sheets, chọn: Tiện ích mở rộng (Extensions) -> Apps Script.
 * 3. Xóa mã mặc định, dán toàn bộ nội dung file này vào `Code.gs` và bấm Lưu (Ctrl+S).
 * 4. Bấm nút "Triển khai" (Deploy) -> "Tạo phiên bản triển khai mới" (New deployment):
 *    - Loại: Ứng dụng web (Web app)
 *    - Thực thi dưới dạng: Tôi (Me)
 *    - Ai có quyền truy cập: Bất kỳ ai (Anyone)
 * 5. Sao chép URL Web App (`https://script.google.com/macros/s/.../exec`) dán vào
 *    trình cài đặt EMS Setup Wizard hoặc biến `EMS_GSHEET_WEBHOOK_URL`.
 */

const CORE_TABLES = [
  "stUser", "stGroup", "stUserGroup", "stPhong", "stPhong_Loai", "stRoomType",
  "stDoanhThu_Loai", "stMenu", "stSetMenu", "stSetMenu_Type", "stBooking_Status",
  "stBookingColor", "stSetupType", "stPTThanhToan", "stChargeType", "stKhachHang_Loai",
  "stLinhVuc", "stSuKien", "stDepartment", "stReasonCancel", "stTinh_TP", "stQuocGia",
  "stSaleType", "stRoomNight", "stTienTe", "stTyGia", "stSK_TrangThai", "stCampaign",
  "stKhachHang", "stKhachHang_NguoiLH", "stBooking", "stBookFunctionRoom",
  "stBooking_Charges", "stMaster_EO", "stSKLK", "stSKLK_DoanhThu", "stSKLK_Notes", "stRoom_Setup"
];

function onOpen() {
  SpreadsheetApp.getUi()
    .createMenu("🚀 EMS Banquet Cloud")
    .addItem("1. Kiểm tra & Chuẩn hóa 38 Tabs CSDL", "ensureAllTablesExist")
    .addItem("2. Xem Thông tin Kết nối Webhook", "showWebhookHelp")
    .addToUi();
}

function ensureAllTablesExist() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let created = 0;
  CORE_TABLES.forEach(function(tbl) {
    if (!ss.getSheetByName(tbl)) {
      ss.insertSheet(tbl);
      created++;
    }
  });
  SpreadsheetApp.getUi().alert(
    "Hoàn tất kiểm tra CSDL Google Sheets!\n" +
    "- Tổng số bảng chuẩn: " + CORE_TABLES.length + "\n" +
    "- Số tab mới vừa tạo thêm: " + created
  );
}

function showWebhookHelp() {
  SpreadsheetApp.getUi().alert(
    "HƯỚNG DẪN LẤY WEBHOOK URL (PHƯƠNG ÁN FREE 1C):\n\n" +
    "1. Vào Tiện ích mở rộng -> Apps Script.\n" +
    "2. Bấm 'Triển khai' (Deploy) -> 'Quản lý nội dung triển khai'.\n" +
    "3. Copy đường dẫn Web App URL (https://script.google.com/macros/s/.../exec)\n" +
    "4. Dán vào ô Google Webhook URL trong Setup Wizard của EMS Banquet."
  );
}

/**
 * GET Endpoint: Trả về dữ liệu của 1 bảng hoặc toàn bộ các bảng cho EMS Banquet Cloud
 * Ví dụ: GET ?action=get_table&table=stBooking
 *        GET ?action=get_all
 */
function doGet(e) {
  try {
    const params = (e && e.parameter) ? e.parameter : {};
    const action = params.action || "status";
    const ss = SpreadsheetApp.getActiveSpreadsheet();

    if (action === "get_table" && params.table) {
      const sheet = ss.getSheetByName(params.table);
      if (!sheet) {
        return jsonResponse({ success: false, error: "Table not found: " + params.table });
      }
      const data = sheet.getDataRange().getDisplayValues();
      const headers = data.length > 0 ? data[0] : [];
      const rows = data.length > 1 ? data.slice(1) : [];
      return jsonResponse({ success: true, table: params.table, headers: headers, rows: rows });
    }

    if (action === "get_all") {
      const dump = {};
      ss.getSheets().forEach(function(sh) {
        const name = sh.getName();
        const data = sh.getDataRange().getDisplayValues();
        if (data.length > 0) {
          dump[name] = {
            headers: data[0],
            rows: data.length > 1 ? data.slice(1) : []
          };
        }
      });
      return jsonResponse({ success: true, spreadsheet_id: ss.getId(), tables: dump });
    }

    return jsonResponse({
      success: true,
      service: "EMS Banquet Google Sheets Cloud Engine (Free 1C)",
      spreadsheet_name: ss.getName(),
      spreadsheet_id: ss.getId(),
      total_tabs: ss.getSheets().length,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    return jsonResponse({ success: false, error: err.toString() });
  }
}

/**
 * POST Endpoint: Nhận dữ liệu đồng bộ tức thì từ EMS Banquet Web / Cloud Run
 * Payload: { action: "sync_table", table: "stBooking", headers: [...], rows: [[...], ...] }
 */
function doPost(e) {
  const lock = LockService.getScriptLock();
  try {
    lock.waitLock(15000);
    const body = JSON.parse(e.postData.contents);
    const action = body.action || "sync_table";
    const ss = SpreadsheetApp.getActiveSpreadsheet();

    if (action === "sync_table" && body.table) {
      let sheet = ss.getSheetByName(body.table);
      if (!sheet) {
        sheet = ss.insertSheet(body.table);
      }
      const headers = body.headers || [];
      const rows = body.rows || [];
      sheet.clearContents();
      if (headers.length > 0) {
        const allValues = [headers].concat(rows);
        sheet.getRange(1, 1, allValues.length, headers.length).setValues(allValues);
      }
      return jsonResponse({
        success: true,
        table: body.table,
        synced_rows: rows.length,
        updated_at: new Date().toISOString()
      });
    }

    return jsonResponse({ success: false, error: "Unsupported action: " + action });
  } catch (err) {
    return jsonResponse({ success: false, error: err.toString() });
  } finally {
    lock.releaseLock();
  }
}

function jsonResponse(obj) {
  return ContentService
    .createTextOutput(JSON.stringify(obj))
    .setMimeType(ContentService.MimeType.JSON);
}
