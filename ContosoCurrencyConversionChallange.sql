/*Query to convert sales from USD to another currency. For this test I used the Euro*/
SELECT 
[FactSales].[SalesKey], 
FORMAT([table1].[rounded_date], 'MM-yyyy') AS rounded_date,
[FactSales].[SalesAmount] AS USD_SalesAmount,
[FactExchangeRate].[AverageRate],
ROUND([FactSales].[SalesAmount] * [FactExchangeRate].[AverageRate], 2) AS Converted_SalesAmount
FROM [ContosoRetailDW].[dbo].[FactSales]
JOIN(
    SELECT 
    [FactSales].[SalesKey],
    [FactSales].[SalesAmount],
    CASE 
        WHEN DAY([FactSales].[DateKey]) >= 16
        THEN DATEADD(m, 1, [FactSales].[DateKey])
        ELSE [FactSales].[DateKey]
    END AS rounded_date
    FROM [ContosoRetailDW].[dbo].[FactSales]
    ) AS table1
        ON [FactSales].[SalesKey] = [table1].[SalesKey]
JOIN [ContosoRetailDW].[dbo].[FactExchangeRate]
    ON FORMAT([table1].[rounded_date], 'MM-yyyy') = FORMAT([FactExchangeRate].[DateKey], 'MM-yyyy') AND [FactExchangeRate].[CurrencyKey] = '7';
/*To convert sales amount to another currency merely change "[FactExchangeRate].[CurrencyKey] = '7'" to contain the currency key for your desired currency*/