select

    order_id,

    quantity,

    price,

    {{ multiply('quantity','price') }} as total_amount

from {{ ref('fact_orders') }}