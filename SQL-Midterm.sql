--1 列出各產品的供應商名稱
SELECT
	p.ProductID,
	p.ProductName,
	s.CompanyName
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID

--2 列出各產品的種類名稱
SELECT
	p.ProductID,
	p.ProductName,
	c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID

--3 列出各訂單的顧客名字
SELECT
	o.OrderID,
	c.CompanyName
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.OrderID

--4 列出各訂單的所負責的物流商名字以及員工名字
SELECT
	o.OrderID,
	s.CompanyName,
	e.FirstName + ' ' + e.LastName AS Name
FROM Orders o
INNER JOIN Shippers s ON o.ShipVia = s.ShipperID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID

--5 列出1998年的訂單
SELECT
	o.OrderID,
	o.OrderDate
FROM Orders o
WHERE o.OrderDate BETWEEN '1998-01-01' AND '1999-01-01'

--6 各產品，UnitsInStock < UnitsOnOrder 顯示'供不應求'，否則顯示'正常'
SELECT
	ProductID,
	UnitsInStock,
	UnitsOnOrder,
	IIF(UnitsInStock < UnitsOnOrder, '供不應求', '正常')
FROM Products

--7 取得訂單日期最新的9筆訂單
SELECT TOP 9
	o.OrderID,
	o.OrderDate
FROM Orders o
ORDER BY o.OrderDate DESC

--8 產品單價最便宜的第4~8名
SELECT
	P.ProductID,
	p.UnitPrice
FROM Products p
ORDER BY p.UnitPrice
OFFSET 3 ROWS FETCH NEXT 5 ROWS ONLY

--9 列出每種類別中最高單價的商品
SELECT
	cu.CategoryID,
	MAX(cu.UnitPrice) AS [Max UnitPrice]
FROM (
	SELECT
		c.CategoryID,
		p.ProductID,
		p.UnitPrice
	FROM Products p
	INNER JOIN Categories c ON p.CategoryID = c.CategoryID
	GROUP BY c.CategoryID, p.ProductID, p.UnitPrice
) AS cu
GROUP BY cu.CategoryID

--10 列出每個訂單的總金額
SELECT
	OrderID,
	SUM(Quantity * UnitPrice * (1 - Discount)) AS Total
FROM [Order Details]
GROUP BY OrderID

--11 列出每個物流商送過的訂單筆數
SELECT
	ShipVia,
	COUNT (OrderID)
FROM Orders
GROUP BY ShipVia

--12 列出被下訂次數小於9次的產品
SELECT
	od.ProductID,
	COUNT(o.OrderID) AS [number of times]
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY od.ProductID
HAVING COUNT(o.OrderID) < 9

-- (13、14、15請一起寫)
--13 新增物流商(Shippers)：
-- 公司名稱: 青杉人才，電話: (02)66057606
-- 公司名稱: 青群科技，電話: (02)14055374
INSERT INTO Shippers
VALUES ('青杉人才', '(02)66057606'),('青群科技', '(02)14055374');

--14 方才新增的兩筆資料，電話都改成(02)66057606，公司名稱結尾加'有限公司'
UPDATE Shippers
SET
    CompanyName = CompanyName + '有限公司',
    Phone = '02-66057606'
WHERE CompanyName = '青杉人才'
OR CompanyName = '青群科技'

--15 刪除剛才兩筆資料
DELETE FROM Shippers
WHERE CompanyName LIKE '%有限公司'
