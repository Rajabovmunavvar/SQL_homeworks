
--1)Create a temporary table named MonthlySales to store the total quantity sold and total revenue for each product in the current month.

CREATE TABLE #MonthlySales (ProductID INT PRIMARY KEY,TotalQuantity INT,TotalRevenue DECIMAL (10,2))

INSERT INTO  #MonthlySales (ProductID ,TotalQuantity,TotalRevenue)

SELECT 
S.ProductID,
SUM(S.Quantity) AS TOTAL_QUANTITY,
SUM(S.Quantity*P.Price) AS TOTAL_RAVENUE
FROM Sales AS S
JOIN Products AS P 
ON S.ProductID=P.ProductID
AND  MONTH(S.SaleDate)=MONTH(GETDATE())
GROUP BY S.ProductID



--2)Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.

CREATE VIEW  vw_ProductSalesSummary 
AS
WITH TOTAL_TABLE AS (
SELECT 
S.ProductID,
SUM(S.Quantity) AS TOTAL_QUANTITY
FROM Sales AS S
GROUP BY S.ProductID
) 

SELECT 
Products.*,
TOTAL_TABLE.TOTAL_QUANTITY
FROM Products,TOTAL_TABLE
WHERE Products.ProductID=TOTAL_TABLE.ProductID

SELECT * FROM  vw_ProductSalesSummary 

--3)Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)

CREATE FUNCTION fn_GetTotalRevenueForProduct(@ProductID INT)
RETURNS TABLE
AS 
RETURN(
SELECT 
S.ProductID,
SUM(S.Quantity) AS TOTAL_QUANTITY,
SUM(S.Quantity*P.Price) AS TOTAL_RAVENUE
FROM Sales AS S
JOIN Products AS P 
ON S.ProductID=P.ProductID
GROUP BY S.ProductID
HAVING S.ProductID=@ProductID 
)

SELECT TOTAL_RAVENUE FROM fn_GetTotalRevenueForProduct(3)


--4)Create an function fn_GetSalesByCategory(@Category VARCHAR(50))

CREATE FUNCTION fn_GetSalesByCategory(@Category VARCHAR(50))
RETURNS TABLE
AS 
RETURN(
SELECT 
S.ProductID AS PRODUCT_ID,
P.ProductName AS PRODUCT_NAME,
SUM(S.Quantity) AS TOTAL_QUANTITY,
SUM(S.Quantity*P.Price) AS TOTAL_RAVENUE
FROM Sales AS S
JOIN Products AS P 
ON S.ProductID=P.ProductID
AND P.Category=@Category
GROUP BY S.ProductID,P.ProductName
)

SELECT 
PRODUCT_NAME,
TOTAL_QUANTITY,
TOTAL_RAVENUE
FROM fn_GetSalesByCategory('Electronics') -- here you can choose what category products you want to search

--5)You have to create a function that get one argument as input from user and the function should return 'Yes' if the input number is a prime number and 'No' otherwise. You can start it like this:


CREATE FUNCTION dbo.UC_IsPrime(@Number INT)
RETURNS VARCHAR(3)
AS 
BEGIN
    DECLARE @IsPrime BIT = 1; -- Assume prime until proven otherwise
    DECLARE @Divisor INT = 2; -- Start checking from 2

    -- Handle special cases (numbers ≤ 1 are not prime)
    IF @Number <= 1
        SET @IsPrime = 0;
    ELSE IF @Number = 2
        SET @IsPrime = 1;
    ELSE IF @Number % 2 = 0
        SET @IsPrime = 0;
    ELSE
    BEGIN
        -- Check for divisors from 3 to square root of @Number, skipping evens
        SET @Divisor = 3;
        WHILE @Divisor <= SQRT(@Number)
        BEGIN
            IF @Number % @Divisor = 0
            BEGIN
                SET @IsPrime = 0;
                BREAK; -- Exit loop if divisor found
            END
            SET @Divisor = @Divisor + 2;
        END
    END

    -- Return the result
    RETURN CASE WHEN @IsPrime = 1 THEN 'Yes' ELSE 'No' END;
END;

SELECT dbo.UC_IsPrime(11) AS IsPrime; -- check any number here;)

--6)Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:

CREATE FUNCTION fn_GetNumbersBetween(@start INT, @end INT)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
    DECLARE @number INT = @start;
    
    WHILE @number <= @end
    BEGIN
        INSERT INTO @Numbers VALUES (@number);
        SET @number = @number + 1;
    END
    
    RETURN;
END;

SELECT * FROM fn_GetNumbersBetween(12,22)


--7)Write a SQL query to return the Nth highest distinct salary from the Employee table. If there are fewer than N distinct salaries, return NULL.


CREATE OR ALTER FUNCTION dbo.GetNthHighestSalary(@N INT)
RETURNS TABLE
AS
RETURN (
    WITH DistinctSalaries AS (
        SELECT DISTINCT Salary
        FROM employees
    ),
    RankedSalaries AS (
        SELECT 
            Salary,
            DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
        FROM DistinctSalaries
    )
    SELECT 
        CASE WHEN EXISTS (SELECT 1 FROM RankedSalaries WHERE SalaryRank = @N)
             THEN (SELECT Salary FROM RankedSalaries WHERE SalaryRank = @N)
             ELSE NULL
        END AS Salary
);

SELECT * FROM dbo.GetNthHighestSalary(65)

--8)Write a SQL query to find the person who has the most friends.

CREATE TABLE RequestAccepted (
    requester_id INT,
    accepter_id INT,
    accept_date DATE
);

-- Insert the sample data
INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date) VALUES
(1, 2, '2016/06/03'),
(1, 3, '2016/06/08'),
(2, 3, '2016/06/08'),
(3, 4, '2016/06/09');

WITH AllFriendships AS (
    -- Treat both sides of the relationship as friendships
    SELECT requester_id AS person_id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS person_id FROM RequestAccepted
),
FriendCounts AS (
    SELECT 
        person_id,
        COUNT(*) AS number_of_friends
    FROM AllFriendships
    GROUP BY person_id
)
SELECT TOP (1)
    person_id,
    number_of_friends
FROM FriendCounts
ORDER BY number_of_friends DESC

--9)Create a View for Customer Order Summary.


CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);

-- Customers
INSERT INTO Customers (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');

-- Orders
INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);

CREATE VIEW  vw_CustomerOrderSummary
AS
WITH DATE_RANK_TABLE AS (
SELECT 
*,
RANK() OVER (PARTITION BY customer_id  ORDER BY order_date desc) as rank_date
FROM Orders
),
ALLS AS (
SELECT
O.customer_id,
C.name,
SUM(O.amount) total_amount,
COUNT(O.customer_id) AS total_orders
FROM Orders AS O
INNER JOIN Customers AS C
ON O.customer_id=C.customer_id
GROUP BY O.customer_id,
C.name
)

SELECT ALLS.*,
R.order_date
FROM ALLS, DATE_RANK_TABLE AS R
WHERE R.customer_id=ALLS.customer_id
AND R.rank_date=1


SELECT * FROM  vw_CustomerOrderSummary



--10)
DROP TABLE IF EXISTS Gaps;

CREATE TABLE Gaps
(
RowNumber   INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NULL
);

INSERT INTO Gaps (RowNumber, TestCase) VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,'Charlie'),(8,NULL),(9,NULL);

SELECT 
    g.RowNumber,
    (
        SELECT TOP 1 g2.TestCase 
        FROM Gaps g2 
        WHERE g2.RowNumber <= g.RowNumber 
        AND g2.TestCase IS NOT NULL 
        ORDER BY g2.RowNumber DESC
    ) AS TestCase
FROM 
    Gaps g
ORDER BY 
    g.RowNumber;
