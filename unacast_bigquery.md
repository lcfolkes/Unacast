# Unacast work sample - Lars Folkestad

## Question 1: What day of week has the most rides in 2014?

### SQL query
[unacast_task1](https://bigquery.cloud.google.com/savedquery/754809503548:2489d84203df4acba447d9af0b0706c4)


```sql
#What day of week has the most rides in 2014?
#Count trips started in 2014 as 2014 rides
SELECT
CASE EXTRACT(DAYOFWEEK FROM pickup_datetime)
  WHEN 1 THEN 'Sunday'
  WHEN 2 THEN 'Monday'
  WHEN 3 THEN 'Tuesday'
  WHEN 4 THEN 'Wedsesday'
  WHEN 5 THEN 'Thursday'
  WHEN 6 THEN 'Friday'
  WHEN 7 THEN 'Saturday'
END
as Weekday
, COUNT(pickup_datetime) as RidesCount
FROM (
  SELECT pickup_datetime FROM `nyc-tlc.yellow.trips`
  WHERE EXTRACT(YEAR FROM pickup_datetime) = 2014
  )
GROUP BY weekday
ORDER BY RidesCount DESC;
```

### Output

From the chart we can see that Saturday is the day of the week with the most rides in 2014.

![Weekdays with the most rides in 2014](./img/task1.png)

## Question 2: How has the ratio of payments in cash and by credit card developed over time?

### SQL query
[unacast_task2](https://bigquery.cloud.google.com/savedquery/909239636881:4db1826329b245f8ab85af54067c41c0)

```sql
SELECT
#defined year of payment as year of dropoff, taking NYE into consideration
  EXTRACT(YEAR FROM dropoff_datetime) AS Year
  ,SUM(Case When payment_type = 'CSH' Then 1 Else 0 End )
  /SUM(Case When payment_type = 'CRD' Then 1 Else 0 End ) * 1.0 AS CashCreditRatio
FROM `nyc-tlc.yellow.trips`
#added because there was erroneous data points outside this range
#that caused zero division errors
WHERE EXTRACT(YEAR FROM dropoff_datetime) BETWEEN 2009 AND 2015
GROUP BY Year
ORDER BY Year ASC;
```

### Output

The chart clearly shows a decreasing trend in the use of cash compared to the use of credit card from 2009 to 2015.

![Cash to credit card ratio](./img/task2.png)

## Question 3: What is the most popular area to be picked up in 2014, disregarding airports?
