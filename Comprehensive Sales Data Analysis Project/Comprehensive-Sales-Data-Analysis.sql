-- 4.10 sql drills
-- Use the right Role and Warehouse
USE ROLE DE;
USE WAREHOUSE COMPUTE_WH;

-- Create the sales_data table
CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.SPATTURI.sales_data (
    Store STRING,
    Product STRING,
    Sales INT,
    Date DATE
);

-- Insert sample data into the sales_data table
-- DATEPART function will make sure that the sql code is compatible with other systems. YEAR(), MONTH(), etc. are functions specific to Snowflake
INSERT INTO TECHCATALYST_DE.SPATTURI.sales_data (Store, Product, Sales, Date) VALUES 
('A', 'Apples', 100, '2024-07-01'),
('A', 'Oranges', 150, '2024-07-02'),
('B', 'Apples', 200, '2024-07-01'),
('B', 'Oranges', 120, '2024-07-02'),
('C', 'Apples', 90, '2024-07-01'),
('C', 'Oranges', 80, '2024-07-02'),
('A', 'Apples', 130, '2024-07-03'),
('B', 'Oranges', 110, '2024-07-03'),
('C', 'Apples', 95, '2024-07-03'),
('A', 'Oranges', 105, '2024-07-04'),
('B', 'Apples', 210, '2024-07-04'),
('C', 'Oranges', 70, '2024-07-04');

-- Exercise 1: 
SELECT STORE, PRODUCT, SUM(Sales) as TOTAL_SALES
FROM TECHCATALYST_DE.SPATTURI.sales_data
GROUP BY STORE, PRODUCT
ORDER BY STORE ASC;

-- Exercise 2:
SELECT PRODUCT, AVG(SALES) as AVG_SALES
FROM TECHCATALYST_DE.SPATTURI.sales_data
GROUP BY PRODUCT;

SELECT STORE,
       PRODUCT,
       SALES, 
       DATE,
       CASE
            WHEN PRODUCT = 'Apples' then (SALES - 137.5)
            WHEN PRODUCT = 'Oranges' then (SALES - 105.83333)
       END as SALES_DIFFERENCE,
       CASE
            WHEN SALES > 100 then TRUE
            ELSE FALSE
       END as HIGH_SALES,
FROM TECHCATALYST_DE.SPATTURI.sales_data;

-- Exercise 3:
SELECT STORE,
       PRODUCT, 
       SALES,
       DATE,
       YEAR(DATE) as year,
       MONTH(DATE) as month,
       DAY(DATE) as day,
       DAYNAME(DATE) as day_of_week
FROM TECHCATALYST_DE.SPATTURI.sales_data;

-- Exercise 4: 
SELECT STORE, PRODUCT, SALES, DATE, AVG(SALES) OVER(PARTITION BY PRODUCT ORDER BY DATE, STORE ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as MOVING_AVG_3_DAYS
FROM TECHCATALYST_DE.SPATTURI.sales_data;

-- Exercise 5: 
SELECT STORE,
       PRODUCT,
       SALES,
       DATE,
       LAG(Sales) OVER (PARTITION BY PRODUCT ORDER BY DATE) AS PREV_DAY_SALES
from TECHCATALYST_DE.SPATTURI.sales_data
ORDER BY PRODUCT;
-- Exercise 6:
with cte as
(
    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY STORE order by SALES desc) as SALES_RANK
    from TECHCATALYST_DE.SPATTURI.sales_data

)
select * from cte;

-- Exercise 7:
-- Low: 100, 90, 80. 95, 70
-- Medium: 150, 120, 130, 110, 105
-- High : 200, 210

SELECT STORE,
       PRODUCT, 
       SALES,
       DATE, 
       CASE
            WHEN SALES <= 100 THEN 'LOW'
            WHEN SALES > 101 AND SALES < 200 THEN 'MEDIUM'
            WHEN SALES >= 200 THEN 'HIGH'
       END AS SALES_LEVEL,
FROM TECHCATALYST_DE.SPATTURI.sales_data;
-- Exercise 8:
SELECT SUM(SALES) AS TOTAL_SALES, AVG(SALES) AS AVG_SALES, MAX(SALES) AS HIGHEST_SALE, MIN(SALES) AS LOWEST_SALE
FROM TECHCATALYST_DE.SPATTURI.sales_data
GROUP BY STORE;