with snapshot_data as (

    select *
    from LEARNDBT.SNAPSHOTS.CUSTOMER_SNAPSHOT

),

versioned as (

    select
        customer_id,
        full_name,
        city,
        country,
        dbt_valid_from,
        dbt_valid_to,

        row_number() over(
            partition by customer_id
            order by dbt_valid_from
        ) as version_number

    from snapshot_data

)

select *
from versioned