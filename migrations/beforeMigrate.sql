CREATE SCHEMA IF NOT EXISTS ${CURRENT_SCHEMA};



-- CREATE OR REPLACE PROCEDURE ${CURRENT_SCHEMA}.sp_create_table_from_raw(
--     raw_database STRING,
--     raw_schema STRING,
--     table_name STRING
-- )
-- RETURNS STRING
-- LANGUAGE SQL
-- AS
-- $$
-- DECLARE
--     create_sql STRING;
--     alter_sql STRING;
-- BEGIN
--     -- Build the dynamic SQL for creating table
--     create_sql := 'CREATE TABLE IF NOT EXISTS ' || '${CURRENT_SCHEMA}.' || table_name || 
--                  ' AS (SELECT * FROM ' || raw_database || '.' || raw_schema || '.' || table_name || ')';
    
--     -- Execute the CREATE TABLE statement
--     EXECUTE IMMEDIATE create_sql;
    
--     -- Build the dynamic SQL for dropping Fivetran columns
--     alter_sql := 'ALTER TABLE ${CURRENT_SCHEMA}.' || table_name || 
--                 ' DROP COLUMN IF EXISTS _FIVETRAN_DELETED, _FIVETRAN_SYNCED';
    
--     -- Execute the ALTER TABLE statement
--     EXECUTE IMMEDIATE alter_sql;
    
--     RETURN 'Table ' || table_name || ' created successfully from ' || raw_database || '.' || raw_schema || '.' || table_name;
-- END;
-- $$;




CREATE OR REPLACE PROCEDURE ${CURRENT_SCHEMA}.sp_create_all_tables_from_raw()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    table_cursor CURSOR FOR 
        SELECT table_schema, table_name 
        FROM ${RAW_DATABASE_NAME}.information_schema.tables 
        WHERE table_schema = 'SQL_SERVER_DBO'
        AND table_type = 'BASE TABLE'
        ORDER BY table_name;
    
    create_sql STRING;
    alter_sql STRING;
    tables_created STRING DEFAULT '';
    table_count INTEGER DEFAULT 0;
    full_table_name STRING;
BEGIN
    -- Loop through all tables in raw_db with flexible schema matching
    FOR table_record IN table_cursor DO
        -- Build full table reference
        full_table_name := '${RAW_DATABASE_NAME}.' || table_record.table_schema || '.' || table_record.table_name;
        
        -- Build the dynamic SQL for creating table
        create_sql := 'CREATE TABLE IF NOT EXISTS ' || '${CURRENT_SCHEMA}.' || table_record.table_name || 
                     ' AS (SELECT * FROM ' || full_table_name || ')';
        
        -- Execute the CREATE TABLE statement
        EXECUTE IMMEDIATE create_sql;
        
        -- Build the dynamic SQL for dropping Fivetran columns (if they exist)
        -- alter_sql_fivetran_deleted := 
        
        EXECUTE IMMEDIATE 'ALTER TABLE ${CURRENT_SCHEMA}.' || table_record.table_name || 
                    ' DROP COLUMN IF EXISTS _FIVETRAN_DELETED';

        -- EXECUTE IMMEDIATE alter_sql_fivetran_deleted;

        --alter_sql_fivetran_synced:= 
        EXECUTE IMMEDIATE 'ALTER TABLE ${CURRENT_SCHEMA}.' || table_record.table_name || 
                    ' DROP COLUMN IF EXISTS _FIVETRAN_SYNCED';

        -- Execute the ALTER TABLE statement  
        
        -- EXECUTE IMMEDIATE alter_sql_fivetran_synced;
        
        -- Track progress
        table_count := table_count + 1;
        IF (tables_created != '') THEN
            tables_created := tables_created || ', ';
        END IF;
        tables_created := tables_created || table_record.table_name;
    END FOR;
    
    RETURN 'Successfully created ' || table_count || ' tables: ' || tables_created;
END;
$$;

CALL ${CURRENT_SCHEMA}.sp_create_all_tables_from_raw();

DROP PROCEDURE ${CURRENT_SCHEMA}.sp_create_all_tables_from_raw();



