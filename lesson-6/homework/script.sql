CREATE TABLE InputTbl ( 
col1 VARCHAR(10),
col2 VARCHAR(10)
); 
GO
INSERT INTO InputTbl (col1, col2) VALUES 
('a', 'b'),
('a', 'b'),
('b', 'a'),
('c', 'd'), 
('c', 'd'), 
('m', 'n'),
('n', 'm');

--1)
--Aproach no 1
SELECT DISTINCT
    CASE WHEN col1 < col2 THEN col1 ELSE col2 END AS col1,
    CASE WHEN col1 < col2 THEN col2 ELSE col1 END AS col2
FROM InputTbl;

--Aproach no 2

SELECT DISTINCT
    LEAST(col1, col2) AS col1,
    GREATEST(col1, col2) AS col2
FROM InputTbl;

--Both of these approaches will:

--First normalize each pair so the smaller value is always in col1

--Then apply DISTINCT to these normalized pairs

--Return your desired result where ('a','b') and ('b','a') are treated as the same pair



--2)
CREATE TABLE TestMultipleZero (
A INT NULL,
B INT NULL, 
C INT NULL,
D INT NULL
);

INSERT INTO TestMultipleZero(A,B,C,D) VALUES
(0,0,0,1),
(0,0,1,0), 
(0,1,0,0), 
(1,0,0,0),
(0,0,0,0),
(1,1,1,0)
;

--First Aproach
SELECT *
FROM TestMultipleZero
WHERE A<>0
OR B<>0
OR C<>0
OR D<>0

--Second alternative way:
--Using SUM of columns (compact but less readable):

SELECT A, B, C, D
FROM TestMultipleZero
WHERE (A + B + C + D) <> 0;


--3)

CREATE TABLE section1(
id int,
name varchar(20)
) 

GO
INSERT INTO section1 values 
(1, 'Been'), 
(2, 'Roma'),
(3, 'Steven'),
(4, 'Paulo'), 
(5, 'Genryh'),
(6, 'Bruno'), 
(7, 'Fred'),
(8, 'Andro')


--First method; Basic MOD Operator Method

SELECT *
FROM section1
WHERE id % 2 = 1;

--How it works:

--The modulus operator % gives the remainder after division

--When you divide any integer by 2:

--Even numbers divide evenly (remainder = 0)

--Odd numbers have remainder = 1


--Second method ; Bitwise AND Method (&) which is the  fastest

SELECT *
FROM  section1
WHERE id & 1 = 1;


--How it works:

--Looks at the binary representation of numbers

--All odd numbers have their least significant bit (rightmost bit) set to 1

--The & 1 operation masks all bits except the last one


--4)

SELECT TOP (1) * -- The TOP 1 clause then returns just that first (smallest) record
FROM section1
ORDER BY ID ASC ;  -- Sort by ID in ascending order (smallest to largest)


--5)

SELECT TOP (1) * -- The TOP 1 clause then returns just that first (highest) record
FROM section1
ORDER BY ID DESC ; -- Sort by ID in ascending order (largest to smallest)


--6)

SELECT * 
FROM section1
WHERE name like 'b%'      -- LIKE 'B%' means: starts with B followed by any characters


--7)


CREATE TABLE ProductCodes (
Code VARCHAR(20)
);

GO 
INSERT INTO ProductCodes (Code) VALUES
('X-123'),
('X_456'),
('X#789'),
('X-001'),
('X%202'), 
('X_ABC'), 
('X#DEF'),
('X-999');

--FIRST METHOD ; Square Bracket Syntax which is more simple and afficient
SELECT * FROM ProductCodes
WHERE Code LIKE '%[_]%'
 
 --OR

-- SECOND METHOD ; ESCAPE Method
--This query finds rows where the 'code' column contains an underscore
--The ESCAPE clause specifies that we're using '\' as our escape character
--'\_' means we want to match a literal underscore
--'%\_%' matches any string containing an underscore

SELECT *
FROM ProductCodes
WHERE code LIKE '%\_%' ESCAPE '\';
