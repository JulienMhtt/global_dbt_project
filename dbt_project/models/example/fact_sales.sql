{{ config(materialized='table') }}

with sales_data as (
    select 
	sod."SalesOrderDetailID" as sales_order_detail_id,
	sod."SalesOrderID" as sales_order_id,
	cast(sod."OrderQty" as INT) as OrderQty ,
	sod."ProductID" as product_id,
	CAST(REPLACE(sod."UnitPrice", ',', '.') AS FLOAT) as unit_price ,
	sod."LineTotal" as line_total,
	soh."TerritoryID" as territory_id, 
	soh."CustomerID" as customer_id,
	soh."OrderDate" as order_date
from
	{{ source('db_dbt_project', 'SalesOrderDetail') }} sod
left join 
    {{ source('db_dbt_project', 'SalesOrderHeader') }} soh on sod."SalesOrderID" = soh."SalesOrderID"
)

select
  {{ dbt_utils.generate_surrogate_key(["sales_order_detail_id", "sales_order_id"]) }} as sales_order_key,
    sales_order_detail_id ,
    sales_order_id ,
    OrderQty ,
    product_id ,
    unit_price ,
    line_total ,
    territory_id ,
    customer_id , 
    order_date
from sales_data




