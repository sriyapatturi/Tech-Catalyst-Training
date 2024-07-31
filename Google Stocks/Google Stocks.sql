use role de;
use warehouse compute_wh;

show databases;

use database techcatalyst_de;

show tables;
show schemas;

SELECT * 
FROM GOOGLE_STOCKS;

SELECT MAX(DATE) as maxdate, MIN(DATE) as mindate, datediff('days', mindate, maxdate)
FROM GOOGLE_STOCKS;

SELECT DATE, CLOSE, AVG(CLOSE) OVER(ORDER BY DATE ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) as moving_avg_30 
FROM GOOGLE_STOCKS; -- this is one example of smoothing the data
-- windows can be based on minutes, months, year
-- moving average = rolling window
-- similar to rolling function in python pandas 

-- Screenshot 987A -- performing the lag or shift technique in sql

SELECT DATE,
       close,
       LAG(close) OVER (ORDER BY DATE) AS PREV_CLOSE, -- to see a 2 day shift, pass in comma 2 next to close in the LAG function
       (CLOSE - PREV_CLOSE) / CLOSE as PCT_CHANGE
from google_stocks; 

-- qualify works with window functions - synanomous to a where clause

SELECT DATE,
VOLUME,
ROW_NUMBER() OVER (ORDER BY VOLUME DESC) AS RANK
FROM google_stocks
qualify rank > 5;

-- Google Stock Drills:
-- Drill 1
SELECT DATE,
       close,
       LAG(close) OVER (ORDER BY DATE) AS PREV_CLOSE,
       (CLOSE - PREV_CLOSE) AS DAILY_CHANGE
FROM google_stocks;

-- Drill 2
SELECT DATE, CLOSE, AVG(CLOSE) OVER(ORDER BY DATE ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) as moving_avg_30d 
FROM GOOGLE_STOCKS;

-- Drill 3: 
SELECT DATE,
       close,
       LAG(close) OVER (ORDER BY DATE) AS PREV_CLOSE, -- to see a 2 day shift, pass in comma 2 next to close in the LAG function
       ((CLOSE - PREV_CLOSE) / PREV_CLOSE) * 100 as PCT_CHANGE
from google_stocks; 

-- Drill 4:
SELECT DATE, CLOSE, MAX(CLOSE) OVER(ORDER BY DATE ROWS BETWEEN 59 PRECEDING AND CURRENT ROW) as max_close_60d, MIN(CLOSE) OVER(ORDER BY DATE ROWS BETWEEN 59 PRECEDING AND CURRENT ROW) as min_close_60d
FROM GOOGLE_STOCKS;

-- Drill 5: 
with cte as
(
    SELECT Date, close, GOOGLE_STOCKS.VOLUME as volume,
    SUM(GOOGLE_STOCKS.VOLUME * GOOGLE_STOCKS.CLOSE) OVER (ORDER BY Date) as CumulativeSumProduct, 
    SUM(GOOGLE_STOCKS.VOLUME) OVER (ORDER BY Date) as CumulativeSumVolume
    FROM google_stocks

)
SELECT DATE, CLOSE, volume, (CUMULATIVESUMPRODUCT / CUMULATIVESUMVOLUME) AS VWAP from cte;


-- you can use the keyword qualify with a lag function 
-- autoscaling - forecasts how big your load is
-- Google Cloud came up with BigQuery - for automl with sql 