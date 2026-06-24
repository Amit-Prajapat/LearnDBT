select
    order_id,
    customer_id,
    product_id,
    quantity,
    order_date,
    updated_at

from {{ source('raw','orders') }}