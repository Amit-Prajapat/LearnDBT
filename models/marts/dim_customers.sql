{{
    config(
        materialized='incremental',
        unique_key='customer_id',
        incremental_strategy='merge'
    )
}}

with source_data as (

    select *
    from {{ ref('stg_customers') }}

)

select *
from source_data

{% if is_incremental() %}

where updated_at >
(
    select coalesce(
        max(updated_at),
        '1900-01-01'::date
    )
    from {{ this }}
)

{% endif %}