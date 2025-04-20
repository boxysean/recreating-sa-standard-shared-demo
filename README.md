## About this project

I am using Cursor and [dbt-mcp](https://github.com/dbt-labs/dbt-mcp) to create a dbt project using input, output, and validation specifications provided in the `specs/` folder. The input dataset is TPCH, and the output are dimensional models (dim_customers, fct_orders, etc).

## (Polite) Prompt

> Using output-spec.md and inputs-spec.md files as the specifications for a dbt project, I would like for you to create a working dbt project and using dbt best practices. Use sample_dim_customers.csv as basis of truth to validate whether the generated dim_customers dbt model matches the output. You can use the connected dbt Cloud MCP server to run commands to achieve this validation. Do not edit the dim_customers model to hardcode the values.
