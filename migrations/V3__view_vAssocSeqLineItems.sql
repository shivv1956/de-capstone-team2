CREATE VIEW ${CURRENT_SCHEMA}.vAssocSeqLineItems AS
SELECT
  OrderNumber,
  LineNumber,
  Model
FROM
  ${CURRENT_SCHEMA}.vDMPrep
WHERE
  (FiscalYear = '2013');