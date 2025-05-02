
--1)Using the Employees and Departments tables, write a query to return the names and salaries of employees whose salary is greater than 50000, along with their department names.
-- Expected Columns: EmployeeName, Salary, DepartmentName


  SELECT 
  emp.Name,
  emp.Salary,
  dep.DepartmentName
  FROM Employees AS emp                    --Alias 'emp' for  Employees table
  INNER JOIN Departments AS dep            --Alias 'dep' for  Departments table
  ON emp.DepartmentID=dep.DepartmentID
  WHERE emp.Salary>50000                    --Filtering to retrieve employees whose salary is greater than 50000
  ORDER BY Dep.DepartmentName                --Optional: sorts by Department names(A-Z),making the report easier to read


--2)Using the Customers and Orders tables, write a query to display customer names and order dates for orders placed in the year 2023.
--Expected Columns: FirstName, LastName, OrderDate

SELECT 
cust.FirstName,
cust.LastName,
ord.OrderDate
FROM Customers AS cust                   --Alias 'cust' for  Customers table 
INNER JOIN Orders AS ord                 --Alias 'ord' for  Orders table
ON cust.CustomerID=ord.CustomerID     
WHERE YEAR(ord.OrderDate)=2023           --Filtering to retrieve order dates for orders placed in the year 2023.
ORDER BY ord.OrderDate                   --Optional: sorts by order dated(oldest to newest),making the report easier to read


--3)Using the Employees and Departments tables, write a query to show all employees along with their department names. Include employees who do not belong to any department.
--Expected Columns: EmployeeName, DepartmentName

SELECT
emp.Name,
dep.DepartmentName
FROM Employees AS emp                   --Alias 'emp' for  Employees table
LEFT JOIN Departments AS dep            --Alias 'dep' for  Departments table
ON emp.DepartmentID=dep.DepartmentID     --using "LEFT JOIN" to Include employees who do not belong to any department.
ORDER BY Dep.DepartmentName             --Optional: sorts by Department names(A-Z),making the report easier to read and spot the ones who dont belong to any department
 

--4)Using the Products and Suppliers tables, write a query to list all suppliers and the products they supply. Show suppliers even if they don’t supply any product.
--Expected Columns: SupplierName, ProductName

SELECT 
supp.SupplierName,
prod.ProductName
FROM Suppliers AS supp                 --Alias 'supp' for  Suppliers table
LEFT JOIN Products AS prod             --Alias 'prod' for  Products table
ON supp.SupplierID=prod.SupplierID     --using "LEFT JOIN" to retrieve suppliers even if they don’t supply any product.
ORDER BY prod.ProductName ASC          --Optional: using "ORDER BY prod.ProductName ASC" just to make spot suppliers that don’t supply any product easily


--5)Using the Orders and Payments tables, write a query to return all orders and their corresponding payments. Include orders without payments and payments not linked to any order.
--Expected Columns: OrderID, OrderDate, PaymentDate, Amount

SELECT 
ord.OrderID,
ord.OrderDate,
paym.PaymentDate,
paym.Amount
FROM Orders AS ord            --Alias 'ord' for  Orders table
FULL JOIN Payments AS paym    --Alias 'paym' for Payments table
ON ord.OrderID=paym.OrderID   --Using "FULL JOIN" to retrieve all orders and their corresponding payments, Including orders without payments and payments not linked to any order.


--6)Using the Employees table, write a query to show each employee's name along with the name of their manager.
--Expected Columns: EmployeeName, ManagerName

SELECT * FROM Employees

SELECT 
emp.Name,
man.Name as manager_name              --using allies to make employee name column and manager name collumn to differ from each other
FROM Employees AS emp                 --Alias 'emp' for Employees table
LEFT JOIN Employees AS man            --Alias 'man' for Employees table refencing managers    
ON emp.ManagerID=man.EmployeeID       --Using "LEFT JOIN" INSTED OF "INNER JOIN" just in case we have employees without a managers 


--7)Using the Students, Courses, and Enrollments tables, write a query to list the names of students who are enrolled in the course named 'Math 101'.
--Expected Columns: StudentName, CourseName


SELECT 
st.Name,
cour.CourseName
FROM Students AS st                        --Alias 'st' for Students table
INNER JOIN Enrollments AS enr              --Alias 'emp' for Enrollments table
ON st.StudentID=enr.StudentID          
INNER JOIN Courses AS cour                 --Alias 'cour' for Courses table
ON Enr.CourseID=cour.CourseID
WHERE cour.CourseName LIKE 'Math 101'      --Filtering to retrieve students who are enrolled in the course named 'Math 101'


--8)Using the Customers and Orders tables, write a query to find customers who have placed an order with more than 3 items. Return their name and the quantity they ordered.
--Expected Columns: FirstName, LastName, Quantity


SELECT 
cus.FirstName,
cus.LastName,
ord.Quantity
FROM Customers AS cus               --Alias 'cus' for Customers table
INNER JOIN Orders AS ord            --Alias 'ord' for Orders table
ON cus.CustomerID=ord.CustomerID
WHERE ord.Quantity>3                ----Filtering to retrieve customers who have placed an order with more than 3 items


--9)Using the Employees and Departments tables, write a query to list employees working in the 'Human Resources' department.
--Expected Columns: EmployeeName, DepartmentName


SELECT
emp.Name,
dep.DepartmentName
FROM Employees AS emp                       --Alias 'emp' for  Employees table
INNER JOIN Departments AS dep               --Alias 'dep' for  Departments table
ON emp.DepartmentID=dep.DepartmentID
WHERE dep.DepartmentName LIKE 'Human Resources'     --Filtering to retrieve employees working in the 'Human Resources' department.


--10)Using the Employees and Departments tables, write a query to return department names that have more than 5 employees.
--Expected Columns: DepartmentName, EmployeeCount


SELECT DISTINCT
dep.DepartmentName,
COUNT(emp.EmployeeID)  AS EmployeeCount
FROM Departments AS dep                       --Alias 'dep' for  Departments table
INNER JOIN Employees AS emp                   --Alias 'emp' for  Employees table
ON emp.DepartmentID=dep.DepartmentID
GROUP BY dep.DepartmentName
HAVING COUNT(emp.EmployeeID)>5                --Filtering to retrieve department names that have more than 5 employees.


--11)Using the Products and Sales tables, write a query to find products that have never been sold.
--Expected Columns: ProductID, ProductName

SELECT 
prod.ProductID,
prod.ProductName
FROM Products AS prod                 --Alias 'prod' for  Products table
LEFT JOIN Sales AS sal                --Alias 'sal' for  Sales table
ON prod.ProductID=sal.ProductID
WHERE sal.SaleID IS NULL              --Filtering to retrieve products that have never been sold.


--12)Using the Customers and Orders tables, write a query to return customer names who have placed at least one order.
--Expected Columns: FirstName, LastName, TotalOrders


SELECT 
cus.FirstName,
cus.LastName,
COUNT(ord.OrderID) AS TotalOrders   --Alias 'TotalOrders ' makes the context clear
FROM Customers AS cus               --Alias 'cus' for Customers table
INNER JOIN Orders AS ord            --Alias 'ord' for Orders table
ON cus.CustomerID=ord.CustomerID
GROUP BY cus.FirstName,cus.LastName --GROUP BY: We group by FirstName and LastName to get one row per customer
HAVING COUNT(ord.OrderID)>=1        --Filtering here is optional/not needed since The INNER JOIN version would automatically exclude customers with no orders, making the HAVING clause unnecessary in this specific case.
ORDER BY  TotalOrders ASC           --Optional:just makes the report more readable


--13)Using the Employees and Departments tables, write a query to show only those records where both employee and department exist (no NULLs).
--Expected Columns: EmployeeName, DepartmentName



SELECT
emp.Name,
dep.DepartmentName
FROM Employees AS emp                    --Alias 'emp' for  Employees table
INNER JOIN Departments AS dep            --Alias 'dep' for  Departments table
ON emp.DepartmentID=dep.DepartmentID     --using "INNER JOIN" to retrieve only those records where both employee and department exist (no NULLs).
WHERE 
 emp.Name IS NOT NULL                    --Optional but more defensive and handles potential NULL values explicitly.
 AND dep.DepartmentName IS NOT NULL
ORDER BY Dep.DepartmentName              --Optional: sorts by Department names(A-Z),making the report more readable
 

--14)Using the Employees table, write a query to find pairs of employees who report to the same manager.
--Expected Columns: Employee1, Employee2, ManagerID

SELECT 
e1.Name AS Employee1,
e2.Name AS Employee2,
e1.ManagerID
FROM 
Employees e1
JOIN 
Employees e2 ON e1.ManagerID = e2.ManagerID
WHERE 
e1.EmployeeID < e2.EmployeeID  -- Ensures unique pairs and avoids self-matches
AND e1.ManagerID IS NOT NULL   -- Excludes employees without managers
ORDER BY 
e1.ManagerID, e1.Name, e2.Name   --Optional: just makes the report more readable



--15)Using the Orders and Customers tables, write a query to list all orders placed in 2022 along with the customer name.
--Expected Columns: OrderID, OrderDate, FirstName, LastName

--Since the question doesn't specify if report needs to include the orders without a customer ,Instead of "LEFT JOIN","INNER JOIN" HAS BEEN USED BELOW
SELECT
Ord.OrderID,
ord.OrderDate,
cust.FirstName,
cust.LastName
FROM Orders AS ord                     --Alias 'ord' for  Orders table
INNER JOIN Customers AS cust           --Alias 'cust' for Customers table
ON ord.CustomerID=cust.CustomerID
WHERE YEAR(ord.OrderDate)=2022         --Filtering to retrieve all orders placed in 2022 along with the customer name.
ORDER BY ord.OrderDate ASC             --Optional: sorts by order dated(oldest to newest),making the report easier to read



 --16)Using the Employees and Departments tables, write a query to return employees from the 'Sales' department whose salary is above 60000.
--Expected Columns: EmployeeName, Salary, DepartmentName 
  

SELECT
emp.Name,
emp.Salary,
dep.DepartmentName
FROM Employees AS emp                       --Alias 'emp' for  Employees table
INNER JOIN Departments AS dep               --Alias 'dep' for  Departments table
ON emp.DepartmentID=dep.DepartmentID
WHERE dep.DepartmentName LIKE 'Sales'
AND emp.Salary>60000                     --Filtering to retrieve employees from the 'Sales' department whose salary is above 60000.


--17)Using the Orders and Payments tables, write a query to return only those orders that have a corresponding payment.
--Expected Columns: OrderID, OrderDate, PaymentDate, Amount


SELECT 
ord.OrderID,
ord.OrderDate,
paym.PaymentDate,
paym.Amount
FROM Orders AS ord              --Alias 'ord' for  Orders table
INNER JOIN Payments AS paym     --Alias 'paym' for Payments table
ON ord.OrderID=paym.OrderID     --Using "INNER JOIN" to only those orders that have a corresponding payment.
ORDER BY ord.OrderDate,
paym.PaymentDate                --Optional: sorts by order date and payment date(oldest to newest),making the report easier to read


--18)Using the Products and Orders tables, write a query to find products that were never ordered.
--Expected Columns: ProductID, ProductName

SELECT 
prod.ProductID,
prod.ProductName
FROM Products AS prod                 --Alias 'prod' for  Products table
LEFT JOIN Orders AS ord                --Alias 'ord' for  Orders table
ON prod.ProductID=ord.ProductID
WHERE ord.OrderID IS NULL              --Filtering to retrieve products that have never been ordered.



--19)Using the Employees table, write a query to find employees whose salary is greater than the average salary in their own departments.
--Expected Columns: EmployeeName, Salary


SELECT
emp0.Name,
emp0.Salary
FROM Employees AS emp0      
INNER JOIN (SELECT 
DepartmentID, 
AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentID) AS dep_avg 
ON emp0.DepartmentID = dep_avg.DepartmentID
WHERE emp0.Salary>dep_avg.AvgSalary             --Filtering to retrieve
ORDER BY 
emp0.DepartmentID, emp0.Salary DESC;



--20)Using the Orders and Payments tables, write a query to list all orders placed before 2020 that have no corresponding payment.
--Expected Columns: OrderID, OrderDate

SELECT 
ord.OrderID,
ord.OrderDate
FROM Orders AS ord               --Alias 'ord' for  Orders table
LEFT JOIN Payments AS paym       --Alias 'paym' for Payments table
ON ord.OrderID=paym.OrderID      --Using "LEFT JOIN" to retrieve orders even without  corresponding payment.
WHERE paym.PaymentID IS NULL     --Filtering to retrieve only those orders placed before 2020 and without corresponding payment
AND YEAR(ord.OrderDate)<2020
ORDER BY ord.OrderDate ASC       ----Optional: sorts by order date (oldest to newest),making the report easier to read


--21)Using the Products and Categories tables, write a query to return products that do not have a matching category.
--Expected Columns: ProductID, ProductName


SELECT
prod.ProductID,
prod.ProductName
FROM Products AS prod                 --Alias 'prod' for Products table
LEFT JOIN Categories AS cat           --Alias 'ord' for  Categories table 
ON prod.Category=cat.CategoryName     --Using "LEFT JOIN" to retrieve products even without  corresponding category
WHERE cat.CategoryID IS NULL          --Filtering to retrieve only those  products that do not have a matching category.


--22)Using the Employees table, write a query to find employees who report to the same manager and earn more than 60000.
--Expected Columns: Employee1, Employee2, ManagerID, Salary



SELECT 
e1.Name AS Employee1,
e2.Name AS Employee2,
e1.ManagerID,
e1.Salary AS emp1_salary ,       --alies here make the context clear
e2.Salary AS emp2_salary          --alies here make the context clear
FROM 
Employees e1
JOIN 
Employees e2 ON e1.ManagerID = e2.ManagerID
WHERE 
e1.EmployeeID < e2.EmployeeID  -- Ensures unique pairs and avoids self-matches
AND e1.ManagerID IS NOT NULL   -- Excludes employees without managers
AND e1.Salary>60000            -- retrieves only those employees who earn more than 60000
AND e2.Salary>60000
ORDER BY 
e1.ManagerID, e1.Name, e2.Name   --Optional: just makes the report more readable


--23)Using the Employees and Departments tables, write a query to return employees who work in departments which name starts with the letter 'M'.
--Expected Columns: EmployeeName, DepartmentName

SELECT 
emp.Name,
dep.DepartmentName
FROM Employees AS emp                     --Alias 'emp' for Employees table
INNER JOIN Departments AS dep             --Alias 'dep' for Departments table  
ON emp.DepartmentID=dep.DepartmentID      --using "INNER JOIN" to retrieve only those who have assigned departments
WHERE dep.DepartmentName LIKE 'M%'        --Filtering to retrieve only those employees who work in departments which name starts with the letter 'M'.
ORDER BY emp.Name ASC                     --Optional:just makes the report more readable 


--24)Using the Products and Sales tables, write a query to list sales where the amount is greater than 500, including product names.
--Expected Columns: SaleID, ProductName, SaleAmount

SELECT 
sal.SaleID,
prod.ProductName,
sal.SaleAmount
FROM Products AS prod                  --Alias 'prod' for  Products table
INNER JOIN Sales AS sal                --Alias 'sal' for  Sales table
ON prod.ProductID=sal.ProductID
WHERE sal.SaleAmount>500               --Filtering to retrieve only those sales where the amount is greater than 500


--25)Using the Students, Courses, and Enrollments tables, write a query to find students who have not enrolled in the course 'Math 101'.
--Expected Columns: StudentID, StudentName


SELECT 
st.StudentID,
st.Name
FROM Students AS st                         --Alias 'st' for Students table
INNER JOIN Enrollments AS enr               --Alias 'emp' for Enrollments table
ON st.StudentID=enr.StudentID          
INNER JOIN Courses AS cour                  --Alias 'cour' for Courses table
ON Enr.CourseID=cour.CourseID
WHERE cour.CourseName NOT LIKE 'Math 101'   --Filtering to retrieve students who who have not enrolled in the course 'Math 101'.


--26)Using the Orders and Payments tables, write a query to return orders that are missing payment details.
--Expected Columns: OrderID, OrderDate, PaymentID


SELECT 
ord.OrderID,
ord.OrderDate,
paym.*
FROM Orders AS ord               --Alias 'ord' for  Orders table
INNER JOIN Payments AS paym       --Alias 'paym' for Payments table
ON ord.OrderID=paym.OrderID      --Firstly,using "INNER JOIN" to retrieve orders with  corresponding payment.
WHERE paym.Amount IS NULL        --Using "IS NULL" and "OR" to filter orders that are missing payment details.
OR paym.OrderID IS NULL          
OR paym.PaymentDate IS NULL
OR paym.PaymentID IS NULL
OR paym.PaymentMethod IS NULL
ORDER BY ord.OrderDate ASC       --Makes the report easier to follow



--27)Using the Products and Categories tables, write a query to list products that belong to either the 'Electronics' or 'Furniture' category.
--Expected Columns: ProductID, ProductName, CategoryName


SELECT
prod.ProductID,
prod.ProductName,
cat.CategoryName
FROM Products AS prod                     --Alias 'prod' for Products table
INNER JOIN Categories AS cat              --Alias 'ord' for  Categories table 
ON prod.Category=cat.CategoryName         --Using "INNER JOIN" to exclude products without  corresponding category
WHERE cat.CategoryName LIKE  'Furniture'  --Filtering to retrieve products that belong to either the 'Electronics' or 'Furniture' category.
OR cat.CategoryName LIKE 'Electronics'
ORDER BY cat.CategoryName                 --Optional: just makes the report easier to follow

