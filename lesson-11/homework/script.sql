--1)Return: OrderID, CustomerName, OrderDate
--Task: Show all orders placed after 2022 along with the names of the customers who placed them.
--Tables Used: Orders, Customers

SELECT
ord.OrderID,
CONCAT(cust.FirstName, ' ', cust.LastName) AS CustomerName,  --using "CONCAT" since the table does not have full name(customer name) column 
ord.OrderDate
FROM Orders AS ord                      --Alias 'ord' for Orders table
INNER JOIN Customers AS cust            --Alias 'cust' for Customers table
ON ord.CustomerID=cust.CustomerID     
WHERE YEAR(ord.OrderDate) > 2022        --Filtering to retrieve only those orders placed after 2022.
ORDER BY ord.OrderDate ASC              --Optional: sorts by order date (oldest to newest),making the report more readable.
;

--2)Return: EmployeeName, DepartmentName
--Task: Display the names of employees who work in either the Sales or Marketing department.
--Tables Used: Employees, Departments

SELECT
emp.Name AS EmployeeName ,               --Alias here makes the context clear
dep.DepartmentName      
FROM Employees AS emp                    --Alias 'emp' for Employees table
INNER JOIN Departments AS dep            --Alias 'dep' for Departments table
ON emp.DepartmentID=dep.DepartmentID
WHERE dep.DepartmentName IN('Sales','Marketing') --Filtering to retrieve only those employees who work in either the Sales or Marketing department.
ORDER BY dep.DepartmentName              --Optional: sorts by Department name (A-Z),making the report more readable.
;


--3)Return: DepartmentName, MaxSalary
--Task: Show the highest salary for each department.
--Tables Used: Departments, Employees


SELECT
dep.DepartmentName,
MAX(emp.Salary) AS max_sal_per_dep     --Alias here makes the context clear
FROM Departments AS dep                --Alias 'dep' for Departments table
INNER JOIN Employees AS emp            --Alias 'emp' for Employees table
ON dep.DepartmentID=emp.DepartmentID
GROUP BY 
dep.DepartmentID ,  -- Grouping by ID ensures correct aggregation
dep.DepartmentName
ORDER BY max_sal_per_dep ASC           --Optional: sorts by max salary (lowest to highest),making the report more readable.
;


--4)Return: CustomerName, OrderID, OrderDate
--Task: List all customers from the USA who placed orders in the year 2023.
--Tables Used: Customers, Orders

SELECT 
CONCAT(cust.FirstName, ' ', cust.LastName) AS CustomerName,  --using "CONCAT" since the table does not have full name(customer name) column
ord.OrderID,
ord.OrderDate
FROM Customers AS cust             --Alias 'cust' for Customers table
INNER JOIN Orders AS ord           --Alias 'ord' for Orders table
ON cust.CustomerID=ord.CustomerID  
WHERE cust.Country='USA'           --Filtering to retrieve only those customers from the USA who placed orders in the year 2023.
AND YEAR(ord.OrderDate)='2023'  
ORDER BY ord.OrderDate ASC         --Optional: sorts by order date (oldest to newest),making the report more readable.
;

--5)Return: CustomerName, TotalOrders
--Task: Show how many orders each customer has placed.
--Tables Used: Orders , Customers


SELECT 
CONCAT(cust.FirstName, ' ', cust.LastName) AS CustomerName,  --using "CONCAT" since the table does not have full name(customer name) column
COUNT(*) AS TotalOrders
FROM Customers AS cust             --Alias 'cust' for Customers table
INNER JOIN Orders AS ord           --Alias 'ord' for Orders table
ON cust.CustomerID=ord.CustomerID 
GROUP BY
cust.CustomerID,
CONCAT(cust.FirstName, ' ', cust.LastName)
ORDER BY TotalOrders		      --Optional: sorts by total number of order per customer(lowest to highest) , making the report easy to follow.
;

--6)Return: ProductName, SupplierName
--Task: Display the names of products that are supplied by either Gadget Supplies or Clothing Mart.
--Tables Used: Products, Suppliers


SELECT 
prod.ProductName,
supp.SupplierName
FROM Products AS prod               --Alias 'prod' for Products table
INNER JOIN Suppliers AS supp        --Alias 'supp' for Suppliers table
ON prod.SupplierID=supp.SupplierID
WHERE supp.SupplierName IN(          --Filtering to retrieve only those products that are supplied by either Gadget Supplies or Clothing Mart.
'Gadget Supplies','Clothing Mart')  
ORDER BY supp.SupplierName ASC       --Optional: sorts by supplier name (A-Z), making the report easy to follow.
;

--7)Return: CustomerName, MostRecentOrderDate
--Task: For each customer, show their most recent order. Include customers who haven't placed any orders.
--Tables Used: Customers, Orders


SELECT 
CONCAT(cust.FirstName, ' ', cust.LastName) AS CustomerName,  --using "CONCAT" since the table does not have full name(customer name) column
MAX(ord.OrderDate) AS MostRecentOrderDate
FROM Customers AS cust             --Alias 'cust' for Customers table
LEFT JOIN Orders AS ord           --Alias 'ord' for Orders table
ON cust.CustomerID=ord.CustomerID 
GROUP BY
cust.CustomerID,
CONCAT(cust.FirstName, ' ', cust.LastName)
ORDER BY MostRecentOrderDate ASC     --Optional: makes the report easy to follow.
;

--8)Return: CustomerName, OrderTotal
--Task: Show the customers who have placed an order where the total amount is greater than 500.
--Tables Used: Orders, Customers

SELECT 
CONCAT(cust.FirstName, ' ', cust.LastName) AS CustomerName,  --using "CONCAT" since the table does not have full name(customer name) column
ord.TotalAmount AS OrderTotal
FROM Customers AS cust             --Alias 'cust' for Customers table
INNER JOIN Orders AS ord           --Alias 'ord' for Orders table
ON cust.CustomerID=ord.CustomerID  
WHERE ord.TotalAmount>500          --Filtering to retrieve only those where the total amount is greater than 500.
ORDER BY ord.TotalAmount ASC       --Optional: makes the report easy to follow.
;

--9)Return: ProductName, SaleDate, SaleAmount
--Task: List product sales where the sale was made in 2022 or the sale amount exceeded 400.
--Tables Used: Products, Sales.

SELECT 
prod.ProductName,
sal.SaleDate,
sal.SaleAmount
FROM Products AS prod              --Alias 'prod' for Products table
INNER JOIN Sales AS sal            --Alias 'sal' for Sales table    
ON prod.ProductID=SAL.ProductID    
WHERE YEAR(sal.SaleDate)='2022'    --Filtering to retrieve only those product sales where the sale was made in 2022 or the sale amount exceeded 400.
OR sal.SaleAmount>400
ORDER BY sal.SaleDate              --Optional: makes the report easy to follow.
;

--10)Return: ProductName, TotalSalesAmount
--Task: Display each product along with the total amount it has been sold for.
--Tables Used: Sales, Products


SELECT 
prod.ProductName,                
SUM(sal.SaleAmount) AS TotalSalesAmount   --Using "SUM(sal.SaleAmount)" To get the Total Sales Amount for each product.
FROM Products AS prod            --Alias 'prod' for Products table
INNER JOIN Sales AS sal          --Alias 'sal' for Sales table    
ON prod.ProductID=SAL.ProductID 
GROUP BY
prod.ProductID,                  -- Grouping by ID ensures correct aggregation
prod.ProductName
ORDER BY TotalSalesAmount ASC    --Optional: sorts  by total sales amount (lowest to highest) ,making the report more readable
;


--11)Return: EmployeeName, DepartmentName, Salary
--Task: Show the employees who work in the HR department and earn a salary greater than 60000.
--Tables Used: Employees, Departments

SELECT
emp.Name  AS EmployeeName ,              --Alias here makes the context clear
dep.DepartmentName ,
emp.Salary
FROM Employees AS emp                    --Alias 'emp' for Employees table
INNER JOIN Departments AS dep            --Alias 'dep' for Departments table
ON emp.DepartmentID=dep.DepartmentID
WHERE dep.DepartmentName LIKE 'HR' 
AND emp.Salary>60000                     --Filtering to retrieve only those employees who work in HR department and earn a salary greater than 60000.
ORDER BY emp.Salary ASC                  --Optional: just makes the report more readable
;


--12)Return: ProductName, SaleDate, StockQuantity
--Task: List the products that were sold in 2023 and had more than 100 units in stock at the time.
--Tables Used: Products, Sales

SELECT 
prod.ProductName,
sal.SaleDate,
prod.StockQuantity
FROM Products AS prod              --Alias 'prod' for Products table
INNER JOIN Sales AS sal            --Alias 'sal' for Sales table    
ON prod.ProductID=SAL.ProductID    
WHERE YEAR(sal.SaleDate)='2023'    --Filtering to retrieve only those  products that were sold in 2023 and had more than 100 units in stock at the time.
AND prod.StockQuantity>100
ORDER BY sal.SaleDate ASC          --Optional: makes the report more readable.
;


--13)Return: EmployeeName, DepartmentName, HireDate
--Task: Show employees who either work in the Sales department or were hired after 2020.
--Tables Used: Employees, Departments


SELECT
emp.Name  AS EmployeeName ,              --Alias here makes the context clear
dep.DepartmentName ,
emp.HireDate
FROM Employees AS emp                    --Alias 'emp' for Employees table
INNER JOIN Departments AS dep            --Alias 'dep' for Departments table
ON emp.DepartmentID=dep.DepartmentID
WHERE dep.DepartmentName LIKE 'Sales' 
OR YEAR(emp.HireDate)>2020               --Filtering to retrieve only those employees who either work in the Sales department or were hired after 2020.
ORDER BY dep.DepartmentName ASC          --Optional: just makes the report more readable
;


--14)Return: CustomerName, OrderID, Address, OrderDate
--Task: List all orders made by customers in the USA whose address starts with 4 digits.
--Tables Used: Customers, Orders

SELECT 
CONCAT(cust.FirstName, ' ', cust.LastName) AS CustomerName,  --using "CONCAT" since the table does not have full name(customer name) column
ord.OrderID,
cust.Address,
ord.OrderDate
FROM Customers AS cust             --Alias 'cust' for Customers table
INNER JOIN Orders AS ord           --Alias 'ord' for Orders table
ON cust.CustomerID=ord.CustomerID  
WHERE cust.Country='USA'           --Filtering to retrieve only those orders made by customers in the USA whose address starts with 4 digits.
AND cust.Address LIKE '[0-9][0-9][0-9][0-9][^0-9]%' --using "[^0-9]" excludes the address that starts with 5 digits.
ORDER BY ord.OrderDate              --Optional: just makes the report more readable 
;


--15)Return: ProductName, Category, SaleAmount
--Task: Display product sales for items in the Electronics category or where the sale amount exceeded 350.
--Tables Used: Products, Sales

--Since "prod.category" doesn't have category name but(category ID) ,we must use "Categories" table one way or another !!


--FIRST METHOD: USING "JOIN"
SELECT 
prod.ProductName,
cat.CategoryName,
sal.SaleAmount
FROM Products AS prod                 --Alias 'prod' for Products table
INNER JOIN Sales AS sal               --Alias 'sal' for Sales table    
ON prod.ProductID=SAL.ProductID  
LEFT JOIN Categories AS cat           --Using "LEFT JOIN" not to exclude those products without mathing categories but has sales exceeded 350
ON prod.Category=cat.CategoryID
WHERE cat.CategoryName='Electronics'  --Filtering to retrieve only those product sales where the sale was made in 2022 or the sale amount exceeded 400.
OR sal.SaleAmount>350
ORDER BY cat.CategoryName ASC         --Optional: makes the report easier to follow
;

--SECOND METHOD: USING "Categories" table when filtering (WHERE)

SELECT 
prod.ProductName,
prod.Category AS Category,            --Alies makes the context clear
sal.SaleAmount
FROM Products AS prod                 --Alias 'prod' for Products table
INNER JOIN Sales AS sal               --Alias 'sal' for Sales table    
ON prod.ProductID=SAL.ProductID  
WHERE prod.Category = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Electronics')  
OR sal.SaleAmount>350
ORDER BY prod.Category
;


--16)Return: CategoryName, ProductCount
--Task: Show the number of products available in each category.
--Tables Used: Products, Categories


--FIRST MEHTOD: only showing categories with products
SELECT
cat.CategoryName,
COUNT(*) AS ProductCount
FROM Categories AS cat
INNER JOIN Products AS prod
ON cat.CategoryID=prod.Category
GROUP BY cat.CategoryName
;

--SECOND: Showing categories even without any product as well
SELECT
cat.CategoryName,
COUNT(prod.ProductID) AS ProductCount
FROM Categories AS cat
left JOIN Products AS prod
ON cat.CategoryID=prod.Category
GROUP BY cat.CategoryName
;

--17)Return: CustomerName, City, OrderID, Amount
--Task: List orders where the customer is from Los Angeles and the order amount is greater than 300.
--Tables Used: Customers, Orders

SELECT 
CONCAT(cust.FirstName, ' ', cust.LastName) AS CustomerName,  --using "CONCAT" since the table does not have full name(customer name) column
cust.City,
ord.OrderID,
ord.TotalAmount
FROM Customers AS cust             --Alias 'cust' for Customers table
INNER JOIN Orders AS ord           --Alias 'ord' for Orders table
ON cust.CustomerID=ord.CustomerID  
WHERE cust.City='Los Angeles'      --Filtering to retrieve the customer is from Los Angeles and the order amount is greater than 300.
AND ord.TotalAmount>300
ORDER BY ord.OrderDate ASC	       --Optional: sorts by order date(oldest to newest),making the report easier to follow
;


--18)Return: EmployeeName, DepartmentName
--Task: Display employees who are in the HR or Finance department, or whose name contains at least 4 vowels.
--Tables Used: Employees, Departments


SELECT
emp.Name  AS EmployeeName ,              --Alias here makes the context clear
dep.DepartmentName 
FROM Employees AS emp                    --Alias 'emp' for Employees table
INNER JOIN Departments AS dep            --Alias 'dep' for Departments table
ON emp.DepartmentID=dep.DepartmentID     
WHERE dep.DepartmentName                 --Filtering to retrieve employees who are in the HR or Finance department, or whose name contains at least 4 vowels.
IN('HR','Finance') 
OR ( LEN(emp.Name) - 
LEN(
REPLACE                                    --Using "LEN()" and"REPLACE()" functions to maeasure and compare before and afte conditions so that it is possible to count vowels in the name.
      (REPLACE
	          (REPLACE
			         (REPLACE
					        (REPLACE
							       (UPPER(emp.Name),  --using (UPPER(e.EmployeeName) to uppercase to standardize the comparison (so we don't need to check both 'a' and 'A')
                                           'A', ''),
		                           'E', ''),
		                   'I', ''),
		          'O', ''),
		'U', '')
		)
    ) >= 4
ORDER BY dep.DepartmentName ASC      --Optional : makes the report easier to follow
;


--19)Return: EmployeeName, DepartmentName, Salary
--Task: Show employees who are in the Sales or Marketing department and have a salary above 60000.
--Tables Used: Employees, Departments

SELECT
emp.Name  AS EmployeeName ,              --Alias here makes the context clear
dep.DepartmentName ,
emp.Salary
FROM Employees AS emp                    --Alias 'emp' for Employees table
INNER JOIN Departments AS dep            --Alias 'dep' for Departments table
ON emp.DepartmentID=dep.DepartmentID
WHERE dep.DepartmentName 
IN('Sales','Marketing') 
AND emp.Salary>60000                     --Filtering to retrieve only those employees who work the Sales or Marketing department and have a salary above 60000.
ORDER BY emp.Salary ASC                  --Optional: just makes the report more readable
;

