select
    payment_id,
    order_id,
    payment_method,
    amount,
    updated_at

from {{ source('raw','payments') }}