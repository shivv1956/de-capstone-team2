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


### Phase 2 : Setup Snowflake Account with Database and Roles

- Used PhData Toolkit to setup Snowflake account, database and roles.

- Setup
    1. Install Toolkit [Link](https://toolkit.phdata.io/docs/toolkit-cli)

    2. Run the commands

    ```bash
    toolkit init
    toolkit provision tutorial # Setup for initial folder structure
    ```

- To generate the files for groups use the following [link](https://provisiontoolpoc-nkfxytohrlpyqzbsajwdim.streamlit.app/)

- To get the template yaml files use the following [link](https://github.com/Hithesh1334/porvisoin-tool-test-/tree/main/stack/templates)

- Run the following command to test the tool:

```bash
toolkit provision apply --local # To generate plan.sql file

toolkit provision apply # To deploy in snowflake
```