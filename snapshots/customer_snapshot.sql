{% snapshot customer_snapshot %}

{{
    config(
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select *
from {{ ref('stg_customers') }}

{% endsnapshot %}