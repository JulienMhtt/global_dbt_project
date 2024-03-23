{{ config(materialized='table') }}

with date_sequence as (
    select 
        date(generate_series('2010-01-01'::date, current_date + interval '1year', '1 day')) as full_date
),
date_attributes as (
    select 
        row_number() over (order by full_date) as id,
        full_date,
        extract(year from full_date) as year,
        to_char(full_date, 'IYYY-IW') as year_week,
        extract(doy from full_date) as year_day,
        case 
            when extract(month from full_date) >= 4 then extract(year from full_date)
            else extract(year from full_date) - 1
        end as fiscal_year,
        case 
            when extract(month from full_date) between 4 and 6 then 1
            when extract(month from full_date) between 7 and 9 then 2
            when extract(month from full_date) between 10 and 12 then 3
            when extract(month from full_date) between 1 and 3 then 4
        end as fiscal_qtr,
        extract(month from full_date) as month,
        to_char(full_date, 'Month') as month_name,
        extract(isodow from full_date) as week_day,
        to_char(full_date, 'Day') as day_name,
        case 
            when extract(isodow from full_date) between 1 and 5 then true
            else false
        end as day_is_weekday
    from 
        date_sequence
)
select 
    *
from 
    date_attributes