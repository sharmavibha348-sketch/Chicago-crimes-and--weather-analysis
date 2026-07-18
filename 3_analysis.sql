-- 12. What are the top 10 most common locations for reported crimes and the number 
--of reported crime (add percentage) 
-- depending on the temperature?

select count(*)  as number_of_Crimes,
 concat(round(count(*)*100.0/(
    select  count(*)
   FROM chicago.crimes
 ),2),'%')AS percentage_of_crimes,
location_description,
sum(
		    CASE
				WHEN w.temp_high >= 60 AND w.temp_high < 90 THEN 1
				ELSE 0
			END) AS crimes_in_Warm_weather,
sum(
			CASE
				WHEN w.temp_high >= 90 THEN 1
				ELSE 0
			END) AS crimes_in_hot_weather,
sum(
			CASE
				WHEN w.temp_high < 60 AND w.temp_high >= 32 THEN 1
				ELSE 0
			END) AS crimes_in_cold_weather,
sum(
			CASE
				WHEN w.temp_high < 32 THEN 1
				ELSE 0
			END) AS freezing_weather
FROM chicago.crimes as c
inner join chicago.weather as w
ON TO_TIMESTAMP(c.date_reported, 'MM/DD/YYYY HH24:MI')::DATE = w.weather_date
group by location_description
order by number_of_Crimes desc
limit 10

/*| Rank | Location Description                   | Total Crimes | % of Total Crimes | Warm Weather | Hot Weather | Cold Weather | Freezing Weather |
| :--: | -------------------------------------- | -----------: | :---------------: | -----------: | ----------: | -----------: | ---------------: |
|   1  | Street                                 |      363,349 |       25.04%      |      180,260 |      23,918 |      136,783 |           22,388 |
|   2  | Apartment                              |      245,159 |       16.90%      |      113,450 |      15,218 |       98,388 |           18,103 |
|   3  | Residence                              |      221,626 |       15.27%      |      101,749 |      14,121 |       89,374 |           16,382 |
|   4  | Sidewalk                               |       92,128 |       6.35%       |       49,108 |       6,962 |       31,372 |            4,686 |
|   5  | Small Retail Store                     |       39,506 |       2.72%       |       18,481 |       2,433 |       15,701 |            2,891 |
|   6  | Restaurant                             |       31,822 |       2.19%       |       14,396 |       1,900 |       13,033 |            2,493 |
|   7  | Alley                                  |       30,873 |       2.13%       |       16,105 |       2,172 |       11,015 |            1,581 |
|   8  | Parking Lot / Garage (Non-Residential) |       30,555 |       2.11%       |       15,879 |       2,041 |       11,083 |            1,552 |
|   9  | Vehicle (Non-Commercial)               |       22,795 |       1.57%       |       10,875 |       1,527 |        8,805 |            1,588 |
|  10  | Other                                  |       22,728 |       1.57%       |        9,647 |       1,251 |        9,587 |            2,243 |*/



-- 13. Calculate the year over year growth in the number of reported crimes.
WITH yearly_crimes as(
 select count(*) as number_of_crimes,
 year
 from chicago.crimes
 group by year
),
   test_table as
   (select *,
   lag(number_of_crimes) over(order by year) as previous_year_value
  from yearly_crimes)

select year,
number_of_crimes,
previous_year_value,
 round((number_of_crimes-previous_year_value)*100.0/previous_year_value,2) as "yoy growth"
from test_table
/*
reported_crime_year|num_of_crimes|prev_year_count|year_over_year|
-------------------+-------------+---------------+--------------+
               2018|       268816|         [NULL]|        [NULL]|
               2019|       261293|         268816|         -2.80|
               2020|       212176|         261293|        -18.80|
               2021|       208759|         212176|         -1.61|
               2022|       238736|         208759|         14.36|
               2023|       261199|         238736|          9.41|	
*/


WITH yearly_crimes as(
 select count(*) as number_of_crimes,
 year
 from chicago.crimes
 where crimes.domestic=true
 group by year
 
),
   test_table as
   (select *,
   lag(number_of_crimes) over(order by year) as previous_year_value
  from yearly_crimes)

select year,
number_of_crimes,
previous_year_value,
 round((number_of_crimes-previous_year_value)*100.0/previous_year_value,2) as "yoy growth"
from test_table
/*
domestic_crime_year|num_of_crimes|prev_year_count|domestic_yoy|
-------------------+-------------+---------------+------------+
               2018|        44099|         [NULL]|      [NULL]|
               2019|        43344|          44099|       -1.71|
               2020|        39983|          43344|       -7.75|
               2021|        45018|          39983|       12.59|
               2022|        42530|          45018|       -5.53|
               2023|        46834|          42530|       10.12|	
*/
-- 15. Calculate the cumulative Month over Month growth in the number of reported crimes and avergage temperature high.

 with reported_crimes as(
select
TO_CHAR(w.weather_date, 'FMMonth') AS month_name,
EXTRACT(MONTH FROM  w.weather_date) as Month,
count(*) as number_of_crimes,
round(avg(w.temp_high),2) as avg_temprature
from chicago.crimes as c
inner join chicago.weather as w
ON TO_TIMESTAMP(c.date_reported, 'MM/DD/YYYY HH24:MI')::DATE = w.weather_date
group by EXTRACT(MONTH FROM  w.weather_date),TO_CHAR(w.weather_date, 'FMMonth') 
 ),
 lag_table as (
 select *,
 lag(number_of_crimes)over(order by Month) as prev_month_count,
lag(avg_temprature)over(order by Month) as prev_month_temprature
 from reported_crimes
 )
 select  month_name,
 month,
 number_of_crimes,
 avg_temprature,
 (number_of_crimes - prev_month_count)*100/number_of_crimes as "MOM growth for crimes",
  round((avg_temprature - prev_month_temprature)*100/avg_temprature,2) as "MOM for temprature"
 from lag_table

 /*| Month     | Number of Crimes | Average High Temperature (°F) | MoM Growth in Crimes (%) | MoM Growth in Temperature (%) |
| --------- | ---------------: | ----------------------------: | -----------------------: | ----------------------------: |
| January   |          113,133 |                         33.36 |                        — |                             — |
| February  |          100,713 |                         36.59 |                      -12 |                          8.83 |
| March     |          113,630 |                         47.66 |                       11 |                         23.23 |
| April     |          109,391 |                         57.81 |                       -3 |                         17.56 |
| May       |          126,130 |                         72.22 |                       13 |                         19.95 |
| June      |          127,774 |                         81.56 |                        1 |                         11.45 |
| July      |          135,240 |                         85.07 |                        5 |                          4.13 |
| August    |          134,712 |                         84.09 |                        0 |                         -1.17 |
| September |          127,567 |                         77.35 |                       -5 |                         -8.71 |
| October   |          128,470 |                         62.94 |                        0 |                        -22.89 |
| November  |          116,688 |                         48.32 |                      -10 |                        -30.26 |
| December  |          117,531 |                         41.27 |                        0 |                        -17.08 |*/


--16. List the number of crimes reported and seasonal growth for each astronomical season and 
--what was the average temperature for each season in 2020? 
-- Use a conditional statement to display either a Gain/Loss for the season and the season over season growth. 
 with table_Season as(
select 
 case when EXTRACT(MONTH FROM w.weather_date) IN(12,1,2) THEN 'Winter'
 when EXTRACT(MONTH FROM w.weather_date) IN(3,4,5) THEN 'Spring'
 when EXTRACT(MONTH FROM w.weather_date) IN(6,7,8) THEN 'Summer'
else 'Autumn'
end as Seasons,
round(AVG(w.temp_high),2) as Average_Temprature,
count(*) as number_of_crimes
from chicago.crimes as c
inner join chicago.weather as w
on w.weather_date=TO_TIMESTAMP(c.date_reported,'MM/DD/YYYY HH24:MI')::Date
where extract(year from w.weather_date) =2020

GROUP BY
    CASE
        WHEN EXTRACT(MONTH FROM w.weather_date) IN (12,1,2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM w.weather_date) IN (3,4,5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM w.weather_date) IN (6,7,8) THEN 'Summer'
        ELSE 'Autumn'
    end
 ),
lag_table2 as(
 select *,
 lag(Average_Temprature) over(order by seasons) as previous_temprature,
 lag(number_of_crimes) over(order by seasons) as previous_crimes
 from table_Season
)

select *,
round((average_temprature-previous_temprature)*100/average_temprature,2) as "temprature growth",
(number_of_crimes-previous_crimes)*100/number_of_crimes as "crimes growth"
from lag_table2

/*| Season | Average Temperature (°F) | Number of Crimes | Previous Temperature (°F) | Previous Crimes | Temperature Growth (%) | Crime Growth (%) |
| ------ | -----------------------: | ---------------: | ------------------------: | --------------: | ---------------------: | ---------------: |
| Autumn |                    64.50 |           53,030 |                         — |               — |                      — |                — |
| Spring |                    60.11 |           47,282 |                     64.50 |          53,030 |                  -7.30 |              -12 |
| Summer |                    86.39 |           57,224 |                     60.11 |          47,282 |                  30.42 |               17 |
| Winter |                    37.66 |           54,640 |                     86.39 |          57,224 |                -129.39 |               -4 |*/

