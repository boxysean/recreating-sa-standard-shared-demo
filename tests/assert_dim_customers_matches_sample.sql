-- This test validates that the dim_customers model matches the sample data
-- It compares all rows where customer_key matches between the two datasets

with dim_customers_actual as (
    select * from {{ ref('dim_customers') }}
),

sample_data as (
    select * from {{ ref('sample_dim_customers') }}
),

validation_results as (
    select
        'Missing customer in dim_customers: ' || customer_key as validation_error
    from sample_data
    where customer_key not in (select customer_key from dim_customers_actual)

    union all

    select
        'Mismatch in region for customer ' || customer_key || 
        ': expected ' || s.region || ', got ' || a.region as validation_error
    from sample_data s
    join dim_customers_actual a using (customer_key)
    where s.region != a.region

    union all

    select
        'Mismatch in name for customer ' || customer_key || 
        ': expected ' || s.name || ', got ' || a.name as validation_error
    from sample_data s
    join dim_customers_actual a using (customer_key)
    where s.name != a.name

    union all

    select
        'Mismatch in address for customer ' || customer_key || 
        ': expected ' || s.address || ', got ' || a.address as validation_error
    from sample_data s
    join dim_customers_actual a using (customer_key)
    where s.address != a.address

    union all

    select
        'Mismatch in nation for customer ' || customer_key || 
        ': expected ' || s.nation || ', got ' || a.nation as validation_error
    from sample_data s
    join dim_customers_actual a using (customer_key)
    where s.nation != a.nation

    union all

    select
        'Mismatch in phone_number for customer ' || customer_key || 
        ': expected ' || s.phone_number || ', got ' || a.phone_number as validation_error
    from sample_data s
    join dim_customers_actual a using (customer_key)
    where s.phone_number != a.phone_number

    union all

    select
        'Mismatch in account_balance for customer ' || customer_key || 
        ': expected ' || s.account_balance || ', got ' || a.account_balance as validation_error
    from sample_data s
    join dim_customers_actual a using (customer_key)
    where s.account_balance != a.account_balance

    union all

    select
        'Mismatch in market_segment for customer ' || customer_key || 
        ': expected ' || s.market_segment || ', got ' || a.market_segment as validation_error
    from sample_data s
    join dim_customers_actual a using (customer_key)
    where s.market_segment != a.market_segment

    union all

    select
        'Mismatch in lifetime_value for customer ' || customer_key || 
        ': expected ' || s.lifetime_value || ', got ' || a.lifetime_value as validation_error
    from sample_data s
    join dim_customers_actual a using (customer_key)
    where coalesce(s.lifetime_value, 0) != coalesce(a.lifetime_value, 0)

    union all

    select
        'Mismatch in is_high_value for customer ' || customer_key || 
        ': expected ' || s.is_high_value || ', got ' || a.is_high_value as validation_error
    from sample_data s
    join dim_customers_actual a using (customer_key)
    where coalesce(s.is_high_value, 'N') != coalesce(a.is_high_value, 'N')

    union all

    select
        'Mismatch in is_mid_value for customer ' || customer_key || 
        ': expected ' || s.is_mid_value || ', got ' || a.is_mid_value as validation_error
    from sample_data s
    join dim_customers_actual a using (customer_key)
    where coalesce(s.is_mid_value, 'N') != coalesce(a.is_mid_value, 'N')

    union all

    select
        'Mismatch in is_low_value for customer ' || customer_key || 
        ': expected ' || s.is_low_value || ', got ' || a.is_low_value as validation_error
    from sample_data s
    join dim_customers_actual a using (customer_key)
    where coalesce(s.is_low_value, 'N') != coalesce(a.is_low_value, 'N')
)

select *
from validation_results 