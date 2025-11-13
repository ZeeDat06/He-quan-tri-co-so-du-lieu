USE QLQCP;
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

CREATE PROCEDURE XOACHITIETHOADON
    @MaHoaDon INT,
    @MaDoAn INT = NULL,
    @MaDoUong INT = NULL
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
        AND (MaDoAn = @MaDoAn OR MaDoUong = @MaDoUong);

        PRINT(N'Đã xóa chi tiết hóa đơn thành công.');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT(N'Lỗi khi xóa chi tiết hóa đơn: ' + @ErrorMessage);
    END CATCH;
END;

EXEC XOADOAN @MaDoAn = 2;