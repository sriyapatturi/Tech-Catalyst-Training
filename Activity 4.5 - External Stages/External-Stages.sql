use ROLE de;
USE WAREHOUSE COMPUTE_WH;

SHOW TABLES;
SHOW SCHEMAS;

SHOW STAGES;
show file formats;
s3://techcatalyst-public/class/yellow_tripdata.parquet

use TECHCATALYST_DE;
use schema EXTERNAL_STAGE;

CREATE OR REPLACE STAGE TECHCATALYST_DE.EXTERNAL_STAGE.SPATTURI_STAGE
    STORAGE_INTEGRATION = s3_int
    URL='s3://techcatalyst-public';

LIST @TECHCATALYST_DE.EXTERNAL_STAGE.SPATTURI_STAGE;
LIST @SPATTURI_STAGE;
LIST @SPATTURI_STAGE PATTERN='.*csv.*';
LIST @SPATTURI_STAGE PATTERN='.*json.*';

CREATE OR REPLACE FILE FORMAT SPATTURI_json_format
TYPE = 'JSON';

CREATE OR REPLACE FILE FORMAT SPATTURI_csv_format
TYPE = 'CSV'
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1;

CREATE OR REPLACE FILE FORMAT SPATTURI_parquet_format
TYPE = 'PARQUET';

CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.SPATTURI.YELLOW_TAXI_JSON (
    VENDORID NUMBER(38,0),
    TPEP_PICKUP_DATETIME NUMBER(38,0),
    TPEP_DROPOFF_DATETIME NUMBER(38,0),
    PASSENGER_COUNT NUMBER(38,0),
    TRIP_DISTANCE FLOAT,
    RATECODEID NUMBER(38,0),
    STORE_AND_FWD_FLAG VARCHAR(16777216),
    PULOCATIONID NUMBER(38,0),
    DOLOCATIONID NUMBER(38,0),
    PAYMENT_TYPE NUMBER(38,0),
    FARE_AMOUNT FLOAT,
    EXTRA FLOAT,
    MTA_TAX FLOAT,
    TIP_AMOUNT FLOAT,
    TOLLS_AMOUNT FLOAT,
    IMPROVEMENT_SURCHARGE FLOAT,
    TOTAL_AMOUNT FLOAT,
    CONGESTION_SURCHARGE FLOAT,
    AIRPORT_FEE FLOAT
);

CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.SPATTURI.YELLOW_TAXI_CSV (
    VENDORID NUMBER(38,0),
    TPEP_PICKUP_DATETIME DATETIME,
    TPEP_DROPOFF_DATETIME DATETIME,
    PASSENGER_COUNT NUMBER(38,0),
    TRIP_DISTANCE FLOAT,
    RATECODEID NUMBER(38,0),
    STORE_AND_FWD_FLAG VARCHAR(16777216),
    PULOCATIONID NUMBER(38,0),
    DOLOCATIONID NUMBER(38,0),
    PAYMENT_TYPE NUMBER(38,0),
    FARE_AMOUNT FLOAT,
    EXTRA FLOAT,
    MTA_TAX FLOAT,
    TIP_AMOUNT FLOAT,
    TOLLS_AMOUNT FLOAT,
    IMPROVEMENT_SURCHARGE FLOAT,
    TOTAL_AMOUNT FLOAT,
    CONGESTION_SURCHARGE FLOAT,
    AIRPORT_FEE FLOAT
);

CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.SPATTURI.YELLOW_TAXI_PARQUET (
    VENDORID NUMBER(38,0),
    TPEP_PICKUP_DATETIME NUMBER(38,0),
    TPEP_DROPOFF_DATETIME NUMBER(38,0),
    PASSENGER_COUNT NUMBER(38,0),
    TRIP_DISTANCE FLOAT,
    RATECODEID NUMBER(38,0),
    STORE_AND_FWD_FLAG VARCHAR(16777216),
    PULOCATIONID NUMBER(38,0),
    DOLOCATIONID NUMBER(38,0),
    PAYMENT_TYPE NUMBER(38,0),
    FARE_AMOUNT FLOAT,
    EXTRA FLOAT,
    MTA_TAX FLOAT,
    TIP_AMOUNT FLOAT,
    TOLLS_AMOUNT FLOAT,
    IMPROVEMENT_SURCHARGE FLOAT,
    TOTAL_AMOUNT FLOAT,
    CONGESTION_SURCHARGE FLOAT,
    AIRPORT_FEE FLOAT
);

COPY INTO TECHCATALYST_DE.SPATTURI.YELLOW_TAXI_CSV
FROM @SPATTURI_STAGE/class/yellow_tripdata.csv
FILE_FORMAT = 'spatturi_csv_format'
ON_ERROR = CONTINUE;

select * from TECHCATALYST_DE.SPATTURI.YELLOW_TAXI_CSV;

COPY INTO TECHCATALYST_DE.SPATTURI.YELLOW_TAXI_PARQUET
FROM @SPATTURI_STAGE/class/yellow_tripdata.parquet
FILE_FORMAT = 'spatturi_parquet_format'
ON_ERROR = CONTINUE
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

select * from TECHCATALYST_DE.SPATTURI.YELLOW_TAXI_PARQUET;

CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.SPATTURI.SIMPLE_TAXI_DATA_JSON (
    VENDORID NUMBER(38,0),
    TRIP_DISTANCE FLOAT,
    TOTAL_AMOUNT FLOAT
);

SELECT value
FROM @SPATTURI_STAGE/class/yellow_tripdata.json
(FILE_FORMAT => 'spatturi_json_format'),
LATERAL FLATTEN(input => PARSE_JSON($1));

INSERT INTO TECHCATALYST_DE.SPATTURI.SIMPLE_TAXI_DATA_JSON
SELECT value:VendorID::number,
       value:trip_distance::float,
       value:total_amount::float
FROM @SPATTURI_STAGE/class/yellow_tripdata.json
(FILE_FORMAT => 'spatturi_json_format'),
LATERAL FLATTEN(input => PARSE_JSON($1));    

SELECT * from TECHCATALYST_DE.SPATTURI.SIMPLE_TAXI_DATA_JSON;

CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.SPATTURI.SIMPLE_TAXI_DATA_CSV (
    VENDORID NUMBER(38,0),
    TRIP_DISTANCE FLOAT,
    TOTAL_AMOUNT FLOAT
);

INSERT INTO TECHCATALYST_DE.SPATTURI.SIMPLE_TAXI_DATA_CSV
(VENDORID, TRIP_DISTANCE, TOTAL_AMOUNT)
select $1::NUMBER, $5::FLOAT, $17::FLOAT
from @SPATTURI_STAGE/class/yellow_tripdata.csv
(FILE_FORMAT => spatturi_csv_format);

CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.SPATTURI.SIMPLE_TAXI_DATA_PARQUET(
    VENDORID NUMBER(38,0),
    TRIP_DISTANCE FLOAT,
    TOTAL_AMOUNT FLOAT
);

-- remember that the name of column names in json are case-sensitive

INSERT INTO TECHCATALYST_DE.SPATTURI.SIMPLE_TAXI_DATA_PARQUET
select $1:VendorID::NUMBER as VENDORID, $1:trip_distance::FLOAT as TRIP_DISTANCE, $1:total_amount::FLOAT as TOTAL_AMOUNT
from @SPATTURI_STAGE/class/yellow_tripdata.parquet
(FILE_FORMAT => spatturi_parquet_format);
select $1
from @SPATTURI_STAGE/class/yellow_tripdata.parquet
(FILE_FORMAT => spatturi_parquet_format);

-- Challenge 2:
CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.SPATTURI.SUMMARY_TAXI_DATA_JSON (
    VENDORID NUMBER(38,0),
    TPEP_PICKUP_DATETIME TIMESTAMP,
    TPEP_DROPOFF_DATETIME TIMESTAMP,
  	TPEP_MONTH NUMBER,
    TPEP_YEAR NUMBER,
	  TPEP_IS_WEEKEND STRING,
    PASSENGER_COUNT NUMBER(38,0),
    TRIP_DURATION_MINUTES FLOAT,
    TOTAL_AMOUNT FLOAT
);

INSERT INTO TECHCATALYST_DE.SPATTURI.SUMMARY_TAXI_DATA_JSON
SELECT value:VendorID::number,
       value:tpep_pickup_datetime::timestamp,
       value:tpep_dropoff_datetime::timestamp,
       MONTH(value:tpep_pickup_datetime::timestamp),
       YEAR(value:tpep_pickup_datetime::timestamp),
       CASE 
            WHEN DAYNAME(value:tpep_pickup_datetime::timestamp) = 'Sat' THEN 'Weekend'
            WHEN DAYNAME(value:tpep_pickup_datetime::timestamp) = 'Sun' THEN 'Weekend' 
            ELSE 'Weekday' 
        END AS TPEP_IS_WEEKEND,
       value:passenger_count::number,
       ABS(TIMESTAMPDIFF(MINUTE,value:tpep_dropoff_datetime::timestamp, value:tpep_pickup_datetime::timestamp)),
       value:fare_amount::float + value:extra::float + value:tip_amount::float + value:tolls_amount::float + value:Airport_fee::float
FROM @SPATTURI_STAGE/class/yellow_tripdata.json
(FILE_FORMAT => 'spatturi_json_format'),
LATERAL FLATTEN(input => PARSE_JSON($1)); 

CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.SPATTURI.SUMMARY_TAXI_DATA_CSV (
    VENDORID NUMBER(38,0),
    TPEP_PICKUP_DATETIME TIMESTAMP,
    TPEP_DROPOFF_DATETIME TIMESTAMP,
  	TPEP_MONTH NUMBER,
    TPEP_YEAR NUMBER,
	  TPEP_IS_WEEKEND STRING,
    PASSENGER_COUNT NUMBER(38,0),
    TRIP_DURATION_MINUTES FLOAT,
    TOTAL_AMOUNT FLOAT
);


-- 1 - vendor id, 2 - pickup, 3 - dropoff, 4 - passanger count, 11- fare amount, 12 - extra, 14 - tip amount, 15 - tolls amount, 19 - airport fee
-- csv work:
INSERT INTO TECHCATALYST_DE.SPATTURI.SUMMARY_TAXI_DATA_CSV
(VENDORID, TPEP_PICKUP_DATETIME, TPEP_DROPOFF_DATETIME, TPEP_MONTH, TPEP_YEAR, TPEP_IS_WEEKEND, PASSENGER_COUNT, TRIP_DURATION_MINUTES, TOTAL_AMOUNT)
SELECT $1::number,
       $2::timestamp,
       $3::timestamp,
       MONTH($2::timestamp),
       YEAR($2::timestamp),
       CASE 
            WHEN DAYNAME($2::timestamp) = 'Sat' THEN 'Weekend'
            WHEN DAYNAME($2::timestamp) = 'Sun' THEN 'Weekend' 
            ELSE 'Weekday' 
        END AS TPEP_IS_WEEKEND,
       $4::number,
       ABS(TIMESTAMPDIFF(MINUTE,$3::timestamp, $2::timestamp)),
       $11::float + $12::float + $14::float + $15::float + $19::float
FROM @SPATTURI_STAGE/class/yellow_tripdata.csv
(FILE_FORMAT => 'spatturi_csv_format');

-- parquet work: 
CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.SPATTURI.SUMMARY_TAXI_DATA_PARQUET (
    VENDORID NUMBER(38,0),
    TPEP_PICKUP_DATETIME TIMESTAMP,
    TPEP_DROPOFF_DATETIME TIMESTAMP,
  	TPEP_MONTH NUMBER,
    TPEP_YEAR NUMBER,
	  TPEP_IS_WEEKEND STRING,
    PASSENGER_COUNT NUMBER(38,0),
    TRIP_DURATION_MINUTES FLOAT,
    TOTAL_AMOUNT FLOAT
);

-- cast tpep_pickup_datetime to a string before passing it into the TO_TIMESTAMP method, just so that this method can take only one argument

INSERT INTO TECHCATALYST_DE.SPATTURI.SUMMARY_TAXI_DATA_PARQUET
SELECT $1:VendorID::number,
       TO_TIMESTAMP($1:tpep_pickup_datetime, 6),
       TO_TIMESTAMP($1:tpep_dropoff_datetime, 6),
       -- $1:tpep_pickup_datetime::timestamp,
       -- $1:tpep_dropoff_datetime::timestamp,
       MONTH($1:tpep_pickup_datetime::timestamp),
       YEAR($1:tpep_pickup_datetime::timestamp),
       CASE 
            WHEN DAYNAME($1:tpep_pickup_datetime::timestamp) = 'Sat' THEN 'Weekend'
            WHEN DAYNAME($1:tpep_pickup_datetime::timestamp) = 'Sun' THEN 'Weekend' 
            ELSE 'Weekday' 
        END AS TPEP_IS_WEEKEND,
       $1:passenger_count::number,
       ABS(TIMESTAMPDIFF(MINUTE,$1:tpep_dropoff_datetime::timestamp, $1:tpep_pickup_datetime::timestamp)),
       $1:fare_amount::float + $1:extra::float + $1:tip_amount::float + $1:tolls_amount::float + $1:Airport_fee::float
FROM @SPATTURI_STAGE/class/yellow_tripdata.parquet
(FILE_FORMAT => 'spatturi_parquet_format');


SELECT * FROM TECHCATALYST_DE.SPATTURI.SUMMARY_TAXI_DATA_PARQUET;

-- class examples - pass in location and file format into the infer_schema method

CREATE OR REPLACE FILE FORMAT tatwan_json_strip_format

TYPE = 'JSON'

STRIP_OUTER_ARRAY = true;

 

 

 

SELECT *

FROM TABLE(

  INFER_SCHEMA(

    LOCATION=>'@TAGTWAN_AWS_STAGE/class/yellow_tripdata.parquet',

    FILE_FORMAT=>'tatwan_parquet_format'

  )

);

 

 

SELECT *

FROM TABLE(

  INFER_SCHEMA(

    LOCATION=>'@TAGTWAN_AWS_STAGE/class/yellow_tripdata.csv',

    FILE_FORMAT=>'tatwan_csv_format'

  )

);

 

 

SELECT *

FROM TABLE(

  INFER_SCHEMA(

    LOCATION=>'@TAGTWAN_AWS_STAGE/class/yellow_tripdata.json',

    FILE_FORMAT=>'tatwan_json_strip_format'

  )

);