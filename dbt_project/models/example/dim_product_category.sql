
{{ config(materialized='table') }}

with territory_data as (
  select
    psc."ProductSubcategoryID" as product_sub_category_id,
    pc."ProductCategoryID" as product_category_id,
    psc."Name" as product_sub_category_name,
    pc."Name" as product_category_name
  from
    {{ source('db_dbt_project', 'ProductSubCategory') }} psc
  left join
    {{ source('db_dbt_project', 'ProductCategory') }} pc
  on psc."ProductCategoryID" = pc."ProductCategoryID"
)

select
  {{ dbt_utils.generate_surrogate_key(['product_sub_category_id', 'product_category_id']) }} as territory_key,
  product_sub_category_id,
  product_category_id,
  product_sub_category_name,
  product_category_name
from territory_data




    