--1)Using Products, Suppliers table List all combinations of product names and supplier names.


SELECT p.ProductName, s.SupplierName 
FROM Products p                      -- Alias 'p' for Products table
CROSS JOIN Suppliers s               -- Alias 's' for Suppliers table and using "CROSS JOIN" to retrieve all the possible compinations.
ORDER BY  s.SupplierName             --Optional: sorts by Supplier names(A-Z),making the table more readable


--2)Using Departments, Employees table Get all combinations of departments and employees.

SELECT 
EMP.Name,
DEP.DepartmentName
FROM Employees AS EMP                 -- Alias 'EMP' for Employees table
CROSS JOIN Departments AS DEP         -- Alias 'DEP' for Departments table and using "CROSS JOIN" to retrieve all the possible compinations.
ORDER BY DEP.DepartmentName ASC       --Optional: sorts by Departments names(A-Z),making the table more readable


--3)Using Products, Suppliers table List only the combinations where the supplier actually supplies the product. Return supplier name and product name

SELECT
SUP.SupplierName,
PROD.ProductName
FROM Products AS PROD                  --Alias 'PROD' for Employees table
INNER JOIN Suppliers AS SUP            --Alias 'SUP' for Supliers table and using "INNER JOIN" to retrieve the supplier actually supplies the product
ON PROD.SupplierID=SUP.SupplierID
ORDER BY SUP.SupplierName ASC          ----Optional: sorts by Supliers names(A-Z),making the table more readable


--4)Using Orders, Customers table List customer names and their orders ID.

SELECT 
  CONCAT(CUS.FirstName, ' ', CUS.LastName) AS Name, -- Using "CONCAT" to retrieve customers' full name since we got no single "name" column but two separate columns "first name" and "last name"
OR_D.OrderID
FROM Customers AS CUS                  --Alias 'CUS' for Customers table
INNER JOIN Orders AS OR_D              --Alias 'OR_D' for Customers table
ON CUS.CustomerID=OR_D.CustomerID
ORDER BY Name                          --Optional: sorts by Customers' names(A-Z),making the table more readable


--5)Using Courses, Students table Get all combinations of students and courses.

SELECT
S.Name,
C.CourseName                 
FROM Students AS S           --Alias 'S' for Students table
CROSS JOIN Courses AS C      --Alias 'C' for Courses table and using "CROSS JOIN" to retrieve all the possible compinations.
ORDER BY S.Name ASC          --Optional: sorts by Students names(A-Z),making the table more readable


--6)Using Products, Orders table Get product names and orders where product IDs match.
SELECT 
PROD.ProductName,
OR_D.*
FROM Products AS PROD             --Alias 'PROD' for Products table
INNER JOIN Orders AS OR_D         --Alias 'OR_D' for Orders table
ON PROD.ProductID=OR_D.ProductID 
ORDER BY OR_D.OrderDate ASC         --Optional: sorts by Order dates(Oldest to newest),making the table more readable


--7)Using Departments, Employees table List employees whose DepartmentID matches the department.

SELECT 
emp.Name,
dep.DepartmentName
FROM Employees AS emp                    --Alias 'emp' for Employees table
INNER JOIN Departments AS dep            --Alias 'dep' for Departments table
ON emp.DepartmentID=dep.DepartmentID
ORDER BY dep.DepartmentName              --Optional: sorts by Departments names(A-Z),making the table more readable


--8)Using Students, Enrollments table List student names and their enrolled course IDs.

SELECT 
st.Name,
enr.CourseID
FROM Students AS st                   --Alias 'st' for Students table
INNER JOIN Enrollments AS enr         --Alias 'enr' for Enrollments table
ON st.StudentID=enr.StudentID
ORDER BY  enr.CourseID    ASC         --Optional: sorts by CourseID (lowest to highest),making the table more readable


--9)Using Payments, Orders table List all orders that have matching payments.


SELECT 
ord.OrderID,
ord.TotalAmount,
pay.Amount
FROM Orders AS ord              --Alias 'ord' for Orders table
INNER JOIN Payments AS pay      --Alias 'pay' for Payments table
ON ord.OrderID=pay.OrderID
WHERE ord.TotalAmount=pay.Amount    --Filtering to retrieve orders only with mathing payments


--10)Using Orders, Products table Show orders where product price is more than 100.

SELECT 
ord.OrderID,
prod.Price
FROM Orders AS ord                   --Alias 'ord' for Orders table
INNER JOIN Products AS prod          --Alias 'prod' for Products table
ON ord.ProductID=prod.ProductID 
WHERE PROD.Price>100                   -- Filtering to retrieve orders where product price is more than 100.
ORDER BY PROD.Price ASC             --Optional: sorts by Product price (lowest to highest),making the table more readable


--11)Using Employees, Departments table List employee names and department names where department IDs are not equal. It means: Show all mismatched employee-department combinations.

SELECT 
emp.Name,
dep.DepartmentName
FROM Employees AS emp                    --Alias 'emp' for Employees table
INNER JOIN Departments AS dep            --Alias 'dep' for Departments table
ON emp.DepartmentID<>dep.DepartmentID
ORDER BY dep.DepartmentName              --Optional: sorts by Departments names(A-Z),making the table more readable


--12)Using Orders, Products table Show orders where ordered quantity is greater than stock quantity.

SELECT 
ord.OrderID,
ord.Quantity,
prod.StockQuantity
FROM Orders AS ord               --Alias 'ord' for Orders table
INNER JOIN Products AS Prod      --Alias 'Prod' for Products table
ON ord.Quantity>prod.StockQuantity


--13)Using Customers, Sales table List customer names and product IDs where sale amount is 500 or more.

SELECT 
 CONCAT(cust.FirstName, ' ', cust.LastName) AS Name, -- Using "CONCAT" to retrieve customers' full name since we got no single "name" column but two separate columns "first name" and "last name"
 sal.ProductID,
 sal.SaleAmount
FROM Customers AS cust      --Alias 'cus' for Orders table
INNER JOIN Sales AS sal
ON sal.CustomerID=cust.CustomerID
WHERE sal.SaleAmount>=500


--14)Using Courses, Enrollments, Students table List student names and course names they’re enrolled in.

SELECT 
st.Name,
cor.CourseName
FROM Students AS st                   --Alias 'st' for Students table
INNER JOIN Enrollments AS enr         --Alias 'enr' for Enrollments table
ON st.StudentID=enr.StudentID
INNER JOIN Courses AS cor             --Alias 'cor' for Courses table
ON cor.CourseID	=enr.CourseID
ORDER BY  enr.CourseID    ASC         --Optional: sorts by CourseID (lowest to highest),making the table more readable


--15)Using Products, Suppliers table List product and supplier names where supplier name contains “Tech”.

SELECT
PROD.ProductName,
SUP.SupplierName
FROM Products AS PROD                  --Alias 'PROD' for Employees table
INNER JOIN Suppliers AS SUP            --Alias 'SUP' for Supliers table and using "INNER JOIN" to retrieve the supplier actually supplies the product
ON PROD.SupplierID=SUP.SupplierID
WHERE SUP.SupplierName LIKE '%Tech%'   --Filtering to retrieve only suppliers containing "tech" in their name
ORDER BY PROD.ProductName ASC          ----Optional: sorts by product names(A-Z),making the table more readable


--16)Using Orders, Payments table Show orders where payment amount is less than total amount.

SELECT 
ord.OrderID,
ord.TotalAmount,
pay.Amount
FROM Orders AS ord              --Alias 'ord' for Orders table
INNER JOIN Payments AS pay      --Alias 'pay' for Payments table
ON ord.OrderID=pay.OrderID
WHERE ord.TotalAmount>pay.Amount    --Filtering to retrieve orders where payment amount is less than total amount.


--17)Using Employees table List employee names with salaries greater than their manager’s salary.

  --selecting both employee names with their salaries and their managers name with their salaries to clearly see how greater emloyee salaries are than their managers'
SELECT 
EMP1.Name AS Emp_name,           
EMP1.Salary AS Emp_sal,
EMP2.Name AS Manag_name,
EMP2.Salary  AS Manag_sal
FROM Employees AS EMP1             --Alias 'EMP1' for Employee reference table
INNER JOIN Employees EMP2          --Alias 'EMP1' for their manager reference table
ON EMP1.ManagerID=EMP2.EmployeeID
WHERE EMP1.Salary>EMP2.Salary          --Filtering to retrieve employee names with salaries greater than their manager’s salary.


--18)Using Products, Categories table Show products where category is either 'Electronics' or 'Furniture'.

SELECT 
Prod.ProductName,
Categ.CategoryName
FROM Products AS Prod              --Alias 'Prod' for Products table
INNER JOIN Categories AS Categ     --Alias 'Categ' for Categories table
ON Prod.Category=Categ.CategoryID
WHERE Categ.CategoryName IN('Electronics','Furniture')  --Filtering to retrieve products where category is either 'Electronics' or 'Furniture'.
ORDER BY Categ.CategoryName  ASC                        --Optional: sorts by Category names(A-Z),separating categories and making the report easy to read


--19)Using Sales, Customers table Show all sales from customers who are from 'USA'.

SELECT 
cus.CustomerID,
cus.FirstName,
cus.LastName,
Sal.SaleAmount,
Sal.SaleDate
FROM Customers AS Cus                --Alias 'Cus' for Customers table
INNER JOIN Sales AS Sal              --Alias 'Sal' for Sales table
ON CUS.CustomerID=SAL.CustomerID      
WHERE Cus.Country LIKE 'USA'         --Filtering to retrieve all sales from customers who are from 'USA'.
ORDER BY Sal.SaleDate ASC            --Optional: sorts by sales date(oldest to newest),making the report more readable


--20)Using Orders, Customers table List orders made by customers from 'Germany' and order total > 100.

SELECT 
CONCAT(cust.FirstName, ' ', cust.LastName) AS Name,
Cust.Country,
Ord.TotalAmount
FROM Customers AS Cust                --Alias 'Cust' for Customers table
INNER JOIN Orders AS Ord              --Alias 'Ord' for Orders table
ON Cust.CustomerID=Ord.CustomerID
WHERE Cust.Country LIKE 'Germany'     --Filtering to retrieve orders made by customers from 'Germany' and order total > 100.
AND Ord.TotalAmount>100


--21)Using Employees table List all pairs of employees from different departments.


--using a self-join where e1.employee_id < e2.employee_id to avoid:
--Duplicate pairs
--Employees paired with themselves
SELECT    
 e1.Name AS employee1_name,
 e1.DepartmentID AS employee1_department,
 e2.Name AS employee2_name,
 e2.DepartmentID AS employee2_department
FROM 
    Employees AS e1  
 INNER JOIN 
    Employees AS e2 
	ON e1.EmployeeID < e2.EmployeeID
WHERE 
    e1.DepartmentID != e2.DepartmentID
ORDER BY 
 e1.EmployeeID, e2.EmployeeID;


 --22)Using Payments, Orders, Products table List payment details where the paid amount is not equal to (Quantity × Product Price).

 SELECT
 pay_m.OrderID,
 prod.Price,
 ord.Quantity,
 pay_m.Amount
 FROM Payments AS pay_m                        --Alias 'pay_m' for Payments table
 INNER JOIN Orders AS ord                      --Alias 'ord' for Orders table
 ON pay_m.OrderID=ord.OrderID                  
 INNER JOIN Products AS prod                   --Alias 'prod' for Products table
 ON prod.ProductID=ord.ProductID
 WHERE pay_m.Amount<>(ord.Quantity*prod.Price)   -- Filtering to retrieve payment details where the paid amount is not equal to (Quantity × Product Price).


 --23)Using Students, Enrollments, Courses table Find students who are not enrolled in any course.

 SELECT * FROM Students
  SELECT * FROM Enrollments
   SELECT * FROM Courses

   SELECT 
st.Name,
cor.CourseName
FROM Students AS st                   --Alias 'st' for Students table
INNER JOIN Enrollments AS enr         --Alias 'enr' for Enrollments table
ON st.StudentID=enr.StudentID
INNER JOIN Courses AS cor             --Alias 'cor' for Courses table
ON cor.CourseID	=enr.CourseID
WHERE st.StudentID  NOT IN(enr.StudentID)
ORDER BY  enr.CourseID    ASC         --Optional: sorts by CourseID (lowest to highest),making the table more readable



--24)Using Employees table List employees who are managers of someone, but their salary is less than or equal to the person they manage.

 --selecting both  managers name with their salaries and  employee names with their salaries to clearly see how less  or equal the Mangagers salaries are than/to their employees'
SELECT 
EMP2.Name AS Manag_name,
EMP2.Salary  AS Manag_sal,
EMP1.Name AS Emp_name,           
EMP1.Salary AS Emp_sal
FROM Employees AS EMP1               --Alias 'EMP1' for Employee reference table
INNER JOIN Employees EMP2            --Alias 'EMP1' for their manager reference table
ON EMP1.ManagerID=EMP2.EmployeeID
WHERE EMP2.Salary<=EMP1.Salary       --Filtering to retrieve  managers  salary which is less than or equal to the person they manage.



--25)Using Orders, Payments, Customers table List customers who have made an order, but no payment has been recorded for it.

 SELECT
 cus.CustomerID,
 cus.FirstName,
 pay_m.OrderID,
 pay_m.Amount
 FROM Payments AS pay_m                        --Alias 'pay_m' for Payments table
 INNER JOIN Orders AS ord                      --Alias 'ord' for Orders table
 ON pay_m.OrderID=ord.OrderID                  
 INNER JOIN Customers AS cus                   --Alias 'prod' for Products table
 ON cus.CustomerID=ord.CustomerID
 where ord.OrderID  NOT IN(pay_m.OrderID)      --Filtering to retrieve customers who have made an order, but no payment has been recorded for it.


