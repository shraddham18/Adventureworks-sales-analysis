-- =============================================
-- Create and initialize the AdventureWorks Database
-- =============================================
Create database AdventureWorks ;
use AdventureWorks ;
USE AdventureWorks;
-- =============================================
-- TABLE CREATION
-- =============================================

-- Customer dimension table storing customer demographic and contact information
CREATE TABLE DimCustomer (
    CustomerKey INT,
    GeographyKey INT,
    CustomerAlternateKey VARCHAR(20),
    Title VARCHAR(10),
    FirstName VARCHAR(50),
    MiddleName VARCHAR(50),
    LastName VARCHAR(50),
    NameStyle VARCHAR(10),
    BirthDate VARCHAR(20),
    MaritalStatus VARCHAR(5),
    Suffix VARCHAR(10),
    Gender VARCHAR(5),
    EmailAddress VARCHAR(100),
    YearlyIncome DECIMAL(10,2),
    TotalChildren INT,
    NumberChildrenAtHome INT,
    EnglishEducation VARCHAR(50),
    SpanishEducation VARCHAR(50),
    FrenchEducation VARCHAR(50),
    EnglishOccupation VARCHAR(50),
    SpanishOccupation VARCHAR(50),
    FrenchOccupation VARCHAR(50),
    HouseOwnerFlag VARCHAR(5),
    NumberCarsOwned INT,
    AddressLine1 VARCHAR(200),
    AddressLine2 VARCHAR(200),
    Phone VARCHAR(50),
    DateFirstPurchase VARCHAR(20),
    CommuteDistance VARCHAR(20)
);
-- Date dimension table storing calendar and fiscal date attributes
CREATE TABLE DimDate (
    DateKey INT,
    FullDateAlternateKey VARCHAR(20),
    DayNumberOfWeek INT,
    EnglishDayNameOfWeek VARCHAR(20),
    SpanishDayNameOfWeek VARCHAR(50),
    FrenchDayNameOfWeek VARCHAR(50),
    DayNumberOfMonth INT,
    DayNumberOfYear INT,
    WeekNumberOfYear INT,
    EnglishMonthName VARCHAR(20),
    SpanishMonthName VARCHAR(20),
    FrenchMonthName VARCHAR(20),
    MonthNumberOfYear INT,
    CalendarQuarter INT,
    CalendarYear INT,
    CalendarSemester INT,
    FiscalQuarter INT,
    FiscalYear INT,
    FiscalSemester INT
);
-- Product dimension table storing product details, pricing, and multilingual descriptions
CREATE TABLE DimProduct (
    ProductKey INT,
    UnitPrice VARCHAR(20),
    ProductAlternateKey VARCHAR(50),
    ProductSubcategoryKey VARCHAR(20),
    WeightUnitMeasureCode VARCHAR(20),
    SizeUnitMeasureCode VARCHAR(20),
    EnglishProductName VARCHAR(100),
    SpanishProductName VARCHAR(100),
    FrenchProductName VARCHAR(100),
    StandardCost VARCHAR(20),
    FinishedGoodsFlag VARCHAR(10),
    Color VARCHAR(20),
    SafetyStockLevel VARCHAR(20),
    ReorderPoint VARCHAR(20),
    ListPrice VARCHAR(20),
    Size VARCHAR(20),
    SizeRange VARCHAR(50),
    Weight VARCHAR(20),
    DaysToManufacture INT,
    ProductLine VARCHAR(10),
    DealerPrice VARCHAR(20),
    Class VARCHAR(10),
    Style VARCHAR(10),
    ModelName VARCHAR(100),
    EnglishDescription TEXT,
    FrenchDescription TEXT,
    ChineseDescription TEXT,
    ArabicDescription TEXT,
    HebrewDescription TEXT,
    ThaiDescription TEXT,
    GermanDescription TEXT,
    JapaneseDescription TEXT,
    TurkishDescription TEXT,
    StartDate VARCHAR(20),
    EndDate VARCHAR(20),
    Status VARCHAR(20)
);
-- Product subcategory dimension table linking products to their parent categories
CREATE TABLE DimProductSubCategory (
    ProductSubcategoryKey INT,
    ProductSubcategoryAlternateKey INT,
    EnglishProductSubcategoryName VARCHAR(100),
    SpanishProductSubcategoryName VARCHAR(100),
    FrenchProductSubcategoryName VARCHAR(100),
    ProductCategoryKey INT
);
-- Product category dimension table storing top-level product classifications
CREATE TABLE DimProductCategory (
    ProductCategoryKey INT,
    ProductCategoryAlternateKey INT,
    EnglishProductCategoryName VARCHAR(50),
    SpanishProductCategoryName VARCHAR(50),
    FrenchProductCategoryName VARCHAR(50)
);
-- Sales territory dimension table storing regional and country-level sales territory info
CREATE TABLE DimSalesTerritory (
    SalesTerritoryKey INT,
    SalesTerritoryAlternateKey INT,
    SalesTerritoryRegion VARCHAR(50),
    SalesTerritoryCountry VARCHAR(50),
    SalesTerritoryGroup VARCHAR(50)
);
-- Fact table storing historical internet sales transactions (older dataset)
CREATE TABLE FactInternetSales_Old (
    ProductKey INT,
    OrderDateKey INT,
    DueDateKey INT,
    ShipDateKey INT,
    CustomerKey INT,
    PromotionKey INT,
    CurrencyKey INT,
    SalesTerritoryKey INT,
    SalesOrderNumber VARCHAR(20),
    SalesOrderLineNumber INT,
    RevisionNumber INT,
    OrderQuantity INT,
    UnitPrice DECIMAL(10,2),
    ExtendedAmount DECIMAL(10,2),
    UnitPriceDiscountPct DECIMAL(10,4),
    DiscountAmount DECIMAL(10,2),
    ProductStandardCost DECIMAL(10,4),
    TaxAmt DECIMAL(10,4),
    Freight DECIMAL(10,4),
    CarrierTrackingNumber VARCHAR(50),
    CustomerPONumber VARCHAR(50),
    OrderDate VARCHAR(20),
    DueDate VARCHAR(20),
    ShipDate VARCHAR(20)
);
-- Fact table storing recent internet sales transactions (newer dataset)
CREATE TABLE FactInternetSales_New (
    ProductKey INT,
    OrderDateKey INT,
    DueDateKey INT,
    ShipDateKey INT,
    CustomerKey INT,
    PromotionKey INT,
    CurrencyKey INT,
    SalesTerritoryKey INT,
    SalesOrderNumber VARCHAR(20),
    SalesOrderLineNumber INT,
    RevisionNumber INT,
    OrderQuantity INT,
    UnitPrice DECIMAL(10,2),
    ExtendedAmount DECIMAL(10,2),
    UnitPriceDiscountPct DECIMAL(10,4),
    DiscountAmount DECIMAL(10,2),
    ProductStandardCost DECIMAL(10,4),
    TaxAmt DECIMAL(10,4),
    Freight DECIMAL(10,4),
    CarrierTrackingNumber VARCHAR(50),
    CustomerPONumber VARCHAR(50),
    OrderDate VARCHAR(20),
    DueDate VARCHAR(20),
    ShipDate VARCHAR(20)
);
-- =============================================
-- COMBINE OLD AND NEW SALES DATA
-- =============================================

-- Merge old and new sales fact tables into a single unified Sales table
CREATE TABLE Sales AS
SELECT * FROM FactInternetSales_Old
UNION ALL
SELECT * FROM FactInternetSales_New;

-- Verify total number of rows loaded into the combined Sales table
SELECT COUNT(*) AS TotalRows FROM Sales;

-- =============================================
-- DATA QUALITY CHECKS
-- =============================================
-- 1. Check for NULL values in Sales
SELECT 
    SUM(CASE WHEN ProductKey IS NULL THEN 1 ELSE 0 END) AS Null_ProductKey,
    SUM(CASE WHEN CustomerKey IS NULL THEN 1 ELSE 0 END) AS Null_CustomerKey,
    SUM(CASE WHEN OrderDateKey IS NULL THEN 1 ELSE 0 END) AS Null_OrderDateKey,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS Null_UnitPrice,
    SUM(CASE WHEN OrderQuantity IS NULL THEN 1 ELSE 0 END) AS Null_OrderQuantity,
    SUM(CASE WHEN ProductStandardCost IS NULL THEN 1 ELSE 0 END) AS Null_ProductCost
FROM Sales;

-- 2. Check for duplicate orders
SELECT SalesOrderNumber, SalesOrderLineNumber, COUNT(*) AS DuplicateCount
FROM Sales
GROUP BY SalesOrderNumber, SalesOrderLineNumber
HAVING COUNT(*) > 1;

-- 3. Check min and max dates
SELECT 
    MIN(OrderDateKey) AS EarliestOrder,
    MAX(OrderDateKey) AS LatestOrder
FROM Sales;

-- 4. Check for negative values
SELECT COUNT(*) AS NegativeUnitPrice
FROM Sales
WHERE UnitPrice < 0;

SELECT COUNT(*) AS NegativeQuantity  
FROM Sales
WHERE OrderQuantity < 0;

-- =============================================
-- KEY PERFORMANCE INDICATORS (KPIs)
-- =============================================


-- 1. Total Sales
-- Calculate overall revenue after discounts, expressed in millions
SELECT CONCAT('$', ROUND(SUM(UnitPrice * OrderQuantity - DiscountAmount) / 1000000, 2), ' Million') 
AS Total_Sales FROM Sales;

-- 2. Total Production Cost
-- Calculate total manufacturing cost based on standard cost per unit and quantity ordered
SELECT CONCAT('$', ROUND(SUM(ProductStandardCost * OrderQuantity) / 1000000, 2), ' Million') 
AS Total_Production_Cost FROM Sales;

-- 3. Total Profit
-- Calculate net profit as the difference between revenue (after discounts) and production cost
SELECT CONCAT('$', ROUND(SUM((UnitPrice * OrderQuantity - DiscountAmount) - 
(ProductStandardCost * OrderQuantity)) / 1000000, 2), ' Million') 
AS Total_Profit FROM Sales;

-- 4. Profit Margin %
-- Calculate profit margin as a percentage of total revenue after discounts
SELECT CONCAT(ROUND(SUM((UnitPrice * OrderQuantity - DiscountAmount) - 
(ProductStandardCost * OrderQuantity)) / 
SUM(UnitPrice * OrderQuantity - DiscountAmount) * 100, 2), '%') 
AS Profit_Margin_Percent FROM Sales;

-- 5. Total Orders
-- Count total number of sales orders placed
SELECT COUNT(SalesOrderNumber) AS Total_Orders FROM Sales;

-- 6. Yearwise Sales
-- Break down total sales revenue by calendar year, extracted from OrderDateKey (format: YYYYMMDD)
SELECT 
    LEFT(OrderDateKey, 4) AS Year,
    CONCAT('$', ROUND(SUM(UnitPrice * OrderQuantity - DiscountAmount) / 1000000, 2), ' Million') AS Total_Sales
FROM Sales
GROUP BY LEFT(OrderDateKey, 4)
ORDER BY Year;

-- 7. Monthwise Sales
-- Break down total sales revenue by year and month for trend analysis
SELECT 
    LEFT(OrderDateKey, 4) AS Year,
    SUBSTRING(OrderDateKey, 5, 2) AS Month,
    CONCAT('$', ROUND(SUM(UnitPrice * OrderQuantity - DiscountAmount) / 1000000, 2), ' Million') AS Total_Sales
FROM Sales
GROUP BY LEFT(OrderDateKey, 4), SUBSTRING(OrderDateKey, 5, 2)
ORDER BY Year, Month;

-- 8. Quarterwise Sales
-- Break down total sales revenue by fiscal quarter using QUARTER() on the parsed order date
SELECT 
    LEFT(OrderDateKey, 4) AS Year,
    CONCAT('Q', QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))) AS Quarter,
    CONCAT('$', ROUND(SUM(UnitPrice * OrderQuantity - DiscountAmount) / 1000000, 2), ' Million') AS Total_Sales
FROM Sales
GROUP BY Year, Quarter
ORDER BY Year, Quarter;

-- 9. Sales by Country
-- Aggregate total sales per country by joining Sales with the Sales Territory dimension
SELECT 
    t.SalesTerritoryCountry,
    CONCAT('$', ROUND(SUM(s.UnitPrice * s.OrderQuantity - s.DiscountAmount) / 1000000, 2), ' Million') AS Total_Sales
FROM Sales s
JOIN DimSalesTerritory t ON s.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY t.SalesTerritoryCountry
ORDER BY SUM(s.UnitPrice * s.OrderQuantity - s.DiscountAmount) DESC;

-- 10. Sales by Category
-- Aggregate total sales per product category by joining through the product hierarchy
SELECT 
    c.EnglishProductCategoryName,
    CONCAT('$', ROUND(SUM(s.UnitPrice * s.OrderQuantity - s.DiscountAmount) / 1000000, 2), ' Million') AS Total_Sales
FROM Sales s
JOIN DimProduct p ON s.ProductKey = p.ProductKey
JOIN DimProductSubCategory sc ON p.ProductSubcategoryKey = sc.ProductSubcategoryKey
JOIN DimProductCategory c ON sc.ProductCategoryKey = c.ProductCategoryKey
GROUP BY c.EnglishProductCategoryName
ORDER BY SUM(s.UnitPrice * s.OrderQuantity - s.DiscountAmount) DESC;

-- 11. Top 5 Products
-- Identify the top 5 best-selling products by total revenue after discounts
SELECT 
    p.EnglishProductName,
    CONCAT('$', ROUND(SUM(s.UnitPrice * s.OrderQuantity - s.DiscountAmount) / 1000000, 2), ' Million') AS Total_Sales
FROM Sales s
JOIN DimProduct p ON s.ProductKey = p.ProductKey
GROUP BY p.EnglishProductName
ORDER BY SUM(s.UnitPrice * s.OrderQuantity - s.DiscountAmount) DESC
LIMIT 5;







