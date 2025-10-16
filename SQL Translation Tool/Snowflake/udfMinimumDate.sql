-- ERROR: line 0, character 0: Procedure return value incompatibility: STRING is added as a default return type by SQL Translation, as Snowflake expects a RETURN TYPE for PROCEDURES.
CREATE OR REPLACE PROCEDURE 
-- WARNING: line 1, character 0: Syntax difference: UDF is converted to PROCEDURE, as Procedural logic is not supported in Snowflake UDFs.
dbo.udfMinimumDate(x DATETIME, y DATETIME)
RETURNS DATETIME
LANGUAGE SQL
as
$$
BEGIN
LET z DATETIME;
IF (:x <= :y) THEN z := :x;
ELSE z := :y;
END IF;
RETURN (:z);
END;
$$
;
