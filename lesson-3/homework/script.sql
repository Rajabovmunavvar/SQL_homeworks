--1)
-- BULK INSERT in SQL Server is a T-SQL command used to efficiently import large volumes of data from a file into a SQL Server table.

--Purpose:

--Quickly load high volumes of data with minimal logging for better performance.

--Supports various file formats (e.g., CSV, TXT).

--Reduces overhead compared to row-by-row inserts.

--2)

--CSV (Comma-Separated Values)

--TXT (Text File / Flat File)

--XLS/XLSX (Excel Files)

--XML (Extensible Markup Language)

--3)
CREATE TABLE Products
(
ProductID INT PRIMARY KEY,
ProductName VARCHAR(50),
Price DECIMAL(10,2)
);
--4)

INSERT INTO Products (ProductID,ProductName,Price) VALUES
(1,'BALL',20),
(2,'BAT',34),
(3,'LEMON',8)

--5)

--NULL:
--Represents missing, unknown, or inapplicable data.

--A column with NULL allows empty values.

--Example:

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(15) NULL  -- Optional (can be empty)
);

INSERT INTO Employees (EmployeeID, Name) 
VALUES (1, 'John Doe');  -- PhoneNumber is NULL

--NOT NULL:
--Ensures a column must have a value (cannot be empty).

--Prevents insertion of NULL values.

--Example:

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE NOT NULL,  -- Must be provided
    CustomerID INT NOT NULL   -- Must be provided as well
);

-- Valid:
INSERT INTO Orders (OrderID, OrderDate, CustomerID) 
VALUES (101, '2024-05-20', 1);

-- Invalid (Error: OrderDate cannot be NULL):
INSERT INTO Orders (OrderID, CustomerID) 
VALUES (102, 1);

--6)

ALTER TABLE Products
ADD CONSTRAINT UNIQUE_PRODUCT_NAME UNIQUE (ProductName );


--7)

--You can add comments in SQL to explain the purpose of your query, making it easier for others (or your future self) to understand.

--8)

CREATE TABLE Categories (CategoryID INT PRIMARY KEY,CategoryName VARCHAR(50) UNIQUE)

--9)
-- IDENTITY property in SQL Server automatically generates unique, incremental numeric values for a column, typically used for primary keys.

--Key Features:

-- Auto-incrementing – Each new row gets a value that increments by a defined step.
-- No manual insertion needed – The database engine handles value assignment.
-- Prevents duplicates – Ensures uniqueness for surrogate keys.

--10)
 BULK INSERT Products
 FROM 'C:\Users\USER\Desktop\example.txt'
WITH (
FIRSTROW=1,
FIELDTERMINATOR=',',
ROWTERMINATOR='\n'
);

--11)
ALTER TABLE Products 
ADD CATEGORY_ID INT  FOREIGN KEY REFERENCES Categories(CategoryID) ;

--12)

-- PRIMARY KEY:


--Purpose: Uniquely identifies each row in a table

--Rules:

--Only one per table

--Cannot contain NULL values

--Automatically creates a clustered index (data is physically sorted by this key)


--Example:

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,  -- Unique ID for each student
    Name VARCHAR(50)
);


-- UNIQUE KEY:

--Purpose: Ensures no duplicate values in a column (but not for identifying rows)

--Rules:

--Multiple allowed per table

--Allows one NULL value (in most databases)

--Creates a non-clustered index

--Example:


--Example:

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Email VARCHAR(100) UNIQUE,  -- No duplicate emails allowed
    Phone VARCHAR(15) UNIQUE    -- No duplicate phone numbers
);


--13) 

ALTER TABLE Products
ADD CONSTRAINT CHECK_PRODUCT_PRICE
CHECK (Price>0)

--14)

ALTER TABLE Products
ADD STOCK INT NOT NULL DEFAULT 50

--15)
UPDATE Products
SET STOCK = ISNULL(STOCK, 50)
WHERE STOCK IS NULL;

--16)

--Purpose of FOREIGN KEY Constraints:

--A FOREIGN KEY (FK) enforces referential integrity between tables by ensuring that values in one table match values in another table's PRIMARY KEY or UNIQUE KEY.

--Key Benefits:
-- Prevents orphaned records (e.g., can’t have an order without a valid customer).
-- Maintains data consistency across related tables.
-- Automates validation of relationships (e.g., rejects invalid references).
 

 --17)

 CREATE TABLE Customers (
 AGE INT CHECK (AGE>=18)
 );

 --18)

 CREATE TABLE IDENTIT_CHECK(
 IDENTITY_ INT IDENTITY(100,10)
 );


 --19)

 CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    UnitPrice DECIMAL(10,2) NOT NULL,
    -- Define composite PRIMARY KEY
    PRIMARY KEY (OrderID, ProductID),
    -- Add FOREIGN KEY constraints
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)


 --20)

 --1. ISNULL (SQL Server Only):
  
  --Replaces NULL with a specified default value.
    
  -- Replace NULL with 'Unknown'-
SELECT ProductName, ISNULL(Color, 'Unknown') AS Color 
FROM Products;

-- Replace NULL discount with 0
SELECT OrderID, ISNULL(Discount, 0) AS Discount
FROM Orders;  


--Key Points:
-- Only works in SQL Server
-- Takes just 2 parameters
-- Returns the data type of the first argument


--2. COALESCE (Standard SQL)

--Returns the first non-NULL value from a list.

--Examples:
-- Use phone, then email, then 'N/A' if both NULL
SELECT 
    CustomerName,
    COALESCE(Phone, Email, 'N/A') AS ContactInfo
FROM Customers;

-- Replace NULL price with 0
SELECT ProductName, COALESCE(Price, 0) AS Price
FROM Products;


--Key Points:
-- Works in all SQL databases
-- Accepts multiple parameters
-- Returns the data type of the highest precedence


--21)

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,               -- Primary key column
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,  -- Unique constraint on email
    HireDate DATE NOT NULL,
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    Department VARCHAR(50)
);

-22)

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    -- FOREIGN KEY with CASCADE actions
    CONSTRAINT FK_OrderItems_Orders 
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
    ON DELETE CASCADE   -- Automatically deletes child records when parent is deleted
    ON UPDATE CASCADE,  -- Automatically updates child records when parent key changes
    
    CONSTRAINT FK_OrderItems_Products
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
