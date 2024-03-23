{{ config(materialized='table') }}

with product_data as (
  select distinct
    p."ProductID" as product_id,
    psc."ProductSubcategoryID" as product_subcategory_id,
    p."ProductNumber" as product_number,
    p."Name" as product_name,
    pm."Name" as product_model_name,
    pd."Description" as product_description,
    p."Color" as product_color,
    p."Size" as product_size,
    p."StandardCost" as product_cost,
    p."ListPrice" as product_price
  from
    {{ source('db_dbt_project', 'Product') }} p
  left join
    {{ source('db_dbt_project', 'ProductSubCategory') }} psc on p."ProductSubcategoryID" = psc."ProductSubcategoryID"
  left join
    {{ source('db_dbt_project', 'ProductModel') }} pm on p."ProductModelID" = pm."ProductModelID"
  left join
    {{ source('db_dbt_project', 'ProductModelProductDescriptionCulture') }} pmpdc on pm."ProductModelID" = pmpdc."ProductModelID"
  left join
    {{ source('db_dbt_project', 'ProductDescription') }} pd on pd."ProductDescriptionID" = pmpdc."ProductDescriptionID"
  where
    pmpdc."CultureID" = 'fr    '
)

select
  {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
  product_id,
  product_subcategory_id,
  product_number,
  product_name,
  product_model_name,
  product_description,
  product_color,
  product_size,
  product_cost,
  product_price
from product_data



