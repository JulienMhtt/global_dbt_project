{{
    config(materialized='table')
}}

with sales_territory as (
    select distinct 
        "TerritoryID" as territoryid,
        "Name" as region,
        "CountryRegionCode" as country,
        "Group" as continent
    from 
        {{ source('db_dbt_project', 'SalesTerritory') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['territoryid', 'region', 'country', 'continent']) }} as surrogate_key,
    territoryid,
    region,
    country,
    continent
from sales_territory
