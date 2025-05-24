
--1)You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that format using employees table.


SELECT 
CONCAT(EMPLOYEE_ID,'-',FIRST_NAME,' ',LAST_NAME)
FROM Employees

--2)Update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'

SELECT
REPLACE(PHONE_NUMBER,'124','999')
FROM Employees

--3)hat displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.(Employees)

SELECT 
    FIRST_NAME AS "First Name",
    LEN(FIRST_NAME) AS "Name Length"
FROM 
    Employees
WHERE 
    SUBSTRING(FIRST_NAME, 1, 1) IN ('A', 'J', 'M')
ORDER BY 
    FIRST_NAME;



--4)Write an SQL query to find the total salary for each manager ID.(Employees table)
select * from Employees

SELECT 
M.EMPLOYEE_ID AS MANAGER_ID ,
SUM(E.SALARY) AS TOTAL_SAL_PER_MAN
FROM Employees E
INNER JOIN Employees M
ON M.EMPLOYEE_ID=E.MANAGER_ID
GROUP BY M.EMPLOYEE_ID


--5)Write a query to retrieve the year and the highest value from the columns Max1, Max2, and Max3 for each row in the TestMax table

SELECT 
    Year1,
    GREATEST(max1, max2, max3) AS Highest_Value
FROM 
    TestMax
ORDER BY 
    Year1;



--6)Find me odd numbered movies and description is not boring.(cinema)


SELECT 
*
FROM cinema
WHERE id % 2 = 1              -- Odd ID numbers
  AND description != 'boring' -- Exclude boring movies
ORDER BY rating DESC;         -- Highest rated first



--7)You have to sort data based on the Id but Id with 0 should always be the last row. Now the question is can you do that with a single order by column.(SingleOrder)


SELECT 
*
FROM SingleOrder
ORDER BY
 CASE WHEN Id=0 THEN 1
 ELSE 0 END ;


 --8)Write an SQL query to select the first non-null value from a set of columns. If the first column is null, move to the next, and so on. If all columns are null, return null.(person)

 SELECT id,
 COALESCE(ssn,passportid,itin) AS FIRST_NON_NULL_VAL
 FROM person

--MEDIUM TASKS;

 --1)Split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)

SELECT 
  FullName,

  -- Firstname: From start to first space
  SUBSTRING(FullName, 1, CHARINDEX(' ', FullName) - 1) AS Firstname,

  -- Middlename: Between first and second space
  SUBSTRING(
    FullName,
    CHARINDEX(' ', FullName) + 1, --Starting from after the fist space
    CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1) - CHARINDEX(' ', FullName) - 1
  ) AS Middlename,

  -- Lastname: From second space to end
  SUBSTRING(
    FullName,
    CHARINDEX(' ', FullName, CHARINDEX(' ', FullName)+1) + 1,
    LEN(FullName)
  ) AS Lastname,

  Grade

FROM Students;


--2)For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas. (Orders Table)


SELECT *
FROM Orders o
WHERE o.DeliveryState = 'TX'
  AND o.CustomerID IN (
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE DeliveryState = 'CA'
  );


  --alternative method:

  WITH CustomersWithCA AS (
  SELECT DISTINCT CustomerID
  FROM Orders
  WHERE DeliveryState = 'CA'
)
SELECT *
FROM Orders
WHERE DeliveryState = 'TX'
  AND CustomerID IN (SELECT CustomerID FROM CustomersWithCA);


 --3)Write an SQL statement that can group concatenate the following values.(DMLTable)

SELECT 
    STRING_AGG(STRING, ' ') WITHIN GROUP (ORDER BY SequenceNumber) AS reconstructed_query
FROM DMLTable;

--4)Find all employees whose names (concatenated first and last) contain the letter "a" at least 3 times


SELECT
CONCAT(FIRST_NAME,' ',LAST_NAME) AS FULLNAME
FROM Employees
WHERE LEN(CONCAT(FIRST_NAME,' ',LAST_NAME))-
LEN(REPLACE(CONCAT(FIRST_NAME,' ',LAST_NAME),'a',''))>=3


--5)The total number of employees in each department and the percentage of those employees who have been with the company for more than 3 years(Employees)


SELECT 
DEPARTMENT_ID,
COUNT(EMPLOYEE_ID) AS TOTAL_NUM_OF_EMP,
  ROUND(
        SUM(CASE WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 3 THEN 1 ELSE 0 END) * 100 / 
        COUNT(*), 
        2
    ) AS percentage_over_3_years
FROM Employees
GROUP BY DEPARTMENT_ID



--6)Write an SQL statement that determines the most and least experienced Spaceman ID by their job description.(Personal)
SELECT * FROM Personal


WITH RankedExperience AS (
    SELECT 
        SpacemanID,
        JobDescription,
        MissionCount,
        RANK() OVER (PARTITION BY JobDescription ORDER BY MissionCount DESC) AS rank_most_experienced,
        RANK() OVER (PARTITION BY JobDescription ORDER BY MissionCount ASC) AS rank_least_experienced
    FROM Personal
)
SELECT 
    JobDescription,
    MAX(CASE WHEN rank_most_experienced = 1 THEN SpacemanID END) AS most_experienced_id,
    MAX(CASE WHEN rank_least_experienced = 1 THEN SpacemanID END) AS least_experienced_id
FROM RankedExperience
GROUP BY JobDescription;


--DIFFICULT TASKS:

--1)Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters from the given string 'tf56sd#%OqH' into separate columns.


-- Create a numbers table to split the string
WITH Numbers AS (
    SELECT TOP (LEN('tf56sd#%OqH')) 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM master.dbo.spt_values
    WHERE type = 'P'
),
-- Split the string into individual characters
StringChars AS (
    SELECT 
        SUBSTRING('tf56sd#%OqH', n, 1) AS char
    FROM Numbers
    WHERE n <= LEN('tf56sd#%OqH')
)
-- Categorize and aggregate the characters
SELECT 
    (SELECT STRING_AGG(char, '') 
     FROM StringChars 
     WHERE char LIKE '[A-Z]') AS uppercase_letters,
    
    (SELECT STRING_AGG(char, '') 
     FROM StringChars 
     WHERE char LIKE '[a-z]') AS lowercase_letters,
    
    (SELECT STRING_AGG(char, '') 
     FROM StringChars 
     WHERE char LIKE '[0-9]') AS numbers,
    
    (SELECT STRING_AGG(char, '') 
     FROM StringChars 
     WHERE char NOT LIKE '[A-Za-z0-9]') AS other_characters;



--2)Write an SQL query that replaces each row with the sum of its value and the previous rows' value. (Students table)


SELECT 
    s1.StudentID,
    s1.FullName,
    (SELECT SUM(s2.Grade) 
     FROM Students s2 
     WHERE s2.StudentID <= s1.StudentID) AS Grade
FROM 
    Students s1
ORDER BY 
    s1.StudentID;


--3)You are given the following table, which contains a VARCHAR column that contains mathematical equations. Sum the equations and provide the answers in the output.(Equations)
WITH ExpressionParser AS (
    -- Anchor member
    SELECT 
        Equation,
        CAST('' AS VARCHAR(1)) AS current_op,
        CAST('' AS VARCHAR(50)) AS number,        -- Ensure consistent type
        1 AS pos,
        0 AS running_total
    FROM Equations

    UNION ALL

    -- Recursive member
    SELECT
        ep.Equation,
        CAST(
            CASE 
                WHEN SUBSTRING(Equation, pos, 1) IN ('+', '-') THEN SUBSTRING(Equation, pos, 1)
                ELSE current_op
            END AS VARCHAR(1)
        ) AS current_op,
        CAST(
            CASE 
                WHEN SUBSTRING(Equation, pos, 1) BETWEEN '0' AND '9' THEN 
                    number + SUBSTRING(Equation, pos, 1)
                ELSE ''
            END AS VARCHAR(50)
        ) AS number,
        pos + 1,
        CASE 
            WHEN SUBSTRING(Equation, pos, 1) IN ('+', '-') OR pos > LEN(Equation) THEN
                running_total + 
                CASE current_op 
                    WHEN '+' THEN CAST(number AS INT)
                    WHEN '-' THEN -CAST(number AS INT)
                    WHEN ''  THEN CAST(number AS INT)
                END
            ELSE running_total
        END AS running_total
    FROM ExpressionParser ep
    WHERE pos <= LEN(Equation) + 1
)

-- Final SELECT
SELECT
    Equation,
    MAX(
        running_total + 
        CASE current_op 
            WHEN '+' THEN CAST(number AS INT)
            WHEN '-' THEN -CAST(number AS INT)
            WHEN ''  THEN CAST(number AS INT)
        END
    ) AS TotalSum
FROM ExpressionParser
GROUP BY Equation
ORDER BY Equation;


--4)Given the following dataset, find the students that share the same birthday.(Student Table)


SELECT 
    Birthday,
    STRING_AGG(StudentName, ', ') AS StudentsSharingBirthday,
    COUNT(*) AS NumberOfStudents
FROM 
    Student
GROUP BY 
    Birthday
HAVING 
    COUNT(*) > 1
ORDER BY 
    Birthday;


--5)You have a table with two players (Player A and Player B) and their scores. If a pair of players have multiple entries, aggregate their scores into a single row for each unique pair of players. Write an SQL query to calculate the total score for each unique player pair(PlayerScores)
select * from PlayerScores


SELECT 
    CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END AS Player1,
    CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END AS Player2,
    SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY 
    CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END,
    CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END
ORDER BY Player1, Player2;
