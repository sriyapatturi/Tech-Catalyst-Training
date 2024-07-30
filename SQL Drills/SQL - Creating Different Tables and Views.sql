use snowflake_sample_data.tpch_sf1;
CREATE TEMPORARY TABLE TECHCATALYST_DE.SPATTURI.customer_sales(
    c_custkey int,
    c_name char(30),
    total_sales float
);
INSERT INTO TECHCATALYST_DE.SPATTURI.customer_sales(c_custkey, c_name, total_sales) 
select c_custkey, c_name, sum(o_totalprice) as total_sales
from customer
join orders on c_custkey = o_custkey
group by c_custkey, c_name
order by total_sales desc;

select * from TECHCATALYST_DE.SPATTURI.customer_sales;
-- Task: Write a query to find the average shipping time per supplier and store the results in a transient table.
CREATE TRANSIENT TABLE TECHCATALYST_DE.SPATTURI.supplier_ship_days(
    s_suppkey int,
    s_name char(30),
    avg_shipping_days float
);
INSERT INTO TECHCATALYST_DE.SPATTURI.supplier_ship_days(s_suppkey, s_name, avg_shipping_days) 
select s_suppkey, s_name, avg(l_receiptdate - l_shipdate) as avg_shipping_days
from supplier
join partsupp on s_suppkey = ps_suppkey 
join lineitem on ps_suppkey = l_suppkey
group by s_suppkey, s_name;
-- Task: Write a query to find the total sales for each nation by year and store the results in a view.
CREATE VIEW TECHCATALYST_DE.SPATTURI.nation_total_sales_by_year as
select n_name, YEAR(o_orderdate) as order_year, sum(o_totalprice) as total_sales
from nation
join customer on n_nationkey = c_nationkey 
join orders on c_custkey = o_custkey
group by n_name, order_year;

-- Task: Write a query to find the average order price per market segment and store the results in a standard table.
CREATE TABLE TECHCATALYST_DE.SPATTURI.avg_order_mkt_segment(
    c_mktsegment char(30),
    avg_order_price float
);
INSERT INTO TECHCATALYST_DE.SPATTURI.avg_order_mkt_segment(c_mktsegment, avg_order_price)
select c_mktsegment, avg(o_totalprice) as avg_order_price
FROM CUSTOMER
join orders on c_custkey = o_custkey
group by c_mktsegment;


