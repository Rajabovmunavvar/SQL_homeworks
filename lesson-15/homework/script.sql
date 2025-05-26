--1)Task: Retrieve employees who earn the minimum salary in the company. Tables: employees (columns: id, name, salary)

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

--SOLUTION:

SELECT * FROM employees
WHERE salary=(
SELECT MIN(salary) from employees) --FINDING THE MINIMUM SALARY


--2)Task: Retrieve products priced above the average price. Tables: products (columns: id, product_name, price)

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO products (id, product_name, price) VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 400),
(3, 'Smartphone', 800),
(4, 'Monitor', 300);

--SOLUTION:

SELECT * FROM products
WHERE price>(
SELECT AVG(price) FROM products) --FINDING AVARAGE PRICE 


--3)Find Employees in Sales Department Task: Retrieve employees who work in the "Sales" department. Tables: employees (columns: id, name, department_id), departments (columns: id, department_name)

CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);
DROP TABLE IF EXISTS employees
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'Sales'),
(2, 'HR');

INSERT INTO employees (id, name, department_id) VALUES
(1, 'David', 1),
(2, 'Eve', 2),
(3, 'Frank', 1);


--SOLUTION:
SELECT *,
(SELECT id FROM departments AS DEP WHERE DEP.id=employees.department_id) AS DEP_ID,
(SELECT department_name FROM departments AS DEP WHERE DEP.id=employees.department_id) AS DEP_name
FROM employees 
WHERE (SELECT department_name FROM departments AS DEP WHERE DEP.id=employees.department_id)='Sales'

--4)Task: Retrieve customers who have not placed any orders. Tables: customers (columns: customer_id, name), orders (columns: order_id, customer_id)

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, name) VALUES
(1, 'Grace'),
(2, 'Heidi'),
(3, 'Ivan');

INSERT INTO orders (order_id, customer_id) VALUES
(1, 1),
(2, 1);



--FIRST METHOD:
SELECT DISTINCT
c.customer_id,
c.name
FROM customers  as c
cross join orders as o
where o.customer_id<>c.customer_id


--Second Method:
SELECT 
C.customer_id,
C.name

FROM customers AS C
where C.customer_id<>(SELECT DISTINCT customer_id from orders as o where c.customer_id<>o.customer_id)

--5)Task: Retrieve products with the highest price in each category. Tables: products (columns: id, product_name, price, category_id)

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Tablet', 400, 1),
(2, 'Laptop', 1500, 1),
(3, 'Headphones', 200, 2),
(4, 'Speakers', 300, 2);

--SOLUTION:
SELECT 
p1.category_id,
(
SELECT 
MAX(price)
FROM products as p2 where p1.category_id=p2.category_id) as max_price_per_category
FROM products p1
GROUP BY category_id

--6)Task: Retrieve employees working in the department with the highest average salary. Tables: employees (columns: id, name, salary, department_id), departments (columns: id, department_name)

CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'IT'),
(2, 'Sales');

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Jack', 80000, 1),
(2, 'Karen', 70000, 1),
(3, 'Leo', 60000, 2);


--SOLUTION:
;WITH AVG_SAL_TABLE AS (
SELECT department_id,
AVG(salary) as avg_sal_per_dep
FROM employees 
GROUP BY department_id
)

SELECT * FROM employees
WHERE employees.department_id IN(
  SELECT department_id from AVG_SAL_TABLE 
  WHERE
    AVG_SAL_TABLE.avg_sal_per_dep=(
	SELECT MAX(avg_sal_per_dep) FROM AVG_SAL_TABLE)
	) 



--7)Task: Retrieve employees earning more than the average salary in their department. Tables: employees (columns: id, name, salary, department_id)

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Mike', 50000, 1),
(2, 'Nina', 75000, 1),
(3, 'Olivia', 40000, 2),
(4, 'Paul', 55000, 2);

--SOLUTION:
;WITH AVG_TABLE AS (
SELECT 
department_id,
AVG(salary) AS avg_sal_per_dep
FROM employees
GROUP BY department_id
)

SELECT 
E.id,
E.name,
E.salary,
e.department_id
FROM employees E
WHERE  E.Salary>(SELECT avg_sal_per_dep FROM AVG_TABLE WHERE department_id=E.department_id)



--8)Task: Retrieve students who received the highest grade in each course. Tables: students (columns: student_id, name), grades (columns: student_id, course_id, grade)

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE grades (
    student_id INT,
    course_id INT,
    grade DECIMAL(4, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (student_id, name) VALUES
(1, 'Sarah'),
(2, 'Tom'),
(3, 'Uma');

INSERT INTO grades (student_id, course_id, grade) VALUES
(1, 101, 95),
(2, 101, 85),
(3, 102, 90),
(1, 102, 80);


--SOLUTION:
;WITH PERCORSE AS(
SELECT 
course_id,
MAX(grade) AS MAX_G
FROM grades
GROUP BY course_id
)

SELECT 
S.student_id,
(SELECT name from students where student_id=s.student_id) as studentNAME,
S.course_id,
S.grade
FROM grades AS S
WHERE S.course_id IN(SELECT course_id FROM PERCORSE)
AND S.grade IN(SELECT MAX_G FROM PERCORSE)


--9)Find Third-Highest Price per Category Task: Retrieve products with the third-highest price in each category. Tables: products (columns: id, product_name, price, category_id)

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Phone', 800, 1),
(2, 'Laptop', 1500, 1),
(3, 'Tablet', 600, 1),
(4, 'Smartwatch', 300, 1),
(5, 'Headphones', 200, 2),
(6, 'Speakers', 300, 2),
(7, 'Earbuds', 100, 2);


--SOLUTION:
WITH RankedProducts AS (
    SELECT 
        id,
        product_name,
        price,
        category_id,
        DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) as price_rank
    FROM 
        products
)
SELECT 
    id,
    product_name,
    price,
    category_id
FROM 
    RankedProducts
WHERE 
    price_rank = 3;


--10)Find Employees whose Salary Between Company Average and Department Max Salary
DROP TABLE IF EXISTS employees

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Alex', 70000, 1),
(2, 'Blake', 90000, 1),
(3, 'Casey', 50000, 2),
(4, 'Dana', 60000, 2),
(5, 'Evan', 75000, 1);


--SOLUTION:
;WITH AVG_TABLE AS (
SELECT 
department_id,
MAX(salary) AS max_sal_per_dep
FROM employees
GROUP BY department_id
)

SELECT 
E.id,
E.name,
E.salary,
e.department_id
FROM employees E
WHERE  E.Salary BETWEEN  (SELECT AVG(salary) FROM employees) AND (SELECT max_sal_per_dep FROM AVG_TABLE WHERE department_id=E.department_id)
