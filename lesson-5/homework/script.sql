--1)

SELECT 
    ProductName AS Name  -- Explicitly using AS for clarity
FROM Products;
   

--2)

SELECT *
FROM Customers AS Client -- Explicitly using AS for clarity
WHERE Client.FirstName LIKE 'J%' -- This is just to check if ranaming the table worked or not 


--3)

SELECT ProductName
FROM Products

UNION 

SELECT ProductName
FROM Products_Discounted


--4)

SELECT *
  FROM Products
INTERSECT
SELECT *
  FROM Products_Discounted


--5)

SELECT DISTINCT 
CONCAT(FirstName, ' ', LastName) AS CustomerName, --Since we  have separate FirstName and LastName columns instead of a single CustomerName column, that is  to combine them
Country
FROM Customers;


--6)

SELECT *,
CASE 
    WHEN Price > 1000 THEN 'HIGH'
	ELSE 'LOW' END AS 'PRICE_STATUS'    --OPTIONAL: Makes results clearer and usable in later queries.

FROM Products
ORDER BY Price DESC    --OPTIONAL : Makes the table easy to follow


--7)

SELECT *,
IIF(StockQuantity > 100 ,'YES','NO') AS 'Stock_contdition'  --OPTIONAL: Makes results clearer and usable in later queries.
FROM Products_Discounted
ORDER BY StockQuantity ;    --OPTIONAL : Makes the table easy to follow


--8)

SELECT ProductName, 'In Stock' AS Source         --OPTIONAL: This will show each product name along with its source table.
FROM Products
UNION
SELECT ProductName,  'Out of Stock' AS Source    --OPTIONAL: This will show each product name along with its source table.
FROM OutOfStock
ORDER BY Source ;      --OPTIONAL : Makes the table easy to follow


--9)

-- Returns rows in Products that are not in Products_Discounted
SELECT * FROM Products
EXCEPT
SELECT * FROM Products_Discounted;


--10)

 SELECT *,
 IIF(Price>1000,'Expensive','Affordable') AS 'PRICE_RANGE' --OPTIONAL: Makes results clearer and usable in later queries.
 FROM Products
 ORDER BY Price ; --OPTIONAL : Makes the table easy to follow


--11)

SELECT *
FROM Employees
WHERE Age < 25 
OR  Salary > 60000 ;


--12)

Update Employees
SET Salary = Salary * 1.10     -- 10% salary increase
WHERE DepartmentName LIKE 'HR' -- Applies to HR department
OR EmployeeID=5;                -- OR employee with ID 5  


--13)

-- PURPOSE: Find products that exist in BOTH Products and Products_Discounted tables
-- METHOD: Using INTERSECT operator to return only matching rows
SELECT *
FROM Products

INTERSECT

SELECT * 
FROM Products_Discounted


--14)

SELECT *, 
CASE WHEN  SaleAmount>500 THEN 'Top Tier'
     WHEN  SaleAmount BETWEEN 200 AND 500 THEN  'Mid Tier'
	 ELSE 'Low Tier' END AS SaleTier
FROM Sales
ORDER BY SaleAmount DESC  --OPTIONAL : Makes the table easy to follow


--15)
SELECT CustomerID 
FROM Orders

EXCEPT

SELECT CustomerID 
FROM Invoices;


--16)

SELECT CustomerID,
Quantity,
CASE WHEN Quantity=1 THEN '3%'
     WHEN Quantity BETWEEN 1 AND 3 THEN '5%'
	 ELSE '7%' END AS discount_percentage
FROM Orders
ORDER BY Quantity --OPTIONAL : Makes the table easy to follow
