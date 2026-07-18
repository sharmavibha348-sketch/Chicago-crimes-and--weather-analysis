
-- 6. What month had the most crimes reported and what was the average and median
-- temperature high in the last six years?

SELECT
    COUNT(*) AS number_of_crimes,
    EXTRACT(MONTH FROM w.weather_date) AS month_new,
    TO_CHAR(w.weather_date, 'FMMonth') AS month_name,
    ROUND(AVG(w.temp_high), 2) AS average_high_temperature,
    PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY w.temp_high) AS median_high_temperature
FROM chicago.crimes AS c
JOIN chicago.weather AS w
ON TO_TIMESTAMP(c.date_reported, 'MM/DD/YYYY HH24:MI')::DATE = w.weather_date
GROUP BY
    EXTRACT(MONTH FROM w.weather_date),
    TO_CHAR(w.weather_date, 'FMMonth')
ORDER BY number_of_crimes DESC, month_new ASC;

/*

month    |n_crimes|avg_high_temp|median_high_temp|
---------+--------+-------------+----------------+
July     |  135240|         85.1|            86.0|
August   |  134712|         84.1|            85.0|
October  |  128470|         62.9|            62.0|
June     |  127774|         81.6|            81.0|
September|  127567|         77.4|            78.0|
May      |  126130|         72.2|            73.0|
December |  117531|         41.3|            41.0|
November |  116688|         48.3|            47.0|
March    |  113630|         47.7|            47.0|
January  |  113133|         33.4|            34.0|
April    |  109391|         57.8|            56.0|
February |  100713|         36.6|            37.0|

*/

select * 
from chicago.crimes
limit 10
select * 
from chicago.weather
limit 10

-- 7. What month had the most homicides reported and what was the average and median
-- temperature high in the last six years?
 SELECT
    count(*) as number_of_crimes,
    AVG(w.temp_high) as Average_high_temprature,
     PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY w.temp_high) AS median_high_temperature,
    EXTRACT(MONTH FROM w.weather_date),
    TO_CHAR(w.weather_date, 'FMMonth') AS month_name
    from chicago.crimes as c
    inner join chicago.weather as w
    ON TO_TIMESTAMP(c.date_reported, 'MM/DD/YYYY HH24:MI')::DATE = w.weather_date
    where c.primary_type='HOMICIDE'
    GROUP BY EXTRACT(MONTH FROM w.weather_date),
    TO_CHAR(w.weather_date, 'FMMonth')
order by number_of_crimes desc
/*| Month     | Number of Homicides | Average High Temperature (°F) | Median High Temperature (°F) |
| --------- | ------------------: | ----------------------------: | ---------------------------: |
| July      |                 459 |                         85.25 |                         86.0 |
| June      |                 432 |                         82.54 |                         83.0 |
| September |                 404 |                         78.12 |                         79.0 |
| May       |                 391 |                         73.07 |                         74.0 |
| August    |                 389 |                         84.36 |                         85.0 |
| October   |                 350 |                         63.87 |                         64.0 |
| April     |                 331 |                         59.85 |                         58.0 |
| November  |                 317 |                         50.21 |                         49.0 |
| December  |                 287 |                         41.74 |                         42.0 |
| January   |                 256 |                         33.80 |                         34.0 |
| February  |                 228 |                         36.49 |                         37.5 |
| March     |                 222 |                         49.11 |                         48.0 |*/

-- 8. List the most violent year and the number of arrests with percentage.  Order by the number of crimes in decending order.  
-- Determine the most violent year by the number of reported Homicides, Assaults and Battery for that year.
select c.year,
count(*) AS Number_of_Crimes,
 sum(case 
    when arrest= true then 1 
    else 0  
    end) AS Number_of_Arrests,
 CONCAT(sum(case 
    when arrest = true then 1 
    else 0  
    end) *100/count(*),'%') as arrest_percentage
from chicago.crimes as c
where 
    c.primary_type IN ('HOMICIDE','ASSAULT','BATTERY')
GROUP BY c.year
ORDER BY Number_of_Crimes DESC

/*
most_violent_year|reported_violent_crimes|number_of_arrests|
-----------------+-----------------------+-----------------+
             2018|                  70835|13907 (19.63%)   |
             2019|                  70645|14334 (20.29%)   |
             2023|                  67355|9340 (13.87%)    |
             2022|                  62412|8165 (13.08%)    |
             2021|                  61611|7855 (12.75%)    |
             2020|                  60562|9577 (15.81%)    |
*/
--9. List the day of the week, year, average precipitation,
-- average high temperature and the highest number of reported 
--crimes for days with and without precipitation.

with crime_summary as(
select c.year,
count(*) AS number_of_crimes,
TO_CHAR(w.weather_date, 'FMDay') AS day_of_week,
case when w.precipitation>0 then 'With Precipitation'
    else 'Without Precipitation'
    end as precipitation_status,

AVG(w.precipitation) AS Average_precipitation,
AVG(w.temp_high) AS average_high_temperature

from chicago.crimes as c
inner join chicago.weather as w
ON TO_TIMESTAMP(c.date_reported, 'MM/DD/YYYY HH24:MI')::DATE = w.weather_date
 WHERE w.precipitation > 0
GROUP BY
    c.year,
    precipitation_status,
    TO_CHAR(w.weather_date, 'FMDay') 
 ), -- sql only allows one with clause to use(All the CTEs belong to one query, so they're declared together.)
 ranked as (
 select *,
 row_number() over (partition by year 
 order by number_of_crimes desc)AS rn
 from crime_summary
 )
 select * 
 from ranked
 where rn=1
 /*| Year | Number of Crimes | Day of Week | Precipitation Status  | Average Precipitation | Average High Temperature | RN |
| ---- | ---------------: | ----------- | --------------------- | --------------------: | -----------------------: | -: |
| 2018 |           25,667 | Friday      | Without Precipitation |                     0 |      60.2399579226243815 |  1 |
| 2019 |           27,042 | Friday      | Without Precipitation |                     0 |      57.0894534427926928 |  1 |
| 2020 |           23,477 | Sunday      | Without Precipitation |                     0 |      61.5108403969842825 |  1 |
| 2021 |           22,840 | Monday      | Without Precipitation |                     0 |      65.3052101576182137 |  1 |
| 2022 |           26,026 | Monday      | Without Precipitation |                     0 |      59.9494736033197572 |  1 |
| 2023 |           27,157 | Tuesday     | Without Precipitation |                     0 |      65.3974297602828000 |  1 |*/

/*| Year | Number of Crimes | Day of Week | Precipitation Status | Average Precipitation | Average High Temperature | RN |
| ---- | ---------------: | ----------- | -------------------- | --------------------: | -----------------------: | -: |
| 2018 |           16,455 | Monday      | With Precipitation   |     0.573600729261616 |      60.2308113035551504 |  1 |
| 2019 |           19,411 | Wednesday   | With Precipitation   |   0.30510586780692156 |      64.0001030343619597 |  1 |
| 2020 |           11,394 | Wednesday   | With Precipitation   |    0.2893838862559312 |      63.5373003335088643 |  1 |
| 2021 |           10,889 | Sunday      | With Precipitation   |   0.30090641932225043 |      57.1205804022407935 |  1 |
| 2022 |           13,029 | Friday      | With Precipitation   |    0.2118704428582394 |      51.4390973981119042 |  1 |
| 2023 |           15,855 | Friday      | With Precipitation   |   0.24191422264270246 |      60.1431094292021444 |  1 |*/

-- 10. List the days with the most reported crimes when there is zero precipitation and
-- the day when precipitation is greater than .5".  Include the day of the week, high temperature,
-- amount and precipitation and the total number of reported crimes for that day. 
 with prectype as(
select 
 w.weather_date,
 TO_CHAR(w.weather_date,'Day') as day_of_week,
 COUNT(*) AS number_of_Crimes,
 w.precipitation,
 w.temp_high,
 CASE
    WHEN precipitation = 0 THEN 'No Rain'
    WHEN precipitation > 0.5 THEN 'Heavy Rain'
END as precipitaion_type
FROM chicago.crimes as c
inner join chicago.weather as w
on TO_TIMESTAMP(c.date_reported, 'MM/DD/YYYY HH24:MI')::DATE = w.weather_date
where w.precipitation=0 or w.precipitation>0.5
group by  TO_CHAR(w.weather_date,'Day'),
w.temp_high, w.weather_date,w.precipitation
 ),
  rain as (select * ,
 row_number () over(
    PARTITION BY precipitaion_type
    ORDER BY number_of_crimes DESC
 ) as rn
 from prectype)
 select *
 from rain
 WHERE rn <= 10
/*| Rank | Weather Date | Day of Week | Number of Crimes | Precipitation (in.) | High Temperature (°F) |
| ---: | ------------ | ----------- | ---------------: | ------------------: | --------------------: |
|    1 | 2018-10-01   | Monday      |              926 |                1.56 |                    72 |
|    2 | 2023-06-25   | Sunday      |              869 |                0.77 |                    86 |
|    3 | 2018-05-30   | Wednesday   |              847 |                0.90 |                    86 |
|    4 | 2023-06-01   | Thursday    |              847 |                0.88 |                    91 |
|    5 | 2018-03-01   | Thursday    |              838 |                0.81 |                    46 |
|    6 | 2018-06-16   | Saturday    |              826 |                0.65 |                    92 |
|    7 | 2019-05-01   | Wednesday   |              824 |                0.80 |                    58 |
|    8 | 2018-12-01   | Saturday    |              820 |                1.13 |                    42 |
|    9 | 2019-09-13   | Friday      |              817 |                1.35 |                    77 |
|   10 | 2018-06-09   | Saturday    |              816 |                1.31 |                    82 |*/

/*| Rank | Weather Date | Day of Week | Number of Crimes | High Temperature (°F) |
| ---: | ------------ | ----------- | ---------------: | --------------------: |
|    1 | 2020-05-31   | Sunday      |            1,899 |                    69 |
|    2 | 2018-06-01   | Friday      |            1,022 |                    76 |
|    3 | 2018-05-01   | Tuesday     |            1,016 |                    86 |
|    4 | 2020-01-01   | Wednesday   |              997 |                    42 |
|    5 | 2018-01-01   | Monday      |              994 |                     1 |
|    6 | 2018-08-01   | Wednesday   |              945 |                    85 |
|    7 | 2018-11-01   | Thursday    |              940 |                    52 |
|    8 | 2019-06-01   | Saturday    |              930 |                    80 |
|    9 | 2019-08-01   | Thursday    |              925 |                    80 |
|   10 | 2020-05-30   | Saturday    |              924 |                    73 |*/





