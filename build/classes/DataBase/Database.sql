-- Drop the table if it exists
IF OBJECT_ID('NguoiDung', 'U') IS NOT NULL
    DROP TABLE NguoiDung;

-- Create the NguoiDung table
CREATE TABLE NguoiDung (
    ID_ND INT,
    Email VARCHAR(50),
    Matkhau VARCHAR(20),
    VerifyCode VARCHAR(10) DEFAULT NULL,
    Trangthai VARCHAR(10) DEFAULT '',
    Vaitro VARCHAR(20),
    CONSTRAINT ND_Email_NNULL CHECK (Email IS NOT NULL),
    CONSTRAINT ND_Matkhau_NNULL CHECK (Matkhau IS NOT NULL),
    CONSTRAINT ND_Vaitro_Ten CHECK (Vaitro IN ('Khach Hang', 'Nhan Vien', 'Nhan Vien Kho', 'Quan Ly')),
    CONSTRAINT NguoiDung_PK PRIMARY KEY (ID_ND)
);

    
-- Drop the table if it exists
IF OBJECT_ID('NhanVien', 'U') IS NOT NULL
    DROP TABLE NhanVien;

-- Create the NhanVien table
CREATE TABLE NhanVien (
    ID_NV INT,
    TenNV VARCHAR(50),
    NgayVL DATE,
    SDT VARCHAR(50),
    Chucvu VARCHAR(50),
    ID_ND INT DEFAULT NULL,
    ID_NQL INT,
    Tinhtrang VARCHAR(20),
    CONSTRAINT NV_TenNV_NNULL CHECK (TenNV IS NOT NULL),
    CONSTRAINT NV_SDT_NNULL CHECK (SDT IS NOT NULL),
    CONSTRAINT NV_NgayVL_NNULL CHECK (NgayVL IS NOT NULL),
    CONSTRAINT NV_Chucvu_Thuoc CHECK (Chucvu IN ('Phuc vu', 'Tiep tan', 'Thu ngan', 'Bep', 'Kho', 'Quan ly')),
    CONSTRAINT NV_Tinhtrang_Thuoc CHECK (Tinhtrang IN ('Dang lam viec', 'Da nghi viec')),
    CONSTRAINT NV_PK PRIMARY KEY (ID_NV),
    CONSTRAINT NV_fk_idND FOREIGN KEY (ID_ND) REFERENCES NguoiDung(ID_ND),
    CONSTRAINT NV_fk_idNQL FOREIGN KEY (ID_NQL) REFERENCES NhanVien(ID_NV)
);


-- Drop the table if it exists
IF OBJECT_ID('KhachHang', 'U') IS NOT NULL
    DROP TABLE KhachHang;

-- Create the KhachHang table
CREATE TABLE KhachHang (
    ID_KH INT,
    TenKH VARCHAR(50),
    Ngaythamgia DATE,
    Doanhso INT DEFAULT 0,
    Diemtichluy INT DEFAULT 0,
    ID_ND INT,
    CONSTRAINT KH_TenKH_NNULL CHECK (TenKH IS NOT NULL),
    CONSTRAINT KH_Ngaythamgia_NNULL CHECK (Ngaythamgia IS NOT NULL),
    CONSTRAINT KH_Doanhso_NNULL CHECK (Doanhso IS NOT NULL),
    CONSTRAINT KH_Diemtichluy_NNULL CHECK (Diemtichluy IS NOT NULL),
    CONSTRAINT KH_IDND_NNULL CHECK (ID_ND IS NOT NULL),
    CONSTRAINT KhachHang_PK PRIMARY KEY (ID_KH),
    CONSTRAINT KH_fk_idND FOREIGN KEY (ID_ND) REFERENCES NguoiDung(ID_ND)
);


-- Drop the table if it exists
IF OBJECT_ID('MonAn', 'U') IS NOT NULL
    DROP TABLE MonAn;

-- Create the MonAn table
CREATE TABLE MonAn (
    ID_MonAn INT,
    TenMon VARCHAR(50),
    DonGia INT,
    Loai VARCHAR(50),
    TrangThai VARCHAR(30),
    CONSTRAINT MA_TenMon_NNULL CHECK (TenMon IS NOT NULL),
    CONSTRAINT MA_DonGia_NNULL CHECK (DonGia IS NOT NULL),
    CONSTRAINT MA_Loai_Ten CHECK (Loai IN ('Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
                                          'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces')),
    CONSTRAINT MA_TrangThai_Thuoc CHECK (TrangThai IN ('Dang kinh doanh', 'Ngung kinh doanh')),
    CONSTRAINT MonAn_PK PRIMARY KEY (ID_MonAn)
);


-- Drop the table if it exists
IF OBJECT_ID('Ban', 'U') IS NOT NULL
    DROP TABLE Ban;

-- Create the Ban table
CREATE TABLE Ban (
    ID_Ban INT,
    TenBan VARCHAR(50),
    Vitri VARCHAR(50),
    Trangthai VARCHAR(50),
    CONSTRAINT Ban_TenBan_NNULL CHECK (TenBan IS NOT NULL),
    CONSTRAINT Ban_Vitri_NNULL CHECK (Vitri IS NOT NULL),
    CONSTRAINT Ban_Trangthai_Ten CHECK (Trangthai IN ('Con trong', 'Dang dung bua', 'Da dat truoc')),
    CONSTRAINT Ban_PK PRIMARY KEY (ID_Ban)
);

-- Drop the table if it exists
IF OBJECT_ID('Voucher', 'U') IS NOT NULL
    DROP TABLE Voucher;

-- Create the Voucher table
CREATE TABLE Voucher (
    Code_Voucher VARCHAR(10),
    Mota VARCHAR(50),
    Phantram INT,
    LoaiMA VARCHAR(50),
    SoLuong INT,
    Diem INT,
    CONSTRAINT V_Code_NNULL CHECK (Code_Voucher IS NOT NULL),
    CONSTRAINT V_Mota_NNULL CHECK (Mota IS NOT NULL),
    CONSTRAINT V_Phantram_NNULL CHECK (Phantram > 0 AND Phantram <= 100),
    CONSTRAINT V_LoaiMA_Thuoc CHECK (LoaiMA IN ('All', 'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
                                                 'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces')),
    CONSTRAINT Voucher_PK PRIMARY KEY (Code_Voucher)
);

CREATE TABLE HoaDon (
    ID_HoaDon INT,
    ID_KH INT,
    ID_Ban INT,
    NgayHD DATE,
    TienMonAn INT,
    Code_Voucher VARCHAR(10),
    TienGiam INT,
    Tongtien INT,
    Trangthai VARCHAR(50),
    CONSTRAINT HD_NgayHD_NNULL CHECK (NgayHD IS NOT NULL),
    CONSTRAINT HD_TrangThai CHECK (Trangthai IN ('Chua thanh toan', 'Da thanh toan')),
    CONSTRAINT HD_PK PRIMARY KEY (ID_HoaDon),
    CONSTRAINT HD_fk_idKH FOREIGN KEY (ID_KH) REFERENCES KhachHang(ID_KH),
    CONSTRAINT HD_fk_idBan FOREIGN KEY (ID_Ban) REFERENCES Ban(ID_Ban)
);

CREATE TABLE CTHD (
    ID_HoaDon INT,
    ID_MonAn INT,
    SoLuong INT,
    Thanhtien INT,
    CONSTRAINT CTHD_SoLuong_NNULL CHECK (SoLuong IS NOT NULL),
    CONSTRAINT CTHD_PK PRIMARY KEY (ID_HoaDon, ID_MonAn),
    CONSTRAINT CTHD_fk_idHD FOREIGN KEY (ID_HoaDon) REFERENCES HoaDon(ID_HoaDon),
    CONSTRAINT CTHD_fk_idMonAn FOREIGN KEY (ID_MonAn) REFERENCES MonAn(ID_MonAn)
);

CREATE TABLE NguyenLieu (
    ID_NL INT,
    TenNL VARCHAR(50),
    Dongia INT,
    Donvitinh VARCHAR(50),
    CONSTRAINT NL_TenNL_NNULL CHECK (TenNL IS NOT NULL),
    CONSTRAINT NL_Dongia_NNULL CHECK (Dongia IS NOT NULL),
    CONSTRAINT NL_DVT_Thuoc CHECK (Donvitinh IN ('g', 'kg', 'ml', 'l')),
    CONSTRAINT NL_PK PRIMARY KEY (ID_NL)
);

CREATE TABLE Kho (
    ID_NL INT,
    SLTon INT DEFAULT 0,
    CONSTRAINT Kho_pk PRIMARY KEY (ID_NL),
    CONSTRAINT Kho_fk_idNL FOREIGN KEY (ID_NL) REFERENCES NguyenLieu(ID_NL)
);

CREATE TABLE PhieuNK (
    ID_NK INT,
    ID_NV INT,
    NgayNK DATE,
    Tongtien INT DEFAULT 0,
    CONSTRAINT PNK_NgayNK_NNULL CHECK (NgayNK IS NOT NULL),
    CONSTRAINT PNK_PK PRIMARY KEY (ID_NK),
    CONSTRAINT PNK_fk_idNV FOREIGN KEY (ID_NV) REFERENCES NhanVien(ID_NV)
);

CREATE TABLE CTNK (
    ID_NK INT,
    ID_NL INT,
    SoLuong INT,
    Thanhtien INT,
    CONSTRAINT CTNK_SL_NNULL CHECK (SoLuong IS NOT NULL),
    CONSTRAINT CTNK_PK PRIMARY KEY (ID_NK, ID_NL),
    CONSTRAINT CTNK_fk_idNK FOREIGN KEY (ID_NK) REFERENCES PhieuNK(ID_NK),
    CONSTRAINT CTNK_fk_idNL FOREIGN KEY (ID_NL) REFERENCES NguyenLieu(ID_NL)
);

CREATE TABLE PhieuXK (
    ID_XK INT,
    ID_NV INT,
    NgayXK DATE,
    CONSTRAINT PXK_NgayXK_NNULL CHECK (NgayXK IS NOT NULL),
    CONSTRAINT PXK_PK PRIMARY KEY (ID_XK),
    CONSTRAINT PXK_fk_idNV FOREIGN KEY (ID_NV) REFERENCES NhanVien(ID_NV)
);

CREATE TABLE CTXK (
    ID_XK INT,
    ID_NL INT,
    SoLuong INT,
    CONSTRAINT CTXK_SL_NNULL CHECK (SoLuong IS NOT NULL),
    CONSTRAINT CTXK_PK PRIMARY KEY (ID_XK, ID_NL),
    CONSTRAINT CTNK_fk_idXK FOREIGN KEY (ID_XK) REFERENCES PhieuXK(ID_XK),
    CONSTRAINT CTXK_fk_idNL FOREIGN KEY (ID_NL) REFERENCES NguyenLieu(ID_NL)
);


--- Tao Trigger

--Khach hang chi duoc co toi da mot hoa don co trang thai Chua thanh toan
-- Create the trigger
CREATE TRIGGER Tg_SLHD_CTT
ON HoaDon
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @ID_KH INT;
    DECLARE @TrangThai VARCHAR(50);
    DECLARE @Count INT;

    -- Get the values of ID_KH and TrangThai for the inserted/updated row
    SELECT @ID_KH = ID_KH, @TrangThai = TrangThai
    FROM inserted;

    -- Count the number of invoices with the same ID_KH and 'Chua thanh toan' status
    SELECT @Count = COUNT(*)
    FROM HoaDon
    WHERE ID_KH = @ID_KH AND TrangThai = 'Chua thanh toan';

    -- If the count exceeds 1, raise an error
    IF @Count > 1
    BEGIN
        RAISERROR ('Moi khach hang chi duoc co toi da mot hoa don co trang thai chua thanh toan', 16, 1);
        ROLLBACK;
        RETURN;
    END;
END;

--  Trigger Thanh tien o CTHD bang SoLuong x Dongia cua mon an do

-- Create the Tg_CTHD_Thanhtien trigger
-- Create the Tg_CTHD_Thanhtien trigger
CREATE TRIGGER Tg_CTHD_Thanhtien
ON CTHD
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @gia INT;
    
    -- Get the DonGia from the MonAn table
    SELECT @gia = M.DonGia
    FROM MonAn M
    WHERE M.ID_MonAn = (SELECT ID_MonAn FROM inserted);
    
    -- Calculate ThanhTien and set it for the new or updated row
    UPDATE CTHD
    SET ThanhTien = inserted.SoLuong * @gia
    FROM CTHD
    INNER JOIN inserted ON CTHD.ID_HoaDon = inserted.ID_HoaDon;
END;


--- Trigger Tien mon an o Hoa Don bang tong thanh tien o CTHD
-- Create the Tg_HD_TienMonAn trigger
CREATE TRIGGER Tg_HD_TienMonAn
ON CTHD
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- For INSERT, update TienMonAn in HoaDon
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        UPDATE H
        SET TienMonAn = TienMonAn + COALESCE(I.ThanhTien, 0) - COALESCE(D.ThanhTien, 0)
        FROM HoaDon H
        LEFT JOIN (SELECT ID_HoaDon, SUM(ThanhTien) AS ThanhTien FROM inserted GROUP BY ID_HoaDon) I
            ON H.ID_HoaDon = I.ID_HoaDon
        LEFT JOIN (SELECT ID_HoaDon, SUM(ThanhTien) AS ThanhTien FROM deleted GROUP BY ID_HoaDon) D
            ON H.ID_HoaDon = D.ID_HoaDon;
    END;

    -- For DELETE, update TienMonAn in HoaDon
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        UPDATE H
        SET TienMonAn = TienMonAn - COALESCE(D.ThanhTien, 0)
        FROM HoaDon H
        LEFT JOIN (SELECT ID_HoaDon, SUM(ThanhTien) AS ThanhTien FROM deleted GROUP BY ID_HoaDon) D
            ON H.ID_HoaDon = D.ID_HoaDon;
    END;
END;

--Trigger Tien giam o Hoa Don = tong thanh tien cua mon An duoc giam  x Phantram
-- Create the Tg_HD_TienGiam trigger
CREATE TRIGGER Tg_HD_TienGiam
ON CTHD
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @v_code VARCHAR(10);
    DECLARE @v_LoaiMA VARCHAR(50);
    DECLARE @MA_Loai VARCHAR(50);

    -- Get Code_Voucher and LoaiMA from HoaDon for the inserted/updated/deleted row
    SELECT @v_code = H.Code_Voucher, @v_LoaiMA = V.LoaiMA
    FROM HoaDon H
    LEFT JOIN Voucher V ON V.Code_Voucher = H.Code_Voucher
    WHERE H.ID_HoaDon = COALESCE((SELECT ID_HoaDon FROM inserted), (SELECT ID_HoaDon FROM deleted));

    -- Get Loai from MonAn for the inserted/updated/deleted row
    SELECT @MA_Loai = M.Loai
    FROM MonAn M
    WHERE M.ID_MonAn = COALESCE((SELECT ID_MonAn FROM inserted), (SELECT ID_MonAn FROM deleted));

    IF @v_code IS NOT NULL
    BEGIN
        IF (@v_LoaiMA = 'All' OR @v_LoaiMA = @MA_Loai)
        BEGIN
            -- Calculate the TienGiam based on the ThanhTien and update HoaDon
            IF EXISTS (SELECT 1 FROM inserted)
            BEGIN
                UPDATE H
                SET TienGiam = TienGiam + dbo.Tinhtiengiam((SELECT ThanhTien FROM inserted), @v_code)
                FROM HoaDon H
                WHERE H.ID_HoaDon = (SELECT ID_HoaDon FROM inserted);
            END;

            IF EXISTS (SELECT 1 FROM deleted)
            BEGIN
                UPDATE H
                SET TienGiam = TienGiam - dbo.Tinhtiengiam((SELECT ThanhTien FROM deleted), @v_code)
                FROM HoaDon H
                WHERE H.ID_HoaDon = (SELECT ID_HoaDon FROM deleted);
            END;
        END;
    END;
END;

-- Tong tien o Hoa Don = Tien mon an - Tien giam
-- Create the Tg_HD_Tongtien trigger
CREATE TRIGGER Tg_HD_Tongtien
ON HoaDon
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE HoaDon
    SET Tongtien = (SELECT ISNULL(SUM(TienMonAn - TienGiam), 0) FROM inserted)
    WHERE HoaDon.ID_HoaDon IN (SELECT ID_HoaDon FROM inserted);
END;

-- Khi cap nhat Code_Voucher o HoaDon, Tinh tien giam theo thong tin cua Voucher do va giam Diem tich luy cua KH
-- Create the Tg_HD_DoiVoucher trigger
-- Corrected Tg_HD_DoiVoucher trigger with ROUND function
CREATE TRIGGER Tg_HD_DoiVoucher
ON HoaDon
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Code_Voucher)
    BEGIN
        DECLARE @TongtienLoaiMonAnduocgiam INT;
        DECLARE @v_Diemdoi INT;
        DECLARE @v_Phantram INT;
        DECLARE @v_LoaiMA VARCHAR(50);

        SELECT @v_Diemdoi = Diem, @v_Phantram = Phantram, @v_LoaiMA = LoaiMA
        FROM Voucher
        WHERE Code_Voucher = (SELECT Code_Voucher FROM inserted);

        -- Your functions KH_TruDTL and Voucher_GiamSL should be implemented here

        IF @v_LoaiMA = 'All'
        BEGIN
            SET @TongtienLoaiMonAnduocgiam = (SELECT TienMonAn FROM inserted);
        END
        ELSE
        BEGIN
            SELECT @TongtienLoaiMonAnduocgiam = SUM(Thanhtien)
            FROM CTHD
            INNER JOIN MonAn ON MonAn.ID_MonAn = CTHD.ID_MonAn
            WHERE ID_HoaDon = (SELECT ID_HoaDon FROM inserted) AND LOAI = @v_LoaiMA;
        END;

        -- Corrected usage of ROUND function with two arguments
        UPDATE HoaDon
        SET Tiengiam = ROUND(@TongtienLoaiMonAnduocgiam * @v_Phantram / 100, 2), -- Replace "2" with the desired number of decimal places
            Tongtien = TienMonAn - ROUND(@TongtienLoaiMonAnduocgiam * @v_Phantram / 100, 2) -- Replace "2" with the desired number of decimal places
        FROM HoaDon
        WHERE ID_HoaDon = (SELECT ID_HoaDon FROM inserted);
    END;
END;

--Trigger Doanh so cua Khach hang bang tong tien cua tat ca hoa don co trang thai 'Da thanh toan' 
--cua khach hang do
-- Diem tich luy cua Khach hang duoc tinh bang 0.005% Tong tien cua hoa don (1.000.000d tuong duong 50 diem)
-- Create the Tg_KH_DoanhsovaDTL trigger
CREATE TRIGGER Tg_KH_DoanhsovaDTL
ON HoaDon
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Trangthai)
    BEGIN
        -- Check if the new Trangthai is 'Da thanh toan'
        IF EXISTS (SELECT 1 FROM inserted WHERE Trangthai = 'Da thanh toan')
        BEGIN
            DECLARE @ID_KH INT;
            DECLARE @Tongtien DECIMAL(10, 0);

            SELECT @ID_KH = ID_KH, @Tongtien = Tongtien
            FROM inserted;

            -- Update KhachHang's Doanhso
            UPDATE KhachHang
            SET Doanhso = Doanhso + @Tongtien
            WHERE ID_KH = @ID_KH;

            -- Update KhachHang's Diemtichluy
            UPDATE KhachHang
            SET Diemtichluy = Diemtichluy + ROUND(@Tongtien * 0.00005, 0)
            WHERE ID_KH = @ID_KH;
        END;
    END;
END;

--Trigger khi khach hang them hoa don moi, trang thai ban chuyen tu 'Con trong' sang 'Dang dung bua'
-- Khi trang thai don hang tro thanh 'Da thanh toan' trang thai ban chuyen tu 'Dang dung bua' sang 'Con trong'

-- Create the Tg_TrangthaiBan trigger
-- Create the Tg_TrangthaiBan trigger
CREATE TRIGGER Tg_TrangthaiBan
ON HoaDon
AFTER INSERT, UPDATE
AS
BEGIN
    IF UPDATE(Trangthai)
    BEGIN
        DECLARE @ID_Ban INT;

        -- Use a unique variable name for the ID_Ban within this scope
        IF EXISTS (SELECT 1 FROM inserted WHERE Trangthai = 'Chua thanh toan')
        BEGIN
            SELECT @ID_Ban = ID_Ban
            FROM inserted;

            -- Update Ban's Trangthai to 'Dang dung bua'
            UPDATE Ban
            SET Trangthai = 'Dang dung bua'
            WHERE ID_Ban = @ID_Ban;
        END
        ELSE -- Trangthai is not 'Chua thanh toan'
        BEGIN
            SELECT @ID_Ban = ID_Ban
            FROM inserted;

            -- Update Ban's Trangthai to 'Con trong'
            UPDATE Ban
            SET Trangthai = 'Con trong'
            WHERE ID_Ban = @ID_Ban;
        END;
    END;
END;


--  Trigger Thanh tien o CTNK bang SoLuong x Dongia cua nguyen lieu do

-- Create the Tg_CTNK_Thanhtien trigger
-- Create the Tg_CTNK_Thanhtien trigger as an INSTEAD OF trigger
CREATE TRIGGER Tg_CTNK_Thanhtien
ON CTNK
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE SoLuong IS NOT NULL)
    BEGIN
        DECLARE @gia DECIMAL(8, 0);

        -- Calculate the ThanhTien based on SoLuong and DonGia
        UPDATE CTNK
        SET ThanhTien = i.SoLuong * NL.DonGia
        FROM inserted AS i
        INNER JOIN NguyenLieu AS NL ON i.ID_NL = NL.ID_NL;

        -- Perform the actual insert or update on the CTNK table
        INSERT INTO CTNK (ID_NK, ID_NL, SoLuong, ThanhTien)
        SELECT ID_NK, ID_NL, SoLuong, ThanhTien
        FROM inserted;
    END;
END;

--Trigger Tong tien o PhieuNK bang tong thanh tien cua CTNK
-- Create the Tg_PNK_Tongtien trigger
CREATE TRIGGER Tg_PNK_Tongtien
ON CTNK
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Check if an INSERT operation occurred
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Update PhieuNK's Tongtien for the INSERT operation
        UPDATE PhieuNK
        SET Tongtien = Tongtien + (SELECT SUM(ThanhTien) FROM inserted)
        WHERE ID_NK IN (SELECT ID_NK FROM inserted);
    END;

    -- Check if an UPDATE operation occurred
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Update PhieuNK's Tongtien for the UPDATE operation
        UPDATE PhieuNK
        SET Tongtien = Tongtien + (SELECT SUM(ThanhTien) FROM inserted) - (SELECT SUM(ThanhTien) FROM deleted)
        WHERE ID_NK IN (SELECT ID_NK FROM inserted);
    END;

    -- Check if a DELETE operation occurred
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Update PhieuNK's Tongtien for the DELETE operation
        UPDATE PhieuNK
        SET Tongtien = Tongtien - (SELECT SUM(ThanhTien) FROM deleted)
        WHERE ID_NK IN (SELECT ID_NK FROM deleted);
    END;
END;

--Trigger khi them CTNK tang So luong ton cua nguyen lieu trong kho
-- Create the Tg_Kho_ThemSLTon trigger
CREATE TRIGGER Tg_Kho_ThemSLTon
ON CTNK
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Check if an INSERT operation occurred
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Update Kho's SLTon for the INSERT operation
        UPDATE Kho
        SET SLTon = SLTon + (SELECT SUM(SoLuong) FROM inserted)
        WHERE ID_NL IN (SELECT ID_NL FROM inserted);
    END;

    -- Check if an UPDATE operation occurred
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Update Kho's SLTon for the UPDATE operation
        UPDATE Kho
        SET SLTon = SLTon + (SELECT SUM(SoLuong) FROM inserted) - (SELECT SUM(SoLuong) FROM deleted)
        WHERE ID_NL IN (SELECT ID_NL FROM inserted);
    END;

    -- Check if a DELETE operation occurred
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Update Kho's SLTon for the DELETE operation
        UPDATE Kho
        SET SLTon = SLTon - (SELECT SUM(SoLuong) FROM deleted)
        WHERE ID_NL IN (SELECT ID_NL FROM deleted);
    END;
END;

--Trigger khi them CTXK giam So luong ton cua nguyen lieu trong kho
-- Create the Tg_Kho_GiamSLTon trigger
CREATE TRIGGER Tg_Kho_GiamSLTon
ON CTXK
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Check if an INSERT operation occurred
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Update Kho's SLTon for the INSERT operation
        UPDATE Kho
        SET SLTon = SLTon - (SELECT SUM(SoLuong) FROM inserted)
        WHERE ID_NL IN (SELECT ID_NL FROM inserted);
    END;

    -- Check if an UPDATE operation occurred
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Update Kho's SLTon for the UPDATE operation
        UPDATE Kho
        SET SLTon = SLTon - (SELECT SUM(SoLuong) FROM inserted) + (SELECT SUM(SoLuong) FROM deleted)
        WHERE ID_NL IN (SELECT ID_NL FROM inserted);
    END;

    -- Check if a DELETE operation occurred
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Update Kho's SLTon for the DELETE operation
        UPDATE Kho
        SET SLTon = SLTon + (SELECT SUM(SoLuong) FROM deleted)
        WHERE ID_NL IN (SELECT ID_NL FROM deleted);
    END;
END;

--Trigger khi them mot Nguyen Lieu moi, them NL do vao Kho
-- Create the Tg_Kho_ThemNL trigger
CREATE TRIGGER Tg_Kho_ThemNL
ON NguyenLieu
AFTER INSERT
AS
BEGIN
    -- Insert a new record into the Kho table with the ID_NL from the inserted record in NguyenLieu
    INSERT INTO Kho (ID_NL, SLTon)
    SELECT ID_NL, 0  -- Assuming SLTon starts at 0 for a new NguyenLieu
    FROM inserted;
END;

--Procedure
--Procudure them mot khach hang moi voi cac thong tin tenKH , NgayTG va ID_ND
CREATE OR ALTER PROCEDURE KH_ThemKH
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


--Procudure them mot nhan vien moi voi cac thong tin tenNV, NgayVL, SDT, Chucvu, ID_NQL, Tinhtrang
CREATE OR ALTER PROCEDURE NV_ThemNV
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

-- Procudure xoa mot NHANVIEN voi idNV
CREATE OR ALTER PROCEDURE NV_XoaNV
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

-- Procudure xoa mot KHACHHANG voi idKH
CREATE OR ALTER PROCEDURE KH_XoaKH
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

-- Procedure xem thong tin KHACHHANG voi thong tin idKH
CREATE OR ALTER PROCEDURE KH_XemTT
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

/
-- Procedure xem thong tin NHANVIEN voi thong tin idNV
CREATE OR ALTER PROCEDURE NV_XemTT
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

/

-- Procedure liet ke danh sach hoa don tu ngay A den ngay B
CREATE OR ALTER PROCEDURE DS_HoaDon_tuAdenB
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

/
-- Procedure liet ke danh sach phieu nhap kho tu ngay A den ngay B
CREATE OR ALTER PROCEDURE DS_PhieuNK_tuAdenB
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

/

-- Procedure liet ke danh sach phieu xuat kho tu ngay A den ngay B
CREATE OR ALTER PROCEDURE DS_PhieuXK_tuAdenB
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

/
-- Procedure xem chi tiet hoa don cua 1 hoa don
CREATE OR ALTER PROCEDURE HD_XemCTHD
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

/
-- Procedure giam So Luong cua Voucher di 1 khi KH doi Voucher
CREATE OR ALTER PROCEDURE Voucher_GiamSL
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

/

-- Procedure giam Diem tich luy cua KH khi doi Voucher
CREATE OR ALTER PROCEDURE KH_TruDTL
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

--Fuction 
--Fuction Tinh doanh thu hoa don theo ngay
CREATE OR ALTER FUNCTION DoanhThuHD_theoNgay
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

--Fuction Tinh chi phi nhap kho theo ngay
CREATE OR ALTER FUNCTION ChiPhiNK_theoNgay
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

--Fuction Tinh doanh so trung binh cua x KHACHHANG co doanh so cao nhat
CREATE OR ALTER FUNCTION DoanhsoTB_TOPxKH
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

--Fuction Tinh so luong KHACHANG moi trong thang chi dinh cua nam co it nhat mot hoa don co tri gia tren x vnd
CREATE OR ALTER FUNCTION SL_KH_Moi
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

    
--Fuction Tinh tien mon an duoc giam khi them mot CTHD moi
CREATE OR ALTER FUNCTION CTHD_Tinhtiengiam
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

--Them data
--ALTER SESSION SET NLS_DATE_FORMAT = 'dd-MM-YYYY';
--Them data cho Bang NguoiDung
--Nhan vien
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (100,'NVHoangViet@gmail.com','123','Verified','Quan Ly');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (101,'NVHoangPhuc@gmail.com','123','Verified','Nhan Vien');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (102,'NVAnhHong@gmail.com','123','Verified','Nhan Vien Kho');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (103,'NVQuangDinh@gmail.com','123','Verified','Nhan Vien');
--Khach Hang
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (104,'KHThaoDuong@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (105,'KHTanHieu@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (106,'KHQuocThinh@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (107,'KHNhuMai@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (108,'KHBichHao@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (109,'KHMaiQuynh@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (110,'KHMinhQuang@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (111,'KHThanhHang@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (112,'KHThanhNhan@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (113,'KHPhucNguyen@gmail.com','123','Verified','Khach Hang');

--Them data cho bang Nhan Vien
ALTER NhanVien SET NLS_DATE_FORMAT = 'dd-MM-YYYY';
--Co tai khoan
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_ND,ID_NQL,Tinhtrang) VALUES (100,'Nguyen Hoang Viet','10/05/2023','0848044725','Quan ly',100,100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_ND,ID_NQL,Tinhtrang) VALUES (101,'Nguyen Hoang Phuc','20/05/2023','0838033334','Tiep tan',101,100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_ND,ID_NQL,Tinhtrang) VALUES (102,'Le Thi Anh Hong','19/05/2023','0838033234','Kho',102,100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_ND,ID_NQL,Tinhtrang) VALUES (103,'Ho Quang Dinh','19/05/2023','0838033234','Tiep tan',103,100,'Dang lam viec');
--Khong co tai khoan
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (104,'Ha Thao Duong','10/05/2023','0838033232','Phuc vu',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (105,'Nguyen Quoc Thinh','11/05/2023','0838033734','Phuc vu',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (106,'Truong Tan Hieu','12/05/2023','0838033834','Phuc vu',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (107,'Nguyen Thai Bao','10/05/2023','0838093234','Phuc vu',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (108,'Tran Nhat Khang','11/05/2023','0838133234','Thu ngan',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (109,'Nguyen Ngoc Luong','12/05/2023','0834033234','Bep',100,'Dang lam viec');

--Them data cho bang KhachHang
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (100,'Ha Thao Duong','10/05/2023',104);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (101,'Truong Tan Hieu','10/05/2023',105);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (102,'Nguyen Quoc Thinh','10/05/2023',106);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (103,'Tran Nhu Mai','10/05/2023',107);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (104,'Nguyen Thi Bich Hao','10/05/2023',108);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (105,'Nguyen Mai Quynh','11/05/2023',109);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (106,'Hoang Minh Quang','11/05/2023',110);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (107,'Nguyen Thanh Hang','12/05/2023',111);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (108,'Nguyen Ngoc Thanh Nhan','11/05/2023',112);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (109,'Hoang Thi Phuc Nguyen','12/05/2023',113);

--Them data cho bang MonAn
--Aries
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(1,'DUI CUU NUONG XE NHO', 250000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(2,'BE SUON CUU NUONG GIAY BAC MONG CO', 230000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(3,'DUI CUU NUONG TRUNG DONG', 350000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(4,'CUU XOC LA CA RI', 129000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(5,'CUU KUNGBAO', 250000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(6,'BAP CUU NUONG CAY', 250000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(7,'CUU VIEN HAM CAY', 19000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(8,'SUON CONG NUONG MONG CO', 250000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(9,'DUI CUU LON NUONG TAI BAN', 750000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(10,'SUONG CUU NUONG SOT NAM', 450000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(11,'DUI CUU NUONG TIEU XANH', 285000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(12,'SUON CUU SOT PHO MAI', 450000,'Aries','Dang kinh doanh');

--Taurus
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(13,'Bit tet bo My khoai tay', 179000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(14,'Bo bit tet Uc',169000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(15,'Bit tet bo My BASIC', 179000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(16,'My Y bo bam', 169000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(17,'Thit suon Wagyu', 1180000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(18,'Steak Thit Vai Wagyu', 1290000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(19,'Steak Thit Bung Bo', 550000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(20,'Tomahawk', 2390000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(21,'Salad Romaine Nuong', 180000,'Taurus','Dang kinh doanh');

--Gemini
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(22,'Combo Happy', 180000,'Gemini','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(23,'Combo Fantastic', 190000,'Gemini','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(24,'Combo Dreamer', 230000,'Gemini','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(25,'Combo Cupid', 180000,'Gemini','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(26,'Combo Poseidon', 190000,'Gemini','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(27,'Combo LUANG PRABANG', 490000,'Gemini','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(28,'Combo VIENTIANE', 620000,'Gemini','Dang kinh doanh');

--Cancer
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(29,'Cua KingCrab Duc sot', 3650000,'Cancer','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(30,'Mai Cua KingCrab Topping Pho Mai', 2650000,'Cancer','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(31,'Cua KingCrab sot Tu Xuyen', 2300000,'Cancer','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(32,'Cua KingCrab Nuong Tu Nhien', 2550000,'Cancer','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(33,'Cua KingCrab Nuong Bo Toi', 2650000,'Cancer','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(34,'Com Mai Cua KingCrab Chien', 1850000,'Cancer','Dang kinh doanh');

--Leo
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(35,'BOSSAM', 650000,'Leo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(36,'KIMCHI PANCAKE', 350000,'Leo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(37,'SPICY RICE CAKE', 250000,'Leo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(38,'SPICY SAUSAGE HOTPOT', 650000,'Leo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(39,'SPICY PORK', 350000,'Leo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(40,'MUSHROOM SPICY SILKY TOFU STEW', 350000,'Leo','Dang kinh doanh');
--Virgo
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(41,'Pavlova', 150000,'Virgo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(42,'Kesutera', 120000,'Virgo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(43,'Cremeschnitte', 250000,'Virgo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(44,'Sachertorte', 150000,'Virgo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(45,'Schwarzwalder Kirschtorte', 250000,'Virgo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(46,'New York-Style Cheesecake', 250000,'Virgo','Dang kinh doanh');

--Libra
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(47,'Cobb Salad', 150000,'Libra','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(48,'Salad Israeli', 120000,'Libra','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(49,'Salad Dau den', 120000,'Libra','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(50,'Waldorf Salad', 160000,'Libra','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(51,'Salad Gado-Gado', 200000,'Libra','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(52,'Nicoise Salad', 250000,'Libra','Dang kinh doanh');

--Scorpio
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(53,'BULGOGI LUNCHBOX', 250000,'Scorpio','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(54,'CHICKEN TERIYAKI LUNCHBOX', 350000,'Scorpio','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(55,'SPICY PORK LUNCHBOX', 350000,'Scorpio','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(56,'TOFU TERIYAKI LUNCHBOX', 250000,'Scorpio','Dang kinh doanh');

--Sagittarius
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(57,'Thit ngua do tuoi', 250000,'Sagittarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(58,'Steak Thit ngua', 350000,'Sagittarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(59,'Thit ngua ban gang', 350000,'Sagittarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(60,'Long ngua xao dua', 150000,'Sagittarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(61,'Thit ngua xao sa ot', 250000,'Sagittarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(62,'Ngua tang', 350000,'Sagittarius','Dang kinh doanh');

--Capricorn
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(63,'Thit de xong hoi', 229000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(64,'Thit de xao rau ngo', 199000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(65,'Thit de nuong tang', 229000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(66,'Thit de chao', 199000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(67,'Thit de nuong xien', 199000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(68,'Nam de nuong/chao', 199000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(69,'Thit de xao lan', 19000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(70,'Dui de tan thuoc bac', 199000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(71,'Canh de ham duong quy', 199000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(72,'Chao de dau xanh', 50000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(73,'Thit de nhung me', 229000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(74,'Lau de nhu', 499000,'Capricorn','Dang kinh doanh');


--Aquarius
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(75,'SIGNATURE WINE', 3290000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(76,'CHILEAN WINE', 3990000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(77,'ARGENTINA WINE', 2890000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(78,'ITALIAN WINE', 5590000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(79,'AMERICAN WINE', 4990000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(80,'CLASSIC COCKTAIL', 200000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(81,'SIGNATURE COCKTAIL', 250000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(82,'MOCKTAIL', 160000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(83,'JAPANESE SAKE', 1490000,'Aquarius','Dang kinh doanh');

--Pisces
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(84,'Ca Hoi Ngam Tuong', 289000,'Pisces','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(85,'Ca Ngu Ngam Tuong', 289000,'Pisces','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(86,'IKURA:Trung ca hoi', 189000,'Pisces','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(87,'KARIN:Sashimi Ca Ngu', 149000,'Pisces','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(88,'KEIKO:Sashimi Ca Hoi', 199000,'Pisces','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(89,'CHIYO:Sashimi Bung Ca Hoi', 219000,'Pisces','Dang kinh doanh');

--Them data cho bang Ban
--Tang 1
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(100,'Ban T1.1','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(101,'Ban T1.2','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(102,'Ban T1.3','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(103,'Ban T1.4','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(104,'Ban T1.5','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(105,'Ban T1.6','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(106,'Ban T1.7','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(107,'Ban T1.8','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(108,'Ban T1.9','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(109,'Ban T1.10','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(110,'Ban T1.11','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(111,'Ban T1.12','Tang 1','Con trong');
--Tang 2
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(112,'Ban T2.1','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(113,'Ban T2.2','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(114,'Ban T2.3','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(115,'Ban T2.4','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(116,'Ban T2.5','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(117,'Ban T2.6','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(118,'Ban T2.7','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(119,'Ban T2.8','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(120,'Ban T2.9','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(121,'Ban T2.10','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(122,'Ban T2.11','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(123,'Ban T2.12','Tang 2','Con trong');
--Tang 3
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(124,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(125,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(126,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(127,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(128,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(129,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(130,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(131,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(132,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(133,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(134,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(135,'Ban T3.1','Tang 3','Con trong');

--Them data cho bang Voucher
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('loQy','20% off for Aries Menu',20,'Aries',10,200);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('pCfI','30% off for Taurus Menu',30,'Taurus',5,300);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('pApo','20% off for Gemini Menu',20,'Gemini',10,200);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('ugQx','100% off for Virgo Menu',100,'Virgo',3,500);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('nxVX','20% off for All Menu',20,'All',5,300);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('Pwyn','20% off for Cancer Menu',20,'Cancer',10,200);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('bjff','50% off for Leo Menu',50,'Leo',5,600);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('YPzJ','20% off for Aquarius Menu',20,'Aquarius',5,200);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('Y5g0','30% off for Pisces Menu',30,'Pisces',5,300);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('7hVO','60% off for Aries Menu',60,'Aries',0,1000);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('WHLm','20% off for Capricorn Menu',20,'Capricorn',0,200);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('GTsC','20% off for Leo Menu',20,'Leo',0,200);


--Them data cho bang HoaDon
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (101,100,100,'10-1-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (102,104,102,'15-1-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (103,105,103,'20-1-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (104,101,101,'13-2-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (105,103,120,'12-2-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (106,104,100,'16-3-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (107,107,103,'20-3-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (108,108,101,'10-4-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (109,100,100,'20-4-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (110,103,101,'5-5-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (111,106,102,'10-5-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (112,108,103,'15-5-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (113,106,102,'20-5-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (114,108,103,'5-6-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (115,109,104,'7-6-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (116,100,105,'7-6-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (117,106,106,'10-6-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (118,102,106,'10-2-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (119,103,106,'12-2-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (120,104,106,'10-4-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (121,105,106,'12-4-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (122,107,106,'12-5-2023',0,0,'Chua thanh toan');

--Them data cho CTHD
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (101,1,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (101,3,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (101,10,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (102,1,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (102,2,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (102,4,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (103,12,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (104,30,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (104,59,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (105,28,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (105,88,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (106,70,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (106,75,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (106,78,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (107,32,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (107,12,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (108,12,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (108,40,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (109,45,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (110,34,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (110,43,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (111,65,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (111,47,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (112,49,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (112,80,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (112,31,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (113,80,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (113,80,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (114,30,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (114,32,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (115,80,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (116,57,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (116,34,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (117,67,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (117,66,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (118,34,10);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (118,35,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (119,83,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (119,78,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (120,38,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (120,39,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (121,53,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (121,31,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (122,33,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (122,34,6);
UPDATE HOADON SET TrangThai='Da thanh toan';

--Them data cho bang NguyenLieu
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(100,'Thit ga',40000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(101,'Thit heo',50000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(102,'Thit bo',80000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(103,'Tom',100000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(104,'Ca hoi',500000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(105,'Gao',40000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(106,'Sua tuoi',40000,'l');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(107,'Bot mi',20000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(108,'Dau ca hoi',1000000,'l');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(109,'Dau dau nanh',150000,'l');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(110,'Muoi',20000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(111,'Duong',20000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(112,'Hanh tay',50000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(113,'Toi',30000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(114,'Dam',50000,'l');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(115,'Thit de',130000,'kg');

--Them data cho PhieuNK
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (100,102,'10-01-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (101,102,'11-02-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (102,102,'12-02-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (103,102,'12-03-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (104,102,'15-03-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (105,102,'12-04-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (106,102,'15-04-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (107,102,'12-05-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (108,102,'15-05-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (109,102,'5-06-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (110,102,'7-06-2023');

--Them data cho CTNK
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (100,100,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (100,101,20);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (100,102,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,101,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,103,20);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,104,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,105,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,106,20);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,107,5);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,108,5);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,109,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,110,20);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,112,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,113,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,114,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (103,112,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (103,113,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (103,114,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (104,112,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (104,113,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (105,110,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (106,102,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (106,115,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (107,110,35);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (107,105,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (108,104,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (108,103,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (108,106,30);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (109,112,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (109,113,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (109,114,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (110,102,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (110,106,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (110,107,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (110,110,20);

--Them data cho PhieuXK
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (100,102,'10-01-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (101,102,'11-02-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (102,102,'12-03-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (103,102,'13-03-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (104,102,'12-04-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (105,102,'13-04-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (106,102,'12-05-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (107,102,'15-05-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (108,102,'20-05-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (109,102,'5-06-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (110,102,'10-06-2023');

--Them data cho CTXK
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (100,100,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (100,101,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (100,102,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,101,7);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,103,10);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,104,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,105,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,106,10);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,109,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,110,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,112,10);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,113,8);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,114,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (103,114,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (103,104,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (104,101,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (104,112,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (105,113,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (105,102,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (106,103,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (106,114,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (107,105,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (107,106,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (108,115,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (108,110,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (109,110,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (109,112,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (110,113,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (110,114,5);



