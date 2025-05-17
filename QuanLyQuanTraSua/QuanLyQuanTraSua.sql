use QuanLyQuanTraSua
Go
create table TableFood(
	id int identity primary key,
	name nvarchar(100) NOT NULL,
	status nvarchar(100) Not null default N'Trống'-- Trong // Co Nguoi
	)
GO

create table Account
(
		id int identity primary key,
		DisplayName nvarchar(100) not null default N'Eirian',
		UserName nvarchar(100) not null ,
		PassWord nvarchar(1000) not null default 0,
		Type int not null default 0
)
GO
create  table FoodCategory
 (
		id int identity primary key,
	    name nvarchar(100) not null,
 )
 GO
 create table Food 
 (
   		id int identity primary key,
	    name nvarchar(100) not null,
		idCategory int not null,
		price float not null

		foreign key (idCategory) references FoodCategory(id)
 )

GO

create table bill
 (
    id int identity primary key,
	DateCheckIn Date not null default GetDate(),
	DataCheckOut Date,
	idTable int not null,
	status int not null --1: thanh toan 0: chua thanh toan
	foreign key (idTable) references TableFood(id)


)
GO

create table BillInfo
(
    id int identity primary key,
	idBill int not null,
	idFood int not null,
	count int not null default 0

	foreign key (idBill) references Bill(id),
		foreign key (idFood) references Food(id)
	)
Go


select * from Account

Create proc USP_Login
@userName nvarchar(100), @passWord nvarchar(100)
AS
Begin 
	Select * from Account where UserName = @userName and PassWord = @passWord
End

declare @i INT = 11

while @i <= 12
begin
  insert TableFood (name) values (N'Bàn ' +  cast(@i as nvarchar(100)))
  set @i = @i + 1;
end

select * from TableFood
drop table TableFood
delete  from TableFood 

create proc USP_GetTableList
AS Select * from TableFood

exec dbo.USP_GetTableList

insert Account (DisplayName, UserName, PassWord, Type) values (N'Clone', N'1',N'1',1),

select * from Account

update TableFood set status = N'Có người' WHERE id = 40

INSERT INTO FoodCategory (name) VALUES
(N'Trà sữa'),
(N'Trà trái cây'),
(N'Sữa tươi'),
(N'Đồ ăn vặt'),
(N'Nước ép trái cây');

select * from FoodCategory

-- Món ăn cho Trà sữa
INSERT INTO Food (name, idCategory, price) VALUES
(N'Trà sữa truyền thống', 1, 20000),
(N'Trà sữa socola', 1, 25000),
(N'Trà sữa kiwi', 1, 25000);

-- Món ăn cho Trà trái cây
INSERT INTO Food (name, idCategory, price) VALUES
(N'Trà trái cây nhiệt đới', 2, 20000),
(N'Trà măng cụt', 2, 25000),
(N'Trà dâu tây', 2, 25000);

-- Món ăn cho Sữa tươi
INSERT INTO Food (name, idCategory, price) VALUES
(N'Sữa tươi trân châu đường đen', 3, 20000),
(N'Sữa tươi cacao', 3, 20000),
(N'Sữa tươi dừa', 3, 25000);

-- Món ăn cho Đồ ăn vặt
INSERT INTO Food (name, idCategory, price) VALUES
(N'Bánh tráng cuốn', 4, 25000),
(N'Khoai tây chiên', 4, 15000),
(N'Gà rán', 4, 25000);

-- Món ăn cho Nước ép trái cây
INSERT INTO Food (name, idCategory, price) VALUES
(N'Nước ép cam', 5, 15000),
(N'Nước ép táo', 5, 15000),
(N'Nước ép bưởi', 5, 15000);

select * from Food
-- them bill
INSERT INTO bill (DateCheckIn, DataCheckOut, idTable, status) VALUES
(GETDATE(), NULL, 32, 0), -- chưa thanh toán
(GETDATE(),GETDATE() , 33, 1), --  đã thanh toán
(GETDATE(), NULL, 34, 0), --  chưa thanh toán
(GETDATE(), NULL, 40, 1); --  đã thanh toán

select * from bill

-- them bill info
INSERT INTO BillInfo (idBill, idFood, count) VALUES
(1, 1, 2), -- Hóa đơn 1, món ăn 1, số lượng 2
(1, 2, 1), -- Hóa đơn 1, món ăn 2, số lượng 1
(2, 3, 3), -- Hóa đơn 2, món ăn 3, số lượng 3
(2, 4, 2), -- Hóa đơn 2, món ăn 4, số lượng 2
(3, 1, 1), -- Hóa đơn 3, món ăn 1, số lượng 1
(4, 5, 1);

SELECT * FROM BillInfo
Select * from bill
Select * from Food
SELECT * FROM FoodCategory
SELECT f.name, b.count, f.price, f.price*b.count as totalPrice FROM BillInfo AS b, bill as bi, Food as f
WHERE	bi.id = b.idBill and b.idFood = f.id and bi.idTable = 33

create PROC USP_InsertBill
@idTable INT
AS 
BEGIN
	INSERT bill (DateCheckIn, DataCheckOut, idTable, status) 
	VALUES
	(GETDATE(), NULL, @idTable, 0)
END

CREATE PROC USP_InsertBillInfo
@idBill int, @idFood INT, @count INT
AS
BEGIN
	 DECLARE @isExitsBillInfo INT
	 DECLARE @foodCount INT = 1

	 SELECT @isExitsBillInfo = id, @foodCount = count
	 FROM BillInfo Where idBill = @idBill and idFood = @idFood

	 IF ( @isExitsBillInfo > 0)
	 BEGIN
		DECLARE @newCount INT = @foodCount + @count
		IF (@newCount > 0)
			UPDATE BillInfo SET count = @foodCount + @count WHERE idFood = @idFood
		ELSE
			DELETE BillInfo WHERE idBill = @idBill AND idFood = @idFood
	END
	ELSE
	BEGIN
	 INSERT BillInfo (idBill, idFood, count) VALUES
	  (@idBill, @idFood, @count)
	END
END

UPDATE bill SET status = 1 where idTable = 1

select * from bill
select * from Table

CREATE TRIGGER UTG_UpdateBillInfo
ON BillInfo FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @idBill INT

	SELECT @idBill = idBill FROM Inserted

	DECLARE @idTable INT

	SELECT @idTable = idTable FROM bill WHERE id = @idBill AND status = 0

	UPDATE TableFood SET status = N'Có người' WHERE id = @idTable
END

CREATE TRIGGER UTG_UpdateBill
ON bill FOR UPDATE
AS
BEGIN
	DECLARE @idBill INT

	SELECT @idBill = id FROM Inserted

	DECLARE @idTable INT

	SELECT @idTable = idTable FROM bill WHERE id = @idBill AND id = @idBill

	DECLARE @count int = 0

	SELECT @count = COUNT(*) FROM bill WHERE idTable = @idTable AND status = 0;

	IF (@count = 0) 
		UPDATE TableFood SET status = N'Trống' where id = @idTable
END
ALTER Table bill ADD totalPrice FLOAT
CREATE PROC USP_GetListBillByDate
@CheckIn date, @CheckOut date
AS
BEGIN
	SELECT t.name as [Tên bàn], b.totalPrice as [Tổng tiền], DateCheckIn as [Ngày vào], DataCheckOut as [Ngày ra]
	FROM bill as b, TableFood as t
	WHERE DateCheckIn >= @CheckIn AND DataCheckOut <= @CheckOut AND b.status = 1 and t.id = b.idTable
END

delete  BillInfo
delete bill

select * from Account

--CREATE PROC USP_UpdateAccount
--@userName Nvarchar(100), @displayName nvarchar(100), @password nvarchar(100), @newPassword nvarchar(100)
--AS
--BEGIN
--	DECLARE @isRightPass int = 0
	
--	SELECT @isRightPass = COUNT(*) FROM Account Where UserName = @userName AND PassWord = @password

--	IF (@isRightPass = 1)
--	BEGIN
--		IF (@newPassword = NULL OR @newPassword = '')
--		BEGIN
--			UPDATE Account SET DisplayName = @displayName WHERE UserName = @userName
--		END
--		ELSE
--			UPDATE Account SET DisplayName = @displayName,  PassWord = @password WHERE UserName = @userName
--	END
--END

ALTER PROC USP_UpdateAccount
@userName Nvarchar(100), 
@displayName nvarchar(100), 
@password nvarchar(100), 
@newPassword nvarchar(100)
AS
BEGIN
    DECLARE @isRightPass int = 0
    
    SELECT @isRightPass = COUNT(*) FROM Account 
    WHERE UserName = @userName AND PassWord = @password

    IF (@isRightPass = 1)
    BEGIN
        UPDATE Account 
        SET DisplayName = @displayName, 
            PassWord = CASE 
                WHEN @newPassword IS NOT NULL AND @newPassword <> '' THEN @newPassword 
                ELSE PassWord 
            END 
        WHERE UserName = @userName
    END
END