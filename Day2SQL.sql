CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    region VARCHAR(50),
    product VARCHAR(50),
    quantity_sold INT
);

INSERT INTO sales (sale_id, region, product, quantity_sold) VALUES
(1, 'North', 'Laptop', 15),
(2, 'North', 'Mobile', 25),
(3, 'North', 'Tablet', 10),
(4, 'North', 'Headphones', 8),
(5, 'North', 'Monitor', 20),

(6, 'South', 'Laptop', 30),
(7, 'South', 'Mobile', 40),
(8, 'South', 'Tablet', 18),
(9, 'South', 'Headphones', 12),
(10, 'South', 'Monitor', 22),

(11, 'East', 'Laptop', 28),
(12, 'East', 'Mobile', 35),
(13, 'East', 'Tablet', 15),
(14, 'East', 'Headphones', 10),
(15, 'East', 'Monitor', 25),

(16, 'West', 'Laptop', 20),
(17, 'West', 'Mobile', 45),
(18, 'West', 'Tablet', 22),
(19, 'West', 'Headphones', 15),
(20, 'West', 'Monitor', 30);


Given a sales table, find the top 3 products sold in each region using RANK or DENSE_RANK

select * from sales;

WITH ranked_sales AS (
    SELECT
        region,
        product,
        quantity_sold,
        DENSE_RANK() OVER (
            PARTITION BY region
            ORDER BY quantity_sold DESC
        ) AS product_rank
    FROM sales
)
SELECT
    region,
    product,
    quantity_sold,
    product_rank
FROM ranked_sales
WHERE product_rank <= 3
ORDER BY region, product_rank;



RANK


WITH ranked_sales AS (
    SELECT
        region,
        product,
        quantity_sold,
        RANK() OVER (
            PARTITION BY region
            ORDER BY quantity_sold DESC
        ) AS product_rank
    FROM sales
)
SELECT *
FROM ranked_sales
WHERE product_rank <= 3
ORDER BY region, product_rank;

