-- Activity 3.1.1
-- Exercise 1: Retrieve All Columns from a Table Write a SQL query to retrieve all columns from the "CUSTOMER" table.
use schema snowflake_sample_data.tpch_sf1;

select * from CUSTOMER;

-- Exercise 2: Retrieve Specific Columns Write a SQL query to retrieve only the "C_NAME" and "C_PHONE" columns from the "CUSTOMER" table.

select C_NAME, C_PHONE from CUSTOMER;

-- Exercise 3: Using Aliases Write a SQL query to retrieve the "C_NAME" and "C_ADDRESS" columns from the "CUSTOMER" table, but alias them as "Customer Name" and "Customer Address."

select C_NAME as "Customer Name",
       C_ADDRESS as "Customer Address"
FROM CUSTOMER;

-- Exercise 4: Sorting Data Write a SQL query to retrieve the "P_NAME" and "P_RETAILPRICE" columns from the "PART" table, sorted in descending order of retail price.

select P_NAME, P_RETAILPRICE from PART
ORDER BY P_RETAILPRICE DESC;


-- Activity 3.1.2

-- Exercise 1: Basic Filtering Write a SQL query to retrieve all columns from the "NATION" table in the 'UNITED STATES'

select * from NATION WHERE N_Name = 'UNITED STATES';

--Exercise 2: Filtering with Multiple Conditions Write a SQL query to retrieve the "P_NAME" and "P_RETAILPRICE" columns from the "PART" table for parts with a "P_TYPE" contains the word 'SMALL' and a "P_SIZE" of 5.

select P_NAME, P_RETAILPRICE from PART WHERE P_TYPE LIKE '%SMALL%' AND P_SIZE = 5;

--Exercise 3: Ordering Results Write a SQL query to retrieve the "O_ORDERDATE" and "O_TOTALPRICE" columns from the "ORDERS" table for orders placed in 1995 and order them by total price in descending order.

select O_ORDERDATE, O_TOTALPRICE from ORDERS
WHERE O_ORDERDATE BETWEEN '1995-01-01' and '1995-12-31'
ORDER BY o_totalprice DESC;

-- another way to do the above: 
select O_ORDERDATE, O_TOTALPRICE from ORDERS
WHERE YEAR(O_ORDERDATE) = 1995
ORDER BY o_totalprice DESC;

-- Exercise 4: Top N Results Write a SQL query to retrieve the top 10 most expensive parts from the "PART" table, including their "P_NAME" and "P_RETAILPRICE," sorted by retail price in descending order.

SELECT P_NAME, P_RETAILPRICE
FROM PART
ORDER BY P_RETAILPRICE DESC LIMIT 10; 

-- ACTIVITY 3.1.3:
--Write a SQL query to retrieve the "P_NAME" and "P_RETAILPRICE" columns from the "PART" table for parts with a retail price between $50 and $100 (inclusive)

SELECT P_NAME, P_RETAILPRICE
from PART
WHERE P_RETAILPRICE >= 50 AND P_RETAILPRICE <= 100;

-- Write a SQL query to retrieve the "O_ORDERDATE" and "O_TOTALPRICE" columns from the "ORDERS" table for orders placed in the year 1994 but not in December 1994.

select O_ORDERDATE, O_TOTALPRICE from ORDERS
WHERE O_ORDERDATE BETWEEN '1994-01-01' and '1994-11-30';
-- another way to do the above
SELECT O_ORDERDATE, O_TOTALPRICE
FROM ORDERS
WHERE YEAR(O_ORDERDATE) = 1994 AND MONTH(O_ORDERDATE) <> 12; 

-- in class examples
SELECT O_ORDERSTATUS,
       SUM(O_TOTALPRICE),
       COUNT(*)
FROM ORDERS
GROUP BY O_ORDERSTATUS;
-- you can group by the name of a column or the position of a colum, same is true with the where clause

SELECT  O_ORDERKEY,

        O_ORDERDATE, 

        O_ORDERSTATUS,

        O_TOTALPRICE

FROM ORDERS

WHERE O_ORDERSTATUS = 'F'

ORDER BY O_TOTALPRICE DESC

LIMIT 10;

 

SELECT O_ORDERKEY, 

       SUM(O_TOTALPRICE) as TOTAL_PRICE,

FROM ORDERS

WHERE O_ORDERSTATUS = 'F'

GROUP BY O_ORDERKEY

ORDER BY TOTAL_PRICE DESC

LIMIT 10;

SELECT upper('Tarek Atwan');
-- Extracting information from a date value

SELECT YEAR(DATE('2016-12-30'));

SELECT MONTH(DATE('2016-12-30'));

SELECT DAYOFWEEK(DATE('2016-12-30'));

SELECT YEAR(O_ORDERDATE) as ORDER_YEAR,
SUM(O_TOTALPRICE)
FROM ORDERS
GROUP BY ORDER_YEAR
ORDER BY ORDER_YEAR ASC;