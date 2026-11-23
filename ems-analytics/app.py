import os
import io
import json
import datetime
from typing import Optional, List, Dict, Any
from fastapi import FastAPI, Query, HTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse, StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response, FileResponse
import pyodbc
import pandas as pd

app = FastAPI(title="EMS Banquet Analytics & Reporting", version="1.3.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class NoCacheMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        response: Response = await call_next(request)
        response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "0"
        response.headers["Surrogate-Control"] = "no-store"
        return response

app.add_middleware(NoCacheMiddleware)

DEFAULT_SERVER = "localhost\\MSSQLSERVER2016" if os.path.exists(r"D:\EMSMDH") else "10.17.10.12\\MSSQLSERVER2016"
SQL_SERVER = os.getenv("EMS_SQL_SERVER", DEFAULT_SERVER)

CONN_STR = (
    "DRIVER={SQL Server};"
    f"SERVER={SQL_SERVER};"
    "DATABASE=EMS_KHAIVY;"
    "UID=SA;"
    "PWD=Sa!123123#;"
)

def get_db():
    try:
        from db_adapter import get_hybrid_db_connection
        return get_hybrid_db_connection(CONN_STR)
    except Exception:
        return pyodbc.connect(CONN_STR, timeout=6)

def build_where_clause(
    year: Optional[int] = None,
    month: Optional[int] = None,
    hall: Optional[str] = None,
    segment: Optional[str] = None,
    channel: Optional[str] = None,
    sales_user: Optional[str] = None,
    status: Optional[str] = None,
    search: Optional[str] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    date_type: Optional[str] = "event",
    book_ids: Optional[str] = None
):
    clauses = ["1=1"]
    params = []
    
    # Date field determination: event date (bfr.fdDate) or booking date (b.fdDate)
    dt_col = "ISNULL(bfr.fdDate, b.fdDate)" if date_type == "event" else "b.fdDate"

    if book_ids and book_ids.strip():
        b_list = [b.strip() for b in book_ids.split(',') if b.strip()]
        if b_list:
            clauses.append(f"b.fcBookID IN ({','.join(['?']*len(b_list))})")
            params.extend(b_list)
    
    if year:
        clauses.append(f"YEAR({dt_col}) = ?")
        params.append(year)
    if month:
        clauses.append(f"MONTH({dt_col}) = ?")
        params.append(month)
    if hall and hall != 'ALL':
        h_list = [h.strip() for h in hall.split(',') if h.strip() and h.strip() != 'ALL']
        if len(h_list) == 1:
            clauses.append("bfr.fcFunctionRoom = ?")
            params.append(h_list[0])
        elif len(h_list) > 1:
            clauses.append(f"bfr.fcFunctionRoom IN ({','.join(['?']*len(h_list))})")
            params.extend(h_list)
    if segment and segment != 'ALL':
        seg_list = [s.strip() for s in segment.split(',') if s.strip() and s.strip() != 'ALL']
        if len(seg_list) == 1:
            clauses.append("k.fcLinhVuc = ?")
            params.append(seg_list[0])
        elif len(seg_list) > 1:
            clauses.append(f"k.fcLinhVuc IN ({','.join(['?']*len(seg_list))})")
            params.extend(seg_list)
    if channel and channel != 'ALL':
        ch_list = [c.strip() for c in channel.split(',') if c.strip() and c.strip() != 'ALL']
        if len(ch_list) == 1:
            clauses.append("k.fcLoaiKhach = ?")
            params.append(ch_list[0])
        elif len(ch_list) > 1:
            clauses.append(f"k.fcLoaiKhach IN ({','.join(['?']*len(ch_list))})")
            params.extend(ch_list)
    if sales_user and sales_user != 'ALL':
        su_list = [u.strip() for u in sales_user.split(',') if u.strip() and u.strip() != 'ALL']
        if len(su_list) == 1:
            clauses.append("ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser) = ?")
            params.append(su_list[0])
        elif len(su_list) > 1:
            clauses.append(f"ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser) IN ({','.join(['?']*len(su_list))})")
            params.extend(su_list)
    if status and status != 'ALL':
        st_list = [s.strip() for s in status.split(',') if s.strip() and s.strip() != 'ALL']
        if len(st_list) == 1:
            clauses.append("b.fcStatus_BkRoom = ?")
            params.append(st_list[0])
        elif len(st_list) > 1:
            clauses.append(f"b.fcStatus_BkRoom IN ({','.join(['?']*len(st_list))})")
            params.extend(st_list)
    if date_from:
        clauses.append(f"CAST({dt_col} AS date) >= ?")
        params.append(date_from[:10])
    if date_to:
        clauses.append(f"CAST({dt_col} AS date) <= ?")
        params.append(date_to[:10])
    if search:
        search_pattern = f"%{search}%"
        clauses.append("(b.fcBookID LIKE ? OR b.fcTitle LIKE ? OR k.fcTen LIKE ? OR k.fcTelephone LIKE ?)")
        params.extend([search_pattern, search_pattern, search_pattern, search_pattern])
        
    return " AND ".join(clauses), params

@app.get("/api/health")
def health_check():
    try:
        cn = get_db()
        cur = cn.cursor()
        cur.execute("SELECT 1")
        cur.close()
        cn.close()
        return {"status": "ok", "database": "EMS_KHAIVY connected"}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.get("/api/filters")
def get_filters():
    try:
        cn = get_db()
        cur = cn.cursor()
        
        # Years
        cur.execute("""
            SELECT DISTINCT YEAR(bfr.fdDate) AS Nam 
            FROM stBookFunctionRoom bfr 
            WHERE bfr.fdDate IS NOT NULL
            UNION
            SELECT DISTINCT YEAR(b.fdDate) AS Nam 
            FROM stBooking b 
            WHERE b.fdDate IS NOT NULL
            ORDER BY Nam DESC
        """)
        years = [int(r[0]) for r in cur.fetchall() if r[0] is not None]
        
        # Halls (stPhong) with Floor grouping & counts
        cur.execute("""
            SELECT p.fcMa, p.fcTen, p.fcKhuVuc, p.fnDienTich, COUNT(bfr.fcBookID) AS BookingsCount
            FROM stPhong p
            LEFT JOIN stBookFunctionRoom bfr ON p.fcMa = bfr.fcFunctionRoom
            GROUP BY p.fcMa, p.fcTen, p.fcKhuVuc, p.fnDienTich
            ORDER BY BookingsCount DESC
        """)
        halls = []
        for r in cur.fetchall():
            area = r[2] or ''
            if 'G' in area.upper():
                grp = "Tầng G (Sảnh Lớn - Trệt)"
            elif 'M' in area.upper():
                grp = "Tầng M (Sảnh Vừa & Linh Hoạt)"
            elif '10' in area:
                grp = "Tầng 10 (Sân Thượng / Giải Trí)"
            else:
                grp = "Khu Vực Khác"
            halls.append({
                "code": r[0],
                "name": r[1],
                "area": area,
                "size": r[3],
                "group": grp,
                "count": int(r[4] or 0)
            })
        
        # Segments (stLinhVuc)
        cur.execute("""
            SELECT 
                lv.fcCode, 
                lv.fcName, 
                lv.fcNote,
                COUNT(b.fcBookID) AS TotalBookings
            FROM stLinhVuc lv
            LEFT JOIN stKhachHang k ON lv.fcCode = k.fcLinhVuc
            LEFT JOIN stBooking b ON k.fcMa = b.fcGuestID
            GROUP BY lv.fcCode, lv.fcName, lv.fcNote
            ORDER BY TotalBookings DESC, lv.fcName ASC
        """)
        raw_segments = cur.fetchall()
        segments = []
        for r in raw_segments:
            code = r[0]
            name = r[1]
            note = r[2] or ''
            cnt = int(r[3] or 0)
            
            disp_name = name
            if code == '20071011124354812':
                disp_name = "Khách Đoàn Du Lịch Nội Địa (GIT-LE-DO)"
            elif code == '20071011124410203':
                disp_name = "Khách Đoàn Hàn Quốc (GIT-LE-KO)"
            elif code == '20240612135600548':
                disp_name = "Tiệc Cưới Trọn Gói (WEDDING)"
            elif code == '20240614073401479':
                disp_name = "Khách Đoàn Đài Loan (GIT-LE-TWN)"
            elif code == '20240612140606682':
                disp_name = "Tiệc Riêng / Sinh Nhật / Gala (PARTY)"
            elif code == '20071011124934500':
                disp_name = "Ngành Giáo Dục & Trường Học (EDU)"
            elif code == '20071011124447875':
                disp_name = "Khối Nhà Nước & Quân Đội (MIL)"
            elif code == '20201210163505851':
                disp_name = "Bệnh Viện & Dược Phẩm / Y Tế"
            elif code == '20201210163222535':
                disp_name = "Ngân Hàng & Tài Chính"
                
            if code in ('20240612135600548', '20240612140606682') or 'WEDDING' in name.upper() or 'PARTY' in name.upper():
                grp = "⭐ Tiệc Cưới & Sự Kiện Trọng Điểm"
            elif 'GIT' in name.upper() or 'LEISURE' in note.upper():
                grp = "✈️ Khách Đoàn Du Lịch (Inbound & Tour)"
            elif any(k in name.upper() for k in ['BANKING', 'CORPORATE', 'GCO', 'TECHNOLOGY', 'SERVICES', 'MANUFACTURING', 'AGRICULTURE', 'BUSINESS', 'F&B', 'COMMERCE', 'CONSTRUCTION', 'STEEL']):
                grp = "🏢 Khối Doanh Nghiệp & Thương Mại"
            elif any(k in name.upper() for k in ['MIL', 'EDU', 'HOSPITAL', 'EMBASSY', 'MEDICAL', 'GOVERNMENT', 'MINISTRIES']):
                grp = "🏛️ Cơ Quan, Giáo Dục & Y Tế"
            else:
                grp = "📁 Các Ngành Khác"
                
            segments.append({
                "code": code,
                "name": disp_name,
                "raw_name": name,
                "note": note,
                "group": grp,
                "count": cnt
            })
        
        # Channels (stKhachHang_Loai)
        cur.execute("""
            SELECT kl.fcCode, kl.fcName, kl.fcNote, kl.fcGroup, COUNT(b.fcBookID) AS TotalBookings
            FROM stKhachHang_Loai kl
            LEFT JOIN stKhachHang k ON kl.fcCode = k.fcLoaiKhach
            LEFT JOIN stBooking b ON k.fcMa = b.fcGuestID
            GROUP BY kl.fcCode, kl.fcName, kl.fcNote, kl.fcGroup
            ORDER BY TotalBookings DESC
        """)
        channels = []
        for r in cur.fetchall():
            c_name = r[1]
            c_note = r[2] or ''
            c_grp = r[3] or ''
            cnt = int(r[4] or 0)
            
            if c_name in ('SALES', 'WK', 'WOM'):
                clean_grp = "💼 Kinh Doanh Trực Tiếp"
            elif c_name in ('FB', 'ZAL', 'TIKTOK', 'ADW', 'EDM'):
                clean_grp = "🌐 Kênh Số & Marketing Online"
            else:
                clean_grp = "🤝 Đại Lý & Đối Tác Thứ 3"
                
            channels.append({
                "code": r[0],
                "name": c_name,
                "note": c_note,
                "group": clean_grp,
                "count": cnt
            })
        
        # Sales staff (effective BEO creators)
        cur.execute("""
            SELECT DISTINCT 
                ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser) AS EffectiveUser,
                u.fcFullName, 
                u.fcPosition 
            FROM stBooking b
            LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
            LEFT JOIN stUser u ON ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser) = u.fcUserName
            WHERE ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser) IS NOT NULL 
              AND ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser) <> ''
              AND UPPER(LTRIM(RTRIM(ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser)))) NOT IN ('LNC', 'NQP', 'NVT', 'NTTHA', 'TVT', 'VNT')
            ORDER BY u.fcFullName
        """)
        sales_users = [{"code": r[0], "name": r[1] if r[1] else r[0], "position": r[2]} for r in cur.fetchall()]
        
        # Statuses
        cur.execute("SELECT fcCode, fcName FROM stBooking_Status ORDER BY fnOrder")
        statuses = [{"code": r[0], "name": r[1]} for r in cur.fetchall()]
        
        cur.close()
        cn.close()
        
        return {
            "years": years,
            "halls": halls,
            "segments": segments,
            "channels": channels,
            "sales_users": sales_users,
            "statuses": statuses
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/summary")
def get_summary(
    year: Optional[int] = None,
    month: Optional[int] = None,
    hall: Optional[str] = None,
    segment: Optional[str] = None,
    channel: Optional[str] = None,
    sales_user: Optional[str] = None,
    status: Optional[str] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    date_type: Optional[str] = "event"
):
    try:
        where_sql, params = build_where_clause(year, month, hall, segment, channel, sales_user, status, None, date_from, date_to, date_type)
        cn = get_db()
        cur = cn.cursor()
        
        sql = f"""
        WITH FilteredBookings AS (
            SELECT DISTINCT 
                b.fcBookID,
                b.fcStatus_BkRoom,
                CASE WHEN ISNULL(b.fnSoLuongDK, 0) > 0 THEN b.fnSoLuongDK ELSE ISNULL(bfr_meta.MaxQuantity, 0) END AS fnSoLuongDK,
                ISNULL(b.fnDatCoc, ISNULL(meo.fnDatCoc, 0)) AS fnDatCoc,
                CASE WHEN b.fcStatus_BkRoom = 'C' THEN 0 ELSE ISNULL(eo_rev.TotalRev, ISNULL(bc_rev.TotalRev, 0)) END AS TongDoanhThu,
                CASE WHEN b.fcStatus_BkRoom = 'C' THEN 0 ELSE ISNULL(eo_rev.RoomRev, ISNULL(bc_rev.RoomRev, 0)) END AS DoanhThuPhong,
                CASE WHEN b.fcStatus_BkRoom = 'C' THEN 0 ELSE ISNULL(eo_rev.BanquetRev, ISNULL(bc_rev.BanquetRev, 0)) END AS DoanhThuTiec
            FROM stBooking b
            LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
            LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
            LEFT JOIN stBookFunctionRoom bfr ON b.fcBookID = bfr.fcBookID
            LEFT JOIN (
                SELECT fcBookID, MAX(fnQuantity) AS MaxQuantity
                FROM stBookFunctionRoom
                GROUP BY fcBookID
            ) bfr_meta ON b.fcBookID = bfr_meta.fcBookID
            LEFT JOIN (
                SELECT 
                    d.fcMaster_EO,
                    SUM(d.fnAmount) AS TotalRev,
                    SUM(CASE WHEN dt.fcGroup = '05' OR d.fcDoanhThu_Type IN ('24', '56') THEN d.fnAmount ELSE 0 END) AS RoomRev,
                    SUM(CASE WHEN dt.fcGroup IN ('01', '02', '03', '04', '06') OR (d.fcDoanhThu_Type NOT IN ('24', '56') AND (dt.fcGroup IS NULL OR dt.fcGroup <> '05')) THEN d.fnAmount ELSE 0 END) AS BanquetRev
                FROM stSKLK_DoanhThu d
                LEFT JOIN stDoanhThu_Loai dt ON d.fcDoanhThu_Type = dt.fcCode
                GROUP BY d.fcMaster_EO
            ) eo_rev ON meo.fcMaster_EO IS NOT NULL AND meo.fcMaster_EO <> '' AND meo.fcMaster_EO = eo_rev.fcMaster_EO
            LEFT JOIN (
                SELECT 
                    c.fcBookID,
                    SUM(c.fnAmount) AS TotalRev,
                    SUM(CASE WHEN dt.fcGroup = '05' OR c.fcDoanhThu_Loai IN ('24', '56') THEN c.fnAmount ELSE 0 END) AS RoomRev,
                    SUM(CASE WHEN dt.fcGroup IN ('01', '02', '03', '04', '06') OR (c.fcDoanhThu_Loai NOT IN ('24', '56') AND (dt.fcGroup IS NULL OR dt.fcGroup <> '05')) THEN c.fnAmount ELSE 0 END) AS BanquetRev
                FROM stBooking_Charges c
                LEFT JOIN stDoanhThu_Loai dt ON c.fcDoanhThu_Loai = dt.fcCode
                GROUP BY c.fcBookID
            ) bc_rev ON b.fcBookID = bc_rev.fcBookID
            WHERE {where_sql}
        )
        SELECT 
            COUNT(*) AS TongBooking,
            SUM(CASE WHEN fcStatus_BkRoom = 'D' THEN 1 ELSE 0 END) AS SoBookingChot,
            SUM(CASE WHEN fcStatus_BkRoom = 'T' THEN 1 ELSE 0 END) AS SoBookingGiuCho,
            SUM(CASE WHEN fcStatus_BkRoom = 'C' THEN 1 ELSE 0 END) AS SoBookingHuy,
            SUM(CASE WHEN fcStatus_BkRoom NOT IN ('D', 'T', 'C') THEN 1 ELSE 0 END) AS SoBookingKhac,
            ISNULL(SUM(fnSoLuongDK), 0) AS TongKhach,
            ISNULL(SUM(fnDatCoc), 0) AS TongTienCoc,
            ISNULL(SUM(TongDoanhThu), 0) AS TongDoanhThu,
            ISNULL(SUM(DoanhThuPhong), 0) AS TongDoanhThuPhong,
            ISNULL(SUM(DoanhThuTiec), 0) AS TongDoanhThuTiec,
            SUM(CASE WHEN DoanhThuPhong > 0 THEN 1 ELSE 0 END) AS SoBookingCoPhong
        FROM FilteredBookings;
        """
        
        cur.execute(sql, params)
        row = cur.fetchone()
        
        tong_booking = int(row[0] or 0)
        chot = int(row[1] or 0)
        giu_cho = int(row[2] or 0)
        huy = int(row[3] or 0)
        khac = int(row[4] or 0)
        tong_khach = float(row[5] or 0)
        tong_coc = float(row[6] or 0)
        tong_doanh_thu = float(row[7] or 0)
        tong_dt_phong = float(row[8] or 0)
        tong_dt_tiec = float(row[9] or 0)
        so_booking_co_phong = int(row[10] or 0)
        
        avg_rev = (tong_doanh_thu / tong_booking) if tong_booking > 0 else 0
        avg_guests = (tong_khach / tong_booking) if tong_booking > 0 else 0
        win_rate = min(chot / tong_booking * 100, 100.0) if tong_booking > 0 else 0
        cancel_rate = min(huy / tong_booking * 100, 100.0) if tong_booking > 0 else 0
        room_rev_pct = round((tong_dt_phong / tong_doanh_thu * 100), 1) if tong_doanh_thu > 0 else 0
        
        cur.close()
        cn.close()
        
        return {
            "total_bookings": tong_booking,
            "confirmed_bookings": chot,
            "tentative_bookings": giu_cho,
            "cancelled_bookings": huy,
            "other_bookings": khac,
            "total_guests": tong_khach,
            "total_deposit": tong_coc,
            "total_revenue": tong_doanh_thu,
            "total_room_revenue": tong_dt_phong,
            "total_banquet_revenue": tong_dt_tiec,
            "room_bookings_count": so_booking_co_phong,
            "room_revenue_pct": room_rev_pct,
            "avg_revenue_per_booking": avg_rev,
            "avg_guests_per_booking": avg_guests,
            "win_rate": round(win_rate, 1),
            "cancel_rate": round(cancel_rate, 1)
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/stats/halls")
def get_hall_stats(
    year: Optional[int] = None,
    month: Optional[int] = None,
    hall: Optional[str] = None,
    segment: Optional[str] = None,
    channel: Optional[str] = None,
    sales_user: Optional[str] = None,
    status: Optional[str] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    date_type: Optional[str] = "event"
):
    try:
        where_sql, params = build_where_clause(year, month, hall, segment, channel, sales_user, status, None, date_from, date_to, date_type)
        cn = get_db()
        cur = cn.cursor()
        
        sql = f"""
        SELECT 
            ISNULL(p.fcMa, 'UNKNOWN') AS HallCode,
            ISNULL(p.fcTen, N'Chưa xếp sảnh') AS HallName,
            ISNULL(p.fcKhuVuc, '') AS FloorArea,
            ISNULL(p.fnDienTich, '') AS SizeSquare,
            COUNT(DISTINCT b.fcBookID) AS TotalBookings,
            ISNULL(SUM(CASE WHEN ISNULL(rs.fnQuantity, 0) > 0 THEN rs.fnQuantity WHEN ISNULL(bfr.fnQuantity, 0) > 0 THEN bfr.fnQuantity ELSE b.fnSoLuongDK END), 0) AS TotalGuests,
            COUNT(DISTINCT CASE WHEN b.fcStatus_BkRoom = 'D' THEN b.fcBookID END) AS ConfirmedCount,
            COUNT(DISTINCT CASE WHEN b.fcStatus_BkRoom = 'C' THEN b.fcBookID END) AS CancelledCount,
            ISNULL(SUM(CASE WHEN b.fcStatus_BkRoom = 'C' THEN 0 ELSE ISNULL(eo_rev.TotalRev, ISNULL(bc_rev.TotalRev, 0)) END), 0) AS TotalRevenue
        FROM stBookFunctionRoom bfr
        INNER JOIN stBooking b ON bfr.fcBookID = b.fcBookID
        LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
        LEFT JOIN stPhong p ON bfr.fcFunctionRoom = p.fcMa
        LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
        LEFT JOIN stRoom_Setup rs ON meo.fcMaster_EO = rs.fcMaster_EO AND bfr.fnCodeID = rs.fnCodeID
        LEFT JOIN (
            SELECT fcMaster_EO, SUM(fnAmount) AS TotalRev
            FROM stSKLK_DoanhThu
            GROUP BY fcMaster_EO
        ) eo_rev ON meo.fcMaster_EO IS NOT NULL AND meo.fcMaster_EO <> '' AND meo.fcMaster_EO = eo_rev.fcMaster_EO
        LEFT JOIN (
            SELECT fcBookID, SUM(fnAmount) AS TotalRev
            FROM stBooking_Charges
            GROUP BY fcBookID
        ) bc_rev ON b.fcBookID = bc_rev.fcBookID
        WHERE {where_sql}
        GROUP BY p.fcMa, p.fcTen, p.fcKhuVuc, p.fnDienTich
        ORDER BY TotalBookings DESC;
        """
        
        cur.execute(sql, params)
        data = []
        for r in cur.fetchall():
            tot = int(r[4] or 0)
            conf = int(r[6] or 0)
            canc = int(r[7] or 0)
            win_pct = min(round((conf / tot * 100), 1), 100.0) if tot > 0 else 0
            canc_pct = min(round((canc / tot * 100), 1), 100.0) if tot > 0 else 0
            data.append({
                "code": r[0],
                "name": r[1],
                "floor": r[2],
                "area_m2": r[3],
                "total_bookings": tot,
                "total_guests": float(r[5] or 0),
                "confirmed_count": conf,
                "cancelled_count": canc,
                "win_rate": win_pct,
                "cancel_rate": canc_pct,
                "total_revenue": float(r[8] or 0)
            })
            
        cur.close()
        cn.close()
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/stats/segments")
def get_segment_stats(
    year: Optional[int] = None,
    month: Optional[int] = None,
    hall: Optional[str] = None,
    segment: Optional[str] = None,
    channel: Optional[str] = None,
    sales_user: Optional[str] = None,
    status: Optional[str] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    date_type: Optional[str] = "event"
):
    try:
        where_sql, params = build_where_clause(year, month, hall, segment, channel, sales_user, status, None, date_from, date_to, date_type)
        cn = get_db()
        cur = cn.cursor()
        
        sql = f"""
        WITH MatchedBookings AS (
            SELECT DISTINCT b.fcBookID
            FROM stBooking b
            LEFT JOIN stBookFunctionRoom bfr ON b.fcBookID = bfr.fcBookID
            LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
            LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
            WHERE {where_sql}
        )
        SELECT 
            ISNULL(lv.fcCode, 'UNKNOWN') AS SegmentCode,
            ISNULL(lv.fcName, N'Chưa xác định') AS SegmentName,
            ISNULL(lv.fcNote, '') AS Description,
            COUNT(DISTINCT b.fcBookID) AS TotalBookings,
            ISNULL(SUM(b.fnSoLuongDK), 0) AS TotalGuests,
            COUNT(DISTINCT CASE WHEN b.fcStatus_BkRoom = 'D' THEN b.fcBookID END) AS ConfirmedCount,
            COUNT(DISTINCT CASE WHEN b.fcStatus_BkRoom = 'C' THEN b.fcBookID END) AS CancelledCount,
            ISNULL(SUM(CASE WHEN b.fcStatus_BkRoom = 'C' THEN 0 ELSE ISNULL(eo_rev.TotalRev, ISNULL(bc_rev.TotalRev, 0)) END), 0) AS TotalRevenue
        FROM MatchedBookings mb
        INNER JOIN stBooking b ON mb.fcBookID = b.fcBookID
        LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
        LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
        LEFT JOIN stLinhVuc lv ON k.fcLinhVuc = lv.fcCode
        LEFT JOIN (
            SELECT fcMaster_EO, SUM(fnAmount) AS TotalRev
            FROM stSKLK_DoanhThu
            GROUP BY fcMaster_EO
        ) eo_rev ON meo.fcMaster_EO IS NOT NULL AND meo.fcMaster_EO <> '' AND meo.fcMaster_EO = eo_rev.fcMaster_EO
        LEFT JOIN (
            SELECT fcBookID, SUM(fnAmount) AS TotalRev
            FROM stBooking_Charges
            GROUP BY fcBookID
        ) bc_rev ON b.fcBookID = bc_rev.fcBookID
        GROUP BY lv.fcCode, lv.fcName, lv.fcNote
        ORDER BY TotalBookings DESC;
        """
        
        cur.execute(sql, params)
        data = []
        for r in cur.fetchall():
            tot = int(r[3] or 0)
            rev = float(r[7] or 0)
            data.append({
                "code": r[0],
                "name": r[1],
                "desc": r[2],
                "total_bookings": tot,
                "total_guests": float(r[4] or 0),
                "confirmed_count": int(r[5] or 0),
                "cancelled_count": int(r[6] or 0),
                "total_revenue": rev,
                "avg_revenue": (rev / tot) if tot > 0 else 0
            })
            
        cur.close()
        cn.close()
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/stats/channels")
def get_channel_stats(
    year: Optional[int] = None,
    month: Optional[int] = None,
    hall: Optional[str] = None,
    segment: Optional[str] = None,
    channel: Optional[str] = None,
    sales_user: Optional[str] = None,
    status: Optional[str] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    date_type: Optional[str] = "event"
):
    try:
        where_sql, params = build_where_clause(year, month, hall, segment, channel, sales_user, status, None, date_from, date_to, date_type)
        cn = get_db()
        cur = cn.cursor()
        
        sql = f"""
        WITH MatchedBookings AS (
            SELECT DISTINCT b.fcBookID
            FROM stBooking b
            LEFT JOIN stBookFunctionRoom bfr ON b.fcBookID = bfr.fcBookID
            LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
            LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
            WHERE {where_sql}
        )
        SELECT 
            ISNULL(kl.fcCode, 'UNKNOWN') AS ChannelCode,
            ISNULL(kl.fcName, N'Chưa xác định') AS ChannelName,
            ISNULL(kl.fcNote, '') AS Description,
            ISNULL(kl.fcGroup, '') AS ChannelGroup,
            COUNT(DISTINCT b.fcBookID) AS TotalBookings,
            ISNULL(SUM(b.fnSoLuongDK), 0) AS TotalGuests,
            COUNT(DISTINCT CASE WHEN b.fcStatus_BkRoom = 'D' THEN b.fcBookID END) AS ConfirmedCount,
            COUNT(DISTINCT CASE WHEN b.fcStatus_BkRoom = 'C' THEN b.fcBookID END) AS CancelledCount,
            ISNULL(SUM(CASE WHEN b.fcStatus_BkRoom = 'C' THEN 0 ELSE ISNULL(eo_rev.TotalRev, ISNULL(bc_rev.TotalRev, 0)) END), 0) AS TotalRevenue
        FROM MatchedBookings mb
        INNER JOIN stBooking b ON mb.fcBookID = b.fcBookID
        LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
        LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
        LEFT JOIN stKhachHang_Loai kl ON k.fcLoaiKhach = kl.fcCode
        LEFT JOIN (
            SELECT fcMaster_EO, SUM(fnAmount) AS TotalRev
            FROM stSKLK_DoanhThu
            GROUP BY fcMaster_EO
        ) eo_rev ON meo.fcMaster_EO IS NOT NULL AND meo.fcMaster_EO <> '' AND meo.fcMaster_EO = eo_rev.fcMaster_EO
        LEFT JOIN (
            SELECT fcBookID, SUM(fnAmount) AS TotalRev
            FROM stBooking_Charges
            GROUP BY fcBookID
        ) bc_rev ON b.fcBookID = bc_rev.fcBookID
        GROUP BY kl.fcCode, kl.fcName, kl.fcNote, kl.fcGroup
        ORDER BY TotalBookings DESC;
        """
        
        cur.execute(sql, params)
        data = []
        for r in cur.fetchall():
            tot = int(r[4] or 0)
            conf = int(r[6] or 0)
            canc = int(r[7] or 0)
            data.append({
                "code": r[0],
                "name": r[1],
                "desc": r[2],
                "group": r[3],
                "total_bookings": tot,
                "total_guests": float(r[5] or 0),
                "confirmed_count": conf,
                "cancelled_count": canc,
                "conv_rate": min(round((conf / tot * 100), 1), 100.0) if tot > 0 else 0,
                "total_revenue": float(r[8] or 0)
            })
            
        cur.close()
        cn.close()
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/stats/sales")
def get_sales_stats(
    year: Optional[int] = None,
    month: Optional[int] = None,
    hall: Optional[str] = None,
    segment: Optional[str] = None,
    channel: Optional[str] = None,
    sales_user: Optional[str] = None,
    status: Optional[str] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    date_type: Optional[str] = "event"
):
    try:
        where_sql, params = build_where_clause(year, month, hall, segment, channel, sales_user, status, None, date_from, date_to, date_type)
        cn = get_db()
        cur = cn.cursor()
        
        # KEY BUSINESS LOGIC: Revenue belongs to BEO Creator (meo.fcNguoiLap), fallback to Booking Lock User (b.fcUser)
        sql = f"""
        WITH MatchedBookings AS (
            SELECT DISTINCT b.fcBookID
            FROM stBooking b
            LEFT JOIN stBookFunctionRoom bfr ON b.fcBookID = bfr.fcBookID
            LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
            LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
            WHERE {where_sql}
        )
        SELECT 
            ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser) AS EffectiveUserCode,
            ISNULL(u.fcFullName, ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser)) AS FullName,
            ISNULL(u.fcPosition, '') AS Position,
            COUNT(DISTINCT b.fcBookID) AS TotalBookings,
            ISNULL(SUM(b.fnSoLuongDK), 0) AS TotalGuests,
            COUNT(DISTINCT CASE WHEN b.fcStatus_BkRoom = 'D' THEN b.fcBookID END) AS ConfirmedCount,
            COUNT(DISTINCT CASE WHEN b.fcStatus_BkRoom = 'C' THEN b.fcBookID END) AS CancelledCount,
            ISNULL(SUM(CASE WHEN b.fcStatus_BkRoom = 'C' THEN 0 ELSE ISNULL(eo_rev.TotalRev, ISNULL(bc_rev.TotalRev, 0)) END), 0) AS TotalRevenue
        FROM MatchedBookings mb
        INNER JOIN stBooking b ON mb.fcBookID = b.fcBookID
        LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
        LEFT JOIN stUser u ON ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser) = u.fcUserName
        LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
        LEFT JOIN (
            SELECT fcMaster_EO, SUM(fnAmount) AS TotalRev
            FROM stSKLK_DoanhThu
            GROUP BY fcMaster_EO
        ) eo_rev ON meo.fcMaster_EO IS NOT NULL AND meo.fcMaster_EO <> '' AND meo.fcMaster_EO = eo_rev.fcMaster_EO
        LEFT JOIN (
            SELECT fcBookID, SUM(fnAmount) AS TotalRev
            FROM stBooking_Charges
            GROUP BY fcBookID
        ) bc_rev ON b.fcBookID = bc_rev.fcBookID
        WHERE ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser) IS NOT NULL AND ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser) <> ''
        GROUP BY ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser), u.fcFullName, u.fcPosition
        ORDER BY TotalRevenue DESC;
        """
        
        cur.execute(sql, params)
        data = []
        for r in cur.fetchall():
            tot = int(r[3] or 0)
            conf = int(r[5] or 0)
            canc = int(r[6] or 0)
            data.append({
                "code": r[0],
                "name": r[1] or r[0],
                "position": r[2],
                "total_bookings": tot,
                "total_guests": float(r[4] or 0),
                "confirmed_count": conf,
                "cancelled_count": canc,
                "win_rate": min(round((conf / tot * 100), 1), 100.0) if tot > 0 else 0,
                "total_revenue": float(r[7] or 0)
            })
            
        cur.close()
        cn.close()
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/stats/timeline")
def get_timeline_stats(
    year: Optional[int] = None,
    month: Optional[int] = None,
    hall: Optional[str] = None,
    segment: Optional[str] = None,
    channel: Optional[str] = None,
    sales_user: Optional[str] = None,
    status: Optional[str] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    date_type: Optional[str] = "event"
):
    try:
        where_sql, params = build_where_clause(year, month, hall, segment, channel, sales_user, status, None, date_from, date_to, date_type)
        dt_col = "ISNULL(bfr.fdDate, b.fdDate)" if date_type == "event" else "b.fdDate"
        cn = get_db()
        cur = cn.cursor()
        
        sql_month = f"""
        WITH MatchedBookings AS (
            SELECT DISTINCT 
                b.fcBookID,
                YEAR({dt_col}) AS Nam,
                MONTH({dt_col}) AS Thang,
                b.fnSoLuongDK,
                b.fcStatus_BkRoom,
                meo.fcMaster_EO
            FROM stBooking b
            LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
            LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
            LEFT JOIN stBookFunctionRoom bfr ON b.fcBookID = bfr.fcBookID
            WHERE {where_sql} AND {dt_col} IS NOT NULL
        )
        SELECT 
            mb.Nam,
            mb.Thang,
            COUNT(DISTINCT mb.fcBookID) AS TotalBookings,
            ISNULL(SUM(mb.fnSoLuongDK), 0) AS TotalGuests,
            ISNULL(SUM(CASE WHEN mb.fcStatus_BkRoom = 'C' THEN 0 ELSE ISNULL(eo_rev.TotalRev, ISNULL(bc_rev.TotalRev, 0)) END), 0) AS TotalRevenue
        FROM MatchedBookings mb
        LEFT JOIN (
            SELECT fcMaster_EO, SUM(fnAmount) AS TotalRev
            FROM stSKLK_DoanhThu
            GROUP BY fcMaster_EO
        ) eo_rev ON mb.fcMaster_EO IS NOT NULL AND mb.fcMaster_EO <> '' AND mb.fcMaster_EO = eo_rev.fcMaster_EO
        LEFT JOIN (
            SELECT fcBookID, SUM(fnAmount) AS TotalRev
            FROM stBooking_Charges
            GROUP BY fcBookID
        ) bc_rev ON mb.fcBookID = bc_rev.fcBookID
        GROUP BY mb.Nam, mb.Thang
        ORDER BY Nam ASC, Thang ASC;
        """
        cur.execute(sql_month, params)
        monthly = [
            {
                "year": int(r[0]),
                "month": int(r[1]),
                "label": f"T{int(r[1])}/{int(r[0])}",
                "bookings": int(r[2] or 0),
                "guests": float(r[3] or 0),
                "revenue": float(r[4] or 0)
            }
            for r in cur.fetchall()
        ]
        
        sql_dow = f"""
        WITH MatchedBookings AS (
            SELECT DISTINCT 
                b.fcBookID,
                DATEPART(dw, {dt_col}) AS ThuID,
                b.fnSoLuongDK
            FROM stBooking b
            LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
            LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
            LEFT JOIN stBookFunctionRoom bfr ON b.fcBookID = bfr.fcBookID
            WHERE {where_sql} AND {dt_col} IS NOT NULL
        )
        SELECT 
            mb.ThuID,
            COUNT(DISTINCT mb.fcBookID) AS TotalBookings,
            ISNULL(SUM(mb.fnSoLuongDK), 0) AS TotalGuests
        FROM MatchedBookings mb
        GROUP BY mb.ThuID
        ORDER BY ThuID ASC;
        """
        cur.execute(sql_dow, params)
        dow_names = {1: "Chủ Nhật", 2: "Thứ 2", 3: "Thứ 3", 4: "Thứ 4", 5: "Thứ 5", 6: "Thứ 6", 7: "Thứ 7"}
        dow = [
            {
                "day_id": int(r[0]),
                "day_name": dow_names.get(int(r[0]), f"Thứ {r[0]}"),
                "bookings": int(r[1] or 0),
                "guests": float(r[2] or 0)
            }
            for r in cur.fetchall()
        ]
        
        cur.close()
        cn.close()
        return {"monthly": monthly, "day_of_week": dow}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/stats/services")
def get_service_stats(
    year: Optional[int] = None,
    month: Optional[int] = None,
    hall: Optional[str] = None,
    segment: Optional[str] = None,
    channel: Optional[str] = None,
    sales_user: Optional[str] = None,
    status: Optional[str] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    date_type: Optional[str] = "event"
):
    try:
        where_sql, params = build_where_clause(year, month, hall, segment, channel, sales_user, status, None, date_from, date_to, date_type)
        cn = get_db()
        cur = cn.cursor()
        
        sql = f"""
        WITH MatchedBookings AS (
            SELECT DISTINCT b.fcBookID
            FROM stBooking b
            LEFT JOIN stBookFunctionRoom bfr ON b.fcBookID = bfr.fcBookID
            LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
            LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
            WHERE {where_sql}
        )
        SELECT 
            ISNULL(dtl.fcName, N'Dịch vụ khác') AS ServiceName,
            ISNULL(dtl.fcGroup, '00') AS ServiceGroup,
            COUNT(item.fnID) AS ItemCount,
            ISNULL(SUM(item.fnAmount), 0) AS TotalAmount
        FROM MatchedBookings mb
        INNER JOIN stBooking b ON mb.fcBookID = b.fcBookID
        LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
        CROSS APPLY (
            SELECT d.fnID, d.fcDoanhThu_Type AS fcCode, d.fnAmount
            FROM stSKLK_DoanhThu d
            WHERE meo.fcMaster_EO IS NOT NULL AND meo.fcMaster_EO <> '' AND d.fcMaster_EO = meo.fcMaster_EO
            UNION ALL
            SELECT c.fnID, c.fcDoanhThu_Loai AS fcCode, c.fnAmount
            FROM stBooking_Charges c
            WHERE c.fcBookID = b.fcBookID 
              AND NOT EXISTS (
                  SELECT 1 FROM stSKLK_DoanhThu d2 
                  WHERE meo.fcMaster_EO IS NOT NULL AND meo.fcMaster_EO <> '' AND d2.fcMaster_EO = meo.fcMaster_EO
              )
        ) item
        LEFT JOIN stDoanhThu_Loai dtl ON item.fcCode = dtl.fcCode
        WHERE b.fcStatus_BkRoom <> 'C'
        GROUP BY dtl.fcName, dtl.fcGroup
        ORDER BY TotalAmount DESC;
        """
        cur.execute(sql, params)
        rows = cur.fetchall()
        
        group_names = {
            "02": "Thức uống & Rượu bia",
            "03": "Dịch vụ tiệc, LED, MC, Trang trí",
            "04": "Ẩm thực & Set Menu F&B",
            "05": "Phòng lưu trú & Khách sạn",
            "06": "Thuê sảnh hội nghị / tiệc"
        }
        
        grouped = {}
        for r in rows:
            g_code = r[1]
            g_name = group_names.get(g_code, "Khác")
            amt = float(r[3] or 0)
            if g_name not in grouped:
                grouped[g_name] = {"group": g_name, "total_amount": 0, "items_count": 0}
            grouped[g_name]["total_amount"] += amt
            grouped[g_name]["items_count"] += int(r[2] or 0)
            
        top_items = [
            {"name": r[0], "group": group_names.get(r[1], "Khác"), "count": int(r[2] or 0), "amount": float(r[3] or 0)}
            for r in rows[:15]
        ]
        
        cur.close()
        cn.close()
        return {
            "by_category": list(grouped.values()),
            "top_services": top_items
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/bookings")
def get_bookings(
    year: Optional[int] = None,
    month: Optional[int] = None,
    hall: Optional[str] = None,
    segment: Optional[str] = None,
    channel: Optional[str] = None,
    sales_user: Optional[str] = None,
    status: Optional[str] = None,
    search: Optional[str] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    date_type: Optional[str] = "event",
    limit: int = 100,
    offset: int = 0
):
    try:
        where_sql, params = build_where_clause(year, month, hall, segment, channel, sales_user, status, search, date_from, date_to, date_type)
        cn = get_db()
        cur = cn.cursor()
        
        # Count total & breakdown by status
        cur.execute(f"""
            SELECT 
                COUNT(DISTINCT b.fcBookID),
                SUM(CASE WHEN b.fcStatus_BkRoom = 'D' THEN 1 ELSE 0 END),
                SUM(CASE WHEN b.fcStatus_BkRoom = 'C' THEN 1 ELSE 0 END),
                SUM(CASE WHEN b.fcStatus_BkRoom = 'T' THEN 1 ELSE 0 END)
            FROM stBooking b
            LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
            LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
            LEFT JOIN stBookFunctionRoom bfr ON b.fcBookID = bfr.fcBookID
            WHERE {where_sql}
        """, params)
        c_row = cur.fetchone()
        total_records = int(c_row[0] or 0)
        confirmed_count = int(c_row[1] or 0)
        cancelled_count = int(c_row[2] or 0)
        tentative_count = int(c_row[3] or 0)
        
        # Query page with BEO Creator vs Lock User clearly separated
        sql = f"""
        WITH MatchedBookings AS (
            SELECT DISTINCT b.fcBookID
            FROM stBooking b
            LEFT JOIN stBookFunctionRoom bfr ON b.fcBookID = bfr.fcBookID
            LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
            LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
            WHERE {where_sql}
        )
        SELECT 
            b.fcBookID,
            CONVERT(varchar(10), b.fdDate, 120) AS BookingDate,
            ISNULL(bfr_meta.FirstEventDate, CONVERT(varchar(10), b.fdDate, 120)) AS EventDate,
            ISNULL(b.fcTitle, '') AS EventTitle,
            ISNULL(b.fcStatus_BkRoom, '') AS StatusCode,
            ISNULL(st.fcName, b.fcStatus_BkRoom) AS StatusName,
            CASE WHEN ISNULL(b.fnSoLuongDK, 0) > 0 THEN b.fnSoLuongDK ELSE ISNULL(bfr_meta.MaxQuantity, 0) END AS Guests,
            ISNULL(b.fnDatCoc, ISNULL(meo.fnDatCoc, 0)) AS Deposit,
            ISNULL(k.fcTen, '') AS CustomerName,
            ISNULL(k.fcTelephone, '') AS Phone,
            -- Effective Sales (BEO Creator first)
            ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser) AS EffectiveUserCode,
            ISNULL(u_beo.fcFullName, ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser)) AS EffectiveUserName,
            b.fcUser AS LockUserCode,
            ISNULL(u_lock.fcFullName, b.fcUser) AS LockUserName,
            ISNULL(meo.fcNguoiLap, '') AS BEOCreatorCode,
            ISNULL(bfr_meta.HallNames, N'Chưa xếp') AS HallNames,
            ISNULL(lv.fcName, N'Chưa rõ') AS SegmentName,
            ISNULL(kl.fcName, N'Chưa rõ') AS ChannelName,
            CASE WHEN b.fcStatus_BkRoom = 'C' THEN 0 ELSE ISNULL(eo_rev.BanquetAmount, ISNULL(bc_rev.BanquetAmount, 0)) END AS BanquetAmount,
            CASE WHEN b.fcStatus_BkRoom = 'C' THEN 0 ELSE ISNULL(eo_rev.TongTien, ISNULL(bc_rev.TongTien, 0)) END AS TotalAmount,
            CASE WHEN b.fcStatus_BkRoom = 'C' THEN 0 ELSE ISNULL(eo_rev.RoomAmount, ISNULL(bc_rev.RoomAmount, 0)) END AS RoomAmount
        FROM MatchedBookings mb
        INNER JOIN stBooking b ON mb.fcBookID = b.fcBookID
        LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
        LEFT JOIN stBooking_Status st ON b.fcStatus_BkRoom = st.fcCode
        LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
        LEFT JOIN stLinhVuc lv ON k.fcLinhVuc = lv.fcCode
        LEFT JOIN stKhachHang_Loai kl ON k.fcLoaiKhach = kl.fcCode
        LEFT JOIN stUser u_beo ON ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser) = u_beo.fcUserName
        LEFT JOIN stUser u_lock ON b.fcUser = u_lock.fcUserName
        LEFT JOIN (
            SELECT 
                bfr2.fcBookID,
                MIN(CONVERT(varchar(10), bfr2.fdDate, 120)) AS FirstEventDate,
                MAX(bfr2.fnQuantity) AS MaxQuantity,
                MIN(p2.fcTen) AS HallNames
            FROM stBookFunctionRoom bfr2
            LEFT JOIN stPhong p2 ON bfr2.fcFunctionRoom = p2.fcMa
            GROUP BY bfr2.fcBookID
        ) bfr_meta ON b.fcBookID = bfr_meta.fcBookID
        LEFT JOIN (
            SELECT 
                d.fcMaster_EO,
                SUM(d.fnAmount) AS TongTien,
                SUM(CASE WHEN dt.fcGroup IN ('01', '02', '03', '04', '06') OR (d.fcDoanhThu_Type NOT IN ('24', '56') AND (dt.fcGroup IS NULL OR dt.fcGroup <> '05')) THEN d.fnAmount ELSE 0 END) AS BanquetAmount,
                SUM(CASE WHEN dt.fcGroup = '05' OR d.fcDoanhThu_Type IN ('24', '56') THEN d.fnAmount ELSE 0 END) AS RoomAmount
            FROM stSKLK_DoanhThu d
            LEFT JOIN stDoanhThu_Loai dt ON d.fcDoanhThu_Type = dt.fcCode
            GROUP BY d.fcMaster_EO
        ) eo_rev ON meo.fcMaster_EO IS NOT NULL AND meo.fcMaster_EO <> '' AND meo.fcMaster_EO = eo_rev.fcMaster_EO
        LEFT JOIN (
            SELECT 
                c.fcBookID,
                SUM(c.fnAmount) AS TongTien,
                SUM(CASE WHEN dt.fcGroup IN ('01', '02', '03', '04', '06') OR (c.fcDoanhThu_Loai NOT IN ('24', '56') AND (dt.fcGroup IS NULL OR dt.fcGroup <> '05')) THEN c.fnAmount ELSE 0 END) AS BanquetAmount,
                SUM(CASE WHEN dt.fcGroup = '05' OR c.fcDoanhThu_Loai IN ('24', '56') THEN c.fnAmount ELSE 0 END) AS RoomAmount
            FROM stBooking_Charges c
            LEFT JOIN stDoanhThu_Loai dt ON c.fcDoanhThu_Loai = dt.fcCode
            GROUP BY c.fcBookID
        ) bc_rev ON b.fcBookID = bc_rev.fcBookID
        ORDER BY ISNULL(bfr_meta.FirstEventDate, b.fdDate) DESC, b.fcBookID DESC
        OFFSET {int(offset)} ROWS FETCH NEXT {int(limit)} ROWS ONLY;
        """
        
        cur.execute(sql, params)
        
        items = []
        for r in cur.fetchall():
            items.append({
                "booking_id": r[0],
                "booking_date": r[1],
                "event_date": r[2],
                "title": r[3],
                "status_code": r[4],
                "status_name": r[5],
                "guests": float(r[6] or 0),
                "deposit": float(r[7] or 0),
                "customer": r[8],
                "phone": r[9],
                "sales_code": r[10],
                "sales_name": r[11],
                "lock_user_code": r[12],
                "lock_user_name": r[13],
                "beo_user_code": r[14],
                "hall_names": r[15],
                "segment": r[16],
                "channel": r[17],
                "banquet_rev": float(r[18] or 0),
                "total_rev": float(r[19] or 0),
                "total_amount": float(r[19] or 0),
                "room_rev": float(r[20] or 0)
            })
            
        cur.close()
        cn.close()
        return {
            "total": total_records, 
            "confirmed_count": confirmed_count,
            "cancelled_count": cancelled_count,
            "tentative_count": tentative_count,
            "limit": limit, 
            "offset": offset, 
            "items": items
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/export")
def export_excel(
    year: Optional[int] = None,
    month: Optional[int] = None,
    hall: Optional[str] = None,
    segment: Optional[str] = None,
    channel: Optional[str] = None,
    sales_user: Optional[str] = None,
    status: Optional[str] = None,
    search: Optional[str] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    date_type: Optional[str] = "event",
    book_ids: Optional[str] = None
):
    try:
        where_sql, params = build_where_clause(year, month, hall, segment, channel, sales_user, status, search, date_from, date_to, date_type, book_ids)
        cn = get_db()
        cur = cn.cursor()
        
        sql = f"""
        WITH MatchedBookings AS (
            SELECT DISTINCT b.fcBookID
            FROM stBooking b
            LEFT JOIN stBookFunctionRoom bfr ON b.fcBookID = bfr.fcBookID
            LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
            LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
            WHERE {where_sql}
        )
        SELECT 
            b.fcBookID AS [Mã Booking],
            ISNULL(bfr_meta.FirstEventDate, CONVERT(varchar(10), b.fdDate, 120)) AS [Ngày Diễn Ra Tiệc],
            CONVERT(varchar(10), b.fdDate, 120) AS [Ngày Đặt Cọc/Tạo Đơn],
            ISNULL(b.fcTitle, '') AS [Tên Tiệc/Sự Kiện],
            ISNULL(k.fcTen, '') AS [Khách Hàng],
            ISNULL(k.fcTelephone, '') AS [SĐT],
            ISNULL(bfr_meta.HallNames, N'Chưa xếp') AS [Sảnh Tiệc],
            ISNULL(lv.fcName, N'Chưa rõ') AS [Phân Khúc/Lĩnh Vực],
            ISNULL(kl.fcName, N'Chưa rõ') AS [Nguồn Tiếp Thị],
            -- Revenue belongs to BEO creator
            ISNULL(u_beo.fcFullName, ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser)) AS [Người Hưởng Doanh Thu (Lập BEO)],
            ISNULL(u_lock.fcFullName, b.fcUser) AS [Người Giữ Sảnh Ban Đầu (Lock)],
            ISNULL(st.fcName, b.fcStatus_BkRoom) AS [Trạng Thái],
            CASE WHEN ISNULL(b.fnSoLuongDK, 0) > 0 THEN b.fnSoLuongDK ELSE ISNULL(bfr_meta.MaxQuantity, 0) END AS [Số Khách],
            ISNULL(b.fnDatCoc, ISNULL(meo.fnDatCoc, 0)) AS [Tiền Cọc (VNĐ)],
            CASE WHEN b.fcStatus_BkRoom = 'C' THEN 0 ELSE ISNULL(eo_rev.BanquetAmount, ISNULL(bc_rev.BanquetAmount, 0)) END AS [Doanh Thu Tiệc - Banquet (VNĐ)],
            CASE WHEN b.fcStatus_BkRoom = 'C' THEN 0 ELSE ISNULL(eo_rev.TongTien, ISNULL(bc_rev.TongTien, 0)) END AS [Tổng Doanh Thu - Total (VNĐ)]
        FROM MatchedBookings mb
        INNER JOIN stBooking b ON mb.fcBookID = b.fcBookID
        LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
        LEFT JOIN stBooking_Status st ON b.fcStatus_BkRoom = st.fcCode
        LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
        LEFT JOIN stLinhVuc lv ON k.fcLinhVuc = lv.fcCode
        LEFT JOIN stKhachHang_Loai kl ON k.fcLoaiKhach = kl.fcCode
        LEFT JOIN stUser u_beo ON ISNULL(NULLIF(meo.fcNguoiLap, ''), b.fcUser) = u_beo.fcUserName
        LEFT JOIN stUser u_lock ON b.fcUser = u_lock.fcUserName
        LEFT JOIN (
            SELECT 
                bfr2.fcBookID,
                MIN(CONVERT(varchar(10), bfr2.fdDate, 120)) AS FirstEventDate,
                MAX(bfr2.fnQuantity) AS MaxQuantity,
                MIN(p2.fcTen) AS HallNames
            FROM stBookFunctionRoom bfr2
            LEFT JOIN stPhong p2 ON bfr2.fcFunctionRoom = p2.fcMa
            GROUP BY bfr2.fcBookID
        ) bfr_meta ON b.fcBookID = bfr_meta.fcBookID
        LEFT JOIN (
            SELECT 
                d.fcMaster_EO,
                SUM(d.fnAmount) AS TongTien,
                SUM(CASE WHEN dt.fcGroup IN ('01', '02', '03', '04', '06') OR (d.fcDoanhThu_Type NOT IN ('24', '56') AND (dt.fcGroup IS NULL OR dt.fcGroup <> '05')) THEN d.fnAmount ELSE 0 END) AS BanquetAmount
            FROM stSKLK_DoanhThu d
            LEFT JOIN stDoanhThu_Loai dt ON d.fcDoanhThu_Type = dt.fcCode
            GROUP BY d.fcMaster_EO
        ) eo_rev ON meo.fcMaster_EO IS NOT NULL AND meo.fcMaster_EO <> '' AND meo.fcMaster_EO = eo_rev.fcMaster_EO
        LEFT JOIN (
            SELECT 
                c.fcBookID,
                SUM(c.fnAmount) AS TongTien,
                SUM(CASE WHEN dt.fcGroup IN ('01', '02', '03', '04', '06') OR (c.fcDoanhThu_Loai NOT IN ('24', '56') AND (dt.fcGroup IS NULL OR dt.fcGroup <> '05')) THEN c.fnAmount ELSE 0 END) AS BanquetAmount
            FROM stBooking_Charges c
            LEFT JOIN stDoanhThu_Loai dt ON c.fcDoanhThu_Loai = dt.fcCode
            GROUP BY c.fcBookID
        ) bc_rev ON b.fcBookID = bc_rev.fcBookID
        ORDER BY ISNULL(bfr_meta.FirstEventDate, b.fdDate) DESC;
        """
        
        cur.execute(sql, params)
        columns = [col[0] for col in cur.description]
        rows = cur.fetchall()
        cur.close()
        cn.close()

        # 2. Lấy dữ liệu KPI Summary và Hall Stats để dựng báo cáo chuẩn Executive
        try:
            summary = get_summary(year, month, hall, segment, channel, sales_user, status, date_from, date_to, date_type)
        except Exception:
            summary = {}

        try:
            hall_stats = get_hall_stats(year, month, hall, segment, channel, sales_user, status, date_from, date_to, date_type)
        except Exception:
            hall_stats = []

        # Chuỗi mô tả bộ lọc
        now_str = datetime.datetime.now().strftime("%d/%m/%Y %H:%M")
        filter_parts = []
        if date_from and date_to:
            filter_parts.append(f"Ngày {date_type}: {date_from} đến {date_to}")
        elif year and month:
            filter_parts.append(f"Tháng {month}/{year}")
        elif year:
            filter_parts.append(f"Năm {year}")
        else:
            filter_parts.append(f"Ngày {date_type}: Toàn bộ thời gian")
            
        if hall and hall != 'ALL': filter_parts.append(f"Sảnh: {hall}")
        if segment and segment != 'ALL': filter_parts.append(f"Phân khúc: {segment}")
        if channel and channel != 'ALL': filter_parts.append(f"Kênh: {channel}")
        if sales_user and sales_user != 'ALL': filter_parts.append(f"Sales: {sales_user}")
        if status and status != 'ALL': filter_parts.append(f"Trạng thái: {status}")
        if search: filter_parts.append(f"Tìm kiếm: '{search}'")
        filter_text = " • ".join(filter_parts)

        output = io.BytesIO()
        with pd.ExcelWriter(output, engine='xlsxwriter') as writer:
            workbook = writer.book

            # ================= STYLES & FORMATS ĐẲNG CẤP EXECUTIVE =================
            fmt_title = workbook.add_format({
                'bold': True, 'font_size': 15, 'font_name': 'Calibri',
                'font_color': '#0F172A', 'valign': 'vcenter'
            })
            fmt_subtitle = workbook.add_format({
                'italic': True, 'font_size': 9.5, 'font_name': 'Calibri',
                'font_color': '#475569', 'valign': 'vcenter'
            })
            fmt_meta_right = workbook.add_format({
                'font_size': 9, 'font_name': 'Calibri',
                'font_color': '#64748B', 'align': 'right', 'valign': 'vcenter'
            })
            fmt_filter_box = workbook.add_format({
                'font_size': 9.5, 'font_name': 'Calibri', 'font_color': '#1E293B',
                'bg_color': '#F8FAFC', 'border': 1, 'border_color': '#CBD5E1',
                'valign': 'vcenter'
            })

            # KPI Card Formats
            fmt_kpi_head = workbook.add_format({
                'bold': True, 'font_size': 8.5, 'font_name': 'Calibri',
                'font_color': '#475569', 'bg_color': '#F1F5F9',
                'align': 'center', 'valign': 'vcenter',
                'top': 1, 'left': 1, 'right': 1, 'border_color': '#CBD5E1'
            })
            fmt_kpi_val_curr = workbook.add_format({
                'bold': True, 'font_size': 13, 'font_name': 'Calibri',
                'font_color': '#047857', 'num_format': '#,##0 "đ"',
                'bg_color': '#FFFFFF', 'align': 'center', 'valign': 'vcenter',
                'left': 1, 'right': 1, 'border_color': '#CBD5E1'
            })
            fmt_kpi_val_int = workbook.add_format({
                'bold': True, 'font_size': 13, 'font_name': 'Calibri',
                'font_color': '#1D4ED8', 'num_format': '#,##0',
                'bg_color': '#FFFFFF', 'align': 'center', 'valign': 'vcenter',
                'left': 1, 'right': 1, 'border_color': '#CBD5E1'
            })
            fmt_kpi_sub = workbook.add_format({
                'font_size': 8.5, 'font_name': 'Calibri',
                'font_color': '#64748B', 'bg_color': '#F8FAFC',
                'align': 'center', 'valign': 'vcenter',
                'bottom': 1, 'left': 1, 'right': 1, 'border_color': '#CBD5E1'
            })

            # Table Header & Data Formats
            fmt_tbl_title = workbook.add_format({
                'bold': True, 'font_size': 11, 'font_name': 'Calibri',
                'font_color': '#0F172A', 'valign': 'vcenter'
            })
            fmt_th = workbook.add_format({
                'bold': True, 'font_size': 9.5, 'font_name': 'Calibri',
                'font_color': '#FFFFFF', 'bg_color': '#1E293B',
                'align': 'center', 'valign': 'vcenter', 'text_wrap': True,
                'border': 1, 'border_color': '#334155'
            })
            fmt_td_left_w = workbook.add_format({'font_size': 9.5, 'font_name': 'Calibri', 'valign': 'vcenter', 'border': 1, 'border_color': '#E2E8F0', 'bg_color': '#FFFFFF'})
            fmt_td_left_z = workbook.add_format({'font_size': 9.5, 'font_name': 'Calibri', 'valign': 'vcenter', 'border': 1, 'border_color': '#E2E8F0', 'bg_color': '#F8FAFC'})
            fmt_td_center_w = workbook.add_format({'font_size': 9.5, 'font_name': 'Calibri', 'align': 'center', 'valign': 'vcenter', 'border': 1, 'border_color': '#E2E8F0', 'bg_color': '#FFFFFF'})
            fmt_td_center_z = workbook.add_format({'font_size': 9.5, 'font_name': 'Calibri', 'align': 'center', 'valign': 'vcenter', 'border': 1, 'border_color': '#E2E8F0', 'bg_color': '#F8FAFC'})
            fmt_td_num_w = workbook.add_format({'font_size': 9.5, 'font_name': 'Calibri', 'align': 'right', 'valign': 'vcenter', 'num_format': '#,##0', 'border': 1, 'border_color': '#E2E8F0', 'bg_color': '#FFFFFF'})
            fmt_td_num_z = workbook.add_format({'font_size': 9.5, 'font_name': 'Calibri', 'align': 'right', 'valign': 'vcenter', 'num_format': '#,##0', 'border': 1, 'border_color': '#E2E8F0', 'bg_color': '#F8FAFC'})
            fmt_td_curr_w = workbook.add_format({'font_size': 9.5, 'font_name': 'Calibri', 'align': 'right', 'valign': 'vcenter', 'num_format': '#,##0 "đ"', 'border': 1, 'border_color': '#E2E8F0', 'bg_color': '#FFFFFF'})
            fmt_td_curr_z = workbook.add_format({'font_size': 9.5, 'font_name': 'Calibri', 'align': 'right', 'valign': 'vcenter', 'num_format': '#,##0 "đ"', 'border': 1, 'border_color': '#E2E8F0', 'bg_color': '#F8FAFC'})
            fmt_td_pct_w = workbook.add_format({'bold': True, 'font_size': 9.5, 'font_name': 'Calibri', 'align': 'center', 'valign': 'vcenter', 'num_format': '0.0%', 'font_color': '#059669', 'border': 1, 'border_color': '#E2E8F0', 'bg_color': '#FFFFFF'})
            fmt_td_pct_z = workbook.add_format({'bold': True, 'font_size': 9.5, 'font_name': 'Calibri', 'align': 'center', 'valign': 'vcenter', 'num_format': '0.0%', 'font_color': '#059669', 'border': 1, 'border_color': '#E2E8F0', 'bg_color': '#F8FAFC'})

            # Total Row Formats
            fmt_tot_label = workbook.add_format({'bold': True, 'font_size': 10, 'font_name': 'Calibri', 'align': 'center', 'valign': 'vcenter', 'bg_color': '#E2E8F0', 'border': 1, 'border_color': '#94A3B8'})
            fmt_tot_num = workbook.add_format({'bold': True, 'font_size': 10, 'font_name': 'Calibri', 'align': 'right', 'valign': 'vcenter', 'num_format': '#,##0', 'bg_color': '#E2E8F0', 'border': 1, 'border_color': '#94A3B8', 'bottom': 6})
            fmt_tot_curr = workbook.add_format({'bold': True, 'font_size': 10.5, 'font_name': 'Calibri', 'align': 'right', 'valign': 'vcenter', 'num_format': '#,##0 "đ"', 'bg_color': '#E2E8F0', 'border': 1, 'border_color': '#94A3B8', 'bottom': 6})
            fmt_tot_pct = workbook.add_format({'bold': True, 'font_size': 10, 'font_name': 'Calibri', 'align': 'center', 'valign': 'vcenter', 'num_format': '0.0%', 'font_color': '#059669', 'bg_color': '#E2E8F0', 'border': 1, 'border_color': '#94A3B8', 'bottom': 6})

            # =========================================================================
            # SHEET 1: BÁO CÁO TỔNG HỢP & CHI TIẾT SẢNH TIỆC (Y HỆT BẢN IN PDF!)
            # =========================================================================
            ws1 = workbook.add_worksheet('BaoCao_TongHop')
            ws1.set_paper(9) # A4
            ws1.set_landscape()
            ws1.hide_gridlines(0) # Hiển thị gridline đẹp

            # Header MerPerle
            ws1.merge_range('A1:F1', 'TRUNG TÂM HỘI NGHỊ TIỆC CƯỚI & KHÁCH SẠN MERPERLE', fmt_title)
            ws1.merge_range('G1:I1', f'Ngày xuất: {now_str}', fmt_meta_right)
            ws1.merge_range('A2:F2', 'Hệ Thống Quản Lý Sự Kiện & Tiệc Cưới EMS • Báo Cáo Thống Kê Tổng Hợp', fmt_subtitle)
            ws1.merge_range('G2:I2', 'Tiêu chuẩn: BGĐ & Phòng Kinh Doanh Banquet', fmt_meta_right)
            
            # Khung Bộ lọc áp dụng
            ws1.merge_range('A4:I4', f'  Bộ lọc áp dụng: {filter_text}', fmt_filter_box)

            # 4 THẺ KPI DASHBOARD
            tot_rev = summary.get('total_revenue', 0)
            avg_rev = summary.get('avg_revenue_per_booking', 0)
            tot_bk = summary.get('total_bookings', 0)
            conf_bk = summary.get('confirmed_bookings', 0)
            conf_rate = summary.get('win_rate', 0)
            tot_guests = summary.get('total_guests', 0)
            avg_guests = summary.get('avg_guests_per_booking', 0)
            tot_dep = summary.get('total_deposit', 0)
            canc_bk = summary.get('cancelled_bookings', 0)
            canc_rate = summary.get('cancel_rate', 0)

            # Card 1: Doanh thu (A6:B8)
            ws1.merge_range('A6:B6', 'TỔNG DOANH THU', fmt_kpi_head)
            ws1.merge_range('A7:B7', tot_rev, fmt_kpi_val_curr)
            ws1.merge_range('A8:B8', f'TB/tiệc: {int(avg_rev):,} đ', fmt_kpi_sub)

            # Card 2: Bookings (C6:D8)
            ws1.merge_range('C6:D6', 'SỐ LƯỢNG BOOKING', fmt_kpi_head)
            ws1.merge_range('C7:D7', tot_bk, fmt_kpi_val_int)
            ws1.merge_range('C8:D8', f'Chốt: {conf_bk}  •  Tỷ lệ: {conf_rate}%', fmt_kpi_sub)

            # Card 3: Khách PAX (E6:F8)
            ws1.merge_range('E6:F6', 'LƯỢNG KHÁCH PHỤC VỤ (PAX)', fmt_kpi_head)
            ws1.merge_range('E7:F7', tot_guests, fmt_kpi_val_int)
            ws1.merge_range('E8:F8', f'Quy mô TB: {int(avg_guests):,} khách/tiệc', fmt_kpi_sub)

            # Card 4: Đặt cọc & Hủy (G6:H8)
            ws1.merge_range('G6:H6', 'ĐẶT CỌC & HỦY ĐƠN', fmt_kpi_head)
            ws1.merge_range('G7:H7', tot_dep, fmt_kpi_val_curr)
            ws1.merge_range('G8:H8', f'Đã hủy: {canc_bk}  •  Tỷ lệ: {canc_rate}%', fmt_kpi_sub)

            # Bảng Thống Kê Chi Tiết Từng Sảnh Tiệc
            ws1.write('A10', 'Bảng Tổng Hợp Chi Tiết Từng Sảnh Tiệc (Phân theo vị trí tầng và năng lực phục vụ)', fmt_tbl_title)
            
            hall_headers = [
                'TÊN SẢNH', 'VỊ TRÍ / TẦNG', 'DIỆN TÍCH', 'TỔNG BOOKING',
                'LƯỢNG KHÁCH (PAX)', 'CHỐT THÀNH CÔNG', 'TỶ LỆ CHỐT', 'ĐÃ HỦY', 'TỔNG DOANH THU'
            ]
            ws1.set_row(10, 24)
            for c_idx, h_txt in enumerate(hall_headers):
                ws1.write(10, c_idx, h_txt, fmt_th)

            r_idx = 11
            sum_h_bk = 0
            sum_h_guests = 0
            sum_h_conf = 0
            sum_h_canc = 0
            sum_h_rev = 0

            for h in hall_stats:
                is_z = (r_idx % 2 == 1)
                t_left = fmt_td_left_z if is_z else fmt_td_left_w
                t_cent = fmt_td_center_z if is_z else fmt_td_center_w
                t_num = fmt_td_num_z if is_z else fmt_td_num_w
                t_curr = fmt_td_curr_z if is_z else fmt_td_curr_w
                t_pct = fmt_td_pct_z if is_z else fmt_td_pct_w

                bk_c = int(h.get('total_bookings', 0))
                gu_c = float(h.get('total_guests', 0))
                co_c = int(h.get('confirmed_count', 0))
                ca_c = int(h.get('cancelled_count', 0))
                rv_c = float(h.get('total_revenue', 0))
                wr_c = float(h.get('win_rate', 0)) / 100.0

                sum_h_bk += bk_c
                sum_h_guests += gu_c
                sum_h_conf += co_c
                sum_h_canc += ca_c
                sum_h_rev += rv_c

                area_disp = f"{h.get('area_m2')} m²" if h.get('area_m2') else "-"
                ws1.write(r_idx, 0, h.get('name', ''), t_left)
                ws1.write(r_idx, 1, h.get('floor', ''), t_cent)
                ws1.write(r_idx, 2, area_disp, t_cent)
                ws1.write(r_idx, 3, bk_c, t_num)
                ws1.write(r_idx, 4, gu_c, t_num)
                ws1.write(r_idx, 5, co_c, t_num)
                ws1.write(r_idx, 6, wr_c, t_pct)
                ws1.write(r_idx, 7, ca_c, t_num)
                ws1.write(r_idx, 8, rv_c, t_curr)
                ws1.set_row(r_idx, 20)
                r_idx += 1

            # Dòng TỔNG CỘNG cho Bảng Sảnh
            ws1.merge_range(r_idx, 0, r_idx, 2, 'TỔNG CỘNG HỆ THỐNG SẢNH', fmt_tot_label)
            ws1.write(r_idx, 3, sum_h_bk, fmt_tot_num)
            ws1.write(r_idx, 4, sum_h_guests, fmt_tot_num)
            ws1.write(r_idx, 5, sum_h_conf, fmt_tot_num)
            ws1.write(r_idx, 6, (sum_h_conf / sum_h_bk) if sum_h_bk > 0 else 0, fmt_tot_pct)
            ws1.write(r_idx, 7, sum_h_canc, fmt_tot_num)
            ws1.write(r_idx, 8, sum_h_rev, fmt_tot_curr)
            ws1.set_row(r_idx, 22)

            # Căn chỉnh độ rộng các cột Sheet 1
            ws1.set_column('A:A', 20) # Sảnh
            ws1.set_column('B:B', 15) # Tầng
            ws1.set_column('C:C', 14) # Diện tích
            ws1.set_column('D:D', 15) # Booking
            ws1.set_column('E:E', 18) # Lượng khách
            ws1.set_column('F:F', 16) # Chốt thành công
            ws1.set_column('G:G', 14) # Tỷ lệ
            ws1.set_column('H:H', 12) # Đã hủy
            ws1.set_column('I:I', 22) # Doanh thu

            # =========================================================================
            # SHEET 2: CHI TIẾT TOÀN BỘ ĐƠN TIỆC (BANQUET BOOKINGS DETAIL)
            # =========================================================================
            ws2 = workbook.add_worksheet('DanhSach_ChiTiet')
            ws2.set_paper(9) # A4
            ws2.set_landscape()
            ws2.hide_gridlines(0)

            ws2.merge_range('A1:H1', 'TRUNG TÂM HỘI NGHỊ TIỆC CƯỚI & KHÁCH SẠN MERPERLE', fmt_title)
            ws2.merge_range('I1:P1', f'Ngày xuất: {now_str}', fmt_meta_right)
            ws2.merge_range('A2:H2', 'Danh Sách Chi Tiết Đơn Đặt Tiệc (Banquet Bookings Master Ledger)', fmt_subtitle)
            ws2.merge_range('I2:P2', 'Tiêu chuẩn: BGĐ & Phòng Kinh Doanh Banquet', fmt_meta_right)
            ws2.merge_range('A4:P4', f'  Bộ lọc áp dụng: {filter_text}', fmt_filter_box)

            detail_headers = [
                'MÃ BOOKING', 'NGÀY TIỆC', 'NGÀY ĐẶT', 'TÊN TIỆC / SỰ KIỆN',
                'KHÁCH HÀNG', 'SĐT', 'SẢNH TIỆC', 'PHÂN KHÚC / LĨNH VỰC',
                'NGUỒN TIẾP THỊ', 'NGƯỜI LÀM BEO (HƯỞNG DT)', 'NGƯỜI LOCK SẢNH', 'TRẠNG THÁI',
                'SỐ KHÁCH (PAX)', 'TIỀN CỌC (VNĐ)', 'DT TIỆC - BANQUET', 'TỔNG DOANH THU'
            ]
            ws2.set_row(5, 24)
            for c_i, d_h in enumerate(detail_headers):
                ws2.write(5, c_i, d_h, fmt_th)

            r_d = 6
            sum_d_pax = 0
            sum_d_coc = 0
            sum_d_bq = 0
            sum_d_tot = 0

            for row in rows:
                is_z = (r_d % 2 == 1)
                t_l = fmt_td_left_z if is_z else fmt_td_left_w
                t_c = fmt_td_center_z if is_z else fmt_td_center_w
                t_n = fmt_td_num_z if is_z else fmt_td_num_w
                t_m = fmt_td_curr_z if is_z else fmt_td_curr_w

                b_id = row[0] or ''
                ev_d = row[1] or ''
                bk_d = row[2] or ''
                ev_title = row[3] or ''
                g_name = row[4] or ''
                g_phone = row[5] or ''
                h_name = row[6] or ''
                seg = row[7] or ''
                src = row[8] or ''
                sales = row[9] or ''
                lock_u = row[10] or ''
                st_name = row[11] or ''
                pax_val = int(row[12] or 0)
                coc_val = float(row[13] or 0)
                bq_val = float(row[14] or 0)
                tot_val = float(row[15] or 0)

                sum_d_pax += pax_val
                sum_d_coc += coc_val
                sum_d_bq += bq_val
                sum_d_tot += tot_val

                ws2.write(r_d, 0, b_id, t_c)
                ws2.write(r_d, 1, ev_d, t_c)
                ws2.write(r_d, 2, bk_d, t_c)
                ws2.write(r_d, 3, ev_title, t_l)
                ws2.write(r_d, 4, g_name, t_l)
                ws2.write(r_d, 5, g_phone, t_c)
                ws2.write(r_d, 6, h_name, t_l)
                ws2.write(r_d, 7, seg, t_l)
                ws2.write(r_d, 8, src, t_c)
                ws2.write(r_d, 9, sales, t_l)
                ws2.write(r_d, 10, lock_u, t_c)
                ws2.write(r_d, 11, st_name, t_c)
                ws2.write(r_d, 12, pax_val, t_n)
                ws2.write(r_d, 13, coc_val, t_m)
                ws2.write(r_d, 14, bq_val, t_m)
                ws2.write(r_d, 15, tot_val, t_m)
                ws2.set_row(r_d, 20)
                r_d += 1

            # Dòng TỔNG CỘNG cho Bảng Chi Tiết
            ws2.merge_range(r_d, 0, r_d, 11, f'TỔNG CỘNG ({len(rows)} ĐƠN TIỆC)', fmt_tot_label)
            ws2.write(r_d, 12, sum_d_pax, fmt_tot_num)
            ws2.write(r_d, 13, sum_d_coc, fmt_tot_curr)
            ws2.write(r_d, 14, sum_d_bq, fmt_tot_curr)
            ws2.write(r_d, 15, sum_d_tot, fmt_tot_curr)
            ws2.set_row(r_d, 22)

            # Độ rộng các cột Sheet 2
            ws2.set_column('A:A', 22) # Mã booking
            ws2.set_column('B:C', 14) # Ngày tiệc & Ngày đặt
            ws2.set_column('D:E', 32) # Tên tiệc & Khách hàng
            ws2.set_column('F:F', 15) # SĐT
            ws2.set_column('G:G', 18) # Sảnh
            ws2.set_column('H:H', 22) # Phân khúc
            ws2.set_column('I:I', 15) # Nguồn
            ws2.set_column('J:K', 20) # Sales & Lock
            ws2.set_column('L:L', 16) # Trạng thái
            ws2.set_column('M:M', 13) # Pax
            ws2.set_column('N:N', 18) # Cọc
            ws2.set_column('O:P', 20) # DT Tiệc & Tổng DT

        output.seek(0)
        filename = f"MerPerle_BaoCao_ThongKe_DatTiec_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"
        return StreamingResponse(
            output,
            media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            headers={"Content-Disposition": f"attachment; filename={filename}"}
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/booking-detail/{booking_id}")
def get_booking_detail_api(booking_id: str):
    """Returns comprehensive full booking detail including CRM, rooms schedule, itemized charges, and BEO department notes."""
    try:
        cn = get_db()
        cur = cn.cursor()

        # 1. Booking, CRM & Master EO
        cur.execute("""
            SELECT 
                b.fcBookID, b.fcTitle, b.fcStatus_BkRoom, b.fdDate,
                b.fdDateContract, b.fdDateConfirm,
                b.fnSoLuongDK, b.fnEXP, b.fnDatCoc,
                b.fcDepositNote, b.fcNote, b.fcUser,
                u.fcFullName as LockUserName,
                k.fcMa, k.fcTen, k.fcNguoiLienHe,
                k.fcTelephone, k.fcPhone_Office, k.fcEmail, k.fcDiaChi, k.fcMST,
                lv.fcName as SegmentName, kl.fcName as ChannelName,
                meo.fcMaster_EO, meo.fcNguoiLap,
                beo_u.fcFullName as BeoUserName,
                sk.fcPrepared_by, sk.fcEndorsed_by, sk.fcBookCode, sk.fcEndUser,
                meo.fcBill_To, meo.fcPTTT, sk.fnMenuPrice, sk.fcPrice, sk.fcMenuDetail,
                sk.fcBeverage, sk.fcBottom, sk.fcNoidung, sk.fcChargeNotes
            FROM stBooking b
            LEFT JOIN stUser u ON b.fcUser = u.fcUserName
            LEFT JOIN stKhachHang k ON b.fcGuestID = k.fcMa
            LEFT JOIN stLinhVuc lv ON k.fcLinhVuc = lv.fcCode
            LEFT JOIN stKhachHang_Loai kl ON k.fcLoaiKhach = kl.fcCode
            LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
            LEFT JOIN stUser beo_u ON meo.fcNguoiLap = beo_u.fcUserName
            LEFT JOIN stSKLK sk ON meo.fcMaster_EO = sk.fcMaster_EO
            WHERE b.fcBookID = ?
        """, [booking_id])
        row = cur.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Booking not found")

        # 2. Rooms schedule (Prioritize actual Cana BEO event time and pax from stRoom_Setup)
        cur.execute("""
            SELECT bfr.fcFunctionRoom, ISNULL(p.fcTen, bfr.fcFunctionRoom), bfr.fdDate, 
                   ISNULL(rs.fdTimeIn, bfr.fdTimeIn) as TimeIn, 
                   ISNULL(rs.fdTimeOut, bfr.fdTimeOut) as TimeOut, 
                   CASE WHEN ISNULL(rs.fnQuantity, 0) > 0 THEN rs.fnQuantity ELSE bfr.fnQuantity END as Quantity, 
                   ISNULL(sk.fcTen, bfr.fcFunctionType),
                   rs.fcNote as RoomSetupNote
            FROM stBookFunctionRoom bfr
            LEFT JOIN stBooking b ON bfr.fcBookID = b.fcBookID
            LEFT JOIN stMaster_EO meo ON b.fcBookID = meo.fcBookID
            LEFT JOIN stPhong p ON bfr.fcFunctionRoom = p.fcMa
            LEFT JOIN stSuKien sk ON bfr.fcFunctionType = sk.fcMa
            LEFT JOIN stRoom_Setup rs ON meo.fcMaster_EO = rs.fcMaster_EO AND bfr.fnCodeID = rs.fnCodeID
            WHERE bfr.fcBookID = ?
            ORDER BY bfr.fdDate, ISNULL(rs.fdTimeIn, bfr.fdTimeIn)
        """, [booking_id])
        rooms = []
        for r in cur.fetchall():
            time_in_str = r[3].strftime("%H:%M") if hasattr(r[3], "strftime") else (str(r[3])[:5] if r[3] else "")
            time_out_str = r[4].strftime("%H:%M") if hasattr(r[4], "strftime") else (str(r[4])[:5] if r[4] else "")
            date_str = r[2].strftime("%Y-%m-%d") if hasattr(r[2], "strftime") else str(r[2])[:10]
            rooms.append({
                "room_code": r[0].strip() if r[0] else "",
                "room_name": r[1].strip() if r[1] else r[0].strip(),
                "date": date_str,
                "time_in": time_in_str,
                "time_out": time_out_str,
                "pax": int(r[5] or 0),
                "function_type": r[6].strip() if r[6] else "",
                "setup_note": r[7].strip() if (len(r) > 7 and r[7]) else ""
            })

        # 3. Itemized charges: Prioritize stSKLK_DoanhThu (Cana BEO) if present, fallback to stBooking_Charges
        master_eo = row[23].strip() if row[23] else ""
        charges = []
        total_charges = 0.0
        banquet_charges = 0.0

        if master_eo:
            cur.execute("""
                SELECT d.fnID, d.fcDoanhThu_Type, dt.fcName, d.fnQuantity, d.fnPrice, d.fnAmount, d.fcNote
                FROM stSKLK_DoanhThu d
                LEFT JOIN stDoanhThu_Loai dt ON d.fcDoanhThu_Type = dt.fcCode
                WHERE d.fcMaster_EO = ?
                ORDER BY d.fnID
            """, [master_eo])
            for ch in cur.fetchall():
                amt = float(ch[5] or 0)
                total_charges += amt
                c_code = ch[1].strip() if ch[1] else ""
                if c_code != "56":
                    banquet_charges += amt
                charges.append({
                    "id": ch[0],
                    "charge_code": c_code,
                    "service_name": ch[2].strip() if ch[2] else (ch[6].strip() if ch[6] else f"Dịch vụ {c_code}"),
                    "quantity": float(ch[3] or 0),
                    "price": float(ch[4] or 0),
                    "amount": amt,
                    "note": ch[6].strip() if ch[6] else ""
                })

        if not charges:
            cur.execute("""
                SELECT c.fnID, c.fcDoanhThu_Loai, dt.fcName, c.fnQuantity, c.fnPrice, c.fnAmount, c.fcNote
                FROM stBooking_Charges c
                LEFT JOIN stDoanhThu_Loai dt ON c.fcDoanhThu_Loai = dt.fcCode
                WHERE c.fcBookID = ?
                ORDER BY c.fnID
            """, [booking_id])
            for ch in cur.fetchall():
                amt = float(ch[5] or 0)
                total_charges += amt
                c_code = ch[1].strip() if ch[1] else ""
                if c_code != "56":  # 56 is ROOM
                    banquet_charges += amt
                charges.append({
                    "id": ch[0],
                    "charge_code": c_code,
                    "service_name": ch[2].strip() if ch[2] else (ch[6].strip() if ch[6] else f"Dịch vụ {c_code}"),
                    "quantity": float(ch[3] or 0),
                    "price": float(ch[4] or 0),
                    "amount": amt,
                    "note": ch[6].strip() if ch[6] else ""
                })

        # 4. Department notes
        dept_notes = []
        if master_eo:
            cur.execute("""
                SELECT n.fcDept, ISNULL(d.fcName, n.fcDept), n.fcNote
                FROM stSKLK_Notes n
                LEFT JOIN stDepartment d ON n.fcDept = d.fcCode
                WHERE n.fcMaster_EO = ?
                ORDER BY n.fcDept
            """, [master_eo])
            for dn in cur.fetchall():
                dept_notes.append({
                    "dept_code": dn[0].strip() if dn[0] else "",
                    "dept_name": dn[1].strip() if dn[1] else dn[0].strip(),
                    "note": dn[2].strip() if dn[2] else ""
                })

        st_code = row[2].strip() if row[2] else "T"
        st_names = {"D": "Đã chốt (Definite)", "T": "Giữ chỗ (Tentative)", "C": "Đã hủy (Cancelled)"}

        return {
            "booking_id": booking_id,
            "title": row[1].strip() if row[1] else "",
            "status_code": st_code,
            "status_name": st_names.get(st_code, "Khác"),
            "event_date": row[3].strftime("%Y-%m-%d") if hasattr(row[3], "strftime") else (str(row[3])[:10] if row[3] else ""),
            "booking_date": row[4].strftime("%Y-%m-%d") if hasattr(row[4], "strftime") else (str(row[4])[:10] if row[4] else ""),
            "confirm_date": row[5].strftime("%Y-%m-%d") if hasattr(row[5], "strftime") else (str(row[5])[:10] if row[5] else ""),
            "pax": int(row[6] or 0),
            "exp_pax": int(row[7] or 0),
            "deposit": float(row[8] or 0),
            "deposit_note": row[9].strip() if row[9] else "",
            "internal_note": row[10].strip() if row[10] else "",
            "lock_user_code": row[11].strip() if row[11] else "",
            "lock_user_name": row[12].strip() if row[12] else (row[11].strip() if row[11] else ""),
            # Customer CRM
            "guest_code": row[13].strip() if row[13] else "",
            "customer_name": row[14].strip() if row[14] else (row[1].strip() if row[1] else "Khách vãng lai"),
            "contact_person": row[15].strip() if row[15] else "",
            "phone": row[16].strip() if row[16] else "",
            "phone_office": row[17].strip() if row[17] else "",
            "email": row[18].strip() if row[18] else "",
            "address": row[19].strip() if row[19] else "",
            "mst": row[20].strip() if row[20] else "",
            "segment": row[21].strip() if row[21] else "Chưa phân khúc",
            "channel": row[22].strip() if row[22] else "Trực tiếp",
            # BEO & Staff
            "master_eo": master_eo,
            "beo_user_code": row[24].strip() if row[24] else "",
            "beo_user_name": row[25].strip() if row[25] else "",
            "prepared_by": row[26].strip() if row[26] else "",
            "endorsed_by": row[27].strip() if row[27] else "",
            "bill_to": row[30].strip() if row[30] else "",
            "payment_method": row[31].strip() if row[31] else "",
            "menu_price": float(row[32] or 0),
            "price_str": row[33].strip() if row[33] else "",
            "menu_detail": row[34].strip() if row[34] else "",
            "beverage": row[35].strip() if row[35] else "",
            "room_setup": row[36].strip() if row[36] else "",
            "welcome_info": row[37].strip() if row[37] else "",
            "charge_notes": row[38].strip() if row[38] else "",
            # Financials
            "total_revenue": total_charges if total_charges > 0 else (float(row[32] or 0) * int(row[6] or 1)),
            "banquet_revenue": banquet_charges,
            "remaining_balance": (total_charges - float(row[8] or 0)) if total_charges > 0 else 0,
            # Sub-lists
            "rooms": rooms,
            "charges": charges,
            "department_notes": dept_notes
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/system/version")
def get_system_version():
    """Returns current build version for client anti-stale cache synchronization."""
    return {
        "app_version": "2026.11.20.02",
        "build_date": "2026-11-20T19:50:00+07:00",
        "service": "EMS_Banquet_Analytics"
    }

STATIC_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "static")

@app.get("/")
@app.get("/index.html")
async def get_index():
    index_path = os.path.join(STATIC_DIR, "index.html")
    response = FileResponse(index_path, media_type="text/html")
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
    response.headers["Surrogate-Control"] = "no-store"
    return response

app.mount("/", StaticFiles(directory=STATIC_DIR, html=True), name="static")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8088, reload=False, timeout_keep_alive=60, limit_concurrency=200)



