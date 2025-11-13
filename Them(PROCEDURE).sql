USE QLQCP;
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

CREATE PROCEDURE THEMHOADON
    @MaHoaDon INT,
    @NgayLap DATETIME = NULL,
    @MaKH INT
AS
BEGIN
    IF @NgayLap IS NULL
    BEGIN
        SET @NgayLap = GETDATE();
    END

    INSERT INTO HOADON (MaHoaDon, NgayLap, MaKH)
    VALUES (@MaHoaDon, @NgayLap, @MaKH);

    PRINT N'Đã thêm hóa đơn thành công.';
END;
GO

CREATE PROCEDURE THEMCHITIETHOADON
    @MaHoaDon INT,
    @MaDoAn INT = NULL,
    @MaDoUong INT = NULL,
    @SoLuong INT
AS
BEGIN
    INSERT INTO CHITIETHOADON (MaHoaDon, MaDoAn, MaDoUong, SoLuong)
    VALUES (@MaHoaDon, @MaDoAn, @MaDoUong, @SoLuong);

    PRINT N'Đã thêm chi tiết hóa đơn thành công.';
END;
GO

EXEC THEMDOAN 1, N'Khô gà', 15000;
EXEC THEMDOUONG 8, N'Cà phê sữa', 20000;
EXEC THEMKHACHHANG 4, N'Nguyễn Văn A', N'0987654321';
EXEC THEMHOADON 6, NULL, 4;