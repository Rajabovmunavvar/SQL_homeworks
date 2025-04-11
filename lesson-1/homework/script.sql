
-- 1)
 
-- Data is raw facts, figures, or symbols that represent information about objects, events, or ideas that can be proccesed to get useful inforamation 
-- A database is an organized collection of data, typically stored electronically, that can be easily accessed, managed, and updated
-- A relational database organizes data into structured tables (like spreadsheets) that can be linked together using relationships.
-- A table is a structured set of data organized into rows (records) and columns (fields)

--2)

--Five key features of SQL Server are relational database management, data warehousing, big data capabilities, high availability, and intelligent query processing

--3)
-- Windows Authentication
--SQL Server Authentication

--4)
create database SchoolDB

USE SchoolDB
--5)
create table Students (StudentID INT PRIMARY KEY,
NAME VARCHAR(50),
AGE INT )
--6)
--SQL Server = Microsoft's database engine (stores/manages data).
--SSMS = Free GUI tool to manage SQL Server (run queries, design tables).
--SQL = Standard language to interact with databases (e.g., SELECT).

--7)
-- DQL (Query) – SELECT (read data).
--DML (Modify) – INSERT, UPDATE, DELETE (edit data).
--DDL (Structure) – CREATE, ALTER, DROP (manage tables).
--DCL (Access) – GRANT, REVOKE (control permissions).
--TCL (Transactions) – COMMIT, ROLLBACK (ensure data integrity).

--8)
INSERT INTO Students (StudentID,NAME,AGE) VALUES

(2,'MURODJON',18),
(3,'PIRIMQUL',38),
(4,'GUMDONBEK',14)

SELECT * FROM Students

--9)
-- Right-click SchoolDB > Tasks > Back Up > Choose location
--Right-click Databases > Restore > S
