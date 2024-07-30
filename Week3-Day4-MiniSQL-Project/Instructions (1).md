# **Claims Analysis: Identifying Patterns and Trends**

## **Objective:** 

Using the dataset provided, your aim is to identify patterns and trends in insurance claims. Your findings will enable the insurance company to gain insights, understand risks better, and implement effective policies for cost reduction and customer satisfaction.

**Data:**  Please refer to the `Reference Material.md`

## **Instructions:**

1. **Data Exploration:**

   - Familiarize yourself with the dataset. Understand the columns, data types, and sample records. 
     - Run some basic queries, find number of records per table, and do some general exploration 
     - Document your queries 
   - Look for any missing or anomalous data. If found, discuss how you would handle these inconsistencies.
2. **ETL Process:** Transform the provided OLTP dataset to fit into a data model (denormalized schema) suitable for analytics in a data warehouse.

   1. Use the provided DDL in the `Reference Material.md`
   2. Perform simple ETL to migrate data from source to target tables
      1. **Source Database**: `TECHCATALYST`
      2. **Source Schema**: `PUBLIC`
         1. **Source Tables:**
            1. `INS_BODY_STYLE`
            2. `INS_ACCIDENT_TYPE`
            3. `INS_ACCIDENTS`
            4. `INS_GENDER_MARITAL_STATUS`
            5. `INS_INSURANCE_COVERAGE`
            6. `INS_POLICYHOLDER`
            7. `INS_STATES`
            8. `INS_VEHICLES`
            9. `INS_VEHICLE_USE`
            10. `INS_VEHICLE_USE_CODE`
      3. **Target Database**: `TECHCATALYST`
      4. **Target Schema**: Use your dedicated schema e.g. `TATWAN` 
         1. **Target Tables**
            1. `FACT_ACCIDENTS`
            2. `DIM_ACCIDENT_TYPE`
            3. `DIM_BODY_STYLE`
            4. `DIM_VEHICLE_USE`
            5. `DIM_POLICYHOLDER`
            6. `DIM_GENDER_MARITAL_STATUS`
            7. `DIM_STATES`
   3. Pay attention to column name changes from source to target (see `Reference Material` document which contains the DDL scripts)

## Deliverables 

**Delivered in PPT format to your instructor** 

* **Reference Architecture Diagram** (visually explain the process you took)

* Explain your process in one-slide (what did you do?, How you did it? What challenges did face?  ..etc. )

* **Data Analysis using SQL: (using the new Dimensional Model you just created)** 

  Write SQL queries to extract data that will help answer the following questions:

  - Identify the top cities with the highest number of claims using SQL

  - Provide a summary of basic statistics of the data (3-4 summary analysis). Using to SQL to include:

    - **Count:** Number of claims, number of policyholders, number of claims per location
    - **Sum:** Total claim amount, total claim amount per accident type
    - **Average:** Average claim amount, average age of policyholders
    - **Minimum and Maximum:** Minimum and maximum claim amounts. Youngest and oldest policyholders
  
  -  Which body style of vehicle has the most claims?  
  
    ​     Which year has the most claims?
  
    ​     What are the Top 5 Year & Months? For example August, 2020 and August 2021
  
    ​     What are the most common Vehicle Use (Top 3)?
  
  - How many policyholders have more than one claim in the dataset? 
  
  - What's the average estimated cost and actual repair cost per accident type? 
  
  - Are there any correlations between vehicle use (e.g., work, pleasure) and accident type? 
  
  - Which state has the highest discrepancy between estimated and actual repair costs?
  
  
