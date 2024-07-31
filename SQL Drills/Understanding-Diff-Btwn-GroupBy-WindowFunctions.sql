use role de;

use warehouse compute_wh;

 

use schema snowflake_sample_data.tpch_sf1;

 

show tables;

 -- to provide a summary table, you should use group by. Group by essentially collapses the data

select o_orderkey, o_custkey, o_clerk, o_orderstatus, o_orderpriority, count(*)

from orders

group by o_orderkey, o_custkey, o_clerk, o_orderstatus, o_orderpriority;

 

 

select o_orderstatus, o_orderpriority, count(*)

from orders

group by  o_orderstatus, o_orderpriority;

-- using window functions, takes data and adds to it, raw data remains untouched but it is utilized to create new columns

select o_orderkey, o_custkey, o_clerk, o_orderstatus, o_orderpriority,
count(o_orderkey) over (partition by o_orderstatus, o_orderpriority) as cnt_by_status_priority
from orders
order by o_orderstatus, o_orderpriority;