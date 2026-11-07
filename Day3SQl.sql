Here are 9 real-world SQL problems and the patterns that fix them fast:

1. Important corrections to the 9 SQL patterns
#	Pattern	Important clarification
1	Duplicate rows after JOIN	DISTINCT can help, but fixing the join cardinality is usually better.
2	NULL handling	COALESCE(status, 'Unknown') replaces NULL values.
3	Running total	Add ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW for explicit row-by-row accumulation.
4	Month-on-month	Use LAG() on monthly aggregated revenue, not raw transactions.
5	Email filtering	Use email LIKE '%@gmail.com' OR email LIKE '%@yahoo.com'.
6	Days between events	In PostgreSQL, subtract dates: purchase_date - signup_date.
7	Percentage of total	Use amount * 100.0 / SUM(amount) OVER () to return a percentage.
8	Latest row per user	Use ROW_NUMBER() partitioned by user, with a deterministic tie-breaker.
9	Category sales above 10k	Use GROUP BY and HAVING SUM(...) > 10000.


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    region VARCHAR(50),
    product VARCHAR(50),
    quantity INT,
    price DECIMAL(10,2)
);



INSERT INTO orders VALUES
(1, 101, '2024-01-05', 'North', 'Laptop', 1, 800.00),
(2, 102, '2024-01-06', 'South', 'Mobile', 2, 500.00),
(3, 103, '2024-01-07', 'East', 'Tablet', 1, 300.00),
(4, 104, '2024-01-08', 'West', 'Laptop', 2, 800.00),
(5, 105, '2024-01-09', 'North', 'Monitor', 1, 200.00),
(6, 101, '2024-01-10', 'South', 'Laptop', 1, 800.00),
(7, 102, '2024-01-11', 'East', 'Mobile', 3, 500.00),
(8, 103, '2024-01-12', 'West', 'Tablet', 2, 300.00),
(9, 104, '2024-01-13', 'North', 'Headphones', 4, 50.00),
(10, 105, '2024-01-14', 'South', 'Monitor', 2, 200.00),

(11, 106, '2024-01-15', 'East', 'Laptop', 1, 800.00),
(12, 107, '2024-01-16', 'West', 'Mobile', 2, 500.00),
(13, 108, '2024-01-17', 'North', 'Tablet', 1, 300.00),
(14, 109, '2024-01-18', 'South', 'Laptop', 3, 800.00),
(15, 110, '2024-01-19', 'East', 'Monitor', 1, 200.00),
(16, 106, '2024-01-20', 'West', 'Headphones', 5, 50.00),
(17, 107, '2024-01-21', 'North', 'Mobile', 2, 500.00),
(18, 108, '2024-01-22', 'South', 'Tablet', 2, 300.00),
(19, 109, '2024-01-23', 'East', 'Laptop', 1, 800.00),
(20, 110, '2024-01-24', 'West', 'Monitor', 2, 200.00),

(21, 101, '2024-01-25', 'North', 'Laptop', 1, 800.00),
(22, 102, '2024-01-26', 'South', 'Mobile', 1, 500.00),
(23, 103, '2024-01-27', 'East', 'Tablet', 3, 300.00),
(24, 104, '2024-01-28', 'West', 'Laptop', 1, 800.00),
(25, 105, '2024-01-29', 'North', 'Monitor', 2, 200.00),
(26, 106, '2024-01-30', 'South', 'Headphones', 6, 50.00),
(27, 107, '2024-01-31', 'East', 'Mobile', 2, 500.00),
(28, 108, '2024-02-01', 'West', 'Tablet', 1, 300.00),
(29, 109, '2024-02-02', 'North', 'Laptop', 2, 800.00),
(30, 110, '2024-02-03', 'South', 'Monitor', 1, 200.00),

(31, 111, '2024-02-04', 'East', 'Laptop', 1, 800.00),
(32, 112, '2024-02-05', 'West', 'Mobile', 4, 500.00),
(33, 113, '2024-02-06', 'North', 'Tablet', 2, 300.00),
(34, 114, '2024-02-07', 'South', 'Laptop', 1, 800.00),
(35, 115, '2024-02-08', 'East', 'Monitor', 3, 200.00),
(36, 111, '2024-02-09', 'West', 'Headphones', 2, 50.00),
(37, 112, '2024-02-10', 'North', 'Mobile', 1, 500.00),
(38, 113, '2024-02-11', 'South', 'Tablet', 2, 300.00),
(39, 114, '2024-02-12', 'East', 'Laptop', 2, 800.00),
(40, 115, '2024-02-13', 'West', 'Monitor', 1, 200.00),

(41, 101, '2024-02-14', 'North', 'Headphones', 3, 50.00),
(42, 102, '2024-02-15', 'South', 'Laptop', 1, 800.00),
(43, 103, '2024-02-16', 'East', 'Mobile', 2, 500.00),
(44, 104, '2024-02-17', 'West', 'Tablet', 3, 300.00),
(45, 105, '2024-02-18', 'North', 'Monitor', 1, 200.00),
(46, 106, '2024-02-19', 'South', 'Laptop', 2, 800.00),
(47, 107, '2024-02-20', 'East', 'Tablet', 1, 300.00),
(48, 108, '2024-02-21', 'West', 'Mobile', 1, 500.00),
(49, 109, '2024-02-22', 'North', 'Laptop', 1, 800.00),
(50, 110, '2024-02-23', 'South', 'Headphones', 4, 50.00);



CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    email VARCHAR(100),
    signup_date DATE
);



INSERT INTO customers
(customer_id, customer_name, city, email, signup_date)
VALUES
(101, 'Amit Sharma', 'Pune', 'amit@gmail.com', '2023-11-10'),
(102, 'Priya Patel', 'Mumbai', 'priya@yahoo.com', '2023-11-15'),
(103, 'Rahul Verma', 'Delhi', 'rahul@gmail.com', '2023-12-01'),
(104, 'Sneha Kulkarni', 'Pune', 'sneha@outlook.com', '2023-12-05'),
(105, 'Vikas Mehta', 'Ahmedabad', 'vikas@yahoo.com', '2023-12-12'),
(106, 'Neha Joshi', 'Mumbai', 'neha@gmail.com', '2023-12-20'),
(107, 'Karan Shah', 'Surat', 'karan@outlook.com', '2024-01-02'),
(108, 'Pooja Singh', 'Delhi', 'pooja@gmail.com', '2024-01-05'),
(109, 'Arjun Nair', 'Bangalore', 'arjun@yahoo.com', '2024-01-10'),
(110, 'Meera Iyer', 'Chennai', 'meera@gmail.com', '2024-01-15'),
(111, 'Rohit Desai', 'Pune', 'rohit@outlook.com', '2024-01-20'),
(112, 'Ananya Rao', 'Hyderabad', 'ananya@gmail.com', '2024-01-25'),
(113, 'Suresh Reddy', 'Hyderabad', 'suresh@yahoo.com', '2024-02-01'),
(114, 'Kavita Gupta', 'Delhi', 'kavita@gmail.com', '2024-02-05'),
(115, 'Manish Jain', 'Jaipur', 'manish@outlook.com', '2024-02-10');


--To validate the data

SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.city
ORDER BY c.customer_id;

1.
Problem statement
The business wants a list of customers who have placed at least one order.
The output must contain exactly one row per customer, even if that customer has placed multiple orders.


with avoide_Duplicate as (
			select 
				c.customer_id,
			    c.customer_name,
			    c.city,
				o.order_date,
				o.region,
				o.product,
				o.quantity,
				o.price
			FROM customers c
			LEFT JOIN orders o
			    ON c.customer_id = o.customer_id
)

select distinct customer_id,customer_name
from avoide_Duplicate
order by customer_id


2. Business scenario
Suppose your orders table contains some missing values in the region and product columns.

The business wants to display:
- Unknown Region whenever region is NULL.
- Unknown Product whenever product is NULL.
Instead of displaying NULL, we need meaningful default labels.
        2. First, introduce some NULL values
Run these statements on your existing dataset:

UPDATE orders
SET region = NULL
WHERE order_id IN (5, 12, 25);

UPDATE orders
SET product = NULL
WHERE order_id IN (8, 19, 35);

Verify:
SELECT *
FROM orders
WHERE region IS NULL
   OR product IS NULL;


Your challenge
Write a query that displays:
order_id	region	product
5	Unknown Region	Monitor
8	West	Unknown Product
12	Unknown Region	Mobile


COALESCE(column_name, 'default value')

select 
	order_id ,
	CASE  WHEN region IS NULL THEN 'Unknown Region' ELSE region END,
	CASE  WHEN product IS NULL THEN 'Unknown Product' ELSE product END
from orders
	WHERE region IS NULL
   	OR product IS NULL;

select 
		order_id,
		COALESCE(region, 'Unknown Region') as Region,
		COALESCE(product, 'Unknown Product') as Product
from orders
	WHERE region IS NULL
   	OR product IS NULL;


3.Business scenario
The sales team wants to track how revenue accumulates over time.

For every order, calculate:
1. Order ID
2. Order date
3. Product
4. Order revenue
5. Cumulative revenue up to that order

Remember:

Order Revenue = Quantity * Price

Expected output
Your result should look something like this:
order_id	order_date	revenue	running_total
1	2024-01-05	800	800
2	2024-01-06	1000	1800
3	2024-01-07	300	2100
4	2024-01-08	1600	3700
5	2024-01-09	200	3900

select 
	order_id,
	order_date,
	product,
	price,
	quantity,
	--sum(price*quantity) over (order by order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
	sum(price*quantity) over (order by order_date,order_id) as running_total
from orders