--1)


SELECT TOP (5) [EmployeeID]
      ,[FirstName]
      ,[LastName]
      ,[DepartmentName]
      ,[Salary]
      ,[HireDate]
      ,[Age]
      ,[Email]
      ,[Country]
  FROM [CLASS_4].[dbo].[Employees]


  --2)

SELECT DISTINCT ProductName  
FROM Products 


--3)
SELECT * FROM Products 
WHERE Price > 100

--4)

SELECT * FROM Customers
WHERE FirstName LIKE 'A%'

--5)
SELECT *
FROM Products
ORDER BY Price ASC;  -- ASC is optional (default behavior)

--6)

SELECT * FROM Employees
WHERE Salary>=60000 AND DepartmentName='HR'

--7)
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    ISNULL(Email, 'noemail@example.com') AS Email
FROM 
    Employees;


--8)

SELECT * FROM Products
WHERE Price BETWEEN 50 AND 100 -- Filter for the price range
    -- Alternative syntax: Price >= 50 AND Price <= 100


--9)

-- Retrieve all unique category and product name combinations
-- This ensures no duplicate category+name pairs appear in results
SELECT DISTINCT
    Category,
    ProductName
FROM 
    Products

	--OR 

	-- If even the categories has to be distinct
	SELECT 
    Category,
    STRING_AGG(ProductName, ', ') AS ProductsInCategory
FROM (
    SELECT DISTINCT Category, ProductName FROM Products
) AS DistinctProducts
GROUP BY Category
ORDER BY Category;
--10)

SELECT DISTINCT
    Category,
    ProductName
FROM 
    Products
ORDER BY  ProductName DESC;  -- Sort product names in reverse alphabetical order


--11)
SELECT TOP (10) *
FROM Products
ORDER BY PRICE DESC ; -- DESC ensures highest prices appear first

--12)
SELECT 
   
    COALESCE(FirstName, LastName, 'No Name Available') AS DisplayName
    
FROM 
    Employees


--13)

SELECT DISTINCT Category,Price
FROM Products

--OR

-- Show each category once with all its unique prices as a comma-separated list
SELECT 
    Category,
    STRING_AGG(CAST(Price AS VARCHAR), ', ') WITHIN GROUP (ORDER BY Price DESC) AS DistinctPrices
FROM (
    SELECT DISTINCT Category, Price FROM Products
) AS DistinctCombos
GROUP BY Category
ORDER BY Category;


--14)

SELECT * FROM Employees
WHERE (Age BETWEEN 30 and 40) OR (DepartmentName = 'Marketing')

--15)

SELECT * FROM  Employees
ORDER BY 
    Salary DESC         -- Sort by highest salary first
OFFSET 10 ROWS          -- Skip the first 10 rows (rows 1-10)
FETCH NEXT 10 ROWS ONLY; -- Take the next 10 rows (rows 11-20)

--16)

SELECT * FROM Products
WHERE 
 Price <= 1000     -- Products priced $1000 or less
    AND StockQuantity > 50    -- Products with more than 50 in stock
ORDER BY
 StockQuantity ASC  -- Sort by stock level (ascending = lowest stock first)


--17)
SELECT * FROM Products
WHERE
 ProductName LIKE '%E%'   -- Contains 'e' anywhere in the name
 ORDER BY 
    ProductName;            -- Sort alphabetically by product name

--18)

SELECT * FROM Employees
WHERE
DepartmentName IN ('HR', 'IT', 'Finance') --- Filter for these 3 departments
ORDER BY 
DepartmentName ;  -- Group by department - Makes the results much more readable than random ordering

--19)

-- Retrieve customers sorted by city (A-Z) and postal code (Z-A)
SELECT * FROM Customers
ORDER BY City ASC,    -- Sort cities in ascending order (A-Z)
POSTALCODE DESC        -- Sort postal codes in descending order (highest first) within each city

--20)
SELECT TOP (10)* FROM SALES
ORDER BY
SaleAmount DESC;   -- Sort from highest to lowest sales


--21)

-- Select employee data with combined full name column
SELECT 
    EmployeeID,
    -- Combine first and last names with space in between
    -- Handle NULL values using ISNULL or COALESCE
    CASE 
        WHEN FirstName IS NOT NULL AND LastName IS NOT NULL THEN FirstName + ' ' + LastName
        WHEN FirstName IS NOT NULL THEN FirstName
        WHEN LastName IS NOT NULL THEN LastName
        ELSE 'Name Not Available'
    END AS FullName,
    DepartmentName,
    Salary,
    HireDate,
    Country
FROM 
    Employees
ORDER BY 
    FullName;  -- Optional: Sort by the combined name


--22)
-- Retrieve unique category, product name, and price combinations
-- for products priced above $50
SELECT DISTINCT
    Category,
    ProductName,
    Price
FROM 
    Products
WHERE 
    Price > 50  -- Filter for products above $50
ORDER BY 
    Category ASC,      -- Primary sort by category (A-Z)
    Price DESC,        -- Secondary sort by price (highest first)
    ProductName ASC;   -- Tertiary sort by product name (A-Z)



--23)
-- Find products priced below 10% of the overall average price
SELECT *,
    (SELECT AVG(Price) FROM Products) AS OverallAvgPrice,  -- Simple average of all product prices
    Price * 100.0 / (SELECT AVG(Price) FROM Products) AS PricePercentage --200
FROM 
    Products
WHERE 
    Price < 0.1 * (SELECT AVG(Price) FROM Products)  -- 10% of average
ORDER BY 
    Price ASC;


--24)

SELECT * FROM Employees
WHERE (Age <30)                          -- Younger than 30 years old
AND (DepartmentName IN ('HR','IT'))     -- Works in either HR or IT department
ORDER BY 
    DepartmentName,                   -- Group by department - OPTIONAL
    Age;                              -- Sort by age within each department -  OPTIONAL


--25)
SELECT * FROM Customers
WHERE Email LIKE '%@gmail.com%'  -- Matches any email containing '@gmail.com'
ORDER BY 
  FirstName;      -- makeЫ  the table easy to follow - OPTIONAL

--26)
-- Retrieve employees whose salary exceeds every salary in the Sales department
SELECT 
 *
FROM 
    Employees
WHERE 
    Salary > ALL (
        -- Subquery returns all salaries from Sales department
        SELECT Salary 
        FROM Employees 
        WHERE DepartmentName = 'Sales'
    )

	--27)

-- Retrieve orders placed in the last 180 days (6 months)
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    TotalAmount,
    DATEDIFF(day, OrderDate, GETDATE()) AS DaysAgo
FROM 
    Orders
WHERE 
    OrderDate <= GETDATE()  -- Exclude future dates
    AND OrderDate >= DATEADD(day, -180, GETDATE())  -- Last 180 days
ORDER BY 
    OrderDate DESC;  -- OPTIONAL - Easy to follow

