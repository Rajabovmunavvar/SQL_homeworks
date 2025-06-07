--1) In this puzzle you have to extract the month from the dt column and then append zero single digit month if any. Please check out sample input and expected output.
CREATE TABLE Dates (
    Id INT,
    Dt DATETIME
);
INSERT INTO Dates VALUES
(1,'2018-04-06 11:06:43.020'),
(2,'2017-12-06 11:06:43.020'),
(3,'2016-01-06 11:06:43.020'),
(4,'2015-11-06 11:06:43.020'),
(5,'2014-10-06 11:06:43.020');

WITH CTE AS (
SELECT *,
CAST(MONTH(Dt)AS varchar(50)) AS MONTH_
FROM Dates
)
SELECT 
Id,
Dt,
CASE WHEN LEN(MONTH_)=1 THEN CONCAT(0,MONTH_) 
ELSE MONTH_ END AS MonthPrefixedWithZero
FROM CTE

--2)Puzzle 2: In this puzzle you have to find out the unique Ids present in the table. You also have to find out the SUM of Max values of vals columns for each Id and RId. For more details please see the sample input and expected output.

CREATE TABLE MyTabel (
    Id INT,
    rID INT,
    Vals INT
);
INSERT INTO MyTabel VALUES
(121, 9, 1), (121, 9, 8),
(122, 9, 14), (122, 9, 0), (122, 9, 1),
(123, 9, 1), (123, 9, 2), (123, 9, 10);

WITH FIL AS (
SELECT  DISTINCT
MAX(Vals) OVER (PARTITION BY id) AS MAXI
FROM MyTabel
)
SELECT
COUNT( DISTINCT Id) AS DISTINCT_IDS,
SUM(DISTINCT rID) AS R_ID,
SUM(DISTINCT MAXI)AS TotalOfMaxVals 
FROM MyTabel,FIL

--3)In this puzzle you have to get records with at least 6 characters and maximum 10 characters. Please see the sample input and expected output.

CREATE TABLE TestFixLengths (
    Id INT,
    Vals VARCHAR(100)
);
INSERT INTO TestFixLengths VALUES
(1,'11111111'), (2,'123456'), (2,'1234567'), 
(2,'1234567890'), (5,''), (6,NULL), 
(7,'123456789012345');

SELECT * FROM TestFixLengths
WHERE LEN(Vals) BETWEEN 6 AND  10

--4) In this puzzle you have to find the maximum value for each Id and then get the Item for that Id and Maximum value. Please check out sample input and expected output.

CREATE TABLE TestMaximum (
    ID INT,
    Item VARCHAR(20),
    Vals INT
);
INSERT INTO TestMaximum VALUES
(1, 'a1',15), (1, 'a2',20), (1, 'a3',90),
(2, 'q1',10), (2, 'q2',40), (2, 'q3',60), (2, 'q4',30),
(3, 'q5',20);

WITH CTE AS (
SELECT *,
MAX(Vals) OVER (PARTITION BY ID) MAX_VAL
FROM TestMaximum
)
SELECT 
ID,
Item,
Vals
FROM CTE
WHERE Vals=MAX_VAL

--5)In this puzzle you have to first find the maximum value for each Id and DetailedNumber, and then Sum the data using Id only. Please check out sample input and expected output.

CREATE TABLE SumOfMax (
    DetailedNumber INT,
    Vals INT,
    Id INT
);
INSERT INTO SumOfMax VALUES
(1,5,101), (1,4,101), (2,6,101), (2,3,101),
(3,3,102), (4,2,102), (4,3,102);

WITH DILTR AS (
SELECT DISTINCT
DetailedNumber,
Id,
MAX(Vals) OVER (PARTITION BY ID) AS max_id,
MAX(Vals) OVER (PARTITION BY DetailedNumber) AS max_det_num
FROM SumOfMax
)
SELECT 
DISTINCT Id,
SUM(max_det_num) OVER (PARTITION BY ID) AS SumofMax
FROM DILTR

--6)In this puzzle you have to find difference between a and b column between each row and if the difference is not equal to 0 then show the difference i.e. a – b otherwise 0. Now you need to replace this zero with blank.Please check the sample input and the expected output.

CREATE TABLE TheZeroPuzzle (
    Id INT,
    a INT,
    b INT
);
INSERT INTO TheZeroPuzzle VALUES
(1,10,4), (2,10,10), (3,1, 10000000), (4,15,15);

WITH CTE AS (
SELECT 
*,
CAST(a-b AS varchar(20))    AS Output
FROM TheZeroPuzzle
)
SELECT 
Id,
a,
b,
CASE WHEN Output=0 THEN REPLACE(Output,0, ' ')
ELSE Output END
FROM CTE

--7)What is the total revenue generated from all sales?
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    Product VARCHAR(50),
    Category VARCHAR(50),
    QuantitySold INT,
    UnitPrice DECIMAL(10,2),
    SaleDate DATE,
    Region VARCHAR(50),
    CustomerID INT
);

INSERT INTO Sales (Product, Category, QuantitySold, UnitPrice, SaleDate, Region, CustomerID)
VALUES
('Laptop', 'Electronics', 10, 800.00, '2024-01-01', 'North', 1),
('Smartphone', 'Electronics', 15, 500.00, '2024-01-02', 'North', 2),
('Tablet', 'Electronics', 8, 300.00, '2024-01-03', 'East', 3),
('Headphones', 'Electronics', 25, 100.00, '2024-01-04', 'West', 4),
('TV', 'Electronics', 5, 1200.00, '2024-01-05', 'South', 5),
('Refrigerator', 'Appliances', 3, 1500.00, '2024-01-06', 'South', 6),
('Microwave', 'Appliances', 7, 200.00, '2024-01-07', 'East', 7),
('Washing Machine', 'Appliances', 4, 1000.00, '2024-01-08', 'North', 8),
('Oven', 'Appliances', 6, 700.00, '2024-01-09', 'West', 9),
('Smartwatch', 'Electronics', 12, 250.00, '2024-01-10', 'East', 10),
('Vacuum Cleaner', 'Appliances', 5, 400.00, '2024-01-11', 'South', 1),
('Gaming Console', 'Electronics', 9, 450.00, '2024-01-12', 'North', 2),
('Monitor', 'Electronics', 14, 300.00, '2024-01-13', 'West', 3),
('Keyboard', 'Electronics', 20, 50.00, '2024-01-14', 'South', 4),
('Mouse', 'Electronics', 30, 25.00, '2024-01-15', 'East', 5),
('Blender', 'Appliances', 10, 150.00, '2024-01-16', 'North', 6),
('Fan', 'Appliances', 12, 75.00, '2024-01-17', 'South', 7),
('Heater', 'Appliances', 8, 120.00, '2024-01-18', 'East', 8),
('Air Conditioner', 'Appliances', 2, 2000.00, '2024-01-19', 'West', 9),
('Camera', 'Electronics', 7, 900.00, '2024-01-20', 'North', 10);

SELECT 
SUM(QuantitySold*UnitPrice ) AS Total_Ravenue
FROM Sales

--8)What is the average unit price of products?

Select AVG(UnitPrice) AS avarage_unit_price FROM Sales

--9)How many sales transactions were recorded?

SELECT COUNT(SaleID) AS total_sales_tranc FROM Sales

--10)What is the highest number of units sold in a single transaction?

SELECT MAX(QuantitySold) AS Highest_n_sold_unit FROM Sales

--11)How many products were sold in each category?

SELECT 
Category,
SUM(QuantitySold) AS Products_sold
FROM Sales
GROUP BY Category

--12)What is the total revenue for each region?

SELECT
Region,
SUM(QuantitySold*UnitPrice ) AS Total_Ravenue_Per_Region
FROM Sales
GROUP BY Region

 --13)Which product generated the highest total revenue?

 SELECT TOP 1 WITH TIES
 Product,
 SUM(QuantitySold*UnitPrice ) AS Ravenue_per_product
 FROM Sales
 GROUP BY Product
 ORDER BY Ravenue_per_product DESC

 --14)Compute the running total of revenue ordered by sale date.

 SELECT 
 SaleDate,
 SUM(QuantitySold*UnitPrice) OVER (ORDER BY SaleDate) AS Ravenue_run_total
 FROM Sales

 --15)How much does each category contribute to total sales revenue?
 SELECT
    Category,
    SUM(QuantitySold * UnitPrice) AS TotalRevenue,
    CONCAT(CAST(
        SUM(QuantitySold * UnitPrice) * 100.0 / 
        (SELECT SUM(QuantitySold * UnitPrice) FROM Sales)
     AS decimal (10,2)
    ),'%') AS RevenuePercentage
FROM Sales
GROUP BY Category;


--SINCE THERE IS NO TASK 16 IN HOMEWORK, GOT TO DO THE TASK 17

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Region VARCHAR(50),
    JoinDate DATE
);
INSERT INTO Customers (CustomerName, Region, JoinDate)
VALUES
('John Doe', 'North', '2022-03-01'),
('Jane Smith', 'West', '2023-06-15'),
('Emily Davis', 'East', '2021-11-20'),
('Michael Brown', 'South', '2023-01-10'),
('Sarah Wilson', 'North', '2022-07-25'),
('David Martinez', 'East', '2023-04-30'),
('Laura Johnson', 'West', '2022-09-14'),
('Kevin Anderson', 'South', '2021-12-05'),
('Sophia Moore', 'North', '2023-02-17'),
('Daniel Garcia', 'East', '2022-08-22');

--17)Show all sales along with the corresponding customer names

SELECT 
C.CustomerName,
S.*
FROM Sales AS S
INNER JOIN Customers AS C
ON S.CustomerID=C.CustomerID

--18)List customers who have not made any purchases

SELECT 
    C.CustomerID,
    C.CustomerName
FROM Customers C
WHERE NOT EXISTS (
    SELECT 1 
    FROM Sales S 
    WHERE S.CustomerID = C.CustomerID
);

--19)Compute total revenue generated from each customer

-- SINCE Sales table does not include Customer Name, joining Customer table is needed!
WITH CUST_SALE AS (
SELECT 
CustomerID,
SUM(QuantitySold*UnitPrice ) AS Ravenue_per_Customer
FROM Sales 
GROUP BY CustomerID
)

SELECT 
C.CustomerName,
S.*
FROM Customers AS C
INNER JOIN CUST_SALE AS S
ON C.CustomerID=S.CustomerID

--20)Find the customer who has contributed the most revenue

-- SINCE Sales table does not include Customer Name, joining Customer table is needed!

WITH CUST_SALE AS (
SELECT 
CustomerID,
SUM(QuantitySold*UnitPrice ) AS Ravenue_per_Customer
FROM Sales 
GROUP BY CustomerID
)

SELECT TOP 1 WITH TIES  -- IN CASE WE GOT CUSTOMERS WITH THE SAME SPENDINGS
C.CustomerName,
S.*
FROM Customers AS C
INNER JOIN CUST_SALE AS S
ON C.CustomerID=S.CustomerID
ORDER BY S.Ravenue_per_Customer DESC


--21)Calculate the total sales per customer 

SELECT 
    CustomerID,
    SUM(QuantitySold) AS TotalItemsPurchased,
    COUNT(*) AS NumberOfTransactions
FROM Sales
GROUP BY CustomerID;

--22)List all products that have been sold at least once


CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    CostPrice DECIMAL(10,2),
    SellingPrice DECIMAL(10,2)
);
INSERT INTO Products (ProductName, Category, CostPrice, SellingPrice)
VALUES
('Laptop', 'Electronics', 600.00, 800.00),
('Smartphone', 'Electronics', 350.00, 500.00),
('Tablet', 'Electronics', 200.00, 300.00),
('Headphones', 'Electronics', 50.00, 100.00),
('TV', 'Electronics', 900.00, 1200.00),
('Refrigerator', 'Appliances', 1100.00, 1500.00),
('Microwave', 'Appliances', 120.00, 200.00),
('Washing Machine', 'Appliances', 700.00, 1000.00),
('Oven', 'Appliances', 500.00, 700.00),
('Gaming Console', 'Electronics', 320.00, 450.00);


SELECT DISTINCT ProductName 
FROM Products P
  WHERE  EXISTS (
   SELECT 1 FROM Sales S
   WHERE P.ProductName=S.Product
  )

  --23)Find the most expensive product in the Products table

  
  SELECT TOP 1 WITH TIES
  * 
  FROM Products
  ORDER BY SellingPrice DESC

  --24)Find all products where the selling price is higher than the average selling price in their category
  
  WITH AVG_PRICE_PER_CAT AS (
  SELECT *,
  AVG(SellingPrice) OVER (PARTITION BY Category) AS avg_price
  FROM Products
  )

  SELECT 
  ProductID,
  ProductName,
  SellingPrice
  FROM AVG_PRICE_PER_CAT
  WHERE SellingPrice>avg_price

