
-- vTimeSeries view supports the creation of time series data mining models.
--      - Replaces earlier bike models with successor models.
--      - Abbreviates model names to improve readability in mining model viewer
--      - Concatenates model and region so that table only has one input.
--      - Creates a date field indexed to monthly reporting date for use in prediction.
CREATE OR REPLACE VIEW ${CURRENT_SCHEMA}.vTimeSeries AS
SELECT
  CASE
    Model
    WHEN 'Mountain-100' THEN 'M200'
    WHEN 'Road-150' THEN 'R250'
    WHEN 'Road-650' THEN 'R750'
    WHEN 'Touring-1000' THEN 'T1000'
    ELSE LEFT(Model, 1) || RIGHT(Model, 3)
  END || ' ' || Region AS ModelRegion,
  (CAST(CalendarYear AS INTEGER) * 100) + CAST(Month AS INTEGER) AS TimeIndex,
  SUM(Quantity) AS Quantity,
  SUM(Amount) AS Amount,
  CalendarYear,
  Month,
  ${CURRENT_SCHEMA}.UDFBUILDISO8601DATE(CalendarYear, Month, 25) AS ReportingDate
FROM
  ${CURRENT_SCHEMA}.vDMPrep
WHERE
  Model IN (
    'Mountain-100',
    'Mountain-200',
    'Road-150',
    'Road-250',
    'Road-650',
    'Road-750',
    'Touring-1000'
  )
GROUP BY
  CASE
    Model
    WHEN 'Mountain-100' THEN 'M200'
    WHEN 'Road-150' THEN 'R250'
    WHEN 'Road-650' THEN 'R750'
    WHEN 'Touring-1000' THEN 'T1000'
    ELSE LEFT(Model, 1) || RIGHT(Model, 3)
  END || ' ' || Region,
  (CAST(CalendarYear AS INTEGER) * 100) + CAST(Month AS INTEGER),
  CalendarYear,
  Month,
  ${CURRENT_SCHEMA}.UDFBUILDISO8601DATE(CalendarYear, Month, 25);