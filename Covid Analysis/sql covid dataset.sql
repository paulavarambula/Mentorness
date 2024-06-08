show databases;
create database mentorness;
use mentorness;
create table covid_dataset
(
Province varchar(200), 
Country_Region varchar(200), 
Latitude double, 
Longitude double, 
Date_ date, 
Confirmed int, 
Deaths int, 
Recovered int
);


select * from covid_dataset;

-- Q1. Write a code to check NULL values
select * from covid_dataset 
where Province is null or 
Country_Region is null or
Latitude is null or 
Longitude is null or
Date_ is null or
Confirmed is null or
Deaths is null or
Recovered is null;

-- Q2. If NULL values are present, update them with zeros for all columns. 
# there are no null values present
update covid_dataset
set Province = coalesce(Province, ''),
Country_Region = coalesce(Country_Region, ''),
Latitude = coalesce(Latitude, 0),
Longitude = coalesce(Longitude, 0),
Date_ = coalesce(Date_, 0),
Confirmed = coalesce(Confirmed, 0),
Deaths = coalesce(Deaths, 0),
Recovered = coalesce(Recovered, 0);

-- Q3. check total number of rows
select count(*) as Total_rows
from covid_dataset;

-- Q4. Check what is start_date and end_date
select min(Date_) as start_date,
 max(Date_) as end_date
from covid_dataset;
## the start_date is 2020-01-22 and the end date is 2021-06-13

-- Q5. Number of month present in dataset
select year(Date_) as Year, 
count(distinct extract(month from Date_)) as Total_months
from covid_dataset
group by year;

select count(distinct extract(year_month from Date_)) as Number_months
from covid_dataset;
#there are 18 months present in the dataset in 2 years. 

-- Q6. Find monthly average for confirmed, deaths, recovered
select 
extract(year_month from Date_) as month_year,
avg(Confirmed) as avg_confirmed,
avg(Deaths) as avg_deaths,
avg(Recovered) as avg_recovered
from covid_dataset
group by month_year;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
with most_frequent as (
select
extract(year_month from Date_) as month_year,
Confirmed, Deaths, Recovered,
count(*) as frequency,
row_number() over(partition by extract(year_month from Date_) 
order by count(*) desc) as Ranking 
from covid_dataset
group by month_year, Confirmed, Deaths, Recovered
)
select
month_year,
Confirmed as most_frequent_confirmed, 
Deaths as most_frequent_deaths, 
Recovered most_frequent_recovered
from most_frequent
where Ranking = 1
order by month_year;

-- Q8. Find minimum values for confirmed, deaths, recovered per year
select 
extract(year from Date_) as year,
min(Confirmed) as min_confirmed,
min(Deaths) as min_deaths,
min(Recovered) as min_recovered
from covid_dataset
group by year;

-- Q9. Find maximum values of confirmed, deaths, recovered per year
select 
extract(year from Date_) as year,
max(Confirmed) as max_confirmed,
max(Deaths) as max_deaths,
max(Recovered) as max_recovered
from covid_dataset
group by year;

-- Q10. The total number of case of confirmed, deaths, recovered each month
select 
extract(year_month from Date_) as month_year,
sum(Confirmed) as total_confirmed,
sum(Deaths) as total_deaths,
sum(Recovered) as total_recovered
from covid_dataset
group by month_year;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
select
sum(Confirmed) as total_confirmed,
avg(Confirmed) as avg_confirmed,
variance(Confirmed) as variance_confirmed,
stddev(Confirmed) as stdev_confirmed
from covid_dataset;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
select
extract(year_month from Date_) as month_year,
sum(Deaths) as total_deaths,
avg(Deaths) as avg_deaths,
variance(Deaths) as variance_deaths,
stddev(Deaths) as stdve_deaths
from covid_dataset
group by month_year;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
select
sum(Recovered) as total_recoverd,
avg(Recovered) as avg_recovered,
variance(Recovered) as variance_recovered,
stddev(Recovered) as stdev_recovered
from covid_dataset;

-- Q14. Find Country having highest number of the Confirmed case
select 
Country_Region, sum(Confirmed) as total_confirmed
from covid_dataset
group by Country_Region
order by total_confirmed desc
limit 1;

-- Q15. Find Country having lowest number of the death case
select 
Country_Region, sum(Deaths) as total_deaths
from covid_dataset
group by Country_Region
order by total_deaths asc;

-- Q16. Find top 5 countries having highest recovered case
select 
Country_Region, sum(Recovered) as total_recovered
from covid_dataset
group by Country_Region
order by total_recovered desc
limit 5;


