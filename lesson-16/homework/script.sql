
--1)Create a numbers table using a recursive query from 1 to 1000.

WITH  RECURSIV AS (
SELECT 1 AS n
UNION ALL
SELECT n+1
from RECURSIV
WHERE n<=999

)
SELECT * FROM RECURSIV
OPTION (MAXRECURSION 1000); 



--2)Write a query to find the total sales per employee using a derived table.(Sales, Employees)

SELECT EMP.*,TOT.TOTAL_SAL FROM Employees EMP, (
SELECT 
EmployeeID,
SUM(SalesAmount) AS TOTAL_SAL
FROM Sales
GROUP BY EmployeeID) AS TOT
WHERE EMP.EmployeeID=TOT.EmployeeID

--3)Create a CTE to find the average salary of employees.(Employees)

WITH CTE AS (
SELECT AVG(salary) AS AVG_SAL
FROM Employees
)
SELECT 
E.*,
(SELECT AVG_SAL FROM CTE) AS AVARAGE_SALARY_OF_EMP
FROM Employees E


--4)Write a query using a derived table to find the highest sales for each product.(Sales, Products)

SELECT DISTINCT S.ProductID,
P.ProductName,
P.Price,
S.EmployeeID,
S.SalesID,
S.SaleDate,
S.SalesAmount,
DERIVED.MAX_SALE
FROM 
SALES AS S,
Products AS P,
(
SELECT DISTINCT
ProductID,
MAX(SalesAmount) AS MAX_SALE
FROM Sales
GROUP BY ProductID
) AS DERIVED  
WHERE S.ProductID=DERIVED.ProductID AND S.SalesAmount=DERIVED.MAX_SALE AND P.ProductID=S.ProductID

--5)Beginning at 1, write a statement to double the number for each record, the max value you get should be less than 1000000.
WITH MILLION AS (
   SELECT 1 AS N
UNION ALL 
SELECT N*2
FROM MILLION
WHERE N*2<=1000000 )
SELECT * FROM MILLION

--6)Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)

WITH CTE AS (
SELECT 
EmployeeID,
COUNT(*) AS COUNT_OF_SALES
FROM Sales
GROUP BY EmployeeID
)

SELECT 
FirstName,
LastName,
(SELECT COUNT_OF_SALES FROM CTE WHERE CTE.EmployeeID=EMP.EmployeeID) AS TIMESOFSALES
FROM Employees AS EMP
	

--7)Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)

;WITH CTE AS (
SELECT 
*
FROM Products 

)

SELECT 
(SELECT ProductNAME FROM CTE WHERE CTE.ProductID=Sales.ProductID) AS ProductName,
Sales.*
FROM Sales
WHERE SalesAmount>500

--8)Create a CTE to find employees with salaries above the average salary.(Employees)

;WITH AVARAGE AS ( 
SELECT 
AVG(Salary) AVF_SAL
FROM Employees
)
SELECT * FROM Employees
WHERE Salary>(SELECT AVF_SAL FROM AVARAGE)

--MEDIUM TASKS:

--1)Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)

WITH CTE AS (
SELECT 
EmployeeID,
COUNT(*) AS COUNT_OF_SALES
FROM Sales
GROUP BY EmployeeID
)

SELECT TOP(5) WITH TIES -- IN CASE, WE HAVE OTHER EMPLOYEES THAT CAN QUALIFY TO TOP5 
FirstName,
LastName,
(SELECT COUNT_OF_SALES FROM CTE WHERE CTE.EmployeeID=EMP.EmployeeID) ORD_NUM
FROM Employees AS EMP
ORDER BY ORD_NUM DESC


--2)Write a query using a derived table to find the sales per product category.(Sales, Products)

SELECT 
    p.CategoryID,
    SUM(s.SalesAmount) AS TotalSalesAmount,
    COUNT(s.SalesID) AS NumberOfSales
FROM 
    Sales s,
    (SELECT ProductID, CategoryID FROM Products) p  -- Derived table
WHERE 
    s.ProductID = p.ProductID  -- This replaces the JOIN
GROUP BY 
    p.CategoryID
ORDER BY 
    TotalSalesAmount DESC;


--3)Write a script to return the factorial of each value next to it.(Numbers1)


-- Using a recursive CTE to calculate factorials
-- Create a table variable to store results
DECLARE @Results TABLE (
    Number INT,
    Factorial DECIMAL(38,0)
);

-- Calculate factorial for each number
DECLARE @current INT;
DECLARE @max INT = (SELECT MAX(Number) FROM Numbers1);
DECLARE @cursor CURSOR;

SET @cursor = CURSOR FOR SELECT Number FROM Numbers1;
OPEN @cursor;
FETCH NEXT FROM @cursor INTO @current;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @fact DECIMAL(38,0) = 1;
    DECLARE @i INT = 1;
    
    WHILE @i <= @current
    BEGIN
        SET @fact = @fact * @i;
        SET @i = @i + 1;
    END
    
    INSERT INTO @Results VALUES (@current, @fact);
    FETCH NEXT FROM @cursor INTO @current;
END

CLOSE @cursor;
DEALLOCATE @cursor;

-- Return results
SELECT Number, Factorial FROM @Results ORDER BY Number;

--4)This script uses recursion to split a string into rows of substrings for each character in the string.(Example)



WITH StringCharacters AS (
    -- Base case: Get the first character of each string
    SELECT 
        ID,
        STRING,
        1 AS Position,
        SUBSTRING(STRING, 1, 1) AS Character
    FROM Example
    
    UNION ALL
    
    -- Recursive case: Get next character in each string
    SELECT 
        sc.ID,
        sc.STRING,
        sc.Position + 1,
        SUBSTRING(sc.STRING, sc.Position + 1, 1) AS Character
    FROM StringCharacters sc
    WHERE sc.Position < LEN(sc.STRING)  -- Stop when we reach string length
)
SELECT 
    ID,
    STRING,
    Position,
    Character
FROM 
    StringCharacters
ORDER BY 
    ID, Position;


--5)Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)

WITH GROUPMON AS (
SELECT
MONTH(SaleDate) AS MONTH,
SUM(SalesAmount) AS TOTAL
from Sales
GROUP BY MONTH(SaleDate)
)

SELECT 
G1.MONTH AS CURRENT_MONTH,
G1.TOTAL AS CURRENT_MONTH_TOTAL_SALE,

G1.TOTAL-G2.TOTAL AS DIFFENCE_TO_PREVIOUS

FROM GROUPMON AS G1,(SELECT * FROM GROUPMON  ) AS G2
WHERE  G1.MONTH= G2.MONTH+1                  
ORDER BY G1.MONTH

--6)Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)
WITH EACHQT AS (
SELECT 
S.EmployeeID,
DATEPART(QUARTER,S.SaleDate) AS EACH_Q,
SUM(S.SalesAmount) AS SALES
FROM Sales AS S, Employees AS EMP
WHERE S.EmployeeID=EMP.EmployeeID
GROUP BY S.EmployeeID,DATEPART(QUARTER,S.SaleDate)
)

SELECT
E.FirstName,
E.LastName,
T.*

FROM Employees AS E	,EACHQT AS T
WHERE T.EmployeeID=E.EmployeeID 
AND T.SALES>45000
ORDER BY EmployeeID

--DIFFICULT TASK:

--1)This script uses recursion to calculate Fibonacci numbers

WITH  Fib(n, a, b) AS (
    SELECT 1, 0, 1
    UNION ALL
    SELECT n + 1, b, a + b
    FROM Fib
    WHERE n < 20
)
SELECT n,a as fibbonaci  FROM Fib;


--2)Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)

SELECT * FROM FindSameCharacters
WHERE LEN(REPLACE(Vals,SUBSTRING(Vals,1,1),''))=0
AND LEN(Vals)>1

--3)Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345)

DECLARE @n INT = 5; -- Change this to your desired maximum number

WITH NumberSequence AS (
    -- Base case: Start with 1
    SELECT 
        1 AS current_number,
        CAST('1' AS VARCHAR(MAX)) AS sequence
    
    UNION ALL
    
    -- Recursive case: Append next number to sequence
    SELECT 
        current_number + 1,
        CAST(sequence + CAST(current_number + 1 AS VARCHAR(10)) AS VARCHAR(MAX))
    FROM NumberSequence
    WHERE current_number < @n
)
SELECT 
    current_number AS n,
    sequence
FROM 
    NumberSequence
ORDER BY 
    current_number;


	--4)Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)
	;WITH EmployeeSalesAmount AS (
    SELECT 
        EmployeeID,
        SUM(SalesAmount) AS TotalSalesAmount
    FROM 
        Sales
    WHERE 
        SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY 
        EmployeeID
)

SELECT TOP(5) -- FINDING THE EMPLOYEES WHO MADE THE MOST SALES
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    esa.TotalSalesAmount
FROM 
    Employees e
JOIN 
    EmployeeSalesAmount esa ON e.EmployeeID = esa.EmployeeID
ORDER BY 
    esa.TotalSalesAmount DESC;


--5)Write a T-SQL query to remove the duplicate integer values present in the string column. Additionally, remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)

-- Step 1: Main query with Tally Table to split digits
WITH Parsed AS (
    SELECT 
        PawanName,
        LEFT(Pawan_slug_name, CHARINDEX('-', Pawan_slug_name)) AS NamePart,
        RIGHT(Pawan_slug_name, LEN(Pawan_slug_name) - CHARINDEX('-', Pawan_slug_name)) AS NumberPart
    FROM RemoveDuplicateIntsFromNames
    WHERE CHARINDEX('-', Pawan_slug_name) > 0
),
Tally AS (
    SELECT TOP (100) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
),
SplitDigits AS (
    SELECT 
        p.PawanName,
        p.NamePart,
        SUBSTRING(p.NumberPart, t.n, 1) AS Digit
    FROM Parsed p
    JOIN Tally t ON t.n <= LEN(p.NumberPart)
),
UniqueDigits AS (
    SELECT DISTINCT 
        PawanName, NamePart, Digit
    FROM SplitDigits
),
Rebuilt AS (
    SELECT 
        u.PawanName,
        u.NamePart,
        (
            SELECT Digit
            FROM UniqueDigits d
            WHERE d.PawanName = u.PawanName
            ORDER BY Digit
            FOR XML PATH(''), TYPE
        ).value('.', 'VARCHAR(MAX)') AS CleanedNumber
    FROM UniqueDigits u
    GROUP BY u.PawanName, u.NamePart
)
SELECT 
    r.PawanName,
    CASE 
        WHEN LEN(CleanedNumber) <= 1 THEN LEFT(NamePart, LEN(NamePart) - 1) -- remove the dash
        ELSE NamePart + CleanedNumber
    END AS Final_slug_name
FROM Rebuilt r

-- Union any rows without '-' to include them as-is (optional if needed)
UNION

SELECT 
    PawanName,
    Pawan_slug_name
FROM RemoveDuplicateIntsFromNames
WHERE CHARINDEX('-', Pawan_slug_name) = 0

ORDER BY PawanName;
