create or replace TABLE TECHCATALYST_DE.SPATTURI.FACT_ACCIDENTS (
	ACCIDENT_ID NUMBER(38,0),
	POLICYHOLDER_ID NUMBER(38,0),
	VEHICLE_ID NUMBER(38,0),
	STATE_ID NUMBER(38,0),
	BODY_STYLE_ID NUMBER(38,0),
	ACCIDENT_TYPE_ID NUMBER(38,0),
	GENDER_MARITALSTATUS_ID NUMBER(38,0),
	VEHICLE_USECODE_ID VARCHAR(16777216),
	ACCIDENT_DATE DATE,
	VEHICLE_YEAR VARCHAR(16777216),
	POLICYHOLDER_BIRTHDATE DATE,
	ESTIMATED_COST FLOAT,
	ACTUAL_REPAIR_COST FLOAT,
	AT_FAULT BOOLEAN,
	IS_DUI BOOLEAN,
	COVERAGE_STATUS VARCHAR(16777216)
);

create or replace TABLE TECHCATALYST_DE.SPATTURI.DIM_ACCIDENT_TYPE (
	ACCIDENT_TYPE_ID NUMBER(38,0),
	ACCIDENT_TYPE VARCHAR(16777216)
);

create or replace TABLE TECHCATALYST_DE.SPATTURI.DIM_BODY_STYLE (
	BODY_STYLE_ID NUMBER(38,0),
	BODY_STYLE VARCHAR(16777216)
);

create or replace TABLE TECHCATALYST_DE.SPATTURI.DIM_GENDER_MARITAL (
	GENDER_MARITALSTATUS_ID NUMBER(38,0),
	GENDER_MARITAL_STATUS VARCHAR(16777216)
);

create or replace TABLE TECHCATALYST_DE.SPATTURI.DIM_POLICYHOLDER (
	POLICYHOLDER_ID NUMBER(38,0),
	FIRST_NAME VARCHAR(16777216),
	LAST_NAME VARCHAR(16777216),
	ADDRESS VARCHAR(16777216)
);

create or replace TABLE TECHCATALYST_DE.SPATTURI.DIM_STATES (
	STATE_ID NUMBER(38,0),
	STATE VARCHAR(16777216)
);

create or replace TABLE TECHCATALYST_DE.SPATTURI.DIM_VEHICLE_USE (
	VEHICLE_USECODE_ID VARCHAR(16777216),
	VEHICLE_USE VARCHAR(16777216)
);

INSERT INTO TECHCATALYST_DE.SPATTURI.FACT_ACCIDENTS(ACCIDENT_ID, POLICYHOLDER_ID, VEHICLE_ID, STATE_ID, BODY_STYLE_ID, ACCIDENT_TYPE_ID, GENDER_MARITALSTATUS_ID, VEHICLE_USECODE_ID, ACCIDENT_DATE, VEHICLE_YEAR, POLICYHOLDER_BIRTHDATE, ESTIMATED_COST, ACTUAL_REPAIR_COST, AT_FAULT, IS_DUI, COVERAGE_STATUS)
SELECT 
a.ACCIDENT_ID, -- get from the accidents table
a.POLICYHOLDER_ID,  -- get from the accidents table
a.VEHICLE_ID, -- get from the accidents table
s.STATE_CODE, -- get from the statecode column from the states table
bs.BODY_STYLE_CODE, -- get from bodystyle code column from the body style table 
at.ACCIDENT_TYPE_CODE, -- get from accident type code col from accidents type table
ph.GENDER_MARITAL_STATUS, -- get from the policy holder table
vu.USE_CODE, -- can use the usecode column from the vehicles_use table
a.ACCIDENT_DATE, -- can use the accident date column from accidents
v.YEAR, -- use the year column from vehicles
ph.BIRTHDATE, -- use the birthdate column from the policy holder table
a.ESTIMATED_COST,-- get from the accidents table
a.ACTUAL_REPAIR_COST, -- get from the accidents table
a.AT_FAULT, -- get from the accidents table 
a.DUI, -- get from the dui column from accidents table
ic.COVERAGE_STATUS -- get from the insurance_coverage table
from TECHCATALYST_DE.PUBLIC.INS_ACCIDENTS as a 
join TECHCATALYST_DE.PUBLIC.INS_POLICYHOLDER as ph on a.policyholder_id = ph.policyholder_id
join TECHCATALYST_DE.PUBLIC.INS_ACCIDENT_TYPE as at on a.accident_type = at.accident_type_code
join TECHCATALYST_DE.PUBLIC.INS_STATES as s on ph.state_code = s.state_code
join TECHCATALYST_DE.PUBLIC.INS_INSURANCE_COVERAGE as ic on ph.policyholder_id = ic.policyholder_id
join TECHCATALYST_DE.PUBLIC.INS_VEHICLES as v on a.vehicle_id =  v.vehicle_id
join TECHCATALYST_DE.PUBLIC.INS_BODY_STYLE as bs on bs.body_style_code = v.body_style_code
join TECHCATALYST_DE.PUBLIC.INS_VEHICLE_USE as vu on vu.vehicle_id = v.vehicle_id;
SELECT * FROM TECHCATALYST_DE.SPATTURI.FACT_ACCIDENTS;

INSERT INTO TECHCATALYST_DE.SPATTURI.DIM_ACCIDENT_TYPE (ACCIDENT_TYPE_ID, ACCIDENT_TYPE)
SELECT 
	a.ACCIDENT_ID,
	at.ACCIDENT_TYPE
from TECHCATALYST_DE.PUBLIC.INS_ACCIDENTS as a
join TECHCATALYST_DE.PUBLIC.INS_ACCIDENT_TYPE as at on a.accident_type = at.accident_type_code;
SELECT * from TECHCATALYST_DE.SPATTURI.DIM_ACCIDENT_TYPE;

INSERT INTO TECHCATALYST_DE.SPATTURI.DIM_BODY_STYLE (BODY_STYLE_ID, BODY_STYLE)
SELECT
	bs.BODY_STYLE_CODE,
	bs.BODY_STYLE
from TECHCATALYST_DE.PUBLIC.INS_BODY_STYLE as bs;
SELECT * from TECHCATALYST_DE.SPATTURI.DIM_BODY_STYLE;

INSERT INTO TECHCATALYST_DE.SPATTURI.DIM_GENDER_MARITAL(GENDER_MARITALSTATUS_ID, GENDER_MARITAL_STATUS)
SELECT
    GENDER_MARITAL_STATUS_CODE,
	GENDER_MARITAL_STATUS
FROM TECHCATALYST_DE.PUBLIC.INS_GENDER_MARITAL_STATUS;

INSERT INTO TECHCATALYST_DE.SPATTURI.DIM_POLICYHOLDER(POLICYHOLDER_ID, FIRST_NAME, LAST_NAME, ADDRESS)
SELECT
    POLICYHOLDER_ID,
	FIRST_NAME,
	LAST_NAME,
	ADDRESS
FROM TECHCATALYST_DE.PUBLIC.INS_POLICYHOLDER;

INSERT INTO TECHCATALYST_DE.SPATTURI.DIM_STATES(STATE_ID, STATE)
SELECT 
    STATE_CODE,
	STATE
FROM TECHCATALYST_DE.PUBLIC.INS_STATES;

-- Identifying the top cities(states) with the highest number of claims using SQL:
select * from TECHCATALYST_DE.SPATTURI.DIM_STATES;

SELECT ds.state, sum(fa.accident_id) as "Number of Claims"
from TECHCATALYST_DE.SPATTURI.DIM_STATES as ds
join TECHCATALYST_DE.SPATTURI.FACT_ACCIDENTS as fa on ds.state_id = fa.state_id
group by ds.state
order by "Number of Claims" desc;

-- calculating the number of claims
SELECT COUNT(accident_id) as "Total Number of Claims" from TECHCATALYST_DE.SPATTURI.FACT_ACCIDENTS;

-- calculating the number of policyholders:


-- total claim amount


-- total claim amount per accident type:


-- average claim amount: 



-- average age of policy holders:
select AVG((CURRENT_DATE() - POLICYHOLDER_BIRTHDATE) / 365) from TECHCATALYST_DE.SPATTURI.FACT_ACCIDENTS;

--minimum and maximum claim amounts:
SELECT MIN(estimated_cost) as "Minimum claim amount" from TECHCATALYST_DE.SPATTURI.FACT_ACCIDENTS;



-- oldest policyholder


-- youngest policyholder:


-- Body style for a vehicle that is associated with the largest number of claims
SELECT body_style, count(*) as "Number of Claims"
from DIM_BODY_STYLE as dbs
join FACT_ACCIDENTS as fa on fa.body_style_id = dbs.body_style_id
group by body_style
order by "Number of Claims" desc
LIMIT 1;

-- Which year has the most number of claims: 


-- What are the Top 5 Year & Months? For example August, 2020 and August 2021:


-- What are the most common Vehicle Use (Top 3)?
SELECT vehicle_use, count(*) as "Number of Claims"
from FACT_ACCIDENTS as fa
join DIM_VEHICLE_USE as dvu on dvu.vehicle_usecode_id = fa.vehicle_usecode_id
group by vehicle_use
order by "Number of Claims" desc
LIMIT 3;

-- How many policyholders have more than one claim in the dataset? -- Answer 2606
select policyholder_id, count(*) as "Number of Claims"
from fact_accidents
group by policyholder_id
having "Number of Claims" > 1; 

-- What's the average estimated cost and actual repair cost per accident type?

-- Which state has the highest discrepancy between estimated and actual repair costs?

select state, (actual_repair_cost - estimated_cost) as "Discrepency In 2 Costs"
from DIM_STATES
join FACT_ACCIDENTS on DIM_STATES.state_id = FACT_ACCIDENTS.state_id
order by "Discrepency In 2 Costs" DESC
LIMIT 1; 