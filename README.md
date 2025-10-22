<<<<<<< HEAD
# de-capstone-team2
Flyway Migrations for Capstone Project
=======
## SQL Server to Snowflake Data Migration ###

### Overview

- Capstone project for ADE 2025 Batch (Chethan R, Shiva S, Ramanujan S)

- Migrating data from a hosted SQL Server database (on AWS RDS) to Snowflake.

- Tools used: Python, Snowflake, Dbeaver, AWS RDS, Snowflake, Fivetran, Flyway, PhData Toolkit.

### Phase 1 : Data Setup

- Loaded data into hosted SQL Server database using Dbeaver.

- Database Link : [Database](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17&tabs=ssms)

- Total of 31 tables to create and load, and we as a team executed for 9 tables. There are also 5 views, 2 UDF's [Script Link](./Data%20Setup/instawdbdw.txt)

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
    
    - Views (Created):

        1. vDMPrep

        2. vTimeSeries

        3. vTargetMail

        4. vAssocSeqOrders

        5. vAssocSeqLineItems
    
    - User Defined Functions (Created):

        1. udfBuildISO8601Date

        2. udfMinimumDate

        3. udfTwoDigitZeroFill


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

### Phase 3 : Data Migration using Fivetran

- Used Fivetran to migrate data to raw database in Snowflake.

- This database acts as a staging area for further transformations.


### Phase 4 : Data Validation Tool Setup

- Data Validation for migrated tables from SQL Server to Snowflake using Data Source Tool (PhData Toolkit)

- Setup

    1. Run the commands

    ```bash
    toolkit init
    toolkit ds list # Run after configuration of toolkit.conf file with necessary datasources and profiles
    ```

    To learn more about setting up the data source tool refer this [link](https://toolkit.phdata.io/docs/data-source)

    2. To scan the datasources (create json files for comparison)

    ```bash
    toolkit ds scan <source_name>
    toolkit ds scan <target_name>
    ```

    3. To compare the datasources

    ```bash
    toolkit ds diff source:profile:new target:profile:new # Generate diff json file for comparison
    toolkit ds show source.target:diff:latest --format html -o # Generate html report using the diff json file
    ```
    Results (Data Validation for Raw Database) : [UI View](./Data%20Source%20Tool/MigrationReport.png) | [HTML Report](./Data%20Source%20Tool/sap_source.sap_target_diff_2025-10-16T140001.969Z.html)


### Phase 5 : SQL Translation

- SQL Translation from SQL Server to Snowflake using SQL Translation Tool (PhData Toolkit)

- Create the following folder structure:

    ```bash
    SQL Translation Tool
    ├── Snowflake
    ├── SQLServer
    ```

    - Initialize the toolkit:

        ```bash
        toolkit init
        ```

    - All the scripts for the UDF's and Views created in SQL Server are placed in the `SQLServer` folder.

    - Run the following command to translate the scripts:

        ```bash
        toolkit sql translate mssql snowflake --input SQLServer --output Snowflake
        ```

### Phase 6 : Deployment using Flyway and Data Validation in Test Environment

- As we have migrated the data to Snowflake raw database, we have to shift this to our development database (we will be deploying the views and UDF's also here).

- Migrate data from development to test
      - Validate tables here --> We do this here because extra columns may have been added while    migrating using Fivetran in the raw database. (using PhData Data Source Tool)

      - Validate the views and UDF's also here. (using PhData Data Source Tool)

      - Deploy data from test to production database, ready for further analysis.

- Flyway Setup [Github Repo](https://github.com/shivv1956/de-capstone-team2/tree/dev)
>>>>>>> 19e36a6f1f70565db6066382cdbddec01bf03377

- Flyway facilitates database migration with version control through the help of CI/CD pipelines.

- Workflow of Migration done:

    1. Migrated data from SQL Server to Snowflake (Raw Database) using Fivetran.

    2. Deploy this data into Development environment using Flyway (after removal of unnecessary columns added during Fivetran migration). Create Views and UDF's in this database.

    3. Move this data to Test environment using Flyway. Test the data, functions and views in this environment.

    4. Finally, deploy this data to Production environment using Flyway.

### Setup

- Install Flyway --> [link](https://www.red-gate.com/hub/product-learning/flyway/installing-and-upgrading-the-flyway-cli)

- Create the following folder structure in your local system:

    ```bash
        project
        ├── migrations
        │   ├── V1__initial_setup.sql
        │   ├── R__SP_sample_stored_procedure.sql
        │   └── ... and more migration files
        ├── configs  # flyway configuration files for different environments
        │   └── dev.conf
        │   └── test.conf
        │   └── prod.conf
        │       └── ... one for each environment
        ├── .github # GitHub Actions for CI/CD Pipelines
        │   └── workflows
        │       └── flyway-dev.yml
        │       └── flyway-test.yml
        │       └── flyway-prod.yml
        │       └── ... one for each environment
        └── README.md

    ```

- To avoid Java related issues, run the following command in terminal before running any Flyway commands:

    ```bash
        set JAVA_ARGS=--add-opens=java.base/java.nio=ALL-UNNAMED # only for current terminal session
    ```

- Run the following command to migrate the database:

    ```bash
        flyway -configFiles=./configs/dev.conf migrate  # for development environment
        flyway -configFiles=./configs/test.conf migrate  # for test environment
        flyway -configFiles=./configs/prod.conf migrate  # for production environment
    ```