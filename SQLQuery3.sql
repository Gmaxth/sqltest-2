--Lab ในชั้นเรียนวันที่  6 สิงหาคม 2569
--ใช้ ฐานข้อมูล Northwind เพื่อ Query ข้อมูลต่อไปนี้
--1.ต้องการ คำนำหน้า ชื่อ นามสกุล พนักงาน ที่อยู่ในเมือง London

SELECT TitleOfCourtesy, FirstName, LastName 
FROM Employees 
WHERE City = 'London';

--2.ข้อมูล รหัสสินค้า ชื่อสินค้า ราคา จำนวน ของสินค้าที่มีจำนวนน้อยกว่า 30

SELECT ProductID, ProductName, UnitPrice, UnitsInStock 
FROM Products 
WHERE UnitsInStock < 30;

--3.รหัสลูกค้า ชื่อบริษัท เบอร์โทรศัพท์ ของลูกค้าที่อยู่ในประเทศต่อไปนี้
--Sweden, Germany, France, Spain, UK

SELECT CustomerID, CompanyName, Phone 
FROM Customers 
WHERE Country IN ('Sweden', 'Germany', 'France', 'Spain', 'UK');

--4.ข้อมูลลูกค้าที่ไม่มีหมายเลขโทรสาร (Fax)

SELECT * FROM Customers
Where Fax is Null;


--5.ข้อมูลสินค้าที่มีจำนวนสินค้าต่ำกว่าจุดสั่งซื้อ และ มีจำนวนที่สั่งซื้อแล้ว

SELECT * FROM Products 
WHERE UnitsInStock < ReorderLevel 
AND UnitsOnOrder > 0;


--6.ชื่อ นามสกุล พนักงานที่เข้าทำงานในปี 1992

SELECT FirstName, LastName 
FROM Employees 
WHERE YEAR(HireDate) = 1992;

--7.ต้องการข้อมูลสินค้าที่มีราคาตั้งแต่ 20-70

SELECT * FROM Products
Where UnitPrice between 20 and 70;

--8.ข้อมูลลูกค้าที่มีชื่อบริษัทขึ้นต้นด้วย S และอยู่ประเทศ Mexico

SELECT * FROM Customers 
WHERE CompanyName LIKE '%S%' 
AND Country = 'Mexico';

--9 ข้อมูลสินค้าที่มีตำแหน่งของผู้ที่ประสานงานเป็น Manager

SELECT p.*FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.ContactTitle LIKE '%Manager%';


--Aggregate Functon (หหรือเรียกว่า GroupFuoction)
--เป้น Function ที่คำนวณจากข้อมูลหลายแถว
Select top(5) * from Products


Select Count(*) as จำนวนชนิด, Max(UnitPrice) as ราคราสูง, Min(UnitPrice) as ราคาต่ำสุด, AVG(UnitPrice) as ราคาเฉลี่ย ,Sum(unitsInStock) จำนวนรวมทั้งหมด
from Products

--ต้องการทราบว่าสินค้าแต่ละหมวดหมู่(CategoryID) มีสินค้ากี่ชนิด แต่ละชนิดมีราคาเฉลี่ย มีราคาสูงสุด และ ราคาต่ำสุด

Select CategoryID, Count(*) as จำนวนชนิด, Max(UnitPrice) as ราคราสูง, Min(UnitPrice) as ราคาต่ำสุด, AVG(UnitPrice) as ราคาเฉลี่ย ,Sum(unitsInStock) จำนวนรวมทั้งหมด
from Products
Group by CategoryID

Select * from Customers
--ต้องการทราบข้อมูลว่าในแต่ละประเทศ (Country) มีลูกค้าอยู่กี่ราย ใครทำได้แล้วเพิม City เข้าไปด้วย
Select Country, City, Count(*) จำนวนลูกค้า
from Customers
group by Country , City
order by country asc, count(*) desc
--order by Count(*) DESC
--order by 3 DESC

--ต้องการทราบข้อมูลว่าในแต่ละประเทศ (Country) แสดงเฉพาะที่มีจำนวนลูกค้า 10 รายขึ้นไป
Select Country, Count(*) จำนวนลูกค้า
from Customers
group by Country
having COUNT(*) >=10

--ต้องการทราบว่าสินค้าที่มีมูลค่าสูง (ราคาตั้งแต่ 75 ขึ้นไป) แต่ละหมวดหมู่มีจำนวนกี่ชนิด มีราคาเฉลี่ยเท่าใด
--ให้แสดงเฉพาะสินค้าที่มีราคาเฉลี่ย มากกว่า 200
select categoryID , count(*) จำนวนชนิด, Avg(UnitPrice) ราคาเฉลี่ย

from Products
where UnitPrice >= 75
group by CategoryID
having avg(UnitPrice) > 200

--จากตราง [Order Details] ให้รวบรวมว่าในแต่ละการสั่งซื้อ มียอดเงินรวมเท่าใด
Select OrderID, UnitPrice,Quantity,Discount,
	UnitPrice * Quantity ราคาเต็ม ,
	UnitPrice * Quantity * Discount as ส่วนลด ,
	(Unitprice * Quantity) - (Unitprice * Quantity * Discount) ราคาหักส่วนลดแล้ว,
	(Unitprice * Quantity) - ( 1 * Discount) ราคาหักส่วนลดสูตรย่อ
 from [Order Details]

Select OrderID, count(*) จำนวนรายการ,
		Sum(Unitprice * Quantity - ( 1 * Discount)) as ยอดเงินรวม
from [Order Details]
group by OrderID
having sum(Unitprice * Quantity - ( 1 * Discount)) > 2000
order by 3 desc

