{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge'
    )
}}

select

    {{
        dbt_utils.generate_surrogate_key(
            ['o.order_id']
        )
    }} as order_sk,

    o.order_id,
    o.customer_id,
    c.full_name,
    o.product_id,
    p.product_name,
    o.quantity,
    p.price,
    o.quantity * p.price as total_amount,
    o.order_date,
    o.updated_at

from {{ ref('stg_orders') }} o

left join {{ ref('stg_customers') }} c
    on o.customer_id = c.customer_id

left join {{ ref('stg_products') }} p
    on o.product_id = p.product_id

{% if is_incremental() %}

where o.updated_at >
(
    select coalesce(
        max(updated_at),
        '1900-01-01'::date
    )
    from {{ this }}
)

{% endif %}