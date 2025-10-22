# de-capstone-team2
### Flyway Migrations for Capstone Project

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