# Snowflake + dbt Data Warehouse Project

## Project Overview

This project demonstrates the implementation of a modern ELT data pipeline using Snowflake and dbt.

The project covers:

- Source to Staging Layer
- Data Modeling using dbt
- Incremental Models
- Fact and Dimension Tables
- SCD Type 1
- SCD Type 2 (Snapshots)
- Custom Macros
- Data Quality Tests
- Stored Procedures
- Tasks
- Streams
- JSON Processing
- VARIANT Data Type
- Table Functions
- CSV File Loading using COPY INTO

---

# Architecture

RAW LAYER
↓
STAGING LAYER
↓
MART LAYER
↓
ANALYTICS

---

## Technologies Used

| Tool | Purpose |
|--------|----------|
| Snowflake | Cloud Data Warehouse |
| dbt | Data Transformation |
| SQL | Data Modeling |
| GitHub | Version Control |
| Python UDF | Snowflake Python Processing |

---

# Project Structure

```text
LearnDBT
│
├── models
│   ├── staging
│   │   ├── stg_customers.sql
│   │   ├── stg_orders.sql
│   │   ├── stg_products.sql
│   │   └── stg_payments.sql
│   │
│   └── marts
│       ├── dim_customers.sql
│       └── fact_orders.sql
│
├── snapshots
│   └── customer_snapshot.sql
│
├── macros
│   ├── generate_surrogate_key.sql
│   └── current_timestamp.sql
│
├── tests
│   └── custom_tests.sql
│
└── dbt_project.yml
```

---

# Source Tables

The following raw tables were used:

- RAW_CUSTOMERS
- RAW_ORDERS
- RAW_PRODUCTS
- RAW_PAYMENTS

---

# Staging Models

Staging models standardize source data and prepare it for downstream transformations.

### Models

- stg_customers
- stg_orders
- stg_products
- stg_payments

Example:

```sql
select
    customer_id,
    full_name,
    city,
    updated_at
from RAW_CUSTOMERS
```

---

# Incremental Models

Implemented incremental loading using:

```sql
is_incremental()
```

Example:

```sql
{% if is_incremental() %}

where updated_at >
(
    select max(updated_at)
    from {{ this }}
)

{% endif %}
```

Benefits:

- Faster execution
- Reduced compute cost
- Loads only new records

---

# Fact Table

## fact_orders

Contains transactional order information.

Columns:

- Order ID
- Customer ID
- Product ID
- Quantity
- Price
- Total Amount
- Order Date

Implemented:

- Incremental Loading
- Surrogate Keys
- Joins with Dimensions

---

# Dimension Table

## dim_customers

Contains customer information.

Columns:

- Customer ID
- Customer Name
- City
- Updated Date

Implemented:

- SCD Type 1

---

# SCD Type 1

Implemented using:

```sql
merge
```

Logic:

- Updates existing records
- Keeps only latest version

Example:

```sql
when matched then update
when not matched then insert
```

---

# SCD Type 2 using dbt Snapshots

Snapshot File:

```text
snapshots/customer_snapshot.sql
```

Configuration:

```sql
{% snapshot customer_snapshot %}

{{
config(
target_schema='SNAPSHOTS',
unique_key='customer_id',
strategy='timestamp',
updated_at='updated_at'
)
}}

{% endsnapshot %}
```

Tracked Columns:

- customer_name
- city

Generated Columns:

- dbt_valid_from
- dbt_valid_to

---

# Custom Macros

Implemented reusable dbt macros.

Example:

```sql
{% macro current_timestamp_macro() %}

current_timestamp()

{% endmacro %}
```

Usage:

```sql
{{ current_timestamp_macro() }}
```

---

# Data Quality Tests

Implemented:

## Unique Test

```yaml
unique
```

## Not Null Test

```yaml
not_null
```

## Custom Test

Example:

```sql
amount > 0
```

---

# Stored Procedures

Implemented:

## SQL Stored Procedure

Features:

- Parameters
- Variables
- Conditional Logic

Example:

```sql
call get_customer(101);
```

---

# JavaScript Stored Procedure

Implemented:

- Dynamic SQL
- Variables
- Result Processing

Example:

```sql
call customer_count();
```

---

# Tasks

Implemented Snowflake Tasks for scheduling.

Example:

```sql
create task customer_task
schedule = '5 minute'
as
call refresh_customer_data();
```

---

# Streams

Implemented Change Data Capture (CDC).

Example:

```sql
create stream customer_stream
on table customers;
```

Features:

- Insert Tracking
- Update Tracking
- Delete Tracking

---

# CSV File Loading

Implemented using:

```sql
COPY INTO
```

Steps:

1. Create Internal Stage
2. Upload CSV File
3. Load Data into Table

Example:

```sql
copy into customers_csv
from @customer_stage;
```

---

# JSON Processing

Implemented:

- VARIANT Data Type
- JSON Parsing
- FLATTEN Table Function

Example:

```sql
select
data:customer_id,
data:name
from customer_json;
```

---

# Table Functions

Implemented:

```sql
flatten()
```

Example:

```sql
select *
from customer_json,
lateral flatten(input => data:orders);
```

---

# Time Travel

Implemented historical data recovery using:

```sql
AT(OFFSET => -60*5)
```

Use Cases:

- Recover Deleted Data
- Audit Changes
- Historical Analysis

---

# Cache Concepts

Studied:

- Result Cache
- Metadata Cache
- Warehouse Cache

Benefits:

- Improved Query Performance
- Reduced Compute Usage

---

# Python UDF

Implemented Python User Defined Functions.

Example:

```sql
create function get_grade(score float)
returns string
language python
runtime_version='3.10'
handler='grade'
as
$$
def grade(score):
    if score >= 90:
        return "A"
    return "B"
$$;
```

---

# Learning Outcomes

Through this project I learned:

- Snowflake Architecture
- Data Warehousing Concepts
- ELT Design
- dbt Fundamentals
- Incremental Processing
- SCD Type 1
- SCD Type 2
- Macros
- Data Testing
- Snapshots
- Streams
- Tasks
- Stored Procedures
- JSON Processing
- Python UDFs
- GitHub Version Control

---

# Author

Developed as part of hands-on learning and practice in Snowflake and dbt.

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
