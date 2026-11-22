-- ============================================================================
-- EMS BANQUET SYSTEM - FULL DATABASE DDL SCHEMA
-- Trích xuất nguyên bản từ CSDL gốc EMS_KHAIVY (MerPerle / Khải Vy Hotel)
-- Bao gồm: 77 Bảng dữ liệu, 33 Functions, 20 Views, 90 Stored Procedures
-- ============================================================================

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stAccess')
BEGIN
CREATE TABLE [dbo].[stAccess] (
    [fcMenuCode] [nvarchar](20) NOT NULL,
    [fcGroupCode] [nvarchar](20) NOT NULL,
    [fcMenu] [bit] NOT NULL,
    [fcInsert] [bit] NOT NULL,
    [fcUpdate] [bit] NOT NULL,
    [fcDelete] [bit] NOT NULL,
    [fcExport] [bit] DEFAULT (1) NOT NULL,
    [fdUpdate] [smalldatetime] DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stAccess] PRIMARY KEY CLUSTERED ([fcMenuCode], [fcGroupCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stBaoGia')
BEGIN
CREATE TABLE [dbo].[stBaoGia] (
    [fcSoBG] [nvarchar](10) DEFAULT ('') NOT NULL,
    [fdNgayBG] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcTitleArrangement] [nvarchar](255) DEFAULT (N'(''') NOT NULL,
    [fcMaKH] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcContactPerson] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcGioiThieu] [ntext] DEFAULT ('') NOT NULL,
    [fcBanner] [ntext] DEFAULT ('') NOT NULL,
    [fcTentative] [ntext] DEFAULT ('') NOT NULL,
    [fcLCDRenTal] [ntext] DEFAULT ('') NOT NULL,
    [fcEndLetter] [ntext] DEFAULT ('') NOT NULL,
    [fdNgayLap] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcNguoiLap] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcEmail_NguoiLap] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fdUpdate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcBookID] [nvarchar](20) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stBaoGia] PRIMARY KEY CLUSTERED ([fcSoBG])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stBaoGia_Code')
BEGIN
CREATE TABLE [dbo].[stBaoGia_Code] (
    [fcCode] [nvarchar](50) NOT NULL,
    [fcDescription] [ntext] DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stBaoGia_Code] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stBaoGia_Sections')
BEGIN
CREATE TABLE [dbo].[stBaoGia_Sections] (
    [fcSoBG] [nvarchar](10) NOT NULL,
    [fcSectionCode] [nvarchar](10) NOT NULL,
    [fcTitle] [nvarchar](100) NOT NULL,
    [fcDate] [nvarchar](255) NOT NULL,
    [fcTime] [nvarchar](100) NOT NULL,
    [fcVenue] [ntext] NOT NULL,
    [fcAttendence] [ntext] NOT NULL,
    [fcMenu] [ntext] NOT NULL,
    [fcPrice] [ntext] NOT NULL,
    [fcSetup] [ntext] NOT NULL,
    [fcNote] [ntext] NOT NULL
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stBookFunctionRoom')
BEGIN
CREATE TABLE [dbo].[stBookFunctionRoom] (
    [fcBookID] [nvarchar](20) NOT NULL,
    [fnCodeID] [nvarchar](20) NOT NULL,
    [fcFunctionRoom] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcFunctionType] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fdDate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fdTimeIn] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fdTimeOut] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fnQuantity] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fnMenuPrice] [numeric](18, 2) DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_stBookFunctionRoom] PRIMARY KEY CLUSTERED ([fcBookID], [fnCodeID])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stBooking')
BEGIN
CREATE TABLE [dbo].[stBooking] (
    [fcBookID] [nvarchar](20) NOT NULL,
    [fdDate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcTitle] [nvarchar](200) DEFAULT ('') NOT NULL,
    [fcGuestID] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcNote] [nvarchar](4000) DEFAULT ('') NOT NULL,
    [fcUser] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcContactPerson] [nvarchar](200) DEFAULT ('') NOT NULL,
    [fcStatus_BkRoom] [nvarchar](1) DEFAULT ('P') NOT NULL,
    [fnSoLuongDK] [numeric](5, 0) DEFAULT ((0)) NOT NULL,
    [fdDateConfirm] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fnEXP] [numeric](18, 0) DEFAULT ((0)) NOT NULL,
    [fnLunch] [numeric](18, 0) DEFAULT ((12)) NOT NULL,
    [fcBreakDown] [ntext] DEFAULT ('') NOT NULL,
    [fnNo_Of_Rooms] [numeric](18, 0) DEFAULT ((0)) NOT NULL,
    [fnRoomRates] [numeric](18, 2) DEFAULT ((0)) NOT NULL,
    [fnTotalRoomNight] [numeric](18, 0) DEFAULT ((0)) NOT NULL,
    [fcCIn_COut_Date] [nvarchar](500) DEFAULT ('') NOT NULL,
    [fbMICE] [char](1) DEFAULT ((0)) NOT NULL,
    [fdDateContract] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcLoaiKH] [nvarchar](20) NOT NULL,
    [fnDatCoc] [numeric](18, 0) NULL,
    [fdDepositDate] [smalldatetime] NULL,
    [fcDepositNote] [nvarchar](255) NULL,
    [fcTienTe] [char](3) NULL,
    [fnTyGia] [numeric](18, 0) NULL,
    [fcCampaign] [nvarchar](20) DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_stBooking] PRIMARY KEY CLUSTERED ([fcBookID])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stBooking_Charges')
BEGIN
CREATE TABLE [dbo].[stBooking_Charges] (
    [fcBookID] [nvarchar](20) NOT NULL,
    [fnCodeID] [nvarchar](20) NOT NULL,
    [fcDoanhThu_Loai] [nvarchar](20) NOT NULL,
    [fnID] [int] IDENTITY(1,1) NOT NULL,
    [fnQuantity] [numeric](9, 2) DEFAULT (0) NOT NULL,
    [fnPrice] [numeric](18, 4) DEFAULT (0) NOT NULL,
    [fnVAT] [numeric](9, 4) DEFAULT (0) NOT NULL,
    [fnService] [numeric](5, 2) DEFAULT (0) NOT NULL,
    [fnAmount] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcNote] [nvarchar](1000) DEFAULT ('') NOT NULL,
    [fnBreakDownLunch] [bit] DEFAULT (0) NOT NULL,
    [fnLunchPrice] [numeric](18, 2) DEFAULT (0) NOT NULL,
    CONSTRAINT [PK_stBooking_Charges] PRIMARY KEY CLUSTERED ([fcBookID], [fnCodeID], [fcDoanhThu_Loai])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stBooking_MICE')
BEGIN
CREATE TABLE [dbo].[stBooking_MICE] (
    [fcBookID] [nvarchar](20) NOT NULL,
    [fcMiceID] [nvarchar](20) NOT NULL,
    [fcMiceID_] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcGroupName] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fdCheckIn] [datetime] DEFAULT ('') NOT NULL,
    [fdCheckOut] [datetime] DEFAULT ('') NOT NULL,
    [fnNo_Of_Room] [numeric](9, 2) DEFAULT (0) NOT NULL,
    [fnRoomRates] [numeric](9, 2) DEFAULT (0) NOT NULL,
    [fnTotalNite] [numeric](9, 2) DEFAULT (0) NOT NULL,
    [fnRevenue] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcNotes] [ntext] DEFAULT ('') NOT NULL,
    [fcRoomType] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcSaleType] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcSaleManager] [nvarchar](200) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stBooking_MICE] PRIMARY KEY CLUSTERED ([fcBookID], [fcMiceID])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stBooking_Status')
BEGIN
CREATE TABLE [dbo].[stBooking_Status] (
    [fcCode] [nvarchar](1) NOT NULL,
    [fcName] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fnOrder] [numeric](18, 0) DEFAULT (0) NOT NULL,
    CONSTRAINT [PK_stBooking_Status] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stBookingColor')
BEGIN
CREATE TABLE [dbo].[stBookingColor] (
    [fcCode] [nvarchar](20) NOT NULL,
    [fcBookStatus] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fnColor] [int] DEFAULT (0) NOT NULL,
    [fnColor1] [int] DEFAULT (0) NOT NULL,
    [tam] [int] DEFAULT (0) NOT NULL,
    CONSTRAINT [PK_stBookingColor] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stBudget')
BEGIN
CREATE TABLE [dbo].[stBudget] (
    [fcRoom] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcYear] [nvarchar](4) DEFAULT ('') NOT NULL,
    [fcJan] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcFeb] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcMar] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcApr] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcMay] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcJun] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcJul] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcAug] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcSep] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcOct] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcNov] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcDec] [numeric](18, 2) DEFAULT (0) NOT NULL,
    CONSTRAINT [PK_stBudget] PRIMARY KEY CLUSTERED ([fcRoom], [fcYear])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stCampaign')
BEGIN
CREATE TABLE [dbo].[stCampaign] (
    [fcCampaignCode] [nvarchar](20) NOT NULL,
    [fcCampaignName] [nvarchar](100) NOT NULL,
    [fcCampaignNote] [nvarchar](4000) NOT NULL,
    CONSTRAINT [PK_stCampaign] PRIMARY KEY CLUSTERED ([fcCampaignCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stChargeType')
BEGIN
CREATE TABLE [dbo].[stChargeType] (
    [fcChargeTypeCode] [nvarchar](20) NOT NULL,
    [fcChargeTypeName] [nvarchar](100) NOT NULL,
    [fcChargeTypeNote] [nvarchar](4000) NOT NULL,
    CONSTRAINT [PK_stChargeType] PRIMARY KEY CLUSTERED ([fcChargeTypeCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stConfig')
BEGIN
CREATE TABLE [dbo].[stConfig] (
    [fcCode] [nvarchar](30) NOT NULL,
    [fcName] [nvarchar](100) NOT NULL,
    [fcValue] [ntext] NOT NULL,
    CONSTRAINT [PK_stConfig] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stDepartment')
BEGIN
CREATE TABLE [dbo].[stDepartment] (
    [fcCode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcName] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fcManager] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcPosition] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fnShow] [int] DEFAULT (0) NOT NULL,
    CONSTRAINT [PK_stDepartment] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stDictionary')
BEGIN
CREATE TABLE [dbo].[stDictionary] (
    [fcCode] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fcDescription1] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcDescription2] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcDescription3] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fdUpdate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_stDictionary] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stDictionary_')
BEGIN
CREATE TABLE [dbo].[stDictionary_] (
    [fcCode] [nvarchar](50) NOT NULL,
    [fcDescription1] [nvarchar](255) NOT NULL,
    [fcDescription2] [nvarchar](255) NOT NULL,
    [fcDescription3] [nvarchar](255) NOT NULL,
    [fdUpdate] [smalldatetime] NOT NULL,
    CONSTRAINT [PK_stDictionary_] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stDoanhThu')
BEGIN
CREATE TABLE [dbo].[stDoanhThu] (
    [fcMa] [nvarchar](20) NOT NULL,
    [fcLoai] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcTen] [nvarchar](200) DEFAULT ('') NOT NULL,
    [fcDept] [nvarchar](10) DEFAULT ('') NOT NULL,
    [fcMenuType] [nvarchar](20) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stDoanhThu] PRIMARY KEY CLUSTERED ([fcMa], [fcLoai])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stDoanhThu_Loai')
BEGIN
CREATE TABLE [dbo].[stDoanhThu_Loai] (
    [fcCode] [nvarchar](20) NOT NULL,
    [fcName] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcNote] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcGroup] [nvarchar](10) DEFAULT ('') NOT NULL,
    [fnOrderBy] [nvarchar](10) DEFAULT (0) NOT NULL,
    CONSTRAINT [PK_stDoanhThu_Loai] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stDoanhThu_Loai_Group')
BEGIN
CREATE TABLE [dbo].[stDoanhThu_Loai_Group] (
    [fcCode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcName] [nvarchar](30) NOT NULL,
    CONSTRAINT [PK_stDoanhThu_Loai_Group] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stFunctionRoom')
BEGIN
CREATE TABLE [dbo].[stFunctionRoom] (
    [locationid] [nvarchar](255) NULL,
    [location] [nvarchar](255) NULL,
    [include] [nvarchar](255) NULL,
    [capacity] [float] NULL,
    [square] [float] NULL
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stGI')
BEGIN
CREATE TABLE [dbo].[stGI] (
    [fcCode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcTen] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fdNgay] [datetime] DEFAULT ('') NOT NULL,
    [fcMaKH] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcKhachLH] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fcLoaiKhach] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcQuocGia] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcSLPhong] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcSLKhach] [nvarchar](10) DEFAULT ('') NOT NULL,
    [fcCheckInVenue] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fcHanhLy] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fdNgayHanhLy] [datetime] DEFAULT ('') NOT NULL,
    [fcWelcomeDrink] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcVIPs] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fcDesignation] [nvarchar](10) DEFAULT ('') NOT NULL,
    [fcRoomType] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcArr_Dep] [nvarchar](30) DEFAULT ('') NOT NULL,
    [fcFLTNo_ETA] [nvarchar](30) DEFAULT ('') NOT NULL,
    [fcSalesCode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcPrepared] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fnDeposit] [numeric](18, 4) DEFAULT (0) NOT NULL,
    [fcCurrency] [nvarchar](10) DEFAULT ('') NOT NULL,
    [fcDepositNote] [nvarchar](200) DEFAULT ('') NOT NULL,
    [fdDepositDate] [datetime] DEFAULT ('') NOT NULL,
    [fnRates] [smallint] DEFAULT (0) NOT NULL,
    [fnRoomRevenue] [numeric](12, 2) DEFAULT (0) NOT NULL,
    [fnVAT] [numeric](8, 0) DEFAULT (0) NOT NULL,
    [fnService] [numeric](8, 0) DEFAULT (0) NOT NULL,
    [fcBookID] [nvarchar](20) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stGI] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stGI_Detail')
BEGIN
CREATE TABLE [dbo].[stGI_Detail] (
    [fcCode] [int] IDENTITY(1,1) NOT NULL,
    [fcGICode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcFLTNo] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fdArrival] [datetime] DEFAULT ('') NOT NULL,
    [fcTime] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcFLTNo1] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fdDeparture] [datetime] DEFAULT ('') NOT NULL,
    [fcTime1] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcRoomType] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fnQuantity] [tinyint] DEFAULT ('') NOT NULL,
    [fnRate] [numeric](18, 4) DEFAULT (0) NOT NULL,
    CONSTRAINT [PK_stGI_Detail] PRIMARY KEY CLUSTERED ([fcCode], [fcGICode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stGI_Note')
BEGIN
CREATE TABLE [dbo].[stGI_Note] (
    [fcGICode] [nvarchar](20) NOT NULL,
    [fcDept] [nvarchar](20) NOT NULL,
    [fcNote] [ntext] DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stGI_Note] PRIMARY KEY CLUSTERED ([fcGICode], [fcDept])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stGroup')
BEGIN
CREATE TABLE [dbo].[stGroup] (
    [fcGroupCode] [nvarchar](20) NOT NULL,
    [fcGroupName] [nvarchar](100) NOT NULL,
    [fdUpdate] [smalldatetime] NOT NULL,
    CONSTRAINT [PK_stGroup] PRIMARY KEY CLUSTERED ([fcGroupCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stHoSo_BanquetForecast')
BEGIN
CREATE TABLE [dbo].[stHoSo_BanquetForecast] (
    [fdSaveDate] [datetime] DEFAULT (getdate()) NOT NULL,
    [fdFromDate] [smalldatetime] DEFAULT ('') NOT NULL,
    [fdToDate] [smalldatetime] DEFAULT ('') NOT NULL,
    [fcBookID] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcGuestID] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcOrganization] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcContactPerson] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcFunctionType] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcL] [char](1) DEFAULT ('') NOT NULL,
    [fcFunctionRoom] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fdFunctionDate] [smalldatetime] DEFAULT ('') NOT NULL,
    [fnGUA] [numeric](18, 0) DEFAULT (0) NOT NULL,
    [fnEXP] [numeric](18, 0) DEFAULT (0) NOT NULL,
    [fcStatus] [char](1) DEFAULT ('') NOT NULL,
    [fnFood_Price] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fnFood_Rev] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fnBev_Price] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fnBev_Revenue] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fnMICS_Revenue] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fnDEF_BQ_Rev] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fnDEF_Rev] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fnTEN_BQ_Rev] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fnTEN_Rev] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fnTOTAL_CXLD] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fcSP] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fdDATE_RECEIVED] [smalldatetime] DEFAULT ('') NOT NULL,
    [fdLAST_DAY_CONTACT] [smalldatetime] DEFAULT ('') NOT NULL
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stImage')
BEGIN
CREATE TABLE [dbo].[stImage] (
    [fcCode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcDescription] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fmImage] [image] NULL,
    CONSTRAINT [PK_stImage] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stImage_Setup')
BEGIN
CREATE TABLE [dbo].[stImage_Setup] (
    [fcRoom] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcSetup] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcImageCode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcNote] [text] DEFAULT ('') NOT NULL,
    [fnCapacity] [int] DEFAULT (0) NOT NULL,
    [fImage] [image] DEFAULT ('') NULL,
    CONSTRAINT [PK_stImage_Setup] PRIMARY KEY CLUSTERED ([fcRoom], [fcSetup], [fcImageCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stKhachHang')
BEGIN
CREATE TABLE [dbo].[stKhachHang] (
    [fcMa] [nvarchar](20) DEFAULT (123) NOT NULL,
    [fcTen] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcLoaiKhach] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcLinhVuc] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcMaNLH] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcNguoiLienHe] [nvarchar](70) DEFAULT ('') NOT NULL,
    [fcTelephone] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcPhone_Office] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fcPhone_Home] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fcEmail] [nvarchar](60) DEFAULT ('') NOT NULL,
    [fcFax] [nvarchar](30) DEFAULT ('') NOT NULL,
    [fcTinh_TP] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcQuocGia] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcDiaChi] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcMST] [nvarchar](30) DEFAULT ('') NOT NULL,
    [fdNgayNhap] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcGhiChu] [nvarchar](200) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stKhachHang] PRIMARY KEY CLUSTERED ([fcMa])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stKhachHang_Loai')
BEGIN
CREATE TABLE [dbo].[stKhachHang_Loai] (
    [fcCode] [nvarchar](20) NOT NULL,
    [fcName] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcNote] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcGroup] [nvarchar](100) NOT NULL,
    CONSTRAINT [PK_stKhachHang_Loai] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stKhachHang_NguoiLH')
BEGIN
CREATE TABLE [dbo].[stKhachHang_NguoiLH] (
    [fcKhachHang_ID] [nvarchar](20) NOT NULL,
    [fcMaNLH] [nvarchar](20) NOT NULL,
    [fcTenNLH] [nvarchar](250) DEFAULT ('') NOT NULL,
    [fcTelephone] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcPhone_Office] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fcPhone_Home] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fcEmail] [nvarchar](60) DEFAULT ('') NOT NULL,
    [fcGhiChu] [nvarchar](200) DEFAULT ('') NOT NULL,
    [fdDate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_stKhachHang_NguoiLH] PRIMARY KEY CLUSTERED ([fcKhachHang_ID], [fcMaNLH])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stLinhVuc')
BEGIN
CREATE TABLE [dbo].[stLinhVuc] (
    [fcCode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcName] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcNote] [nvarchar](100) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stLinhVuc] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stMaster_EO')
BEGIN
CREATE TABLE [dbo].[stMaster_EO] (
    [fcMaster_EO] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fdDate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcBookID] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcGuestCode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcContactPerson] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcContractNo] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fdContractDate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcBill_To] [nvarchar](200) DEFAULT ('') NOT NULL,
    [fcPTTT] [nvarchar](200) DEFAULT ('') NOT NULL,
    [fnDatCoc] [numeric](18, 0) DEFAULT (0) NOT NULL,
    [fdDepositDate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcDepositNote] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcTienTe] [char](3) DEFAULT ('') NOT NULL,
    [fnTyGia] [numeric](18, 0) DEFAULT (1) NOT NULL,
    [fcNguoiLap] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fdLastUpdate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcPaymentNotes] [ntext] DEFAULT ('') NOT NULL,
    [fcEndUser] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcBookCode] [nvarchar](50) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stMaster_EO] PRIMARY KEY CLUSTERED ([fcMaster_EO])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stMenu')
BEGIN
CREATE TABLE [dbo].[stMenu] (
    [fcMenuCode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcMenuName] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcForm] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fcDescription] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcShortcut] [nvarchar](10) DEFAULT ('') NOT NULL,
    [fdNgay] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fnShowMenu] [int] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_stMenu] PRIMARY KEY CLUSTERED ([fcMenuCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stMonth')
BEGIN
CREATE TABLE [dbo].[stMonth] (
    [fnMonth] [int] NOT NULL,
    [fcMonthName] [nvarchar](50) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stMonth] PRIMARY KEY CLUSTERED ([fnMonth])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stPhong')
BEGIN
CREATE TABLE [dbo].[stPhong] (
    [fnID] [smallint] DEFAULT (0) NOT NULL,
    [fcMa] [nvarchar](20) NOT NULL,
    [fcTen] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcLoaiPhong] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcKhuVuc] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fnDienTich] [nvarchar](100) DEFAULT (0) NOT NULL,
    [fcGhiChu] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fnGia] [numeric](18, 2) DEFAULT (0) NOT NULL,
    [fnOrder] [numeric](18, 0) DEFAULT (0) NOT NULL,
    CONSTRAINT [PK_stPhong] PRIMARY KEY CLUSTERED ([fnID], [fcMa])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stPhong_Loai')
BEGIN
CREATE TABLE [dbo].[stPhong_Loai] (
    [fcMa] [nvarchar](20) NOT NULL,
    [fcTen] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fdUpdate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcNote] [nvarchar](100) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stPhong_Loai] PRIMARY KEY CLUSTERED ([fcMa])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stPhong_TrangThai')
BEGIN
CREATE TABLE [dbo].[stPhong_TrangThai] (
    [fcMa] [nchar](2) NOT NULL,
    [fcTen] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcGhiChu] [nvarchar](255) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stPhong_TrangThai] PRIMARY KEY CLUSTERED ([fcMa])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stPTThanhToan')
BEGIN
CREATE TABLE [dbo].[stPTThanhToan] (
    [fcMa] [nvarchar](20) NOT NULL,
    [fcTen] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fcGhiChu] [nvarchar](100) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stPTThanhToan] PRIMARY KEY CLUSTERED ([fcMa])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stQuocGia')
BEGIN
CREATE TABLE [dbo].[stQuocGia] (
    [fcCode] [nvarchar](3) NOT NULL,
    [fcName] [nvarchar](50) NOT NULL,
    [fdDate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_stQuocGia] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stReasonCancel')
BEGIN
CREATE TABLE [dbo].[stReasonCancel] (
    [fcCode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcName] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcNote] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fdUpdate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_stReasonCancel] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stReasonLoss')
BEGIN
CREATE TABLE [dbo].[stReasonLoss] (
    [fcCode] [nvarchar](20) NOT NULL,
    [fcName] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcNote] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fdUpdate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_stReasonLoss] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stReasonTentative')
BEGIN
CREATE TABLE [dbo].[stReasonTentative] (
    [fcCode] [nvarchar](20) NOT NULL,
    [fcName] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcNote] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fdUpdate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_stReasonTentative] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stRoom_Setup')
BEGIN
CREATE TABLE [dbo].[stRoom_Setup] (
    [fcMaster_EO] [nvarchar](20) NOT NULL,
    [fcOrderNo] [nvarchar](20) NOT NULL,
    [fnCodeID] [nvarchar](20) NOT NULL,
    [fcRoom] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcSetup] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcImageCode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fdTimeIn] [smalldatetime] DEFAULT ('') NOT NULL,
    [fdTimeOut] [smalldatetime] DEFAULT ('') NOT NULL,
    [fcNote] [ntext] DEFAULT ('') NOT NULL,
    [fnQuantity] [numeric](18, 0) DEFAULT (0) NOT NULL,
    CONSTRAINT [PK_stRoom_Setup] PRIMARY KEY CLUSTERED ([fcMaster_EO], [fcOrderNo], [fnCodeID])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stRoomNight')
BEGIN
CREATE TABLE [dbo].[stRoomNight] (
    [fcMa] [nvarchar](20) NOT NULL,
    [fcTen] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcKhuVuc] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcDienThoai] [nvarchar](12) DEFAULT ('') NOT NULL,
    [fdNgayNhap] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcGhiChu] [nvarchar](100) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stRoomNight] PRIMARY KEY CLUSTERED ([fcMa])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stRoomType')
BEGIN
CREATE TABLE [dbo].[stRoomType] (
    [fcCode] [nvarchar](20) NOT NULL,
    [fcName] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcNote] [nvarchar](100) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stRoomType] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSaleType')
BEGIN
CREATE TABLE [dbo].[stSaleType] (
    [fcCode] [nvarchar](20) NOT NULL,
    [fcName] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcNote] [nvarchar](100) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stSaleType] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSection_Note')
BEGIN
CREATE TABLE [dbo].[stSection_Note] (
    [fcCode] [nvarchar](20) NOT NULL,
    [fcName] [text] DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stSection_Note] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSetMenu')
BEGIN
CREATE TABLE [dbo].[stSetMenu] (
    [fcCode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcMenuName] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcMenuDetail] [ntext] DEFAULT ('') NOT NULL,
    [fcMenuType] [nvarchar](20) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stSetMenu] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSetMenu_Type')
BEGIN
CREATE TABLE [dbo].[stSetMenu_Type] (
    [fcCode] [nvarchar](20) NOT NULL,
    [fcName] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcNote] [nvarchar](255) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stSetMenu_Type] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSetupType')
BEGIN
CREATE TABLE [dbo].[stSetupType] (
    [fcCode] [nvarchar](20) NOT NULL,
    [fcName] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcNote] [nvarchar](255) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stSetupType] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSK_TrangThai')
BEGIN
CREATE TABLE [dbo].[stSK_TrangThai] (
    [fcMa] [char](1) NOT NULL,
    [fcTen] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcNgay] [smalldatetime] DEFAULT ('') NOT NULL,
    [fcOrder] [char](2) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stSK_TrangThai] PRIMARY KEY CLUSTERED ([fcMa])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSKLK')
BEGIN
CREATE TABLE [dbo].[stSKLK] (
    [fcMaster_EO] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcOrderNo] [nvarchar](20) NOT NULL,
    [fdOrderDate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcEO_ID] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcTitle_EO_ID] [nvarchar](200) DEFAULT ('') NOT NULL,
    [fcPrepared_by] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcEndorsed_by] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fnBEO_Color] [numeric](18, 0) DEFAULT ((0)) NOT NULL,
    [fcMaSK] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fdEventDate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcTrangThai] [char](1) DEFAULT ('P') NOT NULL,
    [fcLyDo] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fdNgayXacNhan] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fdValidityDate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fnStatusEvent_Color] [numeric](18, 0) DEFAULT ((0)) NOT NULL,
    [fcNoidung] [ntext] DEFAULT ('') NOT NULL,
    [fnShow] [bit] DEFAULT ((0)) NOT NULL,
    [fcGUA] [nvarchar](150) DEFAULT ((1)) NOT NULL,
    [fcEXP] [nvarchar](150) DEFAULT ((0)) NOT NULL,
    [fcNguoiNhap] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fdLastUpdated] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcBottom] [ntext] DEFAULT ('') NOT NULL,
    [fnLunch] [numeric](18, 0) DEFAULT ((12)) NOT NULL,
    [fcBreakDown] [nvarchar](4000) DEFAULT ('') NOT NULL,
    [fcPrice] [nvarchar](4000) DEFAULT ('') NOT NULL,
    [fcBeverage] [nvarchar](4000) DEFAULT ('') NOT NULL,
    [fcMenuDetail] [ntext] DEFAULT ('') NOT NULL,
    [fcMenuCode] [nvarchar](200) DEFAULT ('') NOT NULL,
    [fcFileNo] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcChargeNotes] [nvarchar](4000) DEFAULT ('') NOT NULL,
    [fcChargeType] [nvarchar](20) NOT NULL,
    [fnMenuPrice] [numeric](18, 2) DEFAULT ((0)) NOT NULL,
    [fcEndUser] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcBookCode] [nvarchar](50) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stSKLK] PRIMARY KEY CLUSTERED ([fcMaster_EO], [fcOrderNo])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSKLK_Color')
BEGIN
CREATE TABLE [dbo].[stSKLK_Color] (
    [fcCode] [nvarchar](3) DEFAULT (0) NOT NULL,
    [fcName] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fnColor] [int] DEFAULT ((-1)) NOT NULL,
    CONSTRAINT [PK_stSKLK_Color] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSKLK_DoanhThu')
BEGIN
CREATE TABLE [dbo].[stSKLK_DoanhThu] (
    [fcMaster_EO] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcOrderNo] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fnCodeID] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcDoanhThu_Type] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fnID] [int] IDENTITY(1,1) NOT NULL,
    [fnQuantity] [numeric](18, 0) DEFAULT ((0)) NOT NULL,
    [fnPrice] [numeric](18, 2) DEFAULT ((0)) NOT NULL,
    [fnVAT] [int] DEFAULT ((10)) NOT NULL,
    [fnServiceCharge] [int] DEFAULT ((6)) NOT NULL,
    [fnAmount] [numeric](18, 2) DEFAULT ((0)) NOT NULL,
    [fnCharged] [bit] DEFAULT ((1)) NOT NULL,
    [fcNote] [ntext] DEFAULT ('') NOT NULL,
    [fcUser] [nvarchar](10) DEFAULT ('') NOT NULL,
    [fnBreakDownLunch] [bit] DEFAULT ((0)) NOT NULL,
    [fnLunchPrice] [numeric](18, 0) DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_stSKLK_DoanhThu] PRIMARY KEY CLUSTERED ([fcMaster_EO], [fcOrderNo], [fnCodeID], [fcDoanhThu_Type])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSKLK_Notes')
BEGIN
CREATE TABLE [dbo].[stSKLK_Notes] (
    [fcMaster_EO] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcOrderNo] [nvarchar](20) NOT NULL,
    [fcDept] [nvarchar](20) NOT NULL,
    [fcNote] [nvarchar](4000) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stSKLK_Notes] PRIMARY KEY CLUSTERED ([fcMaster_EO], [fcOrderNo], [fcDept])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSuKien')
BEGIN
CREATE TABLE [dbo].[stSuKien] (
    [fcMa] [nvarchar](20) NOT NULL,
    [fcTen] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcGhiChu] [nvarchar](100) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stSuKien] PRIMARY KEY CLUSTERED ([fcMa])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSuKien_Department')
BEGIN
CREATE TABLE [dbo].[stSuKien_Department] (
    [fcEvent] [nvarchar](20) NOT NULL,
    [fcDepartment] [nvarchar](20) NOT NULL,
    [fcNote] [nvarchar](1000) NOT NULL,
    CONSTRAINT [PK_stSuKien_Department] PRIMARY KEY CLUSTERED ([fcEvent], [fcDepartment])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSystem_Company')
BEGIN
CREATE TABLE [dbo].[stSystem_Company] (
    [fnAutoID] [int] NOT NULL,
    [fcvariable] [char](20) NOT NULL,
    [fctype] [char](1) NOT NULL,
    [fnvalue] [image] NOT NULL,
    [fnvalue2] [varbinary](500) NULL
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSystem_DayMonth')
BEGIN
CREATE TABLE [dbo].[stSystem_DayMonth] (
    [fcmonth] [char](6) NOT NULL,
    [fdfirstofmonth] [smalldatetime] NOT NULL,
    [fdlastofmonth] [smalldatetime] NOT NULL
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSystem_Dictionary')
BEGIN
CREATE TABLE [dbo].[stSystem_Dictionary] (
    [fcCode] [nvarchar](50) NOT NULL,
    [fcDescription1] [nvarchar](100) NOT NULL,
    [fcDescription2] [nvarchar](100) NOT NULL,
    [fcDescription3] [nvarchar](100) NOT NULL,
    [fcKey] [char](1) NOT NULL
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSystem_GroupUser')
BEGIN
CREATE TABLE [dbo].[stSystem_GroupUser] (
    [fcCode] [char](10) NOT NULL,
    [fcName] [nvarchar](50) NULL
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSystem_Menu')
BEGIN
CREATE TABLE [dbo].[stSystem_Menu] (
    [fcCode] [char](10) NOT NULL,
    [fcPages_vn] [nvarchar](50) NOT NULL,
    [fcDescript_vn] [nvarchar](50) NOT NULL,
    [fcPages_e] [nvarchar](50) NOT NULL,
    [fcDescript_e] [nvarchar](50) NOT NULL,
    [fcRead] [nvarchar](500) NOT NULL,
    [fcEdit] [nvarchar](500) NOT NULL,
    [fcDelete] [nvarchar](500) NOT NULL,
    [fcAdd] [nvarchar](500) NOT NULL
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSystem_Tam')
BEGIN
CREATE TABLE [dbo].[stSystem_Tam] (
    [fcCode] [char](10) NOT NULL,
    [fcPages_vn] [nvarchar](50) NOT NULL,
    [fcDescript_vn] [nvarchar](50) NOT NULL,
    [fcPages_e] [nvarchar](50) NOT NULL,
    [fcDescript_e] [nvarchar](50) NOT NULL,
    [fcRead] [nvarchar](500) NOT NULL,
    [fcEdit] [nvarchar](500) NOT NULL,
    [fcDelete] [nvarchar](500) NOT NULL,
    [fcAdd] [nvarchar](500) NOT NULL
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSystem_Tigia')
BEGIN
CREATE TABLE [dbo].[stSystem_Tigia] (
    [fnAutoID] [int] NOT NULL,
    [fcMonth] [char](6) NOT NULL,
    [fnSARate] [numeric](10, 0) NOT NULL,
    [fnSIRate] [numeric](18, 0) NOT NULL
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSystem_TSDayMonth')
BEGIN
CREATE TABLE [dbo].[stSystem_TSDayMonth] (
    [fcMonth] [char](6) NOT NULL,
    [fdFirstOfMonth] [smalldatetime] NOT NULL,
    [fdLastOfMonth] [smalldatetime] NOT NULL
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stSystem_User')
BEGIN
CREATE TABLE [dbo].[stSystem_User] (
    [fcCode] [char](10) NOT NULL,
    [fcGroup] [char](10) NOT NULL,
    [fcLoginName] [nvarchar](50) NOT NULL,
    [fcFullName] [nvarchar](50) NOT NULL,
    [fcPassword] [varbinary](100) NOT NULL,
    [fcDepartment] [nvarchar](150) NOT NULL,
    [fcSection] [nvarchar](150) NULL
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stTienTe')
BEGIN
CREATE TABLE [dbo].[stTienTe] (
    [fcMa] [nvarchar](3) NOT NULL,
    [fcTen] [nvarchar](50) DEFAULT ('') NOT NULL,
    [fcGhiChu] [nvarchar](100) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stTienTe] PRIMARY KEY CLUSTERED ([fcMa])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stTinh_TP')
BEGIN
CREATE TABLE [dbo].[stTinh_TP] (
    [fcCode] [nvarchar](20) NOT NULL,
    [fcDescription1] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcDescription2] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcNote] [nvarchar](255) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stTinh_TP] PRIMARY KEY CLUSTERED ([fcCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stTrackRoom')
BEGIN
CREATE TABLE [dbo].[stTrackRoom] (
    [fcID] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcRoom] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fdNgayBatDau] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fdNgayketThuc] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcShowTitle] [nvarchar](100) DEFAULT ('Reserving Room') NOT NULL,
    [fnColor] [numeric](18, 0) DEFAULT (8) NOT NULL,
    [fcUser] [nvarchar](20) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stTrackRoom] PRIMARY KEY CLUSTERED ([fcID])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stTyGia')
BEGIN
CREATE TABLE [dbo].[stTyGia] (
    [fdNgay] [smalldatetime] NOT NULL,
    [fcTienTe] [char](3) DEFAULT ('VND') NOT NULL,
    [fnGia] [numeric](18, 0) DEFAULT (0) NOT NULL,
    [fcNguoiNhap] [nvarchar](20) DEFAULT (getdate()) NOT NULL,
    [fcGhiChu] [nvarchar](100) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stTyGia] PRIMARY KEY CLUSTERED ([fdNgay], [fcTienTe])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stUser')
BEGIN
CREATE TABLE [dbo].[stUser] (
    [fcUserName] [nvarchar](20) NOT NULL,
    [fcFullName] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcDept] [nvarchar](10) DEFAULT ('') NOT NULL,
    [fcAddress] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcPhone] [nvarchar](10) DEFAULT ('') NOT NULL,
    [fcPosition] [nvarchar](255) DEFAULT ('') NOT NULL,
    [fcEmail] [nvarchar](200) DEFAULT ('') NOT NULL,
    [fcMobile] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fdUpdate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    [fcPassword] [varbinary](100) DEFAULT (pwdencrypt('')) NOT NULL,
    CONSTRAINT [PK_stUser] PRIMARY KEY CLUSTERED ([fcUserName])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stUserGroup')
BEGIN
CREATE TABLE [dbo].[stUserGroup] (
    [fcUserName] [nvarchar](20) NOT NULL,
    [fcGroupCode] [nvarchar](20) NOT NULL,
    [fdUpdate] [smalldatetime] DEFAULT ('') NOT NULL,
    [fcOwner] [nvarchar](20) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stUserGroup] PRIMARY KEY CLUSTERED ([fcUserName], [fcGroupCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stUserMenu')
BEGIN
CREATE TABLE [dbo].[stUserMenu] (
    [fcUserName] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcMenuCode] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fdUpdate] [smalldatetime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_stUserMenu] PRIMARY KEY CLUSTERED ([fcUserName], [fcMenuCode])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stValidBooking')
BEGIN
CREATE TABLE [dbo].[stValidBooking] (
    [fcID] [nvarchar](20) DEFAULT ('') NOT NULL,
    [fcValues] [nvarchar](10) DEFAULT (1) NOT NULL,
    [fcDescription1] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcDescription2] [nvarchar](100) DEFAULT ('') NOT NULL,
    [fcDescription3] [nvarchar](100) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_stValidBooking] PRIMARY KEY CLUSTERED ([fcID])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'tmp')
BEGIN
CREATE TABLE [dbo].[tmp] (
    [fnAutoID] [int] IDENTITY(1,1) NOT NULL,
    [a] [nvarchar](50) DEFAULT (' ') NOT NULL,
    [b] [nvarchar](50) DEFAULT (' ') NOT NULL,
    [c] [nvarchar](50) DEFAULT (' ') NOT NULL,
    [d] [nvarchar](50) DEFAULT (' ') NOT NULL,
    [e] [nvarchar](50) DEFAULT (' ') NOT NULL,
    [f] [nvarchar](50) DEFAULT (' ') NOT NULL,
    [g] [nvarchar](50) DEFAULT (' ') NOT NULL,
    [h] [nvarchar](50) DEFAULT (' ') NOT NULL,
    [k] [nvarchar](50) DEFAULT (' ') NOT NULL,
    [l] [nvarchar](50) DEFAULT (' ') NOT NULL,
    [m] [nvarchar](50) DEFAULT (' ') NOT NULL,
    [n] [nvarchar](50) DEFAULT (' ') NOT NULL,
    [o] [nvarchar](50) DEFAULT (' ') NOT NULL,
    CONSTRAINT [PK_tmp] PRIMARY KEY CLUSTERED ([fnAutoID])
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'tudiencode')
BEGIN
CREATE TABLE [dbo].[tudiencode] (
    [manv_ct] [char](10) NULL,
    [manv_linh] [char](10) NULL
);
END
GO

IF OBJECT_ID('[dbo].[fDefind]') IS NOT NULL DROP FUNCTION [dbo].[fDefind]
GO
CREATE FUNCTION [dbo].[fDefind]
(
@frs nvarchar(100)
)

RETURNS nvarchar(200) AS  
BEGIN 

declare @Ten nvarchar(20), @result nvarchar(200), @final nvarchar(200)
set @result = substring(@frs, 0, len(@frs))

select @final = @result
	if rtrim(@result) = ''
		select @final = ''
	else
		select @final = (select fcTen from stPhong where fcMa = rtrim(@result))


--	if rtrim(@result) = '01'
--		select @final = 'Romance'
--	if rtrim(@result) = '02'
--		select @final = 'Classic'
--	if rtrim(@result) = '03'
--		select @final = 'Gothic'
--	if rtrim(@result) = '04'
--		select @final = 'Diamond'
--	if rtrim(@result) = '05'
--		select @final = 'Sapphire'
--	if rtrim(@result) = '06'
--		select @final = 'Sapphire 1'
--	if rtrim(@result) = '07'
--		select @final = 'Sapphire 2'
--	if rtrim(@result) = '08'
--		select @final = 'Sapphire 3'
--	if rtrim(@result) = '09'
--		select @final = 'Sapphire 4'
--	if rtrim(@result) = '10'
--		select @final = 'RUSTIC'
--	if rtrim(@result) = '11'
--		select @final = 'Poolside'
--	if rtrim(@result) = '12'
--		select @final = 'Riverside Café Rest'
--	if rtrim(@result) = '13'
--		select @final = 'Room 514'
--	if rtrim(@result) = '14'
--		select @final = 'Renaissance HTL'
--	if rtrim(@result) = '15'
--		select @final = 'Training Room'
--	if rtrim(@result) = '16'
--		select @final = 'All locations'
--	if rtrim(@result) = '17'
--		select @final = 'Atrium'
--	if rtrim(@result) = '18'
--		select @final = 'Mimosa III'
--	if rtrim(@result) ='19'
--		select @final ='Mimosa I'
--	if rtrim(@result) = '20'
--		select @final = 'Company Office' 
--	if rtrim(@result) = '21'
--		select @final = 'Cruise'
--	if rtrim(@result) = '22'
--		select @final = 'EO Room'
--	if rtrim(@result) = '23'
--		select @final = 'Guest room'
--	if rtrim(@result) = '24'
--		select @final = 'Mimosa II'
--	if rtrim(@result) = ''
--		select @final = ''
--	if rtrim(@result) = 'M4'
--		select @final = 'Me Linh 4'
--	if rtrim(@result) = 'M5'
--		select @final = 'Me Linh 5'

----MeLinh
--	if rtrim(@result) = '01, 02'
--		select @final = 'Me Linh 1+2'
--	if rtrim(@result) = '02, 03'
--		select @final = 'Me Linh 2+3'
--	if rtrim(@result) = '01, 02, 03'
--		select @final = 'Me Linh 1+2+3'
--	if rtrim(@result) = '01, 03'
--		select @final = 'Me Linh 1+3'
--	if rtrim(@result) = 'M4, M5'
--		select @final = 'Me Linh 4+5'

----KaBin
--	if rtrim(@result) = '04, 06'
--		select @final = 'Kabin 1+3'
--	if rtrim(@result) = '04, 05'
--		select @final = 'Kabin 1+2'
--	if rtrim(@result) = '04, 05, 06'
--		select @final = 'Kabin 1+2+3'
--	if rtrim(@result) = '05, 06'
--		select @final = 'Kabin 2+3'
----Mimosa
--	if rtrim(@result) = '18, 19'
--		select @final = 'Mimosa I+III'
--	if rtrim(@result) = '19, 24'
--		select @final = 'Mimosa I+II'
--	if rtrim(@result) = '18, 19, 24'
--		select @final = 'Mimosa I+II+III'
--	if rtrim(@result) = '18, 24'
--		select @final = 'Mimosa II+III'

----Function Room 
--	if rtrim(@result) = '19, 20'
--		select @final = ''
----Vietnam Room 
--	if rtrim(@result) = '12, 13, 14'
--		select @final = ''
--	if rtrim(@result) = '12, 13'
--		select @final = ''
--	if rtrim(@result) = '12, 14'
--		select @final = ''
--	if rtrim(@result) = '13, 14'
--		select @final = ''
---- Grand Indochine
--	if rtrim(@result) = '11, 12, 13, 14'
--		select @final = ''
---- Grand Indochine
--	if rtrim(@result) = '11, 12, 13, 14, 15'
--		select @final = ''
---- VietNam1_Indochine
--	if rtrim(@result) = '11, 12'
--		select @final = ''
---- VietNam2_Indochine
--	if rtrim(@result) = '11, 13'
--		select @final = ''
---- VietNam3_Indochine
--	if rtrim(@result) = '11, 14'
--		select @final = ''
---- VietNam1,2_Indochine
--	if rtrim(@result) = '11, 12, 13'
--		select @final = ''
---- VietNam2,3_Indochine
--	if rtrim(@result) = '11, 13, 14'
--		select @final = ''
---- VietNam1,3_Indochine
--	if rtrim(@result) = '11, 12, 14'
--		select @final = ''

----Cambodia 
--	if rtrim(@result) = '16, 17'
--		select @final = ''

--	if rtrim(@result) = ''
--		select @final = ''

return @final 
END
GO

IF OBJECT_ID('[dbo].[fRooms]') IS NOT NULL DROP FUNCTION [dbo].[fRooms]
GO
CREATE FUNCTION dbo.fRooms
(
@BookID nvarchar(20), 
@d smalldatetime
)

RETURNS nvarchar(20) AS  
BEGIN 

declare @fun nvarchar(20), @result nvarchar(20)
set @result = ''
DECLARE rooms_cursor CURSOR FOR
select fcfunctionroom from stBookFunctionRoom where fcbookid = @BookID and fddate = @d
OPEN rooms_cursor
FETCH NEXT FROM rooms_cursor INTO @fun
WHILE @@FETCH_STATUS = 0
BEGIN
	set @result = @result + ' ' + @fun 
	FETCH NEXT FROM rooms_cursor    INTO @fun
END
CLOSE rooms_cursor
DEALLOCATE rooms_cursor
return replace(ltrim(@result), ' ', ', ')
END
GO

IF OBJECT_ID('[dbo].[fValid_TimeBooking]') IS NOT NULL DROP FUNCTION [dbo].[fValid_TimeBooking]
GO
-- updated on 29/05/2007

CREATE FUNCTION dbo.fValid_TimeBooking
(
	@pcFunctionRoom nvarchar(20) = '',  
	@pdTimeIn smalldatetime  ='', 
	@pdTimeOut smalldatetime ='',
	@pcNumHour  float = 1  ,
	@Call char(1) = '0',
	@pcCodeID nvarchar(20) , 
	@pcTrackRoomID nvarchar(20) 
)  
RETURNS int 
AS  	
BEGIN 
--	set @pdTimeIn = dateadd(hour,-@pcNumHour, @pdTimeIn )
--	set @pdTimeOut = dateadd(hour, @pcNumHour, @pdTimeOut )

	declare @Minute as int
	set   @Minute = cast((@pcNumHour - cast(@pcNumHour as int)) * 60 as int)
	select @pdTimeIn = dateadd(mi, - @Minute, dateadd(hour, - cast(@pcNumHour as int), @pdTimeIn))
	select @pdTimeOut = dateadd(mi,   @Minute, dateadd(hour,  cast(@pcNumHour as int), @pdTimeOut))

	declare @countRecord int 
	set @countRecord = 0


--*********** NOTE *********************
--1. fdTimeIn, fdTimeOut, fcFunctionRoom: la du lieu da duoc book san trong Database, da hien thi cac phong duoc book tren ReservationBook
--2. @pdTimeIn, @pdTimeOut  la thoi gian IN/OUT se duoc book o phong @pcFunctionRoom (neu ko bi duplicate )
--3. Kiem tra cac truong hop khong duoc Book Room
	-- CASE 1: @pdTimeIn < fdTimeIn <@pdTimeOut: KO DAT DUOC BOOKING
	-- CASE 2: @pdTimeIn < fdTimeOUT <@pdTimeOut: KO DAT DUOC BOOKING
	-- CASE 3: fdTimeIn<= @pdTimeIn < @pdTimeOut <= fdTimeOut : KO DAT DUOC BOOKING

if @Call = '0'  -- KIEM TRA TRUNG TRONG BOOKING
begin 
	set @countRecord = (SELECT count(*) from  stBooking  b LEFT join stBookFunctionRoom bf on b.fcbookid = bf.fcbookid
			       where (bf.fcFunctionRoom = @pcFunctionRoom) 
			       --AND bf.fcFunctionRoom not in ('08','07') 
			       --AND (b.fcStatus_bkRoom  <> 'C') 
			       AND (b.fcStatus_bkRoom  = 'D') 
			       AND (b.fcBookID not in (select fcBookID from stMaster_EO))  AND (bf.fnCodeID not in (select fcID from stTrackRoom))
		                    AND ( bf.fnCodeID <> rtrim(ltrim(@pcCodeID)))
	                  	       AND ((@pdTimeIn  < bf.fdTimeIn  and @pdTimeOut  > bf.fdTimeIn)         -- CASE 1
				or (@pdTimeIn  < bf.fdTimeOut  and @pdTimeOut  > bf.fdTimeOut)   -- CASE 2 
				or (@pdTimeIn  >= fdTimeIn  and @pdTimeOut  <= fdTimeOut)))        -- CASE 3  
				
	return @countRecord --  @countRecord  = 0:  DUOC PHEP DAT SU KIEN TAI @pcFunctionRoom, VAO THOI GIAN  @pdTimeIn, @pdTimeoUT
-- KHONG  DUOC PHEP DAT SU KIEN TAI @pcFunctionRoom, VAO THOI GIAN  @pdTimeIn, @pdTimeoUT

end 
if @Call = '1'   -- KIEM TRA TRUNG TRONG BEO

begin 
	set @countRecord = (SELECT count(*) from stSKLK sklk LEFT join stRoom_Setup rs  on rs.fcOrderNo = sklk.fcOrderNo
			       where rs.fcRoom = @pcFunctionRoom 
			       AND rs.fcRoom not in ('08','07') 
			       AND sklk.fcTrangThai  not in('C','R')
		                    AND ( rs.fnCodeID <> @pcCodeID ) AND (rs.fnCodeID not in (select fcID from stTrackRoom))
	                  	       AND ((@pdTimeIn  < rs.fdTimeIn  and @pdTimeOut  > rs.fdTimeIn) 	-- CASE 1
			       or (@pdTimeIn  < rs.fdTimeOut  and @pdTimeOut  > rs.fdTimeOut)	-- CASE 2
			       or (@pdTimeIn  >= fdTimeIn  and @pdTimeOut  <= fdTimeOut)))	-- CASE 3
	return @countRecord  -- --  DUOC PHEP DAT SU KIEN TAI @pcFunctionRoom, VAO THOI GIAN  @pdTimeIn, @pdTimeoUT

end 

if @Call = '2'  --- -- KIEM TRA TRUNG TRONG  stTRACK_ROOM
	set @countRecord = (SELECT count(*) from stTrackRoom  
			       where (fcRoom = @pcFunctionRoom)  and fcRoom not in ('08','07') and (fcID <> @pcTrackRoomID)
	                  	       AND ((@pdTimeIn  < fdNgayBatDau  and @pdTimeOut  > fdNgayBatDau) 	-- CASE 1
			       or (@pdTimeIn  < fdNgayketThuc  and @pdTimeOut  > fdNgayketThuc)	-- CASE 2
			       or (@pdTimeIn  >= fdNgayBatDau  and @pdTimeOut  <= fdNgayketThuc)))	-- CASE 3
	return @countRecord  
return 0
END
GO

IF OBJECT_ID('[dbo].[fValid_TimeBooking_tuyen]') IS NOT NULL DROP FUNCTION [dbo].[fValid_TimeBooking_tuyen]
GO
CREATE FUNCTION dbo.fValid_TimeBooking_tuyen
(
	@pcFunctionRoom nvarchar(20) = '',  
	@pdTimeIn smalldatetime  ='', 
	@pdTimeOut smalldatetime ='',
	@pcNumHour  float = 1  ,
	@Call char(1) = '0',
	@pcCodeID nvarchar(20) 
)  
RETURNS int 
AS  	
BEGIN 
--	set @pdTimeIn = dateadd(hour,-@pcNumHour, @pdTimeIn )
--	set @pdTimeOut = dateadd(hour, @pcNumHour, @pdTimeOut )

	declare @Minute as int
	set   @Minute = cast((@pcNumHour - cast(@pcNumHour as int)) * 60 as int)
	select @pdTimeIn = dateadd(mi, - @Minute, dateadd(hour, - cast(@pcNumHour as int), @pdTimeIn))
	select @pdTimeOut = dateadd(mi,   @Minute, dateadd(hour,  cast(@pcNumHour as int), @pdTimeOut))

	declare @countRecord int 
	set @countRecord = 0
if @Call = '0'  -- KIEM TRA TRUNG TRONG BOOKING
begin 
	set @countRecord = (SELECT count(*) from stBookFunctionRoom bf inner join stBooking b on bf.fcbookid = b.fcbookid
			       where (bf.fcFunctionRoom = rtrim(ltrim(@pcFunctionRoom))) and bf.fcFunctionRoom not in ('08','07') and (b.fcStatus_bkRoom not in ('C','c') )and (b.fcBookID not in (select fcBookID from stMaster_EO))
		                    AND ( bf.fnCodeID <> rtrim(ltrim(@pcCodeID)))
	                  	       AND ((@pdTimeIn  < bf.fdTimeIn  and @pdTimeOut  > bf.fdTimeIn) 
				or (@pdTimeIn  < bf.fdTimeOut  and @pdTimeOut  > bf.fdTimeOut)
				or (@pdTimeIn  > fdTimeIn  and @pdTimeOut  < fdTimeOut)))
				
	return @countRecord --  @countRecord  = 0:  DUOC PHEP DAT SU KIEN TAI @pcFunctionRoom, VAO THOI GIAN  @pdTimeIn, @pdTimeoUT
-- KHONG  DUOC PHEP DAT SU KIEN TAI @pcFunctionRoom, VAO THOI GIAN  @pdTimeIn, @pdTimeoUT

end 
if @Call = '1'   -- KIEM TRA TRUNG TRONG BEO

begin 
	set @countRecord = (SELECT count(*) from stRoom_Setup rs inner join stSKLK sklk on rs.fcOrderNo = sklk.fcOrderNo
			       where rs.fcRoom = @pcFunctionRoom and rs.fcRoom not in ('08','07') and sklk.fcTrangThai  not in('C','R')
		                    AND ( rs.fnCodeID <> @pcCodeID )
	                  	       AND ((@pdTimeIn  < rs.fdTimeIn  and @pdTimeOut  > rs.fdTimeIn) 
			       or (@pdTimeIn  < rs.fdTimeOut  and @pdTimeOut  > rs.fdTimeOut)
			       or (@pdTimeIn  > fdTimeIn  and @pdTimeOut  < fdTimeOut)))
	return @countRecord  -- --  DUOC PHEP DAT SU KIEN TAI @pcFunctionRoom, VAO THOI GIAN  @pdTimeIn, @pdTimeoUT

end 

if @Call = '2'  --- -- KIEM TRA TRUNG TRONG  stTRACK_ROOM
	set @countRecord = (SELECT count(*) from stTrackRoom  
			       where fcRoom = @pcFunctionRoom 
	                  	       AND ((@pdTimeIn  < fdNgayBatDau  and @pdTimeOut  > fdNgayBatDau) or (@pdTimeIn  < fdNgayKetThuc  and @pdTimeOut  > fdNgayKetThuc)))
	if @countRecord  = 0 return 1 -- --  DUOC PHEP DAT SU KIEN TAI @pcFunctionRoom, VAO THOI GIAN  @pdTimeIn, @pdTimeoUT
	else return 0

return 0
END
GO

IF OBJECT_ID('[dbo].[fValidTimeIn_TimeOut_ofRestaurant]') IS NOT NULL DROP FUNCTION [dbo].[fValidTimeIn_TimeOut_ofRestaurant]
GO
CREATE FUNCTION dbo.fValidTimeIn_TimeOut_ofRestaurant
(
	@pcRoom nvarchar(20),
	@pcFunctionDate nvarchar(10),
	@pdTimeIn	smalldatetime,	
	@pdTimeOut	smalldatetime
)
RETURNS nvarchar(1) AS  
BEGIN 
declare @num int
--stValidooking-******* 005---------006---------007---------------008
--************************12:30------18:30 ------18:00-----------21:00

	/*if @pcRoom = 'a' or @pcRoom ='b'
		if (@pdTimeIn < = (select left(@pcFunctionDate, 10) + ' ' + fcValues from stValidBooking where fcID = '005') OR @pdTimeIn < = (select left(@pcFunctionDate, 10) + ' ' + fcValues from stValidBooking where fcID = '006'))
		AND (@pdTimeOut <=  (select left(@pcFunctionDate, 10) + ' ' + fcValues  from stValidBooking where fcID = '005') 
			OR @pdTimeOut >=  (select left(@pcFunctionDate, 10) + ' ' + fcValues  from stValidBooking where fcID = '007')  
			OR @pdTimeOut >=  (select left(@pcFunctionDate, 10) + ' ' + fcValues  from stValidBooking where fcID = '008') )
		return 0 ; --thong bao loi
		if (@pdTimeIn > = (select left(@pcFunctionDate, 10) + ' ' + fcValues from stValidBooking where fcID = '006') AND @pdTimeOut < = (select left(@pcFunctionDate, 10) + ' ' + fcValues from stValidBooking where fcID = '007'))
		OR (@pdTimeIn > = (select left(@pcFunctionDate, 10) + ' ' + fcValues from stValidBooking where fcID = '008') )
		return 0 ; --thong bao loi
		return 1;
	*/
return 1;
	
END
GO

IF OBJECT_ID('[dbo].[Get_CodeID]') IS NOT NULL DROP FUNCTION [dbo].[Get_CodeID]
GO
CREATE FUNCTION dbo.Get_CodeID
(
@orderNo nvarchar(20),
@timeIn nvarchar(20),
@timeOut nvarchar(20),
@loaiPhong nvarchar(20)
)

RETURNS nvarchar(200) AS  
BEGIN 

declare @Ten nvarchar(20), @result nvarchar(200), @final nvarchar(200)
set @result = ''

select @result = rs.fnCodeID
from stRoom_Setup rs 
inner join stPhong p on rs.fcRoom = p.fcMa  
where rs.fcOrderNo = @orderNo and rs.fdTimeIn = @timeIn and rs.fdTimeOut = @timeOut and p.fcLoaiPhong = @loaiPhong

select @final = @result 
return @final 
END
GO

IF OBJECT_ID('[dbo].[Get_Hours]') IS NOT NULL DROP FUNCTION [dbo].[Get_Hours]
GO
CREATE FUNCTION dbo.Get_Hours
(
@timeIn smalldatetime,
@timeOut smalldatetime,
@num1 as int,
@num2 as int
)
RETURNS float AS  
BEGIN 
declare @result float
--set @result = 0
select @result = case 
when (datepart(hh,@timeIn)+datepart(n,@timeIn)/ cast(60 as float)>=@num1 
and  (datepart(hh,@timeOut)+datepart(n,@timeOut)/cast(60 as float))<=@num2) 
then (datepart(hh,@timeOut)+datepart(n,@timeOut)/cast(60 as float)) 
   - (datepart(hh,@timeIn)+datepart(n,@timeIn)/ cast(60 as float))
when (datepart(hh,@timeIn)+datepart(n,@timeIn)/ cast(60 as float)>=@num1 
and  (datepart(hh,@timeIn)+datepart(n,@timeIn)/ cast(60 as float))<=@num2) 
then @num2 - (datepart(hh,@timeIn)+datepart(n,@timeIn)/ cast(60 as float))
when (datepart(hh,@timeOut)+datepart(n,@timeOut)/cast(60 as float)>=@num1 
and  (datepart(hh,@timeOut)+datepart(n,@timeOut)/cast(60 as float))<=@num2) 
then (datepart(hh,@timeOut)+datepart(n,@timeOut)/cast(60 as float))-@num1
else 2 end
return @result 
END
GO

IF OBJECT_ID('[dbo].[Get_SRate]') IS NOT NULL DROP FUNCTION [dbo].[Get_SRate]
GO
CREATE FUNCTION dbo.Get_SRate
(
@timeIn smalldatetime,
@timeOut smalldatetime,
@amount as float,
@num1 as int,
@num2 as int
)
RETURNS float AS  
BEGIN 
declare @result float
--set @result = 0
select @result =(@amount)*dbo.Get_Hours(@timeIn,@timeOut,@num1,@num2)/((datepart(hh,@timeOut)+datepart(n,@timeOut)/cast(60 as float))-(datepart(hh,@timeIn)+datepart(n,@timeIn)/ cast(60 as float))) 
return @result 
END
GO

IF OBJECT_ID('[dbo].[Get_stringFunctionDate]') IS NOT NULL DROP FUNCTION [dbo].[Get_stringFunctionDate]
GO
-- update 05/07/2007

CREATE FUNCTION dbo.Get_stringFunctionDate
(
	@pcBookID nvarchar(20),
	@flag char(1)='0'	
)

RETURNS nvarchar(4000) AS  
BEGIN 

declare @Date nvarchar(20), @sResultDate nvarchar(4000)--, @sResultDate nvarchar(4000)
set @sResultDate = ''



if @flag='0' 		-- Get string of FunctionDates in BookingRoom
	Begin
	DECLARE functionDate_cursor CURSOR FOR
	select  distinct convert(nvarchar(10), fdDate, 6) from stBookFunctionRoom where fcBookID =@pcBookID
	End

else if @flag='1'		-- Get string of FunctionDates in BEO
	begin
		DECLARE functionDate_cursor CURSOR FOR
		select  distinct convert(nvarchar(10), fdEventDate, 6) from stSKLK where fcMaster_EO=@pcBookID
	end

else if @flag='2' 		-- Get string of FunctionDates in stHoSo_BanquetForecast
	Begin
	DECLARE functionDate_cursor CURSOR FOR
	select  distinct convert(nvarchar(10), fdFunctionDate, 6) from stHoSo_BanquetForecast where fcBookID =@pcBookID
	End
	

OPEN functionDate_cursor
FETCH NEXT FROM functionDate_cursor INTO @Date
WHILE @@FETCH_STATUS = 0
BEGIN
	set @sResultDate = @sResultDate + '' + rtrim(@Date)
	FETCH NEXT FROM functionDate_cursor   INTO @Date
	set @sResultDate = @sResultDate + ' ; '
END
CLOSE functionDate_cursor
DEALLOCATE functionDate_cursor

declare @tmp nvarchar(4000)
set @tmp=@sResultDate
if len(@sResultDate) > 0   return left(@sResultDate, len(@sResultDate) - 1)
return @sResultDate


END
GO

IF OBJECT_ID('[dbo].[GetNames_BEO]') IS NOT NULL DROP FUNCTION [dbo].[GetNames_BEO]
GO
CREATE FUNCTION dbo.GetNames_BEO  -- Ham nay dung trong store  sp_Banquet_Actual va spGetListBEO_byDate
(
@pdFromDate smalldatetime,
@pdToDate smalldatetime,
@pdTimeIn smalldatetime,
@pdTimeOut smalldatetime,
@EO_ID nvarchar(20), 
@PhongLoai nvarchar(20)
)

RETURNS nvarchar(200) AS  
BEGIN 

declare @Ten nvarchar(20), @result nvarchar(200), @final nvarchar(200)
set @result = ''

DECLARE rooms_cursor CURSOR FOR

SELECT  distinct p.fcma FROM stMaster_EO ms 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stPhong p on p.fcMa= rst.fcRoom
left join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
where  (rst.fdTimeIn =@pdTimeIn and rst.fdTimeOut =@pdTimeOut) and (lk.fcOrderNo = @EO_ID and pl.fcMa = @PhongLoai)
order by p.fcma

--NOTE : BO DIEU KIEN NAY VAN CHAY DUNG ( lk.fdEventDate  between @pdFromDate and @pdToDate) (NGHIA LA DIEU KIEN THUA)


/*
SELECT  distinct p.fcma FROM stMaster_EO ms 
left join stBooking bk on ms.fcBookID = bk.fcBookID left join stGI gi on gi.fcBookID = bk.fcBookID
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on lk.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
left join stPhong p on p.fcMa= rst.fcRoom
left join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
where ( lk.fdOrderDate  between @pdFromDate and @pdToDate) and (lk.fcOrderNo = @BookID and pl.fcMa = @fr)
order by p.fcma

*/

OPEN rooms_cursor
FETCH NEXT FROM rooms_cursor INTO @Ten
WHILE @@FETCH_STATUS = 0
BEGIN
	set @result = @result + '' + rtrim(@Ten)
	FETCH NEXT FROM rooms_cursor    INTO @Ten
	set @result = @result + ', '
END
CLOSE rooms_cursor
DEALLOCATE rooms_cursor

select @final = @result 
return @final 
END
GO

IF OBJECT_ID('[dbo].[GetNames_BookfunctionRoom]') IS NOT NULL DROP FUNCTION [dbo].[GetNames_BookfunctionRoom]
GO
CREATE FUNCTION dbo.GetNames_BookfunctionRoom
(

@LoaiPhong nvarchar(20), 
@TimeIn smalldatetime,
@TimeOut smalldatetime,
@bookID nvarchar(20)
)

RETURNS nvarchar(200) AS  
BEGIN 

declare @Ten nvarchar(20), @result nvarchar(200), @final nvarchar(200)
set @result = ''

DECLARE rooms_cursor CURSOR FOR

-- UPDATE 25/04/2007
select distinct p.fcma
from stBooking a left join stBookFunctionRoom b
on a.fcBookID = b.fcBookID  
left join stPhong p on p.fcMa = b.fcFunctionRoom 

Where (p.fcloaiphong = @LoaiPhong) and ( b.fcBookID = @bookID)
and (b.fdtimein = @timein) and (b.fdtimeout = @timeout)
Order by p.fcma 

/*	OLD
select distinct p.fcma
from stBooking a inner join stBookFunctionRoom b
on a.fcBookID = b.fcBookID inner join stKhachHang a1 on a.fcGuestID = a1.fcMa
inner join stPhong p on p.fcMa = b.fcFunctionRoom 

Where (b.fdtimein = @timein) and (b.fdtimeout = @timeout) and (p.fcloaiphong = @LoaiPhong)
group by a.fdDate, a.fdDateConfirm, a1.fcTen, a1.fcNguoiLienhe, a1.fcTelephone, a1.fcEmail, a1.fcFax, a1.fcDiaChi
, b.fdDate, b.fdTimeIn, b.fdTimeOut, a.fcUser, a.fcStatus_BkRoom, p.fcLoaiPhong, p.fcma 
Order by p.fcma 

*/


OPEN rooms_cursor
FETCH NEXT FROM rooms_cursor INTO @Ten
WHILE @@FETCH_STATUS = 0
BEGIN
	set @result = @result + '' + rtrim(@Ten)
	FETCH NEXT FROM rooms_cursor    INTO @Ten
	set @result = @result + ', '
END
CLOSE rooms_cursor
DEALLOCATE rooms_cursor

select @final = @result 
return @final 
END
GO

IF OBJECT_ID('[dbo].[GetNames_Booking]') IS NOT NULL DROP FUNCTION [dbo].[GetNames_Booking]
GO
CREATE FUNCTION dbo.GetNames_Booking
(
@pdFromDate smalldatetime,
@pdToDate smalldatetime,
@pdTimeIn smalldatetime,
@pdTimeOut smalldatetime,
@BookID nvarchar(20), 
@fr nvarchar(20)
)

RETURNS nvarchar(200) AS  
BEGIN 

declare @Ten nvarchar(20), @result nvarchar(200), @final nvarchar(200)
set @result = ''

--DECLARE @TuNgay smalldatetime, @DenNgay smalldatetime
DECLARE rooms_cursor CURSOR FOR

select distinct bf.fcFunctionRoom
from stbooking bk 
left join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
WHERE  (bf.fdTimeIn =@pdTimeIn and bf.fdTimeOut =@pdTimeOut)  and (bk.fcBookID = @BookID and pl.fcMa = @fr)
order by bf.fcFunctionRoom


OPEN rooms_cursor
FETCH NEXT FROM rooms_cursor INTO @Ten
WHILE @@FETCH_STATUS = 0
BEGIN
	set @result = @result + '' + rtrim(@Ten)
	FETCH NEXT FROM rooms_cursor    INTO @Ten
	set @result = @result + ', '
END
CLOSE rooms_cursor
DEALLOCATE rooms_cursor

select @final = @result 
return @final 
END
GO

IF OBJECT_ID('[dbo].[GetNames_Print_BEO]') IS NOT NULL DROP FUNCTION [dbo].[GetNames_Print_BEO]
GO
CREATE FUNCTION dbo.GetNames_Print_BEO
(
	@EO_ID nvarchar(20), 
	@LoaiPhong nvarchar(20),
	@pdTimeIn nvarchar(20),
	@pdTimeOut nvarchar(20)
)

RETURNS nvarchar(200) AS  
BEGIN 

declare @Ten nvarchar(20), @result nvarchar(200), @final nvarchar(200)
set @result = ''

DECLARE rooms_cursor CURSOR FOR

SELECT  distinct p.fcma  FROM stMaster_EO ms 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stPhong p on p.fcMa= rst.fcRoom
where  (lk.fcOrderNo = @EO_ID  and p.fcLoaiPhong = @LoaiPhong)
and (fdTimeIn = @pdTimeIn and fdTimeOut = @pdTimeOut)
order by p.fcma


OPEN rooms_cursor
FETCH NEXT FROM rooms_cursor INTO @Ten
WHILE @@FETCH_STATUS = 0
BEGIN
	set @result = @result + '' + rtrim(@Ten)
	FETCH NEXT FROM rooms_cursor    INTO @Ten
	set @result = @result + ', '
END
CLOSE rooms_cursor
DEALLOCATE rooms_cursor

select @final = @result 
return @final 
END
GO

IF OBJECT_ID('[dbo].[sfACTUAL_byCharge]') IS NOT NULL DROP FUNCTION [dbo].[sfACTUAL_byCharge]
GO
-- Lay du lieu tu B.E.O (ACTUAL) cua trang thai DEFINITE
-- Dung khi KH co hop va dat tiec (charges) cho cac functionRoom do
--1.  PHUONG PHAP: giong cua sfTongTien_FORECAST_coCharge_cua_1Room 
--VI DU: Xem vi du trong sfTongTien_FORECAST_coCharge_cua_1Room 
	-- Chang han, ta co MK1, MK2, MK3 cung thuoc loai phong MK
	-- thi khi tinh tong tien charge cho tung phong ta tinh nhu sau
	-- ta se tinh tong tien charge cua MK1 = TotalCharge(MK1) + Totalcharge(MK12)/2 + Totalcharge(MK13)/2 + Totalcharge(MK123)/3
	-- tong tien charge cua MK2 = TotalCharge(MK2) + Totalcharge(MK12)/2 + Totalcharge(MK23)/2 + Totalcharge(MK123)/3
	-- tong tien charge cua MK3 = TotalCharge(MK3) + Totalcharge(MK13)/2 + Totalcharge(MK23)/2 + Totalcharge(MK123)/3

CREATE FUNCTION dbo.sfACTUAL_byCharge
(
	@pcYear nvarchar(4),
	@pnMonth int,
	@pcLoaiPhong	nvarchar(10),
	@pcPhong nvarchar(10),
	@pcCurrDate nvarchar(10) =''  		-- @pcCurrDate <> '': doc du lieu tu NGAY DAU THANG den ngay @pcCurrDate					-- @pcCurrDate = '': doc du lieu ca THANG @pnMonth
)  

RETURNS decimal(12, 5) AS  
BEGIN 

declare @nTongTien_1Rm decimal(12, 5) 
set @nTongTien_1Rm = ( 
	select  sum(fnAmount_of_1Rm)   as fnCharge_1Rm from (
		SELECT   lk.fcOrderNo, p.fcLoaiPhong, 
	/* -- CHI SHOW DE KIEM TRA SO LIEU TRONG CAU SELECT NAY
		dbo.GetNames_BEO( '', '', rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, p.fcLoaiPhong ) as fcFunctionCode, 
		dbo.fDefind(dbo.GetNames_BEO( '', '', rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, p.fcLoaiPhong )) as fcFunctionRoom, 
		isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014', '015') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
		dbo.sfGet_No_ofRms_ACTUAL ( lk.fcOrderNo, p.fcLoaiPhong, rst.fdTimeIn, rst.fdTimeOut ) as fnCountRms, 

		isnull(sum(case when lk.fcTrangThai  = 'D' then lkdt.fnAmount else 0 end ),0) as  fnDEF_Rev, 
		isnull(sum(case when lk.fcTrangThai  = 'D' then fnAmount else 0 end ),0)  -   cast(  isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lk.fcTrangThai ='D' then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)  as decimal)   as  fnDEF_BQ_Rev,
	*/
		dbo.sfTinhDonGia_1Room( isnull(sum(case when lk.fcTrangThai  = 'D' then fnAmount else 0 end ),0)  -   cast(  isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lk.fcTrangThai ='D' then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)  as decimal) , dbo.sfGet_No_ofRms_ACTUAL(lk.fcOrderNo, p.fcLoaiPhong, rst.fdTimeIn, rst.fdTimeOut) ) as fnAmount_of_1Rm

		FROM stMaster_EO ms 
			left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
			left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
			left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
			left  join stPhong p on p.fcMa= rst.fcRoom
		WHERE ( lk.fcTrangThai ='D' ) 
			and year(lk.fdEventDate) =@pcYear 
			and ( @pnMonth   =  0 or month(lk.fdEventDate) = @pnMonth  )
			and (@pcCurrDate = '' or  lk.fdEventDate  <= cast ( @pcCurrDate as smalldatetime ) )
			and p.fcLoaiPhong =@pcLoaiPhong 
			and dbo.GetNames_BEO( '', '', rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, p.fcLoaiPhong ) like  '%'+@pcPhong+'%' 

		GROUP BY lk.fcOrderNo, p.fcLoaiPhong, rst.fdTimeIn, rst.fdTimeOut
		HAVING not (p.fcLoaiPhong  in('08', '09') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0)
			AND isnull(sum( isnull (fnAmount, 0) ),0) > 0  
	)aa)
return isnull(@nTongTien_1Rm, 0)

END
GO

IF OBJECT_ID('[dbo].[sfDsachPhong_chuaCharge]') IS NOT NULL DROP FUNCTION [dbo].[sfDsachPhong_chuaCharge]
GO
CREATE FUNCTION dbo.sfDsachPhong_chuaCharge
 (
	@pcFromDate nvarchar(10),
	@pcToDate nvarchar(10)
 )  
RETURNS int AS  
BEGIN 
/*
	SELECT  distinct bk.fcBookid , bf.fdDate
	, p.fcLoaiPhong

	FROM stbOOKING bk
		left  join stBookFunctionRoom bf on bk.fcBookid = bf.fcBookid
		left  join stBooking_Charges bc on bf.fcBookid = bc.fcBookid and  bf.fnCodeID = bc.fnCodeID
		left  join stPhong p on p.fcMa= bf.fcFunctionRoom
	WHERE ( bk.fcStatus_BkRoom <>'C' )  and (bf.fdDate  between @pdFromDate and @pdToDate)

	GROUP BY bk.fcBookid, p.fcLoaiPhong, bf.fdDate
	HAVING not (p.fcLoaiPhong  in('08', '09')  and isnull(sum(bc.fnQuantity), 0 )  <= 0) 
	AND isnull(sum( isnull (fnAmount, 0) ),0) = 0
*/
return 1
END
GO

IF OBJECT_ID('[dbo].[sfFORECAST_byALLOWPRICE]') IS NOT NULL DROP FUNCTION [dbo].[sfFORECAST_byALLOWPRICE]
GO
CREATE FUNCTION dbo.sfFORECAST_byALLOWPRICE  
-- NOTE: Lay du lieu tu BOOKING (FORECAST) cua trang thai DEFINITE + TENTATIVE cua CAC PHONG CHUA DUOC CHARGES TIEN
-- Tinh tong tien cua 1 phong theo gia co ban: Truong hop khi KH dat phong ma khong dat an uong (charges), thi tinh tien phong theo gia co ban/gio
-- CONG THUC MOI YEU CAU 11/09/2007 : tienPhong = tienPhongcuaBudget_trong1thang/(songayTrongThang * 14gio) * so gio dat phong trong booking
-- Vi du: Budget cua MK1 trong thang 9 la 22000$ -> giaPhongMK1 /1gio =  22000/(30*14)
 (
	@pcYear nvarchar(4),
	@pnMonth int,
	@pcPhong nvarchar(10)
 )  
RETURNS decimal(12, 5) AS  
BEGIN 

declare @pnMonth_ToDate int
declare @nSoNgayTrongThang int
declare @pdFromDate smalldatetime
declare @pdToDate smalldatetime

-- TRUONG HOP MONTH_TO_DATE ( @pnMonth <> 0 ) , NEU @pnMonth = 9, @pcYear= '2007' THI  @pdFromDate = '01/09/2007' VA @pdToDate ='30/09/2007'
-- TRUONG HOP YEAR_TO_DATE ( @pnMonth  = 0 ) ,  @pcYear= '2007'  THI @pdFromDate = '01/01/2007'  VA @pdToDate = '31/12/2007'
set @pdFromDate = ( case @pnMonth when 0 then '01/01/'  +  @pcYear else '01/'  +  cast ( @pnMonth as nvarchar(2) ) + '/' +  @pcYear end ) 
set @nSoNgayTrongThang = ( select dbo.sfGet_NoOfDays_ofMonth (@pdFromDate) )
set @pnMonth_ToDate = ( case @pnMonth when 0 then 12 else @pnMonth end)
set @pdToDate =  cast ( @nSoNgayTrongThang as nvarchar(2) ) + '/' + cast( @pnMonth_ToDate as nvarchar(2)) + '/' + @pcYear


declare @nTienPhong decimal(12, 5)

SET @nTienPhong  = ( SELECT SUM (fnTienPhong) AS fnTienPhong_byBasicPrice FROM (
	select  dbo.sfGiaPhong_chuaCharges_1HOUR ( fdDate ,  @pcPhong ) as fnGia_1Hour
	, dbo.sfGiaPhong_chuaCharges_1HOUR ( fdDate ,  @pcPhong ) * fnSoGioDat as  fnTienPhong
	, *
	from dbo.sfDsachPhong_chuaCharges ( @pdFromDate , @pdToDate ) 
	where fcFunctionRoom_Code like '%' +  @pcPhong + '%'

) tbTienPhong )
return isnull(@nTienPhong, 0)

END
GO

IF OBJECT_ID('[dbo].[sfFORECAST_byCharge]') IS NOT NULL DROP FUNCTION [dbo].[sfFORECAST_byCharge]
GO
--1. Y NGHIA:
	-- Dung de tim so tien cua cot (Forecast: OTB) trong store sp_MONTHLY_BQRevenue cua bao cao MonthLy
	-- Lay du lieu tu BOOKING (FORECAST) cua trang thai DEFINITE + TENTATIVE
	-- Dung khi KH co hop va dat tiec (charges) cho cac functionRoom do
--2.  PHUONG PHAP:
	-- Xet Trong cung mot Booking (BookID)
	--Buoc 1: Lay tong so Amount khi khach chi charge mot phong rieng le (tien charge cua duy nhat phong @pcPhong)
	--Buoc 2: Lay tong so Amount/so phong khi khach  charge tron goi cho cung mot loai phong co chua phong @pcPhong
	--Buoc 3: Tong tien co charge cua @pcPhong = tien (Buoc 1) + tien (Buoc 2)
--3.  VI DU: ta co phong MK1, MK2, MK3 thuoc loai phong MK
	--Buoc 1: Khach chi dat tiec, tong tien tinh duoc o phong MK1 = 1000$, MK2 = 2500$
	--Buoc 2: + Khach dat tiec tron goi cho 2 phong MK1,2 la  3000$ => Amount cua moi phong la 1500$
	-- 	  + Khach dat tiec tron goi cho 2 phong MK1, 3 la  500$  => Amount cua moi phong la 250$
	-- 	  + Khach dat tiec tron goi cho 3 phong MK1,2, 3 la  3000$ => Amount cua moi phong la 1000$
	-- Buoc 3: Tong tien da charge cho phong MK1 la: 1000$ + (1500$ + 250$ + 1000$)

-- TINH TUONG TU CHO MK2; ta se tinh tong tien charge cua MK2 = TotalCharge(MK2) + Totalcharge(MK12)/2 + Totalcharge(MK23)/2 + Totalcharge(MK123)/3

--4. KIEM CHUNG:  Ta co the kiem tra lai so lieu trong bao cao BanquetForecast theo tung buoc cua vi du nay

-- 5. NOTE: SO SÁNH dbo.sfFORECAST_byCharge_TODATE VA dbo.sfFORECAST_byCharge
	-- 5.1. dbo.sfFORECAST_byCharge_TODATE KHAC VOI  dbo.sfFORECAST_byCharge O DIEU KIEN WHERE 
	-- 5.2. dbo.sfFORECAST_byCharge: CHI LAY TotalAmount CUA PHONG TRONG 1 THANG
	-- 5.3. dbo.sfFORECAST_byCharge_TODATE:  LAY TotalAmount CUA PHONG TU DAU NAM CHO DEN NGAY HIEN HANH @pcCurrDate

CREATE FUNCTION dbo.sfFORECAST_byCharge  ---GOOD!
(
	@pcYear nvarchar(4),
	@pnMonth int,
	@pcLoaiPhong	nvarchar(10),
	@pcPhong	nvarchar(10),
	@pcCurrDate nvarchar(10) =''		-- @pcCurrDate <> '': doc du lieu tu ngay dau thang den ngay @pcCurrDate
						-- @pcCurrDate = '': doc du lieu ca thang @pnMonth
)  
RETURNS decimal(12, 5)  AS  
--RETURNS decimal  AS  
BEGIN 
declare @nTongTien_1Rm decimal(12, 5)
--declare @nTongTien_1Rm decimal

set @nTongTien_1Rm = ( select sum(fnAmount_of_1Rm)as fnCharge_1Rm from (
	SELECT  bk.fcBookid, p.fcLoaiPhong
	/*	 -- CHI SHOW DE KIEM TRA SO LIEU
	bf.fdTimeIn, bf.fdTimeOut, 
	dbo.GetNames_Booking('', '',  bf.fdTimeIn, bf.fdTimeOut,bk.fcBookID, p.fcLoaiPhong) as fcFunctionRoom_Code, 
	dbo.fDefind(dbo.GetNames_Booking('', '',  bf.fdTimeIn, bf.fdTimeOut,bk.fcBookID, p.fcLoaiPhong)) as fcFunctionRoom, 
	isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015') then bc.fnQuantity else 0 end ),0) as fnGUA,
	dbo.sfGet_No_ofRms_FORECAST(bk.fcBookid, p.fcLoaiPhong,  bf.fdTimeIn, bf.fdTimeOut) as fnCountRms, 

	isnull(sum(case when bk.fcStatus_BkRoom  <> 'C' then fnAmount else 0 end ),0) as  fnDEF_TEN_Rev, 
	isnull(sum(case when bk.fcStatus_BkRoom  <> 'C' then fnAmount else 0 end ),0)  - cast(  isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom <>'C' then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)  as decimal )  as  fnDEF_TEN_BQ_Rev,
	isnull(sum(case when bk.fcStatus_BkRoom  in('T', 'P', 'A') then CAST ( fnAmount AS DECIMAL ) else 0 end ),0)  - cast( isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom in('A', 'T', 'P') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as decimal)  as  fnTEN_BQ_Rev,
	 , dbo.sfTinhDonGia_1Room( isnull(sum(case when bk.fcStatus_BkRoom  in('T', 'P', 'A') then CAST ( fnAmount AS DECIMAL ) else 0 end ),0)  - cast( isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom in('A', 'T', 'P') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as decimal)  , dbo.sfGet_No_ofRms_FORECAST(bk.fcBookid, p.fcLoaiPhong,  bf.fdTimeIn, bf.fdTimeOut) ) as fnAmount_of_1Rm_TEN
	, dbo.sfTinhDonGia_1Room( isnull(sum(case when bk.fcStatus_BkRoom = 'D' then fnAmount else 0 end ),0)  -   cast(  isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom = 'D' then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)  as decimal) , dbo.sfGet_No_ofRms_FORECAST(bk.fcBookid, p.fcLoaiPhong,  bf.fdTimeIn, bf.fdTimeOut) ) as fnAmount_of_1Rm_DEF
	*/


	, dbo.sfTinhDonGia_1Room( isnull(sum(case when bk.fcStatus_BkRoom <> 'C' then fnAmount else 0 end ),0)  -   cast(  isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom <> 'C' then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)  as decimal) , dbo.sfGet_No_ofRms_FORECAST(bk.fcBookid, p.fcLoaiPhong,  bf.fdTimeIn, bf.fdTimeOut) ) as fnAmount_of_1Rm


	FROM stbOOKING bk
		left  join stBookFunctionRoom bf on bk.fcBookid = bf.fcBookid
		left  join stBooking_Charges bc on bf.fcBookid = bc.fcBookid and  bf.fnCodeID = bc.fnCodeID
		left  join stPhong p on p.fcMa= bf.fcFunctionRoom
	WHERE ( bk.fcStatus_BkRoom  <>'C' ) 
		and year(bf.fdDate) = @pcYear 
		and (@pnMonth = 0 OR  month(bf.fdDate) = @pnMonth )
--		and (@pcCurrDate = '' or  bf.fdDate   <= cast( @pcCurrDate as smalldatetime) )
		and p.fcLoaiPhong = @pcLoaiPhong
		and dbo.GetNames_Booking('', '',  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, p.fcLoaiPhong) like  '%'+@pcPhong+'%' 

	GROUP BY bk.fcBookid, p.fcLoaiPhong, bf.fdTimeIn, bf.fdTimeOut
	HAVING not (p.fcLoaiPhong  in('08', '09')  and isnull(sum(bc.fnQuantity), 0 )  <= 0) 
	AND isnull(sum( isnull (fnAmount, 0) ),0) > 0  

)aa)
return isnull(@nTongTien_1Rm, 0)

END
GO

IF OBJECT_ID('[dbo].[sfGet_No_ofRms]') IS NOT NULL DROP FUNCTION [dbo].[sfGet_No_ofRms]
GO
CREATE FUNCTION dbo.sfGet_No_ofRms
(
	@pcBookID nvarchar(20),
	@pdTimeIn smalldatetime  ='', 
	@pdTimeOut smalldatetime =''
)  
RETURNS int AS  
BEGIN 

declare @nNo_Rms int
set @nNo_Rms = ( 
	select count(bf.fcFunctionRoom)
	from stbooking bk 
	left join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
	left join stPhong p on p.fcMa= bf.fcFunctionRoom
	WHERE bk.fcBookID =  @pcBookID and  bf.fdTimeIn = @pdTimeIn  and bf.fdTimeOut = @pdTimeOut  
)
	return  @nNo_Rms
END
GO

IF OBJECT_ID('[dbo].[sfGet_No_ofRms_ACTUAL]') IS NOT NULL DROP FUNCTION [dbo].[sfGet_No_ofRms_ACTUAL]
GO
-- Create 03/08/2007
CREATE FUNCTION dbo.sfGet_No_ofRms_ACTUAL 
(
	@pcOrderNo nvarchar(20),
	@pcLoaiPhong nvarchar(20),
	@pdTimeIn smalldatetime  ='', 
	@pdTimeOut smalldatetime =''
)  
RETURNS int AS  
BEGIN 
declare @nNo_Rms int
set @nNo_Rms = (
	SELECT  count( p.fcma) FROM stMaster_EO ms 
	left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
	left join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
	left join stPhong p on p.fcMa= rst.fcRoom
	where  (lk.fcOrderNo = @pcOrderNo and p.fcLoaiPhong = @pcLoaiPhong )and (rst.fdTimeIn =  @pdTimeIn and rst.fdTimeOut = @pdTimeOut )
)
	return @nNo_Rms
END
GO

IF OBJECT_ID('[dbo].[sfGet_No_ofRms_FORECAST]') IS NOT NULL DROP FUNCTION [dbo].[sfGet_No_ofRms_FORECAST]
GO
-- Create 03/08/2007
CREATE FUNCTION dbo.sfGet_No_ofRms_FORECAST
(
	@pcBookID nvarchar(20),
	@pcLoaiPhong nvarchar(20),
	@pdTimeIn smalldatetime  ='', 
	@pdTimeOut smalldatetime =''
)  
RETURNS int AS  
BEGIN 

declare @nNo_Rms int
set @nNo_Rms = ( 
	select count(bf.fcFunctionRoom)
	from stbooking bk 
	left join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
	left join stPhong p on p.fcMa= bf.fcFunctionRoom
	WHERE (bk.fcBookID =  @pcBookID and p.fcLoaiPhong=  @pcLoaiPhong )   and  (bf.fdTimeIn = @pdTimeIn  and bf.fdTimeOut = @pdTimeOut ) 
)
	return  @nNo_Rms
END
GO

IF OBJECT_ID('[dbo].[sfGet_NoOfDays_ofMonth]') IS NOT NULL DROP FUNCTION [dbo].[sfGet_NoOfDays_ofMonth]
GO
CREATE FUNCTION dbo.sfGet_NoOfDays_ofMonth
(
	@pdDate as smalldatetime
)  
RETURNS int  AS  
BEGIN 
	declare @NoOfDays int
	select  @NoOfDays =  cast ( day(dateadd(day, -1, dateadd(month, 1, dateadd(day, -(day(@pdDate) - 1), @pdDate)))) as int)
	return @NoOfDays
END
GO

IF OBJECT_ID('[dbo].[sfGet_PERCENT]') IS NOT NULL DROP FUNCTION [dbo].[sfGet_PERCENT]
GO
CREATE FUNCTION dbo.sfGet_PERCENT
(
	@nDividend decimal(12,2), 
	@nDivisor decimal(12,2) 
)  
RETURNS decimal(12,2) AS  
BEGIN 
	set @nDividend = isnull (@nDividend, 0)
	set @nDivisor = isnull (@nDivisor, 0)

	DECLARE @pnPercent decimal(12, 2)
	set @pnPercent =  (CASE  
		 WHEN  @nDivisor >= 0   AND   @nDividend  =  0 THEN  0
		 WHEN  @nDivisor   = 0   AND   @nDividend   > 0 THEN  100
		 WHEN  @nDivisor   > 0   AND   @nDividend   > 0 THEN  (@nDividend/ @nDivisor) *100  END)   
	RETURN @pnPercent
END
GO

IF OBJECT_ID('[dbo].[sfGet_valueBudget_monthTODATE]') IS NOT NULL DROP FUNCTION [dbo].[sfGet_valueBudget_monthTODATE]
GO
CREATE FUNCTION dbo.sfGet_valueBudget_monthTODATE
(
	@pcYear nvarchar(4),
	@pnMonth int ,
	@pcRoom nvarchar(10)
)  
RETURNS decimal(12, 2) AS  
BEGIN 
	declare @pnValueBudget decimal(12, 2)
	set @pnValueBudget = (	
		SELECT (CASE 
			when @pnMonth = 1 then fcJan
			when @pnMonth = 2 then fcFeb
			when @pnMonth = 3 then fcMar
			when @pnMonth = 4 then fcApr
			when @pnMonth = 5 then fcMay
			when @pnMonth = 6 then fcJun
			when @pnMonth = 7 then fcJul
			when @pnMonth = 8 then fcAug
			when @pnMonth = 9 then fcSep
			when @pnMonth = 10 then fcOct
			when @pnMonth = 11 then fcNov
			when @pnMonth = 12 then fcDec END ) as fcBudget 
		FROM  stBudget 
		WHERE fcYear = @pcYear AND fcRoom =@pcRoom
	) -- END SELECT
	return  @pnValueBudget
END
GO

IF OBJECT_ID('[dbo].[sfGet_valueBudget_yearTODATE]') IS NOT NULL DROP FUNCTION [dbo].[sfGet_valueBudget_yearTODATE]
GO
CREATE FUNCTION dbo.sfGet_valueBudget_yearTODATE
(
	@pcYear nvarchar(4),
	@pnMonth int ,
	@pcRoom nvarchar(10)
)  
RETURNS decimal(12, 2) AS  
BEGIN 
	declare @pnValueBudget decimal(12, 2)
	set @pnValueBudget = (	
		SELECT (CASE 
			when @pnMonth = 1 then fcJan
			when @pnMonth = 2 then fcJan + fcFeb
			when @pnMonth = 3 then fcJan + fcFeb + fcMar
			when @pnMonth = 4 then fcJan + fcFeb + fcMar + fcApr
			when @pnMonth = 5 then fcJan + fcFeb + fcMar + fcApr +  fcMay
			when @pnMonth = 6 then fcJan + fcFeb + fcMar + fcApr +  fcMay + fcJun
			when @pnMonth = 7 then fcJan + fcFeb + fcMar + fcApr +  fcMay + fcJun + fcJul
			when @pnMonth = 8 then fcJan + fcFeb + fcMar + fcApr +  fcMay + fcJun + fcJul + fcAug
			when @pnMonth = 9 then fcJan + fcFeb + fcMar + fcApr +  fcMay + fcJun + fcJul + fcAug + fcSep
			when @pnMonth = 10 then fcJan + fcFeb + fcMar + fcApr +  fcMay + fcJun + fcJul + fcAug + fcSep + fcOct
			when @pnMonth = 11 then fcJan + fcFeb + fcMar + fcApr +  fcMay + fcJun + fcJul + fcAug + fcSep + fcOct + fcNov
			when @pnMonth = 12 then fcJan + fcFeb + fcMar + fcApr +  fcMay + fcJun + fcJul + fcAug + fcSep + fcOct + fcDec END ) as fcBudget 
		FROM  stBudget 
		WHERE fcYear = @pcYear AND fcRoom =@pcRoom
	) -- END SELECT
	return  @pnValueBudget
END
GO

IF OBJECT_ID('[dbo].[sfGetAmount_ALLOW_WEEKDAY]') IS NOT NULL DROP FUNCTION [dbo].[sfGetAmount_ALLOW_WEEKDAY]
GO
CREATE FUNCTION dbo.sfGetAmount_ALLOW_WEEKDAY -- tinh TienPhong tu FROMDATE ... TODATE cua ALLOW trong dbo.sp_ALLOW_OCCUPIED_FunctionRoom
(
	@pdFromDate smalldatetime, 
	@pdToDate smalldatetime,
	@pcRoom nvarchar(20)
)  
RETURNS decimal(12, 2) AS  
BEGIN 

	declare @dCurrDate smalldatetime
	set @dCurrDate =   @pdFromDate

	declare @nBudget decimal(12,2)
	declare @nNodays_OfMonth int 	-- so ngay trong 1 thang

	declare @nTienPhong_WD decimal(12,2)
	set @nTienPhong_WD = 0

	-- So gio Booking toi da cua mot functionRoom/1ngay
	declare @nMaxHours int 
	set @nMaxHours = (select cast(fcValues as int)  from stValidBooking where fcID = '011')

	-- So ngay, gio Weekend trong 1 thang
	declare @nNoOfDays_WD int  
	declare @nNoOfHours_WD int  
	declare @dNgayCuoiThang smalldatetime

	WHILE Month(@dCurrDate) <= month(@pdToDate)  and Year(@dCurrDate) <= Year(@pdToDate)
	BEGIN
		set @nNodays_OfMonth = dbo.sfGet_NoOfDays_ofMonth ( @dCurrDate )
		--set @dNgayCuoiThang =  cast(@nNodays_OfMonth as nvarchar(2)) + '/' + cast(Month(@dCurrDate) as nvarchar(2)) + '/' + cast (year(@dCurrDate) as nvarchar(4))
		set @dNgayCuoiThang =   cast(Month(@dCurrDate) as nvarchar(2)) + '/' + cast(@nNodays_OfMonth as nvarchar(2)) + '/' + cast (year(@dCurrDate) as nvarchar(4))
		
		set @nNoOfDays_WD = datediff( dd, @dCurrDate, @dNgayCuoiThang)  + 1  -  (select  dbo.sfGetNumDays_Weekend(@dCurrDate, @dNgayCuoiThang ))  -- SO NGAY Weekday trong thang month(@dCurrDate)
		set @nNoOfHours_WD = @nNoOfDays_WD * @nMaxHours		--  SO GIO  Weekday trong thang month(@dCurrDate)

		set @nBudget = dbo.sfGet_valueBudget_monthTODATE ( year(@dCurrDate), month(@dCurrDate), @pcRoom)	-- SO TIEN ALLOW trong thang month(@dCurrDate)

		set @nTienPhong_WD  = @nTienPhong_WD +  @nBudget/( @nNodays_OfMonth * @nMaxHours ) * @nNoOfHours_WD 	 -- SO TIEN ALLOW-WD TRONG THANG month(@dCurrDate)
		set @dCurrDate = dateadd ( m, 1	, @dCurrDate )
	END
	return   @nTienPhong_WD  -- TONG SO TIEN ALLOW-WD TU FROMDATE ->  TODATE
END
GO

IF OBJECT_ID('[dbo].[sfGetAmount_ALLOW_WEEKEND]') IS NOT NULL DROP FUNCTION [dbo].[sfGetAmount_ALLOW_WEEKEND]
GO
CREATE FUNCTION dbo.sfGetAmount_ALLOW_WEEKEND -- tinh TienPhong tu FROMDATE -> TODATE cua ALLOW-WEEKEND trong dbo.sp_ALLOW_OCCUPIED_FunctionRoom
(
	@pdFromDate smalldatetime, 
	@pdToDate smalldatetime,
	@pcRoom nvarchar(20)
)  
RETURNS decimal(12, 2) AS  
BEGIN 

	declare @dCurrDate smalldatetime
	set @dCurrDate =   @pdFromDate

	declare @nBudget decimal(12,2)
	declare @nNodays_OfMonth int 	-- so ngay trong 1 thang

	declare @nTienPhong_WE decimal(12,2)
	set @nTienPhong_WE = 0

	-- So gio Booking toi da cua mot functionRoom/1ngay
	declare @nMaxHours int 
	set @nMaxHours = (select cast(fcValues as int)  from stValidBooking where fcID = '011')

	-- So gio Weekend trong 1 thang
	declare @nNoOfHours_WE int  
	declare @dNgayCuoiThang smalldatetime


	WHILE Month(@dCurrDate) <= month(@pdToDate)  and Year(@dCurrDate) <= Year(@pdToDate)
	BEGIN
		set @nNodays_OfMonth = dbo.sfGet_NoOfDays_ofMonth ( @dCurrDate )
		set @dNgayCuoiThang = cast(Month(@dCurrDate) as nvarchar(2)) + '/' + cast(@nNodays_OfMonth as nvarchar(2)) + '/' +  cast (year(@dCurrDate) as nvarchar(4))

		set @nNoOfHours_WE = ( select  dbo.sfGetNumDays_Weekend(@dCurrDate, @dNgayCuoiThang ) ) * @nMaxHours -- SO GIO WE TRONG THANG month(@dCurrDate)
		set @nBudget = dbo.sfGet_valueBudget_monthTODATE ( year(@dCurrDate), month(@dCurrDate), @pcRoom) -- SO TIEN ALLOW TRONG THANG month(@dCurrDate)

		set @nTienPhong_WE  =  @nTienPhong_WE  +  @nBudget/( @nNodays_OfMonth * @nMaxHours ) * @nNoOfHours_WE  -- SO TIEN ALLOW-WE TRONG THANG month(@dCurrDate)
		set @dCurrDate = dateadd ( m, 1	, @dCurrDate )
	END
	return   @nTienPhong_WE  --TONG  SO TIEN ALLOW-WE TU FROMDATE -> TODATE
END
GO

IF OBJECT_ID('[dbo].[sfGetFunctionType]') IS NOT NULL DROP FUNCTION [dbo].[sfGetFunctionType]
GO
CREATE FUNCTION dbo.sfGetFunctionType 
(
	@pcBookID nvarchar(20),
	@pdTimeIn smalldatetime,
	@pdTimeOut smalldatetime,
	@pcLoaiPhong nvarchar(20)
)  
RETURNS nvarchar(100)  AS  
BEGIN 
declare @pcFunctionType as nvarchar(100)

	set @pcFunctionType = ( select top 1  sk.fcTen from  stBookFunctionRoom bf 
				inner  join stSuKien sk on bf.fcFunctionType= sk.fcMa
				inner join stPhong p on  bf.fcFunctionRoom = p.fcMa
				where  (bf.fdTimeIn =@pdTimeIn and bf.fdTimeOut =@pdTimeOut)  and (bf.fcBookID = @pcBookID ) and (p.fcLoaiPhong = @pcLoaiPhong)
 				)
return @pcFunctionType
END
GO

IF OBJECT_ID('[dbo].[sfGetNumDays_Weekend]') IS NOT NULL DROP FUNCTION [dbo].[sfGetNumDays_Weekend]
GO
CREATE FUNCTION dbo.sfGetNumDays_Weekend 
(
	@pdFromDate smalldatetime, 
	@pdToDate smalldatetime
)  
RETURNS int  AS  
BEGIN 
	declare  @pnNo_Of_Weekend int
	declare @dMyDate as smalldatetime
	set @pnNo_Of_Weekend= 0
	set @dMyDate = @pdFromDate

	WHILE @dMyDate <= @pdToDate
	BEGIN	
		if  datename (dw, @dMyDate) = 'Sunday' or  datename (dw, @dMyDate) = 'Saturday' 
		begin 
			set @pnNo_Of_Weekend  = @pnNo_Of_Weekend  + 1
		end
		set  @dMyDate = dateadd ( day, 1, @dMyDate)
	END
	 return @pnNo_Of_Weekend
END
GO

IF OBJECT_ID('[dbo].[sfGiaPhong_chuaCharges_1HOUR]') IS NOT NULL DROP FUNCTION [dbo].[sfGiaPhong_chuaCharges_1HOUR]
GO
/*
truong  co do khong?
em chep UserGuide ra destop cho nguoi ta xai o tat ca cac may nghe 
hoi nay e chep nham cai cua e roi, de chi goi em  can update cai gi ?
chi update giup e 2 cai sp_salesofmont va sp_salesomonth_tmp,1 cai dbo.view_salesofmonth_tmp,1 functiontion e wen ten roi chi xem cai nao cung ngay voi dbo.view_salesofmonth day
*/



--  TIM GIA PHONG TRONG 1 GIO CUA STORE
-- CONG THUC MOI YEU CAU 11/09/2007 : GIAPhong/1HOUR = tienPhongtrongBudget/(songayTrongThang * 14gio) 
-- CONG THUC MOI YEU CAU 11/09/2007 : tienPhong = GIAPhong/1HOUR  * so gio dat phong trong booking
CREATE FUNCTION dbo.sfGiaPhong_chuaCharges_1HOUR
(
	@pdDate smalldatetime,
	@pcRoom nvarchar(20)
)  
RETURNS decimal(12, 2) AS  
BEGIN 

	declare @nBudget decimal(12,2)  -- TIEN PHONG YEU CAU BAN DUOC TRONG 1 THANG (ALLOW)
	declare @nNodays_OfMonth int 	-- so ngay trong 1 thang

	-- So gio Booking toi da cua mot functionRoom/1ngay
	declare @nMaxHours int 
	set @nMaxHours = (select cast(fcValues as int)  from stValidBooking where fcID = '011')

	declare @nTienPhong_1Hour decimal(12,2)
	set @nTienPhong_1Hour = 0


	BEGIN
		set @nNodays_OfMonth = dbo.sfGet_NoOfDays_ofMonth ( @pdDate )
		set @nBudget = dbo.sfGet_valueBudget_monthTODATE ( year( @pdDate ), month( @pdDate ), @pcRoom) -- SO TIEN ALLOW TRONG THANG month(@pdDate)

		set @nTienPhong_1Hour = @nBudget/( @nNodays_OfMonth * @nMaxHours ) -- GIA PHONG CO BAN ( ALLOW ) TRONG 1 HOUR CUA THANG  month(@pdDate)
	END
	return   @nTienPhong_1Hour   --TIEN PHONG @pcRoom TRONG 1 GIO CHO PHEP 
END
GO

IF OBJECT_ID('[dbo].[sfIs_Weekend]') IS NOT NULL DROP FUNCTION [dbo].[sfIs_Weekend]
GO
-- NOTE: SET DATEFIRST to U.S. English default value of 7 (SUNday  );  SET DATEFIRST  7

CREATE FUNCTION dbo.sfIs_Weekend 		--  Weekend la ngay thu 7 va  CN 
(
	@pdDate  smalldatetime
)  


RETURNS int  AS  
BEGIN 
declare @isWeekend nvarchar(10)

set @isWeekend = (  SELECT DATENAME(DW,  @pdDate ) )
if @isWeekend = 'Sunday' or @isWeekend = 'Saturday'   return 1 			
return 0
END
GO

IF OBJECT_ID('[dbo].[sfTinhDonGia_1Room]') IS NOT NULL DROP FUNCTION [dbo].[sfTinhDonGia_1Room]
GO
-- Create 03/08/2007
CREATE FUNCTION dbo.sfTinhDonGia_1Room
(
	@pnTien decimal (12, 5),
	@pnSoPhong decimal 
)  
RETURNS decimal(12,5)  AS  

BEGIN 
	set @pnTien = isnull (@pnTien, 0 ) 
	set @pnSoPhong = isnull (@pnSoPhong, 0 )
	declare @pnDonGia decimal (12, 5)

	SET  @pnDonGia = (CASE 
			   WHEN @pnSoPhong >= 0  and @pnTien = 0 THEN  0 
			   WHEN @pnSoPhong > 0  and @pnTien <> 0 THEN  cast ( @pnTien as decimal(12, 5)) / @pnSoPhong  END)
	RETURN isnull(@pnDonGia, 0)
END
GO

IF OBJECT_ID('[dbo].[sfCreateTable_OccupiedFunctionRoom]') IS NOT NULL DROP FUNCTION [dbo].[sfCreateTable_OccupiedFunctionRoom]
GO
-- Create 07/09/2007

CREATE FUNCTION sfCreateTable_OccupiedFunctionRoom
(
	@pdFromDate smalldatetime,
	@pdToDate smalldatetime
)  
RETURNS TABLE 
AS  
RETURN (
	SELECT  lk.fcOrderNo, p.fcLoaiPhong
	, dbo.sfIs_Weekend (lk.fdEventDate) AS IS_WEEKEND
--	, lk.fdEventDate, convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut,  
	, dbo.GetNames_BEO( '', '', rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, p.fcLoaiPhong ) as fcFunctionCode
	, dbo.sfGet_No_ofRms_ACTUAL (lk.fcOrderNo, p.fcLoaiPhong, rst.fdTimeIn, rst.fdTimeOut) as fnCountRms 
	, (CASE WHEN dbo.sfIs_Weekend (lk.fdEventDate)= 1 THEN cast (datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as decimal) / 60  +  1  END ) as fnSoGioDat_TTe_WE 
	, (CASE WHEN dbo.sfIs_Weekend (lk.fdEventDate)= 0 THEN cast (datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as decimal) / 60  +  1  END ) as fnSoGioDat_TTe_WD
	, (CASE WHEN dbo.sfIs_Weekend (lk.fdEventDate)= 1 THEN isnull(sum(case when lk.fcTrangThai  = 'D' then fnAmount else 0 end ),0)  -   cast(  isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lk.fcTrangThai ='D' then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)  as decimal)  END ) as fnDEF_BQ_Rev_TTe_WE 
	, (CASE WHEN dbo.sfIs_Weekend (lk.fdEventDate)= 0 THEN isnull(sum(case when lk.fcTrangThai  = 'D' then fnAmount else 0 end ),0)  -   cast(  isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lk.fcTrangThai ='D' then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)  as decimal)  END ) as fnDEF_BQ_Rev_TTe_WD
--	, isnull(sum(case when lk.fcTrangThai  = 'D' then lkdt.fnAmount else 0 end ),0) as  fnDEF_Rev
--	, isnull(sum(case when lk.fcTrangThai  = 'D' then fnAmount else 0 end ),0)  -   cast(  isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lk.fcTrangThai ='D' then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)  as decimal)   as  fnDEF_BQ_Rev_TTe
	FROM stMaster_EO ms 
		left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
		left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
		left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
		left  join stPhong p on p.fcMa= rst.fcRoom
	WHERE ( lk.fcTrangThai ='D' ) 
		and (lk.fdEventDate between @pdFromDate and @pdToDate )
	GROUP BY lk.fcOrderNo, p.fcLoaiPhong, rst.fdTimeIn, rst.fdTimeOut, lk.fdEventDate
	HAVING not (p.fcLoaiPhong  in('08', '09') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0)
)
GO

IF OBJECT_ID('[dbo].[sfDsachPhong_chuaCharges]') IS NOT NULL DROP FUNCTION [dbo].[sfDsachPhong_chuaCharges]
GO
CREATE FUNCTION dbo.sfDsachPhong_chuaCharges	-- chi xet trong booking - DUNG CHO FORECAST (ON THE BOOK)
(
	@pdFromDate smalldatetime,
	@pdToDate smalldatetime

)
RETURNS TABLE
AS
RETURN (
	SELECT  bk.fcBookid, bf.fdDate, convert( nvarchar(10), bf.fdDate , 6) as fcFunctionDate
	, dbo.sfGetFunctionType  ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, p.fcLoaiPhong ) as fcFunctionType 
	, bk.fcStatus_BkRoom as fcStatus
	, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson 
	, p.fcLoaiPhong
	, dbo.GetNames_Booking('', '', bf.fdTimeIn, bf.fdTimeOut,  bk.fcBookID, p.fcLoaiPhong ) as fcFunctionRoom_Code
	, dbo.fDefind( dbo.GetNames_Booking ( '', '', bf.fdTimeIn, bf.fdTimeOut,bk.fcBookID, p.fcLoaiPhong )) as fcFunctionRoom
	, isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015') then bc.fnQuantity else 0 end ),0) as fnGUA
	, bk.fnEXP 
	, convert( nvarchar(5), bf.fdTimeIn, 8)   as fcTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fcTimeOut 
	, cast ( datediff (mi, bf.fdTimeIn, bf.fdTimeOut) as decimal) / 60  as fnSoGioDat
	, bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
	, isnull (sum(case when bk.fcStatus_BkRoom  <> 'C' then fnAmount else 0 end ),0) as  fnDEF_TEN_Rev
	, isnull (sum(case when bk.fcStatus_BkRoom  <> 'C' then  fnAmount   else 0 end ),0)  - cast(  isnull (sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom <>'C' then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)  as decimal )  as  fnDEF_TEN_BQ_Rev
	FROM stbOOKING bk
		left join stKhachHang kh on kh.fcMa= bk.fcGuestID		
		left  join stBookFunctionRoom bf on bk.fcBookid = bf.fcBookid
		left join stSukien sk on sk.fcMa= bf.fcFunctionType
		left  join stBooking_Charges bc on bf.fcBookid = bc.fcBookid and  bf.fnCodeID = bc.fnCodeID
		left  join stPhong p on p.fcMa= bf.fcFunctionRoom
	WHERE ( bk.fcStatus_BkRoom <> 'C' )  and ( bf.fdDate between   @pdFromDate and  @pdToDate )

	GROUP BY bk.fcBookid, bf.fdDate, p.fcLoaiPhong, kh.fcMa, kh.fcTen, kh.fcMaNLH, bk.fcContactPerson
	, bk.fcStatus_BkRoom, bk.fnEXP, bk.fcUser , bk.fdDate , bk.fdDateConfirm 
	, bf.fdTimeIn, bf.fdTimeOut

	HAVING not (p.fcLoaiPhong  in('08', '09')  and isnull(sum(bc.fnQuantity), 0 )  <= 0) 
	AND isnull (sum(case when bk.fcStatus_BkRoom  <> 'C' then fnAmount else 0 end ),0)  =  0
	

)
GO

-- Stub tables for legacy views binding
IF OBJECT_ID('[dbo].[stSK_Loai]') IS NULL 
CREATE TABLE [dbo].[stSK_Loai] ([fcMa] nvarchar(20) NOT NULL PRIMARY KEY, [fcTen] nvarchar(100) NULL);
GO
IF OBJECT_ID('[dbo].[stDays]') IS NULL 
CREATE TABLE [dbo].[stDays] ([1] nvarchar(50) NULL);
GO

IF OBJECT_ID('[dbo].[vwKhachHang]', 'V') IS NOT NULL DROP VIEW [dbo].[vwKhachHang]
GO
CREATE VIEW dbo.vwKhachHang
AS
SELECT     *
FROM         dbo.stKhachHang
GO

IF OBJECT_ID('[dbo].[vwPhong]', 'V') IS NOT NULL DROP VIEW [dbo].[vwPhong]
GO
CREATE VIEW dbo.vwPhong
AS
SELECT     *
FROM         dbo.stPhong
GO

IF OBJECT_ID('[dbo].[vwSKLK]', 'V') IS NOT NULL DROP VIEW [dbo].[vwSKLK]
GO
CREATE VIEW dbo.vwSKLK
AS
SELECT     *
FROM         dbo.stSKLK
GO

IF OBJECT_ID('[dbo].[vwDoanhThu]', 'V') IS NOT NULL DROP VIEW [dbo].[vwDoanhThu]
GO
CREATE VIEW dbo.vwDoanhThu
AS
SELECT     *
FROM         dbo.stDoanhThu
GO

IF OBJECT_ID('[dbo].[vwPhuongThucThanhToan]', 'V') IS NOT NULL DROP VIEW [dbo].[vwPhuongThucThanhToan]
GO
CREATE VIEW dbo.vwPhuongThucThanhToan
AS
SELECT     dbo.stPTThanhToan.*
FROM         dbo.stPTThanhToan
GO

IF OBJECT_ID('[dbo].[vwTienTe]', 'V') IS NOT NULL DROP VIEW [dbo].[vwTienTe]
GO
CREATE VIEW dbo.vwTienTe
AS
SELECT     *
FROM         dbo.stTienTe
GO

IF OBJECT_ID('[dbo].[vwTyGia]', 'V') IS NOT NULL DROP VIEW [dbo].[vwTyGia]
GO
CREATE VIEW dbo.vwTyGia
AS
SELECT     *
FROM         dbo.stTyGia
GO

IF OBJECT_ID('[dbo].[vwSK_Loai]', 'V') IS NOT NULL DROP VIEW [dbo].[vwSK_Loai]
GO
CREATE VIEW dbo.vwSK_Loai
AS
SELECT     *
FROM         dbo.stSK_Loai
GO

IF OBJECT_ID('[dbo].[charges]', 'V') IS NOT NULL DROP VIEW [dbo].[charges]
GO
CREATE VIEW dbo.charges
AS
SELECT     fcBookID AS EventID, 'EONo' AS EONo, fnAmount AS ChargeAmt
FROM         dbo.stBooking_Charges
GO

IF OBJECT_ID('[dbo].[customers]', 'V') IS NOT NULL DROP VIEW [dbo].[customers]
GO
CREATE VIEW dbo.customers
AS
SELECT     fcMa AS CustomerID, fcTen AS CompanyName
FROM         dbo.stKhachHang
GO

IF OBJECT_ID('[dbo].[events]', 'V') IS NOT NULL DROP VIEW [dbo].[events]
GO
CREATE VIEW dbo.events
AS
SELECT     dbo.stBooking.fcBookID AS EventID, dbo.stBooking.fcGuestID AS CustomerID, eventname.EventName, dbo.stBooking_MICE.fdCheckIn AS StartDate, 
                      dbo.stBooking_MICE.fdCheckOut AS EndDate, dbo.stBooking_MICE.fnNo_Of_Room AS Rooms, dbo.stBooking_MICE.fnRevenue AS RmSales, 
                      dbo.stBooking.fcStatus_BkRoom AS StatusID, dbo.stBooking.fcNote AS CancelReason
FROM         dbo.stBooking LEFT OUTER JOIN
                      dbo.stBooking_MICE ON dbo.stBooking.fcBookID = dbo.stBooking_MICE.fcBookID INNER JOIN
                          (SELECT DISTINCT dbo.stBookFunctionRoom.fcBookID AS EventID, dbo.stSuKien.fcTen AS EventName
                            FROM          dbo.stSuKien INNER JOIN
                                                   dbo.stBookFunctionRoom ON dbo.stSuKien.fcMa = dbo.stBookFunctionRoom.fcFunctionType) eventname ON 
                      dbo.stBooking.fcBookID = eventname.EventID
GO

IF OBJECT_ID('[dbo].[EventSetup]', 'V') IS NOT NULL DROP VIEW [dbo].[EventSetup]
GO
create view EventSetup as SELECT     fcBookID AS EventID, 'EONo' AS EONo, fcFunctionRoom AS LocationID, fdDate AS EventDate, 
	CASE WHEN datepart(hour, fdTimeIn) < 10 THEN '0' ELSE '' END + rtrim(ltrim(CONVERT(char(2), datepart(hour, fdTimeIn)))) + CASE WHEN datepart(minute, fdTimeIn) < 10 THEN '0' ELSE '' END + rtrim(ltrim(CONVERT(char(2), datepart(minute, fdTimeIn)))) AS StartTime,
	CASE WHEN datepart(hour, fdTimeOut) < 10 THEN '0' ELSE '' END + rtrim(ltrim(CONVERT(char(2), datepart(hour, fdTimeOut)))) + CASE WHEN datepart(minute, fdTimeOut) < 10 THEN '0' ELSE '' END + rtrim(ltrim(CONVERT(char(2), datepart(minute, fdTimeOut)))) AS EndTime
FROM         dbo.stBookFunctionRoom
GO

IF OBJECT_ID('[dbo].[locations]', 'V') IS NOT NULL DROP VIEW [dbo].[locations]
GO
CREATE VIEW dbo.locations
AS
SELECT     fcMa AS LocationID, fcTen AS Location
FROM         dbo.stPhong
GO

IF OBJECT_ID('[dbo].[status]', 'V') IS NOT NULL DROP VIEW [dbo].[status]
GO
CREATE VIEW dbo.status
AS
SELECT     fcCode AS StatusID, fcName AS Status
FROM         dbo.stBooking_Status
GO

IF OBJECT_ID('[dbo].[view_salesofmonth_tmp]', 'V') IS NOT NULL DROP VIEW [dbo].[view_salesofmonth_tmp]
GO
CREATE VIEW dbo.view_salesofmonth_tmp
AS
select *
from
(select a.fcbookid,a.fncodeid,c.fcTen,a.fddate,a.fdtimein,a.fdtimeout ,
isnull((select  dbo.sfTinhDonGia_1Room( isnull(sum(fnamount),0)  -   cast(  isnull(sum(case when fnBreakDownLunch = 1 then fnQuantity*fnLunchPrice else 0 end), 0)  as decimal) , dbo.sfGet_No_ofRms(a.fcBookid,a.fdTimeIn, a.fdTimeOut) )
from stbooking_charges where stbooking_charges.fcbookid=a.fcbookid 
and a.fdtimein in(select fdtimein from stbooking_charges a inner join stbookfunctionroom b on a.fcbookid=b.fcbookid and a.fncodeid=b.fncodeid )
and a.fdtimeout in(select fdtimeout from stbooking_charges a inner join stbookfunctionroom b on a.fcbookid=b.fcbookid and a.fncodeid=b.fncodeid )
group by fcbookid),0)as fnamount 
from stbookfunctionroom a inner join stbooking b on a.fcbookid=b.fcbookid inner join stPhong c on a.fcfunctionroom=c.fcMa
where b.fcstatus_bkroom  not in ('C')
)a
GO

IF OBJECT_ID('[dbo].[view_tbFilterRight]', 'V') IS NOT NULL DROP VIEW [dbo].[view_tbFilterRight]
GO
CREATE VIEW dbo.view_tbFilterRightPO
AS
SELECT     *
FROM         (SELECT     stAccess.*, fcUserName
                       FROM          stAccess INNER JOIN
                                              stUserGroup ON stAccess.fcGroupCode = stUserGroup.fcGroupCode) a
WHERE     (fcMenu = 0) OR
                      (fcInsert = 0) OR
                      (fcDelete = 0) OR
                      (fcUpdate = 0) OR
                      (fcExport = 0)
GO

IF OBJECT_ID('[dbo].[view_tbUpdateRight]', 'V') IS NOT NULL DROP VIEW [dbo].[view_tbUpdateRight]
GO
CREATE VIEW dbo.view_tbUpdateRight
AS
SELECT     dbo.stAccess.*, dbo.stUserGroup.fcOwner AS fcOwner
FROM         dbo.stAccess INNER JOIN
                      dbo.stUserGroup ON dbo.stAccess.fcGroupCode = dbo.stUserGroup.fcGroupCode
GO

IF OBJECT_ID('[dbo].[vw_MICEReport]', 'V') IS NOT NULL DROP VIEW [dbo].[vw_MICEReport]
GO
CREATE VIEW dbo.vw_MICEReport
AS
SELECT     l.*, d.*
FROM        stSKLK l left join stDays d on l.fcOrderNo = d.[1]
GO

IF OBJECT_ID('[dbo].[vwKhachHang_Loai]', 'V') IS NOT NULL DROP VIEW [dbo].[vwKhachHang_Loai]
GO
CREATE VIEW dbo.vwKhachHang_Loai
AS
SELECT     *
FROM         dbo.stKhachHang_Loai
GO

IF OBJECT_ID('[dbo].[vwPhong_Loai]', 'V') IS NOT NULL DROP VIEW [dbo].[vwPhong_Loai]
GO
CREATE VIEW dbo.vwPhong_Loai
AS
SELECT     *
FROM         dbo.stPhong_Loai
GO

IF OBJECT_ID('[dbo].[sp_ACTUAL_OCCUPIED_FunctionRoom]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_ACTUAL_OCCUPIED_FunctionRoom]
GO
-- Update 07/09/2007:
-- NOTE: QUY TAC TINH TIEN: Khi KH dat tiec tai 3 phong MK1_2_3 trong cung Functiondate, TimeIn, timeOut ma chi charge tien cho Function MK1 
-- thi so tien se duoc chia deu cho ca 3 phong MK1, MK2, MK3

CREATE PROCEDURE dbo.sp_ACTUAL_OCCUPIED_FunctionRoom
(
	@pcFromDate NVARCHAR(10), 
	@pcToDate NVARCHAR(10), 
	@pcLoaiPhong NVARCHAR(20) = '', 
	@pcPhong NVARCHAR(20) = ''
)
 AS

--SET DATEFIRST 7  
--set dateformat dmy
set dateformat mdy
DECLARE @pdFromDate smalldatetime,  @pdToDate smalldatetime
set @pdFromDate = cast ( @pcFromDate  as  smalldatetime)
set @pdToDate = cast ( @pcToDate  as  smalldatetime)



SELECT  fcLoaiPhong, fcFunctionCode, dbo.fDefind(fcFunctionCode) as fcFunctionRoom, fnCountRms
	, SUM ( isnull ( fnSoGioDat_TTe_WD, 0) ) as fnSoGioDat_TTe_WD
	, SUM ( isnull ( fnSoGioDat_TTe_WE, 0 ) ) as fnSoGioDat_TTe_WE 
	, SUM ( isnull ( fnDEF_BQ_Rev_TTe_WD, 0 ) )  as fnDEF_BQ_Rev_TTe_WD -- tong tien cua fcFunctionRoom  trong cac ngay weekday
	, SUM ( isnull ( fnDEF_BQ_Rev_TTe_WE, 0 )  )  as fnDEF_BQ_Rev_TTe_WE -- tong tien cua fcFunctionRoom trong cac ngay weekend
	, dbo.sfTinhDonGia_1Room( SUM ( isnull ( fnDEF_BQ_Rev_TTe_WD, 0 )  )  , fnCountRms) as fnAmount_1Room_TTe_WD  -- tinh tien phong thuc te cua 1 phong @pcPhong trong cac ngay weekday
	, dbo.sfTinhDonGia_1Room( SUM ( isnull ( fnDEF_BQ_Rev_TTe_WE, 0 ) )  , fnCountRms) as fnAmount_1Room_TTe_WE    -- tinh tien phong thuc te cua 1 phong @pcPhong trong cac ngay weekend

FROM sfCreateTable_OccupiedFunctionRoom (@pdFromDate, @pdToDate)
WHERE (@pcLoaiPhong ='' OR fcLoaiPhong = @pcLoaiPhong) AND (@pcPhong ='' OR fcFunctionCode LIKE '%' + @pcPhong + '%')
GROUP BY  fcLoaiPhong, fcFunctionCode, fnCountRms
GO

IF OBJECT_ID('[dbo].[sp_ALLOW_OCCUPIED_FunctionRoom]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_ALLOW_OCCUPIED_FunctionRoom]
GO
-- Update 07/09/2007
-- NOTE: WD: Weekday, WE: Weekend
CREATE PROCEDURE dbo.sp_ALLOW_OCCUPIED_FunctionRoom 
(
	@pcFromDate nvarchar(10),
	@pcToDate nvarchar(10)
)
AS
--set dateformat dmy
set dateformat mdy
declare 	@pdFromDate as smalldatetime
declare 	@pdToDate as smalldatetime
set 	@pdFromDate = cast ( @pcFromDate as smalldatetime)
set 	@pdToDate  = cast ( @pcToDate  as smalldatetime)

declare @nMaxHours int -- so gio Booking toi da cua mot functionRoom/1ngay
set @nMaxHours = (select cast(fcValues as int)  from stValidBooking where fcID = '011')

declare  @nNoDays_WD int
declare @nNoDays_WE int 
set @nNoDays_WE = ( select  dbo.sfGetNumDays_Weekend(@pdFromDate, @pdToDate) )
set @nNoDays_WD = datediff( dd, @pdFromDate, @pdToDate)  + 1  -  @nNoDays_WE

SELECT  fcLoaiPhong, fcMa, fcTen as fcRoomName, fnGia 
, CAST (@nMaxHours* @nNoDays_WD AS DECIMAL(12, 2) ) as fnAllow_Hours_WD
, CAST( @nMaxHours* @nNoDays_WE as decimal ) AS fnAllow_Hours_WE
, dbo.sfGetAmount_ALLOW_WEEKDAY ( @pdFromDate , @pdToDate, fcMa)   as fnAllow_Amount_WD 
, dbo.sfGetAmount_ALLOW_WEEKEND ( @pdFromDate, @pdToDate,  fcMa)  AS fnAllow_Amount_WE

, CAST ( 0 as decimal ) AS fnActual_Hours_WD,  CAST( 0 as decimal ) AS fnActual_Hours_WE
, CAST ( 0  as decimal ) AS fnActual_Amount_WD, CAST( 0  as decimal ) AS fnActual_Amount_WE
, CAST ( 0  as decimal ) AS fnPercent_Hour_WD,  CAST( 0 as decimal ) AS fnPercent_Hour_WE
, CAST ( 0 as decimal ) AS fnPercent_Amount_WD, CAST ( 0 as decimal ) AS fnPercent_Amount_WE
FROM  stPhong
GO

IF OBJECT_ID('[dbo].[sp_ALLOW_OCCUPIED_FunctionRoom_Chart]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_ALLOW_OCCUPIED_FunctionRoom_Chart]
GO
CREATE PROCEDURE dbo.sp_ALLOW_OCCUPIED_FunctionRoom_Chart 
AS

SELECT  fcLoaiPhong, fcMa, fcTen as fcRoomName,
'Hour_WD' as fcHour,CAST ( 0 as decimal ) AS fnActual_Hours,
'Amount_WD' as fcAmount, CAST ( 0 as decimal ) AS fnActual_Amount
FROM  stPhong
union
SELECT  fcLoaiPhong, fcMa, fcTen as fcRoomName, 
'Hour_WE' as fcHour,CAST ( 0 as decimal ) AS fnActual_Hours,
'Amount_WE' as fcAmount, CAST ( 0 as decimal ) AS fnActual_Amount

FROM  stPhong
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual]
GO
-- Update 07/09/2007 -- update Weekday, Weekend
-- update 09/08/2007 - update Contactperson
CREATE PROCEDURE sp_Banquet_Actual
(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)


SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as decimal) / 60  +  1  as fnSoGioDat_TTe,  
dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,

isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014', '015') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
isnull(sum(case when dt.fcgroup in('01')  then lkdt.fnPrice else 0 end ),0)   as fnFood_Price,
isnull(sum(case when dt.fcgroup in('01') then lkdt.fnAmount else 0 end ),0)   as fnFood_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
isnull(sum(case when dt.fcgroup  in('03') then lkdt.fnAmount else 0 end), 0)   as fnMICS_Revenue,
isnull(sum(case when lk.fcTrangThai  = 'D' then   lkdt.fnAmount    else 0 end ),0)  as  fnDEF_Rev, 
isnull(sum(case when lk.fcTrangThai in('P') then  lkdt.fnAmount   else 0 end ),0)   as  fnTEN_Rev,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD,
--isnull(sum(case when lk.fcTrangThai  = 'D' then  fnAmount  else 0 end ),0)    -    isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lk.fcTrangThai ='D' then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)       as  fnDEF_BQ_Rev,
--isnull(sum(case when lk.fcTrangThai  in( 'P') then fnAmount else 0 end ),0)  -  isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lk.fcTrangThai in( 'P')then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)  as  fnTEN_BQ_Rev


isnull(sum(case when lk.fcTrangThai  = 'D' then  fnAmount  else 0 end ),0)    -   cast(  isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lk.fcTrangThai ='D' then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)  as decimal  )      as  fnDEF_BQ_Rev,
isnull(sum(case when lk.fcTrangThai  in('P') then fnAmount else 0 end ),0)  - cast(  isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lk.fcTrangThai in('P')then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as decimal  )   as  fnTEN_BQ_Rev

FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut
HAVING not (pl.fcMa  in('08', '09') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0)
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_By_Campaign_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_By_Campaign_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Actual_By_Campaign_Ngoc]
(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)
select c.fcCampaignName as fcCampaign
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
, isnull(fcOther_Status, 0) as fcOther_Status
, (case when isnull(fnTotal, 0) <> 0 then cast(isnull(fnWedding_Rev, 0) as numeric(18,4)) / cast(isnull(fnTotal, 0) as numeric(18,4)) else 0 end) as fnWeddingPercent
, (case when isnull(fnTotal, 0) <> 0 then cast(isnull(fnEvent_Rev, 0) as numeric(18,4)) / cast(isnull(fnTotal, 0) as numeric(18,4)) else 0 end) as fnEventPercent
from stCampaign c left join
(
select fcCampaign, 
		count(fcOrderNo) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 0 else fnTOTAL_Rev end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		count(case when fcStatus_1 in ('C', 'D') then null else 1 end) as fcOther_Status,
		(case when count(fcOrderNo) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,2)) / count(fcOrderNo)   as numeric(18,4)) else 0 end) as fnDefinitePercent
from (
SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
--dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
p.fcTen as fcFunctionRoom, -- ngoc them
lKH.fcNote as fcSourceBooking,  -- ngoc them source booking
lKH.fcName as fcSourceBookingCode, --ngoc them source code
lKH.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
lk.fcLyDo as fcNote, -- ngoc them remark
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15))+'/'+cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stKhachHang_Loai lKH on bk.fcLoaiKH=lKH.fcCode --ngoc them
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lKH.fcName --ngoc them
,lKH.fcGroup -- ngoc them source bookin group
, lKH.fcNote -- ngoc them source noet
, lk.fcLyDo -- ngoc them remark
, cp.fcCampaignName -- ngoc them campaign
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0) --ngoc bo
HAVING not isnull(sum(lkdt.fnQuantity), 0 )  <= 0
) actual
Group by actual.fcCampaign
) g
on c.fcCampaignName = g.fcCampaign
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_By_FunctionType_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_By_FunctionType_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Actual_By_FunctionType_Ngoc]
(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)
select sk.fcTen as fcFunctionType
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
from stSuKien sk left join
(
select fcFunctionType, 
		count(fcOrderNo) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType in ('Wedding') then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType not in ('Wedding') then fnTOTAL_Rev else 0 end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		(case when count(fcOrderNo) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,4)) / count(fcOrderNo)   as numeric(18,4)) else 0 end) as fnDefinitePercent
from (
SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
--dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
p.fcTen as fcFunctionRoom, -- ngoc them
lKH.fcNote as fcSourceBooking,  -- ngoc them source booking
lKH.fcName as fcSourceBookingCode, --ngoc them source code
lKH.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
lk.fcLyDo as fcNote, -- ngoc them remark
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15))+'/'+cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stKhachHang_Loai lKH on bk.fcLoaiKH=lKH.fcCode --ngoc them
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lKH.fcName --ngoc them
,lKH.fcGroup -- ngoc them source bookin group
, lKH.fcNote -- ngoc them source note
, lk.fcLyDo -- ngoc them remark
, cp.fcCampaignName -- ngoc them campaign
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0) --ngoc bo
HAVING not isnull(sum(lkdt.fnQuantity), 0 )  <= 0
) actual
Group by actual.fcFunctionType
) functionTypeGroup
on sk.fcTen = functionTypeGroup.fcFunctionType
where sk.fcMa <> '00'
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_By_FunctionType_Ngoc_New]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_By_FunctionType_Ngoc_New]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Actual_By_FunctionType_Ngoc_New]
(
	@pNam int ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = datefromparts(@pNam, 1 ,1)
select @DenNgay = datefromparts(@pNam, 12 , 31)

declare @functionName NVARCHAR(200)
DECLARE @dynamicstr NVARCHAR(300)
SELECT fcTen INTO #tempfunctionTypes FROM stSukien where fcMa <> '00'
SELECT case when number = 1 then 'January' 
			when number = 2 then 'February' 
			when number = 3 then 'March'
			when number = 4 then 'April'
			when number = 5 then 'May'
			when number = 6 then 'June'
			when number = 7 then 'July'
			when number = 8 then 'August'
			when number = 9 then 'September'
			when number = 10 then 'October'
			when number = 11 then 'November'
			when number = 12 then 'December'
		end as fcMonth
INTO #returnTable

FROM master..spt_values as m
WHERE Type = 'P' and number between 1 and 12
order by m.number

SELECT case when number = 1 then 'January' 
			when number = 2 then 'February' 
			when number = 3 then 'March'
			when number = 4 then 'April'
			when number = 5 then 'May'
			when number = 6 then 'June'
			when number = 7 then 'July'
			when number = 8 then 'August'
			when number = 9 then 'September'
			when number = 10 then 'October'
			when number = 11 then 'November'
			when number = 12 then 'December'
		end as fcMonth
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, fcFunctionType

into #tempTable

FROM master..spt_values as m

left join 
(
select sk.fcTen as fcFunctionType
, fcMonth
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
from stSuKien sk left join
(
select fcFunctionType, 
	datepart(MONTH, actual.fdFunctionDate) as fcMonth,
		count(fcOrderNo) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal
from (
SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
--dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
p.fcTen as fcFunctionRoom, -- ngoc them
lKH.fcNote as fcSourceBooking,  -- ngoc them source booking
lKH.fcName as fcSourceBookingCode, --ngoc them source code
lKH.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
lk.fcLyDo as fcNote, -- ngoc them remark
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15))+'/'+cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stKhachHang_Loai lKH on bk.fcLoaiKH=lKH.fcCode --ngoc them
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lKH.fcName --ngoc them
,lKH.fcGroup -- ngoc them source bookin group
, lKH.fcNote -- ngoc them source note
, lk.fcLyDo -- ngoc them remark
, cp.fcCampaignName -- ngoc them campaign
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0) --ngoc bo
HAVING not isnull(sum(lkdt.fnQuantity), 0 )  <= 0
) actual
Group by actual.fcFunctionType, datepart(MONTH, actual.fdFunctionDate)
) functionTypeGroup
on sk.fcTen = functionTypeGroup.fcFunctionType
where sk.fcMa <> '00'
) g


on m.number = g.fcMonth
WHERE Type = 'P' and number between 1 and 12
order by m.number

WHILE((SELECT COUNT(*) FROM #tempfunctionTypes)>0)

BEGIN
	SET @functionName = (SELECT TOP 1 fcTen FROM #tempfunctionTypes)
	SET @dynamicstr = 'ALTER TABLE #returnTable ADD [' + @functionName + '] numeric(18, 2) DEFAULT (0)'
	EXEC sp_executesql @dynamicstr	
	SET @dynamicstr = 'update  #returnTable  set [' + @functionName + '] = ' + 'isnull((SELECT fnTotal FROM #tempTable where #returnTable.fcMonth=fcMonth AND fcFunctionType=''' + @functionName + '''), 0)'  
	EXEC sp_executesql @dynamicstr
	delete FROM #tempfunctionTypes WHERE fcTen = @functionName
END
SELECT * FROM #returnTable
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_By_Month_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_By_Month_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Actual_By_Month_Ngoc]
(
	@pNam int ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = datefromparts(@pNam, 1 ,1)
select @DenNgay = datefromparts(@pNam, 12 , 31)
-- lay 12 thang
SELECT number as fcMonth
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
, (case when isnull(fnTotal, 0) <> 0 then cast(isnull(fnWedding_Rev, 0) as numeric(18,4)) / cast(isnull(fnTotal, 0) as numeric(18,4)) else 0 end) as fnWeddingPercent
, (case when isnull(fnTotal, 0) <> 0 then cast(isnull(fnEvent_Rev, 0) as numeric(18,4)) / cast(isnull(fnTotal, 0) as numeric(18,4)) else 0 end) as fnEventPercent
FROM master..spt_values as m
--
left join (
select datepart(MONTH, actual.fdFunctionDate) as fcMonth, 
		count(fcOrderNo) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType in ('Wedding') then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType not in ('Wedding') then fnTOTAL_Rev else 0 end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		(case when count(fcOrderNo) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,2)) / count(fcOrderNo)   as numeric(18,4)) else 0 end) as fnDefinitePercent
from (
SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
--dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
p.fcTen as fcFunctionRoom, -- ngoc them
lKH.fcNote as fcSourceBooking,  -- ngoc them source booking
lKH.fcName as fcSourceBookingCode, --ngoc them source code
lKH.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
lk.fcLyDo as fcNote, -- ngoc them remark
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15))+'/'+cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stKhachHang_Loai lKH on bk.fcLoaiKH=lKH.fcCode --ngoc them
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lKH.fcName --ngoc them
, lKH.fcNote -- ngoc them source note
,lKH.fcGroup -- ngoc them source bookin group
, lk.fcLyDo -- ngoc them remark
, cp.fcCampaignName -- ngoc them campaign
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0) --ngoc bo
HAVING not isnull(sum(lkdt.fnQuantity), 0 )  <= 0
) actual
Group by datepart(MONTH, actual.fdFunctionDate)
) g
on m.number = g.fcMonth
WHERE Type = 'P' and number between 1 and 12
order by m.number
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_By_PriceRange_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_By_PriceRange_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Actual_By_PriceRange_Ngoc]
(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)
SELECT number
, (case when number < 4 then (case when number = 0 then 'None' else '< 3,000,000' end) else concat(number - 1, ',000,000 - ', number, ',000,000') end) as fcPriceRange
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
FROM master..spt_values as m
--
left join (
select  
	--fnMenuPrice,
	(case when ceiling(actual.fnUnitPrice / 1000000) < 4 then (case when actual.fnUnitPrice = 0 then 0 else 3 end) else ceiling(actual.fnUnitPrice / 1000000) end) as num,
		count(fcOrderNo) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 0 else fnTOTAL_Rev end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		(case when count(fcOrderNo) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,4)) / count(fcOrderNo)   as numeric(18,2)) else 0 end) as fnDefinitePercent
from (
SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
--dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
p.fcTen as fcFunctionRoom, -- ngoc them
lKH.fcNote as fcSourceBooking,  -- ngoc them source booking
lKH.fcName as fcSourceBookingCode, --ngoc them source code
lKH.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
lk.fcLyDo as fcNote, -- ngoc them remark
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15))+'/'+cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
--ngoc them food unit price (unit price cho menu tung ban)
,(case when min(lkdt.fcDoanhThu_Type) in('01') then sum( case when lkdt.fcDoanhThu_Type = '01' then lkdt.fnPrice else 0 end) else 0 end) as fnMenuPrice_Old
--, (case when lkdt.fcDoanhThu_Type in('01') then 1 else 0 end) as isFood
-- ngoc them field fnMenuPrice
, lk.fnMenuPrice

, isnull( case when lk.fnMenuPrice > 0 then lk.fnMenuPrice else null end, case when ((kh.fcTen like '%wedding%' or sk.fcTen like '%wedding%' or sk.fcTen like '%(W)%') and cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ), 0) as numeric(18,2)) < 1000000) then sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ) * 10 else max(lkdt.fnPrice) end) as fnUnitPrice
----------------------------------------------------------
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stKhachHang_Loai lKH on bk.fcLoaiKH=lKH.fcCode --ngoc them
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lKH.fcName --ngoc them
, lKH.fcNote -- ngoc them source note
,lKH.fcGroup -- ngoc them source bookin group
, lk.fcLyDo -- ngoc them remark
, cp.fcCampaignName -- ngoc them 
, lk.fnMenuPrice -- ngoc them field fnMenuPrice
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0) --ngoc bo


HAVING not isnull(sum(lkdt.fnQuantity), 0 )  <= 0
) actual
--where actual.isFood = 1
--Group by (case when actual.fnMenuPrice < 3000000 then '< 3,000,000' else concat(floor(actual.fnMenuPrice / 1000000), ',000,000 - ', floor(actual.fnMenuPrice / 1000000)+1, ',000,000') end)
Group by (case when ceiling(actual.fnUnitPrice / 1000000) < 4 then (case when actual.fnUnitPrice = 0 then 0 else 3 end) else ceiling(actual.fnUnitPrice / 1000000) end)
) g
on m.number = g.num
WHERE Type = 'P' and number between 0 and 7 and number not in (1,2)
order by m.number
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_By_PriceRange_Ngoc_New]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_By_PriceRange_Ngoc_New]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Actual_By_PriceRange_Ngoc_New]
(
	@pNam int ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = datefromparts(@pNam, 1 ,1)
select @DenNgay = datefromparts(@pNam, 12 , 31)

declare @monthName NVARCHAR(200)
DECLARE @dynamicstr NVARCHAR(300)
-- lay 12 thang
SELECT (case when number < 4 then (case when number = 0 then 'None' else '< 3,000,000' end) else case when number < 8 then concat(number - 1, ',000,000 - ', number, ',000,000') else '> 7,000,000'  end end) as fcPriceRange
into #returnTable
FROM master..spt_values as m
WHERE Type = 'P' and number between 0 and 8 and number not in (1,2)

SELECT case when number = 1 then 'January' 
			when number = 2 then 'February' 
			when number = 3 then 'March'
			when number = 4 then 'April'
			when number = 5 then 'May'
			when number = 6 then 'June'
			when number = 7 then 'July'
			when number = 8 then 'August'
			when number = 9 then 'September'
			when number = 10 then 'October'
			when number = 11 then 'November'
			when number = 12 then 'December'
		end as fcMonth
INTO #tempMonthName

FROM master..spt_values as m
WHERE Type = 'P' and number between 1 and 12
order by m.number


SELECT number
, (case when number < 4 then (case when number = 0 then 'None' else '< 3,000,000' end) else case when number < 8 then concat(number - 1, ',000,000 - ', number, ',000,000') else '> 7,000,000'  end end) as fcPriceRange
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
, case when fcMonth = 1 then 'January' 
			when fcMonth = 2 then 'February' 
			when fcMonth = 3 then 'March'
			when fcMonth = 4 then 'April'
			when fcMonth = 5 then 'May'
			when fcMonth = 6 then 'June'
			when fcMonth = 7 then 'July'
			when fcMonth = 8 then 'August'
			when fcMonth = 9 then 'September'
			when fcMonth = 10 then 'October'
			when fcMonth = 11 then 'November'
			when fcMonth = 12 then 'December'
		end as fcMonth

into #tempTable
FROM master..spt_values as m
--
left join (
select  
	--fnMenuPrice,
	(case when ceiling(actual.fnUnitPrice / 1000000) < 4 then (case when actual.fnUnitPrice = 0 then 0 else 3 end) else case when ceiling(actual.fnUnitPrice / 1000000) > 8 then 8 else ceiling(actual.fnUnitPrice / 1000000) end end) as num,
	-- (case when ceiling(actual.fnUnitPrice / 1000000) < 4 then (case when actual.fnUnitPrice = 0 then 0 else 3 end) else ceiling(actual.fnUnitPrice / 1000000) end) as num,
	-- ngoc doi 2017 09 16
	 datepart(MONTH, actual.fdFunctionDate) as fcMonth,
		count(fcOrderNo) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 0 else fnTOTAL_Rev end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		(case when count(fcOrderNo) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,4)) / count(fcOrderNo)   as numeric(18,2)) else 0 end) as fnDefinitePercent
from (
SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
--dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
p.fcTen as fcFunctionRoom, -- ngoc them
lKH.fcNote as fcSourceBooking,  -- ngoc them source booking
lKH.fcName as fcSourceBookingCode, --ngoc them source code
lKH.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
lk.fcLyDo as fcNote, -- ngoc them remark
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15))+'/'+cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
--ngoc them food unit price (unit price cho menu tung ban)
,(case when min(lkdt.fcDoanhThu_Type) in('01') then sum( case when lkdt.fcDoanhThu_Type = '01' then lkdt.fnPrice else 0 end) else 0 end) as fnMenuPrice_Old
--, (case when lkdt.fcDoanhThu_Type in('01') then 1 else 0 end) as isFood
-- ngoc them field fnMenuPrice
, lk.fnMenuPrice

, isnull( case when lk.fnMenuPrice > 0 then lk.fnMenuPrice else null end, case when ((kh.fcTen like '%wedding%' or sk.fcTen like '%wedding%' or sk.fcTen like '%(W)%') and cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ), 0) as numeric(18,2)) < 1000000) then sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ) * 10 else max(lkdt.fnPrice) end) as fnUnitPrice
----------------------------------------------------------
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stKhachHang_Loai lKH on bk.fcLoaiKH=lKH.fcCode --ngoc them
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lKH.fcName --ngoc them
, lKH.fcNote -- ngoc them source note
,lKH.fcGroup -- ngoc them source bookin group
, lk.fcLyDo -- ngoc them remark
, cp.fcCampaignName -- ngoc them 
, lk.fnMenuPrice -- ngoc them field fnMenuPrice
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0) --ngoc bo


HAVING not isnull(sum(lkdt.fnQuantity), 0 )  <= 0
) actual
--where actual.isFood = 1
--Group by (case when actual.fnMenuPrice < 3000000 then '< 3,000,000' else concat(floor(actual.fnMenuPrice / 1000000), ',000,000 - ', floor(actual.fnMenuPrice / 1000000)+1, ',000,000') end)
where fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%'
Group by 
(case when ceiling(actual.fnUnitPrice / 1000000) < 4 then (case when actual.fnUnitPrice = 0 then 0 else 3 end) else case when ceiling(actual.fnUnitPrice / 1000000) > 8 then 8 else ceiling(actual.fnUnitPrice / 1000000) end end)
-- (case when ceiling(actual.fnUnitPrice / 1000000) < 4 then (case when actual.fnUnitPrice = 0 then 0 else 3 end) else ceiling(actual.fnUnitPrice / 1000000) end) -- ngoc doi 2017 09 16
,  datepart(MONTH, actual.fdFunctionDate)
) g
on m.number = g.num
WHERE Type = 'P' and number between 0 and 20 and number not in (1,2)
order by m.number


WHILE((SELECT COUNT(*) FROM #tempMonthName)>0)

BEGIN
	SET @monthName = (SELECT TOP 1 fcMonth FROM #tempMonthName)
	SET @dynamicstr = 'ALTER TABLE #returnTable ADD [' + @monthName + '] int DEFAULT (0)'
	EXEC sp_executesql @dynamicstr	
	SET @dynamicstr = 'update  #returnTable  set [' + @monthName + '] = ' + 'isnull((SELECT fnInquiries FROM #tempTable where #tempTable.fcPriceRange=#returnTable.fcPriceRange AND fcMonth=''' + @monthName + '''), 0)'  
	EXEC sp_executesql @dynamicstr
	delete FROM #tempMonthName WHERE fcMonth = @monthName
END
SELECT * FROM #returnTable
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_By_Source_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_By_Source_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Actual_By_Source_Ngoc]
(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)
select s.fcNote as fcSourceBooking,
s.fcGroup as fcSourceGroup
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fnWedding_Inquiry, 0) as fnWedding_Inquiry
, isnull(fnEvent_Inquiry, 0) as fnEvent_Inquiry
, isnull(fnWedding_D_Inquiry, 0) as fnWedding_D_Inquiry
, isnull(fnEvent_D_Inquiry, 0) as fnEvent_D_Inquiry
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
, isnull(fcOther_Status, 0) as fcOther_Status
, (case when isnull(fnTotal, 0) <> 0 then cast(isnull(fnWedding_Rev, 0) as numeric(18,4)) / cast(isnull(fnTotal, 0) as numeric(18,4)) else 0 end) as fnWeddingPercent
, (case when isnull(fnTotal, 0) <> 0 then cast(isnull(fnEvent_Rev, 0) as numeric(18,4)) / cast(isnull(fnTotal, 0) as numeric(18,4)) else 0 end) as fnEventPercent
, (case when isnull(fnWedding_D_Inquiry, 0) <> 0 then cast(isnull(fnWedding_Rev, 0) as numeric(18,4)) / cast( isnull(fnWedding_D_Inquiry, 0) as numeric(18,4)) else 0 end) as fnWedding_Average
, (case when isnull(fnEvent_D_Inquiry, 0) <> 0 then cast(isnull(fnEvent_Rev, 0) as numeric(18,4)) / cast( isnull(fnEvent_D_Inquiry, 0) as numeric(18,4)) else 0 end) as fnEvent_Average
from stKhachHang_Loai s left join
(
select isnull(fcSourceBooking, '') as fcSourceBooking, isnull(fcSourceGroup, '') as fcSourceGroup, 
  -- fcSourceBooking, fcSourceGroup, -- ngoc sua 2017 09 16
		count(fcOrderNo) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 0 else fnTOTAL_Rev end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') and (fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%') then 1 else null end) as fnWedding_D_Inquiry, 
		count(case when fcStatus_1 in ('D') and (fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%') then null else 1 end) as fnEvent_D_Inquiry, 
		count(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 1 else null end) as fnWedding_Inquiry, 
		count(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then null else 1 end) as fnEvent_Inquiry, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		count(case when fcStatus_1 in ('C', 'D') then null else 1 end) as fcOther_Status,
		(case when count(fcOrderNo) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,2)) / count(fcOrderNo)   as numeric(18,4)) else 0 end) as fnDefinitePercent

from (
SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
--dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
p.fcTen as fcFunctionRoom, -- ngoc them
lKH.fcNote as fcSourceBooking,  -- ngoc them source booking
lKH.fcName as fcSourceBookingCode, --ngoc them source code
lKH.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
lk.fcLyDo as fcNote, -- ngoc them remark
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15))+'/'+cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stKhachHang_Loai lKH on bk.fcLoaiKH=lKH.fcCode --ngoc them
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lKH.fcName --ngoc them
, lKH.fcNote -- ngoc them note
,lKH.fcGroup -- ngoc them source bookin group
, lk.fcLyDo -- ngoc them remark
, cp.fcCampaignName -- ngoc them campaign
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0) --ngoc bo
HAVING not isnull(sum(lkdt.fnQuantity), 0 )  <= 0
) actual
Group by actual.fcSourceBooking , actual.fcSourceGroup
) g
on s.fcNote = g.fcSourceBooking
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_By_TimeInterval_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_By_TimeInterval_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Actual_By_TimeInterval_Ngoc]
(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)
-- lay 12 thang
SELECT number as fnTimeInterval
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
FROM master..spt_values as m
--
left join (
select case when DATEDIFF(month, actual.fdDATE_RECEIVED, actual.fdFunctionDate) + (case when DATEPART(day, actual.fdDATE_RECEIVED) < datepart(day, actual.fdFunctionDate) then 0 else (-1) end) < 0 then 0 else DATEDIFF(month, actual.fdDATE_RECEIVED, actual.fdFunctionDate) + (case when DATEPART(day, actual.fdDATE_RECEIVED) < datepart(day, actual.fdFunctionDate) then 0 else (-1) end) end as fnTimeInterval,  
		count(fcOrderNo) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 0 else fnTOTAL_Rev end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		(case when count(fcOrderNo) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,4)) / count(fcOrderNo)   as numeric(18,4)) else 0 end) as fnDefinitePercent
from (
SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
--dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
p.fcTen as fcFunctionRoom, -- ngoc them
lKH.fcNote as fcSourceBooking,  -- ngoc them source booking
lKH.fcName as fcSourceBookingCode, --ngoc them source code
lKH.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
lk.fcLyDo as fcNote, -- ngoc them remark
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15))+'/'+cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stKhachHang_Loai lKH on bk.fcLoaiKH=lKH.fcCode --ngoc them
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lKH.fcName --ngoc them
,lKH.fcGroup -- ngoc them source bookin group,
, lKH.fcNote -- ngoc them note
, lk.fcLyDo -- ngoc them remark
, cp.fcCampaignName -- ngoc them campaign
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0) --ngoc bo
HAVING not isnull(sum(lkdt.fnQuantity), 0 )  <= 0
) actual
Group by case when DATEDIFF(month, actual.fdDATE_RECEIVED, actual.fdFunctionDate) + (case when DATEPART(day, actual.fdDATE_RECEIVED) < datepart(day, actual.fdFunctionDate) then 0 else (-1) end) < 0 then 0 else DATEDIFF(month, actual.fdDATE_RECEIVED, actual.fdFunctionDate) + (case when DATEPART(day, actual.fdDATE_RECEIVED) < datepart(day, actual.fdFunctionDate) then 0 else (-1) end) end

) g
on m.number = g.fnTimeInterval
WHERE Type = 'P' and number between 0 and 12
order by m.number
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_By_TimeInterval_Ngoc_New]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_By_TimeInterval_Ngoc_New]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Actual_By_TimeInterval_Ngoc_New]
(
	@pNam int ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = datefromparts(@pNam, 1 ,1)
select @DenNgay = datefromparts(@pNam, 12 , 31)

declare @timeInterval NVARCHAR(200)
DECLARE @dynamicstr NVARCHAR(300)
-- lay 12 thang

SELECT number
INTO #tempTimeInterval

FROM master..spt_values as m
WHERE Type = 'P' and number between 0 and 12
order by m.number

SELECT case when number = 1 then 'January' 
			when number = 2 then 'February' 
			when number = 3 then 'March'
			when number = 4 then 'April'
			when number = 5 then 'May'
			when number = 6 then 'June'
			when number = 7 then 'July'
			when number = 8 then 'August'
			when number = 9 then 'September'
			when number = 10 then 'October'
			when number = 11 then 'November'
			when number = 12 then 'December'
		end as fcMonth
INTO #returnTable

FROM master..spt_values as m
WHERE Type = 'P' and number between 1 and 12
order by m.number

SELECT 
	case when number = 1 then 'January' 
			when number = 2 then 'February' 
			when number = 3 then 'March'
			when number = 4 then 'April'
			when number = 5 then 'May'
			when number = 6 then 'June'
			when number = 7 then 'July'
			when number = 8 then 'August'
			when number = 9 then 'September'
			when number = 10 then 'October'
			when number = 11 then 'November'
			when number = 12 then 'December'
		end as fcMonth
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
, isnull(fnTimeInterval, 0) as fnTimeInterval

into #tempTable
FROM master..spt_values as m
--
left join (
select case when DATEDIFF(month, actual.fdDATE_RECEIVED, actual.fdFunctionDate) + (case when DATEPART(day, actual.fdDATE_RECEIVED) <= datepart(day, actual.fdFunctionDate) then 0 else (-1) end) < 0 then 0 else DATEDIFF(month, actual.fdDATE_RECEIVED, actual.fdFunctionDate) + (case when DATEPART(day, actual.fdDATE_RECEIVED) <= datepart(day, actual.fdFunctionDate) then 0 else (-1) end) end as fnTimeInterval,  
 datepart(MONTH, actual.fdFunctionDate) as fcMonth,
		count(fcOrderNo) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 0 else fnTOTAL_Rev end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		(case when count(fcOrderNo) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,4)) / count(fcOrderNo)   as numeric(18,4)) else 0 end) as fnDefinitePercent
from (
SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
--dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
p.fcTen as fcFunctionRoom, -- ngoc them
lKH.fcNote as fcSourceBooking,  -- ngoc them source booking
lKH.fcName as fcSourceBookingCode, --ngoc them source code
lKH.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
lk.fcLyDo as fcNote, -- ngoc them remark
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15))+'/'+cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stKhachHang_Loai lKH on bk.fcLoaiKH=lKH.fcCode --ngoc them
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lKH.fcName --ngoc them
,lKH.fcGroup -- ngoc them source bookin group,
, lKH.fcNote -- ngoc them note
, lk.fcLyDo -- ngoc them remark
, cp.fcCampaignName -- ngoc them campaign
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0) --ngoc bo
HAVING not isnull(sum(lkdt.fnQuantity), 0 )  <= 0
) actual
Group by case when DATEDIFF(month, actual.fdDATE_RECEIVED, actual.fdFunctionDate) + (case when DATEPART(day, actual.fdDATE_RECEIVED) <= datepart(day, actual.fdFunctionDate) then 0 else (-1) end) < 0 then 0 else DATEDIFF(month, actual.fdDATE_RECEIVED, actual.fdFunctionDate) + (case when DATEPART(day, actual.fdDATE_RECEIVED) <= datepart(day, actual.fdFunctionDate) then 0 else (-1) end) end
,  datepart(MONTH, actual.fdFunctionDate)

) g
on m.number = g.fcMonth
WHERE Type = 'P' and number between 1 and 12
order by m.number


WHILE((SELECT COUNT(*) FROM #tempTimeInterval)>0)

BEGIN
	SET @timeInterval = (SELECT TOP 1 number FROM #tempTimeInterval)
	SET @dynamicstr = 'ALTER TABLE #returnTable ADD [' + @timeInterval + '] int DEFAULT (0)'
	EXEC sp_executesql @dynamicstr	
	SET @dynamicstr = 'update  #returnTable  set [' + @timeInterval + '] = ' + 'isnull((SELECT fnInquiries FROM #tempTable where #returnTable.fcMonth=fcMonth AND fnTimeInterval=''' + @timeInterval + '''), 0)'  
	EXEC sp_executesql @dynamicstr
	delete FROM #tempTimeInterval WHERE number = @timeInterval
END
SELECT * FROM #returnTable
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_CT]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_CT]
GO
/****** Object:  Stored Procedure dbo.sp_Banquet_Actual_CT    Script Date: 01/19/2009 10:05:33 AM ******/
CREATE PROCEDURE sp_Banquet_Actual_CT
(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)


SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as decimal) / 60  +  1  as fnSoGioDat_TTe,  
dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case bk.fcBookID When m.fcBookID then 'Yes' else 'No' end) as fcMice,
isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
isnull(sum(case when dt.fcgroup in('01')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnFood_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnBF_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
isnull(sum(case when dt.fcgroup  in('03') then lkdt.fnAmount else 0 end), 0)   as fnMICS_Revenue,
isnull(sum(case when lk.fcTrangThai in('D','P') then fnAmount else 0 end ),0)-cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai in('D','P') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,m.fcBookID
HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0)
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_CT2812]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_CT2812]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Actual_CT2812]
(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)


SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as decimal) / 60  +  1  as fnSoGioDat_TTe,  
dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case bk.fcBookID When m.fcBookID then 'Yes' else 'No' end) as fcMice,
isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
isnull(sum(case when dt.fcgroup in('01')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnFood_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnBF_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013') then lkdt.fnQuantity*4
when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016') then lkdt.fnQuantity*8 else 0 end), 0) as fnF_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013') then lkdt.fnQuantity*2
when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016') then lkdt.fnQuantity*4 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
isnull(sum(case when dt.fcgroup  in('03') then lkdt.fnAmount else 0 end), 0)   as fnMICS_Revenue,
isnull(sum(case when lk.fcTrangThai in('D','P') then fnAmount else 0 end ),0)
-cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as decimal)
-cast(isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013') then lkdt.fnQuantity*4
when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016') then lkdt.fnQuantity*8 else 0 end), 0)as decimal)
- cast(isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013') then lkdt.fnQuantity*2
when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016') then lkdt.fnQuantity*4 else 0 end), 0)as decimal)
as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai in('D','P') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,m.fcBookID
HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0)
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_CT2812_new]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_CT2812_new]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Actual_CT2812_new]
(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)


SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15))+'/'+cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D','P') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D','P') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0)
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_CT2812_new_BySource]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_CT2812_new_BySource]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Actual_CT2812_new_BySource]
(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)

--kh.fcLoaiKhach as fcLoaiKhach, khLoai.fcName as fcLoaiKhachName, kh.fcLinhVuc as fcLinhVuc, khLinhVuc.fcName as fcLinhVucName,
--left join stLinhVuc khLinhVuc on khLinhVuc.fcCode = kh.fcLinhVuc
--left join stKhachHang_Loai khLoai on khLoai.fcCode = kh.fcLoaiKhach 

SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 11) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
kh.fcTen as fcOrganization, 
kh.fcLoaiKhach as fcLoaiKhach, khLoai.fcName as fcLoaiKhachName, kh.fcLinhVuc as fcLinhVuc, khLinhVuc.fcName as fcLinhVucName,
(case ms.fcContactPerson when '' then isnull((select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH),'') else ms.fcContactPerson end ) as fcContactPerson ,
--(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
ms.fcEndUser as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
--cast(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0) as int) as nvarchar(15)) +' / '+cast(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0) as int) as nvarchar(15)) as fnPacket_Price,
format(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0) ,'N0') +' / '+format(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0),'N0') as fnPacket_Price,
--isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when dt.fcgroup in('01') then lkdt.fnAmount else 0 end ),0) as fnBQT_BANQUET_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0) as fnBQT_BEVERAGE_Rev,
isnull(sum(case when dt.fcgroup in('03') then lkdt.fnAmount else 0 end ),0) as fnBQT_MISC_Rev,
isnull(sum(case when dt.fcgroup in('04') then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when dt.fcgroup in('05') then lkdt.fnAmount else 0 end ),0) as fnBQT_ROOM_Rev,
isnull(sum(case when dt.fcgroup in('06') then lkdt.fnAmount else 0 end ),0) as fnBQT_SEMINAR_Rev,
isnull(sum(case when dt.fcgroup in('01','02','03','04','06') then lkdt.fnAmount else 0 end ),0) as fnBQT_SUM_NoMice_Rev,
isnull(sum(lkdt.fnAmount),0) as fnBQT_Total_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D','P') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D','P') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stLinhVuc khLinhVuc on khLinhVuc.fcCode = kh.fcLinhVuc
left join stKhachHang_Loai khLoai on khLoai.fcCode = kh.fcLoaiKhach 
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai, ms.fcEndUser, lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa,kh.fcLoaiKhach, khLoai.fcName , kh.fcLinhVuc , khLinhVuc.fcName , kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0)
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Actual_CT2812_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Actual_CT2812_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Actual_CT2812_Ngoc]
(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)


SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
--dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
p.fcTen as fcFunctionRoom, -- ngoc them
lKH.fcNote as fcSourceBooking,  -- ngoc them source booking
lKH.fcName as fcSourceBookingCode, --ngoc them source code
lKH.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
lk.fcLyDo as fcNote, -- ngoc them remark
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15))+'/'+cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)) as fnPacket_Price,
--ngoc them unit price
isnull( case when lk.fnMenuPrice > 0 then lk.fnMenuPrice else null end, case when ((kh.fcTen like '%wedding%' or sk.fcTen like '%wedding%' or sk.fcTen like '%(W)%') and cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ), 0) as numeric(18,2)) < 1000000) then sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ) * 10 else max(lkdt.fnPrice) end) as fnUnitPrice, 
-----
isnull(sum(case when dt.fcgroup in('04')and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD,
-- ngoc them field fnMenuPrice
lk.fnMenuPrice
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stKhachHang_Loai lKH on bk.fcLoaiKH=lKH.fcCode --ngoc them
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lKH.fcName --ngoc them
,lKH.fcGroup -- ngoc them source bookin group
,lKH.fcNote -- ngoc them note
, lk.fcLyDo -- ngoc them remark
, cp.fcCampaignName -- ngoc them campaign
, lk.fnMenuPrice -- ngoc them field fnMenuPrice
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0) --ngoc bo
HAVING not isnull(sum(lkdt.fnQuantity), 0 )  <= 0
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Forecast_CT2812_new_BySource]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Forecast_CT2812_new_BySource]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Forecast_CT2812_new_BySource]
(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)

--kh.fcLoaiKhach as fcLoaiKhach, khLoai.fcName as fcLoaiKhachName, kh.fcLinhVuc as fcLinhVuc, khLinhVuc.fcName as fcLinhVucName,
--left join stLinhVuc khLinhVuc on khLinhVuc.fcCode = kh.fcLinhVuc
--left join stKhachHang_Loai khLoai on khLoai.fcCode = kh.fcLoaiKhach 

SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 11) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
kh.fcTen as fcOrganization, 
kh.fcLoaiKhach as fcLoaiKhach, khLoai.fcName as fcLoaiKhachName, kh.fcLinhVuc as fcLinhVuc, khLinhVuc.fcName as fcLinhVucName,
(case ms.fcContactPerson when '' then isnull((select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH),'') else ms.fcContactPerson end ) as fcContactPerson ,
--(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
ms.fcEndUser as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
--cast(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0) as int) as nvarchar(15)) +' / '+cast(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0) as int) as nvarchar(15)) as fnPacket_Price,
format(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0) ,'N0') +' / '+format(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0),'N0') as fnPacket_Price,
--isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when dt.fcgroup in('01') then lkdt.fnAmount else 0 end ),0) as fnBQT_BANQUET_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0) as fnBQT_BEVERAGE_Rev,
isnull(sum(case when dt.fcgroup in('03') then lkdt.fnAmount else 0 end ),0) as fnBQT_MISC_Rev,
isnull(sum(case when dt.fcgroup in('04') then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when dt.fcgroup in('05') then lkdt.fnAmount else 0 end ),0) as fnBQT_ROOM_Rev,
isnull(sum(case when dt.fcgroup in('06') then lkdt.fnAmount else 0 end ),0) as fnBQT_SEMINAR_Rev,
isnull(sum(case when dt.fcgroup in('01','02','03','04','06') then lkdt.fnAmount else 0 end ),0) as fnBQT_SUM_NoMice_Rev,
isnull(sum(lkdt.fnAmount),0) as fnBQT_Total_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D','P') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D','P') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stLinhVuc khLinhVuc on khLinhVuc.fcCode = kh.fcLinhVuc
left join stKhachHang_Loai khLoai on khLoai.fcCode = kh.fcLoaiKhach 
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 
GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai, ms.fcEndUser, lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa,kh.fcLoaiKhach, khLoai.fcName , kh.fcLinhVuc , khLinhVuc.fcName , kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0)
GO

IF OBJECT_ID('[dbo].[sp_Banquet_Revenue_By_Month_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Banquet_Revenue_By_Month_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_Banquet_Revenue_By_Month_Ngoc](
	@pNam int ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = datefromparts(@pNam, 1 ,1)
select @DenNgay = datefromparts(@pNam, 12 , 31)
-- lay 12 thang
SELECT case when number = 1 then 'January' 
			when number = 2 then 'February' 
			when number = 3 then 'March'
			when number = 4 then 'April'
			when number = 5 then 'May'
			when number = 6 then 'June'
			when number = 7 then 'July'
			when number = 8 then 'August'
			when number = 9 then 'September'
			when number = 10 then 'October'
			when number = 11 then 'November'
			when number = 12 then 'December'
		end as fcMonth,
isnull(fnForecastRevenue, 0) as fnForecastRevenue,
isnull(fnActualRevevue, 0) as fnActualRevenue

FROM master..spt_values as m

left join 
(
select forecastGroup.fcMonth as fcMonth,

-- case when 1 then 'January' when 2 then 'February' when 3 then 'March' when else 'December' end as fcMonth
forecastGroup.fnTotal as fnForecastRevenue,
actualGroup.fnTotal as fnActualRevevue
from 
(

(
select datepart(MONTH, actual.fdFunctionDate) as fcMonth, 
count(fcOrderNo) as fnInquiries,
sum(fnTOTAL_Rev) as fnTotal
from
(SELECT  ms.fcMaster_EO, lk.fcOrderNo, convert(nvarchar(10), lk.fdEventDate, 6) as fcFunctionDate, lk.fdEventDate as fdFunctionDate
, (case when dbo.sfIs_Weekend (lk.fdEventDate) = 1 then 'Yes' else 'No'  end) AS fcWeekend
,  pl.fcTen ,  ms.fcGuestCode, sk.fcTen as fcFunctionType, 
convert( nvarchar(5),  rst.fdTimeIn, 8)  as fdTimeIn, convert(nvarchar(5), rst.fdTimeOut , 8)  as fdTimeOut ,
(convert(nvarchar(10), lk.fdEventDate, 6)+' '+convert( nvarchar(5),  rst.fdTimeIn, 8)+' '+convert(nvarchar(5), rst.fdTimeOut , 8) )as fcDatetime,
cast ( datediff (mi, rst.fdTimeIn, rst.fdTimeOut) as float) / 60  +  1  as fnSoGioDat_TTe,  
--dbo.fDefind(dbo.GetNames_BEO(@TuNgay, @DenNgay, rst.fdTimeIn, rst.fdTimeOut , lk.fcOrderNo, pl.fcMa)) as fcFunctionRoom, 
p.fcTen as fcFunctionRoom, -- ngoc them
lKH.fcNote as fcSourceBooking,  -- ngoc them source booking
lKH.fcName as fcSourceBookingCode, --ngoc them source code
lKH.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
lk.fcLyDo as fcNote, -- ngoc them remark
kh.fcTen as fcOrganization, (case ms.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH) else ms.fcContactPerson end ) as fcContactPerson ,
(case when sum(cast(lkdt.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
(case when lk.fcTrangThai in ('T', 'A', 'P' ) then 'P'  else lk.fcTrangThai end )  as fcStatus_1, 
LTRIM(lk.fcEXP)  as fnEXP, lk.fcNguoiNhap as fcSP , bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--isnull(sum(case when lkdt.fcDoanhThu_Type in('01', '012' , '013' , '014','015','016','017') then lkdt.fnQuantity else 0 end ),0) as fnGUA,
ltrim(lk.fcGUA) as fnGUA,
--isnull(sum(case when dt.fcgroup in('04')  then lkdt.fnPrice else 0 end ),0)   as fnPacket_Price,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ))-2) as fnPacket_Price,
cast(isnull(sum(case when dt.fcgroup in('04') then lkdt.fnPrice else 0 end ),0)as nvarchar(15))+'/'+cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice else 0 end ),0)as nvarchar(15)) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and lkdt.fnBreakDownLunch  <> 1 then lkdt.fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as fnRS_Rev,
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0) as fnF_Rev,*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnPrice else 0 end ), 0)   as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0)  as fnBev_Revenue,
cast((
cast(isnull(sum(case when dt.fcgroup in('01') then lkdt.fnPrice*lkdt.fnQuantity else 0 end ),0)as float)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','015') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('013','016') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)as float)  as fnBQT_MICS,

/*cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*5
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,*/
cast(isnull(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*154000
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04') and lkdt.fnBreakDownLunch <> 1 then fnAmount else 0 end ),0)as float),0)as float) as fnTotal_F_Rev,

cast(isnull(cast(isnull(sum(case when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('012','013'))or lkdt.fcDoanhThu_Type in('014') then lkdt.fnQuantity*0
when (lkdt.fnBreakDownLunch = 1  and lkdt.fcDoanhThu_Type in('015','016'))or lkdt.fcDoanhThu_Type in('017') then lkdt.fnQuantity*0 else 0 end), 0)as float)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float),0)as float)as fnTotal_B_Rev,

isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when lk.fcTrangThai in('D') then fnAmount else 0 end ),0) -cast(isnull(sum(case when lkdt.fnBreakDownLunch=1 and lk.fcTrangThai in('D','P') then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end),0) as float) as fnBQ_Rev_Only,
isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0)    as  fnTOTAL_CXLD
FROM stMaster_EO ms 
left  join stBooking bk on ms.fcBookID = bk.fcBookID 
left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
INNER   join stPhong p on p.fcMa= rst.fcRoom  -- KHONG HIEN THI CAC EO_ID CHUA DUOC BOOK PHONG
left  join stPhong_Loai pL on p.fcLoaiPhong= pL.fcmA
left join stKhachHang kh on kh.fcMa= ms.fcGuestCode
left join stSuKien sk on sk.fcMa= lk.fcMaSK
left join stKhachHang_Loai lKH on bk.fcLoaiKH=lKH.fcCode --ngoc them
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( lk.fdEventDate  between @TuNgay and @DenNgay)  and lk.fcTrangThai not in ('R')   -- and (@pcUser = '' or  ms.fcNguoiLap = @pcUser) 

GROUP BY ms.fcMaster_EO,lk.fcOrderNo, ms.fcGuestCode, ms.fcContactPerson, sk.fcTen, lk.fcTrangThai,  lk.fcEXP,pl.fcMa, pl.fcTen, kh.fcTen, kh.fcMa, kh.fcMaNLH, 
bk.fnNo_of_ROOMs, bk.fnRoomRates, bk.fnTotalRoomNight,  lk.fdEventDate, bk.fdDate, bk.fdDateConfirm, lk.fcNguoiNhap, rst.fdTimeIn, rst.fdTimeOut, bk.fcBookID,lk.fcGUA
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lKH.fcName --ngoc them
, lKH.fcNote -- ngoc them source note
,lKH.fcGroup -- ngoc them source bookin group
, lk.fcLyDo -- ngoc them remark
, cp.fcCampaignName -- ngoc them campaign
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(lkdt.fnQuantity), 0 )  <= 0) --ngoc bo
HAVING not isnull(sum(lkdt.fnQuantity), 0 )  <= 0
) actual
Group by datepart(MONTH, actual.fdFunctionDate)
) actualGroup full outer join 

(
select datepart(MONTH, forecast.fdFunctionDate) as fcMonth, 
count(fcBookID) as fnInquiries,
sum(fnTOTAL_Rev) as fnTotal
from 
(select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
,(convert(nvarchar(10), bf.fdDate, 6)+' '+convert( nvarchar(5), bf.fdTimeIn, 8)+' '+convert( nvarchar(5), bf.fdTimeOut, 8)) as fcDatetime
--, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom
, p.fcTen as fcFunctionRoom -- ngoc them
, pl.fcMa 
--, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, sk.fcTen as fcFunctionType -- ngoc them 2017 04 17
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson 
, lk.fcNote as fcSourceBooking,  -- ngoc them source booking
lk.fcName as fcSourceBookingCode, -- ngoc them source note
lk.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1  then 'L' else '' end) as fcL, 
--isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
fnSoLuongDK as fnGUA,
bk.fnEXP , bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
-- (case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case when bk.fcStatus_BkRoom in ('0') then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, --ngoc sua show dung trang thai
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
left(cast(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ))-2) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnRS_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
(
isnull(sum(case when dt.fcgroup in('01') then fnPrice*bc.fnQuantity else 0 end ),0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)  as fnBQT_MICS,
-- else isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) end) as fnBQT_MICS,

/*(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,*/
(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float))as fnTotal_B_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) -cast(isnull(sum(case when bc.fnBreakDownLunch=1 and bk.fcStatus_BkRoom not in('C') then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
left join stKhachHang_Loai lk on bk.fcLoaiKH=lk.fcCode
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lk.fcName --ngoc them
, lk.fcNote -- ngoc them note
, sk.fcTen -- ngoc them
, cp.fcCampaignName -- ngoc them campaign
,lk.fcGroup -- ngoc them source bookin group
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0) -- bo dong nay la show tat ca booking

) forecast group by datepart(MONTH, forecast.fdFunctionDate)
) forecastGroup

on actualGroup.fcMonth = forecastGroup.fcMonth
)
) g 


on m.number = g.fcMonth
WHERE Type = 'P' and number between 1 and 12
order by m.number
GO

IF OBJECT_ID('[dbo].[sp_BanquetForcast]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_BanquetForcast]
GO
-- update 09/08/2007 - update Contactperson
-- update 12/09/2007 - update thay the ham dbo.GetNames_Booking thanh dbo.sfGetNames_Booking


CREATE PROCEDURE sp_BanquetForcast(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)

select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom, pl.fcMa 
 --,  sk.fcTen as fcFunctionType 
, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson , 
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015') then bc.fnQuantity else 0 end ),0) as fnGUA,
bk.fnEXP , 
bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
(case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 

isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0) as fnFood_Price,
isnull(sum(case when dt.fcgroup in('01') then fnAmount else 0 end ),0) as fnFood_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) as fnMICS_Revenue,
isnull(sum(case when bk.fcStatus_BkRoom  = 'D' then fnAmount else 0 end ),0) as  fnDEF_Rev, 
isnull(sum(case when bk.fcStatus_BkRoom in('T','P', 'A') then fnAmount else 0 end ),0)  as  fnTEN_Rev,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
isnull(sum(case when bk.fcStatus_BkRoom  = 'D' then  fnAmount   else 0 end ),0)  - cast(  isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom ='D' then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)  as decimal )  as  fnDEF_BQ_Rev,
isnull(sum(case when bk.fcStatus_BkRoom  in('T', 'P', 'A') then  fnAmount  else 0 end ),0)  - cast( isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom in('A', 'T', 'P') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as decimal)  as  fnTEN_BQ_Rev,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT

from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote
HAVING not (pl.fcMa  in('08', '09') and isnull(sum(bc.fnQuantity), 0 )  <= 0) 
ORDER BY bf.fdDate
GO

IF OBJECT_ID('[dbo].[sp_BanquetForcast_CT]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_BanquetForcast_CT]
GO
/****** Object:  Stored Procedure dbo.sp_BanquetForcast_CT    Script Date: 01/19/2009 10:05:33 AM ******/
CREATE PROCEDURE sp_BanquetForcast_CT(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)

select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom, pl.fcMa 
 --,  sk.fcTen as fcFunctionType 
, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson , 
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
bk.fnEXP , 
bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
(case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case bk.fcBookID When m.fcBookID then 'Yes' else 'No' end) as fcMice,
isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0) as fnPacket_Price,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnFood_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnBF_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) as fnMICS_Revenue,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) -cast(isnull(sum(case when bc.fnBreakDownLunch=1 then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT

from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote,m.fcBookID
HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0) 
ORDER BY bf.fdDate
GO

IF OBJECT_ID('[dbo].[sp_BanquetForcast_CT2812]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_BanquetForcast_CT2812]
GO
/****** Object:  Stored Procedure dbo.sp_BanquetForcast_CT    Script Date: 01/19/2009 10:05:33 AM ******/
CREATE PROCEDURE sp_BanquetForcast_CT2812(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)

select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom, pl.fcMa 
 --,  sk.fcTen as fcFunctionType 
, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson , 
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
bk.fnEXP , 
bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
(case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case bk.fcBookID When m.fcBookID then 'Yes' else 'No' end) as fcMice,
isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0) as fnPacket_Price,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnFood_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnBF_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013') then bc.fnQuantity*4
when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016') then bc.fnQuantity*8 else 0 end), 0) as fnF_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013') then bc.fnQuantity*2
when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016') then bc.fnQuantity*4 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) as fnMICS_Revenue,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0)
-cast(isnull(sum(case when bc.fnBreakDownLunch=1 then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal)
-cast(isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013') then bc.fnQuantity*4
when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016') then bc.fnQuantity*8 else 0 end), 0)as decimal)
- cast(isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013') then bc.fnQuantity*2
when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016') then bc.fnQuantity*4 else 0 end), 0)as decimal)
as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT

from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote,m.fcBookID
HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0) 
ORDER BY bf.fdDate
GO

IF OBJECT_ID('[dbo].[sp_BanquetForecast_By_Campaign_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_BanquetForecast_By_Campaign_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_BanquetForecast_By_Campaign_Ngoc](
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)
select c.fcCampaignName as fcCampaign
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
, isnull(fcOther_Status, 0) as fcOther_Status
, (case when isnull(fnTotal, 0) <> 0 then cast(isnull(fnWedding_Rev, 0) as numeric(18,4)) / cast(isnull(fnTotal, 0) as numeric(18,4)) else 0 end) as fnWeddingPercent
, (case when isnull(fnTotal, 0) <> 0 then cast(isnull(fnEvent_Rev, 0) as numeric(18,4)) / cast(isnull(fnTotal, 0) as numeric(18,4)) else 0 end) as fnEventPercent
from stCampaign c left join
(
select fcCampaign, 
count(fcBookID) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 0 else fnTOTAL_Rev end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		count(case when fcStatus_1 in ('C', 'D') then null else 1 end) as fcOther_Status,
		(case when count(fcBookID) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,4)) / count(fcBookID)   as numeric(18,4)) else 0 end) as fnDefinitePercent
		from (
select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
,(convert(nvarchar(10), bf.fdDate, 6)+' '+convert( nvarchar(5), bf.fdTimeIn, 8)+' '+convert( nvarchar(5), bf.fdTimeOut, 8)) as fcDatetime
--, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom
, p.fcTen as fcFunctionRoom -- ngoc them
, pl.fcMa 
--, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, sk.fcTen as fcFunctionType -- ngoc them 2017 04 17
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson 
, lk.fcNote as fcSourceBooking,  -- ngoc them source booking
lk.fcName as fcSourceBookingCode, -- ngoc them source note
lk.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1  then 'L' else '' end) as fcL, 
--isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
fnSoLuongDK as fnGUA,
bk.fnEXP , bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
-- (case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case when bk.fcStatus_BkRoom in ('0') then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, --ngoc sua show dung trang thai
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
left(cast(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ))-2) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnRS_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
(
isnull(sum(case when dt.fcgroup in('01') then fnPrice*bc.fnQuantity else 0 end ),0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)  as fnBQT_MICS,
-- else isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) end) as fnBQT_MICS,

/*(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,*/
(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float))as fnTotal_B_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) -cast(isnull(sum(case when bc.fnBreakDownLunch=1 and bk.fcStatus_BkRoom not in('C') then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
left join stKhachHang_Loai lk on bk.fcLoaiKH=lk.fcCode
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lk.fcName --ngoc them
, lk.fcNote -- ngoc them note
, sk.fcTen -- ngoc them
, cp.fcCampaignName -- ngoc them campaign
,lk.fcGroup -- ngoc them source bookin group
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0) -- bo dong nay la show tat ca booking

) forecast group by forecast.fcCampaign
) g
on c.fcCampaignName = g.fcCampaign
GO

IF OBJECT_ID('[dbo].[sp_BanquetForecast_By_FunctionType_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_BanquetForecast_By_FunctionType_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_BanquetForecast_By_FunctionType_Ngoc](
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)
select sk.fcTen as fcFunctionType
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
from stSuKien sk left join
(select fcFunctionType, 
count(fcBookID) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 0 else fnTOTAL_Rev end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		(case when count(fcBookID) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,4)) / count(fcBookID)   as numeric(18,4)) else 0 end) as fnDefinitePercent
		from (
select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
,(convert(nvarchar(10), bf.fdDate, 6)+' '+convert( nvarchar(5), bf.fdTimeIn, 8)+' '+convert( nvarchar(5), bf.fdTimeOut, 8)) as fcDatetime
--, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom
, p.fcTen as fcFunctionRoom -- ngoc them
, pl.fcMa 
--, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, sk.fcTen as fcFunctionType -- ngoc them 2017 04 17
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson 
, lk.fcNote as fcSourceBooking,  -- ngoc them source booking
lk.fcName as fcSourceBookingCode, -- ngoc them source note
lk.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1  then 'L' else '' end) as fcL, 
--isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
fnSoLuongDK as fnGUA,
bk.fnEXP , bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
-- (case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case when bk.fcStatus_BkRoom in ('0') then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, --ngoc sua show dung trang thai
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
left(cast(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ))-2) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnRS_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
(
isnull(sum(case when dt.fcgroup in('01') then fnPrice*bc.fnQuantity else 0 end ),0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)  as fnBQT_MICS,
-- else isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) end) as fnBQT_MICS,

/*(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,*/
(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float))as fnTotal_B_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) -cast(isnull(sum(case when bc.fnBreakDownLunch=1 and bk.fcStatus_BkRoom not in('C') then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
left join stKhachHang_Loai lk on bk.fcLoaiKH=lk.fcCode
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lk.fcName --ngoc them 
, lk.fcNote -- ngoc them note
, sk.fcTen -- ngoc them
, cp.fcCampaignName -- ngoc them campaign
,lk.fcGroup -- ngoc them source bookin group
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0) -- bo dong nay la show tat ca booking

) forecast group by forecast.fcFunctionType
) functionTypeGroup
on sk.fcTen = functionTypeGroup.fcFunctionType
where sk.fcMa <> '00'
GO

IF OBJECT_ID('[dbo].[sp_BanquetForecast_By_Month_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_BanquetForecast_By_Month_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_BanquetForecast_By_Month_Ngoc](
	@pNam int ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = datefromparts(@pNam, 1 ,1)
select @DenNgay = datefromparts(@pNam, 12 , 31)
-- lay 12 thang
SELECT number as fcMonth
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
, (case when isnull(fnTotal, 0) <> 0 then cast(isnull(fnWedding_Rev, 0) as numeric(18,4)) / cast(isnull(fnTotal, 0) as numeric(18,4)) else 0 end) as fnWeddingPercent
, (case when isnull(fnTotal, 0) <> 0 then cast(isnull(fnEvent_Rev, 0) as numeric(18,4)) / cast(isnull(fnTotal, 0) as numeric(18,4)) else 0 end) as fnEventPercent
FROM master..spt_values as m
--
left join (
select datepart(MONTH, forecast.fdFunctionDate) as fcMonth, 
count(fcBookID) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 0 else fnTOTAL_Rev end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		(case when count(fcBookID) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,4)) / count(fcBookID)   as numeric(18,4)) else 0 end) as fnDefinitePercent
		from (
select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
,(convert(nvarchar(10), bf.fdDate, 6)+' '+convert( nvarchar(5), bf.fdTimeIn, 8)+' '+convert( nvarchar(5), bf.fdTimeOut, 8)) as fcDatetime
--, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom
, p.fcTen as fcFunctionRoom -- ngoc them
, pl.fcMa 
--, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, sk.fcTen as fcFunctionType -- ngoc them 2017 04 17
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson 
, lk.fcNote as fcSourceBooking,  -- ngoc them source booking
lk.fcName as fcSourceBookingCode, -- ngoc them source note
lk.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1  then 'L' else '' end) as fcL, 
--isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
fnSoLuongDK as fnGUA,
bk.fnEXP , bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
-- (case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case when bk.fcStatus_BkRoom in ('0') then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, --ngoc sua show dung trang thai
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
left(cast(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ))-2) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnRS_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
(
isnull(sum(case when dt.fcgroup in('01') then fnPrice*bc.fnQuantity else 0 end ),0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)  as fnBQT_MICS,
-- else isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) end) as fnBQT_MICS,

/*(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,*/
(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float))as fnTotal_B_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) -cast(isnull(sum(case when bc.fnBreakDownLunch=1 and bk.fcStatus_BkRoom not in('C') then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
left join stKhachHang_Loai lk on bk.fcLoaiKH=lk.fcCode
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lk.fcName --ngoc them
, lk.fcNote -- ngoc them note
, sk.fcTen -- ngoc them
, cp.fcCampaignName -- ngoc them campaign
,lk.fcGroup -- ngoc them source bookin group
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0) -- bo dong nay la show tat ca booking

) forecast group by datepart(MONTH, forecast.fdFunctionDate)
) g
on m.number = g.fcMonth
WHERE Type = 'P' and number between 1 and 12
order by m.number
GO

IF OBJECT_ID('[dbo].[sp_BanquetForecast_By_PriceRange_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_BanquetForecast_By_PriceRange_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_BanquetForecast_By_PriceRange_Ngoc](
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)
SELECT number
, (case when number < 4 then (case when number = 0 then 'None' else '< 3,000,000' end) else concat(number - 1, ',000,000 - ', number, ',000,000') end) as fcPriceRange
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
FROM master..spt_values as m
--
left join (
select  
	--fnMenuPrice,
	(case when ceiling(forecast.fnMenuPrice / 1000000) < 4 then (case when forecast.fnMenuPrice = 0 then 0 else 3 end) else ceiling(forecast.fnMenuPrice / 1000000) end) as num,
--select (case when forecast.fnMenuPrice < 3000000 then '< 3,000,000' else concat(floor(forecast.fnMenuPrice / 1000000), ',000,000 - ', floor(forecast.fnMenuPrice / 1000000)+1, ',000,000') end) as fcPriceRange, 
count(fcBookID) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 0 else fnTOTAL_Rev end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		(case when count(fcBookID) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,4)) / count(fcBookID)   as numeric(18,4)) else 0 end) as fnDefinitePercent
		from (
select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
,(convert(nvarchar(10), bf.fdDate, 6)+' '+convert( nvarchar(5), bf.fdTimeIn, 8)+' '+convert( nvarchar(5), bf.fdTimeOut, 8)) as fcDatetime
--, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom
, p.fcTen as fcFunctionRoom -- ngoc them
, pl.fcMa 
--, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, sk.fcTen as fcFunctionType -- ngoc them 2017 04 17
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson 
, lk.fcNote as fcSourceBooking,  -- ngoc them source booking
lk.fcName as fcSourceBookingCode, -- ngoc them source note
lk.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1  then 'L' else '' end) as fcL, 
--isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
fnSoLuongDK as fnGUA,
bk.fnEXP , bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
-- (case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case when bk.fcStatus_BkRoom in ('0') then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, --ngoc sua show dung trang thai
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
left(cast(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ))-2) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnRS_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
(
isnull(sum(case when dt.fcgroup in('01') then fnPrice*bc.fnQuantity else 0 end ),0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)  as fnBQT_MICS,
-- else isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) end) as fnBQT_MICS,

/*(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,*/
(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float))as fnTotal_B_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) -cast(isnull(sum(case when bc.fnBreakDownLunch=1 and bk.fcStatus_BkRoom not in('C') then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
--ngoc them food unit price (unit price cho menu tung ban)
(case when min(bc.fcDoanhThu_Loai) in('01') then sum( case when bc.fcDoanhThu_Loai in ('01') then bc.fnPrice else 0 end) else 0 end) as fnMenuPrice_Old,
----------------------------------------------------------
-- ngoc them field fnMenuPrice
bf.fnMenuPrice,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
left join stKhachHang_Loai lk on bk.fcLoaiKH=lk.fcCode
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lk.fcName --ngoc them
, lk.fcNote -- ngoc them note
, sk.fcTen -- ngoc them
, cp.fcCampaignName -- ngoc them campaign
,lk.fcGroup -- ngoc them source bookin group
, bf.fnMenuPrice -- ngoc them fnMenuPrice
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0) -- bo dong nay la show tat ca booking

) forecast 
--where isFood = 1
--group by 
-- ngoc tinh tung loai menu theo 1000000
--(case when forecast.fnMenuPrice < 3000000 then '< 3,000,000' else concat(floor(forecast.fnMenuPrice / 1000000), ',000,000 - ', floor(forecast.fnMenuPrice / 1000000)+1, ',000,000') end)

Group by (case when ceiling(forecast.fnMenuPrice / 1000000) < 4 then (case when forecast.fnMenuPrice = 0 then 0 else 3 end) else ceiling(forecast.fnMenuPrice / 1000000) end)
) g
on m.number = g.num
WHERE Type = 'P' and number between 0 and 7 and number not in (1,2)
order by m.number
GO

IF OBJECT_ID('[dbo].[sp_BanquetForecast_By_Source_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_BanquetForecast_By_Source_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_BanquetForecast_By_Source_Ngoc](
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)
select s.fcNote as fcSourceBooking,
s.fcGroup as fcSourceGroup
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
from stKhachHang_Loai s left join
(
select fcSourceBooking, fcSourceGroup,
count(fcBookID) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 0 else fnTOTAL_Rev end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		(case when count(fcBookID) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,4)) / count(fcBookID)   as numeric(18,4)) else 0 end) as fnDefinitePercent
		from (
select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
,(convert(nvarchar(10), bf.fdDate, 6)+' '+convert( nvarchar(5), bf.fdTimeIn, 8)+' '+convert( nvarchar(5), bf.fdTimeOut, 8)) as fcDatetime
--, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom
, p.fcTen as fcFunctionRoom -- ngoc them
, pl.fcMa 
--, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, sk.fcTen as fcFunctionType -- ngoc them 2017 04 17
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson 
, lk.fcNote as fcSourceBooking,  -- ngoc them source booking
 lk.fcName as fcSourceBookingCode,  -- ngoc them source booking code
lk.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1  then 'L' else '' end) as fcL, 
--isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
fnSoLuongDK as fnGUA,
bk.fnEXP , bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
-- (case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case when bk.fcStatus_BkRoom in ('0') then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, --ngoc sua show dung trang thai
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
left(cast(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ))-2) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnRS_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
(
isnull(sum(case when dt.fcgroup in('01') then fnPrice*bc.fnQuantity else 0 end ),0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)  as fnBQT_MICS,
-- else isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) end) as fnBQT_MICS,

/*(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,*/
(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float))as fnTotal_B_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) -cast(isnull(sum(case when bc.fnBreakDownLunch=1 and bk.fcStatus_BkRoom not in('C') then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
left join stKhachHang_Loai lk on bk.fcLoaiKH=lk.fcCode
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lk.fcName --ngoc them
, sk.fcTen -- ngoc them
, cp.fcCampaignName -- ngoc them campaign
,lk.fcGroup -- ngoc them source bookin group
, lk.fcNote -- ngoc them source detail
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0) -- bo dong nay la show tat ca booking

) forecast group by forecast.fcSourceBooking, forecast.fcSourceGroup
) g
on s.fcNote = isnull(g.fcSourceBooking, '')
GO

IF OBJECT_ID('[dbo].[sp_BanquetForecast_By_Source_Ngoc_New]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_BanquetForecast_By_Source_Ngoc_New]
GO
CREATE PROCEDURE [dbo].[sp_BanquetForecast_By_Source_Ngoc_New](
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)
select s.fcNote as fcSourceBooking,
s.fcGroup as fcSourceGroup
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
, isnull(fcOther_Status, 0) as fcOther_Status
, (case when isnull(fnTotal, 0) <> 0 then cast(isnull(fnWedding_Rev, 0) as numeric(18,4)) / cast(isnull(fnTotal, 0) as numeric(18,4)) else 0 end) as fnWeddingPercent
, (case when isnull(fnTotal, 0) <> 0 then cast(isnull(fnEvent_Rev, 0) as numeric(18,4)) / cast(isnull(fnTotal, 0) as numeric(18,4)) else 0 end) as fnEventPercent
from stKhachHang_Loai s left join
(
select isnull(fcSourceBooking, '') as fcSourceBooking, isnull(fcSourceGroup, '') as fcSourceGroup, 
  -- fcSourceBooking, fcSourceGroup, -- ngoc sua 2017 09 16
count(fcBookID) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 0 else fnTOTAL_Rev end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		count(case when fcStatus_1 in ('C', 'D') then null else 1 end) as fcOther_Status, 
		(case when count(fcBookID) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,4)) / count(fcBookID)   as numeric(18,4)) else 0 end) as fnDefinitePercent
		from (
select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
,(convert(nvarchar(10), bf.fdDate, 6)+' '+convert( nvarchar(5), bf.fdTimeIn, 8)+' '+convert( nvarchar(5), bf.fdTimeOut, 8)) as fcDatetime
--, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom
, p.fcTen as fcFunctionRoom -- ngoc them
, pl.fcMa 
--, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, sk.fcTen as fcFunctionType -- ngoc them 2017 04 17
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson 
, lk.fcNote as fcSourceBooking,  -- ngoc them source booking
 lk.fcName as fcSourceBookingCode,  -- ngoc them source booking code
lk.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1  then 'L' else '' end) as fcL, 
--isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
fnSoLuongDK as fnGUA,
bk.fnEXP , bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
-- (case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case when bk.fcStatus_BkRoom in ('0') then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, --ngoc sua show dung trang thai
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
left(cast(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ))-2) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnRS_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
(
isnull(sum(case when dt.fcgroup in('01') then fnPrice*bc.fnQuantity else 0 end ),0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)  as fnBQT_MICS,
-- else isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) end) as fnBQT_MICS,

/*(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,*/
(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float))as fnTotal_B_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) -cast(isnull(sum(case when bc.fnBreakDownLunch=1 and bk.fcStatus_BkRoom not in('C') then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
left join stKhachHang_Loai lk on bk.fcLoaiKH=lk.fcCode
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE (bk.fdDate between @TuNgay and @DenNgay)  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lk.fcName --ngoc them
, sk.fcTen -- ngoc them
, cp.fcCampaignName -- ngoc them campaign
,lk.fcGroup -- ngoc them source bookin group
, lk.fcNote -- ngoc them source detail
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0) -- bo dong nay la show tat ca booking

) forecast group by forecast.fcSourceBooking, forecast.fcSourceGroup
) g
on s.fcNote = isnull(g.fcSourceBooking, '')
GO

IF OBJECT_ID('[dbo].[sp_BanquetForecast_By_TimeInterval_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_BanquetForecast_By_TimeInterval_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_BanquetForecast_By_TimeInterval_Ngoc](
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)
-- lay 12 thang
SELECT number as fnTimeInterval
, isnull(fnInquiries, 0) as fnInquiries
, isnull(fnTotal, 0) as fnTotal
, isnull(fnWedding_Rev, 0) as fnWedding_Rev
, isnull(fnEvent_Rev, 0) as fnEvent_Rev
, isnull(fcDefinite, 0) as fcDefinite
, isnull(fcCancel, 0) as fcCancel
, isnull(fnDefinitePercent, 0) as fnDefinitePercent
FROM master..spt_values as m
--
left join (
select DATEDIFF(month, forecast.fdDATE_RECEIVED, forecast.fdFunctionDate) /*+ (case when DATEPART(day, forecast.fdDATE_RECEIVED) < datepart(day, forecast.fdFunctionDate) then 1 else 0 end) */ as fnTimeInterval, 
count(fcBookID) as fnInquiries, 
		sum(fnTOTAL_Rev) as fnTotal, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then fnTOTAL_Rev else 0 end) as fnWedding_Rev, 
		sum(case when fcFunctionType like '%Wedding%' or fcFunctionType like '%(W)%' or fcOrganization like '%Wedding%' then 0 else fnTOTAL_Rev end) as fnEvent_Rev, 
		count(case when fcStatus_1 in ('D') then 1 else null end) as fcDefinite, 
		count(case when fcStatus_1 in ('C') then 1 else null end) as fcCancel, 
		(case when count(fcBookID) <> 0 then cast(cast(count(case when fcStatus_1 in ('D') then 1 else null end) as numeric(18,4)) / count(fcBookID)   as numeric(18,4)) else 0 end) as fnDefinitePercent
		from (
select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
,(convert(nvarchar(10), bf.fdDate, 6)+' '+convert( nvarchar(5), bf.fdTimeIn, 8)+' '+convert( nvarchar(5), bf.fdTimeOut, 8)) as fcDatetime
--, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom
, p.fcTen as fcFunctionRoom -- ngoc them
, pl.fcMa 
--, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, sk.fcTen as fcFunctionType -- ngoc them 2017 04 17
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson 
, lk.fcNote as fcSourceBooking,  -- ngoc them source booking
lk.fcName as fcSourceBookingCode, -- ngoc them source note
lk.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1  then 'L' else '' end) as fcL, 
--isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
fnSoLuongDK as fnGUA,
bk.fnEXP , bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
-- (case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case when bk.fcStatus_BkRoom in ('0') then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, --ngoc sua show dung trang thai
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
left(cast(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ))-2) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnRS_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
(
isnull(sum(case when dt.fcgroup in('01') then fnPrice*bc.fnQuantity else 0 end ),0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)  as fnBQT_MICS,
-- else isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) end) as fnBQT_MICS,

/*(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,*/
(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float))as fnTotal_B_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) -cast(isnull(sum(case when bc.fnBreakDownLunch=1 and bk.fcStatus_BkRoom not in('C') then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
left join stKhachHang_Loai lk on bk.fcLoaiKH=lk.fcCode
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lk.fcName --ngoc them
, lk.fcNote -- ngoc them note
, sk.fcTen -- ngoc them
, cp.fcCampaignName -- ngoc them campaign
,lk.fcGroup -- ngoc them source bookin group
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0) -- bo dong nay la show tat ca booking

) forecast group by DATEDIFF(month, forecast.fdDATE_RECEIVED, forecast.fdFunctionDate) -- + (case when DATEPART(day, forecast.fdDATE_RECEIVED) < datepart(day, forecast.fdFunctionDate) then 1 else 0 end) 
) g
on m.number = g.fnTimeInterval
WHERE Type = 'P' and number between 0 and 12
order by m.number
GO

IF OBJECT_ID('[dbo].[sp_BanquetForecast_CT2812_new]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_BanquetForecast_CT2812_new]
GO
CREATE PROCEDURE [dbo].[sp_BanquetForecast_CT2812_new](
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)

select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
,(convert(nvarchar(10), bf.fdDate, 6)+' '+convert( nvarchar(5), bf.fdTimeIn, 8)+' '+convert( nvarchar(5), bf.fdTimeOut, 8)) as fcDatetime
, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom, pl.fcMa 
, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, bk.fcGuestID, kh.fcTen as fcOrganization
,kh.fcLoaiKhach as fcLoaiKhach, khLoai.fcName as fcLoaiKhachName, kh.fcLinhVuc as fcLinhVuc, khLinhVuc.fcName as fcLinhVucName
, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson , 
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1  then 'L' else '' end) as fcL, 
--isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
fnSoLuongDK as fnGUA,
bk.fnEXP , bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
(case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
--left(cast(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ))-2) as fnPacket_Price,
format(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ),0) ,'N0') +' / '+format(isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0),'N0') as fnPacket_Price,
--isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when dt.fcgroup in('01') then fnAmount else 0 end ),0) as fnBQT_BANQUET_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBQT_BEVERAGE_Rev,
isnull(sum(case when dt.fcgroup in('03') then fnAmount else 0 end ),0) as fnBQT_MISC_Rev,
isnull(sum(case when dt.fcgroup in('04') then fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when dt.fcgroup in('05') then fnAmount else 0 end ),0) as fnBQT_ROOM_Rev,
isnull(sum(case when dt.fcgroup in('06') then fnAmount else 0 end ),0) as fnBQT_SEMINAR_Rev,
isnull(sum(case when dt.fcgroup in('01','02','03','04','06') then fnAmount else 0 end ),0) as fnBQT_SUM_NoMice_Rev,
isnull(sum(fnAmount),0) as fnBQT_Total_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnRS_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
(
isnull(sum(case when dt.fcgroup in('01') then fnPrice*bc.fnQuantity else 0 end ),0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)  as fnBQT_MICS,
-- else isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) end) as fnBQT_MICS,

/*(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,*/
(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float))as fnTotal_B_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) -cast(isnull(sum(case when bc.fnBreakDownLunch=1 and bk.fcStatus_BkRoom not in('C') then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
left join stLinhVuc khLinhVuc on khLinhVuc.fcCode = kh.fcLinhVuc
left join stKhachHang_Loai khLoai on khLoai.fcCode = kh.fcLoaiKhach 
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote,kh.fcLoaiKhach , khLoai.fcName, kh.fcLinhVuc, khLinhVuc.fcName
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0) 
ORDER BY bf.fdDate
GO

IF OBJECT_ID('[dbo].[sp_BanquetForecast_CT2812_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_BanquetForecast_CT2812_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_BanquetForecast_CT2812_Ngoc](
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)

select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
,(convert(nvarchar(10), bf.fdDate, 6)+' '+convert( nvarchar(5), bf.fdTimeIn, 8)+' '+convert( nvarchar(5), bf.fdTimeOut, 8)) as fcDatetime
--, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom
, p.fcTen as fcFunctionRoom -- ngoc them
, pl.fcMa 
--, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, sk.fcTen as fcFunctionType -- ngoc them 2017 04 17
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson 
, lk.fcNote as fcSourceBooking,  -- ngoc them source booking
lk.fcName as fcSourceBookingCode, -- ngoc them source code
lk.fcGroup as fcSourceGroup, -- ngoc them source booking group
cp.fcCampaignName as fcCampaign, -- ngoc them campaign
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1  then 'L' else '' end) as fcL, 
--isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
fnSoLuongDK as fnGUA,
bk.fnEXP , bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
-- (case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case when bk.fcStatus_BkRoom in ('0') then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, --ngoc sua show dung trang thai
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
left(cast(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ))-2) as fnPacket_Price,
 --ngoc them unit price
isnull( case when bf.fnMenuPrice > 0 then bf.fnMenuPrice else null end, case when ((kh.fcTen like '%wedding%' or sk.fcTen like '%wedding%' or sk.fcTen like '%(W)%') and cast(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ), 0) as numeric(18,2)) < 1000000) then sum(case when dt.fcgroup in('04') then fnPrice else 0 end ) * 10 else max(fnPrice) end) as fnUnitPrice, 
-----
isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnRS_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
(
isnull(sum(case when dt.fcgroup in('01') then fnPrice*bc.fnQuantity else 0 end ),0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
/*isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)*/
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)  as fnBQT_MICS,
-- else isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) end) as fnBQT_MICS,

/*(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*5
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*10 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,*/
(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*154000
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*154000 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*0
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*0 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float))as fnTotal_B_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) -cast(isnull(sum(case when bc.fnBreakDownLunch=1 and bk.fcStatus_BkRoom not in('C') then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
-- ngoc them field fnMenuPrice
,bf.fnMenuPrice as fnMenuPrice
from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
left join stKhachHang_Loai lk on bk.fcLoaiKH=lk.fcCode
left join stCampaign cp on cp.fcCampaignCode=bk.fcCampaign --ngoc them campaign
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote
, p.fcTen --ngoc them
, bk.fcLoaiKH -- ngoc them
, lk.fcName --ngoc them
, lk.fcNote -- ngoc them note
, sk.fcTen -- ngoc them
, cp.fcCampaignName -- ngoc them campaign
,lk.fcGroup -- ngoc them source bookin group
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0) -- bo dong nay la show tat ca booking
, bf.fnMenuPrice -- ngoc them fnMenuPrice
ORDER BY bf.fdDate
GO

IF OBJECT_ID('[dbo].[sp_Budget_Year]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Budget_Year]
GO
CREATE PROCEDURE sp_Budget_Year(  -- Cac su kien da xay ra roi, bao cao doanh thu
	@pYear nchar(4)
)
as
--set dateformat dmy
set dateformat mdy

SELECT  distinct    a.*,   SUM(fnJan_) AS fnJan_,     SUM(fnFeb_) AS fnFeb_,  SUM(fnMar_) AS fnMar_,   SUM(fnApr_) AS fnApr_,    
		            SUM(fnMay_) AS fnMay_,   SUM(fnJun_) AS fnJun_,   SUM(fnJul_) AS fnJul_,       SUM(fnAug_) AS fnAug_,    
		            SUM(fnSep_) AS fnSep_,   SUM(fnOct_) AS fnOct_,   SUM(fnNov_) AS fnNov_,   SUM(fnDec_) AS fnDec_
 FROM

(	select  bg.fcYear,  bg.fcRoom,  r.fcTen as fcRoomName, 
	isnull(fcJan, 0) as fnJan, isnull(fcFeb, 0) as fnFeb, isnull(fcMar, 0) as fnMar, isnull(fcApr, 0) as fnApr, isnull(fcMay, 0) as fnMay, isnull(fcJun, 0) as fnJun,
	isnull(fcJul, 0) as fnJul, isnull(fcAug, 0) as fnAug, isnull(fcSep, 0) as fnSep, isnull(fcOct, 0) as fnOct, isnull(fcNov, 0) as fnNov, isnull(fcDec, 0) as fnDec
	from stBudget bg inner join stphong r on bg.fcRoom = r.fcMa where bg.fcYear =@pYear) a
INNER JOIN 
( select distinct rs.fcRoom,  year(rs.fdTimeIn) as fcYear,
	 (case month(fdTimeIn) when '1' then isnull( sum(ldt.fnamount), 0)  else 0 end)  as 'fnJan_',
	 (case month(fdTimeIn) when '2' then isnull( sum(ldt.fnamount), 0)  else 0 end)  as 'fnFeb_',
	 (case month(fdTimeIn) when '3' then isnull( sum(ldt.fnamount), 0)  else 0 end)  as 'fnMar_',
	 (case month(fdTimeIn) when '4' then isnull( sum(ldt.fnamount), 0)  else 0 end)  as 'fnApr_',
	 (case month(fdTimeIn) when '5' then isnull( sum(ldt.fnamount), 0)  else 0 end)  as 'fnMay_',
	 (case month(fdTimeIn) when '6' then isnull( sum(ldt.fnamount), 0)  else 0 end)  as 'fnJun_',
	 (case month(fdTimeIn) when '7' then isnull( sum(ldt.fnamount), 0)  else 0 end)  as 'fnJul_',
	 (case month(fdTimeIn) when '8' then isnull( sum(ldt.fnamount), 0)  else 0 end)  as 'fnAug_',
	 (case month(fdTimeIn) when '9' then isnull( sum(ldt.fnamount), 0)  else 0 end)  as 'fnSep_',
	 (case month(fdTimeIn) when '10' then isnull( sum(ldt.fnamount), 0)  else 0 end)  as 'fnOct_',
	 (case month(fdTimeIn) when '11' then isnull( sum(ldt.fnamount), 0)  else 0 end)  as 'fnNov_',
	 (case month(fdTimeIn) when '12' then isnull( sum(ldt.fnamount), 0)  else 0 end)  as 'fnDec_'

	from stSKLK l
	left join stRoom_Setup rs on rs.fcMaster_EO =l.fcMaster_EO  and rs.fcOrderNo = l.fcOrderNo  
	left join stSKLK_doanhThu ldt on rs.fcMaster_EO =ldt.fcMaster_EO and rs.fcOrderNo = ldt.fcOrderNo and rs.fnCodeID = ldt.fnCodeID
	where year(rs.fdTimeIn) =@pYear  AND  l.fcTrangThai  not in ( 'C', 'R')
	group by rs.fcRoom,  month(rs.fdTimeIn), year(rs.fdTimeIn)
) b
ON a.fcRoom = b.fcroom and a.fcYear = b.fcYear
group by a.fcYear, a.fcRoom, a.fcRoomName, a.fnJan, a.fnFeb, a.fnMar, a.fnApr, a.fnMay, a.fnJun, a.fnJul, a.fnAug, a.fnSep, a.fnOct, a.fnNov, a.fnDec
ORDER BY a.fcRoom
GO

IF OBJECT_ID('[dbo].[sp_Compare_QuantityGuest_ofRestaurant]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Compare_QuantityGuest_ofRestaurant]
GO
CREATE PROCEDURE sp_Compare_QuantityGuest_ofRestaurant 
(
	@pcRoom nvarchar(20),
	@pcFunctionDate nvarchar(10),
	@pdTimeIn	smalldatetime,	
	@pdTimeOut	smalldatetime
)
AS
--set dateformat dmy
set dateformat mdy
DECLARE @pdFunctionDate smalldatetime
SET  @pdFunctionDate  = cast ( @pcFunctionDate  as smalldatetime)

DECLARE @BreakDownTime int
SET @BreakDownTime = (select datepart(hh, fcValues) from stValidBooking where fcID ='006')
DECLARE @getBreakDown char(1) 
SET @getBreakDown = (case  when (datepart(hh, @pdTimeIn ) + datepart(hh, @pdTimeOut ))/2  <= @BreakDownTime  then 'L' else 'D' end)


SELECT fcFunctionRoom, fdDate, fcBreakDown, sum(fnQuantity) as fnQuantity, (select fcValues from stValidBooking where fcID in (CASE when @pcRoom = '07' THEN '003'  else '002' end )) -  sum(fnQuantity) as fnConLai from (
	-- pax of Booking
	select distinct bf.fcFunctionRoom, bf.fdDate, (case when (datepart(hh, bf.fdTimeIn )+ datepart(hh,bf.fdTimeOut))/2  <= @BreakDownTime  then 'L' else 'D' end) as fcBreakDown, sum(bf.fnQuantity) as fnQuantity   from  stBooking b
	left join stBookFunctionRoom bf on bf.fcbookID = b.fcBookID
	where  (b.fcStatus_BkRoom not in ('C'))  AND  (bf.fcFunctionRoom in ('07', '08'))  
	            AND   (bf.fdDate = @pdFunctionDate) 
                         AND (b.fcBookID not in (select fcBookID from stMaster_EO))
	group by bf.fcFunctionRoom, bf.fdDate, (case when (datepart(hh, bf.fdTimeIn )+ datepart(hh,bf.fdTimeOut))/2  <= @BreakDownTime  then 'L' else 'D' end)

UNION ALL
	-- pax of BEO
	select distinct rs.fcRoom, l.fdEventDate, (case when (datepart(hh, rs.fdTimeIn )+ datepart(hh,rs.fdTimeOut))/2  <= @BreakDownTime  then 'L' else 'D' end) as fcBreakDown, sum(rs.fnQuantity) as fnQuantity   from  stSKLK l 
	left join stRoom_Setup rs on l.fcMaster_EO = rs.fcMaster_EO and l.fcOrderNo = rs.fcOrderNo
	where   (l.fcTrangThai not in ('C','R'))  AND  (rs.fcRoom in ('07', '08'))
	           AND (l.fdEventDate = @pdFunctionDate ) 	
	group by rs.fcRoom, l.fdEventDate,  (case when (datepart(hh, rs.fdTimeIn )+ datepart(hh,rs.fdTimeOut))/2  <= @BreakDownTime  then 'L' else 'D' end)

UNION ALL 
	select @pcRoom, @pcFunctionDate,  (case when (datepart(hh, @pdTimeIn )+ datepart(hh, @pdTimeOut))/2  <= @BreakDownTime  then 'L' else 'D' end), 0 as fnQuantity from stValidBooking

)u  WHERE (u.fcBreakDown = @getBreakDown) AND (fcFunctionRoom = @pcRoom)
GROUP BY fcFunctionRoom, fdDate, fcBreakDown
HAVING  (select fcValues from stValidBooking where fcID in (CASE when @pcRoom = '07' THEN '003'  else '002' end )) -  sum(fnQuantity) >=0
GO

IF OBJECT_ID('[dbo].[sp_CompareReport_Banquet_CurrentYEAR]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_CompareReport_Banquet_CurrentYEAR]
GO
-- CREATE  10/07/2007

-- LAY DU LIEU ACTUAL ( MONTH < @pnCurrMonth ) VA FORECAST ( MONTH >= @pnCurrMonth) TRONG NAM HIEN HANH
--************** NOTE : KHONG DUOC DOI THU TU CAC FIELDNAME O BUOC 1 VA BUOC 2 , BOI VI SU DUNG UNION **************

--******* CACH LAM NHU SAU:
	-- BUOC 1:  LAY DU LIEU  FORECAST TU THANG HIEN HANH (@pnCurrMonth) -> THANG 12 CUA NAM HIEN HANH (@pcCurrYear)
	-- BUOC 2: LAY DU LIEU THUC TE ( ACTUAL) TU THANG 01 -> THANG HIEN HANH (@pnCurrMonth) CUA NAM HIEN HANH (@pcCurrYear)
	-- BUOC 3: GOP BUOC 1 VA 2 -> TA SE CO DU LIEU TRONG NAM HIEN HANH

CREATE PROCEDURE sp_CompareReport_Banquet_CurrentYEAR 
(
	@pcCurrYear nchar(4),
	@pnCurrMonth int 
)

AS

SELECT * FROM (
-- BUOC 1:  Lay tat ca record thoa fcMonth >= @pnCurrMonth

	SELECT  month(bf.fdDate) as fcMonth,
	isnull(sum(case when dt.fcgroup in ('01') then fnAmount else 0 end ),0) as fnFood_Rev_CUR,
	isnull(sum(case when dt.fcgroup in ('02') then fnAmount else 0 end ),0) as fnBev_Revenue_CUR,
	isnull(sum(case when dt.fcgroup  in ('03') then fnAmount else 0 end), 0) as fnMICS_Revenue_CUR,
	isnull(sum(case when bk.fcStatus_BkRoom  = 'D' then fnAmount else 0 end ),0) as  fnDEF_Rev_CUR, 
	isnull(sum(case when bk.fcStatus_BkRoom in ('T','P', 'A') then fnAmount else 0 end ),0)  as  fnTEN_Rev_CUR,
	isnull(sum(case when bk.fcStatus_BkRoom = 'C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD_CUR,
	isnull(sum(case when bk.fcStatus_BkRoom  = 'D' then fnAmount else 0 end ),0)  - cast(  isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom ='D' then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)  as decimal )  as  fnDEF_BQ_Rev_CUR,
	isnull(sum(case when bk.fcStatus_BkRoom  in ('T', 'P', 'A') then fnAmount else 0 end ),0)  - cast( isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom in ('A', 'T', 'P') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as decimal)  as  fnTEN_BQ_Rev_CUR

	FROM stBOOKING bk 
	left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
	left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
	left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
	WHERE ( year(bf.fdDate) = @pcCurrYear) and ( month(bf.fdDate) >=  @pnCurrMonth)
	GROUP BY   month(bf.fdDate) , year(bf.fdDate)

UNION ALL -- BUOC 3 = BUOC 1 + BUOC 2

-- BUOC 2:  Lay tat ca record thoa fcMonth < @pnCurrMonth
	SELECT  month(lk.fdEventDate) as fcMonth, 
	isnull(sum(case when dt.fcgroup in('01') then lkdt.fnAmount else 0 end ),0) as fnFood_Rev_CUR,
	isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0) as fnBev_Revenue_CUR,
	isnull(sum(case when dt.fcgroup  in('03') then lkdt.fnAmount else 0 end), 0) as fnMICS_Revenue_CUR,
	isnull(sum(case when lk.fcTrangThai  = 'D' then lkdt.fnAmount else 0 end ),0) as  fnDEF_Rev_CUR, 
	isnull(sum(case when lk.fcTrangThai in('P') then lkdt.fnAmount else 0 end ),0)  as  fnTEN_Rev_CUR,
	isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD_CUR,
	isnull(sum(case when lk.fcTrangThai  = 'D' then fnAmount else 0 end ),0)  -   cast(  isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lk.fcTrangThai ='D' then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)  as decimal)   as  fnDEF_BQ_Rev_CUR,
	isnull(sum(case when lk.fcTrangThai  in( 'P') then fnAmount else 0 end ),0)  - cast(  isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lk.fcTrangThai in( 'P')then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as decimal)  as  fnTEN_BQ_Rev_CUR


	FROM stMASTER_EO ms 
	left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
	left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
	left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
	left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
	WHERE ( YEAR(lk.fdEventDate) = @pcCurrYear ) and ( month ( lk.fdEventDate) < @pnCurrMonth)  and lk.fcTrangThai not in ('R')
	GROUP BY  month(lk.fdEventDate) , year(lk.fdEventDate)

) gop ORDER BY fcMonth
GO

IF OBJECT_ID('[dbo].[sp_CompareReport_Banquet_PreviousYEAR]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_CompareReport_Banquet_PreviousYEAR]
GO
-- CREATE  10/07/2007

-- LAY DU LIEU THUC TE O QUA KHU 

CREATE PROCEDURE sp_CompareReport_Banquet_PreviousYEAR
(
	@pcPrevYear nchar(4)
)

AS

SELECT  * FROM  stMonth M
LEFT JOIN

(	SELECT  month(lk.fdEventDate) as fcMonth_PREV, 
	isnull(sum(case when dt.fcgroup in('01') then lkdt.fnAmount else 0 end ),0) as fnFood_Rev_PREV,
	isnull(sum(case when dt.fcgroup in('02') then lkdt.fnAmount else 0 end ),0) as fnBev_Revenue_PREV,
	isnull(sum(case when dt.fcgroup  in('03') then lkdt.fnAmount else 0 end), 0) as fnMICS_Revenue_PREV,
	isnull(sum(case when lk.fcTrangThai  = 'D' then lkdt.fnAmount else 0 end ),0) as  fnDEF_Rev_PREV, 
	isnull(sum(case when lk.fcTrangThai in('P') then lkdt.fnAmount else 0 end ),0)  as  fnTEN_Rev_PREV,
	isnull(sum(case when lk.fcTrangThai ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD_PREV,
	isnull(sum(case when lk.fcTrangThai  = 'D' then fnAmount else 0 end ),0)  -   cast(  isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lk.fcTrangThai ='D' then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0)  as decimal)   as  fnDEF_BQ_Rev_PREV,
	isnull(sum(case when lk.fcTrangThai  in( 'P') then fnAmount else 0 end ),0)  - cast(  isnull(sum(case when lkdt.fnBreakDownLunch = 1  and lk.fcTrangThai in( 'P')then lkdt.fnQuantity*lkdt.fnLunchPrice else 0 end), 0) as decimal)  as  fnTEN_BQ_Rev_PREV

	FROM stMASTER_EO ms 
	left join stSKLK lk on ms.fcMaster_EO = lk.fcMaster_EO
	left  join stRoom_Setup rst on lk.fcMaster_EO = rst.fcMaster_EO and lk.fcOrderNo = rst.fcOrderNo
	left join stSKLK_DoanhThu lkdt on rst.fcMaster_EO = lkdt.fcMaster_EO and rst.fcOrderNo = lkdt.fcOrderNo and rst.fnCodeID = lkdt.fnCodeID
	left  join stDoanhThu_loai dt on lkdt.fcDoanhThu_Type = dt.fcCode
	WHERE ( YEAR(lk.fdEventDate) = @pcPrevYear ) and lk.fcTrangThai not in ('R')
	GROUP BY  month(lk.fdEventDate) , year(lk.fdEventDate)
) A
ON M.fnMonth = A.fcMonth_PREV
ORDER BY M.fnMonth
GO

IF OBJECT_ID('[dbo].[sp_CompareReport_BanquetForecast]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_CompareReport_BanquetForecast]
GO
--Create 08/06/2007: Liet ke nhung booking co fbDEF_BQ_REV khac nhau giua 2 lan bao cao

CREATE PROCEDURE sp_CompareReport_BanquetForecast
(
	@pcSavedDate1 nvarchar(22), -- datetime, -- 
	@pcSavedDate2  nvarchar(22)-- datetime -- 
)
AS


--set dateformat dmy
set dateformat mdy

declare 	@pdSavedDate1 datetime
declare 	@pdSavedDate2 datetime
set @pdSavedDate1 = cast (@pcSavedDate1 as datetime)
set @pdSavedDate2 = cast (@pcSavedDate2 as datetime)


	
--BUOC 1: Lay du lieu cua tat ca cac record trong bang stHoSo_BanquetForecast thoa dieu kien: CO CUNG  BookID va KHAC DEF_BQ_REF
select   convert(nvarchar(10), fdFunctionDate, 6) as fcFunctionDate, * from stHoSo_BanquetForecast where fcBookID in (
	-- Loc tat ca bookID có fnDEF_BQ_REF khac nhau cua lan baocao_1 va lan baocao_2 
	select a.fcBookID from (
		(select fcBookID , sum (fnDEF_Rev)as fnDEF_Rev, sum(fnTEN_Rev) as fnTEN_Rev, sum(fnToTal_CXLD) as fnToTal_CXLD from stHoSo_BanquetForecast where (fdSaveDate = @pdSavedDate1) group by fcBookID) a
		inner join 
		(select fcBookID , sum (fnDEF_Rev)as fnDEF_Rev, sum(fnTEN_Rev) as fnTEN_Rev, sum(fnToTal_CXLD) as fnToTal_CXLD from stHoSo_BanquetForecast where (fdSaveDate = @pdSavedDate2) group by fcBookID)b
		on a.fcBookID = b.fcBookID
	) where (fdSaveDate = @pdSavedDate1 or fdSaveDate = @pdSavedDate2)
		and (a.fnDEF_Rev <> b.fnDEF_Rev  or a.fnTEN_Rev <> b.fnTEN_Rev or a.fnToTal_CXLD <> b.fnToTal_CXLD)
)

union all 

-- BUOC 2: Lay THEM nhung record duoc book them trong lan baocao_2( nhung BookID nay CHI CO trong lan BAOCAO SAU ma KHONG CO trong lan BAO CAO TRUOC DO )
select convert(nvarchar(10), fdFunctionDate, 6) as fcFunctionDate, * from stHoSo_BanquetForecast where (fdSaveDate = @pdSavedDate2) and (fcBookID not in (select fcBookID from stHoSo_BanquetForecast where fdSaveDate = @pdSavedDate1))
order by fcBookID, fcGuestID, fdSaveDate

-- BUOC 3 = BUOC 1+ BUOC 2:
GO

IF OBJECT_ID('[dbo].[sp_CompareReport_BanquetForecast_NewRequire]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_CompareReport_BanquetForecast_NewRequire]
GO
--Create 27/06/2007: Liet ke nhung booking co REVENUE khac nhau giua 2 lan bao cao @pcSavedDate1 VA @pcSavedData2
-- update 05/07/2007
-- update 10/07/2007

--/* -- SO SANH NGAY THEO DINH DANG CHUOI dd/MM/yyyy
CREATE PROCEDURE sp_CompareReport_BanquetForecast_NewRequire
(
	@pcSavedDate1 nvarchar(10),
	@pcSavedDate2  nvarchar(10),
	@pnMonth1	int,
	@pnMonth2	int
)
AS
--set dateformat dmy
set dateformat mdy
declare @pdSavedDate1 as smalldatetime
declare @pdSavedDate2 as smalldatetime
set  @pdSavedDate1 = cast (@pcSavedDate1 as smalldatetime )
set  @pdSavedDate2 = cast (@pcSavedDate2 as smalldatetime )

SELECT    (case when fcStatus_2 in ('T', 'P', 'A') then 'T' else fcStatus_2 end ) as fcStatus_2_rpt ,  
(case when fcStatus_1 in ('T', 'P', 'A') then 'T' else fcStatus_1 end ) as fcStatus_1_rpt ,   * ,

-- GET DIFFERENT
( ISNULL( rs.fnFood_Rev_2, 0)  - ISNULL( rs.fnFood_Rev_1, 0) ) as fnDIFFERENT_Food_Rev, 
( ISNULL( rs.fnBev_Rev_2, 0) -   ISNULL( rs.fnBev_Rev_1, 0) ) as fnDIFFERENT_Bev_Rev, 
( ISNULL( rs.fnMICS_Rev_2, 0)  -   ISNULL( rs.fnMICS_Rev_1, 0) ) as fnDIFFERENT_MICS_Rev, 
( ISNULL( rs.fnDEF_BQ_Rev_2, 0)  -   ISNULL( rs.fnDEF_BQ_Rev_1, 0) ) as fnDIFFERENT_DEF_BQ, 
( ISNULL( rs.fnDEF_Rev_2, 0)  -  ISNULL(  rs.fnDEF_Rev_1, 0) ) as fnDIFFERENT_DEF_Rev, 
( ISNULL( rs.fnTEN_BQ_Rev_2, 0)  -   ISNULL( rs.fnTEN_BQ_Rev_1, 0) ) as fnDIFFERENT_TEN_BQ_Rev, 
( ISNULL( rs.fnTEN_Rev_2, 0)  -   ISNULL( rs.fnTEN_Rev_1, 0) ) as fnDIFFERENT_TEN_Rev,
( ISNULL( rs.fnTOTAL_CXLD_2, 0)  -   ISNULL( rs.fnTOTAL_CXLD_1, 0) ) as fnDIFFERENT_TOTAL_CXLD,


-- GET PERCENT DIFFERENT
(CASE  
	 WHEN ISNULL( rs.fnFood_Rev_1, 0 ) = 0  AND ISNULL( rs.fnFood_Rev_2, 0 ) =  0 THEN  0
	 WHEN ISNULL( rs.fnFood_Rev_1, 0 ) = 0  AND ISNULL( rs.fnFood_Rev_2, 0 ) >  0 THEN  100
	 WHEN ISNULL( rs.fnFood_Rev_1, 0 ) > 0  AND ISNULL( rs.fnFood_Rev_2, 0 ) >  0 THEN  (rs.fnFood_Rev_2 /  rs.fnFood_Rev_1) *100  END)   as fnPERCENT_Food_Rev, 
(CASE  
	 WHEN ISNULL( rs.fnBev_Rev_1, 0 ) = 0  AND ISNULL( rs.fnBev_Rev_2, 0 ) =  0 THEN  0
	 WHEN ISNULL( rs.fnBev_Rev_1, 0 ) = 0  AND ISNULL( rs.fnBev_Rev_2, 0 ) >  0 THEN  100
	 WHEN ISNULL( rs.fnBev_Rev_1, 0 ) > 0  AND ISNULL( rs.fnBev_Rev_2, 0 ) >  0 THEN  (rs.fnBev_Rev_2 /  rs.fnBev_Rev_1) *100 END)   as fnPERCENT_Bev_Rev, 
(CASE  
	 WHEN ISNULL( rs.fnMICS_Rev_1, 0 ) = 0  AND ISNULL( rs.fnMICS_Rev_2, 0 ) =  0 THEN  0
	 WHEN ISNULL( rs.fnMICS_Rev_1, 0 ) = 0  AND ISNULL( rs.fnMICS_Rev_2, 0 ) >  0 THEN  100
	 WHEN ISNULL( rs.fnMICS_Rev_1, 0 ) > 0  AND ISNULL( rs.fnMICS_Rev_2, 0 ) >  0 THEN  (rs.fnMICS_Rev_2 /  rs.fnMICS_Rev_1) *100 END)   as fnPERCENT_MICS_Rev,
(CASE  
	 WHEN ISNULL( rs.fnDEF_BQ_Rev_1, 0 ) = 0  AND ISNULL( rs.fnDEF_BQ_Rev_2, 0 ) =  0 THEN  0
	 WHEN ISNULL( rs.fnDEF_BQ_Rev_1, 0 ) = 0  AND ISNULL( rs.fnDEF_BQ_Rev_2, 0 ) >  0 THEN  100
	 WHEN ISNULL( rs.fnDEF_BQ_Rev_1, 0 ) > 0  AND ISNULL( rs.fnDEF_BQ_Rev_2, 0 ) >  0 THEN  (rs.fnDEF_BQ_Rev_2 /  rs.fnDEF_BQ_Rev_1) *100  END)   as fnPERCENT_DEF_BQ_Rev,
(CASE  
	 WHEN ISNULL( rs.fnDEF_Rev_1, 0 ) = 0  AND ISNULL( rs.fnDEF_Rev_2, 0 ) =  0 THEN  0
	 WHEN ISNULL( rs.fnDEF_Rev_1, 0 ) = 0  AND ISNULL( rs.fnDEF_Rev_2, 0 ) >  0 THEN  100
	 WHEN ISNULL( rs.fnDEF_Rev_1, 0 ) > 0  AND ISNULL( rs.fnDEF_Rev_2, 0 ) >  0 THEN  (rs.fnDEF_Rev_2 /  rs.fnDEF_Rev_1) END)   as fnPERCENT_DEF_Rev, 
(CASE  
	 WHEN ISNULL( rs.fnTEN_BQ_Rev_1, 0 ) = 0  AND ISNULL( rs.fnTEN_BQ_Rev_2, 0 ) =  0 THEN  0
	 WHEN ISNULL( rs.fnTEN_BQ_Rev_1, 0 ) = 0  AND ISNULL( rs.fnTEN_BQ_Rev_2, 0 ) >  0 THEN  100
	 WHEN ISNULL( rs.fnTEN_BQ_Rev_1, 0 ) > 0  AND ISNULL( rs.fnTEN_BQ_Rev_2, 0 ) >  0 THEN  (rs.fnTEN_BQ_Rev_2 /  rs.fnTEN_BQ_Rev_1) *100 END)   as fnPERCENT_TEN_BQ_Rev, 
(CASE  
	 WHEN ISNULL( rs.fnTEN_Rev_1, 0 ) = 0  AND ISNULL( rs.fnTEN_Rev_2, 0 ) =  0 THEN  0
	 WHEN ISNULL( rs.fnTEN_Rev_1, 0 ) = 0  AND ISNULL( rs.fnTEN_Rev_2, 0 ) >  0 THEN  100
	 WHEN ISNULL( rs.fnTEN_Rev_1, 0 ) > 0  AND ISNULL( rs.fnTEN_Rev_2, 0 ) >  0 THEN  (rs.fnTEN_Rev_2 /  rs.fnTEN_Rev_1) END)   as fnPERCENT_TEN_Rev,
(CASE  
	 WHEN ISNULL( rs.fnTOTAL_CXLD_1, 0 ) = 0  AND ISNULL( rs.fnTOTAL_CXLD_2, 0 ) =  0 THEN  0
	 WHEN ISNULL( rs.fnTOTAL_CXLD_1, 0 ) = 0  AND ISNULL( rs.fnTOTAL_CXLD_2, 0 ) >  0 THEN  100
	 WHEN ISNULL( rs.fnTOTAL_CXLD_1, 0 ) > 0  AND ISNULL( rs.fnTOTAL_CXLD_2, 0 ) >  0 THEN  (rs.fnTOTAL_CXLD_2 /  rs.fnTOTAL_CXLD_1) *100 END)   as fnPERCENT_TOTAL_CXLD

FROM (
	-- GET STATUS, REVENUE OF SAVEDATE1, SAVEDATE2
	select hs_BF.fdSaveDate, hs_BF.fcBookID, hs_BF.fcGuestID, hs_BF.fcOrganization , hs_BF.fcContactPerson, hs_BF.fcSP
	, ( dbo.Get_stringFunctionDate ( hs_BF.fcBookID,'2' ) ) as fcFunctionDate
	, convert ( nvarchar(10),  hs_BF.fdDATE_RECEIVED, 6) as fdDATE_RECEIVED 
	, convert ( nvarchar(10),  hs_BF.fdLAST_DAY_CONTACT, 6) as fdLAST_DAY_CONTACT
	, (select sum(fnFood_Rev) from stHoSo_BanquetForecast   where ( fdSaveDate =  @pdSavedDate1)       and fcBookID = hs_BF.fcBookID ) as fnFood_Rev_1
	, (select sum(fnBev_Revenue) from stHoSo_BanquetForecast   where ( fdSaveDate =  @pdSavedDate1) and  ( month(fdFromDate) = @pnMonth1 )  and (fcBookID = hs_BF.fcBookID) ) as fnBev_Rev_1
	, (select sum(fnMICS_Revenue) from stHoSo_BanquetForecast where ( fdSaveDate =  @pdSavedDate1) and  ( month(fdFromDate) = @pnMonth1 )  and fcBookID = hs_BF.fcBookID )   as fnMICS_Rev_1
	, (select sum(fnDEF_BQ_Rev) from stHoSo_BanquetForecast where ( fdSaveDate =  @pdSavedDate1)    and  ( month(fdFromDate) = @pnMonth1 )  and fcBookID = hs_BF.fcBookID )   as fnDEF_BQ_Rev_1
	, (select sum(fnDEF_Rev) from stHoSo_BanquetForecast where ( fdSaveDate =  @pdSavedDate1)           and  ( month(fdFromDate) = @pnMonth1 )  and fcBookID = hs_BF.fcBookID )   as fnDEF_Rev_1
	, (select sum(fnTEN_BQ_Rev) from stHoSo_BanquetForecast where ( fdSaveDate =  @pdSavedDate1)    and  ( month(fdFromDate) = @pnMonth1 )  and fcBookID = hs_BF.fcBookID )   as fnTEN_BQ_Rev_1
	, (select sum(fnTEN_Rev) from stHoSo_BanquetForecast where ( fdSaveDate =  @pdSavedDate1)           and  ( month(fdFromDate) = @pnMonth1 )  and fcBookID = hs_BF.fcBookID )   as fnTEN_Rev_1
	, (select sum(fnTOTAL_CXLD) from stHoSo_BanquetForecast where ( fdSaveDate =  @pdSavedDate1)    and  ( month(fdFromDate) = @pnMonth1 )  and fcBookID = hs_BF.fcBookID )   as fnTOTAL_CXLD_1
	, isnull( (select distinct fcStatus from stHoSo_BanquetForecast where ( fdSaveDate =  @pdSavedDate1)    and  ( month(fdFromDate) = @pnMonth1 )  and fcBookID = hs_BF.fcBookID )  , 'N') as fcStatus_1
	,(case when hs_BF.fcStatus in ('T', 'P', 'A') then 'T' else hs_BF.fcStatus end ) as fcStatus_2 , 
	sum(hs_BF.fnFood_Rev) as fnFood_Rev_2, 
	sum(hs_BF.fnBev_Revenue) as fnBev_Rev_2, 
	sum(hs_BF.fnMICS_Revenue) as fnMICS_Rev_2, 
	sum(hs_BF.fnDEF_BQ_Rev) as fnDEF_BQ_Rev_2, 
	sum(hs_BF.fnDEF_Rev) as fnDEF_Rev_2, 
	sum(hs_BF.fnTEN_BQ_Rev) as fnTEN_BQ_Rev_2, 
	sum(hs_BF.fnTEN_Rev) as fnTEN_Rev_2, 
	sum(hs_BF.fnTOTAL_CXLD) as fnTOTAL_CXLD_2

	from stHoSo_BanquetForecast hs_BF
	where  ( hs_BF.fdSaveDate  =  @pdSavedDate2 )  and  	 ( month(hs_BF.fdFromDate) = @pnMonth2 )  and 	hs_BF.fcBookID in (
		select distinct one.fcBookID from (
			(select fcBookID , sum (fnDEF_Rev)as fnDEF_Rev, sum(fnTEN_Rev) as fnTEN_Rev, sum(fnToTal_CXLD) as fnToTal_CXLD from stHoSo_BanquetForecast where ( fdSaveDate = @pdSavedDate2) group by fcBookID) ONE
		left join 
			(select fcBookID , sum (fnDEF_Rev)as fnDEF_Rev, sum(fnTEN_Rev) as fnTEN_Rev, sum(fnToTal_CXLD) as fnToTal_CXLD from stHoSo_BanquetForecast where ( fdSaveDate  = @pdSavedDate1) group by fcBookID) MANY
		on one.fcBookID = many.fcBooKID
		) where (many.fnDEF_Rev IS NULL OR one.fnDEF_Rev <> many.fnDEF_Rev)  OR  (many.fnTEN_Rev IS NULL OR one.fnTEN_Rev <> many.fnTEN_Rev) OR (many.fnToTal_CXLD IS NULL OR one.fnToTal_CXLD <> many.fnToTal_CXLD)

	) group by hs_BF.fdSaveDate, hs_BF.fcBookID, hs_BF.fcGuestID, hs_BF.fcOrganization, hs_BF.fcStatus, hs_BF.fcContactPerson,  hs_BF.fcSP, hs_BF.fdDATE_RECEIVED, hs_BF.fdLAST_DAY_CONTACT

) rs ORDER BY rs.fcBookID

/*
NOTE: 
many.fnDEF_Rev IS NULL, many.fnTEN_Rev IS NULL, many.fnToTal_CXLD IS NULL : xay ra trong truong hop LEFT JOIN or RIGHT JOIN
sau khi left join,  ket qua la mot so fieldName cua table NHIEU co gia tri  = NULL=> nghia la record CHI TON TAI trong table MOT ma KHONG TON TAI trong table NHIEU

*/
GO

IF OBJECT_ID('[dbo].[sp_CompareReport_BForecast_byYEAR]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_CompareReport_BForecast_byYEAR]
GO
CREATE PROCEDURE sp_CompareReport_BForecast_byYEAR 
(
	@pcPrevYear nchar(4) ,
	@pcCurrYear nchar(4)  ='',
	@pnMonth int  = 7
)
AS

-- GET TUNG REVENUE CUA NAM TRUOC  VA NAM SAU TRONG CUNG THANG
SELECT *, 

-- GET GIA TRI KHAC NHAU CUA REVENUE GIUA NAM TRUOC  VA NAM SAU TRONG CUNG THANG
	( ISNULL ( B.fnFood_Rev_CUR, 0 )  -  ISNULL(  A.fnFood_Rev_PREV, 0)) AS fnFood_Rev_DIFF, 
	( ISNULL ( B.fnBev_Revenue_CUR, 0) - ISNULL ( A.fnBev_Revenue_PREV, 0)) AS fnBev_Revenue_DIFF, 
	( ISNULL ( B.fnMICS_Revenue_CUR, 0)  - ISNULL ( A.fnMICS_Revenue_PREV, 0) ) AS fnMICS_Revenue_DIFF, 
	( ISNULL ( B.fnDEF_Rev_CUR, 0)  - ISNULL ( A.fnDEF_Rev_PREV, 0) ) AS fnDEF_Rev_DIFF, 
	( ISNULL ( B.fnTEN_Rev_CUR, 0)  - ISNULL ( A.fnTEN_Rev_PREV, 0) ) AS fnTEN_Rev_DIFF, 

	( ISNULL ( B.fnTOTAL_CXLD_CUR, 0)  - ISNULL ( A.fnTOTAL_CXLD_PREV, 0) ) AS fnTOTAL_CXLD_DIFF, 
	( ISNULL ( B.fnDEF_BQ_Rev_CUR, 0)  - ISNULL ( A.fnDEF_BQ_Rev_PREV, 0) ) AS fnDEF_BQ_Rev_DIFF, 
	( ISNULL ( B.fnTEN_BQ_Rev_CUR, 0)  - ISNULL ( A.fnTEN_BQ_Rev_PREV, 0) ) AS fnTEN_BQ_Rev_DIFF,

-- GET GIA TRI PHAN TRAM CUA REVENUE GIUA NAM TRUOC  VA NAM SAU TRONG CUNG THANG
(CASE  
	 WHEN ( ISNULL( A.fnFood_Rev_PREV, 0 ) > 0  or  ISNULL( A.fnFood_Rev_PREV, 0 ) = 0 ) AND ISNULL( B.fnFood_Rev_CUR, 0 ) =  0 THEN  0
	 WHEN   ISNULL( A.fnFood_Rev_PREV, 0 ) = 0  AND ISNULL( B.fnFood_Rev_CUR, 0 ) >  0 THEN  100
	 WHEN   ISNULL( A.fnFood_Rev_PREV, 0 ) > 0  AND ISNULL( B.fnFood_Rev_CUR, 0 ) >  0 THEN  (B.fnFood_Rev_CUR/ A.fnFood_Rev_PREV  ) *100  END)   as fnPERCENT_Food_Rev, 

(CASE  
	 WHEN ( ISNULL( A.fnBev_Revenue_PREV, 0 ) > 0  or  ISNULL( A.fnBev_Revenue_PREV, 0 ) = 0 )  AND ISNULL( B.fnBev_Revenue_CUR, 0 ) =  0 THEN  0
	 WHEN   ISNULL( A.fnBev_Revenue_PREV, 0 ) = 0  AND ISNULL( B.fnBev_Revenue_CUR, 0 ) >  0 THEN  100
	 WHEN   ISNULL( A.fnBev_Revenue_PREV, 0 ) > 0  AND ISNULL( B.fnBev_Revenue_CUR, 0 ) >  0 THEN  ( B.fnBev_Revenue_CUR/  A.fnBev_Revenue_PREV ) *100  END)   as fnPERCENT_Bev_Rev, 

(CASE  
	 WHEN ( ISNULL( A.fnMICS_Revenue_PREV, 0 ) > 0  or  ISNULL( A.fnMICS_Revenue_PREV, 0 ) = 0 )  AND ISNULL( B.fnMICS_Revenue_CUR, 0 ) =  0 THEN  0
	 WHEN   ISNULL( A.fnMICS_Revenue_PREV, 0 ) = 0  AND ISNULL( B.fnMICS_Revenue_CUR, 0 ) >  0 THEN  100
	 WHEN   ISNULL( A.fnMICS_Revenue_PREV, 0 ) > 0  AND ISNULL( B.fnMICS_Revenue_CUR, 0 ) >  0 THEN  ( B.fnMICS_Revenue_CUR / A.fnMICS_Revenue_PREV  ) *100  END)   as fnPERCENT_MICS_Rev, 

(CASE  
	 WHEN ( ISNULL( A.fnDEF_BQ_Rev_PREV, 0 ) > 0  or  ISNULL( A.fnDEF_BQ_Rev_PREV, 0 ) = 0 )  AND ISNULL( B.fnDEF_BQ_Rev_CUR, 0 ) =  0 THEN  0
	 WHEN   ISNULL( A.fnDEF_BQ_Rev_PREV, 0 ) = 0  AND ISNULL( B.fnDEF_BQ_Rev_CUR, 0 ) >  0 THEN  100
	 WHEN   ISNULL( A.fnDEF_BQ_Rev_PREV, 0 ) > 0  AND ISNULL( B.fnDEF_BQ_Rev_CUR, 0 ) >  0 THEN  (  B.fnDEF_BQ_Rev_CUR / A.fnDEF_BQ_Rev_PREV ) *100  END)   as fnPERCENT_DEF_BQ_Rev, 

(CASE  
	 WHEN ( ISNULL( A.fnDEF_Rev_PREV, 0 ) > 0  or  ISNULL( A.fnDEF_Rev_PREV, 0 ) = 0 )  AND ISNULL( B.fnDEF_Rev_CUR, 0 ) =  0 THEN  0
	 WHEN   ISNULL( A.fnDEF_Rev_PREV, 0 ) = 0  AND ISNULL( B.fnDEF_Rev_CUR, 0 ) >  0 THEN  100
	 WHEN   ISNULL( A.fnDEF_Rev_PREV, 0 ) > 0  AND ISNULL( B.fnDEF_Rev_CUR, 0 ) >  0 THEN  ( B.fnDEF_Rev_CUR /A.fnDEF_Rev_PREV  ) *100  END)   as fnPERCENT_DEF_Rev,

(CASE  
	 WHEN ( ISNULL( A.fnTEN_BQ_Rev_PREV, 0 ) > 0  or  ISNULL( A.fnTEN_BQ_Rev_PREV, 0 ) = 0 )  AND ISNULL( B.fnTEN_BQ_Rev_CUR, 0 ) =  0 THEN  0
	 WHEN   ISNULL( A.fnTEN_BQ_Rev_PREV, 0 ) = 0  AND ISNULL( B.fnTEN_BQ_Rev_CUR, 0 ) >  0 THEN  100
	 WHEN   ISNULL( A.fnTEN_BQ_Rev_PREV, 0 ) > 0  AND ISNULL( B.fnTEN_BQ_Rev_CUR, 0 ) >  0 THEN  ( B.fnTEN_BQ_Rev_CUR /A.fnTEN_BQ_Rev_PREV  ) *100  END)   as fnPERCENT_TEN_BQ_Rev,

(CASE  
	 WHEN ( ISNULL( A.fnTEN_Rev_PREV, 0 ) > 0  or  ISNULL( A.fnTEN_Rev_PREV, 0 ) = 0 )  AND ISNULL( B.fnTEN_Rev_CUR, 0 ) =  0 THEN  0
	 WHEN   ISNULL( A.fnTEN_Rev_PREV, 0 ) = 0  AND ISNULL( B.fnTEN_Rev_CUR, 0 ) >  0 THEN  100
	 WHEN   ISNULL( A.fnTEN_Rev_PREV, 0 ) > 0  AND ISNULL( B.fnTEN_Rev_CUR, 0 ) >  0 THEN  (B.fnTEN_Rev_CUR /A.fnTEN_Rev_PREV  ) *100  END)   as fnPERCENT_TEN_Rev, 

(CASE  
	 WHEN ( ISNULL( A.fnTOTAL_CXLD_PREV, 0 ) > 0  or  ISNULL( A.fnTOTAL_CXLD_PREV, 0 ) = 0 )  AND ISNULL( B.fnTOTAL_CXLD_CUR, 0 ) =  0 THEN  0
	 WHEN   ISNULL( A.fnTOTAL_CXLD_PREV, 0 ) = 0  AND ISNULL( B.fnTOTAL_CXLD_CUR, 0 ) >  0 THEN  100
	 WHEN   ISNULL( A.fnTOTAL_CXLD_PREV, 0 ) > 0  AND ISNULL( B.fnTOTAL_CXLD_CUR, 0 ) >  0 THEN  (B.fnTOTAL_CXLD_CUR /A.fnTOTAL_CXLD_PREV  ) *100  END)   as fnPERCENT_TOTAL_CXLD


 FROM  (

	( SELECT  * FROM stMonth M 
	LEFT JOIN
		(SELECT    month(bf.fdDate) as fcMonth_PREV,
		isnull(sum(case when dt.fcgroup in ('01') then fnAmount else 0 end ),0) as fnFood_Rev_PREV,
		isnull(sum(case when dt.fcgroup in ('02') then fnAmount else 0 end ),0) as fnBev_Revenue_PREV,
		isnull(sum(case when dt.fcgroup  in ('03') then fnAmount else 0 end), 0) as fnMICS_Revenue_PREV,
		isnull(sum(case when bk.fcStatus_BkRoom  = 'D' then fnAmount else 0 end ),0) as  fnDEF_Rev_PREV, 
		isnull(sum(case when bk.fcStatus_BkRoom in ('T','P', 'A') then fnAmount else 0 end ),0)  as  fnTEN_Rev_PREV,
		isnull(sum(case when bk.fcStatus_BkRoom = 'C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD_PREV,
		isnull(sum(case when bk.fcStatus_BkRoom  = 'D' then fnAmount else 0 end ),0)  - cast(  isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom ='D' then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)  as decimal )  as  fnDEF_BQ_Rev_PREV,
		isnull(sum(case when bk.fcStatus_BkRoom  in ('T', 'P', 'A') then fnAmount else 0 end ),0)  - cast( isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom in ('A', 'T', 'P') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as decimal)  as  fnTEN_BQ_Rev_PREV

		FROM stBOOKING bk 
		left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
		left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
		left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
		left join stKhachHang kh on kh.fcMa= bk.fcGuestID
		WHERE ( year(bf.fdDate) = @pcPrevYear) and (@pnMonth = '' or  month(bf.fdDate) =  @pnMonth)
		GROUP BY   month(bf.fdDate) , year(bf.fdDate)
	) N  ON M.fnmonth = N.fcMonth_PREV

) A  INNER  JOIN 

	( SELECT * FROM stmonth M 
	LEFT JOIN
		(SELECT  month(bf.fdDate) as fcMonth_CUR,
		isnull(sum(case when dt.fcgroup in ('01') then fnAmount else 0 end ),0) as fnFood_Rev_CUR,
		isnull(sum(case when dt.fcgroup in ('02') then fnAmount else 0 end ),0) as fnBev_Revenue_CUR,
		isnull(sum(case when dt.fcgroup  in ('03') then fnAmount else 0 end), 0) as fnMICS_Revenue_CUR,
		isnull(sum(case when bk.fcStatus_BkRoom  = 'D' then fnAmount else 0 end ),0) as  fnDEF_Rev_CUR, 
		isnull(sum(case when bk.fcStatus_BkRoom in ('T','P', 'A') then fnAmount else 0 end ),0)  as  fnTEN_Rev_CUR,
		isnull(sum(case when bk.fcStatus_BkRoom = 'C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD_CUR,
		isnull(sum(case when bk.fcStatus_BkRoom  = 'D' then fnAmount else 0 end ),0)  - cast(  isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom ='D' then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)  as decimal )  as  fnDEF_BQ_Rev_CUR,
		isnull(sum(case when bk.fcStatus_BkRoom  in ('T', 'P', 'A') then fnAmount else 0 end ),0)  - cast( isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom in ('A', 'T', 'P') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as decimal)  as  fnTEN_BQ_Rev_CUR

		FROM stBOOKING bk 
		left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
		left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
		left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
		left join stKhachHang kh on kh.fcMa= bk.fcGuestID
		WHERE ( year(bf.fdDate) = @pcCurrYear) and (@pnMonth = '' or  month(bf.fdDate) =  @pnMonth)
		GROUP BY   month(bf.fdDate) , year(bf.fdDate)
	) N  ON M.fnmonth = N.fcmonth_cur

) B ON A.fnMonth = B.fnMonth

) ORDER BY  B.fnMonth
GO

IF OBJECT_ID('[dbo].[sp_CompareReport_DemSoLanLuu_XoaLanLuuDauTien]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_CompareReport_DemSoLanLuu_XoaLanLuuDauTien]
GO
CREATE PROCEDURE sp_CompareReport_DemSoLanLuu_XoaLanLuuDauTien 
	@pcType nchar(1) = '1'	--1: Dem so lan luu; 2: Tim lan luu dau tien;  3: Xoa lan luu dau tien
AS

if @pcType = '1'
BEGIN
	SELECT DISTINCT fdSaveDate FROM stHoSo_BanquetForecast ORDER BY fdSaveDate DESC
END

if @pcType = '2'
BEGIN 
	SELECT DISTINCT top 1 fdSaveDate  FROM stHoSo_BanquetForecast order by fdSaveDate 
END

if @pcType = '3'
BEGIN 
	DELETE  stHoSo_BanquetForecast WHERE fdSaveDate in (select top 1 fdSaveDate from stHoSo_BanquetForecast order by fdSaveDate )
END
GO

IF OBJECT_ID('[dbo].[sp_CompareReport_InitReportDate_inLookup]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_CompareReport_InitReportDate_inLookup]
GO
--Create 29/06/2007
-- Khoi tao du lieu len 2 lookup so sanh ngay da luu bao cao
CREATE PROCEDURE sp_CompareReport_InitReportDate_inLookup 
(
	@pcReportDate nchar(1) = '1'
)
AS

if @pcReportDate = '1'   -- Dung cho lan luu truoc: lan bao cao truoc
BEGIN
	select distinct fdSaveDate,  datename(month, fdFromDate ) as fcMonthName , month(fdFromDate) as fcMonth from stHoSo_BanquetForecast  WHERE fdSaveDate not in (select max( fdsaveDate) as fdSaveDate from stHoSo_BanquetForecast ) order by fdSaveDate, fcMonth
	--select distinct fdSaveDate, datename(month, fdFromDate ) as fcMonthName, month(fdFromDate) as fcMonth from stHoSo_BanquetForecast ORDER BY fdSaveDate, fcMonth
END

if @pcReportDate = '2'  -- -- Dung cho lan luu sau cung: lan bao cao hien hanh
BEGIN

	select  distinct a.fdSaveDate, b.fcMonthName, b.fcMonth from (
		(select max( fdsaveDate) as fdSaveDate from stHoSo_BanquetForecast ) a
	inner join 
		(select distinct fdSaveDate, datename(month, fdFromDate ) as fcMonthName, month(fdFromDate) as fcMonth from stHoSo_BanquetForecast ) b
	on a.fdSaveDate = b.fdSaveDate
	) order by fcMonth

--	select distinct fdSaveDate, datename(month, fdFromDate ) as fcMonthName, month(fdFromDate) as fcMonth from stHoSo_BanquetForecast ORDER BY fdSaveDate, fcMonth
END
-- select tat ca saveDate, Month cho ca 2 lookup
-- select distinct fdSaveDate, datename(month, fdFromDate ) as fcMonthName, month(fdFromDate) as fcMonth from stHoSo_BanquetForecast ORDER BY fdSaveDate, fcMonth
GO

IF OBJECT_ID('[dbo].[sp_CompareReport_kiemtraDaLuuRoi]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_CompareReport_kiemtraDaLuuRoi]
GO
--Create 29/06/2007
--Kiem Tra Da Luu Bo (SaveDate, FromDate, ToDate) roi
CREATE PROCEDURE sp_CompareReport_kiemtraDaLuuRoi 
(
	@pcSaveDate nvarchar(10),
	@pnReportMonth int

)

AS
/*
set dateformat dmy
declare @pdFromDate smalldatetime
declare @pdToDate smalldatetime
set @pdFromDate = cast (@pcFromDate as smalldatetime)
set @pdToDate = cast (@pcToDate as smalldatetime)
*/
select distinct fdSaveDate, fdFromDate, fdToDate from stHoSo_BanquetForecast  
where convert(nvarchar(10),fdSaveDate, 103) = @pcSaveDate
and  (month(fdFromDate) = @pnReportMonth)
GO

IF OBJECT_ID('[dbo].[sp_Create_BEO_from_BookingData]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Create_BEO_from_BookingData]
GO
CREATE PROCEDURE [dbo].[sp_Create_BEO_from_BookingData]
(
		@pDateCurrent nvarchar(20)
)
 AS
--set dateformat dmy
set dateformat mdy
declare @dCurrentDate smalldatetime
set @dCurrentDate = cast (@pDateCurrent as smalldatetime)


select distinct bk.fcBookID,bs.fcName as fcBookState, bk.fcGuestID, kh.fcTen as fcTenKH ,bk.fcContactPerson,   u.fcFullName , bk.fcUser, 
(dbo.Get_stringFunctionDate(bk.fcBookID,'0')) as fcFunctionDate
, bk.fnDatCoc, bk.fdDepositDate, bk.fcDepositNote, bk.fcTienTe, bk.fnTyGia -- them deposit
from stBooking bk  
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID 
left  join stKhachHang kh on bk.fcGuestID = kh.fcMa 
left  join stUser u on bk.fcUser= u.fcUserName 
left  join stBooking_Status bs on bs.fcCode= bk.fcStatus_BkRoom
where (fcStatus_BkRoom  ='D' ) -- AND (bf.fdDate >=  @dCurrentDate) --***** CHI LAY NHUNG BOOKING TU NGAY HIEN TAI CHO DEN TUONG LAI DE LAP BEO
AND (bk.fcBookID not in (select fcBookID from stMaster_EO) )
Order by bk.fcBookID
GO

IF OBJECT_ID('[dbo].[sp_Customer_List]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Customer_List]
GO
create proc sp_Customer_List
as
set dateformat mdy
select fcten as fcOrganization,fcTenNLH as fcContactPerson,l.fcTelephone,l.fcPhone_Office,l.fcPhone_Home,l.fcEmail
from stKhachHang k inner join stKhachHang_NguoiLH l on k.fcMa=l.fcKhachHang_ID
GO

IF OBJECT_ID('[dbo].[sp_DieuKienBatBuoc_KhiDatPhong]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_DieuKienBatBuoc_KhiDatPhong]
GO
CREATE PROCEDURE sp_DieuKienBatBuoc_KhiDatPhong
(
	@pcFunctionRoom nvarchar(20)='',
	@pcTimeIn nvarchar(10)='',
	@pcTimeOut nvarchar(10)=''

--	@pcDistanceTime nvarchar(8)= '01:00:00'
)
 AS

--set dateformat dmy
set dateformat mdy
declare @pdTimeIn datetime
declare @pdTimeOut datetime
set @pdTimeIn = cast(@pcTimeIn as datetime) - '01:00'
set @pdTimeOut = cast(@pcTimeOut as datetime) - '01:00'

SELECT *, @pdTimeIn, @pdTimeOut from stBookFunctionRoom where fcFunctionRoom = '02' 
and ((@pdTimeIn  < fdTimeIn  and @pdTimeOut  > fdTimeIn) or (@pdTimeIn  < fdTimeOut  and @pdTimeOut  > fdTimeOut))



/*
-- GIA SU TA DA DAT TRUOC 2 SU KIEN 1 & 2 ROI; BAI TOAN: TIM KHOANG THOI GIAN CHO PHEP DE DATSU KIEN_3 VAO GIUA KHOANG THOI GIAN CUA SUKIEN1 VA SU KIEN2
-- Qui dinh: TimeIn cua su kien KE sau > TimeOut cua su kien ke truoc + 1h tren cung 1 functionRoom

--*************BUOC 1: Tim thoi gian timeOut cua SU KIEN 1 ( KE TRUOC SU KIEN SE DAT- SUKIEN_3) ; va tim cẬn an toan de dat su kien tiep theo trong cung FunctionRoom; 

select fcFunctionRoom, max(cast(fdTimeOut AS smalldatetime)) as fdTimeOut, max(cast(fdTimeOut AS smalldatetime) + '01:00:00') as 'CanTren' from stBookFunctionRoom
where fcFunctionRoom='02'
group by fcFunctionRoom 

--************* Tim thoi gian timeIn cua SU KIEN 2 (KE SAU SU KIEN SE DAT- SUKIEN_3); va tim cẬn an toan de dat su kien KẾ TRƯỚC SUKIEN_2 trong cung FunctionRoom; 
select fcFunctionRoom, max(cast(fdTimeIN AS smalldatetime)) as fdTimeIN, max(cast(fdTimeIN AS smalldatetime) - '01:00:00') as 'CanDuoi' from stBookFunctionRoom
where fcFunctionRoom='02'
group by fcFunctionRoom
*/
GO

IF OBJECT_ID('[dbo].[sp_DsachPhong_chuaCharges]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_DsachPhong_chuaCharges]
GO
CREATE PROCEDURE dbo.sp_DsachPhong_chuaCharges
(
	@pcFromDate nvarchar(10),
	@pcToDate nvarchar(10)
)	
 AS
--set dateformat dmy
set dateformat mdy
declare  @pdFromDate smalldatetime
declare  @pdToDate smalldatetime
set @pdFromDate = cast (@pcFromDate  as smalldatetime )
set @pdToDate = cast (@pcToDate as smalldatetime )

	SELECT  bk.fcBookid, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate 
	, sk.fcTen as fcFunctionType , bk.fcStatus_BkRoom as fcStatus
	, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson 
	, p.fcLoaiPhong
	, dbo.GetNames_Booking('', '',  bf.fdTimeIn, bf.fdTimeOut,bk.fcBookID, p.fcLoaiPhong) as fcFunctionRoom_Code
	, dbo.fDefind(dbo.GetNames_Booking('', '',  bf.fdTimeIn, bf.fdTimeOut,bk.fcBookID, p.fcLoaiPhong)) as fcFunctionRoom
	, isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015') then bc.fnQuantity else 0 end ),0) as fnGUA
	, bk.fnEXP 
	, convert( nvarchar(5), bf.fdTimeIn, 8)   as fcTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fcTimeOut 
	, cast ( datediff (mi, bf.fdTimeIn, bf.fdTimeOut) as decimal) / 60  as fnSoGioDat
	, bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
	, isnull(sum(case when bk.fcStatus_BkRoom  = 'D' then fnAmount else 0 end ),0) as  fnDEF_Rev
	, isnull(sum(case when bk.fcStatus_BkRoom  = 'D' then fnAmount else 0 end ),0)  - cast(  isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom ='D' then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)  as decimal )  as  fnDEF_BQ_Rev

	FROM stbOOKING bk
		left join stKhachHang kh on kh.fcMa= bk.fcGuestID		
		left  join stBookFunctionRoom bf on bk.fcBookid = bf.fcBookid
		left join stSukien sk on sk.fcMa= bf.fcFunctionType
		left  join stBooking_Charges bc on bf.fcBookid = bc.fcBookid and  bf.fnCodeID = bc.fnCodeID
		left  join stPhong p on p.fcMa= bf.fcFunctionRoom
	WHERE ( bk.fcStatus_BkRoom <>'C' )  and (bf.fdDate  between @pdFromDate and @pdToDate)
	GROUP BY bk.fcBookid, bf.fdDate, p.fcLoaiPhong, kh.fcMa, kh.fcTen, kh.fcMaNLH, bk.fcContactPerson
	, bk.fcStatus_BkRoom, sk.fcTen , bk.fnEXP, bk.fcUser , bk.fdDate , bk.fdDateConfirm 
	, bf.fdTimeIn, bf.fdTimeOut

	HAVING not (p.fcLoaiPhong  in('08', '09')  and isnull(sum(bc.fnQuantity), 0 )  <= 0) 
	AND isnull(sum( isnull (fnAmount, 0) ),0) = 0
GO

IF OBJECT_ID('[dbo].[sp_Find_LEISURE]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Find_LEISURE]
GO
-- Create 24/07/2007

CREATE proc sp_Find_LEISURE
(
	@pcFromDate as nvarchar(10),
	@pcToDate as nvarchar(10),
	@User as nvarchar(20)='',
	@CurrentDate as nvarchar(10)=''
)
as
--set dateformat dmy
set dateformat mdy
declare @pdFromDate smalldatetime
declare @pdToDate smalldatetime
select @pdFromDate = cast(@pcFromDate as SMALLdatetime)
select @pdToDate = cast(@pcToDate  as smalldatetime)


	select a.fcBookID , convert(nvarchar(10), a.fdDate , 6) as fdBookDate, convert(nvarchar(10), a.fdDateConfirm,  6) as fdDateConfirm , a1.fcTen, a.fcUser, a.fcStatus_BkRoom, 
	(case a.fcContactPerson when '' then a1.fcNguoiLienHe else a.fcContactPerson end ) as fcContactPerson , 
	a1.fcTelephone, a1.fcEmail,a1.fcFax,a1.fcDiaChi
	, (Select fcFullName from stUser Where fcUserName=a.fcUser) as fcPrepareBy
	, (Select fcName From stBooking_Status Where fcCode = a.fcStatus_BkRoom) as fcStatusBook
	, (case a.fcBookID When m.fcBookID then m.fcGroupName else '' end) as fcGroupName
-- get Min (CheckIn) and Max(CheckOut)
	, case  when month(fdCheckIn)=month(fdCheckOut) then (select  substring(convert(nvarchar(2), min(fdcheckin), 6) ,1,10)+'-' + convert(nvarchar(11), max(fdcheckOut), 6)    from stBooking_MICE  where fcbookid = a.fcBookID  )
	else (select  convert(nvarchar(11), min(fdcheckin), 6) + ';  ' + convert(nvarchar(11), max(fdcheckOut), 6)    from stBooking_MICE  where fcbookid = a.fcBookID  ) end as fcIn_Out

	
	from stBooking a  
	left join stKhachHang a1 on a.fcGuestID = a1.fcMa
	left join stBooking_MICE m on a.fcBookID=m.fcBookID
	--Where (a.fbMICE = 'L') and (@User='' or a.fcUser=@User)   AND (m.fdCheckIn between @pdFromDate and @pdToDate OR m.fdCheckOut  between @pdFromDate and @pdToDate)
	Where (a.fbMICE = 'L')    AND (m.fdCheckIn between @pdFromDate and @pdToDate OR m.fdCheckOut  between @pdFromDate and @pdToDate)
	 -- and ( @CurrentDate='' or a.fdDateConfirm<@CurrentDate ) 
	group by a.fcBookID,a.fdDate, a.fdDateConfirm, a1.fcTen, a1.fcNguoiLienhe, a.fcContactPerson, a1.fcTelephone, a1.fcEmail, a1.fcFax, a1.fcDiaChi, 
	a.fcUser, a.fcStatus_BkRoom,  m.fcGroupName, m.fcBookID, month(fdCheckIn), month(fdCheckOut)
	Order by  a1.fcTen
GO

IF OBJECT_ID('[dbo].[sp_Get_NumDay_ofMonth]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Get_NumDay_ofMonth]
GO
CREATE PROCEDURE sp_Get_NumDay_ofMonth 
(	
	@pcDate nvarchar(10)
)
AS
--set dateformat dmy
set dateformat mdy

declare @pdDate smalldatetime
set @pdDate = cast (@pcDate as smalldatetime)


select  cast(month(@pdDate)  as nvarchar(2)) fcMonth,  cast ( day(dateadd(day, -1, dateadd(month, 1, dateadd(day, -(day(@pdDate) - 1), @pdDate)))) as nvarchar(10)) as fnNoDays-- => return 28
GO

IF OBJECT_ID('[dbo].[sp_GetDateDiff]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_GetDateDiff]
GO
CREATE PROCEDURE sp_GetDateDiff(
@date smalldatetime,
@dateNumber int = 0
)
as
--set dateformat dmy
set dateformat mdy
select dateadd(d, @dateNumber, @date)
GO

IF OBJECT_ID('[dbo].[sp_KiemTraTrungBooking_BEO]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_KiemTraTrungBooking_BEO]
GO
CREATE PROCEDURE sp_KiemTraTrungBooking_BEO 
(
	@pcFromDate nvarchar(10) ,
	@pcToDate nvarchar(10),
	@Call char(1) = '0'
)

AS
--set dateformat dmy
set dateformat mdy
declare @pdFromDate smalldatetime,  @pdToDate smalldatetime
set @pdFromDate = cast ( @pcFromDate as  smalldatetime)
set @pdToDate = cast ( @pcToDate as smalldatetime)


if @Call = '0'
BEGIN 
	select fdDate, fcFunctionRoom , No_repeat from (
		select bf.fdDate,  bf.fcFunctionRoom, sum(1) as 'No_repeat' from stBookFunctionRoom bf 
		inner join stBooking b on bf.fcBookID = b.fcbookID 
		where b.fcBookID not in (select fcBookID from stMaster_EO) and  b.fcStatus_BkRoom <> 'C'
		group by bf.fdDate, bf.fcFunctionRoom
		having sum(1) > 1
	union all
		select l.fdEventDate, rs.fcRoom , sum(1) from stRoom_Setup rs inner join stSKLK  l on rs.fcOrderNo = l.fcOrderNo 
		where l.fcTrangThai not in ( 'C', 'R')
		group by l.fdEventDate, rs.fcRoom
		having sum(1) > 1
	)Repeat_Booking_BEO 
	WHERE (fdDate between @pdFromDate and @pdToDate)
	order by fdDate, fcFunctionRoom
END

if @Call = '1'
BEGIN 
	select  fdDate, fdTimeIn, fdTimeOut, stPhong.fcTen as fcRoomName,  fcFunctionRoom, fcUser, fnCodeID,fcMaster_Code,  fcStatus from (
		select  bf.fdDate, bf.fdTimeIn, bf.fdTimeOut, bf.fcFunctionRoom,  b.fcUser, bf.fnCodeID as fnCodeID, bf.fcBookID as fcMaster_Code, s.fcName  as fcStatus from stBookFunctionRoom bf 
		inner join stBooking b on bf.fcBookID = b.fcbookID 
		inner join stBooking_Status s on b.fcStatus_BkRoom = s.fcCode
		where b.fcBookID not in (select fcBookID from stMaster_EO) and  b.fcStatus_BkRoom <> 'C'
	union all
		select  l.fdEventDate, rs.fdTimeIn, rs.fdTimeOut, rs.fcRoom, l.fcNguoiNhap, rs.fnCodeID, rs.fcOrderNo , s.fcTen from stRoom_Setup rs 
		inner join stSKLK  l on rs.fcOrderNo = l.fcOrderNo 
		inner join stSK_TrangThai s on l.fcTrangThai = s.fcMa
		where l.fcTrangThai not  in  ( 'C', 'R')
	)All_Booking_BEO inner join stPhong  on All_Booking_BEO.fcFunctionRoom = stPhong.fcMa 
	WHERE (fdDate between @pdFromDate and @pdToDate)	
	order by fdDate, fcFunctionRoom
END
GO

IF OBJECT_ID('[dbo].[SP_LEISURE_REPORT]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[SP_LEISURE_REPORT]
GO
-- Create 23/07/2007
-- NOTE:  
	--1.  Bao cao nay la ban  copy cua  SP_MICE_REPORT,  
	--2.  Bao cao SP_MICE_REPORT VA SP_LEISURE_REPORT chi KHAC NHAU o dieu kien sau
	--3. SP_MICE_REPORT co dieu kien (bk.fbMICE <> 'L')
	--4. SP_LEISURE_REPORT  co dieu kien (bk.fbMICE = 'L')

CREATE PROCEDURE SP_LEISURE_REPORT
(
	@pcFromDate  nvarchar(10), 
	@pcToDate  nvarchar(10),
	@pcCall  char(1)  ='0'
)
AS
--set dateformat dmy
set dateformat mdy
declare @pdFromDate  smalldatetime
declare @pdToDate smalldatetime
select @pdFromDate = cast(@pcFromDate as smalldatetime)
select @pdToDate = cast(@pcToDate as smalldatetime)

if @pcCall  = '0'
-- Note:- khong duoc thay doi thu tu cac fieldname trong cau select cua @pcCall  = '0'
--           

SELECT DISTINCT convert(nvarchar(6), fdDATE_RECEIVED, 6) as  fcDATE_RECEIVED, convert(nvarchar(6), fdLAST_DAY_CONTACT, 6) as  fcLAST_DAY_CONTACT, fcCompany, fcSaleManager, fcGroupName,
-- GET MIN(fdCheckIn) va MAX(fdCheckOut)
		 (SELECT CASE  WHEN  month( min(fdCheckIn) ) = month( max( fdCheckOut) ) 
		  THEN 	(select  substring(convert(nvarchar(2), min(fdcheckin), 6) ,1,10)+'-' + convert(nvarchar(11), max(fdcheckOut), 6)    from stBooking_MICE  where fcbookid = AllMonth.FCBOOKID)
		  ELSE  (select  convert(nvarchar(11), min(fdcheckin), 6) + ';  ' + convert(nvarchar(11), max(fdcheckOut), 6)    from stBooking_MICE  where fcbookid =  AllMonth.FCBOOKID )
		  END  FROM stBooking_MICE WHERE FCBOOKID = AllMonth.FCBOOKID ) AS fcIn_Out
,  fcStatus_BkRoom, fcStatusName, fcMonth, fcMonthName, fnRates,fnRates1,cast(0  as decimal) AS fnRevenue, 0 AS fnTotal, fcRemark,  fcBookID 
FROM  (

	select distinct bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,  kh.fcTen as fcCompany, bm.fcSaleManager, bm.fcGroupName,
	(case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_BkRoom,    
	UPPER(case when bs.fcName in('Tentative','Agreement','Proposal') then 'Tentative' else bs.fcName end) as fcStatusName, 
	UPPER( datename(month, bm.fdCheckIn )) as fcMonthName,  convert(nvarchar(6), bm.fdCheckIn, 112) as fcMonth
	, cast ( (select top 1 fnRoomRates from stBooking_MICE where fcBookID =bk.fcBookID order by fnNo_Of_Room desc )  as nvarchar(10))  + '++' as fnRates,
 	(select top 1 fnRoomRates from stBooking_MICE where fcBookID =bk.fcBookID order by fnNo_Of_Room desc )   as fnRates1,
	cast(bm.fcNotes as varchar(8000)) as fcRemark, 
	max(bm.fnNo_Of_Room) as fnMax_No_Of_Room, 	bk.fcBookID
	from stBooking bk 
	left join stBooking_MICE bm on bk.fcBookID= bm.fcBookID
	left join stKhachHang kh on kh.fcMa= bk.fcGuestID
	left join stBooking_Status bs on bs.fcCode =  bk.fcStatus_BkRoom
             where ((bm.fdCheckIn between  @pdFromDate and @pdToDate) or (bm.fdCheckOut between  @pdFromDate and @pdToDate) ) AND (bk.fbMICE = 'L')
	group by bk.fcBookID, convert(nvarchar(6), bm.fdCheckIn, 112),  UPPER( datename(month, bm.fdCheckIn )), 
	 bk.fcStatus_BkRoom , bs.fcName,  kh.fcTen , bm.fcSaleManager,bm.fcGroupName,  bk.fdDate, bk.fdDateConfirm , cast(bm.fcNotes as varchar(8000))

UNION ALL
	select distinct  bk.fdDate,  bk.fdDateConfirm ,  kh.fcTen as fcCompany, bm.fcSaleManager, bm.fcGroupName, 
	-- bk.fcStatus_BkRoom, UPPER(bs.fcName) as fcStatusName,  
	(case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_BkRoom,    
	UPPER(case when bs.fcName in('Tentative','Agreement','Proposal') then 'Tentative' else bs.fcName end) as fcStatusName, 
	UPPER( datename(month,bm.fdCheckOut )) as fcMonthName,  convert(nvarchar(6), bm.fdCheckOut, 112) as fcMonth
	, cast ( (select top 1 fnRoomRates from stBooking_MICE where fcBookID =bk.fcBookID order by fnNo_Of_Room desc )  as nvarchar(10))  + '++' as fnRates, 	
	(select top 1 fnRoomRates from stBooking_MICE where fcBookID =bk.fcBookID order by fnNo_Of_Room desc )   as fnRates1,	
	cast(bm.fcNotes as varchar(8000)) as fcRemark, 
	max(bm.fnNo_Of_Room) as fnMax_No_Of_Room, 	bk.fcBookID
	from stBooking bk 
	left join  stBooking_MICE bm  on bk.fcBookID= bm.fcBookID
	left join stKhachHang kh on kh.fcMa= bk.fcGuestID
	left join stBooking_Status bs on bs.fcCode =  bk.fcStatus_BkRoom
	where ((bm.fdCheckIn between  @pdFromDate and @pdToDate) or (bm.fdCheckOut between  @pdFromDate and @pdToDate) ) AND (bk.fbMICE = 'L')
	group by bk.fcBookID, convert(nvarchar(6), bm.fdCheckOut, 112),  UPPER( datename(month, bm.fdCheckOut )), 
	 bk.fcStatus_BkRoom , bs.fcName, kh.fcTen ,bm.fcSaleManager, bm.fcGroupName,  bk.fdDate, bk.fdDateConfirm ,cast(bm.fcNotes as varchar(8000))
) AllMonth 
WHERE  (cast (fcMonth as int) between cast( convert(nvarchar(6), @pdFromDate, 112) as int) and  cast(convert(nvarchar(6), @pdToDate, 112) as int) )
ORDER BY  fcMonth, fcIn_Out


if @pcCall  = '1'
BEGIN	
SELECT distinct fcBookID, fcMonth, fcMiceID, fdCheckIn, fdCheckOut, fnRoomRates, fnNo_Of_Room
FROM (
	select  bk.fcBookID,  convert(nvarchar(6), bm.fdCheckIn, 112) as fcMonth,   fcMiceID,  bm.fdCheckIn, bm.fdCheckOut, bm.fnRoomRates, bm.fnNo_Of_Room 
	from stBooking bk
	left  join stBooking_MICE bm  on bk.fcBookID= bm.fcBookID
	left  join stKhachHang kh on kh.fcMa= bk.fcGuestID
	left  join stBooking_Status bs on bs.fcCode =  bk.fcStatus_BkRoom
	where (( bm.fdCheckIn between  @pdFromDate and @pdToDate) or (bm.fdCheckOut between  @pdFromDate and @pdToDate) ) AND (bk.fbMICE =  'L')
UNION ALL
	select  bk.fcBookID, convert(nvarchar(6), bm.fdCheckOut, 112) as fcMonth,  fcMiceID,  bm.fdCheckIn, bm.fdCheckOut, bm.fnRoomRates, bm.fnNo_Of_Room 
	from stBooking bk
	left  join  stBooking_MICE bm on bk.fcBookID= bm.fcBookID
	left  join stKhachHang kh on kh.fcMa= bk.fcGuestID
	left  join stBooking_Status bs on bs.fcCode =  bk.fcStatus_BkRoom
	where ( (bm.fdCheckIn between  @pdFromDate and @pdToDate) or (bm.fdCheckOut between  @pdFromDate and @pdToDate) ) AND (bk.fbMICE =  'L')
) AllMonth_Detail  
WHERE  (cast (fcMonth as int) between convert(nvarchar(6), @pdFromDate, 112) and convert(nvarchar(6), @pdToDate, 112))
ORDER BY  fcBookID
END
GO

IF OBJECT_ID('[dbo].[SP_MICE_REPORT]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[SP_MICE_REPORT]
GO
/****** Object:  Stored Procedure dbo.SP_MICE_REPORT    Script Date: 01/19/2009 10:05:32 AM ******/
-- Update last 23/07/2007
-- NOTE:  
	--1.  Bao cao SP_MICE_REPORT VA SP_LEISURE_REPORT chi KHAC NHAU o dieu kien sau
	--2. SP_MICE_REPORT co dieu kien (bk.fbMICE <> 'L')
	--3. SP_LEISURE_REPORT  co dieu kien (bk.fbMICE = 'L')


CREATE PROCEDURE SP_MICE_REPORT
(
	@pcFromDate  nvarchar(10), 
	@pcToDate  nvarchar(10),
	@pcCall  char(1)  ='0'
)
AS
--set dateformat dmy
set dateformat mdy
declare @pdFromDate  smalldatetime
declare @pdToDate smalldatetime
select @pdFromDate = cast(@pcFromDate as smalldatetime)
select @pdToDate = cast(@pcToDate as smalldatetime)

if @pcCall  = '0'
-- Note:- khong duoc thay doi thu tu cac fieldname trong cau select cua @pcCall  = '0'
--           

SELECT DISTINCT convert(nvarchar(6), fdDATE_RECEIVED, 7) as  fcDATE_RECEIVED, convert(nvarchar(6), fdLAST_DAY_CONTACT, 7) as  fcLAST_DAY_CONTACT, fcCompany, fcSaleManager, fcGroupName 
-- GET MIN(fdCheckIn) va MAX(fdCheckOut)
, (SELECT CASE  WHEN  month( min(fdCheckIn) ) = month( max( fdCheckOut) ) 
		  THEN 	(select  substring(convert(nvarchar(2), min(fdcheckin), 6) ,1,10)+'-' + convert(nvarchar(11), max(fdcheckOut), 6)    from stBooking_MICE  where fcbookid = AllMonth.FCBOOKID)
		  ELSE  (select  convert(nvarchar(11), min(fdcheckin), 6) + ';  ' + convert(nvarchar(11), max(fdcheckOut), 6)    from stBooking_MICE  where fcbookid =  AllMonth.FCBOOKID )
		  END  FROM stBooking_MICE WHERE FCBOOKID = AllMonth.FCBOOKID ) AS fcIn_Out
, fcStatus_BkRoom, fcStatusName, fcMonth, fcMonthName, fnRates, fnRates1,cast(0  as decimal) AS fnRevenue,0 as fnTotal, fcRemark,  fcBookID 
FROM (

	select distinct bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT,  kh.fcTen as fcCompany,  bm.fcSaleManager,bm.fcGroupName,    
	(case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_BkRoom,    
	UPPER(case when bs.fcName in('Tentative','Agreement','Proposal') then 'Tentative' else bs.fcName end) as fcStatusName, 
	UPPER( datename(month, bm.fdCheckIn )) as fcMonthName,  convert(nvarchar(6), bm.fdCheckIn, 112) as fcMonth,
	cast ( (select top 1 fnRoomRates from stBooking_MICE where fcBookID =bk.fcBookID order by fnNo_Of_Room desc )  as nvarchar(10))  + '++' as fnRates,
 	(select top 1 fnRoomRates from stBooking_MICE where fcBookID =bk.fcBookID order by fnNo_Of_Room desc )    as fnRates1,
	cast(bm.fcNotes as varchar(8000)) as fcRemark, 
	max(bm.fnNo_Of_Room) as fnMax_No_Of_Room, 	bk.fcBookID
	from stBooking bk 
	left join stBooking_MICE bm on bk.fcBookID= bm.fcBookID
	left join stKhachHang kh on kh.fcMa= bk.fcGuestID
	left join stBooking_Status bs on bs.fcCode =  bk.fcStatus_BkRoom
             where ((bm.fdCheckIn between  @pdFromDate and @pdToDate) or (bm.fdCheckOut between  @pdFromDate and @pdToDate))  AND (bk.fbMICE <> 'L')
	group by bk.fcBookID, convert(nvarchar(6), bm.fdCheckIn, 112),  UPPER( datename(month, bm.fdCheckIn )), 
	 bk.fcStatus_BkRoom , bs.fcName,  kh.fcTen , bm.fcSaleManager, bm.fcGroupName,  bk.fdDate, bk.fdDateConfirm , cast(bm.fcNotes as varchar(8000))
UNION ALL
	select distinct  bk.fdDate,  bk.fdDateConfirm ,  kh.fcTen as fcCompany, bm.fcSaleManager, bm.fcGroupName,   
	(case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_BkRoom,    
	UPPER(case when bs.fcName in('Tentative','Agreement','Proposal') then 'Tentative' else bs.fcName end) as fcStatusName, 
	UPPER( datename(month,bm.fdCheckOut )) as fcMonthName,  convert(nvarchar(6), bm.fdCheckOut, 112) as fcMonth,
	cast ( (select top 1 fnRoomRates from stBooking_MICE where fcBookID =bk.fcBookID order by fnNo_Of_Room desc )  as nvarchar(10))  + '++' as fnRates,
	(select top 1 fnRoomRates from stBooking_MICE where fcBookID =bk.fcBookID order by fnNo_Of_Room desc )    as fnRates1, 	
	cast(bm.fcNotes as varchar(8000)) as fcRemark, 
	max(bm.fnNo_Of_Room) as fnMax_No_Of_Room, 	bk.fcBookID
	from stBooking bk 
	left join  stBooking_MICE bm  on bk.fcBookID= bm.fcBookID
	left join stKhachHang kh on kh.fcMa= bk.fcGuestID
	left join stBooking_Status bs on bs.fcCode =  bk.fcStatus_BkRoom
	where ( (bm.fdCheckIn between  @pdFromDate and @pdToDate) or (bm.fdCheckOut between  @pdFromDate and @pdToDate) )   AND (bk.fbMICE <> 'L')
	group by bk.fcBookID, convert(nvarchar(6), bm.fdCheckOut, 112),  UPPER( datename(month, bm.fdCheckOut )),  
	 bk.fcStatus_BkRoom , bs.fcName, kh.fcTen , bm.fcSaleManager, bm.fcGroupName,  bk.fdDate, bk.fdDateConfirm , cast(bm.fcNotes as varchar(8000))
) AllMonth 
WHERE  (cast (fcMonth as int) between cast( convert(nvarchar(6), @pdFromDate, 112) as int) and  cast(convert(nvarchar(6), @pdToDate, 112) as int) )
ORDER BY  fcMonth, fcIn_Out


if @pcCall  = '1'
BEGIN	
SELECT distinct fcBookID, fcMonth, fcMiceID, fdCheckIn, fdCheckOut, fnRoomRates, fnNo_Of_Room FROM (
	select  bk.fcBookID,  convert(nvarchar(6), bm.fdCheckIn, 112) as fcMonth,   fcMiceID,  bm.fdCheckIn, bm.fdCheckOut, bm.fnRoomRates, bm.fnNo_Of_Room 
	from stBooking bk
	left  join stBooking_MICE bm  on bk.fcBookID= bm.fcBookID
	left  join stKhachHang kh on kh.fcMa= bk.fcGuestID
	left  join stBooking_Status bs on bs.fcCode =  bk.fcStatus_BkRoom
	where ( (bm.fdCheckIn between  @pdFromDate and @pdToDate) or (bm.fdCheckOut between  @pdFromDate and @pdToDate) )  AND (bk.fbMICE <> 'L')
UNION ALL
	select  bk.fcBookID, convert(nvarchar(6), bm.fdCheckOut, 112) as fcMonth,  fcMiceID,  bm.fdCheckIn, bm.fdCheckOut, bm.fnRoomRates, bm.fnNo_Of_Room 
	from stBooking bk
	left  join  stBooking_MICE bm on bk.fcBookID= bm.fcBookID
	left  join stKhachHang kh on kh.fcMa= bk.fcGuestID
	left  join stBooking_Status bs on bs.fcCode =  bk.fcStatus_BkRoom
	where ( (bm.fdCheckIn between  @pdFromDate and @pdToDate) or (bm.fdCheckOut between  @pdFromDate and @pdToDate) )  AND (bk.fbMICE <> 'L')
) AllMonth_Detail  
where (cast (fcMonth as int) between convert(nvarchar(6), @pdFromDate, 112) and convert(nvarchar(6), @pdToDate, 112))
order by fcBookID
END
GO

IF OBJECT_ID('[dbo].[sp_MONTHLY_BQRevenue]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_MONTHLY_BQRevenue]
GO
-- NOTE:  STORE DOC DU LIEU TU CAC FUNCTION SAU
-- 1. fcMonth_Last, fcMonth_Curr: Lay gia tri tu sfACTUAL_byCharge (TRANG THAI D, voi @pcCurrDate <> '' , nMonth <> 0 )
-- 2. fcMonth_Forecast: lay gia tri tu sfFORECAST_byCharge  + sfFORECAST_byBasicPrice (TRANG THAI D + T, voi @pcCurrDate =''  , nMonth <> 0 )
-- 3. fcYear_Last, fcYear_Curr: Lay gia tri tu sfACTUAL_byCharge (TRANG THAI D, voi  @pcCurrDate <> '', nMonth = 0: ko so sanh Month)
-- 4. fcYear_Forecast: lay gia tri tu sfFORECAST_byCharge+ sfFORECAST_byBasicPrice(TRANG THAI D + T, voi @pcCurrDate  = '' ,  nMonth = 0: ko so sanh Month)

CREATE PROCEDURE dbo.sp_MONTHLY_BQRevenue
(
	@pcCurrDate nvarchar(10)
)
 AS
--set dateformat dmy
set dateformat mdy

declare @pcLastYear nvarchar(4)
declare @pcCurrYear nvarchar(4)
declare @pcMonth int
declare @pcCurrDate_ofLastYear nvarchar(10)

set @pcCurrDate_ofLastYear = left ( @pcCurrDate, 6 ) + @pcLastYear
set @pcLastYear = year( cast ( @pcCurrDate as smalldatetime) ) - 1
set @pcCurrYear = year( cast ( @pcCurrDate as smalldatetime) )
set @pcMonth = month( cast ( @pcCurrDate as smalldatetime) )

-- NOTE : O DAY TRUYEN GIA TRI @pcCurrDate_ofLastYear VA @pcCurrDate VAO CAC FUNCTION LA KIEU CHUOI CHU KO PHAI KIEU DATETIME
SELECT    *
, dbo.sfGet_PERCENT( fcMonth_Curr , fcMonth_Last )  AS  fcMonth_CL
, dbo.sfGet_PERCENT( fcMonth_Curr , fcMonth_Forecast )  AS  fcMonth_CF
, dbo.sfGet_PERCENT( fcMonth_Curr , fcMonth_Budget )  AS  fcMonth_CB
, cast ( 0 as decimal)  as fcYear_Last
, cast ( 0 as decimal)  as fcYear_Curr
, cast ( 0 as decimal)  as fcYear_Forecast
, dbo.sfGet_valueBudget_yearTODATE ( @pcCurrYear , @pcMonth, fcRoom )  as fcYear_Budget
, cast ( 0 as decimal)  AS  fcYear_CL
, cast ( 0 as decimal)  AS  fcYear_CF
, cast ( 0 as decimal)  AS  fcYear_CB

FROM  (
	SELECT  p.fcLoaiPhong,  p.fcMa as fcRoom, p.fcTen as fcRoomName
	-- MONTH TO DATE 
	, CAST(  0 AS DECIMAL(12, 5) )   as fcMonth_Last
	, CAST( 0   AS DECIMAL(12, 5) ) as fcMonth_Curr
--	, dbo.sfACTUAL_byCharge (@pcLastYear, @pcMonth, p.fcLoaiPhong, bg.fcRoom, @pcCurrDate_ofLastYear) as fcMonth_Last
--	, dbo.sfACTUAL_byCharge (@pcCurrYear, @pcMonth, p.fcLoaiPhong, bg.fcRoom, @pcCurrDate) as fcMonth_Curr
	, dbo.sfFORECAST_byCharge(@pcCurrYear, @pcMonth, p.fcLoaiPhong, bg.fcRoom, '')  + dbo.sfFORECAST_byALLOWPRICE  (@pcCurrYear, @pcMonth,  bg.fcRoom )   as fcMonth_Forecast
	, dbo.sfGet_valueBudget_monthTODATE  ( @pcCurrYear,  @pcMonth , bg.fcRoom ) as fcMonth_Budget

	FROM stBudget bg
	inner JOIN  stPhong p  ON bg.fcRoom = p.fcMa	
	WHERE fcYear = @pcCurrYear

) aa ORDER BY fcLoaiPhong, fcRoom
GO

IF OBJECT_ID('[dbo].[sp_Room_isExisted_inTrack]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Room_isExisted_inTrack]
GO
CREATE PROCEDURE sp_Room_isExisted_inTrack 
(
	@pcRoom nvarchar(20),
	@pcDate nvarchar(20)
)
AS
--set dateformat dmy
set dateformat mdy
/*
declare @pdDate smalldatetime
set @pdDate = cast(@pcDate as smalldatetime)
select * from stTrackRoom 
where fcRoom = @pcRoom and convert(char(10), fdNgayBatDau,103)  = @pdDate
*/
select * from stTrackRoom 
where fcRoom = @pcRoom and fdNgayBatDau <=@pcDate and @pcDate<=fdNgayKetThuc
GO

IF OBJECT_ID('[dbo].[sp_SalesofMonth]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_SalesofMonth]
GO
--1.-----------------------------------
CREATE PROCEDURE sp_SalesofMonth
(
	@pcDate nvarchar(10) 
)

AS
--set dateformat dmy
set dateformat mdy
declare @pdDate smalldatetime
set @pdDate = cast ( @pcDate as smalldatetime)
declare @T1 char(10),@T2 char(10),@T3 char(10),@T4 char(10)
declare @T5 char(10),@T6 char(10),@T7 char(10),@T8 char(10),@T9 char(10)
declare @so1 as int,@so2 as int,@so3 as int,@so4 as int,@so5 as int
declare @so6 as int,@so7 as int,@so8 as int,@so9 as int,@so10 as int
SET @T1='08h-10h' SET @T2='10h-12h' SET @T3='12h-14h' SET @T4='14h-16h'
SET @T5='16h-18h' SET @T6='18h-20h' SET @T7='20h-22h' SET @T8='22h-24h'  SET @T9='06h-08h'
set @so1=8 set @so2=10 set @so3=12 set @so4=14 set @so5=16 
set @so6=18 set @so7=20 set @so8=22 set @so9=24 set @so10=6
select fcten,thoigian, cast(0 as float) as fnTotal,cast(0 as float) as fnDaysTotal,cast(0 as float) as fnSatTotal, cast(0 as float) as fnSunTotal
from
(
-----------------------------T1()-------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T1 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so1,@so2)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so2
      or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so1)
      and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------------------T2()----------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T2 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so2,@so3)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so3
      or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so2)
      and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------T3()------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T3 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so3,@so4)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so4
      or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so3)
      and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------T4()------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T4 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so4,@so5)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so5
      or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so4)
      and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------T5()------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T5 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so5,@so6)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so6
      or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so5)
      and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------T6()------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T6 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so6,@so7)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so7
      or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so6)
      and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------T7()------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T7 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so7,@so8)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so8
      or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so7)
      and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------T8()------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T8 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so8,@so9)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so9
      or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so8)
      and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
---------------------------------T9()----------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T9 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so10,@so1)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so1
      or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so10)
      and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut


)abc
group by thoigian,fcTen
order by fcTen,thoigian
GO

IF OBJECT_ID('[dbo].[sp_SalesofMonth_34_08_07]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_SalesofMonth_34_08_07]
GO
CREATE PROCEDURE sp_SalesofMonth_34_08_07
(
	@pcDate nvarchar(10) 
)

AS
--set dateformat dmy
set dateformat mdy
declare @pdDate smalldatetime
set @pdDate = cast ( @pcDate as smalldatetime)

declare @T1 char(10),@T2 char(10),@T3 char(10),@T4 char(10)
declare @T5 char(10),@T6 char(10),@T7 char(10),@T8 char(10)
declare @so1 as int,@so2 as int,@so3 as int,@so4 as int,@so5 as int
declare @so6 as int,@so7 as int,@so8 as int,@so9 as int
SET @T1='08h-10h' SET @T2='10h-12h' SET @T3='12h-14h' SET @T4='14h-16h'
SET @T5='16h-18h' SET @T6='18h-20h' SET @T7='20h-22h' SET @T8='22h-24h'
set @so1=8 set @so2=10 set @so3=12 set @so4=14 set @so5=16 
set @so6=18 set @so7=20 set @so8=22 set @so9=24
select fcten,thoigian,fddate,fnTile,Total,[%Occupation],fcMonth,SumTime
from
(
-----------------------------T1()-------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T1 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so1,@so2)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so2
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so1)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut

-----------
union all
--------------------------------------------T2()----------------------------------------

select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T2 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so2,@so3)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so3
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so2)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut

-----------
union all

--------------------------------T3()------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T3 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so3,@so4)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so4
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so3)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut
-----------
union all

--------------------------------T4()------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T4 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so4,@so5)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so5
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so4)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut

-----------
union all

--------------------------------T5()------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T5 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so5,@so6)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so6
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so5)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut

-----------
union all

--------------------------------T6()------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T6 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so6,@so7)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so7
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so6)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut

-----------
union all

--------------------------------T7()------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T7 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so7,@so8)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so8
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so7)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut

-----------
union all

--------------------------------T8()------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T8 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so8,@so9)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so9
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so8)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut
)abc
--------------------------------------***The end***-------------------------------

group by thoigian,fcTen,fddate,fnTile,Total,[%Occupation],fcMonth,SumTime
order by fcTen,thoigian
GO

IF OBJECT_ID('[dbo].[sp_SalesofMonth_35]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_SalesofMonth_35]
GO
CREATE PROCEDURE sp_SalesofMonth_35
(
	@pcDate nvarchar(10) 
)

AS
--set dateformat dmy
set dateformat mdy
declare @pdDate smalldatetime
set @pdDate = cast ( @pcDate as smalldatetime)

declare @T1 char(10),@T2 char(10),@T3 char(10),@T4 char(10)
declare @T5 char(10),@T6 char(10),@T7 char(10),@T8 char(10)
declare @so1 as int,@so2 as int,@so3 as int,@so4 as int,@so5 as int
declare @so6 as int,@so7 as int,@so8 as int,@so9 as int
SET @T1='08h-10h' SET @T2='10h-12h' SET @T3='12h-14h' SET @T4='14h-16h'
SET @T5='16h-18h' SET @T6='18h-20h' SET @T7='20h-22h' SET @T8='22h-24h'
set @so1=8 set @so2=10 set @so3=12 set @so4=14 set @so5=16 
set @so6=18 set @so7=20 set @so8=22 set @so9=24
select fcten,thoigian,0 as fnTotal
from
(
-----------------------------T1()-------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T1 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so1,@so2)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so2
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so1)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut

-----------
union all
--------------------------------------------T2()----------------------------------------

select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T2 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so2,@so3)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so3
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so2)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut

-----------
union all

--------------------------------T3()------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T3 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so3,@so4)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so4
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so3)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut
-----------
union all

--------------------------------T4()------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T4 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so4,@so5)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so5
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so4)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut

-----------
union all

--------------------------------T5()------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T5 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so5,@so6)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so6
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so5)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut

-----------
union all

--------------------------------T6()------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T6 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so6,@so7)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so7
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so6)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut

-----------
union all

--------------------------------T7()------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T7 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so7,@so8)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so8
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so7)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut

-----------
union all

--------------------------------T8()------------------------------------
select d.fcTen,b.fddate,right(b.fdTimeIn,8)as fdTimeIn,right(b.fdTimeOut,8)as fdTimeOut,@T8 as thoigian, 
UPPER( datename(month, b.fddate )) as fcMonthName,  convert(nvarchar(6), b.fddate, 112) as fcMonth,
sum(c.fnamount) as Total,cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60 as SumTime,
((cast ( datediff (mi,b.fdTimeIn,b.fdTimeOut) as float) / 60)/14)*100 as [%Occupation],
fnTile=dbo.Get_SRate(b.fdTimeIn,b.fdTimeOut,sum(c.fnamount),@so8,@so9)
from stbooking_charges c left join stbookfunctionroom b on c.fcbookid=b.fcbookid and c.fncodeid=b.fncodeid 
left join stbooking a on b.fcbookid=a.fcbookid left join stphong d on b.fcfunctionroom=d.fcma
where not (datepart(hh,b.fdTimeIn)+datepart(n,b.fdTimeIn)/ cast(60 as float) >@so9
      or datepart(hh,b.fdTimeOut)+datepart(n,b.fdTimeOut)/cast(60 as float)<@so8)
      and month(b.fddate)=month(@pdDate)and year(b.fddate)=year(@pdDate) and a.fcstatus_bkroom='d'
-----------------------
group by d.fcten,b.fdDate,b.fdTimeIn,b.fdTimeOut
)abc
--------------------------------------***The end***-------------------------------

group by thoigian,fcTen
order by fcTen,thoigian
GO

IF OBJECT_ID('[dbo].[sp_SalesofMonth_ChartReport_tmp]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_SalesofMonth_ChartReport_tmp]
GO
CREATE PROCEDURE sp_SalesofMonth_ChartReport_tmp
(
	@pcDate nvarchar(10) 
)
AS
--set dateformat dmy
set dateformat mdy
declare @pdDate smalldatetime
set @pdDate = cast ( @pcDate as smalldatetime)
declare @T1 nvarchar(50),@T2 nvarchar(50),@T3 nvarchar(50)
declare @so1 as int,@so2 as int,@so3 as int,@so4 as int
SET @T1='06h-12h' SET @T2='12h-18h' SET @T3='18h-24h' 
set @so1=6 set @so2=12 set @so3=18 set @so4=24 
select fcten,(case thoigian when '06h-12h' then convert(nvarchar(100),N'06h-12h:Sáng') when '12h-18h' then convert(nvarchar(100),N'12h-18h:Chiều') else convert(nvarchar(100),N'18h-24h:Tối')end)as thoigian,round(sum(fnTile),2) as fnAmount
from
(
-----------------------------T1()-------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T1 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so1,@so2)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so2
          or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so1)
          and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------------------T2()----------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T2 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so2,@so3)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so3
          or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so2)
          and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------T3()------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T3 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so3,@so4)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so4
          or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so3)
          and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
)abc
--order by fcTen,thoigian
group by abc.fcten,abc.thoigian
order by fcTen,thoigian
GO

IF OBJECT_ID('[dbo].[sp_SalesofMonth_tmp]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_SalesofMonth_tmp]
GO
--2.-----------------------------------
CREATE PROCEDURE sp_SalesofMonth_tmp
(
	@pcDate nvarchar(10) 
)
AS
--set dateformat dmy
set dateformat mdy
declare @pdDate smalldatetime
set @pdDate = cast ( @pcDate as smalldatetime)
declare @T1 char(10),@T2 char(10),@T3 char(10),@T4 char(10)
declare @T5 char(10),@T6 char(10),@T7 char(10),@T8 char(10),@T9 char(10)
declare @so1 as int,@so2 as int,@so3 as int,@so4 as int,@so5 as int
declare @so6 as int,@so7 as int,@so8 as int,@so9 as int,@so10 as int
SET @T1='08h-10h' SET @T2='10h-12h' SET @T3='12h-14h' SET @T4='14h-16h'
SET @T5='16h-18h' SET @T6='18h-20h' SET @T7='20h-22h' SET @T8='22h-24h'  SET @T9='06h-08h'
set @so1=8 set @so2=10 set @so3=12 set @so4=14 set @so5=16 
set @so6=18 set @so7=20 set @so8=22 set @so9=24 set @so10=6
select fcten,thoigian,fddate,fnTile
from
(
-----------------------------T1()-------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T1 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so1,@so2)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so2
          or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so1)
          and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------------------T2()----------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T2 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so2,@so3)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so3
          or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so2)
          and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------T3()------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T3 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so3,@so4)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so4
          or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so3)
          and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------T4()------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T4 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so4,@so5)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so5
          or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so4)
          and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------T5()------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T5 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so5,@so6)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so6
          or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so5)
          and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------T6()------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T6 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so6,@so7)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so7
          or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so6)
          and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------T7()------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T7 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so7,@so8)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so8
          or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so7)
          and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
--------------------------------T8()------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T8 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so8,@so9)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so9
          or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so8)
          and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut
union all
---------------------------------T9()----------------------------------------
select fcTen,fddate,right(fdTimeIn,8)as fdTimeIn,right(fdTimeOut,8)as fdTimeOut,
@T9 as thoigian,fnTile=dbo.Get_SRate(fdTimeIn,fdTimeOut,sum(fnamount),@so10,@so1)
from dbo.view_salesofmonth_tmp
where not (datepart(hh,fdTimeIn)+datepart(n,fdTimeIn)/ cast(60 as float) >@so1
      or datepart(hh,fdTimeOut)+datepart(n,fdTimeOut)/cast(60 as float)<@so10)
      and month(fddate)=month(@pdDate)and year(fddate)=year(@pdDate) 
group by fcTen,fdDate,fdTimeIn,fdTimeOut

)abc
order by fcTen,thoigian
GO

IF OBJECT_ID('[dbo].[sp_TinhTien_dsPhong_chuaCharges]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_TinhTien_dsPhong_chuaCharges]
GO
-- Update  11/09/2007: Gia phong theo cach lay tu Budget
-- CONG THUC: GIAPhong/1HOUR = tienPhongtrongBudget/(songayTrongThang * 14gio) ; 14gio = SO GIO TOI DA CUA 1 FUNCTIONROOM TRONG stVALIDBOOKING

CREATE PROCEDURE dbo.sp_TinhTien_dsPhong_chuaCharges
(
	@pcFromDate nvarchar(10),
	@pcToDate nvarchar(10)
)	
 AS
--set dateformat dmy
set dateformat mdy
declare  @pdFromDate smalldatetime
declare  @pdToDate smalldatetime
set @pdFromDate = cast (@pcFromDate  as smalldatetime )
set @pdToDate = cast (@pcToDate as smalldatetime )



SELECT DISTINCT   b.*,  dbo.fDefind(a.fcRoom + ', ') as fcRoom, a.fnGia_1Hour as fnGia, b.fnSoGioDat * a.fnGia_1Hour as fnTienPhong  FROM  (
	( select distinct  bf.fcBookID, p.fcMa as fcRoom , p.fcLoaiPhong,  dbo.GetNames_Booking('', '',  bf.fdTimeIn, bf.fdTimeOut, bf.fcBookID, p.fcLoaiPhong) as fcFunctionRoom_Code
	, dbo.sfGiaPhong_chuaCharges_1HOUR ( bf.fdDate ,  p.fcMa ) as fnGia_1Hour
	from stBookFunctionRoom bf inner join stPhong p on bf.fcFunctionRoom = p.fcMa) a

INNER JOIN  
	(select * from dbo.sfDsachPhong_chuaCharges(@pdFromDate,  @pdToDate) ) b
ON  a.fcBookiD = b.fcBookID and a.fcFunctionRoom_Code = b.fcFunctionRoom_Code 
) ORDER BY B.FCBOOKID
GO

IF OBJECT_ID('[dbo].[sp_Top_FrequentCustomer]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Top_FrequentCustomer]
GO
-- UPDATE 25/08/2007

CREATE PROCEDURE sp_Top_FrequentCustomer(  -- Cac su kien da xay ra roi, bao cao doanh thu
	@pTuNgay nchar(10),
	@pDenNgay nchar(10)
	--@nTop int = 3
)
as
--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime

select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)

SELECT fcOrganization, fcContactPerson, fcKindOfGuest, SUM (fnFrequence) AS fnFrequence
, fcField, fcAddress , fcTelephone,  fcFax,  fcEmail 
FROM (
	select   ms.fcGuestCode, kh.fcTen as fcOrganization, cast( count(ms.fcGuestCode) as int ) as fnFrequence
	, (select top 1 fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = ms.fcGuestCode ) as fcContactPerson
	, isnull((select fcName from stKhachHang_Loai where fcCode = kh.fcLoaiKhach), '' ) as fcKindOfGuest
	, isnull((select fcName from stLinhVuc where fcCode = kh.fcLinhVuc), '')as fcField
	, (kh.fcDiaChi + ' ' + t_tp.fcDescription2 + ' ' + qg.fcName) as fcAddress , kh.fcTelephone, kh.fcFax, kh.fcEmail

	from stMaster_EO ms left  join  stSKLK l on ms.fcMaster_EO = l.fcMaster_EO
	left  join stKhachHang kh on ms.fcGuestCode = kh.fcMa 
	left  join stTinh_TP t_tp  on t_tp.fcCode = kh.fcTinh_TP 
	left  join stQuocGia qg  on qg.fcCode = kh.fcQuocGia 

	where ( convert(char(10), l.fdEventDate,101)  between @TuNgay and @DenNgay ) --and (l.fcTrangThai <> 'C')
	group by ms.fcGuestCode, kh.fcTen , kh.fcma, fcMaNLH, kh.fcNguoiLienHe, kh.fcLoaiKhach, ms.fcContactPerson, kh.fcLinhVuc ,  kh.fcTelephone,kh.fcFax, kh.fcEmail, kh.fcDiaChi, t_tp.fcDescription2, qg.fcName
	--order by fnFrequence desc
) AA 
GROUP BY fcOrganization, fcContactPerson, fcKindOfGuest, fcField, fcAddress , fcTelephone,  fcFax,  fcEmail 
ORDER BY fnFrequence DESC
GO

IF OBJECT_ID('[dbo].[sp_TopRevenue_Actual]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_TopRevenue_Actual]
GO
-- UPDATE 25/08/2007

CREATE PROCEDURE sp_TopRevenue_Actual(  -- Cac su kien da xay ra roi, bao cao doanh thu
	@pTuNgay nchar(10),
	@pDenNgay nchar(10)
)
as
--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime

select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)

SELECT fcOrganization, fcContactPerson, fcAddress, fcTelephone, fcFax, fcEmail, fcKindOfGuest, fcField
, SUM (fnRoomRevenue)  AS fnRoomRevenue, SUM(fnMeetingRevenue) AS fnMeetingRevenue
, SUM (fnRoomRevenue) +  SUM(fnMeetingRevenue)   AS fnRevenue 
FROM (
	select  distinct ms.fcMaster_EO, ms.fcBookID, ms.fcGuestCode,  kh.fcTen as fcOrganization, --ms.fcContactPerson , 
	(select top 1 fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = ms.fcGuestCode ) as fcContactPerson
	, kh.fcDiaChi  as fcAddress , kh.fcTelephone, kh.fcFax, kh.fcEmail
	, isnull((select fcName from stKhachHang_Loai where fcCode = kh.fcLoaiKhach), '')as fcKindOfGuest
	, isnull((select fcName from stLinhVuc where fcCode = kh.fcLinhVuc), '') as fcField

	, (select isnull(sum(isnull(fnRevenue, 0)) , 0) from stBooking_MICE where fcBookID =ms.fcBookID ) as fnRoomRevenue
	, (select isnull(sum (fnAmount ), 0) from stSKLK_DoanhThu ldt inner join stSKLK l on ldt.fcOrderNo = l.fcOrderNo and ldt.fcMaster_eo = l.fcMaster_eo where l.fcMaster_eo =ms.fcMaster_EO and (l.fcTrangThai not in ( 'C', 'R'))) as fnMeetingRevenue
--	(select isnull(sum(isnull(fnRevenue,0)) , 0) from stBooking_MICE where fcBookID =ms.fcBookID ) + (select isnull(sum(isnull(fnAmount, 0)),0) from stSKLK_DoanhThu where fcMaster_EO =ms.fcMaster_EO and l.fcTrangThai not in ( 'C', 'R')) AS  fnRevenue

	from stmaster_EO ms inner join stSKLK l on ms.fcMaster_EO= l.fcMaster_EO
	left  join stKhachHang kh on ms.fcGuestCode = kh.fcMa 
	where (convert(char(10), l.fdEventDate,101)  between @TuNgay and @DenNgay ) and (l.fcTrangThai not in ( 'C', 'R'))
) AA  
GROUP BY fcOrganization, fcContactPerson, fcAddress, fcTelephone, fcFax, fcEmail, fcKindOfGuest, fcField
ORDER BY  fnRevenue DESC
GO

IF OBJECT_ID('[dbo].[sp_Track_StartDate_EndDate]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Track_StartDate_EndDate]
GO
CREATE PROCEDURE sp_Track_StartDate_EndDate 
(
	@pcRoom as nvarchar(10) = '',
	@pcEventStarDate as nvarchar(20)
)
 AS

--set dateformat dmy
set dateformat mdy
declare @pdEventStarDate smalldatetime
set @pdEventStarDate = cast(@pcEventStarDate as smalldatetime)

select a.*, b.* from(
 (
	select '1' as Ma, rs.fcroom, max(fdTimeOut)as startDate 
	from stsklk l 
	inner join stroom_setup rs on l.fcorderno = rs.fcorderno
	where @pdEventStarDate > fdTimeOut  and year(fdTimeOut) = year(@pdEventStarDate) and month(fdTimeOut) = month(@pdEventStarDate) and day(fdTimeOut) = day(@pdEventStarDate)
	group by rs.fcroom
 ) a
--Can duoi
 full join
 ( 
	select '1' as Ma, rs.fcroom, min(fdTimeIn) as EndDate 
	from stsklk l 
   	inner join stroom_setup rs on l.fcorderno = rs.fcorderno
   	where @pdEventStarDate < fdTimeOut  and year(fdTimeOut) = year(@pdEventStarDate) and month(fdTimeOut) = month(@pdEventStarDate) and day(fdTimeOut) = day(@pdEventStarDate)
   	group by rs.fcroom
 ) b
 on a.ma = b.ma 
)  where  (@pcRoom = '' or a.fcroom = rtrim(ltrim(@pcRoom)) )or (@pcRoom = '' or  b.fcroom = rtrim(ltrim(@pcRoom)))

/*
select a.*, b.* from(
 (
	select '1' as Ma, rs.fcroom, max(fdTimeOut)as startDate 
	from stsklk l 
	inner join stroom_setup rs on l.fcorderno = rs.fcorderno
	where @pdEventStarDate > fdTimeOut  and year(fdTimeOut) = year(@pdEventStarDate) and month(fdTimeOut) = month(@pdEventStarDate) and day(fdTimeOut) = day(@pdEventStarDate)
	group by rs.fcroom
 ) a
--Can duoi
 full join
 ( 
	select '1' as Ma, rs.fcroom, min(fdTimeIn) as EndDate 
	from stsklk l 
   	inner join stroom_setup rs on l.fcorderno = rs.fcorderno
   	where @pdEventStarDate < fdTimeOut  and year(fdTimeOut) = year(@pdEventStarDate) and month(fdTimeOut) = month(@pdEventStarDate) and day(fdTimeOut) = day(@pdEventStarDate)
   	group by rs.fcroom
 ) b
 on a.ma = b.ma 
)  where  (@pcRoom = '' or a.fcroom = rtrim(ltrim(@pcRoom)) )or (@pcRoom = '' or  b.fcroom = rtrim(ltrim(@pcRoom)))


*/

/*
select a.*, b.* from(
 (
	select '1' as Ma, rs.fcroom, max(fdngayketthuc)as startDate 
	from stsklk l 
	inner join stroom_setup rs on l.fcorderno = rs.fcorderno
	where year(fdngayketthuc) = year(@pdEventStarDate) and month(fdngayketthuc) = month(@pdEventStarDate) and day(fdngayketthuc) = day(@pdEventStarDate) and  fdngayketthuc < @pdEventStarDate
	group by rs.fcroom
 ) a
--Can duoi
 full join
 ( 
	select '1' as Ma, rs.fcroom, min(fdngaybatdau) as EndDate 
	from stsklk l 
   	inner join stroom_setup rs on l.fcorderno = rs.fcorderno
   	where year(fdngayketthuc) = year(@pdEventStarDate) and month(fdngayketthuc) = month(@pdEventStarDate) and day(fdngaybatdau) = day(@pdEventStarDate) and fdngaybatdau > @pdEventStarDate
   	group by rs.fcroom
 ) b
 on a.ma = b.ma 
)  where  (@pcRoom = '' or a.fcroom = rtrim(ltrim(@pcRoom)) )or (@pcRoom = '' or  b.fcroom = rtrim(ltrim(@pcRoom)))
*/
GO

IF OBJECT_ID('[dbo].[sp_Track_StartDate_EndDate_TEMP]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Track_StartDate_EndDate_TEMP]
GO
CREATE PROCEDURE sp_Track_StartDate_EndDate_TEMP
(
	@pcRoom as nvarchar(10) = '',
	@pcEventStartDate as nvarchar(20)='',      -- LA THOI GIAN TIMEIN CUA SU KIEN DANG BOOK
	@pcEventEndDate as nvarchar(20)=''       -- LA THOI GIAN TIMEOUT CUA SU KIEN DANG BOOK
)
 AS

--set dateformat dmy
set dateformat mdy
declare @pdEventStartDate smalldatetime
declare @pDEventEndDate smalldatetime
set @pdEventStartDate = cast(@pcEventStartDate as smalldatetime)
set @pdEventEndDate = cast(@pcEventEndDate as smalldatetime)

select a.*, b.* from (
	--***** BUOC1: KIEM TRA CAN TREN: DUNG DE SO SANH VOI TIMEIN CUA SU KIEN DANG BOOK
(
	select '1' as Ma, fcFunctionRoom, max(fdTimeOut)as endDate, max(fdTimeOut)+'01:00:00' as endDate_plus_1h from stBookFunctionRoom 
	where fcFunctionRoom =@pcRoom  and convert(char(10), fdTimeOut,103) =convert(char(10), @pdEventStartDate,103) 
	group by fcFunctionRoom, fdtimeOut
	having @pdEventStartDate > fdTimeOut --and max(fdTimeOut)+'01:00:00' <= @pdEventStartDate 
) a

full join 
(
	--***** BUOC2: KIEM TRA CAN DUOI: DUNG DE SO SANH VOI TIMEOUT CUA SU KIEN DANG BOOK
	select '1' as Ma, fcFunctionRoom, max(fdTimeIn) as StartDate , max(fdTimeIn) - '01:00:00'  as startDate_substract_1h
	from stBookFunctionRoom 
	where fcFunctionRoom =@pcRoom and convert(char(10), fdTimeOut,103) =convert(char(10), @pdEventEndDate,103)
	group by fcFunctionRoom, fdTimein, fdTimeout
	having @pdEventEndDate  < fdTimein --and max(fdTimeIn)- '01:00:00' >=@pdEventEndDate 
) b

on a.Ma = b.Ma
)
/*
select a.*, b.* from(
 (
	select '1' as Ma, rs.fcroom, max(fdngayketthuc)as startDate 
	from stsklk l 
	inner join stroom_setup rs on l.fcorderno = rs.fcorderno
	where year(fdngayketthuc) = year(@pdEventStarDate) and month(fdngayketthuc) = month(@pdEventStarDate) and day(fdngayketthuc) = day(@pdEventStarDate) and  fdngayketthuc < @pdEventStarDate
	group by rs.fcroom
 ) a
--Can duoi
 full join
 ( 
	select '1' as Ma, rs.fcroom, min(fdngaybatdau) as EndDate 
	from stsklk l 
   	inner join stroom_setup rs on l.fcorderno = rs.fcorderno
   	where year(fdngayketthuc) = year(@pdEventStarDate) and month(fdngayketthuc) = month(@pdEventStarDate) and day(fdngaybatdau) = day(@pdEventStarDate) and fdngaybatdau > @pdEventStarDate
   	group by rs.fcroom
 ) b
 on a.ma = b.ma 
)  where  (@pcRoom = '' or a.fcroom = rtrim(ltrim(@pcRoom)) )or (@pcRoom = '' or  b.fcroom = rtrim(ltrim(@pcRoom)))
*/
GO

IF OBJECT_ID('[dbo].[sp_Turn_down_business]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Turn_down_business]
GO
CREATE PROCEDURE sp_Turn_down_business(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)

select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom, pl.fcMa 
 --,  sk.fcTen as fcFunctionType 
, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson , 
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1 then 'L' else '' end) as fcL, 
isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015') then bc.fnQuantity else 0 end ),0) as fnGUA,
bk.fnEXP , 
bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
(case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 

isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0) as fnFood_Price,
isnull(sum(case when dt.fcgroup in('01') then fnAmount else 0 end ),0) as fnFood_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) as fnMICS_Revenue,
isnull(sum(case when bk.fcStatus_BkRoom  = 'D' then fnAmount else 0 end ),0) as  fnDEF_Rev, 
isnull(sum(case when bk.fcStatus_BkRoom in('T','P', 'A') then fnAmount else 0 end ),0)  as  fnTEN_Rev,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
isnull(sum(case when bk.fcStatus_BkRoom  = 'D' then  fnAmount   else 0 end ),0)  - cast(  isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom ='D' then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)  as decimal )  as  fnDEF_BQ_Rev,
isnull(sum(case when bk.fcStatus_BkRoom  in('T', 'P', 'A') then  fnAmount  else 0 end ),0)  - cast( isnull(sum(case when bc.fnBreakDownLunch = 1  and bk.fcStatus_BkRoom in('A', 'T', 'P') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as decimal)  as  fnTEN_BQ_Rev,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT

from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
WHERE ( bf.fdDate  between @TuNgay and @DenNgay) and bk.fcStatus_BkRoom='C'  --  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote
HAVING not (pl.fcMa  in('08', '09') and isnull(sum(bc.fnQuantity), 0 )  <= 0) 
ORDER BY bf.fdDate
GO

IF OBJECT_ID('[dbo].[sp_Turn_down_business_ct2812]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Turn_down_business_ct2812]
GO
CREATE PROCEDURE sp_Turn_down_business_ct2812(
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)

select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
,(convert(nvarchar(10), bf.fdDate, 6)+' '+convert( nvarchar(5), bf.fdTimeIn, 8)+' '+convert( nvarchar(5), bf.fdTimeOut, 8)) as fcDatetime
, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom, pl.fcMa 
, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson , 
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1  then 'L' else '' end) as fcL, 
--isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
fnSoLuongDK as fnGUA,
bk.fnEXP , bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
(case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
left(cast(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ))-2) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnRS_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*4
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*8 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*2
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*4 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
(
isnull(sum(case when dt.fcgroup in('01') then fnPrice*bc.fnQuantity else 0 end ),0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*4
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*8 else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*2
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*4 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)  as fnBQT_MICS,
-- else isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) end) as fnBQT_MICS,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*4
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*8 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*2
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*4 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float))as fnTotal_B_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) -cast(isnull(sum(case when bc.fnBreakDownLunch=1 and bk.fcStatus_BkRoom not in('C') then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  and bk.fcStatus_BkRoom='C'--  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote
HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0) 
ORDER BY bf.fdDate
GO

IF OBJECT_ID('[dbo].[sp_Turn_down_business_ct2812_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Turn_down_business_ct2812_Ngoc]
GO
CREATE PROCEDURE [dbo].[sp_Turn_down_business_ct2812_Ngoc](
	@pTuNgay nchar(10) ,
	@pDenNgay nchar(10) ,
	@pcUser nvarchar(20)= ''
)
as

--set dateformat dmy
set dateformat mdy
declare @TuNgay smalldatetime
declare @DenNgay smalldatetime
select @TuNgay = cast(@pTuNgay as smalldatetime)
select @DenNgay = cast(@pDenNgay as smalldatetime)

select bk.fcBookID, convert(nvarchar(10), bf.fdDate, 6) as fcFunctionDate, bf.fdDate as fdFunctionDate, convert( nvarchar(5), bf.fdTimeIn, 8)   as fdTimeIn, convert( nvarchar(5), bf.fdTimeOut, 8)  as fdTimeOut 
,(convert(nvarchar(10), bf.fdDate, 6)+' '+convert( nvarchar(5), bf.fdTimeIn, 8)+' '+convert( nvarchar(5), bf.fdTimeOut, 8)) as fcDatetime
--, dbo.fDefind(dbo.GetNames_Booking(@TuNgay, @DenNgay,  bf.fdTimeIn, bf.fdTimeOut, bk.fcBookID, pl.fcMa)) as fcFunctionRoom
, p.fcTen  as fcFunctionRoom -- ngoc sua ten phong
, pl.fcMa
--, dbo.sfGetFunctionType ( bk.fcBookID, bf.fdTimeIn, bf.fdTimeOut, pl.fcMa ) as fcFunctionType
, sk.fcTen as fcFunctionType -- ngoc them 2017 04 17
, bk.fcGuestID, kh.fcTen as fcOrganization, (case bk.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = kh.fcma and fcMaNLH = kh.fcMaNLH)  else bk.fcContactPerson end ) as fcContactPerson , 
(case when sum(cast(bc.fnBreakDownLunch as int)) = 1  then 'L' else '' end) as fcL, 
--isnull(sum(case when bc.fcDoanhThu_Loai in('01', '012' , '013' , '014','015','016','017') then bc.fnQuantity else 0 end ),0) as fnGUA,
fnSoLuongDK as fnGUA,
bk.fnEXP , bk.fcStatus_BkRoom as fcStatus, bk.fcNote, 
(case when bk.fcStatus_BkRoom in ('T', 'A', 'P' ) then 'T'  else bk.fcStatus_BkRoom end )  as fcStatus_1, 
(case  When bk.fcBookID in (select distinct fcBookID from stBooking_Mice ) then 'Yes' else 'No' end) as fcMice,
left(cast(isnull(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('04') then fnPrice else 0 end ))-2)+'/'+left(cast(isnull(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ),0)as nvarchar(15)),len(sum(case when dt.fcgroup in('01') then fnPrice else 0 end ))-2) as fnPacket_Price,
isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0) as fnBQT_Food_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnKABIN_Rev,
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0) as fnRS_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*4
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*8 else 0 end), 0) as fnF_Rev,
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*2
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*4 else 0 end), 0) as fnB_Rev,
isnull(sum(case when dt.fcgroup in('02') then fnPrice else 0 end ), 0) as fnBev_Price,
isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0) as fnBev_Revenue,
(
isnull(sum(case when dt.fcgroup in('01') then fnPrice*bc.fnQuantity else 0 end ),0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','015') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('013','016') then bc.fnQuantity*bc.fnLunchPrice else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*4
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*8 else 0 end), 0)
-
isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*2
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*4 else 0 end), 0)
) + isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0)  as fnBQT_MICS,
-- else isnull(sum(case when dt.fcgroup  in('03') then fnAmount else 0 end), 0) end) as fnBQT_MICS,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*4
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*8 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('04')and bc.fnBreakDownLunch  <> 1 then fnAmount else 0 end ),0)as float))as fnTotal_F_Rev,

(isnull(sum(case when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('012','013'))or bc.fcDoanhThu_Loai in('014') then bc.fnQuantity*2
when (bc.fnBreakDownLunch = 1  and bc.fcDoanhThu_Loai in('015','016'))or bc.fcDoanhThu_Loai in('017') then bc.fnQuantity*4 else 0 end), 0)+
cast(isnull(sum(case when dt.fcgroup in('02') then fnAmount else 0 end ),0)as float))as fnTotal_B_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) as  fnTOTAL_Rev,
isnull(sum(case when bk.fcStatus_BkRoom not in('C') then fnAmount else 0 end ),0) -cast(isnull(sum(case when bc.fnBreakDownLunch=1 and bk.fcStatus_BkRoom not in('C') then bc.fnQuantity*bc.fnLunchPrice else 0 end),0) as decimal) as fnBQ_Rev_Only,
isnull(sum(case when bk.fcStatus_BkRoom ='C' then fnAmount else 0 end ),0) as  fnTOTAL_CXLD,
bk.fcUser as fcSP, bk.fdDate as fdDATE_RECEIVED, bk.fdDateConfirm as fdLAST_DAY_CONTACT
from stbooking bk 
left  join stBookFunctionRoom bf on bk.fcBookID = bf.fcBookID
left  join stBooking_Charges  bc on bk.fcBookID = bc.fcBookID and bf.fnCodeID = bc.fnCodeID
left  join stDoanhThu_loai dt on bc.fcDoanhThu_Loai = dt.fcCode
left join stKhachHang kh on kh.fcMa= bk.fcGuestID
left join stSukien sk on sk.fcMa= bf.fcFunctionType
left join stPhong p on p.fcMa= bf.fcFunctionRoom
left join stPhong_Loai pL on p.fcLoaiPhong= PL.fcmA
--left join stBooking_MICE m on bk.fcBookID=m.fcBookID
WHERE ( bf.fdDate  between @TuNgay and @DenNgay)  and bk.fcStatus_BkRoom='C'--  and ( @pcUser = '' or bk.fcUser = @pcUser )
GROUP BY bk.fcBookID,bf.fdDate, bk.fdDate,  kh.fcTen , bk.fcContactPerson, kh.fcMa, kh.fcMaNLH, pl.fcMa, pl.fcTen ,  bk.fnNo_of_ROOMs, bk.fnRoomRates, 
bk.fcUser, bk.fnSoLuongDK, bk.fnTotalRoomNight  ,bk.fnEXP , bk.fcStatus_BkRoom  , bk.fdDateConfirm, bf.fdTimeIn, bf.fdTimeOut, bk.fcGuestID , bk.fcNote
, p.fcTen -- ngoc them
, sk.fcTen -- Thang them
--HAVING not (pl.fcMa  in('04', '05','06') and isnull(sum(bc.fnQuantity), 0 )  <= 0)  --Ngoc bo
ORDER BY bf.fdDate
GO

IF OBJECT_ID('[dbo].[sp_XemDatPhong]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_XemDatPhong]
GO
CREATE PROCEDURE sp_XemDatPhong
(
@pTuNgay nchar(10),
@pDenNgay nchar(10)
)
as
--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
declare @sql nvarchar(2000)

select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TuDenNgay]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TuDenNgay]

select @sql = 'Create Table TuDenNgay (fcMaPhong nvarchar(20), TongSuKien int default 0, '
while datediff(d, @TuNgay, @DenNgay) >= 0
begin
	select @sql = @sql 
		+ '[' + right('0' + cast(day(@TuNgay) as nvarchar(2)), 2) + '/' + right('0' + cast(month(@TuNgay) as nvarchar(2)), 2) + '/' + cast(year(@TuNgay) as char(4)) + ']' 
		+ ' nchar(10) default ' + char(39) + char(39)
	select @tungay = dateadd(d, 1, @tungay)
	if datediff(d, @TuNgay, @DenNgay) >= 0
		select @sql = @sql + ', '
end
select @sql = @sql + ') on [primary]'
--print @sql 
--1. Tao bang voi so cot bang voi so ngay, cot dau tien la Ma phong
exec(@sql)

--2. Insert so phong vao bang 
insert into TuDenNgay(fcMaPhong) select fcMa from stPhong

--3. Fill thong tin dat phong vao bang
select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)

while datediff(d, @TuNgay, @DenNgay) >= 0
begin
	declare @dem nchar(10)
	declare @Cot nvarchar(15)

	DECLARE @Ma varchar(20)
	DECLARE phong_cursor CURSOR FOR
	select fcMa from stphong
	OPEN phong_cursor

	FETCH NEXT FROM phong_cursor INTO @Ma

	WHILE @@FETCH_STATUS = 0
	BEGIN
	 
		select @cot = '[' + right('0' + cast(day(@TuNgay) as nvarchar(2)), 2) + '/' + right('0' + cast(month(@TuNgay) as nvarchar(2)), 2) + '/' + cast(year(@TuNgay) as char(4)) + ']' 
		select @dem = count(*) from stSKLK l inner join stSKCT_Phong cp on l.fcMa = cp.fcMa 
	   	where (@tungay between l.fdNgayBatDau and fdNgayKetThuc)  and (cp.fcPhong = @Ma)

		if @Dem = '0'
			select @Dem = 'char(32)'

		select @sql = 'update TuDenNgay  set ' + @cot + ' = ' + @Dem + ' where fcMaPhong = ' + char(39) + @Ma + char(39)
		--Print @sql 
		exec(@sql)
	   FETCH NEXT FROM phong_cursor   INTO @Ma
	END
	CLOSE phong_cursor
	DEALLOCATE phong_cursor

	select @tungay = dateadd(d, 1, @tungay)
end
GO

IF OBJECT_ID('[dbo].[sp_XemDatPhong_Loai]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_XemDatPhong_Loai]
GO
CREATE PROCEDURE sp_XemDatPhong_Loai
(
@pTuNgay nchar(10),
@pDenNgay nchar(10)
)
as
--set dateformat dmy
set dateformat mdy
declare @TuNgay datetime
declare @DenNgay datetime
declare @sql nvarchar(2000)

select @TuNgay = cast(@pTuNgay as datetime)
select @DenNgay = cast(@pDenNgay as datetime)

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TuDenNgay_Loai]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TuDenNgay_Loai]

select @sql = 'Create Table TuDenNgay_Loai (fcMaLoai nvarchar(20), TongSoPhong int default 0, '
while datediff(d, @TuNgay, @DenNgay) >= 0
begin
	select @sql = @sql 
		+ '[' + right('0' + cast(day(@TuNgay) as nvarchar(2)), 2) + '/' + right('0' + cast(month(@TuNgay) as nvarchar(2)), 2) + '/' + cast(year(@TuNgay) as char(4)) + ']' 
		+ ' nchar(10) default ' + char(39) + char(39)
	select @tungay = dateadd(d, 1, @tungay)
	if datediff(d, @TuNgay, @DenNgay) >= 0
		select @sql = @sql + ', '
end
select @sql = @sql + ') on [primary]'
--print @sql 
--1. Tao bang voi so cot bang voi so ngay, cot dau tien la Ma phong
exec(@sql)

--2. Insert so loai phong vao bang 
insert into TuDenNgay_Loai(fcMaLoai) select fcMa from stPhong_Loai

--3. Fill thong tin tong so phong vao bang Loai phong
	declare @dem nchar(10)
	declare @Cot nvarchar(15)

	DECLARE @Ma varchar(20)
	DECLARE phong_cursor CURSOR FOR
	select fcMa from stphong_Loai
	OPEN phong_cursor

	FETCH NEXT FROM phong_cursor INTO @Ma

	WHILE @@FETCH_STATUS = 0
	BEGIN
	 	select @dem = '0'
		--print @ma
		select @dem = count(*) from stphong where left(fcma, 1) = @ma
		--select @ma + ': ' + @dem 
		update TuDenNgay_Loai set TongSoPhong = @dem where fcmaloai = @ma
	   FETCH NEXT FROM phong_cursor   INTO @Ma
	END
	CLOSE phong_cursor
	DEALLOCATE phong_cursor
GO

IF OBJECT_ID('[dbo].[sp_XemTyGia]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_XemTyGia]
GO
CREATE PROCEDURE sp_XemTyGia
as
select a.fdNgay, a.fcTienTe, b.fnGia from(
(select fcTienTe, max(fdngay) as fdNgay from sttygia group by fctiente) a
inner join
(select * from sttygia) b
on a.fctiente = b.fctiente and a.fdngay = b.fdngay
)
GO

IF OBJECT_ID('[dbo].[sp_YEARLY_BQRevenue]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_YEARLY_BQRevenue]
GO
-- NOTE Tat ca cac cot fcJan_Last, fcJan_Cur, fcFeb_Last, fcFeb_Cur, fcMar_Last, fcMar_Cur, ...  deu lay du lieu tu function dbo.sfACTUAL_byCharge
-- (TRANG THAI = D, voi @CurrDate = '')


CREATE PROCEDURE dbo.sp_YEARLY_BQRevenue 
(
	@pcYear nvarchar(4) ='2007'
)
 AS
--SET LOCK_TIMEOUT 120000
	SELECT  p.fcLoaiPhong, p.fcTen as fcFunctionRoom, bg.*, 
	cast ( 0 as decimal )   AS  fcJan_Last,   cast ( 0 as decimal )   AS  fcJan_Cur ,
	cast ( 0  as decimal )   AS  fcFeb_Last,  cast ( 0 as decimal )   AS fcFeb_Cur,
	cast ( 0  as decimal )   AS  fcMar_Last,  cast ( 0 as decimal )   AS  fcMar_Cur , 
	cast ( 0  as decimal )   AS  fcApr_Last,  cast ( 0  as decimal )  AS  fcApr_Cur, 
	cast ( 0  as decimal )   AS  fcMay_Last,  cast ( 0 as decimal )   AS  fcMay_Cur , 
	cast ( 0  as decimal )   AS  fcJun_Last,   cast ( 0  as decimal )  AS  fcJun_Cur,
	cast ( 0  as decimal )   AS fcJul_Last,     cast ( 0  as decimal )  AS fcJul_Cur , 
	cast ( 0  as decimal )   AS fcAug_Last,   cast ( 0  as decimal )  AS fcAug_Cur,
	cast ( 0  as decimal )   AS fcSep_Last,   cast ( 0  as decimal )  AS fcSep_Cur , 
	cast ( 0  as decimal )   AS fcOct_Last,   cast ( 0  as decimal )  AS fcOct_Cur,
	cast ( 0  as decimal )   AS fcNov_Last,  cast ( 0  as decimal )  AS fcNov_Cur , 
	cast ( 0  as decimal )   AS fcDec_Last,  cast ( 0  as decimal )  AS fcDec_Cur

	    , cast ( 0 as decimal )  as fcJan_Percent
	    , cast ( 0 as decimal )  as fcFeb_Percent
	    , cast ( 0 as decimal )  as fcMar_Percent	
	    , cast ( 0 as decimal )  as fcApr_Percent
	    , cast ( 0 as decimal )  as fcMay_Percent	
	    , cast ( 0 as decimal )  as fcJun_Percent
	    , cast ( 0 as decimal )  as fcJul_Percent	
	    , cast ( 0 as decimal )  as fcAug_Percent
	    , cast ( 0 as decimal )  as fcSep_Percent	
	    , cast ( 0 as decimal )  as fcOct_Percent	
	    , cast ( 0 as decimal )  as fcNov_Percent
	    , cast ( 0 as decimal )  as fcDec_Percent		

	FROM stBudget bg
	INNER JOIN  stPhong p ON bg.fcRoom = p.fcMa	
	WHERE fcYear = @pcYear
	ORDER BY fcLoaiPhong, fcFunctionRoom
GO

IF OBJECT_ID('[dbo].[spBooking_byStatus]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spBooking_byStatus]
GO
CREATE PROCEDURE spBooking_byStatus
(
	@pcFromDate	nvarchar(10),
	@pcToDate	nvarchar(10),
	@pcStatus	nvarchar(1) = '0' ,
	@pcFunctionType nvarchar(20) = '00',
	@pcLinhVuc	nvarchar(20) ='00'
)
 AS 

--set dateformat dmy
set dateformat mdy
declare @pdFromDate as datetime
declare @pdToDate as datetime
set @pdFromDate = cast(@pcFromDate as datetime)
set @pdToDate = cast(@pcToDate as datetime)

select distinct bk.fcBookID, bk.fcGuestID,  kh.fcTen as fcTenKH, bk.fcContactPerson, lv.fcName as fcLinhVuc
, (case when bk.fcStatus_BkRoom in('A','P','T') then 'T' else bk.fcStatus_BkRoom end ) as fcStatus_BkRoom --bk.fcStatus_BkRoom
, br.fdDate as fdFunctionDate,  s.fcTen as fcEvent , sum(isnull(bc.fnAmount, 0)) as fnRevenue
, bk.fcUser, bk.fdDate, bk.fdDateConfirm

from stBooking bk
left join stBookFunctionRoom br on bk.fcBookID = br.fcBookID 
left join stSuKien s on br.fcFunctionType = s.fcMa 
left join stBooking_Charges bc on bc.fcBookID = br.fcBookID and bc.fnCodeID =br.fnCodeID
left join stKhachHang  KH on bk.fcGuestID= kh.fcMa  left join stLinhVuc  lv on kh.fcLinhVuc= lv.fcCode 

where (br.fdDate between @pdFromDate and @pdToDate)
	 and (@pcStatus = '0' or bk.fcStatus_BkRoom = @pcStatus)  
	 and (@pcFunctionType = '00' or br.fcFunctionType = @pcFunctionType)
	 and (@pcLinhVuc = '00' or   kh.fcLinhVuc  = @pcLinhVuc)
group by bk.fcBookID, bk.fcGuestID, br.fdDate, kh.fcTen , bk.fcContactPerson, lv.fcName, bk.fcStatus_BkRoom
, s.fcTen, bk.fcUser, bk.fdDate, bk.fdDateConfirm

Order by br.fdDate
GO

IF OBJECT_ID('[dbo].[spFind_BEO]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spFind_BEO]
GO
/****** Object:  Stored Procedure dbo.spFind_BEO    Script Date: 01/19/2009 10:05:33 AM ******/


CREATE PROCEDURE spFind_BEO 
(
	@pcUserName nvarchar(20) = ''
)
AS

	select distinct  eo.fcMaster_EO, convert(nvarchar(10),  eo.fdDate ,7) AS fdDate, kh.fcTen, eo.fcNguoiLap , (dbo.Get_stringFunctionDate(eo.fcMaster_EO,'1')) as fcFunctionDate,
	(case when convert(nvarchar(10),eo.fdDepositDate,7)='Jan 01, 00' then null else convert(nvarchar(10),  eo.fdDepositDate ,7) end )AS fdDepositDate
	from stmaster_EO eo   
	left join stSKLK lk on lk.fcMaster_EO=eo.fcMaster_EO
	left join stUser u on eo.fcNguoiLap= u.fcUserName 
	left join stKhachHang kh on kh.fcMa= eo.fcguestCode
	--where (@pcUserName = '' or eo.fcNguoiLap = @pcUserName)
GO

IF OBJECT_ID('[dbo].[spFind_BEO_New]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spFind_BEO_New]
GO
/****** Object:  Stored Procedure dbo.spFind_BEO    Script Date: 01/19/2009 10:05:33 AM ******/


CREATE PROCEDURE [dbo].[spFind_BEO_New] 
(
	@pcUserName nvarchar(20) = '',
	@pdDate smalldatetime
)
AS

	select distinct  eo.fcMaster_EO, convert(nvarchar(10),  eo.fdDate ,7) AS fdDate, kh.fcTen, eo.fcNguoiLap , (dbo.Get_stringFunctionDate(eo.fcMaster_EO,'1')) as fcFunctionDate,
	(case when convert(nvarchar(10),eo.fdDepositDate,7)='Jan 01, 00' then null else convert(nvarchar(10),  eo.fdDepositDate ,7) end )AS fdDepositDate
	from stmaster_EO eo   
	left join stSKLK lk on lk.fcMaster_EO=eo.fcMaster_EO
	left join stUser u on eo.fcNguoiLap= u.fcUserName 
	left join stKhachHang kh on kh.fcMa= eo.fcguestCode
	where lk.fdEventDate  >= @pdDate
	--select  distinct convert(nvarchar(10), fdEventDate, 6) from stSKLK where fcMaster_EO=@pcBookID
	--eo.fdDate >= @pdDate
GO

IF OBJECT_ID('[dbo].[spFindImage_ofSetuppedRoom]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spFindImage_ofSetuppedRoom]
GO
CREATE PROCEDURE spFindImage_ofSetuppedRoom  
(
	@pcRoom nvarchar(10)  ='',
	@pcSetupType nvarchar(10) = '',
	@pcImageCode nvarchar(10) = ''
)
AS
	select rs.fcRoom, rs.fcSetup , i.* from stImage_Setup rs left join stImage i on rs.fcImageCode = i.fcCode 
	where (@pcRoom = '' or rs.fcRoom=rtrim(@pcRoom)) 
	and (@pcSetupType = '' or  rs.fcSetup = rtrim(@pcSetupType)) 
	and (@pcImageCode = '' or  rs.fcImageCode like '%'+ ltrim(rtrim(@pcImageCode )) +'%')
GO

IF OBJECT_ID('[dbo].[spGet_CustomerInfor]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spGet_CustomerInfor]
GO
CREATE PROCEDURE spGet_CustomerInfor 
(
	@CustomerCode nvarchar(20) = '',
	@CustomerName nvarchar(255) = ''
)
AS

SELECT  fcMa, fcTen AS fcOrganization
	, (select top 1 fcTenNLH from stKhachHang_NguoiLH where fcMaNLH = kh.fcMaNLH) as fcContactPerson
	, fcTelephone, fcPhone_Office, fcFax
FROM  stKhachHang kh 
WHERE  (@CustomerCode = '' OR  kh.fcMa = @CustomerCode)
AND  (@CustomerName = '' OR fcTen LIKE  N'%'+ @CustomerName +'%')
GO

IF OBJECT_ID('[dbo].[spGet_FunctionRoom_PrintBEO]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spGet_FunctionRoom_PrintBEO]
GO
CREATE PROCEDURE spGet_FunctionRoom_PrintBEO ( --**** Print TIMEIN, TIMEOUT, LOCATION  in report xRptBEO
	@pcOrderID nvarchar(20) 
	
)
AS


select distinct dbo.fDefind(dbo.GetNames_Print_BEO( rs.fcOrderNo,  p.fcLoaiPhong, rs.fdTimeIn, rs.fdTimeOut)) as fcFunctionRoom , rs.fcOrderNo, 
rs.fdTimeIn, rs.fdTimeOut, p.fcLoaiPhong, dbo.Get_CodeID(rs.fcOrderNo, rs.fdTimeIn, rs.fdTimeOut, p.fcLoaiPhong) as fnCodeID 
from stRoom_Setup rs 
inner join stPhong p on rs.fcRoom = p.fcMa  
where (fcOrderNo=@pcOrderID) 
order by fnCodeID
GO

IF OBJECT_ID('[dbo].[spGet_FunctionRoom_PrintBEO_Ngoc]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spGet_FunctionRoom_PrintBEO_Ngoc]
GO
CREATE PROCEDURE [dbo].[spGet_FunctionRoom_PrintBEO_Ngoc] ( --**** Print TIMEIN, TIMEOUT, LOCATION  in report xRptBEO
	@pcOrderID nvarchar(20) 	
)
AS


--select distinct dbo.fDefind(dbo.GetNames_Print_BEO( rs.fcOrderNo,  p.fcLoaiPhong, rs.fdTimeIn, rs.fdTimeOut)) as fcFunctionRoom , rs.fcOrderNo, 
select distinct p.fcTen as fcFunctionRoom , rs.fcOrderNo, --ngoc them
rs.fdTimeIn, rs.fdTimeOut, p.fcLoaiPhong, dbo.Get_CodeID(rs.fcOrderNo, rs.fdTimeIn, rs.fdTimeOut, p.fcLoaiPhong) as fnCodeID 
from stRoom_Setup rs 
inner join stPhong p on rs.fcRoom = p.fcMa  
where (fcOrderNo=@pcOrderID) 
order by fnCodeID
GO

IF OBJECT_ID('[dbo].[spGet_lookupFOLIO_ofCopyPageEO]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spGet_lookupFOLIO_ofCopyPageEO]
GO
CREATE PROCEDURE [dbo].[spGet_lookupFOLIO_ofCopyPageEO] 
(
	@pcUserName nvarchar(20) = ''
)
AS
	select distinct  eo.fcMaster_EO, eo.fdDate, kh.fcTen, eo.fcNguoiLap ,(dbo.Get_stringFunctionDate(eo.fcMaster_EO,'1')) as fcFunctionDate
            from stmaster_EO eo   
            --inner join stUser u on eo.fcNguoiLap= u.fcUserName 
            inner join stKhachHang kh on kh.fcMa= eo.fcguestCode
            inner join stSKLK lk on lk.fcMaster_EO=eo.fcMaster_EO
            Where (lk.fcTrangThai<>'R') --and (@pcUserName = '' or eo.fcNguoiLap = @pcUserName)
			order by  eo.fcMaster_EO
GO

IF OBJECT_ID('[dbo].[spGetFULLY_BOOKED]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spGetFULLY_BOOKED]
GO
CREATE PROCEDURE dbo.spGetFULLY_BOOKED
(
	@pcFromDate nvarchar(10),
	@pcToDate nvarchar(10)
)
AS
--set dateformat dmy
set dateformat mdy
declare @pdFromDate  smalldatetime
declare @pdToDate  smalldatetime
set @pdFromDate  = cast ( @pcFromDate  as smalldatetime )
set @pdToDate  = cast ( @pcToDate  as smalldatetime )

SELECT  kh.fcTen  as fcOrganization,bk.fcContactPerson,  bk.fdDateConfirm as fdFunctionDate, convert(nvarchar(10), bk.fdDateConfirm, 6) as fcFunctionDate, 
bk.fdDate as fdDATE_RECEIVED, bk.fnSoLuongDK as  fnGUA, bk.fnEXP, bk.fcNote as fcRemark, bk.fcUser as fcSP, bk.fcStatus_BkRoom as fcStatus 
FROM  stBooking bk  
INNER JOIN  stKhachhang kh ON  bk.fcGuestID = kh.fcMa 
WHERE (fdDateConfirm BETWEEN @pdFromDate  AND  @pdToDate )  AND  (fcStatus_BkRoom = 'F' )
GO

IF OBJECT_ID('[dbo].[spGetListBEO_byDate]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spGetListBEO_byDate]
GO
CREATE proc spGetListBEO_byDate
(
	@pcFromDate as nvarchar(10),
	@pcToDate as nvarchar(10),
	@User as nvarchar(20)=''
)
as
--set dateformat dmy
set dateformat mdy
declare @pdFromDate smalldatetime
declare @pdToDate smalldatetime
select @pdFromDate = cast(@pcFromDate as SMALLdatetime)
select @pdToDate = cast(@pcToDate  as smalldatetime)



select distinct l.fcMaster_EO , m.fcBookID,  l.fcOrderNo, b.fdDate as fdBookDate, b.fdDateConfirm, kh.fcTen as fcOrganization, m.fcContactPerson,  m.fcNguoiLap as fcUser, l.fcTrangThai , 
l.fdEventDate ,  convert(nvarchar(5), rst.fdTimeIn, 8) as fdTimeIn,  convert(nvarchar(5), rst.fdTimeOut ,  8)  as  fdTimeOut,
dbo.fDefind(dbo.GetNames_BEO(@pdFromDate, @pdToDate, rst.fdTimeIn, rst.fdTimeOut , l.fcOrderNo, p.fcLoaiPhong)) as fcFunctionRoom

from stMaster_EO m 
inner join  stSKLK l  on  m.fcMaster_EO = l.fcMaster_EO
left join stRoom_Setup  rst on l.fcMaster_EO= rst.fcMaster_EO and l.fcOrderNo  = rst.fcOrderNo 
left join stKhachHang kh on m.fcGuestCode = kh.fcMa
left join stBooking b on m.fcBookID = b.fcBookID
inner join stPhong p on p.fcMa = rst.fcRoom 

Where( l.fdEventDate between @pdFromDate and @pdToDate) --and (@User='' or m.fcNguoiLap=@User) 
Order by  l.fdEventDate
GO

IF OBJECT_ID('[dbo].[spGetListBookfunctionRoomForDate]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spGetListBookfunctionRoomForDate]
GO
CREATE proc spGetListBookfunctionRoomForDate
(
	@type as nvarchar(20)=0,
	@pcFromDate as nvarchar(10),
	@pcToDate as nvarchar(10),
	@User as nvarchar(20)='',
	@CurrentDate as nvarchar(10)=''
)
as
--set dateformat dmy
set dateformat mdy
declare @pdFromDate smalldatetime
declare @pdToDate smalldatetime
select @pdFromDate = cast(@pcFromDate as SMALLdatetime)
select @pdToDate = cast(@pcToDate  as smalldatetime)


if @type=0  -- NOT ORVER CONFIRM DATE
begin 

select a.fcBookID,a.fdDate as fdBookDate,a.fdDateConfirm, a1.fcTen, a.fcUser,  
(case when a.fcStatus_BkRoom in('A','P','T') then 'T' else a.fcStatus_BkRoom end)as fcStatus_BkRoom, 
--a1.fcNguoiLienhe as fcContactPerson, 
(case a.fcContactPerson when '' then a1.fcNguoiLienHe else a.fcContactPerson end ) as fcContactPerson , 
a1.fcTelephone, a1.fcEmail,a1.fcFax,a1.fcDiaChi, b.fdDate as fdFunctionDate, 
convert(nvarchar(5), b.fdTimeIn, 8) as fdTimeIn,  convert(nvarchar(5), b.fdTimeOut, 8) as fdTimeOut
, (Select fcFullName from stUser Where fcUserName=a.fcUser) as fcPrepareBy
, (Select case when fcName in('Agreement','Proposal','Tentative')then 'Tentative'else fcName end  From stBooking_Status Where fcCode = a.fcStatus_BkRoom) as fcStatusBook
, dbo.fDefind(dbo.GetNames_BookfunctionRoom(p.fcloaiphong, b.fdTimeIn, b.fdTimeOut, a.fcBookID)) as fcFuncRoomName
, (case a.fcBookID When m.fcBookID then 'Yes' else 'No' end) as fcMice
, (case a.fcBookID When m.fcBookID then m.fcGroupName else '' end) as fcGroupName

from stBooking a inner join stBookFunctionRoom b
on a.fcBookID = b.fcBookID left join stKhachHang a1 on a.fcGuestID = a1.fcMa
inner join stPhong p on p.fcMa = b.fcFunctionRoom 
left join stBooking_MICE m on a.fcBookID=m.fcBookID

Where (b.fdDate between @pdFromDate and @pdToDate) and (@User='' or a.fcUser=@User)
group by a.fcBookID,a.fdDate, a.fdDateConfirm, a1.fcTen, a1.fcNguoiLienhe, a.fcContactPerson, a1.fcTelephone, a1.fcEmail, a1.fcFax, a1.fcDiaChi, 
b.fdDate, b.fdTimeIn, b.fdTimeOut, a.fcUser, a.fcStatus_BkRoom, p.fcLoaiPhong , m.fcGroupName,m.fcBookID
Order by  b.fdDate 

end 

else   --  ORVER CONFIRM DATE
begin 
select a.fcBookID,a.fdDate as fdBookDate,a.fdDateConfirm, a1.fcTen,
a1.fcNguoiLienhe as fcContactPerson, a1.fcTelephone, a1.fcEmail,a1.fcFax,a1.fcDiaChi, 
b.fdDate as fdFunctionDate, b.fdTimeIn, b.fdTimeOut
, (Select fcFullName from stUser Where fcUserName=a.fcUser) as fcPrepareBy
, (Select fcName From stBooking_Status Where fcCode = a.fcStatus_BkRoom) as fcStatusBook
, dbo.fDefind(dbo.GetNames_BookfunctionRoom(p.fcloaiphong, b.fdTimeIn, b.fdTimeOut, a.fcBookID)) as fcFuncRoomName
, (case a.fcBookID When m.fcBookID then 'Yes' else 'No' end) as fcMice
, (case a.fcBookID When m.fcBookID then m.fcGroupName else '' end) as fcGroupName

from stBooking a inner join stBookFunctionRoom b
on a.fcBookID = b.fcBookID inner join stKhachHang a1 on a.fcGuestID = a1.fcMa
inner join stPhong p on p.fcMa = b.fcFunctionRoom 
left join stBooking_MICE m on a.fcBookID=m.fcBookID

Where (b.fdDate between @pdFromDate and @pdToDate) and (@User='' or a.fcUser=@User) and (a.fdDateConfirm<@CurrentDate or @CurrentDate='')
group by a.fcBookID,a.fdDate, a.fdDateConfirm, a1.fcTen, a1.fcNguoiLienhe, a1.fcTelephone, a1.fcEmail, a1.fcFax, a1.fcDiaChi, 
b.fdDate, b.fdTimeIn, b.fdTimeOut, a.fcUser, a.fcStatus_BkRoom, p.fcLoaiPhong  , m.fcGroupName,m.fcBookID
Order by  b.fdDate 
end
GO

IF OBJECT_ID('[dbo].[spGetListBookfunctionRoomForDate_NEW]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spGetListBookfunctionRoomForDate_NEW]
GO
/****** Object:  Stored Procedure dbo.spGetListBookfunctionRoomForDate_NEW    Script Date: 01/19/2009 10:05:33 AM ******/





CREATE proc spGetListBookfunctionRoomForDate_NEW
-- Update 09/08/2007: cho phep show nhung booking co MICE or show tat ca, va update ContactPerson 
(
	@Book_NotRoom as nvarchar(1)='1',
	@pcFromDate as nvarchar(10),
	@pcToDate as nvarchar(10),
	@User as nvarchar(20)='',
	@CurrentDate as nvarchar(10)='',
	@pcIsMICE as nvarchar(3)= ''
)
as
--set dateformat dmy
set dateformat mdy
declare @pdFromDate smalldatetime
declare @pdToDate smalldatetime
select @pdFromDate = cast(@pcFromDate as SMALLdatetime)
select @pdToDate = cast(@pcToDate  as smalldatetime)


if @Book_NotRoom ='0'  -- BOOKING CO  BOOK FUNCTIONROOM 
BEGIN 

	select a.fcBookID, convert(nvarchar(10), a.fdDate ,7) as fdBookDate, convert(nvarchar(10), a.fdDateConfirm,  7) as fdDateConfirm , a1.fcTen, a.fcUser, a.fcStatus_BkRoom, 
	(case a.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = a1.fcma and fcMaNLH = a1.fcMaNLH) else a.fcContactPerson end ) as fcContactPerson , 
	a1.fcTelephone, a1.fcEmail,a1.fcFax,a1.fcDiaChi, isnull(b.fdDate, '01/01/1900') as fdFunctionDate, 
	convert(nvarchar(5), b.fdTimeIn, 8) as fdTimeIn,  convert(nvarchar(5), b.fdTimeOut, 8) as fdTimeOut
	, (Select fcFullName from stUser Where fcUserName=a.fcUser) as fcPrepareBy
	, (Select case when fcName in ('Tentative','Agreement','Proposal')then 'Tentative' else fcName end From stBooking_Status Where fcCode = a.fcStatus_BkRoom) as fcStatusBook
	, dbo.fDefind(dbo.GetNames_BookfunctionRoom(p.fcloaiphong, b.fdTimeIn, b.fdTimeOut, a.fcBookID)) as fcFuncRoomName
	, (case a.fcBookID When m.fcBookID then 'Yes' else 'No' end) as fcMice
	, (case a.fcBookID When m.fcBookID then m.fcGroupName else '' end) as fcGroupName, a.fcNote
	
	from stBooking a left join stBookFunctionRoom b
	on a.fcBookID = b.fcBookID left join stKhachHang a1 on a.fcGuestID = a1.fcMa
	left join stPhong p on p.fcMa = b.fcFunctionRoom 
	left join stBooking_MICE m on a.fcBookID=m.fcBookID
	--Where (@User='' or a.fcUser=@User) and  (b.fdDate between @pdFromDate and @pdToDate)  and ( @CurrentDate='' or a.fdDateConfirm <@CurrentDate )
	Where (b.fdDate between @pdFromDate and @pdToDate)  and ( @CurrentDate='' or a.fdDateConfirm <@CurrentDate )
	-- Kiem tra co group MICE
	and (@pcIsMICE ='' or (case a.fcBookID When m.fcBookID then 'Yes' else 'No' end)= @pcIsMICE)

	group by a.fcBookID,a.fdDate, a.fdDateConfirm , a1.fcTen, a1.fcMa, a1.fcMaNLH, a.fcContactPerson, a1.fcTelephone, a1.fcEmail, a1.fcFax, a1.fcDiaChi, 
	b.fdDate, b.fdTimeIn, b.fdTimeOut, a.fcUser, a.fcStatus_BkRoom, p.fcLoaiPhong , m.fcGroupName, m.fcBookID, a.fcNote
	Order by  b.fdDate 

END

ELSE -- BOOKING KHONG  BOOK BAT KY FUNCTIONROOM NAO CA
BEGIN 
	select a.fcBookID, convert(nvarchar(10), a.fdDate , 7) as fdBookDate, convert(nvarchar(10), a.fdDateConfirm,  7) as fdDateConfirm , a1.fcTen, a.fcUser, a.fcStatus_BkRoom, 
	(case a.fcContactPerson when '' then a1.fcNguoiLienHe else a.fcContactPerson end ) as fcContactPerson , 
	a1.fcTelephone, a1.fcEmail,a1.fcFax,a1.fcDiaChi, b.fdDate as fdFunctionDate, 
	convert(nvarchar(5), b.fdTimeIn, 8) as fdTimeIn,  convert(nvarchar(5), b.fdTimeOut, 8) as fdTimeOut
	, (Select fcFullName from stUser Where fcUserName=a.fcUser) as fcPrepareBy
	, (Select case when fcName in ('Tentative','Agreement','Proposal')then 'Tentative' else fcName end From stBooking_Status Where fcCode = a.fcStatus_BkRoom) as fcStatusBook
	, dbo.fDefind(dbo.GetNames_BookfunctionRoom(p.fcloaiphong, b.fdTimeIn, b.fdTimeOut, a.fcBookID)) as fcFuncRoomName
	, (case a.fcBookID When m.fcBookID then 'Yes' else 'No' end) as fcMice
	, (case a.fcBookID When m.fcBookID then m.fcGroupName else '' end) as fcGroupName
	
	from stBooking a left join stBookFunctionRoom b
	on a.fcBookID = b.fcBookID left join stKhachHang a1 on a.fcGuestID = a1.fcMa
	left join stPhong p on p.fcMa = b.fcFunctionRoom 
	left join stBooking_MICE m on a.fcBookID=m.fcBookID
	Where (a.fbMICE <> 'L') and  ( @CurrentDate='' or a.fdDateConfirm<@CurrentDate )  and (b.fdDate =NULL)
	group by a.fcBookID,a.fdDate, a.fdDateConfirm, a1.fcTen, a1.fcNguoiLienhe, a.fcContactPerson, a1.fcTelephone, a1.fcEmail, a1.fcFax, a1.fcDiaChi, 
	b.fdDate, b.fdTimeIn, b.fdTimeOut, a.fcUser, a.fcStatus_BkRoom, p.fcLoaiPhong , m.fcGroupName,m.fcBookID
	Order by  b.fdDate 
END
GO

IF OBJECT_ID('[dbo].[spGetListBookfunctionRoomForDate_NEW_ct]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spGetListBookfunctionRoomForDate_NEW_ct]
GO
CREATE proc spGetListBookfunctionRoomForDate_NEW_CT
-- Update 09/08/2007: cho phep show nhung booking co MICE or show tat ca, va update ContactPerson 
(
	@Book_NotRoom as nvarchar(1)='1',
	@pcFromDate as nvarchar(10),
	@pcToDate as nvarchar(10),
	@User as nvarchar(20)='',
	@CurrentDate as nvarchar(10)='',
	@pcIsMICE as nvarchar(3)= ''
)
as
set dateformat mdy
declare @pdFromDate smalldatetime
declare @pdToDate smalldatetime
select @pdFromDate = cast(@pcFromDate as SMALLdatetime)
select @pdToDate = cast(@pcToDate  as smalldatetime)


if @Book_NotRoom ='0'  -- BOOKING CO  BOOK FUNCTIONROOM 
BEGIN 

	select a.fcBookID, convert(nvarchar(10), a.fdDate , 7) as fdBookDate, convert(nvarchar(10), a.fdDateConfirm,  7) as fdDateConfirm , a1.fcTen, a.fcUser, a.fcStatus_BkRoom, 
	(case a.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = a1.fcma and fcMaNLH = a1.fcMaNLH) else a.fcContactPerson end ) as fcContactPerson , 
	a1.fcTelephone, a1.fcEmail,a1.fcFax,a1.fcDiaChi, isnull(b.fdDate, '01/01/1900') as fdFunctionDate, 
	convert(nvarchar(5), b.fdTimeIn, 8) as fdTimeIn,  convert(nvarchar(5), b.fdTimeOut, 8) as fdTimeOut
	, (Select fcFullName from stUser Where fcUserName=a.fcUser) as fcPrepareBy
	, (Select case when fcName in ('Tentative','Agreement','Proposal')then 'Tentative' else fcName end From stBooking_Status Where fcCode = a.fcStatus_BkRoom) as fcStatusBook
	, dbo.fDefind(dbo.GetNames_BookfunctionRoom(p.fcloaiphong, b.fdTimeIn, b.fdTimeOut, a.fcBookID)) as fcFuncRoomName
	, (case a.fcBookID When m.fcBookID then 'Yes' else 'No' end) as fcMice
	, (case a.fcBookID When m.fcBookID then m.fcGroupName else '' end) as fcGroupName, a.fcNote
	
	from stBooking a left join stBookFunctionRoom b
	on a.fcBookID = b.fcBookID left join stKhachHang a1 on a.fcGuestID = a1.fcMa
	left join stPhong p on p.fcMa = b.fcFunctionRoom 
	left join stBooking_MICE m on a.fcBookID=m.fcBookID
	Where (@User='' or a.fcUser=@User) and  (b.fdDate between @pdFromDate and @pdToDate)  and ( @CurrentDate='' or a.fdDateConfirm <@CurrentDate )
	-- Kiem tra co group MICE
	and (@pcIsMICE ='' or (case a.fcBookID When m.fcBookID then 'Yes' else 'No' end)= @pcIsMICE)

	group by a.fcBookID,a.fdDate, a.fdDateConfirm , a1.fcTen, a1.fcMa, a1.fcMaNLH, a.fcContactPerson, a1.fcTelephone, a1.fcEmail, a1.fcFax, a1.fcDiaChi, 
	b.fdDate, b.fdTimeIn, b.fdTimeOut, a.fcUser, a.fcStatus_BkRoom, p.fcLoaiPhong , m.fcGroupName, m.fcBookID, a.fcNote
	Order by  b.fdDate 

END

ELSE -- BOOKING KHONG  BOOK BAT KY FUNCTIONROOM NAO CA
BEGIN 
	select a.fcBookID, convert(nvarchar(10), a.fdDate , 7) as fdBookDate, convert(nvarchar(10), a.fdDateConfirm,  7) as fdDateConfirm , a1.fcTen, a.fcUser, a.fcStatus_BkRoom, 
	(case a.fcContactPerson when '' then a1.fcNguoiLienHe else a.fcContactPerson end ) as fcContactPerson , 
	a1.fcTelephone, a1.fcEmail,a1.fcFax,a1.fcDiaChi, b.fdDate as fdFunctionDate, 
	convert(nvarchar(5), b.fdTimeIn, 8) as fdTimeIn,  convert(nvarchar(5), b.fdTimeOut, 8) as fdTimeOut
	, (Select fcFullName from stUser Where fcUserName=a.fcUser) as fcPrepareBy
	, (Select case when fcName in ('Tentative','Agreement','Proposal')then 'Tentative' else fcName end From stBooking_Status Where fcCode = a.fcStatus_BkRoom) as fcStatusBook
	, dbo.fDefind(dbo.GetNames_BookfunctionRoom(p.fcloaiphong, b.fdTimeIn, b.fdTimeOut, a.fcBookID)) as fcFuncRoomName
	, (case a.fcBookID When m.fcBookID then 'Yes' else 'No' end) as fcMice
	, (case a.fcBookID When m.fcBookID then m.fcGroupName else '' end) as fcGroupName
	
	from stBooking a left join stBookFunctionRoom b
	on a.fcBookID = b.fcBookID left join stKhachHang a1 on a.fcGuestID = a1.fcMa
	left join stPhong p on p.fcMa = b.fcFunctionRoom 
	left join stBooking_MICE m on a.fcBookID=m.fcBookID
	--Where (a.fbMICE <> 'L') and  (@User='' or a.fcUser=@User) and  (a.fdDate between @pdFromDate and @pdToDate) and ( @CurrentDate='' or a.fdDateConfirm<@CurrentDate )  and (b.fdDate =NULL)
	
	Where (a.fbMICE <> 'L') and  (@User='' or a.fcUser=@User) AND (m.fdCheckIn between @pdFromDate and @pdToDate OR m.fdCheckOut  between @pdFromDate and @pdToDate)and ( @CurrentDate='' or a.fdDateConfirm<@CurrentDate )  and (b.fdDate is NULL)
	group by a.fcBookID,a.fdDate, a.fdDateConfirm, a1.fcTen, a1.fcNguoiLienhe, a.fcContactPerson, a1.fcTelephone, a1.fcEmail, a1.fcFax, a1.fcDiaChi, 
	b.fdDate, b.fdTimeIn, b.fdTimeOut, a.fcUser, a.fcStatus_BkRoom, p.fcLoaiPhong , m.fcGroupName,m.fcBookID
	Order by  b.fdDate 
END
GO

IF OBJECT_ID('[dbo].[spGetListBookfunctionRoomForDate_NEW_ct2812]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spGetListBookfunctionRoomForDate_NEW_ct2812]
GO
/****** Object:  Stored Procedure dbo.spGetListBookfunctionRoomForDate_NEW_ct    Script Date: 01/19/2009 10:05:33 AM ******/
CREATE proc spGetListBookfunctionRoomForDate_NEW_ct2812
-- Update 09/08/2007: cho phep show nhung booking co MICE or show tat ca, va update ContactPerson 
(
	@Book_NotRoom as nvarchar(1)='1',
	@pcFromDate as nvarchar(10)
)
as
--set dateformat dmy
set dateformat mdy
declare @pdFromDate smalldatetime
select @pdFromDate = cast(@pcFromDate as SMALLdatetime)

if @Book_NotRoom ='0'  -- BOOKING CO  BOOK FUNCTIONROOM 
BEGIN 

	select a.fcBookID, convert(nvarchar(10), a.fdDateContract ,7) as fdBookDate, convert(nvarchar(10), a.fdDateConfirm,  7) as fdDateConfirm , a1.fcTen, a.fcUser, a.fcStatus_BkRoom, 
	(case a.fcContactPerson when '' then (select fcTenNLH from stKhachHang_NguoiLH where fcKhachHang_ID = a1.fcma and fcMaNLH = a1.fcMaNLH) else a.fcContactPerson end ) as fcContactPerson , 
	a1.fcTelephone, a1.fcEmail,a1.fcFax,a1.fcDiaChi, isnull(b.fdDate, '01/01/1900') as fdFunctionDate, 
	convert(nvarchar(5), b.fdTimeIn, 8) as fdTimeIn,  convert(nvarchar(5), b.fdTimeOut, 8) as fdTimeOut
	, (Select fcFullName from stUser Where fcUserName=a.fcUser) as fcPrepareBy
	, (Select case when fcName in ('Tentative','Agreement','Proposal')then 'Tentative' else fcName end From stBooking_Status Where fcCode = a.fcStatus_BkRoom) as fcStatusBook
	, dbo.fDefind(dbo.GetNames_BookfunctionRoom(p.fcloaiphong, b.fdTimeIn, b.fdTimeOut, a.fcBookID)) as fcFuncRoomName
	, (case a.fcBookID When m.fcBookID then 'Yes' else 'No' end) as fcMice
	, (case a.fcBookID When m.fcBookID then m.fcGroupName else '' end) as fcGroupName, a.fcNote
	
	from stBooking a left join stBookFunctionRoom b
	on a.fcBookID = b.fcBookID left join stKhachHang a1 on a.fcGuestID = a1.fcMa
	left join stPhong p on p.fcMa = b.fcFunctionRoom 
	left join stBooking_MICE m on a.fcBookID=m.fcBookID
	
	where convert(nvarchar(10), a.fdDateConfirm ,7)=convert(nvarchar(10), @pdFromDate ,7)
	group by a.fcBookID,a.fdDateContract ,a.fdDateConfirm , a1.fcTen, a1.fcMa, a1.fcMaNLH, a.fcContactPerson, a1.fcTelephone, a1.fcEmail, a1.fcFax, a1.fcDiaChi, 
	b.fdDate, b.fdTimeIn, b.fdTimeOut, a.fcUser, a.fcStatus_BkRoom, p.fcLoaiPhong , m.fcGroupName, m.fcBookID, a.fcNote
	Order by  b.fdDate 

END

ELSE -- BOOKING KHONG  BOOK BAT KY FUNCTIONROOM NAO CA
BEGIN 
	select a.fcBookID, convert(nvarchar(10), a.fdDateContract , 7) as fdBookDate, convert(nvarchar(10), a.fdDateConfirm,  7) as fdDateConfirm , a1.fcTen, a.fcUser, a.fcStatus_BkRoom, 
	(case a.fcContactPerson when '' then a1.fcNguoiLienHe else a.fcContactPerson end ) as fcContactPerson , 
	a1.fcTelephone, a1.fcEmail,a1.fcFax,a1.fcDiaChi, b.fdDate as fdFunctionDate, 
	convert(nvarchar(5), b.fdTimeIn, 8) as fdTimeIn,  convert(nvarchar(5), b.fdTimeOut, 8) as fdTimeOut
	, (Select fcFullName from stUser Where fcUserName=a.fcUser) as fcPrepareBy
	, (Select case when fcName in ('Tentative','Agreement','Proposal')then 'Tentative' else fcName end From stBooking_Status Where fcCode = a.fcStatus_BkRoom) as fcStatusBook
	, dbo.fDefind(dbo.GetNames_BookfunctionRoom(p.fcloaiphong, b.fdTimeIn, b.fdTimeOut, a.fcBookID)) as fcFuncRoomName
	, (case a.fcBookID When m.fcBookID then 'Yes' else 'No' end) as fcMice
	, (case a.fcBookID When m.fcBookID then m.fcGroupName else '' end) as fcGroupName
	
	from stBooking a left join stBookFunctionRoom b
	on a.fcBookID = b.fcBookID left join stKhachHang a1 on a.fcGuestID = a1.fcMa
	left join stPhong p on p.fcMa = b.fcFunctionRoom 
	left join stBooking_MICE m on a.fcBookID=m.fcBookID
	where convert(nvarchar(10), a.fdDateContract ,7)=convert(nvarchar(10), @pdFromDate ,7)
	group by a.fcBookID,a.fdDateContract, a.fdDateConfirm, a1.fcTen, a1.fcNguoiLienhe, a.fcContactPerson, a1.fcTelephone, a1.fcEmail, a1.fcFax, a1.fcDiaChi, 
	b.fdDate, b.fdTimeIn, b.fdTimeOut, a.fcUser, a.fcStatus_BkRoom, p.fcLoaiPhong , m.fcGroupName,m.fcBookID
	Order by  b.fdDate 
END
GO

IF OBJECT_ID('[dbo].[spGetUserChuaPhanQuyen]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spGetUserChuaPhanQuyen]
GO
/*
Hàm tra ve nhung user chua duoc phan quyen trong usergroup
Xet theo thuat toan moi nguoi chi thuoc 1 nhom
*/
CREATE PROCEDURE dbo.spGetUserChuaPhanQuyen
(
		@User nvarchar(20) = ''
)

AS
Select * From(
Select * from stUser where fcUserName not in(
Select distinct * from(
	Select fcUserName from stUserGroup
	union All
	Select fcOwner as fcUserName from stUserGroup
)tmp)
)a Where @User='' or fcUserName like '%' + @User + '%' 

	RETURN
GO

IF OBJECT_ID('[dbo].[spGetUserOnForm]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spGetUserOnForm]
GO
CREATE PROCEDURE dbo.spGetUserOnForm
	(
		@User nchar(20)='',
		@frmName nchar(20)=''
	)

AS
SELECT stUserMenu.*, stMenu.*
FROM   stUserMenu INNER JOIN
       stMenu ON stUserMenu.fcMenuCode = stMenu.fcMenuCode
       WHERE (@user='' or stUserMenu.fcUserName = @User) AND (@frmName='' or stMenu.fcForm = @frmName)
                     
RETURN
GO

IF OBJECT_ID('[dbo].[spKiemTraTimeIn_Time_TonTai]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spKiemTraTimeIn_Time_TonTai]
GO
CREATE PROCEDURE spKiemTraTimeIn_Time_TonTai
( 
	@FunctionRoom nvarchar(20),
	@pdTimeIn  datetime,
	@pdTimeOut datetime
)
as
--set dateformat dmy
set dateformat mdy
/*
select * from (
	select fcRoom,fdTimeIn,fdTimeOut 
	from stSKLK sk inner join stRoom_Setup rs 
	on sk.fcOrderNo=rs.fcOrderNo
	Where sk.fcTrangThai not in ('C')
union all
	select fcFunctionRoom as fcRoom,fdTimeIn,fdTimeOut
	from stBookFunctionRoom br inner join stBooking b on
	b.fcBookID= br.fcBookID
	Where b.fcStatus_BkRoom not in ('C')
union all
	select fcRoom, fdNgayBatDau, fdNgayKetThuc from stTrackRoom
)a
Where  fcRoom=@FunctionRoom and ((fdTimeIn>=@TimeIn and fdTimeIn >=@TimeOut) or  (fdTimeOut=<@TimeIn and fdTimeOut<@TimeOut ))
*/
/*	

	SELECT bf.* from stBookFunctionRoom bf inner join stBooking b on bf.fcbookid = b.fcbookid
	where bf.fcFunctionRoom = @FunctionRoom and b.fcStatus_bkRoom <> 'C'
	 AND ((@pdTimeIn  < bf.fdTimeIn  and @pdTimeOut  > bf.fdTimeIn) or (@pdTimeIn  < bf.fdTimeOut  and @pdTimeOut  > bf.fdTimeOut))
	--if @countRecord  = 0 return 1 --
	--else return 0

*/


select * from (
	select fcRoom,fdTimeIn,fdTimeOut 
	from stSKLK sk inner join stRoom_Setup rs 
	on sk.fcOrderNo=rs.fcOrderNo
	Where sk.fcTrangThai not in ('C') and rs.fcRoom=@FunctionRoom
union all
	select fcFunctionRoom as fcRoom,fdTimeIn,fdTimeOut
	from stBookFunctionRoom br inner join stBooking b on
	b.fcBookID= br.fcBookID
	Where b.fcStatus_BkRoom not in ('C') and br.fcFunctionRoom=@FunctionRoom
--union all
	--select fcRoom, fdNgayBatDau, fdNgayKetThuc from stTrackRoom
)a
Where  
((@pdTimeIn  < fdTimeIn  and @pdTimeOut  > fdTimeIn) or (@pdTimeIn  < fdTimeOut  and @pdTimeOut  > fdTimeOut))

RETURN
GO

IF OBJECT_ID('[dbo].[spSetRightForChidlUser]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spSetRightForChidlUser]
GO
/*
Ham nay dung khi admin xoa quyen xx tren UserA
thi tat ca cac User la con cua UserA deu mat quyen xx
*/
CREATE PROCEDURE dbo.spSetRightForChidlUser

	(

		@User nvarchar(20) = '',
		@fcRight nvarchar(20)='',
		@flag tinyint =1--flag cho biet thuc hien tren menu nao 1 SO, 2 PO
	)
AS
declare @str nvarchar(500)
declare @strView1 nvarchar(500)
declare @strView2 nvarchar(500)
  if @flag=1
	select @strView1='view_tbUpdateRight a'
	select @strView2= 'view_tbFilterRight b '

  if @flag=2
	BEGIN
	select @strView1='view_tbUpdateRight a'
	select @strView2= 'view_tbFilterRight b '
    	END

	select @str='Update a set a.' + @fcRight+'=b.'+@fcRight+ ' from ' +
	  @strView1+ ' inner join '+
	  @strView2 + '  on a.fcMenuCode=b.fcMenuCode
	 Where  b.fcUserName= '+char(39)+@User +char(39)+' and a.fcOwner='+char(39)+@User+char(39)
	exec(@str)

/*
select @str='Update a set a.' + @fcRight+'=b.'+@fcRight+ ' from ' +
 ' view_tbUpdateRight a inner join 
  view_tbFilterRight b 
 on a.fcMenuCode=b.fcMenuCode
 Where  b.fcUserName= '+@User +' and a.fcOwner='+@User
exec(@str)

*/
GO

IF OBJECT_ID('[dbo].[spShow_inScheduler]', 'P') IS NOT NULL DROP PROCEDURE [dbo].[spShow_inScheduler]
GO
CREATE PROCEDURE [dbo].[spShow_inScheduler]
(
	@pType bit = 0,
	@pDateCurrent nvarchar(20)=''
)
 AS

--set dateformat dmy
set dateformat mdy
declare @dCurrentDate smalldatetime
set @dCurrentDate = cast (@pDateCurrent as smalldatetime)

if @pType = 0  -- HIEN THI TREN LUOI SCHEDULER**********NOTE: TEN FIELD RESOURCEID DUOC MAPPING TRONG SchedStorage PHAI DUNG LA fcFunctionRoom
BEGIN 
	select  l.fcOrderNo as fcCode ,rs.fcRoom as fcFunctionRoom, RS.fdTimeIn, rs.fdTimeOut, l.fcNoidung, 5 AS fnStatusEvent_Color, kh.fcTen + '(BEO -' + cast(l.fcGUA as nvarchar) + '; SP: ' + ms.fcNguoiLap +  ')'  as fcTenKH ,   s.fcTen + ' - ' + t.fcTen   as fcShowInfo , '1' as Is_EO
	from stMaster_EO ms 
	left join stSKLK l on  ms.fcMaster_EO = l.fcMaster_EO
	left join stRoom_Setup rs on  l.fcOrderNo = rs.fcOrderNo
	left  join stSK_TrangThai t on l.fcTrangThai = t.fcMa  
	left  join stSukien s on l.fcMaSK = s.fcMa  
	left join stKhachHang kh on ms.fcGuestCode= kh.fcMa 
	where  l.fcTrangThai not in ('C','R')  and  (l.fdEventDate >= DATEADD  (month, -12, @dCurrentDate))
union all
	select  l.fcOrderNo as fcCode ,'06' as fcFunctionRoom, RS.fdTimeIn, rs.fdTimeOut, l.fcNoidung, 5 AS fnStatusEvent_Color, kh.fcTen + '(BEO -' + cast(l.fcGUA as nvarchar) + '; SP: ' + ms.fcNguoiLap +  ')'  as fcTenKH ,   s.fcTen + ' - ' + t.fcTen   as fcShowInfo , '2' as Is_EO
	from stMaster_EO ms 
	left join stSKLK l on  ms.fcMaster_EO = l.fcMaster_EO
	left join stRoom_Setup rs on  l.fcOrderNo = rs.fcOrderNo
	left  join stSK_TrangThai t on l.fcTrangThai = t.fcMa  
	left  join stSukien s on l.fcMaSK = s.fcMa  
	left join stKhachHang kh on ms.fcGuestCode= kh.fcMa 
	where  l.fcTrangThai not in ('C','R')  and  (l.fdEventDate >= DATEADD  (month, -12, @dCurrentDate))
	and rs.fcRoom ='05'
union all
	select  l.fcOrderNo as fcCode ,'07' as fcFunctionRoom, RS.fdTimeIn, rs.fdTimeOut, l.fcNoidung, 5 AS fnStatusEvent_Color, kh.fcTen + '(BEO -' + cast(l.fcGUA as nvarchar) + '; SP: ' + ms.fcNguoiLap +  ')'  as fcTenKH ,   s.fcTen + ' - ' + t.fcTen   as fcShowInfo , '2' as Is_EO
	from stMaster_EO ms 
	left join stSKLK l on  ms.fcMaster_EO = l.fcMaster_EO
	left join stRoom_Setup rs on  l.fcOrderNo = rs.fcOrderNo
	left  join stSK_TrangThai t on l.fcTrangThai = t.fcMa  
	left  join stSukien s on l.fcMaSK = s.fcMa  
	left join stKhachHang kh on ms.fcGuestCode= kh.fcMa 
	where  l.fcTrangThai not in ('C','R')  and  (l.fdEventDate >= DATEADD  (month, -12, @dCurrentDate))
	and rs.fcRoom ='05'

union all
	select  l.fcOrderNo as fcCode ,'08' as fcFunctionRoom, RS.fdTimeIn, rs.fdTimeOut, l.fcNoidung, 5 AS fnStatusEvent_Color, kh.fcTen + '(BEO -' + cast(l.fcGUA as nvarchar) + '; SP: ' + ms.fcNguoiLap +  ')'  as fcTenKH ,   s.fcTen + ' - ' + t.fcTen   as fcShowInfo , '2' as Is_EO
	from stMaster_EO ms 
	left join stSKLK l on  ms.fcMaster_EO = l.fcMaster_EO
	left join stRoom_Setup rs on  l.fcOrderNo = rs.fcOrderNo
	left  join stSK_TrangThai t on l.fcTrangThai = t.fcMa  
	left  join stSukien s on l.fcMaSK = s.fcMa  
	left join stKhachHang kh on ms.fcGuestCode= kh.fcMa 
	where  l.fcTrangThai not in ('C','R')  and  (l.fdEventDate >= DATEADD  (month, -12, @dCurrentDate))
	and rs.fcRoom ='05'

union all
	select  l.fcOrderNo as fcCode ,'09' as fcFunctionRoom, RS.fdTimeIn, rs.fdTimeOut, l.fcNoidung, 5 AS fnStatusEvent_Color, kh.fcTen + '(BEO -' + cast(l.fcGUA as nvarchar) + '; SP: ' + ms.fcNguoiLap +  ')'  as fcTenKH ,   s.fcTen + ' - ' + t.fcTen   as fcShowInfo , '2' as Is_EO
	from stMaster_EO ms 
	left join stSKLK l on  ms.fcMaster_EO = l.fcMaster_EO
	left join stRoom_Setup rs on  l.fcOrderNo = rs.fcOrderNo
	left  join stSK_TrangThai t on l.fcTrangThai = t.fcMa  
	left  join stSukien s on l.fcMaSK = s.fcMa  
	left join stKhachHang kh on ms.fcGuestCode= kh.fcMa 
	where  l.fcTrangThai not in ('C','R')  and  (l.fdEventDate >= DATEADD  (month, -12, @dCurrentDate))
	and rs.fcRoom ='05'
union all
	select  l.fcOrderNo as fcCode ,'05' as fcFunctionRoom, RS.fdTimeIn, rs.fdTimeOut, l.fcNoidung, 5 AS fnStatusEvent_Color, kh.fcTen + '(BEO -' + cast(l.fcGUA as nvarchar) + '; SP: ' + ms.fcNguoiLap +  ')'  as fcTenKH ,   s.fcTen + ' - ' + t.fcTen   as fcShowInfo , '2' as Is_EO
	from stMaster_EO ms 
	left join stSKLK l on  ms.fcMaster_EO = l.fcMaster_EO
	left join stRoom_Setup rs on  l.fcOrderNo = rs.fcOrderNo
	left  join stSK_TrangThai t on l.fcTrangThai = t.fcMa  
	left  join stSukien s on l.fcMaSK = s.fcMa  
	left join stKhachHang kh on ms.fcGuestCode= kh.fcMa 
	where  l.fcTrangThai not in ('C','R')  and  (l.fdEventDate >= DATEADD  (month, -12, @dCurrentDate))
	and (rs.fcRoom ='06' or rs.fcRoom ='07' or rs.fcRoom ='08' or rs.fcRoom ='09' )

union all
--	Select bf.fcbookID as fcCode, bf.fcFunctionRoom ,bf.fdTimeIn, bf.fdTimeOut , b.fcNote as fcNoiDung,case When @pDateCurrent>b.fdDateConfirm and b.fcStatus_BkRoom in ('A','P','T') then 9 else fnColor end  fnStatusEvent_Color, kh.fcTen  + '( '+ cast(b.fnSoLuongDK as nvarchar)  + 'pax _Total Amount: ' + cast((select isnull(sum(isnull(fnAmount, 0)),0) from stBooking_Charges where fcBookID= bf.fcBookID and fnCodeID= bf.fnCodeID)  as nvarchar(20)) + ';  SP: ' + b.fcUser + ' )' as fcTenKH, (s.fcTen +' - '+ case when bst.fcName in ('Agreement','Proposal','Tentative')then 'Tentative' else bst.fcName end ) as fcShowInfo  , '0' AS Is_EO
	Select bf.fcbookID as fcCode, bf.fcFunctionRoom ,bf.fdTimeIn, bf.fdTimeOut , b.fcNote as fcNoiDung,case When @pDateCurrent>b.fdDateConfirm and b.fcStatus_BkRoom in ('A','P','T') then (select top 1 fnColor from stBookingColor where fcBookStatus='C') else cl.fnColor end  fnStatusEvent_Color, kh.fcTen  + '( '+ cast(b.fnSoLuongDK as nvarchar)  + 'pax _Total Amount: ' + cast((select isnull(sum(isnull(fnAmount, 0)),0) from stBooking_Charges where fcBookID= bf.fcBookID and fnCodeID= bf.fnCodeID)  as nvarchar(20)) + ';  SP: ' + b.fcUser + ' )' as fcTenKH, (s.fcTen +' - '+ bst.fcName ) as fcShowInfo  , '0' AS Is_EO	from stBooking b
	left join  stBookFunctionRoom bf on  b.fcBookID= bf.fcBookID
	left join stBooking_Status bst on  b.fcStatus_BkRoom = bst.fcCode
	left join stKhachHang kh on b.fcGuestID= kh.fcMa 
	left join stSukien s on s.fcMa = bf.fcFunctionType
	left join stBookingColor cl on b.fcStatus_BkRoom=cl.fcBookStatus
	where b.fcStatus_BkRoom <> ('C' )   and (bf.fcBookID not in (select fcBookID from stMaster_EO ))   and  (bf.fdDate >= DATEADD  (month, -12 , @dCurrentDate))

union all
	Select bf.fcbookID as fcCode, '06' as fcFunctionRoom ,bf.fdTimeIn, bf.fdTimeOut , b.fcNote as fcNoiDung,case When @pDateCurrent>b.fdDateConfirm and b.fcStatus_BkRoom in ('A','P','T') then (select top 1 fnColor from stBookingColor where fcBookStatus='C') else cl.fnColor end  fnStatusEvent_Color, kh.fcTen  + '( '+ cast(b.fnSoLuongDK as nvarchar)  + 'pax _Total Amount: ' + cast((select isnull(sum(isnull(fnAmount, 0)),0) from stBooking_Charges where fcBookID= bf.fcBookID and fnCodeID= bf.fnCodeID)  as nvarchar(20)) + ';  SP: ' + b.fcUser + ' )' as fcTenKH, (s.fcTen +' - '+ bst.fcName ) as fcShowInfo  , '3' AS Is_EO	
	from stBooking b
	left join  stBookFunctionRoom bf on  b.fcBookID= bf.fcBookID
	left join stBooking_Status bst on  b.fcStatus_BkRoom = bst.fcCode
	left join stKhachHang kh on b.fcGuestID= kh.fcMa 
	left join stSukien s on s.fcMa = bf.fcFunctionType
	left join stBookingColor cl on b.fcStatus_BkRoom=cl.fcBookStatus
	where b.fcStatus_BkRoom <> ('C' )   and (bf.fcBookID not in (select fcBookID from stMaster_EO ))   and  (bf.fdDate >= DATEADD  (month, -12 , @dCurrentDate))
	and bf.fcFunctionRoom = '05'

union all
	Select bf.fcbookID as fcCode, '07' as fcFunctionRoom ,bf.fdTimeIn, bf.fdTimeOut , b.fcNote as fcNoiDung,case When @pDateCurrent>b.fdDateConfirm and b.fcStatus_BkRoom in ('A','P','T') then (select top 1 fnColor from stBookingColor where fcBookStatus='C') else cl.fnColor end  fnStatusEvent_Color, kh.fcTen  + '( '+ cast(b.fnSoLuongDK as nvarchar)  + 'pax _Total Amount: ' + cast((select isnull(sum(isnull(fnAmount, 0)),0) from stBooking_Charges where fcBookID= bf.fcBookID and fnCodeID= bf.fnCodeID)  as nvarchar(20)) + ';  SP: ' + b.fcUser + ' )' as fcTenKH, (s.fcTen +' - '+ bst.fcName ) as fcShowInfo  , '3' AS Is_EO	
	from stBooking b
	left join  stBookFunctionRoom bf on  b.fcBookID= bf.fcBookID
	left join stBooking_Status bst on  b.fcStatus_BkRoom = bst.fcCode
	left join stKhachHang kh on b.fcGuestID= kh.fcMa 
	left join stSukien s on s.fcMa = bf.fcFunctionType
	left join stBookingColor cl on b.fcStatus_BkRoom=cl.fcBookStatus
	where b.fcStatus_BkRoom <> ('C' )   and (bf.fcBookID not in (select fcBookID from stMaster_EO ))   and  (bf.fdDate >= DATEADD  (month, -12 , @dCurrentDate))
	and bf.fcFunctionRoom = '05'

union all
	Select bf.fcbookID as fcCode, '08' as fcFunctionRoom ,bf.fdTimeIn, bf.fdTimeOut , b.fcNote as fcNoiDung,case When @pDateCurrent>b.fdDateConfirm and b.fcStatus_BkRoom in ('A','P','T') then (select top 1 fnColor from stBookingColor where fcBookStatus='C') else cl.fnColor end  fnStatusEvent_Color, kh.fcTen  + '( '+ cast(b.fnSoLuongDK as nvarchar)  + 'pax _Total Amount: ' + cast((select isnull(sum(isnull(fnAmount, 0)),0) from stBooking_Charges where fcBookID= bf.fcBookID and fnCodeID= bf.fnCodeID)  as nvarchar(20)) + ';  SP: ' + b.fcUser + ' )' as fcTenKH, (s.fcTen +' - '+ bst.fcName ) as fcShowInfo  , '3' AS Is_EO	
	from stBooking b
	left join  stBookFunctionRoom bf on  b.fcBookID= bf.fcBookID
	left join stBooking_Status bst on  b.fcStatus_BkRoom = bst.fcCode
	left join stKhachHang kh on b.fcGuestID= kh.fcMa 
	left join stSukien s on s.fcMa = bf.fcFunctionType
	left join stBookingColor cl on b.fcStatus_BkRoom=cl.fcBookStatus
	where b.fcStatus_BkRoom <> ('C' )   and (bf.fcBookID not in (select fcBookID from stMaster_EO ))   and  (bf.fdDate >= DATEADD  (month, -12 , @dCurrentDate))
	and bf.fcFunctionRoom = '05'

union all
	Select bf.fcbookID as fcCode, '09' as fcFunctionRoom ,bf.fdTimeIn, bf.fdTimeOut , b.fcNote as fcNoiDung,case When @pDateCurrent>b.fdDateConfirm and b.fcStatus_BkRoom in ('A','P','T') then (select top 1 fnColor from stBookingColor where fcBookStatus='C') else cl.fnColor end  fnStatusEvent_Color, kh.fcTen  + '( '+ cast(b.fnSoLuongDK as nvarchar)  + 'pax _Total Amount: ' + cast((select isnull(sum(isnull(fnAmount, 0)),0) from stBooking_Charges where fcBookID= bf.fcBookID and fnCodeID= bf.fnCodeID)  as nvarchar(20)) + ';  SP: ' + b.fcUser + ' )' as fcTenKH, (s.fcTen +' - '+ bst.fcName ) as fcShowInfo  , '3' AS Is_EO	
	from stBooking b
	left join  stBookFunctionRoom bf on  b.fcBookID= bf.fcBookID
	left join stBooking_Status bst on  b.fcStatus_BkRoom = bst.fcCode
	left join stKhachHang kh on b.fcGuestID= kh.fcMa 
	left join stSukien s on s.fcMa = bf.fcFunctionType
	left join stBookingColor cl on b.fcStatus_BkRoom=cl.fcBookStatus
	where b.fcStatus_BkRoom <> ('C' )   and (bf.fcBookID not in (select fcBookID from stMaster_EO ))   and  (bf.fdDate >= DATEADD  (month, -12 , @dCurrentDate))
	and bf.fcFunctionRoom = '05'
union all
	Select bf.fcbookID as fcCode, '05' as fcFunctionRoom ,bf.fdTimeIn, bf.fdTimeOut , b.fcNote as fcNoiDung,case When @pDateCurrent>b.fdDateConfirm and b.fcStatus_BkRoom in ('A','P','T') then (select top 1 fnColor from stBookingColor where fcBookStatus='C') else cl.fnColor end  fnStatusEvent_Color, kh.fcTen  + '( '+ cast(b.fnSoLuongDK as nvarchar)  + 'pax _Total Amount: ' + cast((select isnull(sum(isnull(fnAmount, 0)),0) from stBooking_Charges where fcBookID= bf.fcBookID and fnCodeID= bf.fnCodeID)  as nvarchar(20)) + ';  SP: ' + b.fcUser + ' )' as fcTenKH, (s.fcTen +' - '+ bst.fcName ) as fcShowInfo  , '3' AS Is_EO	
	from stBooking b
	left join  stBookFunctionRoom bf on  b.fcBookID= bf.fcBookID
	left join stBooking_Status bst on  b.fcStatus_BkRoom = bst.fcCode
	left join stKhachHang kh on b.fcGuestID= kh.fcMa 
	left join stSukien s on s.fcMa = bf.fcFunctionType
	left join stBookingColor cl on b.fcStatus_BkRoom=cl.fcBookStatus
	where b.fcStatus_BkRoom <> ('C' )   and (bf.fcBookID not in (select fcBookID from stMaster_EO ))   and  (bf.fdDate >= DATEADD  (month, -12 , @dCurrentDate))
	and ( bf.fcFunctionRoom = '06' or bf.fcFunctionRoom = '07' or bf.fcFunctionRoom = '08' or bf.fcFunctionRoom = '09' )

union 	all
	select fcID, fcRoom as fcFunctionRoom, fdNgayBatDau, fdNgayKetThuc, 'Reserving FunctionRoom' as fcNoiDung, fnColor, '' as fcTenKH, fcShowTitle, '' as Is_EO 
	from stTrackRoom

END

IF @pType = 1  -- HIEN THI REOURCE
BEGIN
	SELECT * FROM stPhong order by fnorder asc
END
GO
