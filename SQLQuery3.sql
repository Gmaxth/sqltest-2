--lab ในชั้นเรียนวันที่ 13 สิงหาคม 2569
--1.ต้องการข้อมูล รหัสใบสั่งซื้อ ยอดเงินรวมที่หักส่วนลดแล้ว จากแต่ละใบสั่งซื้อ ทั้งหมด เรียงลำดับตามยอดเงิน จากมากไปน้อย

SELECT OrderID, 
       Format(SUM(UnitPrice * Quantity * (1 - Discount)),'N2') AS ยอดเงินรวม
FROM [Order Details]
GROUP BY OrderID
ORDER BY ยอดเงินรวม DESC;

--2.ต้องการ ชื่อประเทศ ของผู้แทนจำหน่ายย (suppliers) และจำนวนผู้แทนจำหน่ายในแต่ละประเทศ
--แสดงมาเฉพราะรายการที่ผู้แทนจำหน่ายมีมากกว่า 1 ราย
SELECT Country, 
       COUNT(*) AS จำนวนผู้แทนจำหน่าย
FROM Suppliers
GROUP BY Country
HAVING COUNT(*) > 1;

--3. รหัสสินค้า จำนวนนวมทั้งหมดที่ขายได้ ราคาสูงสุดที่ขายได้ ราคาต่ำสุดที่ขายได้
-- แสดงเฉพราะสินค้าที่ขายได้รวมมากกว่า 1500 ชิ้น
SELECT ProductID,
       SUM(Quantity) AS จำนวนรวมทั้งหมดที่ขายได้, 
       MAX(UnitPrice) AS ราคาสูงสุดที่ขายได้, 
       MIN(UnitPrice) AS ราคาต่ำสุดที่ขายได้
FROM [Order Details]
GROUP BY ProductID
HAVING SUM(Quantity) > 1500;
--การ Query ข้อมูล จากหลายตาราง (Join Table)
Select * From Products
Select * From Categories

Select *
From Products inner join Categories
              on products.categoryID = Categories.categoryID


--ต้องการรหัสหมวดหมู่สินค้า รหัสสิน ค้าชื่อสินค้า ราคา โดยเรียนตามลำดับตามหมวดหมู่สินค้า และราคาสูงไปต้ำ

Select p.categoryID, CategoryName,ProductID,ProductName,UnitPrice
From Products  p inner join Categories  c
              on p.categoryID = c.categoryID
Order by CategoryID asc , UnitPrice desc

--ต้องการชื่อผู้รับผิดชอบการสั่งชื่อแต่ลละรายการ
select * from Orders
select * From Employees
--รหัสใบสั่งซื้อ วันที่สั่งซื้อ ประเทศปลายทาง ชื่อ-นาทสกุลพนักงานผู้รับผิดชอบ
Select  o.OrderID,FORMAT(o.OrderDate, 'dd/MM/yyyy') [Order Date] ,FORMAT(o.ShippedDate,'dd/MM/yyyy') [Shipped Date],o.ShipCity,
    e.LastName+SPACE(1)+e.FirstName ผู้รับผิดชอบ
from orders o inner join Employees e on o.EmployeeID = e.EmployeeID 

--ต้องการรหัสหมวดหมู่สินค้า รหัสสิน ค้าชื่อสินค้า ราคา ประเทศที่มา
--โดยเรียงลำดับตามหมวดหมู่สินค้า และราคาสูงไปต่ำ และสิงค้ามาจากประเทศ USA,Mexico,Canada
select * from Products
select * from Categories
select * from Suppliers

Select c.CategoryID, c.CategoryName , p.ProductID,p.ProductName,p.UnitPrice,s.Country
from Products p inner join Categories c on p.CategoryID = c.CategoryID
                inner join Suppliers s on p.SupplierID = s.SupplierID
where s.Country in ('USA','Mexico','Canada')
order by Country 

--แบบฝึกหัดการ Join ตาราง
--1.ต้องการ รหัสบริษัทขนส่ง, ชื่อบริษัทขนส่ง, จำนวนใบสั่งซื้อที่เกี่ยวข้อง ยอดรวมค่าขนส่ง
select * from Orders
select * from [Order Details]
select * from Suppliers
select * from Shippers
SELECT s.ShipperID รหัสบริษัทขนส่ง, s.CompanyName ชื่อบริษัทขนส่ง, COUNT(o.OrderID)จำนวนใบสั่งซื้อที่เกี่ยวข้อง, SUM(o.Freight)ยอดรวมค่าขนส่ง
FROM Shippers s INNER JOIN Orders o ON s.ShipperID = o.ShipVia
GROUP BY s.ShipperID, s.CompanyName;

    

--2. รหัสใบสั่งซื้อ วันที่สั่งซื้อ ชื่อบริษัทลูกค้า ให้แสดงเฉพาะ ลูกค้าที่อยู่ในประเทศ USA
SELECT * FROM Customers

SELECT 
    o.OrderID รหัสใบสั่งซื้อ, 
    FORMAT(o.OrderDate,'dd/MM/yy') วันที่สั่งซื้อ, 
    c.CompanyName ชื่อบริษัทลูกค้า
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA'


--3. รหัสพนักงาน ชื่อนามสกุล จำนวนใบสั่งซื้อที่เกี่ยวข้อง
SELECT * FROM Employees

SELECT e.EmployeeID รหัสพนักงาน, e.FirstName + ' ' + e.LastName ชื่อนามสกุล, 
    COUNT(o.OrderID) จำนวนใบสั่งซื้อที่เกี่ยวข้อง
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

--4.รหัสใบสั่นซื้อ วันที่สั่งซื้อ ชื่อพนักงาน ชื่อบริษัทลูกค้า ชื่อบริษัทลูกค้า ชื่อบริษัทขนส่ง
--ยอดรวมในใบสั่งซื้อ เฉพาะรายการที่ขายในปี 1997 เรียงตามลำดับ ยอดดเงินจากมากไปน้อย
SELECT * FROM Customers
SELECT * FROM Employees

SELECT o.OrderID รหัสใบสั่งซื้อ, FORMAT(o.OrderDate,'dd/MM/yyyy') วันที่สั่งซื้อ, e.FirstName + ' ' + e.LastName ชื่อพนักงาน, c.CompanyName ชื่อบริษัทลูกค้า, s.CompanyName ชื่อบริษัทขนส่ง,SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) ยอดรวมในใบสั่งซื้อ
FROM Orders o
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN Shippers s ON o.ShipVia = s.ShipperID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY 
    o.OrderID, 
    o.OrderDate, 
    e.FirstName, 
    e.LastName, 
    c.CompanyName, 
    s.CompanyName
ORDER BY ยอดรวมในใบสั่งซื้อ DESC

--ต้องการ รหัสสินค้า ชื่อสินค้า จำนวนที่ขายได้ เฉพาะสินค้าที่ขายดีที่สุด 5 อันดับแรกในปี 1997
Select * From Products
Select * From [Order Details]

Select TOP 5 p.ProductID รหัสสินค้า, p.ProductName ชื่อสินค้า, SUM(od.Quantity) จำนวนที่ขายได้
From Products p
inner join [Order Details] od on p.ProductID = od.ProductID
inner join Orders o on o.OrderID = od.OrderID
where year(OrderDate) = 1997
Group by p.ProductID, p.ProductName
order by 3 desc

--ข้อมูล ชื่อบริษัทลูกค้า และประเทศลูกค้า ที่ซื้อสินค้าที่มาจากบริษัทชื่อ Exotic Liquids

Select
    c.CompanyName AS ชื่อบริษัทลูกค้า, 
    c.Country AS ประเทศลูกค้า
From Customers c
inner join Orders o on c.CustomerID = o.CustomerID
inner join [Order Details] od on o.OrderID = od.OrderID
inner join Products p on od.ProductID = p.ProductID
inner join Suppliers s on p.SupplierID = s.SupplierID
Where s.CompanyName = 'Exotic Liquids';

--หมวดหมู่สินค้า และชื่อบริษัทที่ซื้อสินค้าหมวดหมู Seafood

Select 
    ca.CategoryName  หมวดหมู่สินค้า, 
    c.CompanyName  ชื่อบริษัทลูกค้า
From Categories ca
inner join Products p on ca.CategoryID = p.CategoryID
inner join [Order Details] od on p.ProductID = od.ProductID
inner join Orders o on od.OrderID = o.OrderID
inner join Customers c on o.CustomerID = c.CustomerID
where ca.CategoryName = 'Seafood';


    --Sub Query (Query ซ้อนกัน)
    --ชื่อพนักงานที่มีตำแหน่งเดียวกับ Nancy (nancy ตำแหน่งอะไร)
Select Firstname
from Employees 
where Title = (select Title from Employees where FirstName = 'nancy')
--ชื่อพนักงานที่อายุหน้ากว่า Robert (Robert เกิดเมื่อใด)
Select Firstname
from Employees
where BirthDate > (select BirthDate from Employees where FirstName = 'Robert')
--รหัสสินค้า ชื่อสินค้า ที่มีราคาสูงกว่าค่าเฉลี่ยทั้งหมดอขงราคาสินค้า(ค่าเฉลี่ยของราคาสินค้าคืออะไร)
Select ProductID, ProductName, Unitprice
from Products
where UnitPrice > (select avg(UnitPrice) from Products)

-- ชื่อ นามสกุล พนักงานที่ อายุมากที่สุด
Select FirstName, LastName, BirthDate
From Employees
where BirthDate = (SELECT MIN(BirthDate) FROM Employees);

-- ชื่อ นามสกุล พนักงานที่ เข้าทำงานหลังสุด
Select FirstName, LastName,FORMAT(HireDate,'dd/MM/yyyy') HireDate
From Employees
where HireDate = (SELECT MAX(HireDate) FROM Employees);


Select * From Employees





