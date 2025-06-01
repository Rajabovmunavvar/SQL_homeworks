
--1)Create a stored procedure that:
/*
Creates a temp table #EmployeeBonus
Inserts EmployeeID, FullName (FirstName + LastName), Department, Salary, and BonusAmount into it
(BonusAmount = Salary * BonusPercentage / 100)
Then, selects all data from the temp table.
*/

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE DepartmentBonus (
    Department NVARCHAR(50) PRIMARY KEY,
    BonusPercentage DECIMAL(5,2)
);

INSERT INTO Employees VALUES
(1, 'John', 'Doe', 'Sales', 5000),
(2, 'Jane', 'Smith', 'Sales', 5200),
(3, 'Mike', 'Brown', 'IT', 6000),
(4, 'Anna', 'Taylor', 'HR', 4500);

INSERT INTO DepartmentBonus VALUES
('Sales', 10),
('IT', 15),
('HR', 8);




CREATE PROC TEMP_TAB 
AS 
   BEGIN 
 CREATE TABLE #EmployeeBonus (
 EmployeeID INT PRIMARY KEY,
 FullName varchar(50),
 Department varchar(59),
 Salary decimal (10,2),
 BonusAmount decimal (10,2)
 );
 
 INSERT INTO  #EmployeeBonus 
 
SELECT 
EMP.EmployeeID,
CONCAT_WS(' ',EMP.FirstName,EMP.LastName) AS FullName,
EMP.Department,
EMP.Salary,
CAST(EMP.Salary/100*DEP.BonusPercentage AS decimal(10,2)) AS BonusAmount
FROM employees AS EMP
JOIN DepartmentBonus AS DEP
ON EMP.Department=DEP.Department
   SELECT * FROM #EmployeeBonus
   END


EXEC TEMP_TAB

--2)Task 2:
/*
Create a stored procedure that:

Accepts a department name and an increase percentage as parameters
Update salary of all employees in the given department by the given percentage
Returns updated employees from that department.
*/

CREATE PROC DEP_EN 
@dep_name VARCHAR(25),
@per_cent int
as
begin
UPDATE Employees
 SET Salary=Salary+Salary/100*@per_cent
 WHERE Department=@dep_name
end
BEGIN 
SELECT * FROM Employees
WHERE Department=@dep_name
END

EXEC DEP_EN 'Sales',10


--3)Perform a MERGE operation that:

/*Updates ProductName and Price if ProductID matches
Inserts new products if ProductID does not exist
Deletes products from Products_Current if they are missing in Products_New
Return the final state of Products_Current after the MERGE.
*/

CREATE TABLE Products_Current (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Products_New (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

INSERT INTO Products_Current VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 600),
(3, 'Smartphone', 800);

INSERT INTO Products_New VALUES
(2, 'Tablet Pro', 700),
(3, 'Smartphone', 850),
(4, 'Smartwatch', 300);

 
MERGE INTO Products_Current AS CURRENT_P
USING Products_New AS NEW_P
ON CURRENT_P.ProductID = NEW_P.ProductID

WHEN MATCHED AND (
    ISNULL(CURRENT_P.ProductName, '') <> ISNULL(NEW_P.ProductName, '') OR 
    ISNULL(CURRENT_P.Price, 0) <> ISNULL(NEW_P.Price, 0)
) THEN
    UPDATE SET 
        CURRENT_P.ProductName = NEW_P.ProductName,
        CURRENT_P.Price = NEW_P.Price

WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (NEW_P.ProductID, NEW_P.ProductName, NEW_P.Price)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
 
 SELECT * FROM Products_Current

--4)Tree Node

/*Each node in the tree can be one of three types:

"Leaf": if the node is a leaf node.
"Root": if the node is the root of the tree.
"Inner": If the node is neither a leaf node nor a root node.
*/

CREATE TABLE Tree (id INT, p_id INT);
TRUNCATE TABLE Tree;
INSERT INTO Tree (id, p_id) VALUES (1, NULL);
INSERT INTO Tree (id, p_id) VALUES (2, 1);
INSERT INTO Tree (id, p_id) VALUES (3, 1);
INSERT INTO Tree (id, p_id) VALUES (4, 2);
INSERT INTO Tree (id, p_id) VALUES (5, 2);

SELECT 
    id,
    CASE 
        WHEN p_id IS NULL THEN 'Root'
        WHEN id IN (SELECT DISTINCT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Inner'
        ELSE 'Leaf'
    END AS type
FROM Tree
ORDER BY id;


--5)Find the confirmation rate for each user. If a user has no confirmation requests, the rate should be 0.


CREATE TABLE   Signups (user_id INT, time_stamp DATETIME);
CREATE TABLE   Confirmations (user_id INT, time_stamp DATETIME,action VARCHAR(10) CHECK (action IN ('confirmed', 'timeout')));

TRUNCATE TABLE Signups;
INSERT INTO Signups (user_id, time_stamp) VALUES 
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');

TRUNCATE TABLE Confirmations;
INSERT INTO Confirmations (user_id, time_stamp, action) VALUES 
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');


WITH UserStats AS (
    SELECT
        S.user_id,
        SUM(CASE WHEN C.action='confirmed' THEN 1 ELSE 0 END) AS Confirmation_Count,
        SUM(CASE WHEN C.action='timeout' THEN 1 ELSE 0 END) AS Timeout_Count
    FROM Signups AS S
    LEFT JOIN Confirmations AS C
        ON S.user_id = C.user_id
    GROUP BY S.user_id
)
SELECT 
user_id ,
 CASE 
        WHEN Confirmation_Count + Timeout_Count = 0 THEN 0
        ELSE CAST(CAST(Confirmation_Count AS decimal (10,2)) / NULLIF(Confirmation_Count + Timeout_Count,0)AS DECIMAL (10,2))
    END AS confirmation_rate
FROM UserStats;

--6)Find employees with the lowest salary using subqueries

DROP TABLE IF EXISTS Employees
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

SELECT 
name,
salary
FROM (
SELECT
*,
RANK() OVER (ORDER BY salary) as salary_rank
FROM employees) AS SUB_QUERY
WHERE  salary_rank=1

--7)Create a stored procedure called GetProductSalesSummary that:
/*
Accepts a @ProductID input
Returns:
ProductName
Total Quantity Sold
Total Sales Amount (Quantity × Price)
First Sale Date
Last Sale Date
If the product has no sales, return NULL for quantity, total amount, first date, and last date, but still return the product name.*/


-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);

-- Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    SaleDate DATE
);

INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop Model A', 'Electronics', 1200),
(2, 'Laptop Model B', 'Electronics', 1500),
(3, 'Tablet Model X', 'Electronics', 600),
(4, 'Tablet Model Y', 'Electronics', 700),
(5, 'Smartphone Alpha', 'Electronics', 800),
(6, 'Smartphone Beta', 'Electronics', 850),
(7, 'Smartwatch Series 1', 'Wearables', 300),
(8, 'Smartwatch Series 2', 'Wearables', 350),
(9, 'Headphones Basic', 'Accessories', 150),
(10, 'Headphones Pro', 'Accessories', 250),
(11, 'Wireless Mouse', 'Accessories', 50),
(12, 'Wireless Keyboard', 'Accessories', 80),
(13, 'Desktop PC Standard', 'Computers', 1000),
(14, 'Desktop PC Gaming', 'Computers', 2000),
(15, 'Monitor 24 inch', 'Displays', 200),
(16, 'Monitor 27 inch', 'Displays', 300),
(17, 'Printer Basic', 'Office', 120),
(18, 'Printer Pro', 'Office', 400),
(19, 'Router Basic', 'Networking', 70),
(20, 'Router Pro', 'Networking', 150);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate) VALUES
(1, 1, 2, '2024-01-15'),
(2, 1, 1, '2024-02-10'),
(3, 1, 3, '2024-03-08'),
(4, 2, 1, '2024-01-22'),
(5, 3, 5, '2024-01-20'),
(6, 5, 2, '2024-02-18'),
(7, 5, 1, '2024-03-25'),
(8, 6, 4, '2024-04-02'),
(9, 7, 2, '2024-01-30'),
(10, 7, 1, '2024-02-25'),
(11, 7, 1, '2024-03-15'),
(12, 9, 8, '2024-01-18'),
(13, 9, 5, '2024-02-20'),
(14, 10, 3, '2024-03-22'),
(15, 11, 2, '2024-02-14'),
(16, 13, 1, '2024-03-10'),
(17, 14, 2, '2024-03-22'),
(18, 15, 5, '2024-02-01'),
(19, 15, 3, '2024-03-11'),
(20, 19, 4, '2024-04-01');


CREATE PROC GetProductSalesSummary
@INPUT_ID INT
AS 
BEGIN
WITH FILTERED_TABLE AS (
SELECT 
P.ProductID,
P.ProductName,
SUM(S.Quantity) AS TOTAL_QUANTITY,
SUM(S.Quantity)*P.Price AS TOTAL_SALES
FROM Products AS P
LEFT JOIN Sales AS S
ON P.ProductID=S.ProductID
GROUP BY 
P.ProductID,
P.ProductName,
P.Price
),
DATED AS (
SELECT 
ProductID ,
FIRST_VALUE(SaleDate) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS FIRST_SALE,
FIRST_VALUE(SaleDate) OVER (PARTITION BY ProductID ORDER BY SaleDate DESC) AS LAST_SALE

FROM Sales
)
SELECT DISTINCT
 F.*,
 D.FIRST_SALE,
 D.LAST_SALE
FROM FILTERED_TABLE AS F
LEFT JOIN  DATED AS D
ON D.ProductID=F.ProductID
WHERE F.ProductID=@INPUT_ID
END;

EXEC GetProductSalesSummary 20

