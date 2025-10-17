-- vDMPrep will be used as a data source by the other data mining views.
-- Uses DW data at customer, product, day, etc. granularity and
-- gets region, model, year, month, etc.

CREATE OR REPLACE VIEW ${CURRENT_SCHEMA}.vDMPrep AS
SELECT
  pc.EnglishProductCategoryName,
  COALESCE(p.ModelName, p.EnglishProductName) AS Model,
  c.CustomerKey,
  s.SalesTerritoryGroup AS Region,
  CASE
    WHEN MONTH(TO_TIMESTAMP_NTZ(CURRENT_TIMESTAMP())) < MONTH(c.BirthDate) THEN DATEDIFF(
      YY,
      c.BirthDate,
      TO_TIMESTAMP_NTZ(CURRENT_TIMESTAMP())
    ) - 1
    WHEN MONTH(TO_TIMESTAMP_NTZ(CURRENT_TIMESTAMP())) = MONTH(c.BirthDate)
    AND DAY(TO_TIMESTAMP_NTZ(CURRENT_TIMESTAMP())) < DAY(c.BirthDate) THEN DATEDIFF(
      YY,
      c.BirthDate,
      TO_TIMESTAMP_NTZ(CURRENT_TIMESTAMP())
    ) - 1
    ELSE DATEDIFF(
      YY,
      c.BirthDate,
      TO_TIMESTAMP_NTZ(CURRENT_TIMESTAMP())
    )
  END AS Age,
  CASE
    WHEN c.YearlyIncome < 40000 THEN 'Low'
    WHEN c.YearlyIncome > 60000 THEN 'High'
    ELSE 'Moderate'
  END AS IncomeGroup,
  d.CalendarYear,
  d.FiscalYear,
  d.MonthNumberOfYear AS Month,
  f.SalesOrderNumber AS OrderNumber,
  f.SalesOrderLineNumber AS LineNumber,
  f.OrderQuantity AS Quantity,
  f.ExtendedAmount AS Amount
FROM
  dbo.FactInternetSales f
  INNER JOIN dbo.DimDate d ON f.OrderDateKey = d.DateKey
  INNER JOIN dbo.DimProduct p ON f.ProductKey = p.ProductKey
  INNER JOIN dbo.DimProductSubcategory psc ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey
  INNER JOIN dbo.DimProductCategory pc ON psc.ProductCategoryKey = pc.ProductCategoryKey
  INNER JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
  INNER JOIN dbo.DimGeography g ON c.GeographyKey = g.GeographyKey
  INNER JOIN dbo.DimSalesTerritory s ON g.SalesTerritoryKey = s.SalesTerritoryKey;