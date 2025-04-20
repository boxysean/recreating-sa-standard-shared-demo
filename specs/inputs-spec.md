I'll create a comprehensive project plan detailing all source tables and their specifications.

# DBT Source Tables Project Plan

## Overview
The project uses the TPCH dataset, which is split across two source databases. This appears to be a sample/demo project that emulates a production environment.

## Source 1: TPCH_SF001
**Physical Location**: `raw.tpch_sf001`
**Data Freshness**: Warning after 12 hours
**Loaded At**: Current timestamp - 6.3 hours (demo setting)

### 1. Customer Table (`raw.tpch_sf001.customer`)
**Description**: Main customer table
**Columns**:
- `c_custkey` 
  - Description: unique customer key
  - Tests: unique (warn), not_null (warn)
- `c_name` - customer id
- `c_address` - address of the customer
- `c_nationkey` - foreign key to stg_tpch_nations
- `c_phone` - phone number of the customer
- `c_acctbal` - raw account balance
- `c_mktsegment` - market segment of the customer
- `c_comment` - general comment field

### 2. Nation Table (`raw.tpch_sf001.nation`)
**Description**: Nation mapping
**Columns**:
- `n_nationkey`
  - Description: 25 nations are populated
  - Tests: unique (warn), not_null (warn)
- `n_name` - nation name
- `n_regionkey`
  - Description: Foreign Key to R_REGIONKEY
  - Tests: relationships to region.r_regionkey
- `n_comment` - general comment field

### 3. Part Table (`raw.tpch_sf001.part`)
**Description**: Main part table
**Columns**:
- `p_partkey`
  - Description: SF*200,000 are populated
  - Tests: unique (warn), not_null (warn)
- `p_name` - name of the part
- `p_mfgr` - manufacturer of the part
- `p_brand` - brand of the part
- `p_type` - type of part including material
- `p_size` - size of the part
- `p_container` - container of the part
- `p_retailprice` - raw retail price
- `p_comment` - general comment field

### 4. PartSupp Table (`raw.tpch_sf001.partsupp`)
**Description**: Main part supplier table
**Columns**:
- `ps_partkey`
  - Description: Foreign Key to P_PARTKEY
  - Tests: relationships to part.p_partkey
- `ps_suppkey`
  - Description: Foreign Key to S_SUPPKEY
  - Tests: relationships to supplier.s_suppkey
- `ps_availqty` - raw available quantity
- `ps_supplycost` - raw cost
- `ps_comment` - general comment field

### 5. Region Table (`raw.tpch_sf001.region`)
**Description**: Region mapping
**Columns**:
- `r_regionkey`
  - Description: 5 regions are populated
  - Tests: unique (warn), not_null (warn)
- `r_name` - region name
- `r_comment` - general comment field

### 6. Supplier Table (`raw.tpch_sf001.supplier`)
**Description**: Main supplier table
**Columns**:
- `s_suppkey`
  - Description: SF*10,000 are populated
  - Tests: unique (warn), not_null (warn)
- `s_name` - id of the supplier
- `s_address` - address of the supplier
- `s_nationkey`
  - Description: Foreign Key to N_NATIONKEY
  - Tests: relationships to nation.n_nationkey
- `s_phone` - phone number of the supplier
- `s_acctbal` - raw account balance
- `s_comment` - general comment field

## Source 2: TPCH_NOW
**Physical Location**: `raw.tpch_now`

### 1. Orders Table (`raw.tpch_now.orders`)
**Description**: Main order tracking table
**Columns**:
- `o_orderkey`
  - Description: SF*1,500,000 are sparsely populated
  - Tests: unique, not_null
- `o_custkey`
  - Description: Foreign Key to C_CUSTKEY
  - Tests: relationships to customer.c_custkey
- `o_orderstatus` - status code of the order
- `o_totalprice` - raw price
- `o_orderdate` - date the order was made
- `o_ordertime` - time the order was made
- `o_orderpriority` - code associated with the order
- `o_clerk` - id of the clerk
- `o_shippriority` - numeric representation of shipping priority (0 default)
- `o_comment` - general comment field

### 2. Lineitem Table (`raw.tpch_now.lineitem`)
**Description**: Main lineitem table
**Columns**:
- `l_orderkey`
  - Description: Foreign Key to O_ORDERKEY
  - Tests: relationships to orders.o_orderkey
- `l_partkey`
  - Description: Foreign key to P_PARTKEY
  - Tests: relationships to part.p_partkey
- `l_suppkey`
  - Description: Foreign key to S_SUPPKEY
  - Tests: relationships to supplier.s_suppkey
- `l_linenumber` - sequence of order items within the order
- `l_quantity` - total units
- `l_extendedprice` - line item price
- `l_discount` - percentage of the discount
- `l_tax` - tax rate of the order item
- `l_returnflag`
  - Description: letter determining return status
  - Values: 'R' (returned), 'A' (accepted)
  - Tests: accepted_values (warn)
- `l_linestatus`
  - Description: status code of the order item
  - Values: 'P' (returned), 'F' (billed), 'O' (shipped)
  - Tests: accepted_values
- `l_shipdate` - shipment date
- `l_commitdate` - commitment date
- `l_receiptdate` - receipt date
- `l_shipinstruct` - additional shipment instructions
- `l_shipmode` - method of shipping
- `l_comment` - general comment field

## Data Quality Framework
The source tables implement several types of tests:
1. **Primary Key Tests**:
   - Unique constraints (mostly with warn severity)
   - Not null constraints (mostly with warn severity)

2. **Referential Integrity Tests**:
   - Foreign key relationships between tables
   - Particularly strong in the order-customer-supplier chain

3. **Value Validation Tests**:
   - Specific accepted values for status fields
   - Particularly in lineitem status fields

4. **Data Freshness Tests**:
   - Warning threshold of 12 hours for TPCH_SF001 source

This source structure provides a comprehensive foundation for an e-commerce/retail data warehouse, with clear relationships between customers, orders, products, and suppliers.
