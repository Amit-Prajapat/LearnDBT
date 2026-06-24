select

    customer_id,
    full_name,
    city,
    country,

    dbt_valid_from as effective_date,
    dbt_valid_to as expiry_date,

    case
        when dbt_valid_to is null
        then 'Y'
        else 'N'
    end as current_flag

from LEARNDBT.SNAPSHOTS.CUSTOMER_SNAPSHOT