-- Repeatable migration for stored procedure
-- This will be re-applied whenever the file changes

CREATE OR REPLACE PROCEDURE ${CURRENT_SCHEMA}.sp_create_table_from_raw(
    raw_database STRING,
    raw_schema STRING,
    table_name STRING
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    create_sql STRING;
    alter_sql STRING;
BEGIN
    -- Build the dynamic SQL for creating table
    create_sql := 'CREATE TABLE IF NOT EXISTS ' || '${CURRENT_SCHEMA}.' || table_name || 
                 ' AS (SELECT * FROM ' || raw_database || '.' || raw_schema || '.' || table_name || ')';
    
    -- Execute the CREATE TABLE statement
    EXECUTE IMMEDIATE create_sql;
    
    -- Build the dynamic SQL for dropping Fivetran columns
    alter_sql := 'ALTER TABLE ${CURRENT_SCHEMA}.' || table_name || 
                ' DROP COLUMN IF EXISTS _FIVETRAN_DELETED, _FIVETRAN_SYNCED';
    
    -- Execute the ALTER TABLE statement
    EXECUTE IMMEDIATE alter_sql;
    
    RETURN 'Table ' || table_name || ' created successfully from ' || raw_database || '.' || raw_schema || '.' || table_name;
END;
$$;