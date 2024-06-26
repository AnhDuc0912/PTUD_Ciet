USE [QuanLyNhaHang]
GO
/****** Object:  UserDefinedFunction [dbo].[ChiPhiNK_theoNgay]    Script Date: 10/9/2023 7:52:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[ChiPhiNK_theoNgay]
(
    @ngNK DATE
)
RETURNS DECIMAL(18, 2) -- Adjust the data type based on your actual requirement
AS
BEGIN
    DECLARE @v_Chiphi DECIMAL(18, 2); -- Adjust the data type based on your actual requirement

    -- Calculate the total cost for the given date
    SELECT @v_Chiphi = SUM(Tongtien)
    FROM PHIEUNK 
    WHERE NGAYNK = @ngNK;

    -- Set v_Chiphi to 0 if no data is found
    IF @v_Chiphi IS NULL
    BEGIN
        SET @v_Chiphi = 0;
    END;

    -- Return the calculated total cost
    RETURN @v_Chiphi;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[CTHD_Tinhtiengiam]    Script Date: 10/9/2023 7:52:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[CTHD_Tinhtiengiam]
(
    @Tongtien DECIMAL(18, 2), -- Adjust the data type based on your actual requirement
    @Code VARCHAR(50) -- Adjust the data type and length based on your actual requirement
)
RETURNS DECIMAL(18, 2) -- Adjust the data type based on your actual requirement
AS
BEGIN
    DECLARE @Tiengiam DECIMAL(18, 2);
    DECLARE @v_Phantram DECIMAL(18, 2);

    -- Calculate the discount amount
    SELECT @v_Phantram = Phantram
    FROM Voucher
    WHERE Code_Voucher = @Code;

    SET @Tiengiam = ROUND(@Tongtien * @v_Phantram / 100.0, 2);

    -- Return the calculated discount amount
    RETURN @Tiengiam;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[DoanhsoTB_TOPxKH]    Script Date: 10/9/2023 7:52:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[DoanhsoTB_TOPxKH]
(
    @x INT
)
RETURNS DECIMAL(18, 2) -- Adjust the data type based on your actual requirement
AS
BEGIN
    DECLARE @v_avg DECIMAL(18, 2); -- Adjust the data type based on your actual requirement

    -- Calculate the average sales for the top x customers
    ;WITH RankedCustomers AS
    (
        SELECT Doanhso, ROW_NUMBER() OVER (ORDER BY Doanhso DESC) AS RowNum
        FROM KHACHHANG
    )
    SELECT @v_avg = AVG(Doanhso)
    FROM RankedCustomers
    WHERE RowNum <= @x;

    -- Set v_avg to 0 if no data is found
    IF @v_avg IS NULL
    BEGIN
        SET @v_avg = 0.0;
    END;

    -- Return the calculated average sales
    RETURN @v_avg;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[DoanhThuHD_theoNgay]    Script Date: 10/9/2023 7:52:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[DoanhThuHD_theoNgay]
(
    @ngHD DATE
)
RETURNS DECIMAL(18, 2) -- Adjust the data type based on your actual requirement
AS
BEGIN
    DECLARE @v_Doanhthu DECIMAL(18, 2); -- Adjust the data type based on your actual requirement

    -- Calculate the total revenue for the given date
    SELECT @v_Doanhthu = SUM(Tongtien)
    FROM HOADON 
    WHERE NGAYHD = @ngHD;

    -- Set v_Doanhthu to 0 if no data is found
    IF @v_Doanhthu IS NULL
    BEGIN
        SET @v_Doanhthu = 0;
    END;

    -- Return the calculated total revenue
    RETURN @v_Doanhthu;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[SL_KH_Moi]    Script Date: 10/9/2023 7:52:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[SL_KH_Moi]
(
    @thang INT,
    @nam INT,
    @trigiaHD DECIMAL(18, 2) -- Adjust the data type based on your actual requirement
)
RETURNS INT
AS
BEGIN
    DECLARE @v_count INT;

    -- Calculate the count of new customers meeting the criteria
    SELECT @v_count = COUNT(KHACHHANG.ID_KH)
    FROM KHACHHANG
    WHERE MONTH(Ngaythamgia) = @thang
        AND YEAR(Ngaythamgia) = @nam
        AND EXISTS (
            SELECT 1
            FROM HOADON
            WHERE HOADON.ID_KH = KHACHHANG.ID_KH
                AND TONGTIEN > @trigiaHD
        );

    -- Return the calculated count
    RETURN @v_count;
END;
GO
/****** Object:  Table [dbo].[Ban]    Script Date: 10/9/2023 7:52:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ban](
	[ID_Ban] [int] NOT NULL,
	[TenBan] [varchar](50) NULL,
	[Vitri] [varchar](50) NULL,
	[Trangthai] [varchar](50) NULL,
 CONSTRAINT [Ban_PK] PRIMARY KEY CLUSTERED 
(
	[ID_Ban] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CTHD]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CTHD](
	[ID_HoaDon] [int] NOT NULL,
	[ID_MonAn] [int] NOT NULL,
	[SoLuong] [int] NULL,
	[Thanhtien] [int] NULL,
 CONSTRAINT [CTHD_PK] PRIMARY KEY CLUSTERED 
(
	[ID_HoaDon] ASC,
	[ID_MonAn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CTNK]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CTNK](
	[ID_NK] [int] NOT NULL,
	[ID_NL] [int] NOT NULL,
	[SoLuong] [int] NULL,
	[Thanhtien] [int] NULL,
 CONSTRAINT [CTNK_PK] PRIMARY KEY CLUSTERED 
(
	[ID_NK] ASC,
	[ID_NL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CTXK]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CTXK](
	[ID_XK] [int] NOT NULL,
	[ID_NL] [int] NOT NULL,
	[SoLuong] [int] NULL,
 CONSTRAINT [CTXK_PK] PRIMARY KEY CLUSTERED 
(
	[ID_XK] ASC,
	[ID_NL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HoaDon]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoaDon](
	[ID_HoaDon] [int] NOT NULL,
	[ID_KH] [int] NULL,
	[ID_Ban] [int] NULL,
	[NgayHD] [date] NULL,
	[TienMonAn] [int] NULL,
	[Code_Voucher] [varchar](10) NULL,
	[TienGiam] [int] NULL,
	[Tongtien] [int] NULL,
	[Trangthai] [varchar](50) NULL,
 CONSTRAINT [HD_PK] PRIMARY KEY CLUSTERED 
(
	[ID_HoaDon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KhachHang]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KhachHang](
	[ID_KH] [int] NOT NULL,
	[TenKH] [varchar](50) NULL,
	[Ngaythamgia] [date] NULL,
	[Doanhso] [int] NULL,
	[Diemtichluy] [int] NULL,
	[ID_ND] [int] NULL,
 CONSTRAINT [KhachHang_PK] PRIMARY KEY CLUSTERED 
(
	[ID_KH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Kho]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kho](
	[ID_NL] [int] NOT NULL,
	[SLTon] [int] NULL,
 CONSTRAINT [Kho_pk] PRIMARY KEY CLUSTERED 
(
	[ID_NL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MonAn]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MonAn](
	[ID_MonAn] [int] NOT NULL,
	[TenMon] [varchar](50) NULL,
	[DonGia] [int] NULL,
	[Loai] [varchar](50) NULL,
	[TrangThai] [varchar](30) NULL,
 CONSTRAINT [MonAn_PK] PRIMARY KEY CLUSTERED 
(
	[ID_MonAn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NguoiDung]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NguoiDung](
	[ID_ND] [int] NOT NULL,
	[Email] [varchar](50) NULL,
	[Matkhau] [varchar](20) NULL,
	[VerifyCode] [varchar](10) NULL,
	[Trangthai] [varchar](10) NULL,
	[Vaitro] [varchar](20) NULL,
 CONSTRAINT [NguoiDung_PK] PRIMARY KEY CLUSTERED 
(
	[ID_ND] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NguyenLieu]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NguyenLieu](
	[ID_NL] [int] NOT NULL,
	[TenNL] [varchar](50) NULL,
	[Dongia] [int] NULL,
	[Donvitinh] [varchar](50) NULL,
 CONSTRAINT [NL_PK] PRIMARY KEY CLUSTERED 
(
	[ID_NL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhanVien](
	[ID_NV] [int] NOT NULL,
	[TenNV] [varchar](50) NULL,
	[NgayVL] [date] NULL,
	[SDT] [varchar](50) NULL,
	[Chucvu] [varchar](50) NULL,
	[ID_ND] [int] NULL,
	[ID_NQL] [int] NULL,
	[Tinhtrang] [varchar](20) NULL,
 CONSTRAINT [NV_PK] PRIMARY KEY CLUSTERED 
(
	[ID_NV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PhieuNK]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhieuNK](
	[ID_NK] [int] NOT NULL,
	[ID_NV] [int] NULL,
	[NgayNK] [date] NULL,
	[Tongtien] [int] NULL,
 CONSTRAINT [PNK_PK] PRIMARY KEY CLUSTERED 
(
	[ID_NK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PhieuXK]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhieuXK](
	[ID_XK] [int] NOT NULL,
	[ID_NV] [int] NULL,
	[NgayXK] [date] NULL,
 CONSTRAINT [PXK_PK] PRIMARY KEY CLUSTERED 
(
	[ID_XK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Voucher]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Voucher](
	[Code_Voucher] [varchar](10) NOT NULL,
	[Mota] [varchar](50) NULL,
	[Phantram] [int] NULL,
	[LoaiMA] [varchar](50) NULL,
	[SoLuong] [int] NULL,
	[Diem] [int] NULL,
 CONSTRAINT [Voucher_PK] PRIMARY KEY CLUSTERED 
(
	[Code_Voucher] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (100, N'Ban T1.1', N'Tang 1', N'Dang dung bua')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (101, N'Ban T1.2', N'Tang 1', N'Dang dung bua')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (102, N'Ban T1.3', N'Tang 1', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (103, N'Ban T1.4', N'Tang 1', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (104, N'Ban T1.5', N'Tang 1', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (105, N'Ban T1.6', N'Tang 1', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (106, N'Ban T1.7', N'Tang 1', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (107, N'Ban T1.8', N'Tang 1', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (108, N'Ban T1.9', N'Tang 1', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (109, N'Ban T1.10', N'Tang 1', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (110, N'Ban T1.11', N'Tang 1', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (111, N'Ban T1.12', N'Tang 1', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (112, N'Ban T2.1', N'Tang 2', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (113, N'Ban T2.2', N'Tang 2', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (114, N'Ban T2.3', N'Tang 2', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (115, N'Ban T2.4', N'Tang 2', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (116, N'Ban T2.5', N'Tang 2', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (117, N'Ban T2.6', N'Tang 2', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (118, N'Ban T2.7', N'Tang 2', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (119, N'Ban T2.8', N'Tang 2', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (120, N'Ban T2.9', N'Tang 2', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (121, N'Ban T2.10', N'Tang 2', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (122, N'Ban T2.11', N'Tang 2', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (123, N'Ban T2.12', N'Tang 2', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (124, N'Ban T3.1', N'Tang 3', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (125, N'Ban T3.1', N'Tang 3', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (126, N'Ban T3.1', N'Tang 3', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (127, N'Ban T3.1', N'Tang 3', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (128, N'Ban T3.1', N'Tang 3', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (129, N'Ban T3.1', N'Tang 3', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (130, N'Ban T3.1', N'Tang 3', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (131, N'Ban T3.1', N'Tang 3', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (132, N'Ban T3.1', N'Tang 3', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (133, N'Ban T3.1', N'Tang 3', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (134, N'Ban T3.1', N'Tang 3', N'Con trong')
INSERT [dbo].[Ban] ([ID_Ban], [TenBan], [Vitri], [Trangthai]) VALUES (135, N'Ban T3.1', N'Tang 3', N'Con trong')
GO
INSERT [dbo].[CTHD] ([ID_HoaDon], [ID_MonAn], [SoLuong], [Thanhtien]) VALUES (101, 1, 2, 500000)
INSERT [dbo].[CTHD] ([ID_HoaDon], [ID_MonAn], [SoLuong], [Thanhtien]) VALUES (102, 41, 1, 150000)
GO
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (100, 100, 10, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (100, 101, 20, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (100, 102, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (101, 101, 10, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (101, 103, 20, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (101, 104, 10, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (101, 105, 10, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (101, 106, 20, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (101, 107, 5, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (101, 108, 5, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (102, 109, 10, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (102, 110, 20, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (102, 112, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (102, 113, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (102, 114, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (103, 112, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (103, 113, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (103, 114, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (104, 112, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (104, 113, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (105, 110, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (106, 102, 25, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (106, 115, 25, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (107, 105, 25, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (107, 110, 35, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (108, 103, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (108, 104, 25, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (108, 106, 30, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (109, 112, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (109, 113, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (109, 114, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (110, 102, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (110, 106, 25, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (110, 107, 15, 400000)
INSERT [dbo].[CTNK] ([ID_NK], [ID_NL], [SoLuong], [Thanhtien]) VALUES (110, 110, 20, NULL)
GO
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (100, 100, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (100, 101, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (100, 102, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (101, 101, 7)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (101, 103, 10)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (101, 104, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (101, 105, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (101, 106, 10)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (102, 109, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (102, 110, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (102, 112, 10)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (102, 113, 8)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (102, 114, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (103, 104, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (103, 114, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (104, 101, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (104, 112, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (105, 102, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (105, 113, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (106, 103, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (106, 114, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (107, 105, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (107, 106, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (108, 110, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (108, 115, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (109, 110, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (109, 112, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (110, 113, 5)
INSERT [dbo].[CTXK] ([ID_XK], [ID_NL], [SoLuong]) VALUES (110, 114, 5)
GO
INSERT [dbo].[HoaDon] ([ID_HoaDon], [ID_KH], [ID_Ban], [NgayHD], [TienMonAn], [Code_Voucher], [TienGiam], [Tongtien], [Trangthai]) VALUES (101, 100, 100, CAST(N'2023-10-01' AS Date), 500000, NULL, 0, 650000, N'Chua thanh toan')
INSERT [dbo].[HoaDon] ([ID_HoaDon], [ID_KH], [ID_Ban], [NgayHD], [TienMonAn], [Code_Voucher], [TienGiam], [Tongtien], [Trangthai]) VALUES (102, 110, 101, CAST(N'2023-09-10' AS Date), 150000, NULL, 0, 650000, N'Chua thanh toan')
GO
INSERT [dbo].[KhachHang] ([ID_KH], [TenKH], [Ngaythamgia], [Doanhso], [Diemtichluy], [ID_ND]) VALUES (100, N'Ha Thao Duong', CAST(N'2023-10-05' AS Date), 0, 0, 104)
INSERT [dbo].[KhachHang] ([ID_KH], [TenKH], [Ngaythamgia], [Doanhso], [Diemtichluy], [ID_ND]) VALUES (101, N'Truong Tan Hieu', CAST(N'2023-10-05' AS Date), 0, 0, 105)
INSERT [dbo].[KhachHang] ([ID_KH], [TenKH], [Ngaythamgia], [Doanhso], [Diemtichluy], [ID_ND]) VALUES (102, N'Nguyen Quoc Thinh', CAST(N'2023-10-05' AS Date), 0, 0, 106)
INSERT [dbo].[KhachHang] ([ID_KH], [TenKH], [Ngaythamgia], [Doanhso], [Diemtichluy], [ID_ND]) VALUES (103, N'Tran Nhu Mai', CAST(N'2023-10-05' AS Date), 0, 0, 107)
INSERT [dbo].[KhachHang] ([ID_KH], [TenKH], [Ngaythamgia], [Doanhso], [Diemtichluy], [ID_ND]) VALUES (104, N'Nguyen Thi Bich Hao', CAST(N'2023-10-05' AS Date), 0, 0, 108)
INSERT [dbo].[KhachHang] ([ID_KH], [TenKH], [Ngaythamgia], [Doanhso], [Diemtichluy], [ID_ND]) VALUES (105, N'Nguyen Mai Quynh', CAST(N'2023-11-05' AS Date), 0, 0, 109)
INSERT [dbo].[KhachHang] ([ID_KH], [TenKH], [Ngaythamgia], [Doanhso], [Diemtichluy], [ID_ND]) VALUES (106, N'Hoang Minh Quang', CAST(N'2023-11-05' AS Date), 0, 0, 110)
INSERT [dbo].[KhachHang] ([ID_KH], [TenKH], [Ngaythamgia], [Doanhso], [Diemtichluy], [ID_ND]) VALUES (107, N'Nguyen Thanh Hang', CAST(N'2023-12-05' AS Date), 0, 0, 111)
INSERT [dbo].[KhachHang] ([ID_KH], [TenKH], [Ngaythamgia], [Doanhso], [Diemtichluy], [ID_ND]) VALUES (108, N'Nguyen Ngoc Thanh Nhan', CAST(N'2023-11-05' AS Date), 0, 0, 112)
INSERT [dbo].[KhachHang] ([ID_KH], [TenKH], [Ngaythamgia], [Doanhso], [Diemtichluy], [ID_ND]) VALUES (109, N'Hoang Thi Phuc Nguyen', CAST(N'2023-12-05' AS Date), 0, 0, 113)
INSERT [dbo].[KhachHang] ([ID_KH], [TenKH], [Ngaythamgia], [Doanhso], [Diemtichluy], [ID_ND]) VALUES (110, N'Nguyen Van Hung', CAST(N'2023-09-10' AS Date), 0, 0, 114)
GO
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (100, 5)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (101, 13)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (102, 45)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (103, 20)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (104, 25)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (105, 25)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (106, 60)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (107, 20)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (108, 5)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (109, 5)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (110, 75)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (111, 0)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (112, 40)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (113, 42)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (114, 25)
INSERT [dbo].[Kho] ([ID_NL], [SLTon]) VALUES (115, 20)
GO
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (1, N'DUI CUU NUONG XE NHO', 260000, N'Aries', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (2, N'BE SUON CUU NUONG GIAY BAC MONG CO', 230000, N'Aries', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (3, N'DUI CUU NUONG TRUNG DONG', 350000, N'Aries', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (4, N'CUU XOC LA CA RI', 129000, N'Aries', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (5, N'CUU KUNGBAO', 250000, N'Aries', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (6, N'BAP CUU NUONG CAY', 250000, N'Aries', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (7, N'CUU VIEN HAM CAY', 19000, N'Aries', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (8, N'SUON CONG NUONG MONG CO', 250000, N'Aries', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (9, N'DUI CUU LON NUONG TAI BAN', 750000, N'Aries', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (10, N'SUONG CUU NUONG SOT NAM', 450000, N'Aries', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (11, N'DUI CUU NUONG TIEU XANH', 285000, N'Aries', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (12, N'SUON CUU SOT PHO MAI', 450000, N'Aries', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (13, N'Bit tet bo My khoai tay', 179000, N'Taurus', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (14, N'Bo bit tet Uc', 169000, N'Taurus', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (15, N'Bit tet bo My BASIC', 179000, N'Taurus', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (16, N'My Y bo bam', 169000, N'Taurus', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (17, N'Thit suon Wagyu', 1180000, N'Taurus', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (18, N'Steak Thit Vai Wagyu', 1290000, N'Taurus', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (19, N'Steak Thit Bung Bo', 550000, N'Taurus', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (20, N'Tomahawk', 2390000, N'Taurus', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (21, N'Salad Romaine Nuong', 180000, N'Taurus', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (22, N'Combo Happy', 180000, N'Gemini', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (23, N'Combo Fantastic', 190000, N'Gemini', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (24, N'Combo Dreamer', 230000, N'Gemini', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (25, N'Combo Cupid', 180000, N'Gemini', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (26, N'Combo Poseidon', 190000, N'Gemini', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (27, N'Combo LUANG PRABANG', 490000, N'Gemini', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (28, N'Combo VIENTIANE', 620000, N'Gemini', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (29, N'Cua KingCrab Duc sot', 3650000, N'Cancer', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (30, N'Mai Cua KingCrab Topping Pho Mai', 2650000, N'Cancer', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (31, N'Cua KingCrab sot Tu Xuyen', 2300000, N'Cancer', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (32, N'Cua KingCrab Nuong Tu Nhien', 2550000, N'Cancer', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (33, N'Cua KingCrab Nuong Bo Toi', 2650000, N'Cancer', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (34, N'Com Mai Cua KingCrab Chien', 1850000, N'Cancer', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (35, N'BOSSAM', 650000, N'Leo', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (36, N'KIMCHI PANCAKE', 350000, N'Leo', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (37, N'SPICY RICE CAKE', 250000, N'Leo', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (38, N'SPICY SAUSAGE HOTPOT', 650000, N'Leo', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (39, N'SPICY PORK', 350000, N'Leo', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (40, N'MUSHROOM SPICY SILKY TOFU STEW', 350000, N'Leo', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (41, N'Pavlova', 150000, N'Virgo', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (42, N'Kesutera', 120000, N'Virgo', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (43, N'Cremeschnitte', 250000, N'Virgo', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (44, N'Sachertorte', 150000, N'Virgo', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (45, N'Schwarzwalder Kirschtorte', 250000, N'Virgo', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (46, N'New York-Style Cheesecake', 250000, N'Virgo', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (47, N'Cobb Salad', 150000, N'Libra', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (48, N'Salad Israeli', 120000, N'Libra', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (49, N'Salad Dau den', 120000, N'Libra', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (50, N'Waldorf Salad', 160000, N'Libra', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (51, N'Salad Gado-Gado', 200000, N'Libra', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (52, N'Nicoise Salad', 250000, N'Libra', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (53, N'BULGOGI LUNCHBOX', 250000, N'Scorpio', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (54, N'CHICKEN TERIYAKI LUNCHBOX', 350000, N'Scorpio', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (55, N'SPICY PORK LUNCHBOX', 350000, N'Scorpio', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (56, N'TOFU TERIYAKI LUNCHBOX', 250000, N'Scorpio', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (57, N'Thit ngua do tuoi', 250000, N'Sagittarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (58, N'Steak Thit ngua', 350000, N'Sagittarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (59, N'Thit ngua ban gang', 350000, N'Sagittarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (60, N'Long ngua xao dua', 150000, N'Sagittarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (61, N'Thit ngua xao sa ot', 250000, N'Sagittarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (62, N'Ngua tang', 350000, N'Sagittarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (63, N'Thit de xong hoi', 229000, N'Capricorn', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (64, N'Thit de xao rau ngo', 199000, N'Capricorn', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (65, N'Thit de nuong tang', 229000, N'Capricorn', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (66, N'Thit de chao', 199000, N'Capricorn', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (67, N'Thit de nuong xien', 199000, N'Capricorn', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (68, N'Nam de nuong/chao', 199000, N'Capricorn', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (69, N'Thit de xao lan', 19000, N'Capricorn', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (70, N'Dui de tan thuoc bac', 199000, N'Capricorn', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (71, N'Canh de ham duong quy', 199000, N'Capricorn', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (72, N'Chao de dau xanh', 50000, N'Capricorn', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (73, N'Thit de nhung me', 229000, N'Capricorn', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (74, N'Lau de nhu', 499000, N'Capricorn', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (75, N'SIGNATURE WINE', 3290000, N'Aquarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (76, N'CHILEAN WINE', 3990000, N'Aquarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (77, N'ARGENTINA WINE', 2890000, N'Aquarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (78, N'ITALIAN WINE', 5590000, N'Aquarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (79, N'AMERICAN WINE', 4990000, N'Aquarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (80, N'CLASSIC COCKTAIL', 200000, N'Aquarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (81, N'SIGNATURE COCKTAIL', 250000, N'Aquarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (82, N'MOCKTAIL', 160000, N'Aquarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (83, N'JAPANESE SAKE', 1490000, N'Aquarius', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (84, N'Ca Hoi Ngam Tuong', 289000, N'Pisces', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (85, N'Ca Ngu Ngam Tuong', 289000, N'Pisces', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (86, N'IKURA:Trung ca hoi', 189000, N'Pisces', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (87, N'KARIN:Sashimi Ca Ngu', 149000, N'Pisces', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (88, N'KEIKO:Sashimi Ca Hoi', 199000, N'Pisces', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (89, N'CHIYO:Sashimi Bung Ca Hoi', 219000, N'Pisces', N'Dang kinh doanh')
INSERT [dbo].[MonAn] ([ID_MonAn], [TenMon], [DonGia], [Loai], [TrangThai]) VALUES (90, N'Món An M?i', 300000, N'Gemini', N'Dang kinh doanh')
GO
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (100, N'NVHoangViet@gmail.com', N'123', NULL, N'Verified', N'Quan Ly')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (101, N'NVHoangPhuc@gmail.com', N'123', NULL, N'Verified', N'Nhan Vien')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (102, N'NVAnhHong@gmail.com', N'123', NULL, N'Verified', N'Nhan Vien Kho')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (103, N'NVQuangDinh@gmail.com', N'123', NULL, N'Verified', N'Nhan Vien')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (104, N'KHThaoDuong@gmail.com', N'123', NULL, N'Verified', N'Khach Hang')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (105, N'KHTanHieu@gmail.com', N'123', NULL, N'Verified', N'Khach Hang')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (106, N'KHQuocThinh@gmail.com', N'123', NULL, N'Verified', N'Khach Hang')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (107, N'KHNhuMai@gmail.com', N'123', NULL, N'Verified', N'Khach Hang')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (108, N'KHBichHao@gmail.com', N'123', NULL, N'Verified', N'Khach Hang')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (109, N'KHMaiQuynh@gmail.com', N'123', NULL, N'Verified', N'Khach Hang')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (110, N'KHMinhQuang@gmail.com', N'123', NULL, N'Verified', N'Khach Hang')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (111, N'KHThanhHang@gmail.com', N'123', NULL, N'Verified', N'Khach Hang')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (112, N'KHThanhNhan@gmail.com', N'123', NULL, N'Verified', N'Khach Hang')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (113, N'KHPhucNguyen@gmail.com', N'123', NULL, N'Verified', N'Khach Hang')
INSERT [dbo].[NguoiDung] ([ID_ND], [Email], [Matkhau], [VerifyCode], [Trangthai], [Vaitro]) VALUES (114, N'nvhhungnv@gmail.com', N'123', N'', N'Verified', N'Khach Hang')
GO
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (100, N'Thit ga', 40000, N'kg')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (101, N'Thit heo', 50000, N'kg')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (102, N'Thit bo', 80000, N'kg')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (103, N'Tom', 100000, N'kg')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (104, N'Ca hoi', 500000, N'kg')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (105, N'Gao', 40000, N'kg')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (106, N'Sua tuoi', 40000, N'l')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (107, N'Bot mi', 20000, N'kg')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (108, N'Dau ca hoi', 1000000, N'l')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (109, N'Dau dau nanh', 150000, N'l')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (110, N'Muoi', 20000, N'kg')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (111, N'Duong', 20000, N'kg')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (112, N'Hanh tay', 50000, N'kg')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (113, N'Toi', 30000, N'kg')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (114, N'Dam', 50000, N'l')
INSERT [dbo].[NguyenLieu] ([ID_NL], [TenNL], [Dongia], [Donvitinh]) VALUES (115, N'Thit de', 140000, N'kg')
GO
INSERT [dbo].[NhanVien] ([ID_NV], [TenNV], [NgayVL], [SDT], [Chucvu], [ID_ND], [ID_NQL], [Tinhtrang]) VALUES (100, N'Nguyen Hoang Viet', CAST(N'2023-10-05' AS Date), N'0848044725', N'Quan ly', 100, 100, N'Dang lam viec')
INSERT [dbo].[NhanVien] ([ID_NV], [TenNV], [NgayVL], [SDT], [Chucvu], [ID_ND], [ID_NQL], [Tinhtrang]) VALUES (101, N'Ngo The Thuong', CAST(N'2023-10-09' AS Date), N'0823773272', N'Kho', NULL, 100, N'Dang lam viec')
INSERT [dbo].[NhanVien] ([ID_NV], [TenNV], [NgayVL], [SDT], [Chucvu], [ID_ND], [ID_NQL], [Tinhtrang]) VALUES (104, N'Ha Thao Duong', CAST(N'2023-10-05' AS Date), N'0838033232', N'Phuc vu', NULL, 100, N'Dang lam viec')
INSERT [dbo].[NhanVien] ([ID_NV], [TenNV], [NgayVL], [SDT], [Chucvu], [ID_ND], [ID_NQL], [Tinhtrang]) VALUES (105, N'Nguyen Quoc Thinh', CAST(N'2023-11-05' AS Date), N'0838033734', N'Phuc vu', NULL, 100, N'Dang lam viec')
INSERT [dbo].[NhanVien] ([ID_NV], [TenNV], [NgayVL], [SDT], [Chucvu], [ID_ND], [ID_NQL], [Tinhtrang]) VALUES (106, N'Truong Tan Hieu', CAST(N'2023-12-05' AS Date), N'0838033834', N'Phuc vu', NULL, 100, N'Dang lam viec')
INSERT [dbo].[NhanVien] ([ID_NV], [TenNV], [NgayVL], [SDT], [Chucvu], [ID_ND], [ID_NQL], [Tinhtrang]) VALUES (107, N'Nguyen Thai Bao', CAST(N'2023-10-05' AS Date), N'0838093234', N'Phuc vu', NULL, 100, N'Dang lam viec')
INSERT [dbo].[NhanVien] ([ID_NV], [TenNV], [NgayVL], [SDT], [Chucvu], [ID_ND], [ID_NQL], [Tinhtrang]) VALUES (108, N'Tran Nhat Khang', CAST(N'2023-11-05' AS Date), N'0838133234', N'Thu ngan', NULL, 100, N'Dang lam viec')
INSERT [dbo].[NhanVien] ([ID_NV], [TenNV], [NgayVL], [SDT], [Chucvu], [ID_ND], [ID_NQL], [Tinhtrang]) VALUES (109, N'Nguyen Ngoc Luong', CAST(N'2023-12-05' AS Date), N'0834033234', N'Bep', NULL, 100, N'Dang lam viec')
GO
INSERT [dbo].[PhieuNK] ([ID_NK], [ID_NV], [NgayNK], [Tongtien]) VALUES (100, 104, CAST(N'2023-10-01' AS Date), NULL)
INSERT [dbo].[PhieuNK] ([ID_NK], [ID_NV], [NgayNK], [Tongtien]) VALUES (101, 104, CAST(N'2023-11-02' AS Date), NULL)
INSERT [dbo].[PhieuNK] ([ID_NK], [ID_NV], [NgayNK], [Tongtien]) VALUES (102, 104, CAST(N'2023-12-02' AS Date), NULL)
INSERT [dbo].[PhieuNK] ([ID_NK], [ID_NV], [NgayNK], [Tongtien]) VALUES (103, 104, CAST(N'2023-12-03' AS Date), NULL)
INSERT [dbo].[PhieuNK] ([ID_NK], [ID_NV], [NgayNK], [Tongtien]) VALUES (104, 104, CAST(N'2023-12-03' AS Date), NULL)
INSERT [dbo].[PhieuNK] ([ID_NK], [ID_NV], [NgayNK], [Tongtien]) VALUES (105, 104, CAST(N'2023-12-08' AS Date), NULL)
INSERT [dbo].[PhieuNK] ([ID_NK], [ID_NV], [NgayNK], [Tongtien]) VALUES (106, 104, CAST(N'2023-07-14' AS Date), NULL)
INSERT [dbo].[PhieuNK] ([ID_NK], [ID_NV], [NgayNK], [Tongtien]) VALUES (107, 104, CAST(N'2023-09-11' AS Date), NULL)
INSERT [dbo].[PhieuNK] ([ID_NK], [ID_NV], [NgayNK], [Tongtien]) VALUES (108, 104, CAST(N'2023-10-10' AS Date), NULL)
INSERT [dbo].[PhieuNK] ([ID_NK], [ID_NV], [NgayNK], [Tongtien]) VALUES (109, 104, CAST(N'2023-08-19' AS Date), NULL)
INSERT [dbo].[PhieuNK] ([ID_NK], [ID_NV], [NgayNK], [Tongtien]) VALUES (110, 104, CAST(N'2023-10-13' AS Date), NULL)
GO
INSERT [dbo].[PhieuXK] ([ID_XK], [ID_NV], [NgayXK]) VALUES (100, 104, CAST(N'2023-01-10' AS Date))
INSERT [dbo].[PhieuXK] ([ID_XK], [ID_NV], [NgayXK]) VALUES (101, 104, CAST(N'2023-02-11' AS Date))
INSERT [dbo].[PhieuXK] ([ID_XK], [ID_NV], [NgayXK]) VALUES (102, 104, CAST(N'2023-03-12' AS Date))
INSERT [dbo].[PhieuXK] ([ID_XK], [ID_NV], [NgayXK]) VALUES (103, 104, CAST(N'2023-03-13' AS Date))
INSERT [dbo].[PhieuXK] ([ID_XK], [ID_NV], [NgayXK]) VALUES (104, 104, CAST(N'2023-04-12' AS Date))
INSERT [dbo].[PhieuXK] ([ID_XK], [ID_NV], [NgayXK]) VALUES (105, 104, CAST(N'2023-04-13' AS Date))
INSERT [dbo].[PhieuXK] ([ID_XK], [ID_NV], [NgayXK]) VALUES (106, 104, CAST(N'2023-05-12' AS Date))
INSERT [dbo].[PhieuXK] ([ID_XK], [ID_NV], [NgayXK]) VALUES (107, 104, CAST(N'2023-05-15' AS Date))
INSERT [dbo].[PhieuXK] ([ID_XK], [ID_NV], [NgayXK]) VALUES (108, 104, CAST(N'2023-05-20' AS Date))
INSERT [dbo].[PhieuXK] ([ID_XK], [ID_NV], [NgayXK]) VALUES (109, 104, CAST(N'2023-06-05' AS Date))
INSERT [dbo].[PhieuXK] ([ID_XK], [ID_NV], [NgayXK]) VALUES (110, 104, CAST(N'2023-06-10' AS Date))
GO
INSERT [dbo].[Voucher] ([Code_Voucher], [Mota], [Phantram], [LoaiMA], [SoLuong], [Diem]) VALUES (N'7hVO', N'60% off for Aries Menu', 60, N'Aries', 0, 1000)
INSERT [dbo].[Voucher] ([Code_Voucher], [Mota], [Phantram], [LoaiMA], [SoLuong], [Diem]) VALUES (N'bjff', N'50% off for Leo Menu', 50, N'Leo', 5, 600)
INSERT [dbo].[Voucher] ([Code_Voucher], [Mota], [Phantram], [LoaiMA], [SoLuong], [Diem]) VALUES (N'GTsC', N'20% off for Leo Menu', 20, N'Leo', 0, 200)
INSERT [dbo].[Voucher] ([Code_Voucher], [Mota], [Phantram], [LoaiMA], [SoLuong], [Diem]) VALUES (N'loQy', N'20% off for Aries Menu', 20, N'Aries', 10, 200)
INSERT [dbo].[Voucher] ([Code_Voucher], [Mota], [Phantram], [LoaiMA], [SoLuong], [Diem]) VALUES (N'nxVX', N'20% off for All Menu', 20, N'All', 5, 300)
INSERT [dbo].[Voucher] ([Code_Voucher], [Mota], [Phantram], [LoaiMA], [SoLuong], [Diem]) VALUES (N'pApo', N'20% off for Gemini Menu', 20, N'Gemini', 10, 200)
INSERT [dbo].[Voucher] ([Code_Voucher], [Mota], [Phantram], [LoaiMA], [SoLuong], [Diem]) VALUES (N'pCfI', N'30% off for Taurus Menu', 30, N'Taurus', 5, 300)
INSERT [dbo].[Voucher] ([Code_Voucher], [Mota], [Phantram], [LoaiMA], [SoLuong], [Diem]) VALUES (N'Pwyn', N'20% off for Cancer Menu', 20, N'Cancer', 10, 200)
INSERT [dbo].[Voucher] ([Code_Voucher], [Mota], [Phantram], [LoaiMA], [SoLuong], [Diem]) VALUES (N'ugQx', N'100% off for Virgo Menu', 100, N'Virgo', 3, 500)
INSERT [dbo].[Voucher] ([Code_Voucher], [Mota], [Phantram], [LoaiMA], [SoLuong], [Diem]) VALUES (N'WHLm', N'20% off for Capricorn Menu', 20, N'Capricorn', 0, 200)
INSERT [dbo].[Voucher] ([Code_Voucher], [Mota], [Phantram], [LoaiMA], [SoLuong], [Diem]) VALUES (N'Y5g0', N'30% off for Pisces Menu', 30, N'Pisces', 5, 300)
INSERT [dbo].[Voucher] ([Code_Voucher], [Mota], [Phantram], [LoaiMA], [SoLuong], [Diem]) VALUES (N'YPzJ', N'20% off for Aquarius Menu', 20, N'Aquarius', 5, 200)
GO
ALTER TABLE [dbo].[KhachHang] ADD  DEFAULT ((0)) FOR [Doanhso]
GO
ALTER TABLE [dbo].[KhachHang] ADD  DEFAULT ((0)) FOR [Diemtichluy]
GO
ALTER TABLE [dbo].[Kho] ADD  DEFAULT ((0)) FOR [SLTon]
GO
ALTER TABLE [dbo].[NguoiDung] ADD  DEFAULT (NULL) FOR [VerifyCode]
GO
ALTER TABLE [dbo].[NguoiDung] ADD  DEFAULT ('') FOR [Trangthai]
GO
ALTER TABLE [dbo].[NhanVien] ADD  DEFAULT (NULL) FOR [ID_ND]
GO
ALTER TABLE [dbo].[PhieuNK] ADD  DEFAULT ((0)) FOR [Tongtien]
GO
ALTER TABLE [dbo].[CTHD]  WITH CHECK ADD  CONSTRAINT [CTHD_fk_idHD] FOREIGN KEY([ID_HoaDon])
REFERENCES [dbo].[HoaDon] ([ID_HoaDon])
GO
ALTER TABLE [dbo].[CTHD] CHECK CONSTRAINT [CTHD_fk_idHD]
GO
ALTER TABLE [dbo].[CTHD]  WITH CHECK ADD  CONSTRAINT [CTHD_fk_idMonAn] FOREIGN KEY([ID_MonAn])
REFERENCES [dbo].[MonAn] ([ID_MonAn])
GO
ALTER TABLE [dbo].[CTHD] CHECK CONSTRAINT [CTHD_fk_idMonAn]
GO
ALTER TABLE [dbo].[CTNK]  WITH CHECK ADD  CONSTRAINT [CTNK_fk_idNK] FOREIGN KEY([ID_NK])
REFERENCES [dbo].[PhieuNK] ([ID_NK])
GO
ALTER TABLE [dbo].[CTNK] CHECK CONSTRAINT [CTNK_fk_idNK]
GO
ALTER TABLE [dbo].[CTNK]  WITH CHECK ADD  CONSTRAINT [CTNK_fk_idNL] FOREIGN KEY([ID_NL])
REFERENCES [dbo].[NguyenLieu] ([ID_NL])
GO
ALTER TABLE [dbo].[CTNK] CHECK CONSTRAINT [CTNK_fk_idNL]
GO
ALTER TABLE [dbo].[CTXK]  WITH CHECK ADD  CONSTRAINT [CTNK_fk_idXK] FOREIGN KEY([ID_XK])
REFERENCES [dbo].[PhieuXK] ([ID_XK])
GO
ALTER TABLE [dbo].[CTXK] CHECK CONSTRAINT [CTNK_fk_idXK]
GO
ALTER TABLE [dbo].[CTXK]  WITH CHECK ADD  CONSTRAINT [CTXK_fk_idNL] FOREIGN KEY([ID_NL])
REFERENCES [dbo].[NguyenLieu] ([ID_NL])
GO
ALTER TABLE [dbo].[CTXK] CHECK CONSTRAINT [CTXK_fk_idNL]
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [HD_fk_idBan] FOREIGN KEY([ID_Ban])
REFERENCES [dbo].[Ban] ([ID_Ban])
GO
ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [HD_fk_idBan]
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [HD_fk_idKH] FOREIGN KEY([ID_KH])
REFERENCES [dbo].[KhachHang] ([ID_KH])
GO
ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [HD_fk_idKH]
GO
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD  CONSTRAINT [KH_fk_idND] FOREIGN KEY([ID_ND])
REFERENCES [dbo].[NguoiDung] ([ID_ND])
GO
ALTER TABLE [dbo].[KhachHang] CHECK CONSTRAINT [KH_fk_idND]
GO
ALTER TABLE [dbo].[Kho]  WITH CHECK ADD  CONSTRAINT [Kho_fk_idNL] FOREIGN KEY([ID_NL])
REFERENCES [dbo].[NguyenLieu] ([ID_NL])
GO
ALTER TABLE [dbo].[Kho] CHECK CONSTRAINT [Kho_fk_idNL]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [NV_fk_idND] FOREIGN KEY([ID_ND])
REFERENCES [dbo].[NguoiDung] ([ID_ND])
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [NV_fk_idND]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [NV_fk_idNQL] FOREIGN KEY([ID_NQL])
REFERENCES [dbo].[NhanVien] ([ID_NV])
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [NV_fk_idNQL]
GO
ALTER TABLE [dbo].[PhieuNK]  WITH CHECK ADD  CONSTRAINT [PNK_fk_idNV] FOREIGN KEY([ID_NV])
REFERENCES [dbo].[NhanVien] ([ID_NV])
GO
ALTER TABLE [dbo].[PhieuNK] CHECK CONSTRAINT [PNK_fk_idNV]
GO
ALTER TABLE [dbo].[PhieuXK]  WITH CHECK ADD  CONSTRAINT [PXK_fk_idNV] FOREIGN KEY([ID_NV])
REFERENCES [dbo].[NhanVien] ([ID_NV])
GO
ALTER TABLE [dbo].[PhieuXK] CHECK CONSTRAINT [PXK_fk_idNV]
GO
ALTER TABLE [dbo].[Ban]  WITH CHECK ADD  CONSTRAINT [Ban_TenBan_NNULL] CHECK  (([TenBan] IS NOT NULL))
GO
ALTER TABLE [dbo].[Ban] CHECK CONSTRAINT [Ban_TenBan_NNULL]
GO
ALTER TABLE [dbo].[Ban]  WITH CHECK ADD  CONSTRAINT [Ban_Trangthai_Ten] CHECK  (([Trangthai]='Da dat truoc' OR [Trangthai]='Dang dung bua' OR [Trangthai]='Con trong'))
GO
ALTER TABLE [dbo].[Ban] CHECK CONSTRAINT [Ban_Trangthai_Ten]
GO
ALTER TABLE [dbo].[Ban]  WITH CHECK ADD  CONSTRAINT [Ban_Vitri_NNULL] CHECK  (([Vitri] IS NOT NULL))
GO
ALTER TABLE [dbo].[Ban] CHECK CONSTRAINT [Ban_Vitri_NNULL]
GO
ALTER TABLE [dbo].[CTHD]  WITH CHECK ADD  CONSTRAINT [CTHD_SoLuong_NNULL] CHECK  (([SoLuong] IS NOT NULL))
GO
ALTER TABLE [dbo].[CTHD] CHECK CONSTRAINT [CTHD_SoLuong_NNULL]
GO
ALTER TABLE [dbo].[CTNK]  WITH CHECK ADD  CONSTRAINT [CTNK_SL_NNULL] CHECK  (([SoLuong] IS NOT NULL))
GO
ALTER TABLE [dbo].[CTNK] CHECK CONSTRAINT [CTNK_SL_NNULL]
GO
ALTER TABLE [dbo].[CTXK]  WITH CHECK ADD  CONSTRAINT [CTXK_SL_NNULL] CHECK  (([SoLuong] IS NOT NULL))
GO
ALTER TABLE [dbo].[CTXK] CHECK CONSTRAINT [CTXK_SL_NNULL]
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [HD_NgayHD_NNULL] CHECK  (([NgayHD] IS NOT NULL))
GO
ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [HD_NgayHD_NNULL]
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [HD_TrangThai] CHECK  (([Trangthai]='Da thanh toan' OR [Trangthai]='Chua thanh toan'))
GO
ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [HD_TrangThai]
GO
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD  CONSTRAINT [KH_Diemtichluy_NNULL] CHECK  (([Diemtichluy] IS NOT NULL))
GO
ALTER TABLE [dbo].[KhachHang] CHECK CONSTRAINT [KH_Diemtichluy_NNULL]
GO
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD  CONSTRAINT [KH_Doanhso_NNULL] CHECK  (([Doanhso] IS NOT NULL))
GO
ALTER TABLE [dbo].[KhachHang] CHECK CONSTRAINT [KH_Doanhso_NNULL]
GO
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD  CONSTRAINT [KH_IDND_NNULL] CHECK  (([ID_ND] IS NOT NULL))
GO
ALTER TABLE [dbo].[KhachHang] CHECK CONSTRAINT [KH_IDND_NNULL]
GO
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD  CONSTRAINT [KH_Ngaythamgia_NNULL] CHECK  (([Ngaythamgia] IS NOT NULL))
GO
ALTER TABLE [dbo].[KhachHang] CHECK CONSTRAINT [KH_Ngaythamgia_NNULL]
GO
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD  CONSTRAINT [KH_TenKH_NNULL] CHECK  (([TenKH] IS NOT NULL))
GO
ALTER TABLE [dbo].[KhachHang] CHECK CONSTRAINT [KH_TenKH_NNULL]
GO
ALTER TABLE [dbo].[MonAn]  WITH CHECK ADD  CONSTRAINT [MA_DonGia_NNULL] CHECK  (([DonGia] IS NOT NULL))
GO
ALTER TABLE [dbo].[MonAn] CHECK CONSTRAINT [MA_DonGia_NNULL]
GO
ALTER TABLE [dbo].[MonAn]  WITH CHECK ADD  CONSTRAINT [MA_Loai_Ten] CHECK  (([Loai]='Pisces' OR [Loai]='Aquarius' OR [Loai]='Capricorn' OR [Loai]='Sagittarius' OR [Loai]='Scorpio' OR [Loai]='Libra' OR [Loai]='Virgo' OR [Loai]='Leo' OR [Loai]='Cancer' OR [Loai]='Gemini' OR [Loai]='Taurus' OR [Loai]='Aries'))
GO
ALTER TABLE [dbo].[MonAn] CHECK CONSTRAINT [MA_Loai_Ten]
GO
ALTER TABLE [dbo].[MonAn]  WITH CHECK ADD  CONSTRAINT [MA_TenMon_NNULL] CHECK  (([TenMon] IS NOT NULL))
GO
ALTER TABLE [dbo].[MonAn] CHECK CONSTRAINT [MA_TenMon_NNULL]
GO
ALTER TABLE [dbo].[MonAn]  WITH CHECK ADD  CONSTRAINT [MA_TrangThai_Thuoc] CHECK  (([TrangThai]='Ngung kinh doanh' OR [TrangThai]='Dang kinh doanh'))
GO
ALTER TABLE [dbo].[MonAn] CHECK CONSTRAINT [MA_TrangThai_Thuoc]
GO
ALTER TABLE [dbo].[NguoiDung]  WITH CHECK ADD  CONSTRAINT [ND_Email_NNULL] CHECK  (([Email] IS NOT NULL))
GO
ALTER TABLE [dbo].[NguoiDung] CHECK CONSTRAINT [ND_Email_NNULL]
GO
ALTER TABLE [dbo].[NguoiDung]  WITH CHECK ADD  CONSTRAINT [ND_Matkhau_NNULL] CHECK  (([Matkhau] IS NOT NULL))
GO
ALTER TABLE [dbo].[NguoiDung] CHECK CONSTRAINT [ND_Matkhau_NNULL]
GO
ALTER TABLE [dbo].[NguoiDung]  WITH CHECK ADD  CONSTRAINT [ND_Vaitro_Ten] CHECK  (([Vaitro]='Quan Ly' OR [Vaitro]='Nhan Vien Kho' OR [Vaitro]='Nhan Vien' OR [Vaitro]='Khach Hang'))
GO
ALTER TABLE [dbo].[NguoiDung] CHECK CONSTRAINT [ND_Vaitro_Ten]
GO
ALTER TABLE [dbo].[NguyenLieu]  WITH CHECK ADD  CONSTRAINT [NL_Dongia_NNULL] CHECK  (([Dongia] IS NOT NULL))
GO
ALTER TABLE [dbo].[NguyenLieu] CHECK CONSTRAINT [NL_Dongia_NNULL]
GO
ALTER TABLE [dbo].[NguyenLieu]  WITH CHECK ADD  CONSTRAINT [NL_DVT_Thuoc] CHECK  (([Donvitinh]='l' OR [Donvitinh]='ml' OR [Donvitinh]='kg' OR [Donvitinh]='g'))
GO
ALTER TABLE [dbo].[NguyenLieu] CHECK CONSTRAINT [NL_DVT_Thuoc]
GO
ALTER TABLE [dbo].[NguyenLieu]  WITH CHECK ADD  CONSTRAINT [NL_TenNL_NNULL] CHECK  (([TenNL] IS NOT NULL))
GO
ALTER TABLE [dbo].[NguyenLieu] CHECK CONSTRAINT [NL_TenNL_NNULL]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [NV_Chucvu_Thuoc] CHECK  (([Chucvu]='Quan ly' OR [Chucvu]='Kho' OR [Chucvu]='Bep' OR [Chucvu]='Thu ngan' OR [Chucvu]='Tiep tan' OR [Chucvu]='Phuc vu'))
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [NV_Chucvu_Thuoc]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [NV_NgayVL_NNULL] CHECK  (([NgayVL] IS NOT NULL))
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [NV_NgayVL_NNULL]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [NV_SDT_NNULL] CHECK  (([SDT] IS NOT NULL))
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [NV_SDT_NNULL]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [NV_TenNV_NNULL] CHECK  (([TenNV] IS NOT NULL))
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [NV_TenNV_NNULL]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [NV_Tinhtrang_Thuoc] CHECK  (([Tinhtrang]='Da nghi viec' OR [Tinhtrang]='Dang lam viec'))
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [NV_Tinhtrang_Thuoc]
GO
ALTER TABLE [dbo].[PhieuNK]  WITH CHECK ADD  CONSTRAINT [PNK_NgayNK_NNULL] CHECK  (([NgayNK] IS NOT NULL))
GO
ALTER TABLE [dbo].[PhieuNK] CHECK CONSTRAINT [PNK_NgayNK_NNULL]
GO
ALTER TABLE [dbo].[PhieuXK]  WITH CHECK ADD  CONSTRAINT [PXK_NgayXK_NNULL] CHECK  (([NgayXK] IS NOT NULL))
GO
ALTER TABLE [dbo].[PhieuXK] CHECK CONSTRAINT [PXK_NgayXK_NNULL]
GO
ALTER TABLE [dbo].[Voucher]  WITH CHECK ADD  CONSTRAINT [V_Code_NNULL] CHECK  (([Code_Voucher] IS NOT NULL))
GO
ALTER TABLE [dbo].[Voucher] CHECK CONSTRAINT [V_Code_NNULL]
GO
ALTER TABLE [dbo].[Voucher]  WITH CHECK ADD  CONSTRAINT [V_LoaiMA_Thuoc] CHECK  (([LoaiMA]='Pisces' OR [LoaiMA]='Aquarius' OR [LoaiMA]='Capricorn' OR [LoaiMA]='Sagittarius' OR [LoaiMA]='Scorpio' OR [LoaiMA]='Libra' OR [LoaiMA]='Virgo' OR [LoaiMA]='Leo' OR [LoaiMA]='Cancer' OR [LoaiMA]='Gemini' OR [LoaiMA]='Taurus' OR [LoaiMA]='Aries' OR [LoaiMA]='All'))
GO
ALTER TABLE [dbo].[Voucher] CHECK CONSTRAINT [V_LoaiMA_Thuoc]
GO
ALTER TABLE [dbo].[Voucher]  WITH CHECK ADD  CONSTRAINT [V_Mota_NNULL] CHECK  (([Mota] IS NOT NULL))
GO
ALTER TABLE [dbo].[Voucher] CHECK CONSTRAINT [V_Mota_NNULL]
GO
ALTER TABLE [dbo].[Voucher]  WITH CHECK ADD  CONSTRAINT [V_Phantram_NNULL] CHECK  (([Phantram]>(0) AND [Phantram]<=(100)))
GO
ALTER TABLE [dbo].[Voucher] CHECK CONSTRAINT [V_Phantram_NNULL]
GO
/****** Object:  StoredProcedure [dbo].[DS_HoaDon_tuAdenB]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[DS_HoaDon_tuAdenB]
    @fromA DATE,
    @toB DATE
AS
BEGIN
    DECLARE @ID_HOADON INT;
    DECLARE @ID_KH INT;
    DECLARE @ID_BAN INT;
    DECLARE @NgayHD DATE;
    DECLARE @TIENMONAN INT;
    DECLARE @TIENGIAM INT;
    DECLARE @TONGTIEN INT;
    DECLARE @TRANGTHAI NVARCHAR(50);

    -- Retrieve the list of invoices within the specified date range
    SELECT @ID_HOADON = ID_HOADON,
           @ID_KH = ID_KH,
           @ID_BAN = ID_BAN,
           @NgayHD = NGAYHD,
           @TIENMONAN = TIENMONAN,
           @TIENGIAM = TIENGIAM,
           @TONGTIEN = TONGTIEN,
           @TRANGTHAI = TRANGTHAI
    FROM HOADON
    WHERE NGAYHD BETWEEN @fromA AND DATEADD(DAY, 1, @toB);

    -- Check if there are invoices in the specified date range
    IF @@ROWCOUNT > 0
    BEGIN
        -- Print invoice information
        PRINT 'Ma hoa don: ' + CAST(@ID_HOADON AS NVARCHAR(50));
        PRINT 'Ma khach hang: ' + CAST(@ID_KH AS NVARCHAR(50));
        PRINT 'Ma ban: ' + CAST(@ID_BAN AS NVARCHAR(50));
        PRINT 'Ngay hoa don: ' + CONVERT(NVARCHAR(10), @NgayHD, 105);
        PRINT 'Tien mon an: ' + CAST(@TIENMONAN AS NVARCHAR(50));
        PRINT 'Tien giam: ' + CAST(@TIENGIAM AS NVARCHAR(50));
        PRINT 'Tong tien: ' + CAST(@TONGTIEN AS NVARCHAR(50));
        PRINT 'Trang thai: ' + ISNULL(@TRANGTHAI, '');

    END
    ELSE
    BEGIN
        -- Raise an error if no invoices are found in the specified date range
        THROW 51000, 'Khong co hoa don nao', 1;
    END;
END;
GO
/****** Object:  StoredProcedure [dbo].[DS_PhieuNK_tuAdenB]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[DS_PhieuNK_tuAdenB]
    @fromA DATE,
    @toB DATE
AS
BEGIN
    DECLARE @ID_NK INT;
    DECLARE @ID_NV INT;
    DECLARE @NGAYNK DATE;
    DECLARE @TONGTIEN INT;

    -- Retrieve the list of PhieuNK within the specified date range
    SELECT @ID_NK = ID_NK,
           @ID_NV = ID_NV,
           @NGAYNK = NGAYNK,
           @TONGTIEN = TONGTIEN
    FROM PHIEUNK
    WHERE NGAYNK BETWEEN @fromA AND DATEADD(DAY, 1, @toB);

    -- Check if there are PhieuNK in the specified date range
    IF @@ROWCOUNT > 0
    BEGIN
        -- Print PhieuNK information
        PRINT 'Ma nhap kho: ' + CAST(@ID_NK AS NVARCHAR(50));
        PRINT 'Ma nhan vien: ' + CAST(@ID_NV AS NVARCHAR(50));
        PRINT 'Ngay nhap kho: ' + CONVERT(NVARCHAR(10), @NGAYNK, 105);
        PRINT 'Tong tien: ' + CAST(@TONGTIEN AS NVARCHAR(50));

    END
    ELSE
    BEGIN
        -- Raise an error if no PhieuNK are found in the specified date range
        THROW 51000, 'Khong co PhieuNK nao', 1;
    END;
END;
GO
/****** Object:  StoredProcedure [dbo].[DS_PhieuXK_tuAdenB]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[DS_PhieuXK_tuAdenB]
    @fromA DATE,
    @toB DATE
AS
BEGIN
    DECLARE @ID_XK INT;
    DECLARE @ID_NV INT;
    DECLARE @NGAYXK DATE;

    -- Create a temporary table to store the results
    CREATE TABLE #TempTable
    (
        ID_XK INT,
        ID_NV INT,
        NGAYXK DATE
    );

    -- Insert data into the temporary table from PHIEUXK within the specified date range
    INSERT INTO #TempTable (ID_XK, ID_NV, NGAYXK)
    SELECT ID_XK, ID_NV, NGAYXK
    FROM PHIEUXK
    WHERE NGAYXK BETWEEN @fromA AND DATEADD(DAY, 1, @toB);

    -- Iterate over the temporary table
    DECLARE cur CURSOR FOR
    SELECT ID_XK, ID_NV, NGAYXK
    FROM #TempTable;

    OPEN cur;

    FETCH NEXT FROM cur INTO @ID_XK, @ID_NV, @NGAYXK;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Print PhieuXK information
        PRINT 'Ma xuat kho: ' + CAST(@ID_XK AS NVARCHAR(50));
        PRINT 'Ma nhan vien: ' + CAST(@ID_NV AS NVARCHAR(50));
        PRINT 'Ngay xuat kho: ' + CONVERT(NVARCHAR(10), @NGAYXK, 105);

        FETCH NEXT FROM cur INTO @ID_XK, @ID_NV, @NGAYXK;
    END;

    CLOSE cur;
    DEALLOCATE cur;

    -- Drop the temporary table
    DROP TABLE #TempTable;

    IF @@ROWCOUNT = 0
    BEGIN
        -- Raise an error if no PhieuXK are found in the specified date range
        THROW 51000, 'Khong co PhieuXK nao', 1;
    END;
END;
GO
/****** Object:  StoredProcedure [dbo].[HD_XemCTHD]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Procedure xem chi tiet hoa don cua 1 hoa don
CREATE   PROCEDURE [dbo].[HD_XemCTHD]
    @idHD INT
AS
BEGIN
    DECLARE @ID_MONAN INT;
    DECLARE @SOLUONG INT;
    DECLARE @THANHTIEN DECIMAL(18, 2);

    -- Create a temporary table to store the results
    CREATE TABLE #TempTable
    (
        ID_MONAN INT,
        SOLUONG INT,
        THANHTIEN DECIMAL(18, 2)
    );

    -- Insert data into the temporary table from CTHD for the specified HoaDon (ID_HOADON)
    INSERT INTO #TempTable (ID_MONAN, SOLUONG, THANHTIEN)
    SELECT ID_MONAN, SOLUONG, THANHTIEN
    FROM CTHD
    WHERE ID_HOADON = @idHD;

    -- Iterate over the temporary table
    DECLARE cur CURSOR FOR
    SELECT ID_MONAN, SOLUONG, THANHTIEN
    FROM #TempTable;

    OPEN cur;

    FETCH NEXT FROM cur INTO @ID_MONAN, @SOLUONG, @THANHTIEN;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Print CTHD information
        PRINT 'Ma mon an: ' + CAST(@ID_MONAN AS NVARCHAR(50));
        PRINT 'So luong: ' + CAST(@SOLUONG AS NVARCHAR(50));
        PRINT 'Thanh tien: ' + CAST(@THANHTIEN AS NVARCHAR(50));

        FETCH NEXT FROM cur INTO @ID_MONAN, @SOLUONG, @THANHTIEN;
    END;

    CLOSE cur;
    DEALLOCATE cur;

    -- Drop the temporary table
    DROP TABLE #TempTable;

    IF @@ROWCOUNT = 0
    BEGIN
        -- Raise an error if no CTHD records are found for the specified HoaDon
        THROW 51000, 'Khong co chi tiet hoa don nao', 1;
    END;
END;
GO
/****** Object:  StoredProcedure [dbo].[KH_ThemKH]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[KH_ThemKH]
    @tenKH NVARCHAR(50),
    @NgayTG DATE,
    @ID_ND INT
AS
BEGIN
    DECLARE @v_ID_KH INT;
    
    -- Find the next available ID_KH
    SELECT TOP 1 @v_ID_KH = ID_KH + 1
    FROM KhachHang
    WHERE ID_KH + 1 NOT IN (SELECT ID_KH FROM KhachHang)
    ORDER BY ID_KH;
    
    IF @v_ID_KH IS NULL
    BEGIN
        -- Handle the case where there are no gaps in ID_KH
        SELECT @v_ID_KH = MAX(ID_KH) + 1
        FROM KhachHang;
    END
    
    -- Insert the new record into KhachHang
    INSERT INTO KhachHang (ID_KH, TenKH, Ngaythamgia, ID_ND)
    VALUES (@v_ID_KH, @tenKH, @NgayTG, @ID_ND);
END;
GO
/****** Object:  StoredProcedure [dbo].[KH_TruDTL]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[KH_TruDTL]
    @ID INT,
    @diemdoi INT
AS
BEGIN
    DECLARE @v_count INT;

    -- Check if the customer with the given ID exists
    SELECT @v_count = COUNT(*)
    FROM KHACHHANG
    WHERE ID_KH = @ID;

    IF @v_count > 0
    BEGIN
        -- Update the Diemtichluy by subtracting diemdoi
        UPDATE KHACHHANG
        SET Diemtichluy = Diemtichluy - @diemdoi
        WHERE ID_KH = @ID;
    END
    ELSE
    BEGIN
        -- Raise an error if the customer doesn't exist
        THROW 51000, 'Khach hang khong ton tai', 1;
    END;
END;
GO
/****** Object:  StoredProcedure [dbo].[KH_XemTT]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[KH_XemTT]
    @idKH INT
AS
BEGIN
    DECLARE @TenKH VARCHAR(50);
    DECLARE @Ngaythamgia DATE;
    DECLARE @Doanhso INT;
    DECLARE @Diemtichluy INT;
    DECLARE @ID_ND INT;

    -- Retrieve customer information
    SELECT @TenKH = TenKH,
           @Ngaythamgia = Ngaythamgia,
           @Doanhso = Doanhso,
           @Diemtichluy = Diemtichluy,
           @ID_ND = ID_ND
    FROM KHACHHANG
    WHERE ID_KH = @idKH;

    -- Check if the customer exists
    IF @@ROWCOUNT > 0
    BEGIN
        -- Print customer information
        PRINT 'Ma khach hang: ' + CAST(@idKH AS VARCHAR(10));
        PRINT 'Ten khach hang: ' + ISNULL(@TenKH, '');
        PRINT 'Ngay tham gia: ' + CONVERT(VARCHAR(10), @Ngaythamgia, 105);
        PRINT 'Doanh so: ' + CAST(@Doanhso AS VARCHAR(10));
        PRINT 'Diemtichluy: ' + CAST(@Diemtichluy AS VARCHAR(10));
        PRINT 'Ma nguoi dung: ' + CAST(@ID_ND AS VARCHAR(10));
    END
    ELSE
    BEGIN
        -- Raise an error if the customer does not exist
        THROW 51000, 'Khach hang khong ton tai', 1;
    END;
END;
GO
/****** Object:  StoredProcedure [dbo].[KH_XoaKH]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[KH_XoaKH]
    @idKH INT
AS
BEGIN
    DECLARE @v_count INT;

    -- Check if the customer exists
    SELECT @v_count = COUNT(*)
    FROM KHACHHANG
    WHERE ID_KH = @idKH;

    IF @v_count > 0
    BEGIN
        -- Delete related records from HOADON
        DELETE FROM CTHD
        WHERE ID_HoaDon IN (SELECT ID_HoaDon FROM HOADON WHERE ID_KH = @idKH);

        -- Delete related records from HOADON
        DELETE FROM HOADON
        WHERE ID_KH = @idKH;

        -- Delete the customer record
        DELETE FROM KHACHHANG
        WHERE ID_KH = @idKH;
    END
    ELSE
    BEGIN
        -- Raise an error if the customer does not exist
        THROW 51000, 'Khach hang khong ton tai', 1;
    END;
END;
GO
/****** Object:  StoredProcedure [dbo].[NV_ThemNV]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[NV_ThemNV]
    @tenNV NVARCHAR(50),
    @NgayVL DATE,
    @SDT NVARCHAR(50),
    @Chucvu NVARCHAR(50),
    @ID_NQL INT,
    @Tinhtrang NVARCHAR(20)
AS
BEGIN
    DECLARE @v_ID_NV INT;

    -- Find the next available ID_NV
    SELECT TOP 1 @v_ID_NV = ID_NV + 1
    FROM NhanVien
    WHERE ID_NV + 1 NOT IN (SELECT ID_NV FROM NhanVien)
    ORDER BY ID_NV;

    IF @v_ID_NV IS NULL
    BEGIN
        -- Handle the case where there are no gaps in ID_NV
        SELECT @v_ID_NV = MAX(ID_NV) + 1
        FROM NhanVien;
    END

    -- Insert the new record into NhanVien
    INSERT INTO NhanVien (ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_NQL, Tinhtrang)
    VALUES (@v_ID_NV, @tenNV, @NgayVL, @SDT, @Chucvu, @ID_NQL, @Tinhtrang);
END;
GO
/****** Object:  StoredProcedure [dbo].[NV_XemTT]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[NV_XemTT]
    @idNV INT
AS
BEGIN
    DECLARE @TenNV VARCHAR(50);
    DECLARE @NgayVL DATE;
    DECLARE @SDT VARCHAR(20);
    DECLARE @Chucvu VARCHAR(50);
    DECLARE @ID_NQL INT;

    -- Retrieve employee information
    SELECT @TenNV = TenNV,
           @NgayVL = NgayVL,
           @SDT = SDT,
           @Chucvu = Chucvu,
           @ID_NQL = ID_NQL
    FROM NHANVIEN
    WHERE ID_NV = @idNV;

    -- Check if the employee exists
    IF @@ROWCOUNT > 0
    BEGIN
        -- Print employee information
        PRINT 'Ma nhan vien: ' + CAST(@idNV AS VARCHAR(10));
        PRINT 'Ten nhan vien: ' + ISNULL(@TenNV, '');
        PRINT 'Ngay vao lam: ' + CONVERT(VARCHAR(10), @NgayVL, 105);
        PRINT 'So dien thoai: ' + ISNULL(@SDT, '');
        PRINT 'Chuc vu: ' + ISNULL(@Chucvu, '');
        PRINT 'Ma nguoi quan ly: ' + CAST(@ID_NQL AS VARCHAR(10));
    END
    ELSE
    BEGIN
        -- Raise an error if the employee does not exist
        THROW 51000, 'Nhan vien khong ton tai', 1;
    END;
END;
GO
/****** Object:  StoredProcedure [dbo].[NV_XoaNV]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[NV_XoaNV]
    @idNV INT
AS
BEGIN
    DECLARE @v_count INT;
    DECLARE @idNQL INT;

    -- Find the count and ID_NQL for the specified ID_NV
SELECT @v_count = COUNT(ID_NV), @idNQL = MAX(ID_NQL)
FROM NHANVIEN
WHERE ID_NV = @idNV;


    IF @v_count > 0
    BEGIN
        IF @idNV = @idNQL
        BEGIN
            -- Cannot delete a QUAN LY (manager)
            THROW 50000, 'Khong the xoa QUAN LY', 1;
        END
        ELSE
        BEGIN
            -- Delete records from related tables first
            DELETE FROM CTNK WHERE ID_NK IN (SELECT ID_NK FROM PHIEUNK WHERE ID_NV = @idNV);
            DELETE FROM CTXK WHERE ID_XK IN (SELECT ID_XK FROM PHIEUXK WHERE ID_NV = @idNV);
            DELETE FROM PHIEUNK WHERE ID_NV = @idNV;
            DELETE FROM PHIEUXK WHERE ID_NV = @idNV;

            -- Finally, delete the NHANVIEN record
            DELETE FROM NHANVIEN WHERE ID_NV = @idNV;
        END
    END
    ELSE
    BEGIN
        -- The employee does not exist
        THROW 50000, 'Nhan vien khong ton tai', 1;
    END;
END;
GO
/****** Object:  StoredProcedure [dbo].[Voucher_GiamSL]    Script Date: 10/9/2023 7:52:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Voucher_GiamSL]
    @code NVARCHAR(50)
AS
BEGIN
    DECLARE @v_count INT;

    -- Check if the voucher with the given code exists
    SELECT @v_count = COUNT(*)
    FROM Voucher
    WHERE Code_Voucher = @code;

    IF @v_count > 0
    BEGIN
        -- Decrease the quantity (SoLuong) of the voucher by 1
        UPDATE Voucher
        SET SoLuong = SoLuong - 1
        WHERE Code_Voucher = @code;
    END
    ELSE
    BEGIN
        -- Raise an error if the voucher does not exist
        THROW 51000, 'Voucher khong ton tai', 1;
    END;
END;
GO
