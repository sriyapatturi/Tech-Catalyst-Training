-- inner join example 
SELECT c.c_name, o.o_orderkey
FROM ORDERS as o
JOIN CUSTOMER as c on o.o_custkey = c.c_custkey;
-- JOIN == INNER JOIN

-- Case Study Activity:
-- Building Market Segment Insights: "We cater to different market segments. Can you breakdown the total sales for each market segment? I've heard the 'BUILDING' and 'AUTOMOBILE' segments have been doing exceptionally well."
SELECT C_MKTSEGMENT as "Marked Segment", SUM(L_ExtendedPrice * (1 - L_Discount)) as "Total Sales Value"
FROM CUSTOMER 
JOIN ORDERS ON C_CUSTKEY = O_CUSTKEY
JOIN LINEITEM ON O_ORDERKEY = L_ORDERKEY
GROUP BY C_MKTSEGMENT
ORDER BY C_MKTSEGMENT
-- Potential Issues: "Lastly, I want to ensure we're not missing out on any opportunities. Could you list out customers who haven't placed any orders with us? It might be a good idea to have the sales team reach out to them."
SELECT C_NAME as "Customer Name",
COUNT(O_CUSTKEY) as "Number of Orders"
FROM CUSTOMER 
LEFT JOIN ORDERS ON O_CUSTKEY = C_CUSTKEY
GROUP BY "Customer Name"
HAVING COUNT(O_CUSTKEY) = 0;
-- schema, logical separation between data in the database

-- Creating a new schema
CREATE SCHEMA IF NOT EXISTS TECHCATALYST_DE.SPATTURI;
USE SCHEMA TECHCATALYST_DE.SPATTURI;

DROP SCHEMA TECHCATALYST_DE.SRIYA;

SELECT O_ORDERDATE
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS;

SELECT COUNT(*)
FROM TECHCATALYST_DE.PUBLIC.YELLOW_TAXI_2024_01; -- to find the number of records

-- to see the structure of a table
use schema snowflake_sample_data.tpch_sf1;
describe table orders;

-- CTE - Common Table Expression
-- Fancy term for creating a temporary result set that you can use in your query
with myquery as
(select o_orderkey, o_orderdate, o_totalprice
from orders 
where year(o_orderdate) = 1994
)

SELECT * from myquery;

-- Activity 3.4.1 - Exercise
-- Exercise 1: 
-- As a data analyst for NorthWind Traders, you are tasked with identifying the top 10 customers in terms of total sales. Additionally, you need to provide insights on the number of orders each of these top customers has made and calculate the average price per order. The average price per order is defined as the total order price divided by the total number of orders made by the customer.

-- Task: Write an SQL query to achieve the following:

-- Identify the top 10 customers based on total sales.
-- Show the number of orders made by each of these top 10 customers.
-- Calculate the average price per order for each of these customers.
-- Hint: Use aggregation functions and consider using a common table expression (CTE) to structure your query effectively.
with customers_orders_cte as
(
    SELECT C_CUSTKEY, C_NAME, O_ORDERKEY, O_TOTALPRICE
    FROM CUSTOMER
    JOIN ORDERS ON C_CUSTKEY = O_CUSTKEY
)

SELECT C_CUSTKEY, C_NAME, COUNT(O_ORDERKEY) AS NUM_ORDERS, SUM(O_TOTALPRICE) AS TOTAL_SALES, SUM(O_TOTALPRICE) / COUNT(O_ORDERKEY) AS AVG_ORDER_PRICE
FROM customers_orders_cte
GROUP BY C_CUSTKEY, C_NAME
ORDER BY TOTAL_SALES DESC LIMIT 10;

-- Exercise 2:
-- As a data analyst for NorthWind Traders, you are tasked with identifying the top-performing nations and their best-selling products. Your goal is to determine the top 5 nations by total order sales, broken down by market segment, and then find the top 3 selling products for these nations based on Sum Charge.

-- Task: Write an SQL query to achieve the following:

-- Identify the top 5 nations based on total order sales
-- Create a Common Table Expression (CTE) to store these results.
-- Using the CTE, find the top 15 selling products by Sum Charge for these top nations.
-- Sum Charge is defined as Extended Price x (1 - Discount) x (1 + Tax).
-- Hint: Use aggregation functions, JOINs, and consider using a Common Table Expression (CTE) to structure your query effectively.

with ex2_cte as (
    SELECT N_NATIONKEY, N_NAME, SUM(O_TOTALPRICE) AS TOTAL_ORDER_SALES,
    FROM NATION
    JOIN CUSTOMER ON N_NATIONKEY = C_NATIONKEY
    JOIN ORDERS ON C_CUSTKEY = O_CUSTKEY
    GROUP BY N_NAME, N_NATIONKEY
    ORDER BY TOTAL_ORDER_SALES DESC
    LIMIT 5
)
SELECT ex2_cte.N_NAME, P_NAME, SUM(L_EXTENDEDPRICE * (1 - L_DISCOUNT) * (1 + L_TAX)) AS SUM_CHARGE
FROM ex2_cte
JOIN CUSTOMER ON N_NATIONKEY = C_NATIONKEY
JOIN ORDERS ON C_CUSTKEY = O_CUSTKEY
JOIN LINEITEM ON O_ORDERKEY = L_ORDERKEY
JOIN PARTSUPP ON L_PARTKEY = PS_PARTKEY AND L_SUPPKEY = PS_SUPPKEY
JOIN PART ON PS_PARTKEY = P_PARTKEY
GROUP BY ex2_cte.N_NAME, P_NAME
ORDER BY SUM_CHARGE DESC
LIMIT 15;

-- Exercise 3: 
-- Common Table Expressions (CTE)
-- As a data analyst for NorthWind Traders, you are tasked with analyzing the sales performance of parts. Your goal is to identify the top 5 selling parts in 1997, broken down by month, and then determine the last time these parts were ordered.

-- Task: Write an SQL query to achieve the following:

-- Identify the top 5 selling parts in 1994
-- Top selling parts are based on Sum Charge = Extended Price x (1 - Discount) x (1 + Tax).
-- These are parts that have been fulfilled (Line States is F) and not returned (Return Flag is A or N but not R)
-- Create a Common Table Expression (CTE) to store these results.
-- Using the CTE, find the last order date for these top parts.
-- Use the Commit Date for determining the last order date.
-- Hint: Use aggregation functions, JOINs, and consider using a Common Table Expression (CTE) to structure your query effectively.
with ex3_cte as
(
    SELECT P_NAME, P_PARTKEY, SUM(L_EXTENDEDPRICE * (1 - L_DISCOUNT) * (1 + L_TAX)) AS SUM_CHARGE
    FROM ORDERS 
    JOIN LINEITEM ON O_ORDERKEY = L_ORDERKEY
    JOIN PARTSUPP ON L_PARTKEY = PS_PARTKEY and L_SUPPKEY = PS_SUPPKEY
    JOIN PART ON P_PARTKEY = PS_PARTKEY
    WHERE YEAR(O_ORDERDATE) = 1994 and L_LINESTATUS = 'F' and L_RETURNFLAG in ('A', 'N')
    GROUP BY P_NAME, P_PARTKEY
    ORDER BY SUM_CHARGE DESC
)
select P_NAME, L_COMMITDATE as MOST_RECENT_CDATE
from ex3_cte 
JOIN PARTSUPP ON P_PARTKEY = PS_PARTKEY
JOIN LINEITEM ON L_PARTKEY = PS_PARTKEY AND L_SUPPKEY = PS_SUPPKEY;

-- Exercise 4:
-- As a data analyst for NorthWind Traders, you are tasked with evaluating the efficiency of order fulfillment in 1994. Specifically, you need to determine the average number of days it takes to ship an order from the order date, broken down by month.

-- Task: Write an SQL query to achieve the following:

-- Calculate the average number of days it takes to ship an order from the order date, for each month in 1994.
-- Hint: Use date functions to calculate the difference in days between the order date and the ship date. Aggregate the results by month and calculate the average shipping time.

SELECT MONTH(O_ORDERDATE) AS MONTH, AVG(L_SHIPDATE - O_ORDERDATE) AS DAYS 
FROM ORDERS 
JOIN LINEITEM ON O_ORDERKEY = L_ORDERKEY
WHERE YEAR(O_ORDERDATE) = 1994
GROUP BY MONTH(O_ORDERDATE)
ORDER BY MONTH(O_ORDERDATE); 

-- Exercise 5:
-- As a data analyst for NorthWind Traders, you need to determine the efficiency of suppliers in shipping orders. Specifically, you want to find out the average number of days it takes for each supplier to ship an order from the commit date.

-- Task: Write an SQL query to achieve the following:

-- For each supplier, calculate the average number of days it takes to ship an order from the commit date.
-- Hint: Use date functions and aggregation functions to calculate the average shipping time. You may need to join the lineitem and supplier tables to get the necessary information.

SELECT S_SUPPKEY, S_NAME, AVG(L_SHIPDATE - L_COMMITDATE) AS AVG_SHIPPING_DAYS
FROM SUPPLIER
JOIN PARTSUPP ON S_SUPPKEY = PS_SUPPKEY
JOIN LINEITEM ON PS_PARTKEY = L_PARTKEY AND PS_SUPPKEY = L_SUPPKEY
GROUP BY S_SUPPKEY, S_NAME;
-- Activity 3.4.3:
-- As a data analyst for NorthWind Traders, you are asked to assist two distinct marketing teams. One team focuses on the "AUTOMOBILE" market segment, while the other focuses on the "BUILDING" market segment. Your task is to provide a consolidated list of all customers from both market segments without any duplicates. Customers may belong to multiple market segments over time, so you need to use UNION to ensure each customer appears only once in the result.

-- Task: Write an SQL query to achieve the following:

-- Identify customers from the "AUTOMOBILE" market segment.
-- Identify customers from the "BUILDING" market segment.
-- Combine the results using UNION to remove duplicates.
-- Use Common Table Expressions (CTEs) to structure your query.
-- Hint: Use CTEs to create separate lists of customers for each market segment, then combine these lists using UNION.
with cte as
(
    select DISTINCT c_custkey, c_name
    FROM customer
    WHERE c_mktsegment = 'AUTOMOBILE'
),
cte2 as (
    select DISTINCT c_custkey, c_name
    from customer
    WHERE c_mktsegment = 'BUILDING'
)

select c_custkey, c_name, 'AUTO' as TEAM
from cte 
union 
select c_custkey, c_name, 'BUILD' as TEAM
from cte2
ORDER BY C_CUSTKEY ASC; 
-- Activity 3.4.2:
-- Exercise 1: Task: Retrieve a list of customers (c_name) who have placed orders. Display the customer name along with the order date (o_orderdate).
SELECT C_NAME, O_ORDERDATE
FROM CUSTOMER
JOIN ORDERS ON C_CUSTKEY = O_CUSTKEY;

SELECT p.p_name, COALESCE(COUNT(l.l_orderkey), 0) AS order_count
FROM part AS p
LEFT JOIN lineitem AS l ON p.p_partkey = l.l_partkey
GROUP BY p.p_name
-- Exercise 2:Task: Identify all customers who haven't placed any orders. Display their names (c_name) and market segments (c_mktsegment).

with customer_num_orders as
(
    SELECT C_NAME as cus_name, COUNT(O_ORDERKEY) AS NUM_ORDERS
    FROM CUSTOMER
    LEFT JOIN ORDERS ON C_CUSTKEY = O_CUSTKEY
    GROUP BY cus_name
    HAVING NUM_ORDERS = 0
)
SELECT C_NAME, C_MKTSEGMENT 
FROM CUSTOMER
JOIN customer_num_orders
on CUSTOMER.C_NAME = customer_num_orders.cus_name;

-- Exercise 3:Task: For each supplier (s_name), retrieve the supplier's name and their associated nation's name (n_name). Include all suppliers, even if their nation is somehow missing in the dataset.
SELECT S_NAME, N_NAME 
FROM SUPPLIER
LEFT JOIN NATION ON S_NATIONKEY = N_NATIONKEY;

-- Exercise 4:Task: Display a list of all customers (c_name) and their associated regions (r_name). If a customer's region cannot be determined, still display the customer's name but indicate the region as 'Unknown'.
SELECT C_NAME, COALESCE(r.r_name, 'Unknown') AS region_name
FROM CUSTOMER
LEFT JOIN NATION ON C_NATIONKEY = N_NATIONKEY
LEFT JOIN REGION ON N_REGIONKEY = R_REGIONKEY;

-- Exercise 5:Task: Retrieve a list of products (p_name) and the number of times they've been ordered (o_orderkey). Include all products, even if they haven't been ordered, and display a count of 0 for those.
SELECT p.p_name, COALESCE(COUNT(l.l_orderkey), 0) AS order_count
FROM part as p
LEFT JOIN lineitem AS l ON p.p_partkey = l.l_partkey
GROUP BY p.p_name;


-- l_orderkey for a specific customer may be null
-- Coalesce() function is used to handle missing data
-- usually use this function when you are joining two tables using the left join operation
