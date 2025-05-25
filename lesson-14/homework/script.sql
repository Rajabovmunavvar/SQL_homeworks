--1)Write a SQL query to split the Name column by a comma into two separate columns: Name and Surname.(TestMultipleColumns)

SELECT
Id,
SUBSTRING(Name,1,CHARINDEX(',',Name )-1) AS Name ,
SUBSTRING(Name,CHARINDEX(',',Name)+1,LEN(NAME)) AS Surname
FROM TestMultipleColumns

--2)Write a SQL query to find strings from a table where the string itself contains the % character.(TestPercent)


--FIRST METHOD(LIKE):SIMPLE
SELECT * FROM TestPercent
WHERE Strs LIKE '%[%]%'


--SECOND METHOD: LENS AND REPLACE

SELECT 
*
FROM TestPercent
WHERE LEN(Strs)-LEN(REPLACE(Strs,'%',''))>=1

--THIRD METHOD:  CHARINDEX (SQL Server)

SELECT 
*
FROM TestPercent
WHERE CHARINDEX('%',Strs)>0


--3)In this puzzle you will have to split a string based on dot(.).(Splitter)


SELECT 
    s.Id,
    f.value AS Part
FROM Splitter s
CROSS APPLY STRING_SPLIT(Vals, '.') f;



--4)Write a SQL query to replace all integers (digits) in the string with 'X'.(1234ABC123456XYZ1234567890ADS)

DECLARE @input VARCHAR(100) = '1234ABC123456XYZ1234567890ADS';
DECLARE @result VARCHAR(100) = '';
DECLARE @i INT = 1;

WHILE @i <= LEN(@input)
BEGIN
    SET @result = @result + 
        CASE WHEN SUBSTRING(@input, @i, 1) LIKE '[0-9]' 
             THEN 'X' 
             ELSE SUBSTRING(@input, @i, 1) 
        END;
    SET @i = @i + 1;
END

SELECT @input AS OriginalString, @result AS MaskedString;

--5)Write a SQL query to return all rows where the value in the Vals column contains more than two dots (.).(testDots)


SELECT
Vals
FROM testDots
WHERE LEN(Vals)-LEN(REPLACE(Vals,'.',''))>2


--6)Write a SQL query to count the spaces present in the string.(CountSpaces)
SELECT * FROM CountSpaces

SELECT 
LEN(texts)-LEN(REPLACE(texts,' ','')) NUMBER_OF_SPACES
FROM CountSpaces

--7)write a SQL query that finds out employees who earn more than their managers.(Employees)


SELECT 
E.EMPLOYEE_ID AS EMP_ID,
E.FIRST_NAME AS EMP_NAM,
E.SALARY AS EMP_SAL,
E.MANAGER_ID AS MAN_ID,
M.EMPLOYEE_ID AS MANAG_ID,
M.FIRST_NAME AS MAN_NAM,
M.SALARY AS MAN_SAL
FROM Employees AS E
INNER JOIN Employees AS M
ON E.MANAGER_ID=M.EMPLOYEE_ID
WHERE E.SALARY>M.SALARY


--8)Find the employees who have been with the company for more than 10 years, but less than 15 years. Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service (calculated as the number of years between the current date and the hire date).(Employees)
SELECT * FROM Employees

SELECT 
EMPLOYEE_ID,
FIRST_NAME,
LAST_NAME,
HIRE_DATE,
CONCAT(DATEDIFF(YEAR,HIRE_DATE,GETDATE()),' YEARS') AS Years_of_exp
FROM Employees
WHERE DATEDIFF(YEAR,HIRE_DATE,GETDATE()) BETWEEN 11 AND 14


--MEDIUM TASK:

--1)Write a SQL query to separate the integer values and the character values into two different columns.(rtcfvty34redt)


DECLARE @test_string VARCHAR(100) = 'rtcfvty34redt';

-- Letters only: Replace all numbers with empty space
SELECT REPLACE(TRANSLATE(@test_string, '0123456789', '          '), ' ', '') 
AS LettersOnly;

-- Numbers only: Replace all letters with empty space
SELECT REPLACE(TRANSLATE(@test_string, 'abcdefghijklmnopqrstuvwxyz', '                          '), ' ', '') 
AS NumbersOnly;

--2)write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.(weather)
SELECT 
    w1.Id,
	w1.RecordDate,
	w1.Temperature,
	w2.Id,
	w2.RecordDate,
	w2.Temperature
FROM 
    Weather w1
JOIN 
    Weather w2 
    ON DATEADD(DAY, 1, w2.RecordDate) = w1.RecordDate
where w1.Temperature>w2.Temperature

--3)Write an SQL query that reports the first login date for each player.(Activity)
SELECT * FROM Activity

SELECT 
player_id,
MIN(event_date)
FROM Activity  
GROUP BY player_id

--4)Your task is to return the third item from that list.(fruits)


SELECT 
SP_F.value AS THIRD_ITEM
FROM fruits
CROSS APPLY string_split(fruit_list,',',1) AS SP_F
WHERE ordinal=3

--5)Write a SQL query to create a table where each character from the string will be converted into a row.(sdgfhsdgfhs@121313131)
CREATE TABLE Chars (
    Id INT IDENTITY(1,1),
    Character CHAR(1)
);

-- 2. Declare the input string
DECLARE @THESTRING VARCHAR(50) = 'sdgfhsdgfhs@121313131';

-- 3. Use a Tally table (numbers generator) to extract each character and insert
WITH Tally AS (
    SELECT TOP (LEN(@THESTRING))
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO Chars (Character)
SELECT SUBSTRING(@THESTRING, n, 1)
FROM Tally
WHERE n <= LEN(@THESTRING);

-- 4. View the result
SELECT * FROM Chars;



--6)You are given two tables: p1 and p2. Join these tables on the id column. The catch is: when the value of p1.code is 0, replace it with the value of p2.code.(p1,p2)
SELECT * FROM p1
SELECT * FROM p2

SELECT 
p1.id AS P1_ID,
case when p1.code=0 THEN p2.code 
       ELSE p1.code END  AS P1_CODE,
p2.id AS P2_ID,
p2.id AS P2_CODE
FROM p1 
INNER JOIN p2
ON p1.id=p2.id


--7)Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. The stages are defined as follows:
--If the employee has worked for less than 1 year → 'New Hire'
--If the employee has worked for 1 to 5 years → 'Junior'
--If the employee has worked for 5 to 10 years → 'Mid-Level'
--If the employee has worked for 10 to 20 years → 'Senior'
--If the employee has worked for more than 20 years → 'Veteran'(Employees)


SELECT 
EMPLOYEE_ID,
FIRST_NAME,
LAST_NAME,
HIRE_DATE,
CASE WHEN YEAR(GETDATE())-YEAR(HIRE_DATE)<1 THEN 'New Hire'
     WHEN YEAR(GETDATE())-YEAR(HIRE_DATE) BETWEEN 1 AND 5 THEN 'Junior'
	 WHEN YEAR(GETDATE())-YEAR(HIRE_DATE) BETWEEN 5 AND 10 THEN 'Mid-Level'
	 WHEN YEAR(GETDATE())-YEAR(HIRE_DATE) BETWEEN 10 AND 20 THEN 'Senior'
	 ELSE 'Veteran' END AS STATUS

FROM Employees


--8)Write a SQL query to extract the Яvalue that appears at the start of the string in a column named Vals.
WITH ExtractedNumbers AS (
    SELECT 
        Id,
        Vals,
        CASE
            WHEN Vals LIKE '[0-9]%' THEN 
                SUBSTRING(Vals, 1, PATINDEX('%[^0-9]%', Vals+' ') - 1)
            ELSE NULL
        END AS LeadingInteger
    FROM GetIntegers
)
SELECT * FROM ExtractedNumbers
WHERE LeadingInteger IS NOT NULL;

--HARD TASKS:

--1)In this puzzle you have to swap the first two letters of the comma separated string.(MultipleVals)

WITH SplitData AS (
    SELECT 
        id,
        Vals,
        -- Extract first value (before first comma)
        LEFT(Vals, CHARINDEX(',', Vals + ',') - 1) AS first_val,
        -- Extract second value (between first and second commas)
        SUBSTRING(
            Vals, 
            CHARINDEX(',', Vals) + 1, 
            CHARINDEX(',', Vals + ',', CHARINDEX(',', Vals) + 1) - CHARINDEX(',', Vals) - 1
        ) AS second_val,
        -- Extract remaining values (after second comma)
        STUFF(Vals, 1, 
              CHARINDEX(',', Vals + ',', CHARINDEX(',', Vals) + 1), '') AS rest_vals
    FROM MultipleVals
    GROUP BY id, Vals  -- Remove duplicates if needed
)
SELECT 
    id,
    Vals AS OriginalVals,
    -- Rebuild string with swapped first two values
    second_val + ',' + first_val + 
    CASE WHEN rest_vals = '' THEN '' ELSE ',' + rest_vals END AS SwappedVals
FROM SplitData;

--2)Write a SQL query that reports the device that is first logged in for each player.(Activity)
SELECT * FROM Activity
 
 WITH FIR AS (
SELECT 
player_id,
MIN(event_date) as firstg
FROM Activity  
GROUP BY player_id
)

SELECT FIR.player_id,
Activity.device_id
FROM FIR,Activity
WHERE Activity.event_date=firstg



--3)You are given a sales table. Calculate the week-on-week percentage of sales per area for each financial week. For each week, the total sales will be considered 100%, and the percentage sales for each day of the week should be calculated based on the area sales for that week.(WeekPercentagePuzzle)

WITH WeeklyTotals AS (
    SELECT 
        Area,
        FinancialYear,
        FinancialWeek,
        SUM(ISNULL(SalesLocal, 0) + ISNULL(SalesRemote, 0)) AS TotalWeekSales
    FROM WeekPercentagePuzzle
    GROUP BY Area, FinancialYear, FinancialWeek
),
DailySales AS (
    SELECT 
        w.Area,
        w.Date,
        w.DayName,
        w.FinancialWeek,
        w.FinancialYear,
        ISNULL(w.SalesLocal, 0) + ISNULL(w.SalesRemote, 0) AS DaySales,
        t.TotalWeekSales
    FROM WeekPercentagePuzzle w
    JOIN WeeklyTotals t ON w.Area = t.Area 
                       AND w.FinancialYear = t.FinancialYear
                       AND w.FinancialWeek = t.FinancialWeek
)
SELECT 
    d.Area,
    d.FinancialYear,
    d.FinancialWeek,
    d.Date,
    d.DayName,
    d.TotalWeekSales,
    d.DaySales,
    CASE 
        WHEN d.TotalWeekSales = 0 THEN NULL
        ELSE CAST(ROUND(d.DaySales * 100.0 / d.TotalWeekSales, 2) AS DECIMAL(5,2))
    END AS PercentageOfWeek
FROM DailySales d
ORDER BY d.Area, d.FinancialYear, d.FinancialWeek, d.Date;
