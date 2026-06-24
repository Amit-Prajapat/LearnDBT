with customer_history as (

    select *
    from LEARNDBT.SNAPSHOTS.CUSTOMER_SNAPSHOT

),

final as (

    select

        customer_id,
        full_name,
        city,
        country,

        row_number() over(
            partition by customer_id
            order by dbt_valid_from
        ) as version_number,

        dbt_valid_from as effective_date,

        dbt_valid_to as expiry_date,

        case
            when dbt_valid_to is null
            then 'Y'
            else 'N'
        end as current_flag

    from customer_history

)

select *
from final
