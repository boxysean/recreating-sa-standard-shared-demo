# DBT Project Specification - Core Models

## Overview
This project appears to be a data warehouse implementation for what seems to be an e-commerce or retail business system, with core models organized into dimension and fact tables following dimensional modeling best practices.

## Core Models

### 1. Dimension Tables

#### `dim_customers`
A customer dimension table tracking all customer-related attributes.
- **Key Business Purpose**: Stores comprehensive customer information including segmentation and value tiers
- **Notable Features**:
  - Versioned model (currently on v2)
  - Contract enforcement enabled
  - Public access granted
- **Key Columns**:
  - `customer_key` (PK) - Unique identifier
  - `region` - Restricted to ['AFRICA','MIDDLE EAST','ASIA','AMERICA']
  - `account_balance` - Financial tracking with statistical validation
  - Value segmentation columns (`is_high_value`, `is_mid_value`, `is_low_value`)
  - Customer attributes: name, address, phone_number, market_segment
  - `lifetime_value` - Customer LTV tracking

#### `dim_parts`
Product/parts catalog dimension table.
- **Key Business Purpose**: Central repository for product information
- **Key Columns**:
  - `part_key` (PK)
  - Product attributes: manufacturer, name, brand, type, size
  - `retail_price` - Product pricing information
  - `container` - Storage/shipping information

#### `dim_suppliers`
Supplier information dimension table.
- **Key Business Purpose**: Tracks all supplier-related information
- **Key Columns**:
  - `supplier_key` (PK)
  - Contact info: supplier_name, supplier_address, phone_number
  - Geographic info: nation, region
  - `account_balance` - Financial tracking

### 2. Fact Tables

#### `fct_order_items`
Detailed order line items fact table.
- **Key Business Purpose**: Tracks individual items within orders with detailed financial calculations
- **Data Quality**: Includes cross-table validation with `fct_orders` for sales amounts
- **Key Columns**:
  - `order_item_key` (PK)
  - Foreign keys: order_key, customer_key, part_key, supplier_key
  - Dates: order_date, ship_date, commit_date, receipt_date
  - Status tracking: order_item_status_code, return_flag
  - Financial metrics:
    - `supplier_cost`
    - `base_price`
    - `discount_percentage`
    - `discounted_price`
    - `tax_rate`
    - Various sales amounts (gross, discounted, net)
  - Quantity metrics: order_item_count, quantity

#### `fct_orders`
Order header fact table.
- **Key Business Purpose**: Provides order-level aggregations and tracking
- **Key Columns**:
  - `order_key` (PK)
  - `customer_key` (FK) - With referential integrity enforcement
  - Temporal data: order_date, order_time
  - Order attributes: status_code, priority_code, clerk_name, ship_priority
  - Metrics:
    - `order_count`
    - `return_count`
    - Financial summaries (gross_item_sales_amount, item_discount_amount, item_tax_amount, net_item_sales_amount)

## Technical Implementation Notes

1. **Data Quality Controls**:
   - Extensive use of data tests including uniqueness, null checks
   - Statistical validation on financial fields
   - Cross-table aggregation validation
   - Referential integrity enforcement
   - Value validation (e.g., region restrictions)

2. **Versioning Strategy**:
   - Implemented in `dim_customers` with clear deprecation dates
   - Multiple versions supported with column inclusion/exclusion rules

3. **Access Control**:
   - Group-based access control implemented
   - Data team ownership clearly defined
   - Public access specified where applicable

4. **Documentation**:
   - Comprehensive column-level descriptions
   - Use of doc blocks for reusable documentation
   - Clear business rules documented in column descriptions

This project appears to be a well-structured data warehouse implementation with strong emphasis on data quality, clear ownership, and comprehensive tracking of business metrics particularly focused on orders, customers, products, and suppliers.
