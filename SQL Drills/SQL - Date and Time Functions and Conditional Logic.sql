SELECT current_date();

select 'hello world' as greeting;

SELECT current_date() as today_date,
year(today_date) as yr -- extract year
, date_part('year', today_date) as yr_part
, month(today_date)as mnth
, date_part('month', today_date) as mnth_part
, dayname(today_date) as day_name
, next_day(today_date, 'WE') as next_date
, PREVIOUS_DAY(today_date, 'TU') as prev_date
, dateadd('day', 1, today_date) as add_1_day
, dateadd('month', 1, today_date) as add_1_month
, datediff('day', today_date, next_date);

select 
cast('124'as decimal(5, 2)), to_decimal('124'), '123'::decimal(5,1), try_to_decimal('124a'); -- casting and converting are 
-- any of the try methods prevent the program from crashing - if a value is not able to be converted to a desired type - it will be set to null 
-- Activity 4.4:
-- Exercise 1:
-- Objective: Understand how to extract different components from the current date. Instructions:

-- Write a query to get today's date.
-- Extract the year, month, quarter, and week number from today's date.
-- Get the name of the day for today's date.
SELECT CURRENT_DATE() as TODAY_DATE
, year(today_date)as yr
, month(today_date)as mnth
, quarter(today_date) as qtr
, week(today_date) as wk_num
, dayname(today_date) as day_name;


-- Exercise 2:
-- Objective: Learn how to find the next and previous occurrences of a specific day. Instructions:

-- Write a query to find the next Wednesday from today's date.
-- Write a query to find the previous Wednesday from today's date.
SELECT CURRENT_DATE() as TODAY_DATE
, next_day(today_date, 'WE') as next_wednesday
, PREVIOUS_DAY(today_date, 'WE') as previous_wednesday;

-- Exercise 3:
-- Objective: Learn how to manipulate dates by adding or subtracting time units. Instructions:

-- Write a query to add one month and one quarter to today's date.
-- Write a query to subtract one week and one year from today's date.
SELECT CURRENT_DATE() as TODAY_DATE
, dateadd('month', 1, today_date) as next_month
, dateadd('quarter', 1, today_date) as next_quarter
, dateadd('week', -1, today_date) as previous_week
, dateadd('year', -1, today_date) as previous_year;

-- Exercise 4:
-- Objective: Understand how to calculate the difference between two dates. Instructions:

-- Write a query to find the difference in days between today and the next Wednesday.
-- Write a query to find the difference in months between today and the next quarter.
SELECT CURRENT_DATE() as TODAY_DATE
, next_day(today_date, 'WE') as next_wednesday
, datediff('day', TODAY_DATE, next_wednesday) as diff_in_days
, next_day(today_date, 'WE') as next_date
, dateadd('quarter', 1, today_date) as next_quarter
, datediff('month', TODAY_DATE, next_quarter) as diff_in_months;

-- Exercise 5: 
-- Objective: Learn how to convert strings to different data types. Instructions:

-- Write a query to convert a string to a decimal using three different methods.
-- Write a query to convert a string to a date and a datetime using different functions.
SELECT
    CAST('124' as DECIMAL(5,2)) as decimal_cast,
    '124'::DECIMAL(5,2) as decimal_colon,
    TO_DECIMAL('124', 5,2) as decimal_to,
    TRY_TO_DECIMAL('12A', 5,2) as decimal_try,
    CAST('2023-10-25' as DATE) as date_cast,
    '2023-10-25'::DATE as date_colon,
    TO_DATE('2023-10-25') as date_to,
    CAST('2023-10-25' as DATETIME) as datetime_cast,
    '2023-10-25'::DATETIME as datetime_colon,
    TO_TIMESTAMP('2023-10-25') as datetime_to;

-- Exercise 6: 
-- Objective: Learn how to handle invalid data during conversions. Instructions:

-- Write a query to convert invalid strings to dates and decimals, ensuring the query does not fail.
-- Use TRY_CAST and TRY_TO_DATE functions to handle invalid data.

SELECT
    TRY_CAST('202A-10-25' as DATE) as try_date_cast,
    TRY_CAST('202A-10-25' as DATETIME) as try_datetime_cast,
    TRY_TO_DATE('202A-10-25') as try_date_to,
    TRY_TO_TIMESTAMP('202A-10-25') as try_datetime_to,
    TRY_TO_DECIMAL('12A', 5,2) as try_decimal_to;

    
-- Exercise 7:
-- Objective: Understand how to apply conditional logic in SQL using the IFF function. Instructions:

-- Write a query to determine if a number is positive, negative, or zero using the IFF function. Use the number 5 for the first column
-- Write a query to label a number as "Even" or "Odd". Use the number 4 for the second column.

SELECT IFF(5 > 0 , 'Positive', 'Negative') as number_sign,
       IFF( 4 % 2 = 0, 'Even', 'Odd') as number_parity;

-- Exercise 8:
-- ansi sql = standard sql

-- class examples:
SELECT '1720533320'::INT as epoch_int,
'1720533320'::STRING as epoch_str,
to_timestamp(epoch_int),
to_timestamp(epoch_str),
to_timestamp_ntz(epoch_int), -- no time zone
to_timestamp_ltz(epoch_int), -- local time zone
to_timestamp_tz(epoch_int); 
-- in a view, you can hide columns, you can hide secret columns
