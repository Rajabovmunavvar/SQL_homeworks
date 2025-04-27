--1)Using Products table, find the total number of products available in each category.

SELECT Category,
COUNT(ProductID) AS TOTAL_PROD_NUMBER_PER_CATEGORY
FROM Products
GROUP BY Category
ORDER BY TOTAL_PROD_NUMBER_PER_CATEGORY ASC --Optional, just sorts by  number of products available in each category in order(lowest to highest),making the table easy to follow


--2)Using Products table, get the average price of products in the 'Electronics' category.


SELECT Category,
AVG(Price) AS AVG_PRICE_OF_CATEGORY  --"AS" : Makes the context clearer.
FROM Products
GROUP BY Category
HAVING Category like 'Electronics'


--3)Using Customers table, list all customers from cities that start with 'L'.

SELECT     CustomerID ,
    FirstName ,
    LastName ,
	City
FROM Customers
WHERE City LIKE 'L%'      --Filtering to retrieve customers only from the cities that start with "L".
ORDER BY CustomerID ASC   --Optional: sorts by customer IDs (LOWEST TO HIGHEST)


--4)Using Products table, get all product names that end with 'er'.

SELECT  
ProductID ,
ProductName 
FROM Products
WHERE ProductName LIKE '%er'   --Filtering to retrieve all product names that end with 'er'.
ORDER BY ProductName ASC       --Optional: sorts by product name (A-Z) , making the report easier to follow


--5)Using Customers table, list all customers from countries ending in 'A'.

SELECT 
 CustomerID ,
 FirstName ,
 LastName ,
 Country
FROM Customers
WHERE Country LIKE '%A'   --Filtering to retrieve all customers from countries ending in 'A'.
ORDER BY Country          --Optional: sorts by country name  (A-Z) , making the report easier to follow


--6)Using Products table, show the highest price among all products.

--FIRST METHOD :
SELECT TOP 1
ProductID,
ProductName,
Price
FROM Products
ORDER BY Price DESC


--SECOND METHOD :
SELECT 
MAX(PRICE) AS Highest_price    --"AS" : Makes the context clearer.
FROM Products


--7)Using Products table, use IIF to label stock as 'Low Stock' if quantity < 30, else 'Sufficient'.

SELECT
ProductID,
ProductName,
StockQuantity,
         IIF(StockQuantity< 30,'Low Stock','Sufficient')
FROM Products
ORDER BY StockQuantity ASC   --Optional: sorts by StockQuantity (lowest to highest) , making the report easier to follow


--8)Using Customers table, find the total number of customers in each country.

SELECT 
Country,
COUNT( CustomerID) AS NUM_OF_CUST_PER_COUNTRY
FROM Customers
GROUP BY Country 
ORDER BY NUM_OF_CUST_PER_COUNTRY ASC      --Optional: sorts by  total number of customers in each country (lowest to highest) , making the report easier to follow


--OR:


SELECT 
Country,
COUNT(*) AS NUM_OF_CUST_PER_COUNTRY
FROM Customers
GROUP BY Country 
ORDER BY NUM_OF_CUST_PER_COUNTRY ASC    --Optional: sorts by  total number of customers in each country (lowest to highest) , making the report easier to follow 


--9)Using Orders table, find the minimum and maximum quantity ordered.

SELECT 
MIN(Quantity) as min_quantity_ordered ,
MAX(Quantity) as max_quantity_ordered
FROM Orders


--10)Using Orders and Invoices tables, list customer IDs who placed orders in 2023 (using EXCEPT) to find those who did not have invoices.

SELECT CustomerID
FROM Orders
WHERE YEAR(OrderDate) LIKE '2023'

EXCEPT

SELECT CustomerID
FROM Invoices


--11)Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted including duplicates.

SELECT ProductName 
FROM Products

UNION ALL            -- using "UNION ALL" to Combine all product names from Products and Products_Discounted including duplicates.

SELECT ProductName
FROM Products_Discounted


--12)Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted without duplicates.

SELECT ProductName 
FROM Products

UNION             -- using "UNION" to Combine all product names from Products and Products_Discounted without duplicates.

SELECT ProductName
FROM Products_Discounted


--13)Using Orders table, find the average order amount by year.

SELECT 
FORMAT(orderdate, 'yyyy') as 'year' ,   --"AS" : Makes the context clearer.
AVG(TotalAmount) AS AVG_ORDER_AMOUNT       --"AS" : Makes the context clearer.
FROM Orders
GROUP BY FORMAT(orderdate, 'yyyy')
ORDER BY FORMAT(orderdate, 'yyyy') ASC  --Optional: sorts by year, making the report easier to follow 


--14)Using Products table, use CASE to group products based on price: 'Low' (<100), 'Mid' (100-500), 'High' (>500). Return productname and pricegroup.

SELECT 
ProductID,
ProductName,
Price,
    CASE WHEN Price<100 THEN 'Low'
	     WHEN Price BETWEEN 100 AND 500 THEN 'Mid'
		 ELSE 'High' END AS 'Price_status'

FROM Products
ORDER BY price


--15)Using Customers table, list all unique cities where customers live, sorted alphabetically.

SELECT
DISTINCT City      --Using "DISTINCT" , we can select all unique cities
FROM  Customers
ORDER BY City ASC  --This way, we can sort them lphabetically (A-Z).


--16)Using Sales table, find total sales per product Id.

SELECT ProductID ,
SUM(SaleAmount) AS TOTAL_SALES   --using "AS" to make context more clear and readable.
FROM SALES
GROUP BY ProductID
ORDER BY TOTAL_SALES             --Optional : just makes the report easier to read.


--17)Using Products table, use wildcard to find products that contain 'oo' in the name. Return productname.

SELECT ProductName   --Selecting "ProductName" to return that product name in the result.
FROM Products
WHERE  ProductName LIKE '%oo%'   --Filtering to retrieve products that contain 'oo' in the name.


--18)Using Products and Products_Discounted tables, compare product IDs using INTERSECT.

SELECT ProductID FROM Products

INTERSECT                    --using "INTERSECT" to compare products IDs from both tables.

SELECT ProductID FROM Products_Discounted


--19)Using Invoices table, show top 3 customers with the highest total invoice amount. Return CustomerID and Totalspent.

SELECT TOP 3 WITH TIES           --Using "WITH TIES" ,just in case we might have other customers who can be qualified for top 3
CustomerID,
SUM(TotalAmount) as total_spend  --Using "AS" to make the report more readable
FROM Invoices
GROUP BY CustomerID
ORDER BY total_spend DESC        --using "ORDER BY DESC" , we can get top 3 customers with the highest total spent amount


--20)Find product ID and productname that are present in Products but not in Products_Discounted.

SELECT 
ProductID,
ProductName
FROM Products

EXCEPT            ---Using "EXCEPT" To find exceptions .

SELECT 
ProductID,
ProductName
FROM Products_Discounted


--21)Using Products and Sales tables, list product names and the number of times each has been sold. (Research for Joins)

SELECT 
    p.ProductID,
    p.ProductName,
    COUNT(s.SaleID) AS times_sold
FROM 
    Products p
LEFT JOIN                              --Using "LEFT JOIN" to include products with zero sales.
    Sales s ON p.ProductID = s.ProductID
GROUP BY 
    p.ProductID, p.ProductName
ORDER BY 
    times_sold DESC;


--22)Using Orders table, find top 5 products (by ProductID) with the highest order quantities.

SELECT TOP 5 WITH TIES                      --Using "WITH TIES" ,just in case we might have other products that can be qualified for top 5
ProductID,
SUM(Quantity)   as total_ord_quantity       --using "AS" To make the report more readable.
FROM Orders
GROUP BY ProductID
ORDER BY SUM(Quantity) DESC                 --this way, we can get top 5 products with highest order quantities.

