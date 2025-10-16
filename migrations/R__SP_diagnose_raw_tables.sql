-- Diagnostic procedure to check what tables are available
CREATE OR REPLACE PROCEDURE ${CURRENT_SCHEMA}.sp_diagnose_raw_tables()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    result STRING DEFAULT '';
    table_count INTEGER DEFAULT 0;
    table_cursor CURSOR FOR 
        SELECT table_schema, table_name 
        FROM raw_db.information_schema.tables 
        WHERE table_schema = 'SQL_SERVER_DBO'
        AND table_type = 'BASE TABLE'
        ORDER BY table_name;
BEGIN
    -- Check all available tables in raw_db
    FOR table_record IN table_cursor DO
        table_count := table_count + 1;
        IF (result != '') THEN
            result := result || ', ';
        END IF;
        result := result || table_record.table_schema || '.' || table_record.table_name;
    END FOR;
    
    RETURN 'Found ' || table_count || ' tables in raw_db: ' || result;
END;
$$;