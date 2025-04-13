--1)
create table Employees (EmpID INT,NAME VARCHAR(50),SALARY DECIMAL(10,2));

--2)
insert into Employees values
(1,'OBIDJON',2000);

insert into Employees values
(2,'GULOMBEK',3000),
(3,'ABROR',6000);


--3)
UPDATE Employees
SET SALARY=110000
WHERE EmpID=1;


--4) and 5)
DELETE FROM Employees
WHERE EmpID=2;
 --

TRUNCATE TABLE Employees

DROP TABLE Employees;

--DELETE = "Remove some/all data"

--TRUNCATE = "Reset empty table"

--DROP = "Delete table completely"

--(DELETE is precise, TRUNCATE is fast cleanup, DROP is permanent removal.)

create table Employees (EmpID INT,NAME VARCHAR(50),SALARY DECIMAL(10,2));


--6)
ALTER TABLE Employees
ALTER COLUMN NAME VARCHAR(100)

--7)
ALTER TABLE  Employees
ADD  DEPARTMENT VARCHAR(50)

--8)
ALTER TABLE Employees
ALTER COLUMN SALARY FLOAT


--9)

CREATE TABLE Departments (DepartmentID INT PRIMARY KEY,Departmentname Varchar(50));

--10)

Truncate TABLE Employees



CREATE TABLE SAMPLE (EMP_ID INT,EMP_NAME VARCHAR(50),DepartmentID INT,Departmentname Varchar(50), SALARY  MONEY);

INSERT INTO SAMPLE VALUES
(1,'ABUZAR',1,'MANAGEMENT',6000),
(2,'ABUJON',2,'MANAGEMENT',5100),
(3,'JONMEK',23,'MARKETING',4800),
(4,'XUSHNYD',21,'MARKETING',5100),
(5,'XUSHNYD',31,'SALES',5700),
(6,'RAMAL',34,'IT',7000),
(7,'MANSUR',39,'IT',4000);

--11)

INSERT INTO Departments (DepartmentID, Departmentname)
SELECT DepartmentID, Departmentname
FROM SAMPLE


--12) 
UPDATE SAMPLE
SET Departmentname = 'Management'
WHERE Salary > 5000;

--13) 

TRUNCATE TABLE Employees
--14)
ALTER TABLE Employees
DROP COLUMN DEPARTMENT

--15)
EXEC sp_rename 'Employees', 'StaffMembers';

--16) 
DROP TABLE Departments

--17)
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2),
	);

--18)

ALTER TABLE Products
ADD CONSTRAINT PricePos
CHECK (Price > 0);

--19)
ALTER TABLE Products
ADD StockQuantity INT NOT NULL DEFAULT 50;

--20)
EXEC sp_rename 'dbo.Products.Category', 'Product_Category', 'COLUMN';
SELECT * FROM Products
--21)
INSERT INTO Products VALUES
(71,'APPLE','FRUIT',1.60,60),
(11,'BANANA','FRUIT',2.1,60 ),
(88,'DOUGH','FOOF',1.60,60),
(12,'COLA','DRINK',2.1,60 )


--22)
SELECT *
INTO Products_Backup
FROM Products;

--23)
EXEC sp_rename 'Products', 'Inventory';

--24)
ALTER TABLE Inventory
DROP CONSTRAINT CHK_PricePositive ;

ALTER TABLE Inventory
ALTER COLUMN Price float;

--25)
ALTER TABLE Inventory
ADD ProductCode INT IDENTITY(1000, 5);
