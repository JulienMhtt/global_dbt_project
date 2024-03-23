{{ config(materialized='table') }}

with customer_data as (
    select
        c."CustomerID" as customer_id,
        c."AccountNumber" as account_number,
        c."TerritoryID" as territory_id,
        p."FirstName",
        p."LastName",
        p."BirthDate",
        p."MaritalStatus",
        p."YearlyIncome",
        p."Gender",
        p."Education",
        p."Occupation",
        p."HomeOwnerFlag",
        p."NumberCarsOwned",
        p."BusinessEntityID",
        c."PersonID" as person_id
    from
        {{ source('db_dbt_project', 'Customer') }} as c
    LEFT JOIN
        {{ source('db_dbt_project', 'Person') }} as p
    on
        c."PersonID" = p."BusinessEntityID"
)

select
    {{ dbt_utils.generate_surrogate_key(['customer_id', 'account_number', 'territory_id', 'person_id']) }} as customer_id_key,
    "customer_id",
    "account_number",
    "territory_id",
    "FirstName",
    "LastName",
    "BirthDate",
    "MaritalStatus",
    "YearlyIncome",
    "Gender",
    "Education",
    "Occupation",
    "HomeOwnerFlag",
    "NumberCarsOwned",
    "BusinessEntityID",
    "person_id"
from
    customer_data

