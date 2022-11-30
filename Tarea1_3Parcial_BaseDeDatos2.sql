--Ejercicio 1--
select
  name,
  gender,
  sum(number) sumatoria
from `bigquery-public-data.usa_names.usa_1910_2013`
group by 
  name,
  gender
order by
  sumatoria desc

--Ejercicio2--
select 
  date as fecha,
  state,
  tests_total,
  sum(tests_total) over (partition by state order by state desc) tests_sumary,
  cases_positive_total
from `bigquery-public-data.covid19_covidtracking.summary`

--Ejercicio3--
with channel_views as (
  select
    channelGrouping,
    date,
    sum(totals.pageviews) pageviews
  from `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
    group by 
    channelGrouping,
    date 
)
  select 
  channelGrouping,
  pageviews,
  (pageviews / sum(pageviews) over()) porcentaje_del_total,
  avg(pageviews) over (partition by date) promedio
from channel_views
group by
  channelGrouping,
  pageviews,
  date
order by porcentaje_del_total desc


--Ejercicio 4--
select 
  region,
  Country,
  Total_Revenue,
  dense_rank() over (partition by region order by Total_Revenue desc) rank
from `dataset.sales records`
