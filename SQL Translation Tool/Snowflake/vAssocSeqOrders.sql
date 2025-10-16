-- WARNING: line 1, character 0: Statement is not supported: MS SQL server settings in SET statement. It only sets the local variable.
/* SET ANSI_NULLS ON; */
-- WARNING: line 3, character 0: Statement is not supported: MS SQL server settings in SET statement. It only sets the local variable.
/* SET QUOTED_IDENTIFIER ON; */
/* vAssocSeqOrders supports assocation and sequence clustering data mmining models.
      - Limits data to FY2004.
      - Creates order case table and line item nested table.*/
CREATE VIEW dbo.vAssocSeqOrders AS
SELECT
  DISTINCT OrderNumber,
  CustomerKey,
  Region,
  IncomeGroup
FROM
  dbo.vDMPrep
WHERE
  (FiscalYear = '2013');
