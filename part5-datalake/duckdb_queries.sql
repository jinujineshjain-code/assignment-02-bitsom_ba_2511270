-- ============================================================
-- Part 5.1 - Cross-Format Queries using DuckDB
-- Files read directly (no pre-loading into tables):
--   customers  → datasets/customers.csv
--   orders     → datasets/orders.json
--   products   → datasets/products.parquet
-- ============================================================

-- Q1: List all customers along with the total number of orders they have placed
SELECT
    c.customer_id,
    c.name                          AS customer_name,
    c.city,
    COUNT(o.order_id)               AS total_orders
FROM read_csv_auto('datasets/customers.csv')     AS c
LEFT JOIN read_json_auto('datasets/orders.json') AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_orders DESC;

-- Q2: Find the top 3 customers by total order value
SELECT
    c.customer_id,
    c.name                          AS customer_name,
    c.city,
    SUM(o.total_amount)             AS total_order_value
FROM read_csv_auto('datasets/customers.csv')     AS c
JOIN read_json_auto('datasets/orders.json')      AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_order_value DESC
LIMIT 3;

-- Q3: List all products purchased by customers from Bangalore
SELECT DISTINCT
    c.name                              AS customer_name,
    c.city,
    p.product_name,
    p.category
FROM read_csv_auto('datasets/customers.csv')     AS c
JOIN read_json_auto('datasets/orders.json')      AS o
    ON c.customer_id = o.customer_id
JOIN read_parquet('datasets/products.parquet')   AS p
    ON o.order_id = p.order_id
WHERE c.city = 'Bangalore'
ORDER BY c.name, p.product_name;

-- Q4: Join all three files to show: customer name, order date, product name
SELECT
    c.name                              AS customer_name,
    c.city                              AS customer_city,
    o.order_date,
    p.product_name,
    p.category,
    p.quantity,
    p.unit_price,
    p.total_price
FROM read_csv_auto('datasets/customers.csv')     AS c
JOIN read_json_auto('datasets/orders.json')      AS o
    ON c.customer_id = o.customer_id
JOIN read_parquet('datasets/products.parquet')   AS p
    ON o.order_id = p.order_id
ORDER BY o.order_date DESC;
