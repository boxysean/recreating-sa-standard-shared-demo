{{
    config(
        materialized='table',
        tags=['core']
    )
}}

with orders as (
    select * from {{ ref('stg_tpch_now__orders') }}
),

line_items as (
    select * from {{ ref('stg_tpch_now__lineitems') }}
),

order_items as (
    select
        order_key,
        sum(extended_price) as gross_item_sales_amount,
        sum(extended_price * (1 - discount_percentage)) as discounted_item_sales_amount,
        sum(extended_price * (1 - discount_percentage) * (1 + tax_rate)) as net_item_sales_amount,
        sum(extended_price * discount_percentage) as item_discount_amount,
        sum(extended_price * (1 - discount_percentage) * tax_rate) as item_tax_amount,
        count(*) as order_item_count,
        sum(case when return_flag = 'R' then 1 else 0 end) as return_count,
        sum(quantity) as quantity
    from line_items
    group by order_key
),

final as (
    select
        orders.order_key,
        orders.customer_key,
        orders.order_date,
        orders.order_time,
        orders.status_code,
        orders.priority_code,
        orders.clerk_name,
        orders.ship_priority,
        coalesce(order_items.order_item_count, 0) as order_item_count,
        coalesce(order_items.return_count, 0) as return_count,
        coalesce(order_items.quantity, 0) as quantity,
        coalesce(order_items.gross_item_sales_amount, 0) as gross_item_sales_amount,
        coalesce(order_items.discounted_item_sales_amount, 0) as discounted_item_sales_amount,
        coalesce(order_items.net_item_sales_amount, 0) as net_item_sales_amount,
        coalesce(order_items.item_discount_amount, 0) as item_discount_amount,
        coalesce(order_items.item_tax_amount, 0) as item_tax_amount
    from orders
    left join order_items using (order_key)
)

select * from final 