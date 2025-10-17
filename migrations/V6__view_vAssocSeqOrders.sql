
/* vAssocSeqOrders supports assocation and sequence clustering data mmining models.
      - Limits data to FY2004.
      - Creates order case table and line item nested table.*/
CREATE OR REPLACE VIEW ${CURRENT_SCHEMA}.vAssocSeqOrders AS
SELECT
  DISTINCT OrderNumber,
  CustomerKey,
  Region,
  IncomeGroup
FROM
  ${CURRENT_SCHEMA}.vDMPrep
WHERE
  (FiscalYear = '2013');
