-- Toolkit Solution
-- ERROR: line 0, character 0: Procedure return value incompatibility: STRING is added as a default return type by SQL Translation, as Snowflake expects a RETURN TYPE for PROCEDURES.
CREATE OR REPLACE PROCEDURE 
-- WARNING: line 1, character 0: Syntax difference: UDF is converted to PROCEDURE, as Procedural logic is not supported in Snowflake UDFs.
dbo.udfTwoDigitZeroFill(number INT)
RETURNS CHAR(2)
LANGUAGE SQL
as
$$
BEGIN
LET result CHAR(2);
IF (:number > 9) THEN result := CAST(LEFT(:number, 2) AS CHAR(2));
ELSE result := CAST(
  LEFT('0' || CAST(LEFT(:number, 30) AS VARCHAR(30)), 2) AS CHAR(2)
);
END IF;
RETURN :result;
END;
$$
;


-- Correct Solution
CREATE OR REPLACE FUNCTION udfTwoDigitZeroFill(number INT)
RETURNS CHAR(2)
LANGUAGE SQL
AS
$$
    LPAD(CAST(number AS STRING), 2, '0')
$$;

