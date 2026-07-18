--1. total number of crimes in chicago
SELECT COUNT(*) AS total_crimes
FROM chicago.crimes;

/*Total Reported Crimes
1,450,979           */

-- 2. What is the count of Homicides, Battery and Assaults reported?


select 
    COUNT(*) AS number_of_crimes,
    primary_type
from chicago.crimes
where primary_type='BATTERY' OR
        primary_type='HOMICIDE' OR
        primary_type='ASSAULT'
group by primary_type


/*"number_of_crimes","primary_type"
"122997","ASSAULT"
"266357","BATTERY"
"4066","HOMICIDE"*/

-- 3. Which are the 3 most common crimes reported and what percentage 
--amount are they from the total amount of reported crimes?

select count(*) as number_of_crimes,
   concat (round(count (*)*100.0/(
    select count(*)
    from chicago.crimes
  ),2),'%')as Percentage_of_Crimes,
primary_type
from chicago.crimes
group by primary_type
order by number_of_crimes desc
limit 3
/*## Top 3 Most Common Crimes in Chicago
| 1 | THEFT | 321,957 | 22.19% |
| 2 | BATTERY | 266,357 | 18.36% |
| 3 | CRIMINAL DAMAGE | 161,766 | 11.15% |*/


select *
from chicago.crimes
order by community_area asc
limit 10

-- 4. What are the top ten communities that had the MOST amount of crimes reported?
-- Include the current population, density and order by the number of reported crimes.

select COUNT(*) AS number_of_crimes,
 community.population,
 community.density,
 INITCAP(community.community_name)
from chicago.crimes
 join  chicago.community
  on crimes.community_area=community.community_id
group by community.population,
community.density,community.community_name
order by Number_of_Crimes desc
limit 10


/*communities with the highest reported crime levels.

community             |population|density |reported_crimes|
----------------------+----------+--------+---------------+
Austin                |     96557|13504.48|          79271|
Near North Side       |    105481|38496.72|          63084|
Near West Side        |     67881|11929.88|          52091|
South Shore           |     53971|18420.14|          49722|
Loop                  |     42298|25635.15|          49003|
North Lawndale        |     34794|10839.25|          46155|
Humboldt Park         |     54165|15045.83|          41949|
West Town             |     87781|19166.16|          40772|
Auburn Gresham        |     44878|11903.98|          40514|
Greater Grand Crossing|     31471| 8865.07|          37429|

*/

-- 5. What are the top ten communities that had the LEAST amount of crimes reported?
-- Include the current population, density and order by the number of reported crimes.

select COUNT(*) AS number_of_crimes,
 community.population,
 community.density,
 INITCAP(community.community_name)
from chicago.crimes
 join  chicago.community
  on crimes.community_area=community.community_id
group by community.population,
community.density,community.community_name
order by Number_of_Crimes asc
limit 10

/*

community      |population|density |reported_crimes|
---------------+----------+--------+---------------+
Edison Park    |     11525|10199.12|           1623|
Burnside       |      2527| 4142.62|           2129|
Forest Glen    |     19596| 6123.75|           3135|
Mount Greenwood|     18628|  6873.8|           3150|
Montclare      |     14401|14546.46|           3616|
Hegewisch      |     10027| 1913.55|           3632|
Oakland        |      6799|11722.41|           4267|
Fuller Park    |      2567| 3615.49|           4342|
Archer Heights |     14196| 7062.69|           5036|
Mckinley Park  |     15923|11292.91|           5048|

*/




