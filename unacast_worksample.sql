
#Question 1

#What day of the week has the most rides in 2014?
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
AS Weekday
, COUNT(pickup_datetime) as RidesCount
FROM (
  SELECT pickup_datetime FROM `nyc-tlc.yellow.trips`
  WHERE EXTRACT(YEAR FROM pickup_datetime) = 2014
  )
GROUP BY weekday
ORDER BY RidesCount DESC;


#Question 2

#How has the ratio of payments in cash and by credit card developed over time?

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

#Question 3

#What is the most popular area to be picked up in 2014, disregarding airports?

SELECT pickup_latitude, pickup_longitude, COUNT(*) AS num_trips
FROM `nyc-tlc.yellow.trips`
WHERE
  #Erroneus points in data
  NOT (pickup_latitude = 0.0 OR pickup_longitude = 0.0)
  #Approximate borders of New York metropolitan area
  AND (pickup_latitude >= 40.5 AND pickup_latitude <= 41.0)
  AND (pickup_longitude >= -74.2 AND pickup_longitude <= -73.7)
  AND EXTRACT(YEAR FROM pickup_datetime) = 2014
GROUP BY pickup_latitude, pickup_longitude
ORDER BY num_trips DESC
LIMIT 10000
