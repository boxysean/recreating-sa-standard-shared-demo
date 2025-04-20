{{
    config(
        materialized='table',
        tags=['core']
    )
}}

with customers as (
    select * from {{ ref('stg_tpch_sf001__customers') }}
),

customer_orders as (
    select
        customer_key,
        sum(net_item_sales_amount) as lifetime_value
    from {{ ref('fct_orders') }}
    group by customer_key
),

final as (
    select
        customers.customer_key,
        customers.region,
        customers.customer_name as name,
        customers.customer_address as address,
        customers.nation,
        customers.phone_number,
        customers.account_balance,
        customers.market_segment,
        coalesce(customer_orders.lifetime_value, 0) as lifetime_value,
        case 
            when coalesce(customer_orders.lifetime_value, 0) > 1000000 then 'Y'
            else 'N'
        end as is_high_value,
        case 
            when coalesce(customer_orders.lifetime_value, 0) between 100000 and 1000000 then 'Y'
            else 'N'
        end as is_mid_value,
        case 
            when coalesce(customer_orders.lifetime_value, 0) < 100000 then 'Y'
            else 'N'
        end as is_low_value
    from customers
    left join customer_orders using (customer_key)
)

select * from final 