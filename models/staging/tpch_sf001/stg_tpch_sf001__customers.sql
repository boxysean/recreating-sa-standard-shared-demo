with source as (
    select * from {{ source('tpch_sf001', 'customer') }}
),

nation as (
    select * from {{ source('tpch_sf001', 'nation') }}
),

region as (
    select * from {{ source('tpch_sf001', 'region') }}
),

renamed as (
    select
        c_custkey as customer_key,
        c_name as customer_name,
        c_address as customer_address,
        n.n_name as nation,
        r.r_name as region,
        c_phone as phone_number,
        c_acctbal as account_balance,
        c_mktsegment as market_segment,
        c_comment as comment
    from source
    left join nation n on source.c_nationkey = n.n_nationkey
    left join region r on n.n_regionkey = r.r_regionkey
)

select * from renamed 