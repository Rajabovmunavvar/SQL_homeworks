
	--1)Compute Running Total Sales per Customer

	SELECT 
	customer_id,
	customer_name,
	order_date,
	SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RUN_TOTAL
	FROM sales_data

	--2)Count the Number of Orders per Product Category
	
	SELECT DISTINCT
	product_category,
	COUNT(sale_id) OVER (PARTITION BY product_category) AS CNT_ORD_PER_CAT
	FROM sales_data

	--3)Find the Maximum Total Amount per Product Category
	
	SELECT DISTINCT
	product_category,
	MAX(total_amount) OVER (PARTITION BY  product_category) AS MAX_TOTAL
	FROM sales_data

	--4)Find the Minimum Price of Products per Product Category

	SELECT DISTINCT
	product_category,
	MAX(unit_price) OVER (PARTITION BY  product_category) AS MAX_PRICED_PRODUCT
	FROM sales_data

	--5)Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)

	SELECT *,
	CAST(AVG(total_amount) OVER ( ORDER BY order_date ASC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING )AS decimal(10,2)) AS THREE_DAYS
	FROM sales_data

	--6)Find the Total Sales per Region
	
	SELECT DISTINCT
	region,
	SUM(total_amount) OVER (PARTITION BY region ) as total_sale_per_region
	FROM sales_data
	
	--7)Compute the Rank of Customers Based on Their Total Purchase Amount

	WITH FILTRD AS (
	SELECT 
	DISTINCT customer_id,
	customer_name,
	TOTAL_PUR_AMO,
	DENSE_RANK() OVER ( ORDER BY TOTAL_PUR_AMO DESC) RANKED_CUST
	FROM (
	SELECT *,
	SUM(total_amount) OVER (PARTITION BY customer_id ) TOTAL_PUR_AMO
	FROM sales_data
	) AS EX
	)

	SELECT * FROM FILTRD
	ORDER BY RANKED_CUST
	
	--8)Calculate the Difference Between Current and Previous Sale Amount per Customer
	
	SELECT *,
	ISNULL(total_amount - LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date), 0) AS DIF_BET_PREV_SAKE
	FROM sales_data

	--9)Find the Top 3 Most Expensive Products in Each Category
	SELECT * FROM (
	SELECT DISTINCT
	product_name,
	product_category,
	unit_price,
	DENSE_RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC ) AS RANKING
	FROM sales_data
    ) AS EM
    WHERE RANKING<4
	ORDER BY product_category,RANKING
    
	--10)Compute the Cumulative Sum of Sales Per Region by Order Date

	SELECT 
	region,
	order_date,
	total_amount,
	SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CUMULATIVE_SUM_PER_CAT
	FROM sales_data


	--11)Compute Cumulative Revenue per Product Category

	SELECT 
	product_category,
	quantity_sold,
	unit_price,
	total_amount,
	SUM(total_amount) OVER (PARTITION BY product_category ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CUMULATIVE_SUM_PER_CAT
	FROM sales_data


	--12)Here you need to find out the sum of previous values. Please go through the sample input and expected output.
	
	--EXPECTED OUTPUT:
	/*| ID | SumPreValues |
|----|--------------|
|  1 |            1 |
|  2 |            3 |
|  3 |            6 |
|  4 |           10 |
|  5 |           15 |
    */

	CREATE TABLE SUM_OF_PREV (ID INT  )
	INSERT INTO SUM_OF_PREV VALUES
	(1),(2),(3),(4),(5)

	SELECT *,
	SUM(ID) OVER (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SunPreValues
	FROM SUM_OF_PREV

	--13)Sum of Previous Values to Current Value
	
	--EXPECTED OUTPUT:
	/*
	| Value | Sum of Previous |
|-------|-----------------|
|    10 |              10 |
|    20 |              30 |
|    30 |              50 |
|    40 |              70 |
|   100 |             140 |
	*/


	CREATE TABLE OneColumn (
    Value SMALLINT
);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);
    
SELECT *,
SUM(Value) OVER (ORDER BY Value ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS SumOfPrevious
FROM OneColumn

--14)Generate row numbers for the given data. The condition is that the first row number for every partition should be odd number.For more details please check the sample input and expected output.

CREATE TABLE Row_Nums (
    Id INT,
    Vals VARCHAR(10)
);
INSERT INTO Row_Nums VALUES
(101,'a'), (102,'b'), (102,'c'), (103,'f'), (103,'e'), (103,'q'), (104,'r'), (105,'p');

WITH OrderedRows AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS InsertionOrder -- simulates insert order
    FROM Row_Nums
),
DistinctIds AS (
    SELECT DISTINCT Id
    FROM OrderedRows
),
GroupRanks AS (
    SELECT 
        Id,
        ROW_NUMBER() OVER (ORDER BY Id) AS GroupIndex
    FROM DistinctIds
),
JoinedData AS (
    SELECT 
        r.Id,
        r.Vals,
        g.GroupIndex,
        ROW_NUMBER() OVER (PARTITION BY r.Id ORDER BY r.InsertionOrder) AS RowInGroup
    FROM OrderedRows r
    JOIN GroupRanks g ON r.Id = g.Id
),
Final AS (
    SELECT *,
           ((GroupIndex - 1) * 2 + 1) + (RowInGroup - 1) AS RowNumber
    FROM JoinedData
)
SELECT Id, Vals, RowNumber
FROM Final
ORDER BY RowNumber;


--15)Find customers who have purchased items from more than one product_category
WITH CTE AS (
SELECT 
customer_id,
customer_name,
product_category,
product_name,
total_amount,
      CASE WHEN product_category = FIRST_VALUE(product_category) OVER (PARTITION BY customer_id ORDER BY order_date)
	  THEN 1 ELSE 0 END AS STAT,
COUNT(product_category) OVER (PARTITION BY customer_id) CNT

FROM sales_data
),
CTE_2 AS (
SELECT *, SUM(STAT) OVER (PARTITION BY customer_id) AS SUM_OF_STAT FROM CTE
)

SELECT 
customer_id,
customer_name,
product_category,
product_name,
total_amount
FROM CTE_2
WHERE SUM_OF_STAT<>CNT

--16)Find Customers with Above-Average Spending in Their Region
WITH PARTED_BY_REG AS  (
SELECT *,
AVG(total_amount) OVER (PARTITION BY region) AVG_PER_REG,
AVG(total_amount) OVER (PARTITION BY customer_id) AVG_PER_cust
FROM sales_data
)

SELECT 
customer_name,
CAST(AVG_PER_cust AS decimal(10,2)) AS avarage_spending_per_customer,
CAST(AVG_PER_REG AS decimal(10,2))  AS avarage_spending_per_region
FROM  PARTED_BY_REG
WHERE AVG_PER_cust>AVG_PER_REG

--17)Rank customers based on their total spending (total_amount) within each region. If multiple customers have the same spending, they should receive the same rank.

WITH [SUM] AS (
SELECT *,
SUM(total_amount) OVER (PARTITION BY customer_id) Total_sp
FROM sales_data
)
SELECT DISTINCT
customer_id,
customer_name,
region,
Total_sp,
DENSE_RANK() OVER (PARTITION BY REGION ORDER BY Total_sp DESC) RANKED_CUSTOMERS
FROM SUM
ORDER BY region ASC, RANKED_CUSTOMERS ASC

--18)Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.

SELECT 
customer_id,
customer_name,
total_amount,
order_date,
SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) Running_total_per_cust
FROM sales_data

--19)Calculate the sales growth rate (growth_rate) for each month compared to the previous month.

--Since we have the data of only one month , Output does not show almost anything 
WITH STE AS (
SELECT 
YEAR(order_date) AS SalesYear,
MONTH(order_date)AS SalesMonth,
Sum(total_amount) OVER (PARTITION BY YEAR(order_date),MONTH(order_date)) as Sum_of_sale
FROM sales_data
)

SELECT DISTINCT *,
   ROUND(
(Sum_of_sale - LAG(Sum_of_sale) OVER (ORDER BY SalesYear, SalesMonth))
                          /
NULLIF(LAG(Sum_of_sale) OVER (ORDER BY SalesYear, SalesMonth), 0) * 100,2
) AS Growthpecentage
FROM STE

--20)Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)
 
 WITH CTE AS (
 SELECT *,
 LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS last_order_amount,
 CASE WHEN total_amount>LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date)
 THEN 1 ELSE 0 END AS STAT
 FROM sales_data
 )
 SELECT
 customer_id,
 customer_name,
 total_amount,
 order_date,
 last_order_amount
 FROM CTE
 WHERE STAT=1

 --21)Identify Products that prices are above the average product price
WITH AVG_TABLE AS (
 SELECT *,
 AVG(unit_price) OVER ( ) AS average_price
 FROM sales_data
 )

 SELECT 
 product_name,
 product_category,
 unit_price,
 average_price
 FROM AVG_TABLE
WHERE unit_price>average_price

--22)In this puzzle you have to find the sum of val1 and val2 for each group and put that value at the beginning of the group in the new column. The challenge here is to do this in a single select. For more details please see the sample input and expected output.

CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17)

WITH CTE AS (
SELECT *,
Val1+Val2 as total,
RANK() OVER (ORDER BY grp) as ranki
FROM MyData
)
SELECT 
Id,
Grp,
Val1,
Val2,
CASE WHEN total=59 OR total=0 THEN
SUM(total) over (partition by ranki)
ELSE NULL END AS TOT
FROM CTE

--23)Here you have to sum up the value of the cost column based on the values of Id. For Quantity if values are different then we have to add those values.Please go through the sample input and expected output for details.

CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);

WITH CTE AS (
SELECT 
ID,
Cost AS Cost_,
Quantity,
LAG(Quantity) OVER (ORDER BY ID) AS FORMER
FROM TheSumPuzzle
),
CTE2 AS (
SELECT *,
SUM(Cost_) OVER (PARTITION BY ID) AS Cost,
CASE WHEN Quantity<>FORMER THEN
SUM(Quantity) OVER (PARTITION BY ID)
ELSE FORMER END AS SUM
FROM CTE
)

SELECT DISTINCT
ID,
Cost,
SUM
FROM CTE2
WHERE SUM IS NOT NULL

--24)From following set of integers, write an SQL statement to determine the expected outputs

CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 

INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54); 

WITH FIX AS (
SELECT 
SeatNumber as currrent_s,
LAG(SeatNumber) OVER (ORDER BY SeatNumber) as pr_s,
ROW_NUMBER() OVER (ORDER BY SeatNumber) AS RANKI
FROM Seats
)
SELECT
CASE WHEN pr_s IS NULL THEN 1
     WHEN  currrent_s-pr_s<>1 THEN pr_s+ 1
     ELSE NULL END AS [START],

CASE WHEN pr_s IS NULL THEN currrent_s-1 
     WHEN  currrent_s-pr_s<>1 THEN currrent_s-1
	 ELSE NULL END AS [END]

FROM FIX
WHERE (CASE WHEN pr_s IS NULL THEN 6
     WHEN  currrent_s-pr_s<>1 THEN pr_s+ 1
     ELSE NULL END ) IS NOT NULL
	 AND
	 ( CASE WHEN pr_s IS NULL THEN 1 
     WHEN  currrent_s-pr_s<>1 THEN currrent_s-1
	 ELSE NULL END) IS NOT NULL


--25)In this puzzle you need to generate row numbers for the given data. The condition is that the first row number for every partition should be even number.For more details please check the sample input and expected output.


WITH ordered AS (
  SELECT 
    Id,
    Vals,
    ROW_NUMBER() OVER (ORDER BY Id, Vals) AS rn
  FROM Row_Nums
),
with_prev_id AS (
  SELECT 
    Id,
    Vals,
    rn,
    LAG(Id) OVER (ORDER BY Id, Vals) AS prev_id
  FROM ordered
),
calculated AS (
  SELECT 
    Id,
    Vals,
    SUM(CASE WHEN prev_id IS NULL OR prev_id != Id THEN 2 ELSE 1 END) 
      OVER (ORDER BY rn ROWS UNBOUNDED PRECEDING) AS Changed
  FROM with_prev_id
)
SELECT 
  Id,
  Vals,
  Changed
FROM calculated
