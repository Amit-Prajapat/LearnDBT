select

    customer_id,
    full_name,
    city,
    country,

    dbt_valid_from as effective_date,
    dbt_valid_to as expiry_date

from LEARNDBT.SNAPSHOTS.CUSTOMER_SNAPSHOT