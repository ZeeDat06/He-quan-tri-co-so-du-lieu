USE QLQCP;
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
    @TenKH = N'Nguyễn Văn A',
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
