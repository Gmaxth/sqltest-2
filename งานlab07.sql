---ข้อที่ 1

Select CustomerID, CompanyName
From Customers
Where CustomerID = 'ALFKI'

use Northwind

Begin Transaction;

insert into Orders
(CustomerID,EmployeeID,
OrderDate, RequiredDate,Freight)
Values
('ALFKI',1,GETDATE(),DATEADD(DAY,7,GETDATE()),50.00)

Select SCOPE_IDENTITY()
		AS NewOrderID;
--newOrderID 11078


INSERT INTO [Order Details]
	(OrderID,ProductID,
	UnitPrice,Quantity,Discount)
Select
	11078, ProductID,
	UnitPrice, 2,0
FROM Products
Where ProductID = 1;


SELECT * From Orders
Where OrderID = 11078;

SELECT * From [Order Details]
Where OrderID = 11078;

Commit


---ข้อที่ 2
use Northwind

Begin Transaction;

insert into Orders
(CustomerID,EmployeeID,
OrderDate, RequiredDate,Freight)
Values
('ALFKI',1,GETDATE(),DATEADD(DAY,7,GETDATE()),75.00)

Select SCOPE_IDENTITY()
	as rollbackorderID;

	--11079


INSERT INTO [Order Details]
	(OrderID,ProductID,
	UnitPrice,Quantity,Discount)
Select
	11079, ProductID,
	UnitPrice, 2,0
FROM Products
Where ProductID = 2;


SELECT * From Orders
Where OrderID = 11079;

SELECT * From [Order Details]
Where OrderID = 11079;

rollback

SELECT * From Orders
Where OrderID = 11079;

SELECT * From [Order Details]
Where OrderID = 11079;