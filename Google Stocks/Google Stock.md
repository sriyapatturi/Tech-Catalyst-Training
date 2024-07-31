#### Drill 1: Calculate Daily Price Change

**Objective**: Calculate the daily price change (difference between the closing price of the current day and the previous day).

**Instructions**:

1. Use the `LAG` function to get the previous day's closing price.
2. Calculate the difference between the current day's closing price and the previous day's closing price.

![image-20240710173416575](images/image-20240710173416575.png)



#### Drill 2: Calculate 30-Day Moving Average of Closing Prices

**Objective**: Calculate the 30-day moving average of the closing prices.

**Instructions**:

1. Use the `AVG` function with the `ROWS BETWEEN` clause to calculate the moving average over the last 30 days.

![image-20240710150014299](images/image-20240710150014299.png)



#### Drill 3: Calculate the Daily Percentage Change in Closing Prices

**Objective**: Calculate the daily percentage change in the closing price.

**Instructions**:

1. Use the `LAG` function to get the previous day's closing price.
2. Calculate the percentage change using the current and previous closing prices.



![image-20240710150039229](images/image-20240710150039229.png)

#### Drill 4: Identify the Highest and Lowest Closing Prices Over the Past 60 Days

**Objective**: Identify the highest and lowest closing prices over the past 60 days for each date.

**Instructions**:

1. Use the `MAX` and `MIN` functions with the `ROWS BETWEEN` clause to get the highest and lowest closing prices over the past 60 days.

![image-20240710150107781](images/image-20240710150107781.png)



#### Drill 5: Calculate the Volume Weighted Average Price (VWAP)

**Objective**: Calculate the Volume Weighted Average Price (VWAP) for each day.

**Instructions**:

1. Calculate the cumulative sum of the product of closing price and volume.
2. Calculate the cumulative sum of the volume.
3. Divide the cumulative sum of the product by the cumulative sum of the volume.

![image-20240710150205295](images/image-20240710150205295.png)