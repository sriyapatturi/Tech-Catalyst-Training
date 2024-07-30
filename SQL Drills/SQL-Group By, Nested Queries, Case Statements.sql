
-- Activity 3.2.1:
-- Exercise 1: Count number of Orders by Year
SELECT YEAR(O_ORDERDATE) AS "Order Year", COUNT(O_ORDERKEY)
FROM ORDERS
GROUP BY "Order Year"
ORDER BY "Order Year" ASC;
-- Exercise 2: What is the average days from Commit Date to Ship Date broken by Ship Mode?
SELECT L_SHIPMODE, AVG(L_SHIPDATE - L_COMMITDATE) as "Avg Days"
FROM LINEITEM 
GROUP BY L_SHIPMODE;

-- another way to do exercise 2 that is above 
SELECT L_SHIPMODE, AVG(DATEDIFF('DAYS', L_COMMITDATE, L_SHIPDATE)) as "AVG DAYS"
FROM LINEITEM
GROUP BY L_SHIPMODE;

--extra: which ship modes on average take more than 1 day to ship items from one place to another
SELECT L_SHIPMODE, AVG(L_SHIPDATE - L_COMMITDATE) as "AVG DAYS"
FROM LINEITEM
GROUP BY L_SHIPMODE
HAVING "AVG DAYS" > 1.0;
-- everytime you utilize an aggregate function, you need to specify the GROUP BY line when you are selecting multiple columns
-- Exercise 3 Total Sales and Number of Orders by Customer
select O_CUSTKEY,
       SUM(O_TOTALPRICE) AS TOTAL_SALES,
       COUNT(O_ORDERKEY) AS NUMBER_OF_ORDERS
FROM ORDERS
GROUP BY O_CUSTKEY;




-- return the top 5 customers, identified by their customer key who are associated with the highest amounts of total_sales and have made 20 orders or more
select O_CUSTKEY,
       SUM(O_TOTALPRICE) AS TOTAL_SALES,
       COUNT(O_ORDERKEY) AS NUMBER_OF_ORDERS
FROM ORDERS
GROUP BY O_CUSTKEY
HAVING NUMBER_OF_ORDERS > 20
ORDER BY TOTAL_SALES DESC
LIMIT 5;

-- you can order by a column or an aggregate of a column that is not listed in the select columns section
-- ie. 
SELECT O_CUSTKEY,
       COUNT(O_ORDERKEY) as NUMBER_OF_ORDERS
FROM ORDERS
GROUP BY O_CUSTKEY
HAVING NUMBER_OF_ORDERS > 20 
ORDER BY SUM(O_TOTALPRICE) DESC
LIMIT 5;
-- in class examples
SELECT L_SHIPMODE, AVG_DAYS
FROM
(
SELECT L_SHIPMODE, AVG(L_SHIPDATE - L_COMMITDATE) as AVG_DAYS
FROM LINEITEM
GROUP BY L_SHIPMODE
)
WHERE AVG_DAYS > 1
-- a view is nothing but a query with a name
-- you can have a table in snowflake and an etl process can be used to refresh the table each day

-- to get unique values under a column in snowflake
SELECT DISTINCT L_SHIPMODE 
FROM LINEITEM;
-- or: 
SELECT L_SHIPMODE
FROM LINEITEM
GROUP BY L_SHIPMODE;

SELECT L_SHIPMODE, AVG(L_SHIPDATE - L_COMMITDATE) as AVG_DAYS
FROM LINEITEM
WHERE L_SHIPMODE IN (
    SELECT DISTINCT L_SHIPMODE 
    FROM LINEITEM 
    WHERE L_SHIPMODE NOT IN ('TRUCK', 'SHIP')
)
GROUP BY L_SHIPMODE


-- Activity 3.2.2:

SELECT * FROM REGION;

SELECT * FROM NATION;
-- Exercise 1:
-- Write a query against the Nation table that uses a subquery on the Region table to return the names of all nations except those in the America and Asia regions.
SELECT N_NATIONKEY,
       N_NAME
FROM NATION
WHERE N_REGIONKEY IN (SELECT R_REGIONKEY
                       FROM REGION
                       WHERE R_NAME NOT IN ('AMERICA', 'ASIA'));

-- using exists or not exists clauses
SELECT n_nationkey, n_name
FROM NATION as n
WHERE exists
    (
        select 1
        from region as r
        where r.r_regionkey = n.n_regionkey
        and r_name not in ('AMERICA', 'ASIA')
    );


-- Exercise 2 : Write a query against the Customer table that returns the c_custkey and c_name columns for all customers who placed exactly four orders in 1997. Use a subquery against the Orders table.
SELECT * FROM CUSTOMER;

SELECT * FROM ORDERS;
-- year function is very specific to snowflake, alternative to using year function would entail using datepart
SELECT C_CUSTKEY, C_NAME 
FROM CUSTOMER
WHERE C_CUSTKEY IN(SELECT O_CUSTKEY
                   FROM ORDERS
                   WHERE YEAR(O_ORDERDATE) = 1997
                   GROUP BY O_CUSTKEY
                   HAVING COUNT(*) = 4
); 
-- another way to do the above:
select c_custkey, c_name 
from customer c
where 4 = (
        select count(*)
        from orders o
        where date_part(year, o_orderdate) = 1997
        and o.o_custkey = c.c_custkey);

-- Exercise 3, 4, 5:
-- Exercise 3: Write a query to count the number of rows in the Supplier table, along with determining the minimum and maximum values of the s_acctbal column.
-- Exercise 4: Modify the query from Exercise 8-3 to perform the same calculations, but for each value of s_nationkey rather than for the entire table.
-- Exercise 5: Modify the query from Exercise 8-4 to return only those rows with more than 300 suppliers per s_nationkey value.
SELECT S_NATIONKEY, 
       COUNT(*) AS NUM_SUPPLIERS,
       MAX(S_ACCTBAL),
       MIN(S_ACCTBAL)
from SUPPLIER
GROUP BY S_NATIONKEY
HAVING NUM_SUPPLIERS > 300; 

-- simple vs searched case statements
-- pandas library is heavily influenced by sql
-- SIMPLE CASE
-- ORDER STATUS: (P, F, O)

-- SELECT DISTINCT O_ORDERSTATUS
-- FROM ORDERS 

SELECT O_ORDERKEY,
       O_ORDERDATE,
       O_ORDERSTATUS,
       CASE O_ORDERSTATUS
            WHEN 'P' THEN 'PARTIAL FULFILLMENT'
            WHEN 'F' THEN 'FULLY DELIVERED'
            WHEN 'O' THEN 'ORDER OUT'
            ELSE 'UNKNOWN'
        END AS STATUSDESCRIPTION
FROM ORDERS
-- single quotes are reserved for things like comparison
-- double quotes are preserved for aliases

-- SEARCH CASE:
SELECT O_ORDERKEY,
       O_ORDERDATE,
       O_ORDERSTATUS
       CASE
            WHEN O_ORDERSTATUS = 'P' THEN 'PARTIAL FULFILLMENT'
            WHEN O_ORDERSTATUS = 'F' THEN 'FULLY DELIVERED'
            WHEN O_ORDERSTATUS = 'O' THEN 'ORDER OUT'
       END AS "STATUS DESCRIPTION"
FROM ORDERS;

SELECT O_ORDERDATE,
        CASE
            WHEN o_totalprice < 100 then 'Low Sales'
            WHEN o_totalprice >= 100 then 'High Sales'
        END as SalesStatus,

        CASE 
            WHEN YEAR(O_ORDERDATE) <= 2018 then 'BEFORE ECONOMIC CRISIS'
            WHEN YEAR(O_ORDERDATE) > 2018 then 'AFTER ECONOMIC CRISIS'
        END AS YEAR_ECON,

        CASE
            WHEN YEAR(O_ORDERDATE) <= 2018 then 0_totalprice/100
            WHEN YEAR(O_ORDERDATE) > 2018 then o_totalprice/100
        end as PRICE_ADJUSTMENT
            
FROM ORDERS
        
-- Working with multiple tables
SELECT ORDERS.O_ORDERKEY, REGION.R_NAME
FROM ORDERS 
JOIN CUSTOMER ON ORDERS.O_CUSTKEY = CUSTOMER.C_CUSTKEY
JOIN NATION ON CUSTOMER.C_NATIONKEY = NATION.N_NATIONKEY
JOIN REGION ON NATION.N_REGIONKEY = REGION.R_REGIONKEY;

SELECT COUNT(ORDERS.O_ORDERKEY), REGION.R_NAME
FROM ORDERS 
JOIN CUSTOMER ON ORDERS.O_CUSTKEY = CUSTOMER.C_CUSTKEY
JOIN NATION ON CUSTOMER.C_NATIONKEY = NATION.N_NATIONKEY
JOIN REGION ON NATION.N_REGIONKEY = REGION.R_REGIONKEY
GROUP BY ORDERS.O_ORDERKEY; 

-- Determine which tables are candidates for real time ingestion - in our case, LINEITEM and ORDERS are candidates

-- Activity 3.2.3
-- Add a column named order_status to the following query that will use a case expression to return the value 'order now' if the ps_availqty value is less than 100, 'order soon' if the ps_availqty value is between 101 and 1000, and 'plenty in stock' otherwise:

SELECT PS_PARTKEY, 
       PS_SUPPKEY, 
       PS_AVAILQTY,
       CASE
            WHEN ps_availqty <= 100 THEN 'order now'
            WHEN ps_availqty >= 101 and ps_availqty <= 1000 THEN 'order soon'
            ELSE 'plenty in stock'
        end as order_status
FROM PARTSUPP
WHERE PS_PARTKEY BETWEEN 148300 AND 148450;
-- Activity 3.2.4
-- Exercise 1: Write a SQL query to retrieve a list of customers along with the total number of orders they have placed. Include customer names and the corresponding order counts. Order the results by the customer's name.
SELECT CUSTOMER.C_NAME, COUNT(ORDERS.O_ORDERKEY) AS "Number of Orders"
FROM ORDERS 
JOIN CUSTOMER ON ORDERS.O_CUSTKEY = CUSTOMER.C_CUSTKEY
GROUP BY CUSTOMER.C_NAME
ORDER BY CUSTOMER.C_NAME;

-- Exercise 2: Create a SQL query to identify high-value customers who have placed orders with a total value greater than $10,000. List the customer name, their total order value, and the number of orders they've placed. Sort the results by the total order value in descending order.

SELECT CUSTOMER.C_NAME, COUNT(ORDERS.O_ORDERKEY) AS "Number of Orders", SUM(O_TOTALPRICE) AS "Total Order Value"
FROM ORDERS
JOIN CUSTOMER ON ORDERS.O_CUSTKEY = CUSTOMER.C_CUSTKEY
GROUP BY CUSTOMER.C_NAME
HAVING "Total Order Value" > 10000
ORDER BY "Total Order Value" DESC;

-- Exercise 3: Write a SQL query to find the top 10 most popular parts (items) based on the total quantity ordered. Include the part name, part number, and the total quantity ordered for each part. Sort the results by the total quantity ordered in descending order.
SELECT PART.P_PARTKEY AS "Part Number", PART.P_NAME AS "Part Name", LINEITEM.L_QUANTITY AS "Total Quantity"
FROM PART
JOIN PARTSUPP on PART.P_PARTKEY = PARTSUPP.PS_PARTKEY
JOIN LINEITEM ON PARTSUPP.PS_PARTKEY = LINEITEM.L_PARTKEY
ORDER BY "Total Quantity" DESC;

-- Teacher's solution
SELECT 
    p.o_name as part_name,
    p.p_partkey as part_number,
    sum(l.l_quantity) as total_qty_ordered
FROM
    LINEITEM as l
    JOIN PARTSUPP as ps ON 


-- Activity 3.2.5:
-- Using the PART Table we want to focus on two Brands (#11 and #42).
-- For Brand #11 if the size is less than or equal to 20 then it is a “High Cost Part”
-- For Brand #11 if the size is greater than 20 then it is a “Low Cost Part”
-- For Brand #42 if the size is less than or equal to 20 then it is a “High Demand Part”
-- For Brand #42 if the size is greater than 20 then it is a “Low Demand Part”
-- The new column will be added is called NOTE
SELECT PART.P_BRAND,
       PART.P_TYPE,
       PART.P_SIZE,
       CASE
            WHEN PART.P_BRAND = 'Brand#11' and PART.P_SIZE <= 20 THEN 'High Cost Part'
            WHEN PART.P_BRAND = 'Brand#11' and PART.P_SIZE > 20 THEN 'Low Cost Part'
            WHEN PART.P_BRAND = 'Brand#42' and PART.P_SIZE <= 20 THEN 'High Demand Part'
            WHEN PART.P_BRAND = 'Brand#42' and PART.P_SIZE > 20 THEN 'Low Demand Part'
        end as NOTE
FROM PART
WHERE PART.P_BRAND = 'Brand#11' or PART.P_BRAND = 'Brand#42';

-- Activity 3.2.6:
-- Rewrite the following query to use a searched case expression instead of a simple case expression:
-- SELECT O_ORDERDATE, O_CUSTKEY,
       --   CASE O_ORDERSTATUS
       --     WHEN 'P' THEN 'PARTIAL'
       --     WHEN 'F' THEN 'FILLED'
       --     WHEN 'O' THEN 'OPEN'
       --   END STATUS
       -- FROM ORDERS
       -- WHERE O_ORDERKEY > 5999500;
SELECT O_ORDERKEY,
       O_ORDERDATE,
       O_ORDERSTATUS,
       CASE
            WHEN O_ORDERSTATUS = 'P' THEN 'PARTIAL FULFILLMENT'
            WHEN O_ORDERSTATUS = 'F' THEN 'FULLY DELIVERED'
            WHEN O_ORDERSTATUS = 'O' THEN 'ORDER OUT'
       END AS "STATUS"
FROM ORDERS
WHERE O_ORDERKEY > 5999500;

-- Activity 3.3.1 
-- Exercise 1 : Retrieve the c_name and c_acctbal (account balance) columns from the Customer table, but only for those rows in the Machinery segment (c_mktsegment = 'MACHINERY') and with an account balance greater than 9998.

SELECT c_name,
       c_acctbal
FROM CUSTOMER
WHERE c_mktsegment = 'MACHINERY' and c_acctbal > 9998;

-- Exercise 2: Retrieve the c_name, c_mktsegment (market segment), and c_acctbal (account balance) columns from the Customer table, but only for those rows in either the Machinery or Furniture market segments with an account balance between –1 and 1.
SELECT c_name, c_mktsegment, c_acctbal
FROM CUSTOMER
WHERE c_mktsegment IN('MACHINERY','FURNITURE') and c_acctbal BETWEEN -1 and 1;

-- Exercise 3: Retrieve the c_name, c_mktsegment (market segment), and c_acctbal (account balance) columns from the Customer table, but only for those rows where either the market segment is Machinery and the account balance is 20, or the market segment is Furniture and the account balance is 334
SELECT c_name, c_mktsegment, c_acctbal
FROM CUSTOMER
WHERE c_mktsegment = 'Machinery' and c_acctbal = 20 or c_mktsegment = 'Furniture' and c_acctbal = 334;

-- Exercise 4, 5, 6:
-- Exercise 4: Write a query to count the number of rows in the Supplier table, along with determining the minimum and maximum values of the s_acctbal column.
-- Exercise 5: Modify the query from Exercise 4 to perform the calculations, but for each value of s_nationkey rather than for the entire table.
-- Exercise 6: Modify the query from Exercise 5 to return only those rows with more than 300 suppliers per s_nationkey value.
SELECT S_NATIONKEY, COUNT(*), MIN(S_ACCTBAL), MAX(S_ACCTBAL)
FROM SUPPLIER
GROUP BY S_NATIONKEY
HAVING COUNT(*) > 300;

--  Activity 3.3.2:

-- Exercise 1: Write a SQL query to retrieve the top 5 suppliers who have the highest account balance. Include the supplier's name, nation, and account balance. Sort the results by account balance in descending order.

SELECT SUPPLIER.S_NAME as supplier_name, NATION.N_NAME as nation, SUPPLIER.S_ACCTBAL as account_balance
FROM SUPPLIER
JOIN NATION ON SUPPLIER.S_NATIONKEY = NATION.N_NATIONKEY
ORDER BY SUPPLIER.S_ACCTBAL DESC
LIMIT 5;

-- Exercise 2: Calculate the average order value for each year. Display the year and the corresponding average order value.

SELECT YEAR(O_ORDERDATE) as, AVG(O_TOTALPRICE) as avg_order_value
FROM ORDERS
GROUP BY YEAR(O_ORDERDATE); 
-- YEAR(o_orderdate) = DATE_PART(YEAR, O_ORDERDATE)
-- ROUND(AVG(o_total_price), 2) -> This can be used to round each value to 2 decimal places

-- Exercise 3: Note: Revenue is calculated is l_extendedprice*(1-l_discount)
-- Find the total revenue generated from the 'AUTOMOBILE' market segment by Year.
-- csv files don't retain data types
-- LIKE allows you to use a value that has a % sign
SELECT YEAR(O_ORDERDATE), SUM((L_EXTENDEDPRICE * (1-L_DISCOUNT))) AS "REVENUE"
FROM ORDERS
JOIN CUSTOMER ON C_CUSTKEY = O_CUSTKEY
JOIN LINEITEM ON O_ORDERKEY = L_ORDERKEY
WHERE C_MKTSEGMENT = 'AUTOMOBILE'
GROUP BY YEAR(O_ORDERDATE); 

-- Exercise 4: Determine which nation has the most suppliers.
SELECT N_NAME, COUNT(S_SUPPKEY) AS "NUMBER OF SUPPLIERS"
FROM NATION
JOIN SUPPLIER ON N_NATIONKEY = S_NATIONKEY
GROUP BY N_NAME
ORDER BY COUNT(S_SUPPKEY) DESC LIMIT 1;

-- Exercise 5: Find the month in which the highest number of orders were placed.
SELECT MONTH(O_ORDERDATE) as "MONTH", COUNT(*) as "NUMBER OF ORDERS"
FROM ORDERS
GROUP BY "MONTH"
ORDER BY "NUMBER OF ORDERS" DESC LIMIT 1;

-- Exercise 6: Calculate the average discount given on orders for each market segment.
SELECT C_MKTSEGMENT, AVG(L_DISCOUNT)
FROM ORDERS
JOIN LINEITEM ON O_ORDERKEY = L_ORDERKEY
JOIN CUSTOMER ON C_CUSTKEY = O_CUSTKEY
GROUP BY C_MKTSEGMENT;

-- Exercise 7: Determine the top 3 nations that have the highest average account balances for their suppliers.
SELECT N_NAME, AVG(S_ACCTBAL) as "AVERAGE ACCOUNT BALANCE"
FROM NATION 
JOIN SUPPLIER ON N_NATIONKEY = S_NATIONKEY
GROUP BY N_NAME
ORDER BY "AVERAGE ACCOUNT BALANCE" DESC LIMIT 3; 

-- Challenge Activity: 
-- Description
-- In this exercise, you will learn how to determine if a specific condition is met for any record in a related table using a case expression with a correlated subquery. The goal is to identify customers who have ever placed an order over $400,000. It doesn't matter how many such orders were placed; we only need to know if at least one exists.

-- Scenario
-- You are working with a retail database and want to classify customers based on their spending behavior. Specifically, you want to label customers who have placed any order over $400,000 as "Big Spender" and others as "Regular."

-- Task
-- Write an SQL query to find out if customers in a specific range have ever placed an order over $400,000. Use the CASEexpression with a correlated subquery to achieve this.

-- For now, you can use the range of customers from 74000 to 74020


SELECT c.c_custkey,
       c.c_name,
       CASE
         WHEN C.C_CUSTKEY IN
          (SELECT ORDERS.O_CUSTKEY FROM ORDERS WHERE ORDERS.O_TOTALPRICE > 400000) THEN 'BIG SPENDER'
         ELSE 'Regular'
       END AS cust_type
FROM customer c
WHERE c.c_custkey BETWEEN 74000 and 74020;