-- ============================================================
-- Part 3.1 - Star Schema Design
-- Based on retail_transactions.csv
-- Data Warehouse for Retail Chain Business Intelligence
-- ============================================================

-- Drop tables if they exist (for clean re-runs)
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_product;

-- -----------------------------------------------
-- Dimension Table 1: dim_date
-- -----------------------------------------------
CREATE TABLE dim_date (
    date_id     INTEGER     NOT NULL PRIMARY KEY,
    full_date   DATE        NOT NULL,
    day         INTEGER     NOT NULL,
    month       INTEGER     NOT NULL,
    month_name  TEXT        NOT NULL,
    quarter     INTEGER     NOT NULL,
    year        INTEGER     NOT NULL
);

INSERT INTO dim_date (date_id, full_date, day, month, month_name, quarter, year) VALUES
(20230101, '2023-01-15', 15, 1,  'January',   1, 2023),
(20230201, '2023-02-05', 5,  2,  'February',  1, 2023),
(20230202, '2023-02-08', 8,  2,  'February',  1, 2023),
(20230203, '2023-02-20', 20, 2,  'February',  1, 2023),
(20230301, '2023-03-31', 31, 3,  'March',     1, 2023),
(20230401, '2023-04-28', 28, 4,  'April',     2, 2023),
(20230501, '2023-05-12', 12, 5,  'May',       2, 2023),
(20230502, '2023-05-21', 21, 5,  'May',       2, 2023),
(20230601, '2023-06-04', 4,  6,  'June',      2, 2023),
(20230801, '2023-08-01', 1,  8,  'August',    3, 2023),
(20230802, '2023-08-09', 9,  8,  'August',    3, 2023),
(20230803, '2023-08-29', 29, 8,  'August',    3, 2023),
(20230901, '2023-09-15', 15, 9,  'September', 3, 2023),
(20231001, '2023-10-26', 26, 10, 'October',   4, 2023),
(20231002, '2023-10-20', 20, 10, 'October',   4, 2023),
(20231101, '2023-11-18', 18, 11, 'November',  4, 2023),
(20231201, '2023-12-08', 8,  12, 'December',  4, 2023),
(20231202, '2023-12-12', 12, 12, 'December',  4, 2023);

-- -----------------------------------------------
-- Dimension Table 2: dim_store
-- -----------------------------------------------
CREATE TABLE dim_store (
    store_id    INTEGER  NOT NULL PRIMARY KEY,
    store_name  TEXT     NOT NULL,
    store_city  TEXT     NOT NULL
);

INSERT INTO dim_store (store_id, store_name, store_city) VALUES
(1, 'Mumbai Central', 'Mumbai'),
(2, 'Delhi South',    'Delhi'),
(3, 'Bangalore MG',   'Bangalore'),
(4, 'Chennai Anna',   'Chennai'),
(5, 'Pune FC Road',   'Pune');

-- -----------------------------------------------
-- Dimension Table 3: dim_product
-- Note: Categories cleaned to consistent casing
-- (electronics -> Electronics, Grocery -> Groceries)
-- -----------------------------------------------
CREATE TABLE dim_product (
    product_id    INTEGER         NOT NULL PRIMARY KEY,
    product_name  TEXT            NOT NULL,
    category      TEXT            NOT NULL,
    unit_price    DECIMAL(10,2)   NOT NULL
);

INSERT INTO dim_product (product_id, product_name, category, unit_price) VALUES
(1,  'Laptop',      'Electronics', 42343.15),
(2,  'Phone',       'Electronics', 48703.39),
(3,  'Tablet',      'Electronics', 23226.12),
(4,  'Headphones',  'Electronics', 39854.96),
(5,  'Smartwatch',  'Electronics', 58851.01),
(6,  'Speaker',     'Electronics', 49262.78),
(7,  'Jeans',       'Clothing',     2317.47),
(8,  'Jacket',      'Clothing',    30187.24),
(9,  'Saree',       'Clothing',    35451.81),
(10, 'T-Shirt',     'Clothing',     1899.00),
(11, 'Atta 10kg',   'Groceries',   52464.00),
(12, 'Biscuits',    'Groceries',   27469.99),
(13, 'Milk 1L',     'Groceries',   43374.39),
(14, 'Oil 1L',      'Groceries',   18500.00),
(15, 'Rice 5kg',    'Groceries',   32000.00),
(16, 'Pulses 1kg',  'Groceries',   15000.00);

-- -----------------------------------------------
-- Fact Table: fact_sales
-- Central table referencing all 3 dimensions
-- -----------------------------------------------
CREATE TABLE fact_sales (
    fact_id         INTEGER         NOT NULL PRIMARY KEY,
    transaction_id  TEXT            NOT NULL,
    date_id         INTEGER         NOT NULL,
    store_id        INTEGER         NOT NULL,
    product_id      INTEGER         NOT NULL,
    units_sold      INTEGER         NOT NULL,
    unit_price      DECIMAL(10,2)   NOT NULL,
    total_revenue   DECIMAL(12,2)   NOT NULL,
    FOREIGN KEY (date_id)    REFERENCES dim_date(date_id),
    FOREIGN KEY (store_id)   REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

INSERT INTO fact_sales (fact_id, transaction_id, date_id, store_id, product_id, units_sold, unit_price, total_revenue) VALUES
(1,  'TXN5000', 20230803, 4, 6,  3,  49262.78, 147788.34),
(2,  'TXN5001', 20231202, 4, 3,  11, 23226.12, 255487.32),
(3,  'TXN5002', 20230201, 4, 2,  20, 48703.39, 974067.80),
(4,  'TXN5003', 20230203, 2, 3,  14, 23226.12, 325165.68),
(5,  'TXN5004', 20230101, 4, 5,  10, 58851.01, 588510.10),
(6,  'TXN5005', 20230802, 3, 11, 12, 52464.00, 629568.00),
(7,  'TXN5006', 20230301, 5, 5,  6,  58851.01, 353106.06),
(8,  'TXN5007', 20231001, 5, 7,  16, 2317.47,  37079.52),
(9,  'TXN5008', 20231201, 3, 12, 9,  27469.99, 247229.91),
(10, 'TXN5009', 20230901, 3, 5,  3,  58851.01, 176553.03),
(11, 'TXN5010', 20230601, 4, 8,  15, 30187.24, 452808.60),
(12, 'TXN5011', 20231002, 1, 7,  13, 2317.47,  30127.11),
(13, 'TXN5012', 20230502, 3, 1,  13, 42343.15, 550460.95),
(14, 'TXN5013', 20230401, 1, 13, 10, 43374.39, 433743.90),
(15, 'TXN5014', 20231101, 2, 8,  5,  30187.24, 150936.20),
(16, 'TXN5015', 20230101, 1, 9,  15, 35451.81, 531777.15),
(17, 'TXN5016', 20230801, 1, 9,  11, 35451.81, 389969.91),
(18, 'TXN5017', 20230501, 3, 8,  6,  30187.24, 181123.44),
(19, 'TXN5018', 20230202, 3, 4,  15, 39854.96, 597824.40),
(20, 'TXN5019', 20230203, 2, 3,  14, 23226.12, 325165.68);
