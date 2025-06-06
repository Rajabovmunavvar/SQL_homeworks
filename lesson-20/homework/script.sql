--1)1. Find customers who purchased at least one item in March 2024 using EXISTS

CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');


SELECT DISTINCT *
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s1.CustomerName
    AND YEAR(s2.SaleDate) = 2024
    AND MONTH(s2.SaleDate) = 3
);


--2)Find the product with the highest total sales revenue using a subquery.


--Using subquery instead of simple (top) method since it is required by the task!
SELECT Product, TotalRevenue
FROM (
    SELECT 
        Product,
        SUM(Quantity * Price) AS TotalRevenue
    FROM 
        #Sales
    GROUP BY 
        Product
) AS ProductRevenues
WHERE TotalRevenue = (
    SELECT MAX(TotalRevenue)
    FROM (
        SELECT 
            SUM(Quantity * Price) AS TotalRevenue
        FROM 
            #Sales
        GROUP BY 
            Product
    ) AS MaxRevenue
);


--3)Find the second highest sale amount using a subquery

--Using subquery since it is required !!!!!
SELECT 
Product,
TOTAL_SALE
FROM(
SELECT 
Product,
SUM(Quantity*Price) AS TOTAL_SALE,
RANK() OVER (ORDER BY SUM(Quantity*Price) DESC) AS RANKED
FROM #Sales
GROUP BY Product
) AS RANKED_T
WHERE RANKED=2

--4)Find the total quantity of products sold per month using a subquery

--SUBQUERY IS NOT NEEDED AT ALL For THAT CASE
select 
DATENAME(MONTH,SaleDate) AS SALE_MONTH,
SUM(Quantity) AS TOTAL_QUANTITY
from #Sales
GROUP BY DATENAME(MONTH,SaleDate)

--5)Find customers who bought same products as another customer using EXISTS

use CLASS_20_HOMEWORK
SELECT DISTINCT S1.CustomerName,
Product
FROM #Sales S1
WHERE EXISTS (
    SELECT 1
    FROM #Sales S2
    WHERE S1.Product = S2.Product
      AND S1.CustomerName <> S2.CustomerName
);



--6)Return how many fruits does each person have in individual fruit level

create table Fruits(Name varchar(50), Fruit varchar(50))
go
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')


SELECT 
Name,
SUM(CASE WHEN Fruit='Apple' THEN 1 ELSE 0 END) AS Apple ,
SUM(CASE WHEN Fruit='Orange' THEN 1 ELSE 0 END) AS Orange ,
SUM(CASE WHEN Fruit='Banana' THEN 1 ELSE 0 END) AS Banana 
FROM Fruits
GROUP BY Name

--7)create table Family(ParentId int, ChildID int)

create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)

SELECT 
F1.ParentId,
F2.ChildID
FROM Family F1
JOIN Family AS F2
ON F2.ChildID>F1.ParentId
ORDER BY F1.ParentId

--8)Write an SQL statement given the following requirements. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas

CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);


INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);



SELECT * FROM #Orders
WHERE CustomerID IN(
SELECT DISTINCT CustomerID
FROM #Orders
WHERE DeliveryState='CA'
) AND DeliveryState='TX'

--9) Insert the names of residents if they are missing

create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')


--FIRST METHOD (In case inserting the name permanently is not needed but just to look ):
SELECT 
resid,
fullname,
CASE WHEN address NOT LIKE '%name=%' THEN
STUFF(address,CHARINDEX('age=',address)-1,0,' name='+fullname+' ')
ELSE address END AS INSERTED
FROM #residents

--SECOND METHOD (ACTUALLY  UPDATING THE DATA) :
SELECT * FROM #residents
UPDATE #residents
SET address=CASE WHEN address NOT LIKE '%name=%' THEN
STUFF(address,CHARINDEX('age=',address)-1,0,' name='+fullname+' ')
ELSE address END

--10)Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and the most expensive routes
CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

WITH ROUTE_OPTIONS AS (
SELECT 
    'Tashkent → Samarkand → Bukhoro → Khorezm' AS Route,
    R1.Cost + R2.Cost + R3.Cost AS TotalCost
FROM #Routes R1
JOIN #Routes R2 ON R1.ArrivalCity = R2.DepartureCity
JOIN #Routes R3 ON R2.ArrivalCity = R3.DepartureCity
WHERE R1.DepartureCity = 'Tashkent' AND R3.ArrivalCity = 'Khorezm'

UNION ALL

-- Path 2: Tashkent → Samarkand → Khorezm
SELECT 
    'Tashkent → Samarkand → Khorezm' AS Route,
    R1.Cost + R2.Cost AS TotalCost
FROM #Routes R1
JOIN #Routes R2 ON R1.ArrivalCity = R2.DepartureCity
WHERE R1.DepartureCity = 'Tashkent' AND R2.ArrivalCity = 'Khorezm'

UNION ALL

-- Path 3: Tashkent → Jizzakh → Samarkand → Bukhoro → Khorezm
SELECT 
    'Tashkent → Jizzakh → Samarkand → Bukhoro → Khorezm' AS Route,
    R1.Cost + R2.Cost + R3.Cost + R4.Cost AS TotalCost
FROM #Routes R1
JOIN #Routes R2 ON R1.ArrivalCity = R2.DepartureCity
JOIN #Routes R3 ON R2.ArrivalCity = R3.DepartureCity
JOIN #Routes R4 ON R3.ArrivalCity = R4.DepartureCity
WHERE R1.DepartureCity = 'Tashkent' AND R4.ArrivalCity = 'Khorezm'
),
RANKED AS (
 SELECT *,
 RANK() OVER (ORDER BY TotalCost ASC ) AS CHEAP,
  RANK() OVER (ORDER BY TotalCost DESC ) AS EXPENSIVE
 FROM ROUTE_OPTIONS

)

SELECT 
Route,
TotalCost
FROM RANKED
WHERE CHEAP=1 OR EXPENSIVE=1
ORDER BY TotalCost


--11) Rank products based on their order of insertion.

CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')


SELECT *,
ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RANKED_BY_INSERTATION_ORDER
FROM #RankingPuzzle

--12)Find employees whose sales were higher than the average sales in their department

CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);


WITH FILTERED AS (
SELECT *,
AVG(SalesAmount) OVER (PARTITION BY Department ) AS [AVG_SAL_PER_DEP]
FROM #EmployeeSales
)
SELECT 
EmployeeID,
EmployeeName,
Department,
SalesAmount
FROM FILTERED
WHERE SalesAmount>AVG_SAL_PER_DEP


--13)Find employees who had the highest sales in any given month using EXISTS

SELECT *
FROM #EmployeeSales AS E1
WHERE NOT EXISTS (
    SELECT 1
    FROM #EmployeeSales AS E2
    WHERE E1.SalesMonth = E2.SalesMonth
      AND E1.SalesYear = E2.SalesYear
      AND E2.SalesAmount > E1.SalesAmount
);

--14)Find employees who made sales in every month using NOT EXISTS
SELECT DISTINCT E1.EmployeeName
FROM #EmployeeSales AS E1
WHERE NOT EXISTS (
    SELECT 1
    FROM (
        SELECT DISTINCT SalesMonth 
        FROM #EmployeeSales
    ) AS AllMonths
    WHERE NOT EXISTS (
        SELECT 1 
        FROM #EmployeeSales AS E2
        WHERE E2.EmployeeName = E1.EmployeeName
          AND E2.SalesMonth = AllMonths.SalesMonth
    )
);

--15)Retrieve the names of products that are more expensive than the average price of all products.

CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

SELECT Name FROM Products
WHERE PRICE>(SELECT CAST(AVG(Price)AS decimal(10,2)) FROM Products)


--16)Find the products that have a stock count lower than the highest stock count.
SELECT * FROM Products
WHERE Stock<(
SELECT TOP 1 Stock FROM Products
ORDER BY Stock DESC)

--17)Get the names of products that belong to the same category as 'Laptop'.
SELECT * FROM Products
WHERE Category=(
SELECT Category FROM Products
WHERE name ='Laptop')
AND Name<>'Laptop' -- Optional: In case 'Laptop' is not wanted in the output


--18)Retrieve products whose price is greater than the lowest price in the Electronics category.
SELECT * FROM Products
WHERE Price>(
SELECT TOP 1 Price FROM Products
WHERE Category='Electronics'
ORDER BY Price ASC
)

--19)Find the products that have a higher price than the average price of their respective category.

SELECT 
*
FROM Products A
WHERE PRICE >(SELECT AVG(Price) FROM Products B WHERE A.Category=B.Category)
ORDER BY Category


--20)Find the products that have been ordered at least once.

CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');

--FIRST METHOD (USING JOIN)
SELECT DISTINCT              -- USING DISTINCT IN CASE THERE ARE DUBLICATES
P.ProductID,
P.Name FROM Products AS P 
INNER JOIN Orders AS O
ON P.ProductID=O.ProductID
ORDER BY P.ProductID
--SECOND METHOD(USING SUBQUERY)
SELECT DISTINCT               -- USING DISTINCT IN CASE THERE ARE DUBLICATES
ProductID,
NAME FROM Products
WHERE ProductID IN(
SELECT ProductID FROM Orders
)
ORDER BY ProductID


--21)Retrieve the names of products that have been ordered more than the average quantity ordered.

SELECT * FROM Products
WHERE ProductID IN (
SELECT 
ProductID
FROM Orders
WHERE Quantity> (SELECT AVG(Quantity) FROM Orders)
)

--22)Find the products that have never been ordered.

SELECT DISTINCT               -- USING DISTINCT IN CASE THERE ARE DUBLICATES
ProductID,
NAME FROM Products
WHERE ProductID NOT IN(
SELECT ProductID FROM Orders
)
ORDER BY ProductID


--23). Retrieve the product with the highest total quantity ordered.

SELECT * FROM Products
WHERE ProductID=(
SELECT TOP 1 
ProductID
FROM Orders
GROUP BY ProductID
ORDER BY SUM(Quantity) DESC
)
