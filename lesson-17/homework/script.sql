--1)You must provide a report of all distributors and their sales by region. If a distributor did not have any sales for a region, rovide a zero-dollar value for that day. Assume there is at least one sale for each region

DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

-- Get all unique regions and distributors
WITH AllRegions AS (
    SELECT DISTINCT Region FROM #RegionSales
),
AllDistributors AS (
    SELECT DISTINCT Distributor FROM #RegionSales
),
-- Create all possible combinations
AllCombinations AS (
    SELECT r.Region, d.Distributor
    FROM AllRegions r
    CROSS JOIN AllDistributors d
)

-- Final result with sales (or 0 if no sales)
SELECT 
    c.Region,
    c.Distributor,
    ISNULL(rs.Sales, 0) AS Sales
FROM AllCombinations c
LEFT JOIN #RegionSales rs ON c.Region = rs.Region AND c.Distributor = rs.Distributor
ORDER BY 
    c.Distributor,
    c.Region;


--2)Find managers with at least five direct reports

CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

SELECT * FROM Employee

WITH EMP_MAN AS (
SELECT 
EMP.id AS EMP_ID,
EMP.name AS EMP_NAME,
(SELECT id FROM Employee WHERE EMP.managerId=Employee.id) AS MANAGER_ID,
(SELECT name FROM Employee WHERE EMP.managerId=Employee.id) AS MANAGER_NAME
FROM Employee AS EMP

)

SELECT 
MANAGER_NAME
FROM EMP_MAN
GROUP BY MANAGER_NAME
HAVING COUNT(*)>=4



--3)Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.

CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);


WITH CAT AS (
SELECT 
O.product_id,
DATENAME(YEAR,O.order_date) as year_,
DATENAME(MONTH,O.order_date) as month,
O.unit
FROM Orders AS O
WHERE YEAR(O.order_date)=2020 AND DATENAME(MONTH,O.order_date)='February'
)
, totl as (
SELECT 
product_id AS products_id,
SUM(unit) AS sum_of_u
FROM CAT
GROUP BY product_id
)

SELECT
(SELECT product_name FROM Products WHERE Products.product_id=totl.products_id) AS product_name,
*
FROM totl
WHERE sum_of_u >=100

--4) Write an SQL statement that returns the vendor from which each customer has placed the most orders

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

WITH VendorTotals AS (
SELECT
CustomerID,
Vendor,
SUM(Count) AS TOTAL
FROM Orders
GROUP BY 
CustomerID,
Vendor
),
RANKED_ AS(
  SELECT
    CustomerID,
    Vendor,
	TOTAL,
    RANK() OVER (PARTITION BY CustomerID ORDER BY	TOTAL DESC) AS VendorRank
  FROM VendorTotals
  )
 



SELECT 
  CustomerID,
    Vendor
FROM RANKED_
WHERE VendorRank = 1


--5) You will be given a number as a variable called @Check_Prime check( 91)if this number is prime then return 'This number is prime' else eturn 'This number is not prime'
DECLARE @Check_Prime INT = 91;
DECLARE @IsPrime BIT = 1; -- Assume prime until proven otherwise
DECLARE @Divisor INT = 2; -- Start checking from 2

-- Handle special cases (numbers ≤ 1 are not prime)
IF @Check_Prime <= 1
    SET @IsPrime = 0;
ELSE
BEGIN
    -- Check for divisors from 2 to square root of @Check_Prime
    WHILE @Divisor <= SQRT(@Check_Prime)
    BEGIN
        IF @Check_Prime % @Divisor = 0
        BEGIN
            SET @IsPrime = 0;
            BREAK; -- Exit loop if divisor found
        END
        
        -- Skip even numbers after checking 2
        IF @Divisor = 2
            SET @Divisor = 3;
        ELSE
            SET @Divisor = @Divisor + 2;
    END
END

-- Print the result in the requested format
IF @IsPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';

--6)Write an SQL query to return the number of locations,in which location most signals sent, and total number of signal for each device from the given table.

CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');



WITH SignalCounts AS (
    SELECT 
        Device_id,
        Locations,
        COUNT(*) AS signal_count
    FROM Device
    GROUP BY Device_id, Locations
),
DeviceStats AS (
    SELECT
        Device_id,
        COUNT(DISTINCT Locations) AS no_of_location,
        SUM(signal_count) AS total_signals,
        MAX(signal_count) AS max_signal_count
    FROM SignalCounts
    GROUP BY Device_id
)
SELECT
    ds.Device_id,
    ds.no_of_location,
    sc.Locations AS max_signal_location,
    ds.total_signals AS no_of_signals
FROM DeviceStats ds
JOIN SignalCounts sc ON ds.Device_id = sc.Device_id AND ds.max_signal_count = sc.signal_count
ORDER BY ds.Device_id;

--7) Write a SQL to find all Employees who earn more than the average salary in their corresponding department. Return EmpID, EmpName,Salary in your output
CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);


WITH AVG_SAL_PER_DEP AS (
SELECT 
DeptID,
AVG(Salary) AS AVG_SAL
FROM Employee
GROUP BY DeptID
)
Select 
*
FROM employee
WHERE (SELECT AVG_SAL FROM AVG_SAL_PER_DEP WHERE Employee.DeptID=AVG_SAL_PER_DEP.DeptID and  employee.Salary>=AVG_SAL_PER_DEP.AVG_SAL) IS NOT NULL
ORDER BY EmpID


--8)You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table of each ticket’s chosen numbers. If a ticket has some but not all the winning numbers, you win $10. If a ticket has all the winning numbers, you win $100. Calculate the total winnings for today’s drawing.

CREATE TABLE ValidNumbers (
    Number INT
);
GO
INSERT INTO ValidNumbers (Number) VALUES
(25),
(45),
(78);

CREATE TABLE Tickets (
    TicketID VARCHAR(20),
    Number INT
);
GO
INSERT INTO Tickets (TicketID, Number) VALUES
('A23423', 25),
('A23423', 45),
('A23423', 78),
('B35643', 25),
('B35643', 45),
('B35643', 98),
('C98787', 67),
('C98787', 86),
('C98787', 91);

SELECT * FROM Tickets
SELECT * FROM ValidNumbers

WITH ALLS AS (
SELECT 
TicketID,
Number,
(SELECT * FROM ValidNumbers WHERE ValidNumbers.Number=Tickets.Number) AS VALID_N
FROM Tickets
GROUP BY TicketID, Number
HAVING (SELECT * FROM ValidNumbers WHERE ValidNumbers.Number=Tickets.Number) IS NOT NULL

),
PRIZES AS (
SELECT 
ALLS.TicketID,
CASE WHEN COUNT(*)=3 THEN 100 
     WHEN COUNT(*) BETWEEN 1 AND 2 THEN 10
	 ELSE 0 END AS PRIZE
FROM ALLS
GROUP BY ALLS.TicketID
)

SELECT SUM(PRIZE) AS TOTAL_WINNING FROM PRIZES


--9)Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.


CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);




WITH user_platforms AS (
    SELECT 
        User_id,
        Spend_date,
        CASE 
            WHEN COUNT(DISTINCT Platform) > 1 THEN 'Both'
            ELSE MAX(Platform)
        END AS platform_type
    FROM Spending
    GROUP BY User_id, Spend_date
),
platform_amounts AS (
    SELECT
        s.User_id,
        s.Spend_date,
        up.platform_type,
        SUM(s.Amount) AS amount
    FROM Spending s
    JOIN user_platforms up ON s.User_id = up.User_id AND s.Spend_date = up.Spend_date
    GROUP BY s.User_id, s.Spend_date, up.platform_type
),
final_stats AS (
    SELECT
        Spend_date,
        platform_type AS Platform,
        SUM(amount) AS Total_Amount,
        COUNT(DISTINCT User_id) AS Total_users
    FROM platform_amounts
    GROUP BY Spend_date, platform_type
),
all_combinations AS (
    SELECT DISTINCT s.Spend_date, p.Platform
    FROM Spending s
    CROSS JOIN (SELECT 'Mobile' AS Platform UNION SELECT 'Desktop' UNION SELECT 'Both') p
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY ac.Spend_date, 
        CASE ac.Platform 
            WHEN 'Mobile' THEN 1 
            WHEN 'Desktop' THEN 2 
            WHEN 'Both' THEN 3 
        END) AS Row,
    ac.Spend_date,
    ac.Platform,
    COALESCE(fs.Total_Amount, 0) AS Total_Amount,
    COALESCE(fs.Total_users, 0) AS Total_users
FROM all_combinations ac
LEFT JOIN final_stats fs ON ac.Spend_date = fs.Spend_date AND ac.Platform = fs.Platform
ORDER BY ac.Spend_date, 
    CASE ac.Platform 
        WHEN 'Mobile' THEN 1 
        WHEN 'Desktop' THEN 2 
        WHEN 'Both' THEN 3 
    END;






--10)

DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

WITH  ExpandedProducts AS (
    -- Base case: Select all products
    SELECT 
        Product,
        Quantity,
        1 AS CurrentCount
    FROM Grouped
    
    UNION ALL
    
    -- Recursive case: Generate additional rows until we reach the quantity
    SELECT 
        Product,
        Quantity,
        CurrentCount + 1
    FROM ExpandedProducts
    WHERE CurrentCount < Quantity
)
SELECT 
    Product,
    1 AS Quantity
FROM ExpandedProducts
ORDER BY Product, CurrentCount;
