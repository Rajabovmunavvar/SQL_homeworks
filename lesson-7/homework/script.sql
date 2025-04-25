--1)finding the minimum price of a product in the Products table.

--FIRST METHOD : Basic SQL Query

SELECT  
MIN(Price) AS minimum_price   --'AS' makes the context clear
FROM Products

--SECOND METHOD :  if more details wanted about the cheapest product

  SELECT *
FROM Products
WHERE price = (
SELECT MIN(price)
FROM Products
);


--2) Finding the maximum Salary from the Employees table.

--First Method : basic SQL query

SELECT MAX(Salary) AS Max_salary_in_emp --'AS' makes the context clear
FROM Employees


--Second method :  if more details wanted about the employee with the highest salary

  SELECT *
FROM Employees
WHERE Salary = (
SELECT MAX(Salary)
FROM Employees
);

--3)counting the number of rows in the Customers table using COUNT(*).

SELECT COUNT(*) AS ROWS_IN_TABLE --'AS' makes the context clear
FROM Customers


--4) counting the number of unique product categories (COUNT(DISTINCT Category)) from the Products table.

--First method : Basic query
SELECT COUNT(DISTINCT Category)  AS DISTINCT_CATEGORIES --'AS' makes the context clear
FROM Products

--Second method : if you want the table to show what those distinct categories are 

SELECT DISTINCT Category
FROM Products


--5) finding the total  sales amount for the product with id 7 in the Sales table.

--First method : Basic query
SELECT SUM(SaleAmount) AS SUM_SALE_PROD_ID7  --'AS' makes the context clear
FROM Sales
WHERE ProductID=7


--Second method : version with more explicit output

SELECT 
    'Product 7' AS product_description,
    SUM(SaleAmount) AS total_sales_amount,
    COUNT(*) AS number_of_sales_transactions
FROM 
    Sales
WHERE 
    ProductID = 7;


--6)calculating the average  age of employees in the Employees table.

SELECT AVG(AGE)  AS AVG_AGE_OF_EMP    --'AS' makes the context clear
FROM Employees


--7) using GROUP BY to count the number of employees in each department.

SELECT DepartmentName, 
COUNT(EmployeeID) AS NUM_OF_EMP_PER_DEP  --'AS' makes the context clear
FROM Employees
GROUP BY DepartmentName
ORDER BY NUM_OF_EMP_PER_DEP DESC;  -- Optional: sorts by department size (largest first)

--8)showing the minimum and maximum Price of products grouped by Category,using Products table

 SELECT Category,
 MAX(Price) AS Max_prod,   --'AS' makes the context clear
 MIN(Price) AS Min_prod    --'AS' makes the context clear
 FROM Products
 GROUP BY Category
 ORDER BY Category ASC -- Optional: sorts by Category name  (A-Z)

 --9)calculating the total  sales per Customer in the Sales table.
 
SELECT CustomerID,
SUM(SaleAmount) AS TOTAL_SALE_PER_CUSTOMER  --'AS' makes the context clear
FROM Sales
GROUP BY CustomerID
ORDER BY TOTAL_SALE_PER_CUSTOMER DESC -- Optional: sorts by total sale per customer  (highest to lowest)


--10)using HAVING to filter departments having more than 5 employees from the Employees table.


SELECT DepartmentName, 
COUNT(EmployeeID) AS NUM_OF_EMP_PER_DEP  --'AS' makes the context clear
FROM Employees
GROUP BY DepartmentName
HAVING  COUNT(EmployeeID)>5        -- Filtering if employees in the department more than 5
ORDER BY NUM_OF_EMP_PER_DEP DESC;  -- Optional: sorts by department size (largest first)


--11)calculating the total sales and average sales for each product category from the Sales table.
  
SELECT CategoryID,
SUM(SaleAmount) AS Total_sales_per_category,
AVG(SaleAmount) AS Avarage_sales_per_category
FROM Sales
GROUP BY CategoryID
ORDER BY Total_sales_per_category DESC -- Optional: sorts by total sale of per category  (highest to lowest)


--12)using COUNT to count the number of employees from the Department HR.

SELECT DepartmentName, 
COUNT(EmployeeID) AS NUM_OF_EMP_PER_DEP  --'AS' makes the context clear
FROM Employees
GROUP BY DepartmentName
HAVING DepartmentName LIKE 'HR'


--13) finding the highest and lowest Salary by department in the Employees table.

SELECT DepartmentName, 
MAX(Salary) as Highest_Salary_per_dep,   --'AS' makes the context clear
MIN(Salary) as Lowest_Salary_per_dep     --'AS' makes the context clear
FROM Employees
GROUP BY DepartmentName
ORDER BY Highest_Salary_per_dep DESC  -- Optional: sorts by highest salary in each department   (highest to lowest)


--14) using GROUP BY to calculate the average salary per Department

SELECT DepartmentName, 
AVG(Salary) as Avg_salary_in_thedepartment    --'AS' makes the context clear
FROM Employees
GROUP BY DepartmentName 
ORDER BY Avg_salary_in_thedepartment ASC -- Optional: sorts by Avarage salary in each department   (lowest to highest)


--15)showing the AVG salary and COUNT(*) of employees working in each department.

SELECT DepartmentName, 
AVG(Salary) as Avg_salary_in_thedepartment ,   --'AS' makes the context clear
COUNT(EmployeeID) AS NUM_OF_EMP_PER_DEP  --'AS' makes the context clear
FROM Employees
GROUP BY DepartmentName
ORDER BY Avg_salary_in_thedepartment ASC -- Optional: sorts by Avarage salary in each department   (lowest to highest)


--16)using HAVING to filter product categories with an average price greater than 400.

SELECT Category,
AVG(Price) AS AVG_PRICE_PER_CATEGORY  --'AS' makes the context clear
FROM Products
GROUP BY Category
HAVING AVG(Price)> 400;


--17) calculating the total sales for each year in the Sales table, and using GROUP BY to group them.


SELECT 
    YEAR(SaleDate) AS SalesYear,
    SUM(SaleAmount) AS TotalSales,
    COUNT(*) AS NumberOfTransactions    --OPTIONAL!
FROM 
    Sales
GROUP BY 
    YEAR(SaleDate) 
ORDER BY 
    SalesYear;           -- This ensures your report shows years in proper sequence (2023, 2024, etc.)


--18)using COUNT to show the number of customers who placed at least 3 orders.
 
SELECT CustomerID,
COUNT(*) AS TIMES_OF_ORDER  --'AS' makes the context clear
FROM Sales
GROUP BY CustomerID
HAVING COUNT(*) >=4         --Filtering to retrieve only customers who place at least 3 orders
ORDER BY TIMES_OF_ORDER ASC -- This ensures your report shows placed orders in proper sequence (lowest to highest)


--19)
SELECT DepartmentName, 
SUM(Salary) AS Total_salary_per_dep   --'AS' makes the context clear
FROM Employees
GROUP BY DepartmentName
HAVING SUM(Salary)<500000 ;    --Filtering out Departments with total salary expenses greater than 500,000


--20)showing the average (AVG) sales for each product category, and then usign HAVING to filter categories with an average sales amount greater than 200.

  
SELECT CategoryID,
AVG(SaleAmount) AS Avarage_sales_per_category        --'AS' makes the context clear
FROM Sales
GROUP BY CategoryID
HAVING AVG(SaleAmount)>200       --Filtering to retrieve only Product categories with an average sales amount greater than 200
ORDER BY AVG(SaleAmount) ASC     -- Optional: sorts by Avarage sales amount in each category   (lowest to highest)


--21)calculating the total  sales for each Customer, then filter the results using HAVING to include only Customers with total sales over 1500.

SELECT CustomerID,
SUM(SaleAmount) AS TOTAL_SALE_PER_CUSTOMER     --'AS' makes the context clear
FROM Sales
GROUP BY CustomerID
HAVING SUM(SaleAmount)>1500       --Filtering to retrieve only Customers with total sales over 1500.
ORDER BY SUM(SaleAmount) ASC      -- Optional: sorts by Total sales amount per customer  (lowest to highest)


--22)finding the total (SUM) and average (AVG) salary of employees grouped by department, and using HAVING to include only departments with an average salary greater than 65000.


SELECT DepartmentName, 
AVG(Salary) as Avg_salary_in_thedepartment    --'AS' makes the context clear
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary)>65000                 --Filtering to retrieve only departments with an average salary greater than 65000
ORDER BY Avg_salary_in_thedepartment ASC -- Optional: sorts by Avarage salary in each department   (lowest to highest)


--23) finding the maximum and minimum order value for each customer, and then applying HAVING to exclude customers with an order value less than 50.

SELECT CustomerID,
MAX(SaleAmount) AS MAX_ORDER_VAL,    --'AS' makes the context clear
MIN(SaleAmount)  AS MIN_ORDER_VAL    --'AS' makes the context clear
FROM Sales
GROUP BY CustomerID
HAVING MAX(SaleAmount)>=50           --Filtering to filter out customers with an order value less than 50.
order by MAX(SaleAmount) ASC            -- Optional: sorts by maximum saleamount per customer  (lowest to highest)

SELECT * FROM Sales
--24)calculating the total sales  and counts distinct products sold in each month, and then applies HAVING to filter the months with more than 8 products sold.

SELECT   
FORMAT(SaleDate, 'yyyy-MM') AS year_month, --- 'YEAR' here is optional but effective when working with multi-year datasets
SUM(SaleAmount) AS TOTAL_SALES_PERMONTH ,   --'AS' makes the context clear
COUNT(DISTINCT ProductID) AS DIST_PROD_SOLD_PER_MONTH 
FROM Sales
GROUP BY FORMAT(SaleDate, 'yyyy-MM')
HAVING COUNT(DISTINCT ProductID) > 8


--25) finding the MIN and MAX order quantity per Year. From orders table.

SELECT *
FROM Orders
 
SELECT DISTINCT FORMAT(OrderDate, 'yyyy') AS 'YEAR',-- 'AS' creates a column alias and -- Single quotes around 'YEAR' make it a literal colum(avoiding confusion with the YEAR() function)
MIN(Quantity) AS Min_order_quant ,  --'AS' makes the context clear
MAX(Quantity) AS Max_order_quant    --AS Min_order_quant 
FROM Orders
GROUP BY  FORMAT(OrderDate, 'yyyy')
ORDER BY YEAR  ASC   -- This ensures your report shows the years  in proper sequence ,making the tale easier to follow



