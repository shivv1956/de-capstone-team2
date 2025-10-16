-- Repeatable migration for stored procedure
-- This will be re-applied whenever the file changes

CREATE OR REPLACE PROCEDURE ${CURRENT_SCHEMA}.sp_create_all_tables_from_raw()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    table_cursor CURSOR FOR 
        SELECT table_schema, table_name 
        FROM raw_db.information_schema.tables 
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
        full_table_name := 'raw_db.' || table_record.table_schema || '.' || table_record.table_name;
        
        -- Build the dynamic SQL for creating table
        create_sql := 'CREATE TABLE IF NOT EXISTS ' || '${CURRENT_SCHEMA}.' || table_record.table_name || 
                     ' AS (SELECT * FROM ' || full_table_name || ')';
        
        -- Execute the CREATE TABLE statement
        EXECUTE IMMEDIATE create_sql;
        
        -- Build the dynamic SQL for dropping Fivetran columns (if they exist)
        alter_sql := 'ALTER TABLE ${CURRENT_SCHEMA}.' || table_record.table_name || 
                    ' DROP COLUMN IF EXISTS _FIVETRAN_DELETED, _FIVETRAN_SYNCED';
        
        -- Execute the ALTER TABLE statement  
        EXECUTE IMMEDIATE alter_sql;
        
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