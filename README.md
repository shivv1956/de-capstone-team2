## SQL Server to Snowflake Data Migration ###

### Overview

- Capstone project for ADE 2025 Batch (Chethan R, Shiva S, Ramanujan S)

- Migrating data from a hosted SQL Server database (on AWS RDS) to Snowflake.

- Tools used: Python, Snowflake, Dbeaver, AWS RDS, Snowflake, Fivetran, DBT.

### Phase 1 : Data Setup

- Loaded data into hosted SQL Server database using Dbeaver.

- Database Link : [Database](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17&tabs=ssms)

- Total of 31 tables to create and load, and we as a team executed for 9 tables. [Script Link](./Data%20Setup/instawdbdw.txt)

    - Tables (Created, loaded data, primary key and foreign key constraints):

        1. DatabaseLog

        2. AdventureWorksDWBuildVersion

        3. DimDate

        4. DimDepartmentGroup

        5. DimEmployee

        6. DimGeography

        7. DimAccount

        8. DimCurrency

        9. DimCustomer

