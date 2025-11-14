CREATE DATABASE QLQCP;
GO

USE QLQCP;
GO

DROP TABLE IF EXISTS DOAN
CREATE TABLE DOAN(
    MaDoAn INT PRIMARY KEY,
    TenDoAn NVARCHAR(100) NOT NULL,
    Gia DECIMAL(10, 2) NOT NULL,
);

DROP TABLE IF EXISTS DOUONG
CREATE TABLE DOUONG(
    MaDoUong INT PRIMARY KEY,
    TenDoUong NVARCHAR(100) NOT NULL,
    Gia DECIMAL(10, 2) NOT NULL 
);

DROP TABLE IF EXISTS KHACHHANG
CREATE TABLE KHACHHANG(
    MaKH INT PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    SDT NVARCHAR(15) NOT NULL
);

DROP TABLE IF EXISTS HOADON
CREATE TABLE HOADON(
    MaHoaDon INT PRIMARY KEY,
    NgayLap DATETIME NOT NULL,
    MaKH INT
);

DROP TABLE IF EXISTS CHITIETHOADON
CREATE TABLE CHITIETHOADON(
    MaHoaDon INT,
    MaDoAn INT NULL,
    MaDoUong INT NULL,
    SoLuong INT NOT NULL
);

ALTER TABLE HOADON
ADD CONSTRAINT FK_HOADON_KHACHHANG FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH);
GO

ALTER TABLE CHITIETHOADON
ADD CONSTRAINT FK_CHITIETHOADON_HOADON FOREIGN KEY (MaHoaDon) REFERENCES HOADON(MaHoaDon);  
ALTER TABLE CHITIETHOADON
ADD CONSTRAINT FK_CHITIETHOADON_DOAN FOREIGN KEY (MaDoAn) REFERENCES DOAN(MaDoAn);  
ALTER TABLE CHITIETHOADON
ADD CONSTRAINT FK_CHITIETHOADON_DOUONG FOREIGN KEY (MaDoUong) REFERENCES DOUONG(MaDoUong);
GO

INSERT INTO DOAN (MaDoAn, TenDoAn, Gia) VALUES
(1, N'Khô gà', 25000),
(2, N'Khô bò', 25000),
(3, N'Nem chua rán', 36000),
(4, N'Ngô cay', 15000),
(5, N'Hướng dương', 15000);
GO

INSERT INTO DOUONG (MaDoUong, TenDoUong, Gia) VALUES
(1, N'Cà phê đen', 20000),
(2, N'Cà phê sữa', 20000),
(3, N'Bạc xỉu', 28000),
(4, N'Cà phê muối', 28000),
(5, N'Americano', 25000),
(6, N'Capuchino', 32000),
(7, N'Caramel Macchiato', 35000),
(8, N'Matcha latte', 30000),
(9, N'Matcha macchiato', 35000),
(10, N'Cacao latte', 30000),
(11, N'Trà đào cam sả', 32000),
(12, N'Hồng trà việt quất', 30000),
(13, N'Trà chanh nha đam', 20000),
(14, N'Yahul Ô long', 26000),
(15, N'Yakul Việt quất', 28000),
(16, N'Yakul Đào', 25000);
GO

INSERT INTO KHACHHANG (MaKH, TenKH, SDT) VALUES
(1, N'Nguyễn Duy Đạt', 0265963206),
(2, N'Phạm Minh Hoàng', 0366630733),
(3, N'Nguyễn Thị Linh', 0338000873),
(4, N'Cao Thùy Châm', 0969206477),
(5, N'Mã Thục Quyên', 0837069885);
GO

INSERT INTO HOADON (MaHoaDon, NgayLap, MaKH) VALUES
(1, '2023-10-01 10:00:00', 1),
(2, '2023-10-02 11:30:00', 2),
(3, '2023-10-03 14:15:00', 3),
(4, '2023-10-04 16:45:00', 4),
(5, '2023-10-05 18:20:00', 5);
GO

INSERT INTO CHITIETHOADON (MaHoaDon, MaDoAn, MaDoUong, SoLuong) VALUES
(1, 1, 1, 2),
(1, 2, NULL, 1),
(2, NULL, 3, 1),
(2, 4, 2, 2),
(3, 5, NULL, 1),
(3, NULL, 4, 1),
(4, 3, 5, 1),
(4, NULL, 6, 2),
(5, 2, NULL, 1),
(5, NULL, 7, 1);
GO

SELECT * FROM DOAN;
SELECT * FROM DOUONG;
SELECT * FROM KHACHHANG;
SELECT * FROM HOADON;
SELECT * FROM CHITIETHOADON;
GO
---------------------------------------------------------------------------------------------------
CREATE INDEX DOAN_Gia ON DOAN(Gia);
CREATE INDEX DOUONG_Gia ON DOUONG(Gia);
CREATE INDEX KHACHHANG_SDT ON KHACHHANG(SDT);
CREATE INDEX HOADON_NgayLap ON HOADON(NgayLap);
CREATE INDEX HOADON_MaKH ON HOADON(MaKH);
CREATE INDEX CHITIETHOADON_MaDoAn ON CHITIETHOADON(MaDoAn);
CREATE INDEX CHITIETHOADON_MaDoUong ON CHITIETHOADON(MaDoUong);
CREATE INDEX CHITIETHOADON_SoLuong ON CHITIETHOADON(SoLuong);
GO
---------------------------------------------------------------------------------------------------
CREATE TRIGGER KIEMTRADOAN
ON DOAN
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @Gia DECIMAL(10, 2);

    SELECT @Gia = Gia FROM inserted;

    IF @Gia <= 0
    BEGIN
        RAISERROR(N'Giá món ăn phải lớn hơn 0.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER KIEMTRADOUONG
ON DOUONG
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @Gia DECIMAL(10, 2);

    SELECT @Gia = Gia FROM inserted;

    IF @Gia <= 0
    BEGIN
        RAISERROR(N'Giá đồ uống phải lớn hơn 0.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER KIEMTRAKHACHHANG
ON KHACHHANG
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @SDT NVARCHAR(15);

    SELECT @SDT = SDT FROM inserted;

    IF LEN(@SDT) != 10
    BEGIN
        RAISERROR(N'Số điện thoại phải có độ dài 10 ký tự.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER KIEMTRAHOADON
ON HOADON
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @NgayLap DATETIME;

    SELECT @NgayLap = NgayLap FROM inserted;

    IF @NgayLap > GETDATE()
    BEGIN
        RAISERROR(N'Ngày lập hóa đơn không được lớn hơn ngày hiện tại.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER KIEMTRACHITIETHOADON
ON CHITIETHOADON
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @SoLuong INT;

    SELECT @SoLuong = SoLuong FROM inserted;

    IF @SoLuong <= 0
    BEGIN
        RAISERROR(N'Số lượng phải lớn hơn 0.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
---------------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS THEMDOAN;
GO
CREATE PROCEDURE THEMDOAN
    @MaDoAn INT,
    @TenDoAn NVARCHAR(100),
    @Gia DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO DOAN (MaDoAn, TenDoAn, Gia)
    VALUES (@MaDoAn, @TenDoAn, @Gia);

    PRINT N'Đã thêm món ăn thành công.';
END;
GO

DROP PROCEDURE IF EXISTS THEMDOUONG;
GO
CREATE PROCEDURE THEMDOUONG
    @MaDoUong INT,
    @TenDoUong NVARCHAR(100),
    @Gia DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO DOUONG (MaDoUong, TenDoUong, Gia)
    VALUES (@MaDoUong, @TenDoUong, @Gia);

    PRINT N'Đã thêm đồ uống thành công.';
END;
GO

DROP PROCEDURE IF EXISTS THEMKHACHHANG;
GO
CREATE PROCEDURE THEMKHACHHANG
    @MaKH INT,
    @TenKH NVARCHAR(100),
    @SDT NVARCHAR(15)
AS
BEGIN
    INSERT INTO KHACHHANG (MaKH, TenKH, SDT)
    VALUES (@MaKH, @TenKH, @SDT);

    PRINT N'Đã thêm khách hàng thành công.';
END;
GO

DROP PROCEDURE IF EXISTS THEMHOADON;
GO
CREATE PROCEDURE THEMHOADON
    @MaHoaDon INT,
    @NgayLap DATETIME = NULL,
    @MaKH INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Khách hàng không tồn tại.', 16, 1);
            RETURN;
        END
        IF @NgayLap IS NULL
        BEGIN
            SET @NgayLap = GETDATE();
        END
        INSERT INTO HOADON (MaHoaDon, NgayLap, MaKH)
        VALUES (@MaHoaDon, @NgayLap, @MaKH);
        PRINT N'Đã thêm hóa đơn thành công.';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT(N'Lỗi khi thêm hóa đơn: ' + @ErrorMessage);
    END CATCH;
END;
GO

DROP PROCEDURE IF EXISTS THEMCHITIETHOADON;
GO
CREATE PROCEDURE THEMCHITIETHOADON
    @MaHoaDon INT,
    @MaDoAn INT = NULL,
    @MaDoUong INT = NULL,
    @SoLuong INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF NOT EXISTS (SELECT 1 FROM HOADON WHERE MaHoaDon = @MaHoaDon)
        BEGIN
            RAISERROR(N'Hóa đơn không tồn tại.', 16, 1);
            RETURN;
        END
        IF @MaDoAn IS NULL AND @MaDoUong IS NULL
        BEGIN
            RAISERROR(N'Phải cung cấp ít nhất một món ăn hoặc đồ uống.', 16, 1);
            RETURN;
        END
        
        IF @MaDoAn IS NOT NULL AND @MaDoUong IS NOT NULL
        BEGIN
            RAISERROR(N'Chỉ được cung cấp một trong hai: món ăn hoặc đồ uống.', 16, 1);
            RETURN;
        END

        IF @MaDoAn IS NOT NULL AND NOT EXISTS (SELECT 1 FROM DOAN WHERE MaDoAn = @MaDoAn)
        BEGIN
            RAISERROR(N'Món ăn không tồn tại.', 16, 1);
            RETURN;
        END

        IF @MaDoUong IS NOT NULL AND NOT EXISTS (SELECT 1 FROM DOUONG WHERE MaDoUong = @MaDoUong)
        BEGIN
            RAISERROR(N'Đồ uống không tồn tại.', 16, 1);
            RETURN;
        END

        INSERT INTO CHITIETHOADON (MaHoaDon, MaDoAn, MaDoUong, SoLuong)
        VALUES (@MaHoaDon, @MaDoAn, @MaDoUong, @SoLuong);
        PRINT(N'Đã thêm chi tiết hóa đơn thành công.');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT(N'Lỗi khi thêm chi tiết hóa đơn: ' + @ErrorMessage);
    END CATCH;
END;
GO

EXEC THEMDOAN 1, N'Khô gà', 15000;
EXEC THEMDOUONG 8, N'Cà phê sữa', 20000;
EXEC THEMKHACHHANG 4, N'Nguyễn Văn An', N'0987654321';
EXEC THEMHOADON 6, NULL, 4;
EXEC THEMCHITIETHOADON 6, 10, NULL, 10;
GO
---------------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS SUADOAN;
GO
CREATE PROCEDURE SUADOAN
    @MaDoAn INT,
    @TenDoAn NVARCHAR(100),
    @Gia DECIMAL(10, 2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF NOT EXISTS (SELECT 1 FROM DOAN WHERE MaDoAn = @MaDoAn)
        BEGIN
            RAISERROR(N'Món ăn không tồn tại.', 16, 1);
            RETURN;
        END

        IF @TenDoAn IS NOT NULL AND @Gia IS NOT NULL
        BEGIN
            UPDATE DOAN
            SET TenDoAn = @TenDoAn,
                Gia = @Gia
            WHERE MaDoAn = @MaDoAn;
        END
        ELSE IF @TenDoAn IS NOT NULL
        BEGIN
            UPDATE DOAN
            SET TenDoAn = @TenDoAn
            WHERE MaDoAn = @MaDoAn;
        END
        ELSE IF @Gia IS NOT NULL
        BEGIN
            UPDATE DOAN
            SET Gia = @Gia
            WHERE MaDoAn = @MaDoAn;
        END
        ELSE
        BEGIN
            RAISERROR(N'Phải cung cấp ít nhất một thông tin để cập nhật.', 16, 1);
            RETURN;
        END;
        PRINT(N'Đã cập nhật món ăn thành công.');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT(N'Lỗi khi cập nhật món ăn: ' + @ErrorMessage);
    END CATCH;
END;
GO

DROP PROCEDURE IF EXISTS SUADOUONG;
GO
CREATE PROCEDURE SUADOUONG
    @MaDoUong INT,
    @TenDoUong NVARCHAR(100),
    @Gia DECIMAL(10, 2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF NOT EXISTS (SELECT 1 FROM DOUONG WHERE MaDoUong = @MaDoUong)
        BEGIN
            RAISERROR(N'Đồ uống không tồn tại.', 16, 1);
            RETURN;
        END

        IF @TenDoUong IS NOT NULL AND @Gia IS NOT NULL
        BEGIN
            UPDATE DOUONG
            SET TenDoUong = @TenDoUong,
                Gia = @Gia
            WHERE MaDoUong = @MaDoUong;
        END
        ELSE IF @TenDoUong IS NOT NULL
        BEGIN
            UPDATE DOUONG
            SET TenDoUong = @TenDoUong
            WHERE MaDoUong = @MaDoUong;
        END
        ELSE IF @Gia IS NOT NULL
        BEGIN
            UPDATE DOUONG
            SET Gia = @Gia
            WHERE MaDoUong = @MaDoUong;
        END
        ELSE
        BEGIN
            RAISERROR(N'Phải cung cấp ít nhất một thông tin để cập nhật.', 16, 1);
            RETURN;
        END;
        PRINT(N'Đã cập nhật đồ uống thành công.');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT(N'Lỗi khi cập nhật đồ uống: ' + @ErrorMessage);
    END CATCH;
END;
GO 

DROP PROCEDURE IF EXISTS SUAKHACHHANG;
GO
CREATE PROCEDURE SUAKHACHHANG
    @MaKH INT,
    @TenKH NVARCHAR(100),
    @SDT NVARCHAR(15)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Khách hàng không tồn tại.', 16, 1);
            RETURN;
        END

        IF @TenKH IS NOT NULL AND @SDT IS NOT NULL
        BEGIN
            UPDATE KHACHHANG
            SET TenKH = @TenKH,
                SDT = @SDT
            WHERE MaKH = @MaKH;
        END
        ELSE IF @TenKH IS NOT NULL
        BEGIN
            UPDATE KHACHHANG
            SET TenKH = @TenKH
            WHERE MaKH = @MaKH;
        END
        ELSE IF @SDT IS NOT NULL
        BEGIN
            UPDATE KHACHHANG
            SET SDT = @SDT
            WHERE MaKH = @MaKH;
        END
        ELSE
        BEGIN
            RAISERROR(N'Phải cung cấp ít nhất một thông tin để cập nhật.', 16, 1);
            RETURN;
        END;
        PRINT(N'Đã cập nhật khách hàng thành công.');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT(N'Lỗi khi cập nhật khách hàng: ' + @ErrorMessage);
    END CATCH;
END;
GO

DROP PROCEDURE IF EXISTS SUAHOADON;
GO
CREATE PROCEDURE SUAHOADON
    @MaHoaDon INT,
    @NgayLap DATETIME = NULL,
    @MaKH INT = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF NOT EXISTS (SELECT 1 FROM HOADON WHERE MaHoaDon = @MaHoaDon)
        BEGIN
            RAISERROR(N'Hóa đơn không tồn tại.', 16, 1);
            RETURN;
        END

        IF @NgayLap IS NOT NULL AND @MaKH IS NOT NULL
        BEGIN
            UPDATE HOADON
            SET NgayLap = @NgayLap,
                MaKH = @MaKH
            WHERE MaHoaDon = @MaHoaDon;
        END
        ELSE IF @NgayLap IS NOT NULL
        BEGIN
            UPDATE HOADON
            SET NgayLap = @NgayLap
            WHERE MaHoaDon = @MaHoaDon;
        END
        ELSE IF @MaKH IS NOT NULL
        BEGIN
            UPDATE HOADON
            SET MaKH = @MaKH
            WHERE MaHoaDon = @MaHoaDon;
        END
        ELSE
        BEGIN
            RAISERROR(N'Phải cung cấp ít nhất một thông tin để cập nhật.', 16, 1);
            RETURN;
        END;
        PRINT(N'Đã cập nhật hóa đơn thành công.');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT(N'Lỗi khi cập nhật hóa đơn: ' + @ErrorMessage);
    END CATCH;
END;
GO

DROP PROCEDURE IF EXISTS SUACHITIETHOADON;
GO
CREATE PROCEDURE SUACHITIETHOADON
    @MaHoaDon INT,
    @MaDoAn INT = NULL,
    @MaDoUong INT = NULL,
    @SoLuong INT = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF NOT EXISTS (SELECT 1 FROM CHITIETHOADON WHERE MaHoaDon = @MaHoaDon AND (MaDoAn = @MaDoAn OR MaDoUong = @MaDoUong))
        BEGIN
            RAISERROR(N'Chi tiết hóa đơn không tồn tại.', 16, 1);
            RETURN;
        END

        IF @SoLuong IS NOT NULL
        BEGIN
            UPDATE CHITIETHOADON
            SET SoLuong = @SoLuong
            WHERE MaHoaDon = @MaHoaDon AND (MaDoAn = @MaDoAn OR MaDoUong = @MaDoUong);
        END
        ELSE
        BEGIN
            RAISERROR(N'Phải cung cấp số lượng để cập nhật.', 16, 1);
            RETURN;
        END;
        PRINT(N'Đã cập nhật chi tiết hóa đơn thành công.');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT(N'Lỗi khi cập nhật chi tiết hóa đơn: ' + @ErrorMessage);
    END CATCH;
END;
GO

EXEC SUADOAN
    @MaDoAn = 6,
    @TenDoAn = N'Khô gà lá chanh',
    @Gia = 30000;
GO

EXEC SUADOUONG
    @MaDoUong = 2,
    @TenDoUong = N'Cà phê sữa đá',
    @Gia = 22000;
GO

EXEC SUAKHACHHANG
    @MaKH = 1,
    @TenKH = N'Nguyễn Văn An',
    @SDT = N'0987654320';
GO

EXEC SUAHOADON
    @MaHoaDon = 1,
    @NgayLap = '2024-01-01 10:00:00',
    @MaKH = 2;
GO

EXEC SUACHITIETHOADON
    @MaHoaDon = 1,
    @MaDoAn = 1,
    @SoLuong = 5;
GO
---------------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS XOADOAN;
GO
CREATE PROCEDURE XOADOAN
    @MaDoAn INT,
    @KiemTra BIT = 1
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF NOT EXISTS (SELECT 1 FROM DOAN WHERE MaDoAn = @MaDoAn)
        BEGIN
            RAISERROR(N'Món ăn không tồn tại.', 16, 1);
            RETURN;
        END

        IF @KiemTra = 1
        AND EXISTS (SELECT 1 FROM CHITIETHOADON WHERE MaDoAn = @MaDoAn)
        BEGIN
            RAISERROR(N'Món ăn đang được sử dụng trong chi tiết hóa đơn. Không thể xóa. Chọn @KiemTra = 0 để xóa cứng', 16, 1);
            RETURN;
        END

        IF @KiemTra = 0
        BEGIN
            DELETE FROM CHITIETHOADON WHERE MaDoAn = @MaDoAn;
            PRINT(N'Đã xóa các chi tiết hóa đơn liên quan đến món ăn.');
        END

        DELETE FROM DOAN WHERE MaDoAn = @MaDoAn;
        PRINT(N'Đã xóa món ăn thành công.');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT(N'Lỗi khi xóa món ăn: ' + @ErrorMessage);
    END CATCH;
END;
GO

DROP PROCEDURE IF EXISTS XOADOUONG;
GO
CREATE PROCEDURE XOADOUONG
    @MaDoUong INT,
    @KiemTra BIT = 1
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF NOT EXISTS (SELECT 1 FROM DOUONG WHERE MaDoUong = @MaDoUong)
        BEGIN
            RAISERROR(N'Đồ uống không tồn tại.', 16, 1);
            RETURN;
        END

        IF @KiemTra = 1
        AND EXISTS (SELECT 1 FROM CHITIETHOADON WHERE MaDoUong = @MaDoUong)
        BEGIN
            RAISERROR(N'Đồ uống đang được sử dụng trong chi tiết hóa đơn. Không thể xóa. Chọn @KiemTra = 0 để xóa cứng', 16, 1);
            RETURN;
        END

        IF @KiemTra = 0
        BEGIN
            DELETE FROM CHITIETHOADON WHERE MaDoUong = @MaDoUong;
            PRINT(N'Đã xóa các chi tiết hóa đơn liên quan đến đồ uống.');
        END

        DELETE FROM DOUONG WHERE MaDoUong = @MaDoUong;
        PRINT(N'Đã xóa đồ uống thành công.');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT(N'Lỗi khi xóa đồ uống: ' + @ErrorMessage);
    END CATCH;
END;
GO

DROP PROCEDURE IF EXISTS XOAKHACHHANG;
GO
CREATE PROCEDURE XOAKHACHHANG
    @MaKH INT,
    @KiemTra BIT = 1
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Khách hàng không tồn tại.', 16, 1);
            RETURN;
        END

        IF @KiemTra = 1
        AND EXISTS (SELECT 1 FROM HOADON WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Khách hàng đang được sử dụng trong hóa đơn. Không thể xóa. Chọn @KiemTra = 0 để xóa cứng', 16, 1);
            RETURN;
        END

        IF @KiemTra = 0
        BEGIN
            DELETE FROM CHITIETHOADON
            WHERE MaHoaDon IN (SELECT MaHoaDon FROM HOADON WHERE MaKH = @MaKH);
            DELETE FROM HOADON WHERE MaKH = @MaKH;
            PRINT(N'Đã xóa các hóa đơn và chi tiết hóa đơn liên quan đến khách hàng.');
        END

        DELETE FROM KHACHHANG WHERE MaKH = @MaKH;
        PRINT(N'Đã xóa khách hàng thành công.');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT(N'Lỗi khi xóa khách hàng: ' + @ErrorMessage);
    END CATCH;
END;
GO

DROP PROCEDURE IF EXISTS XOAHOADON;
GO
CREATE PROCEDURE XOAHOADON
    @MaHoaDon INT,
    @KiemTra BIT = 1
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF NOT EXISTS (SELECT 1 FROM HOADON WHERE MaHoaDon = @MaHoaDon)
        BEGIN
            RAISERROR(N'Hóa đơn không tồn tại.', 16, 1);
            RETURN;
        END

        IF @KiemTra = 1
        AND EXISTS (SELECT 1 FROM CHITIETHOADON WHERE MaHoaDon = @MaHoaDon)
        BEGIN
            RAISERROR(N'Hóa đơn đang có chi tiết hóa đơn. Không thể xóa. Chọn @KiemTra = 0 để xóa cứng', 16, 1);
            RETURN;
        END

        IF @KiemTra = 0
        BEGIN
            DELETE FROM CHITIETHOADON WHERE MaHoaDon = @MaHoaDon;
            PRINT(N'Đã xóa các chi tiết hóa đơn liên quan đến hóa đơn.');
        END

        DELETE FROM HOADON WHERE MaHoaDon = @MaHoaDon;
        PRINT(N'Đã xóa hóa đơn thành công.');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT(N'Lỗi khi xóa hóa đơn: ' + @ErrorMessage);
    END CATCH;
END;
GO

DROP PROCEDURE IF EXISTS XOACHITIETHOADON;
GO
CREATE PROCEDURE XOACHITIETHOADON
    @MaHoaDon INT,
    @MaDoAn INT = NULL,
    @MaDoUong INT = NULL,
    @SoLuong INT = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF NOT EXISTS (SELECT 1 FROM CHITIETHOADON WHERE MaHoaDon = @MaHoaDon AND (MaDoAn = @MaDoAn OR MaDoUong = @MaDoUong))
        BEGIN
            RAISERROR(N'Chi tiết hóa đơn không tồn tại.', 16, 1);
            RETURN;
        END

        DELETE FROM CHITIETHOADON
        WHERE MaHoaDon = @MaHoaDon
        AND (MaDoAn = @MaDoAn OR MaDoUong = @MaDoUong)
        AND (@SoLuong IS NULL OR SoLuong = @SoLuong);

        PRINT(N'Đã xóa chi tiết hóa đơn thành công.');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT(N'Lỗi khi xóa chi tiết hóa đơn: ' + @ErrorMessage);
    END CATCH;
END;

EXEC XOADOAN @MaDoAn = 6;
GO
EXEC XOACHITIETHOADON @MaHoaDon = 6, @MaDoAn = 1;
----------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS TIMDOANTHEOGIA;
GO
CREATE FUNCTION TIMDOANTHEOGIA
(
    @GiaMin DECIMAL(10, 2),
    @GiaMax DECIMAL(10, 2)
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM DOAN
    WHERE Gia BETWEEN @GiaMin AND @GiaMax
);
GO

DROP FUNCTION IF EXISTS TIMDOUONGTHEOGIA;
GO
CREATE FUNCTION TIMDOUONGTHEOGIA
(
    @GiaMin DECIMAL(10, 2),
    @GiaMax DECIMAL(10, 2)
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM DOUONG
    WHERE Gia BETWEEN @GiaMin AND @GiaMax
);
GO

DROP FUNCTION IF EXISTS TIMKHACHHANGTHEOSDT;
GO
CREATE FUNCTION TIMKHACHHANGTHEOSDT
(
    @SDT NVARCHAR(15)
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM KHACHHANG
    WHERE SDT = @SDT
);
GO

DROP FUNCTION IF EXISTS TIMHOADONTHEONGAY;
GO
CREATE FUNCTION TIMHOADONTHEONGAY
(
    @NgayBatDau DATETIME,
    @NgayKetThuc DATETIME
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM HOADON
    WHERE NgayLap BETWEEN @NgayBatDau AND @NgayKetThuc
);
GO

DROP FUNCTION IF EXISTS TIMCHITIETHOADONTHEOSOLUONG;
GO
CREATE FUNCTION TIMCHITIETHOADONTHEOSOLUONG
(
    @SoLuongMin INT,
    @SoLuongMax INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM CHITIETHOADON
    WHERE SoLuong BETWEEN @SoLuongMin AND @SoLuongMax
);
GO

SELECT * FROM TIMDOANTHEOGIA(20000, 30000);
GO
----------------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS HOADONCHITIET;
GO
CREATE VIEW HOADONCHITIET AS
SELECT
    HD.MaHoaDon AS MaHoaDon,
    KH.TenKH AS TenKhachHang,
    HD.NgayLap AS NgayLap,
    COALESCE(DA.TenDoAn, DU.TenDoUong) AS TenMon,
    CTHD.SoLuong AS SoLuong,
    ISNULL (DA.Gia, DU.Gia) AS DonGia,
    (CTHD.SoLuong * ISNULL (DA.Gia, DU.Gia)) AS ThanhTien
FROM HOADON HD
INNER JOIN CHITIETHOADON CTHD ON CTHD.MaHoaDon = HD.MaHoaDon
INNER JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
LEFT JOIN DOAN DA ON CTHD.MaDoAn = DA.MaDoAn
LEFT JOIN DOUONG DU ON CTHD.MaDoUong = DU.MaDoUong;
GO

SELECT * FROM HOADONCHITIET
WHERE MaHoaDon = 1;

---------------------------------------------------------------------------------------------------

CREATE ROLE QUANLY;
CREATE ROLE NHANVIEN;
CREATE ROLE KHACHHANG;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON DOAN TO QUANLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON DOUONG TO QUANLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON KHACHHANG TO QUANLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON HOADON TO QUANLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON CHITIETHOADON TO QUANLY;
GRANT EXECUTE ON THEMDOAN TO QUANLY;
GRANT EXECUTE ON THEMDOUONG TO QUANLY;
GRANT EXECUTE ON THEMKHACHHANG TO QUANLY;
GRANT EXECUTE ON THEMHOADON TO QUANLY;
GRANT EXECUTE ON THEMCHITIETHOADON TO QUANLY;
GRANT EXECUTE ON SUADOAN TO QUANLY;
GRANT EXECUTE ON SUADOUONG TO QUANLY;
GRANT EXECUTE ON SUAKHACHHANG TO QUANLY;
GRANT EXECUTE ON SUAHOADON TO QUANLY;
GRANT EXECUTE ON SUACHITIETHOADON TO QUANLY;
GRANT EXECUTE ON XOADOAN TO QUANLY;
GRANT EXECUTE ON XOADOUONG TO QUANLY;
GRANT EXECUTE ON XOAKHACHHANG TO QUANLY;
GRANT EXECUTE ON XOAHOADON TO QUANLY;
GRANT EXECUTE ON XOACHITIETHOADON TO QUANLY;
GO

GRANT SELECT, INSERT ON DOAN TO NHANVIEN;
GRANT SELECT, INSERT ON DOUONG TO NHANVIEN;
GRANT SELECT, INSERT ON KHACHHANG TO NHANVIEN;
GRANT SELECT, INSERT ON HOADON TO NHANVIEN;
GRANT SELECT, INSERT ON CHITIETHOADON TO NHANVIEN;
GRANT EXECUTE ON THEMDOAN TO NHANVIEN;
GRANT EXECUTE ON THEMDOUONG TO NHANVIEN;
GRANT EXECUTE ON THEMKHACHHANG TO NHANVIEN;
GRANT EXECUTE ON THEMHOADON TO NHANVIEN;
GRANT EXECUTE ON THEMCHITIETHOADON TO NHANVIEN;
GO

GRANT SELECT ON DOAN TO KHACHHANG;
GRANT SELECT ON DOUONG TO KHACHHANG;
GO
---------------------------------------------------------------------------------------------------

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'ThisIsPassword';

CREATE CERTIFICATE CaPheChoi
WITH SUBJECT = 'Nhan vien ngon hon ca phe';

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE CaPheChoi;

ALTER DATABASE QLQCP
SET ENCRYPTION ON;
