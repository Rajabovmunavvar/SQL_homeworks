CREATE DATABASE lesson_12_homework
use lesson_12_homework


--1)Combine Two Tables

--EXPECTED OUTPUT:

/*
| firstName | lastName | city          | state    |
+-----------+----------+---------------+----------+
| Allen     | Wang     | Null          | Null     |
| Bob       | Alice    | New York City | New York |
*/

Create table Person (personId int, firstName varchar(255), lastName varchar(255))
Create table Address (addressId int, personId int, city varchar(255), state varchar(255))
Truncate table Person
insert into Person (personId, lastName, firstName) values ('1', 'Wang', 'Allen')
insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob')
Truncate table Address
insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York')
insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California')


SELECT 
P.firstName,
P.lastName,
A.city,
A.state
FROM Person AS P
LEFT JOIN Address AS A
ON P.personId=A.personId



--2)Employees Earning More Than Their Managers



Create table Employee (id int, name varchar(255), salary int, managerId int)
Truncate table Employee
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3')
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4')
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', NULL)
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', NULL)

SELECT 
EMP.name
FROM Employee AS EMP
INNER JOIN Employee AS MAN
ON EMP.managerId=MAN.id
WHERE EMP.salary>MAN.salary


--3) Find Duplicate Emails

Create table Person (id int, email varchar(255))
Truncate table Person 
insert into Person (id, email) values ('1', 'a@b.com')
insert into Person (id, email) values ('2', 'c@d.com') 
insert into Person (id, email) values ('3', 'a@b.com')

SELECT 
email
FROM Person
GROUP BY email
HAVING COUNT(*)>1

--4)Delete Duplicate Emails
DROP TABLE Person
Create table Person (id int, email varchar(255))
Truncate table Person 
insert into Person (id, email) values('1', 'a@b.com')
insert into Person (id, email) values('2', 'c@d.com') 
insert into Person (id, email) values('3', 'a@b.com')

WITH ranked_duplicates AS (
    SELECT
        id,
        email,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS rn  --by ranking the ids we can we keep one record and delete the dublicate 
    FROM Person
)
DELETE FROM Person
WHERE  id IN (
    SELECT id
    FROM ranked_duplicates
    WHERE rn > 1
);

SELECT * FROM Person


--5)Find those parents who has only girls.

CREATE TABLE boys (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

CREATE TABLE girls (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

INSERT INTO boys (Id, name, ParentName) 
VALUES 
(1, 'John', 'Michael'),  
(2, 'David', 'James'),   
(3, 'Alex', 'Robert'),   
(4, 'Luke', 'Michael'),  
(5, 'Ethan', 'David'),    
(6, 'Mason', 'George');  


INSERT INTO girls (Id, name, ParentName) 
VALUES 
(1, 'Emma', 'Mike'),  
(2, 'Olivia', 'James'),  
(3, 'Ava', 'Robert'),    
(4, 'Sophia', 'Mike'),  
(5, 'Mia', 'John'),      
(6, 'Isabella', 'Emily'),
(7, 'Charlotte', 'George');

Select DISTINCT
girls.ParentName 
FROM girls
LEFT JOIN boys
ON girls.ParentName=boys.ParentName
WHERE boys.Id IS NULL

--6)
SELECT 
    CustomerID,
    SUM(SalesAmount) AS Total_Sales_Over_50,
    MIN(Weight) AS Least_Weight
FROM Sales.Orders
WHERE Weight > 50
GROUP BY CustomerID
UNION
SELECT 
    CustomerID,
    0 AS Total_Sales_Over_50,
    MIN(Weight) AS Least_Weight
FROM Sales.Orders
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID 
    FROM Sales.Orders 
    WHERE Weight > 50
)
GROUP BY CustomerID
ORDER BY CustomerID;

--7)
--EXPECTED OUTPUT:
/*
| Item Cart 1 | Item Cart 2 |  
|-------------|-------------|  
| Sugar       | Sugar       | 
| Bread       | Bread       |  
| Juice       |             |  
| Soda        |             |  
| Flour       |             |
|             | Butter      |  
|             | Cheese      |  
|             | Fruit       |
*/
DROP TABLE IF EXISTS Cart1;
DROP TABLE IF EXISTS Cart2;
GO

CREATE TABLE Cart1
(
Item  VARCHAR(100) PRIMARY KEY
);
GO

CREATE TABLE Cart2
(
Item  VARCHAR(100) PRIMARY KEY
);
GO

INSERT INTO Cart1 (Item) VALUES
('Sugar'),('Bread'),('Juice'),('Soda'),('Flour');
GO

INSERT INTO Cart2 (Item) VALUES
('Sugar'),('Bread'),('Butter'),('Cheese'),('Fruit');
GO


SELECT 
ISNULL(Cart1.Item,' ') AS Cart1,
ISNULL(Cart2.Item,' ') AS Cart2
FROM Cart1
FULL JOIN Cart2
ON Cart1.Item=Cart2.Item
ORDER BY CASE WHEN Cart1.Item=Cart2.Item THEN 1
         END DESC,Cart2.Item


--8)Customers Who Never Order

Create table Customers (id int, name varchar(255))
Create table Orders (id int, customerId int)
Truncate table Customers
insert into Customers (id, name) values ('1', 'Joe')
insert into Customers (id, name) values ('2', 'Henry')
insert into Customers (id, name) values ('3', 'Sam')
insert into Customers (id, name) values ('4', 'Max')
Truncate table Orders
insert into Orders (id, customerId) values ('1', '3')
insert into Orders (id, customerId) values ('2', '1')

--SOLUTION:
SELECT C.name AS Customers
FROM Customers AS C
LEFT JOIN Orders AS O
ON C.id=O.customerId
WHERE O.id IS  NULL


--9)Students and Examinations


Create table Students (student_id int, student_name varchar(20))
Create table Subjects (subject_name varchar(20))
Create table Examinations (student_id int, subject_name varchar(20))
Truncate table Students
insert into Students (student_id, student_name) values ('1', 'Alice')
insert into Students (student_id, student_name) values ('2', 'Bob')
insert into Students (student_id, student_name) values ('13', 'John')
insert into Students (student_id, student_name) values ('6', 'Alex')
Truncate table Subjects
insert into Subjects (subject_name) values ('Math')
insert into Subjects (subject_name) values ('Physics')
insert into Subjects (subject_name) values ('Programming')
Truncate table Examinations
insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Programming')
insert into Examinations (student_id, subject_name) values ('2', 'Programming')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Programming')
insert into Examinations (student_id, subject_name) values ('13', 'Physics')
insert into Examinations (student_id, subject_name) values ('2', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Math')


SELECT 
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
    ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;

