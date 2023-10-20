
CREATE DATABASE AW2017;
GO

USE AW2017
GO
---- Dim
-- DimProducts
CREATE TABLE dbo.DimProducts(
	ProductID INT NOT NULL,
	ProductName NVARCHAR(50) NULL,
	ProductNumber NVARCHAR(25) NULL,
	ProductCategory INT NULL,
	ProductSubcategory INT NULL,
	StandardCost MONEY NULL,
    ListPrice MONEY NULL,
	Discontinued DATETIME NULL,
    StartDate DATE NOT NULL,
	EndDate DATE NULL,
    CONSTRAINT PK_DimProduct PRIMARY KEY CLUSTERED ( ProductID )
);
GO
-- DimCustomer
CREATE TABLE dbo.DimCustomers(
    CustomerID INT NOT NULL,
    FirstName NVARCHAR(50) NULL,
    LastName NVARCHAR(50) NULL,
    EmailAddress NVARCHAR(50) NULL,
    PhoneNumber NVARCHAR(25) NULL,
    Address_ NVARCHAR(120) NULL,
    City NVARCHAR(30) NULL,
    StateProvince NVARCHAR(50) NULL,
    CountryRegion NVARCHAR(50) NULL,
    PostalCode NVARCHAR(15) NULL,
    StartDate DATE NOT NULL,
	EndDate DATE NULL,
    CONSTRAINT PK_DimCustomers PRIMARY KEY CLUSTERED ( CustomerID )
);

GO
-- DimDate
CREATE TABLE dbo.DimDate(
	DateID INT NOT NULL,
	DateValue DATE NOT NULL,
	CYear SMALLINT NOT NULL,
	CQtr TINYINT NOT NULL,
	CMonth TINYINT NOT NULL,
	Day TINYINT NOT NULL,
	StartOfMonth DATE NOT NULL,
	EndOfMonth DATE NOT NULL,
	MonthName VARCHAR(9) NOT NULL,
	DayOfWeekName VARCHAR(9) NOT NULL,
    CONSTRAINT PK_DimDate PRIMARY KEY CLUSTERED ( DateID )
);
GO

CREATE PROCEDURE dbo.DimDate_Load_Multi_Dates
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
 DECLARE @CurrDate DATE 
 SET @CurrDate = @StartDate
 WHILE ( @CurrDate <= @EndDate)
 BEGIN
  INSERT INTO dbo.DimDate
  SELECT CAST( YEAR(@CurrDate) * 10000 + MONTH(@CurrDate) * 100 + DAY(@CurrDate) AS INT),
      @CurrDate,
      YEAR(@CurrDate),
      MONTH(@CurrDate),
      DAY(@CurrDate),
      DATEPART(qq, @CurrDate),
      DATEADD(DAY, 1, EOMONTH(@CurrDate, -1)),
      EOMONTH(@CurrDate),
      DATENAME(mm, @CurrDate),
      DATENAME(dw, @CurrDate);
  SET @CurrDate = DATEADD(day, 1, @CurrDate);
 END
END
GO

EXECUTE dbo.DimDate_Load_Multi_Dates @StartDate='2001-01-01', @EndDate='2022-12-31';
-- SELECT * from dbo.DimDate
GO

-- DimSalesperson
CREATE TABLE dbo.DimSalesperson (
    SalespersonID INT NOT NULL,
    FirstName NVARCHAR(50) NULL,
    LastName NVARCHAR(50) NULL,
    Territory NVARCHAR(50) NULL,
    CommissionPct DECIMAL(5,2) NULL,
    SalesQuota MONEY NULL,
    EmailAddress NVARCHAR(50) NULL,
    PhoneNumber NVARCHAR(25) NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NULL,
    CONSTRAINT Salesperson_PK PRIMARY KEY CLUSTERED (SalespersonID)
);
GO
-- DimPromotion
CREATE TABLE dbo.DimPromotion (
    PromotionID INT NOT NULL,
    PromotionName NVARCHAR(50) NOT NULL,
    PromotionType NVARCHAR(50) NOT NULL,
    PromotionStartDate DATE NOT NULL,
    PromotionEndDate DATE NULL,
    DiscountPct DECIMAL(18,2) NOT NULL,
    MinQuantity INT NOT NULL,
    MaxQuantity INT NULL,
    StartDate DATE NOT NULL,
	EndDate DATE NULL,
    CONSTRAINT Promotion_PK PRIMARY KEY CLUSTERED (PromotionID)
);
GO
-- Fact

CREATE TABLE FactSales (
    ProductID INT,
    CustomerID INT,
    DateID INT,
    SalespersonID INT,
    PromotionID INT,
    OrderQuantity INT,
    UnitPrice DECIMAL(18, 2),
    Discount DECIMAL(5, 2),
    LineTotal DECIMAL(18, 2),
    FOREIGN KEY (ProductID) REFERENCES DimProducts(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomers(CustomerID),
    FOREIGN KEY (DateID) REFERENCES DimDate(DateID),
    FOREIGN KEY (SalespersonID) REFERENCES DimSalesperson(SalespersonID),
    FOREIGN KEY (PromotionID) REFERENCES DimPromotion(PromotionID),
);
CREATE INDEX IX_FactOrders_ProductID ON dbo.FactSales(ProductID);
CREATE INDEX IX_FactOrders_CustomerID ON dbo.FactSales(CustomerID);
CREATE INDEX IX_FactOrders_DateID ON dbo.FactSales(DateID);
CREATE INDEX IX_FactOrders_SalespersonID ON dbo.FactSales(SalespersonID);
CREATE INDEX IX_FactOrders_PromotionID ON dbo.FactSales(PromotionID);
GO

---- Stage
-- Products
CREATE TABLE dbo.Products_Stage (
	ProductName NVARCHAR(50) NULL,
	ProductNumber NVARCHAR(25) NULL,
	ProductCategory INT NULL,
	ProductSubcategory INT NULL,
	StandardCost MONEY NULL,
    ListPrice MONEY NULL,
	Discontinued DATETIME NULL,
);
GO
-- Customer
CREATE TABLE dbo.Customers_Stage(
    FirstName NVARCHAR(50) NULL,
    LastName NVARCHAR(50) NULL,
    EmailAddress NVARCHAR(50) NULL,
    PhoneNumber NVARCHAR(25) NULL,
    Address_ NVARCHAR(120) NULL,
    City NVARCHAR(30) NULL,
    StateProvince NVARCHAR(50) NULL,
    CountryRegion NVARCHAR(50) NULL,
    PostalCode NVARCHAR(15) NULL
);
GO
-- Salesperson
CREATE TABLE dbo.Salesperson_Stage (
    FirstName NVARCHAR(50) NULL,
    LastName NVARCHAR(50) NULL,
    Territory NVARCHAR(50) NULL,
    CommissionPct DECIMAL(18,2) NULL,
    SalesQuota MONEY NULL,
    EmailAddress NVARCHAR(50) NULL,
    PhoneNumber NVARCHAR(25) NULL
);
GO
-- Promotion
CREATE TABLE dbo.Promotion_Stage (
    PromotionName NVARCHAR(50) NULL,
    PromotionType NVARCHAR(50) NULL,
    PromotionStartDate DATE NULL,
    PromotionEndDate DATE NULL,
    DiscountPct DECIMAL(18,2) NULL,
    MinQuantity INT NULL,
    MaxQuantity INT NULL,
);
GO
-- Fact
CREATE TABLE dbo.Sales_Stage (
    ProductName NVARCHAR(50),
    CustomerName NVARCHAR(50),
    OrderDate DATE,
    SalespersonName NVARCHAR(50),
    PromotionName NVARCHAR(50) NULL,
    OrderQuantity INT,
    UnitPrice DECIMAL(18, 2),
    Discount DECIMAL(5, 2),
    LineTotal DECIMAL(18, 2)
);
GO

---- Extract
-- Products
CREATE PROCEDURE dbo.Products_Extract
AS
BEGIN;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @RowCt INT;

    TRUNCATE TABLE dbo.Products_Stage;

    INSERT INTO dbo.Products_Stage (
	    ProductName,
	    ProductNumber,
	    ProductCategory,
	    ProductSubcategory,
	    StandardCost,
        ListPrice,
	    Discontinued)
    SELECT p.Name,
           p.ProductNumber,
           ps.ProductCategoryID,
           ps.ProductSubcategoryID,
           p.StandardCost,
           p.ListPrice,
           p.DiscontinuedDate
    FROM AdventureWorks2017.Production.Product p
    JOIN AdventureWorks2017.Production.ProductSubCategory ps
			ON p.ProductSubCategoryID = ps.ProductSubCategoryID;
    SET @RowCt = @@ROWCOUNT;
    IF @RowCt = 0 
    BEGIN;
        THROW 50001, 'No records found. Check with source system.', 1;
    END;
END; --END OF PROCEDURE Productss_Extract
GO

-- Customer
CREATE PROCEDURE dbo.Customers_Extract
AS
BEGIN;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @RowCt INT;

    TRUNCATE TABLE dbo.Customers_Stage;

    INSERT INTO dbo.Customers_Stage (
	    FirstName,
	    LastName,
	    EmailAddress,
	    PhoneNumber,
	    Address_,
        City,
	    StateProvince,
        CountryRegion,
        PostalCode)
    SELECT P.FirstName,
           P.LastName,
           E.EmailAddress,
           PP.PhoneNumber,
           A.AddressLine1 + ISNULL(' ' + A.AddressLine2, '') AS Address,
           A.City,
           SP.Name AS StateProvince,
           CR.Name AS CountryRegion,
           A.PostalCode
    FROM AdventureWorks2017.Sales.Customer AS C
    JOIN AdventureWorks2017.Person.Person AS P 
        ON C.PersonID = P.BusinessEntityID
    JOIN AdventureWorks2017.Person.EmailAddress AS E 
        ON P.BusinessEntityID = E.BusinessEntityID
    JOIN AdventureWorks2017.Person.PersonPhone AS PP 
        ON P.BusinessEntityID = PP.BusinessEntityID
    JOIN AdventureWorks2017.Person.BusinessEntityAddress AS BEA 
        ON P.BusinessEntityID = BEA.BusinessEntityID
    JOIN AdventureWorks2017.Person.Address AS A 
        ON BEA.AddressID = A.AddressID
    JOIN AdventureWorks2017.Person.StateProvince AS SP 
        ON A.StateProvinceID = SP.StateProvinceID
    JOIN AdventureWorks2017.Person.CountryRegion AS CR 
        ON SP.CountryRegionCode = CR.CountryRegionCode;

    SET @RowCt = @@ROWCOUNT;
    IF @RowCt = 0 
    BEGIN;
        THROW 50001, 'No records found. Check with source system.', 1;
    END;
END; --END OF PROCEDURE Customers_Extract
GO
-- Salesperson
CREATE PROCEDURE dbo.Salesperson_Extract
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @RowCt INT;

    TRUNCATE TABLE dbo.SalesPerson_Stage;

    INSERT INTO dbo.SalesPerson_Stage (
        FirstName,
        LastName,
        Territory,
        CommissionPct,
        SalesQuota,
        EmailAddress,
        PhoneNumber
    )
    SELECT
        p.FirstName,
        p.LastName,
        st.Name AS Territory,
        sp.CommissionPct,
        sp.SalesQuota,
        e.EmailAddress,
        ph.PhoneNumber
    FROM AdventureWorks2017.Sales.SalesPerson sp
    INNER JOIN AdventureWorks2017.Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
    INNER JOIN AdventureWorks2017.Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
    LEFT JOIN AdventureWorks2017.Person.EmailAddress e ON p.BusinessEntityID = e.BusinessEntityID
    LEFT JOIN AdventureWorks2017.Person.PersonPhone ph ON p.BusinessEntityID = ph.BusinessEntityID AND ph.PhoneNumberTypeID = 1;
    --Note that the LEFT JOIN is used instead of INNER JOIN in case there are salespeople who don't have an email address or phone number in the corresponding tables.
    SET @RowCt = @@ROWCOUNT;
    IF @RowCt = 0 
    BEGIN;
        THROW 50001, 'No records found. Check with source system.', 1;
    END;
END;
GO
-- Promotion
CREATE PROCEDURE dbo.Promotion_Extract
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Truncate the staging table to remove any existing data
    TRUNCATE TABLE dbo.Promotion_Stage;

    -- Insert data from Sales.SpecialOffer and Sales.SpecialOfferProduct tables into the staging table
    INSERT INTO dbo.Promotion_Stage (
        PromotionName,
        PromotionType,
        PromotionStartDate,
        PromotionEndDate,
        DiscountPct,
        MinQuantity,
        MaxQuantity
    )
    SELECT
        so.Description AS PromotionName,
        so.Category AS PromotionType,
        so.StartDate AS PromotionStartDate,
        so.EndDate AS PromotionEndDate,
        so.DiscountPct,
        so.MinQty,
        so.MaxQty
    FROM
        AdventureWorks2017.Sales.SpecialOffer AS so
        JOIN AdventureWorks2017.Sales.SpecialOfferProduct AS sop ON so.SpecialOfferID = sop.SpecialOfferID;
END;
GO
-- Fact
CREATE PROCEDURE dbo.Sales_Extract
AS
BEGIN;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @RowCt INT;
    
    TRUNCATE TABLE dbo.Sales_Stage;
    
    INSERT INTO dbo.Sales_Stage(
        ProductName,
        CustomerName,
        OrderDate,
        SalespersonName,
        PromotionName,
        OrderQuantity,
        UnitPrice,
        Discount,
        LineTotal
    )
    SELECT
        p.Name AS ProductName,
        CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
        h.OrderDate,
        CONCAT(pp.FirstName, ' ', pp.LastName) AS SalespersonName,
        so.Description AS PromotionName,
        d.OrderQty AS OrderQuantity,
        d.UnitPrice,
        d.UnitPriceDiscount AS Discount,
        d.LineTotal
    FROM AdventureWorks2017.Sales.SalesOrderHeader h
    INNER JOIN AdventureWorks2017.Sales.SalesOrderDetail d
        ON h.SalesOrderID = d.SalesOrderID
    INNER JOIN AdventureWorks2017.Production.Product p
        ON d.ProductID = p.ProductID
    INNER JOIN AdventureWorks2017.Sales.Customer cu
        ON h.CustomerID = cu.CustomerID
    INNER JOIN AdventureWorks2017.Person.Person c
        ON cu.PersonID = c.BusinessEntityID
    INNER JOIN AdventureWorks2017.Sales.SalesPerson sp
        ON h.SalesPersonID = sp.BusinessEntityID
    INNER JOIN AdventureWorks2017.Person.Person pp
        ON sp.BusinessEntityID = pp.BusinessEntityID
    INNER JOIN AdventureWorks2017.Sales.SpecialOfferProduct sop
        ON d.SpecialOfferID = sop.SpecialOfferID AND d.ProductID = sop.ProductID
    INNER JOIN AdventureWorks2017.Sales.SpecialOffer so
        ON sop.SpecialOfferID = so.SpecialOfferID
    
    SET @RowCt = @@ROWCOUNT;
    IF @RowCt = 0 
    BEGIN;
        THROW 50001, 'No records found. Check with source system.', 1;
    END;
END; --END OF PROCEDURE Sales_Extract
GO

EXECUTE dbo.Products_Extract;
-- SELECT * FROM Products_Stage;
EXECUTE dbo.Customers_Extract;
-- SELECT * FROM Customers_Stage;
EXECUTE dbo.Salesperson_Extract;
-- SELECT * FROM Salesperson_Stage;
EXECUTE dbo.Promotion_Extract;
-- SELECT * FROM Promotion_Stage;
EXECUTE dbo.Sales_Extract;
-- SELECT * FROM Sales_Stage;

---- Preload
-- Products
CREATE TABLE dbo.Products_Preload (
	ProductID INT NOT NULL,
	ProductName NVARCHAR(50) NULL,
	ProductNumber NVARCHAR(25) NULL,
	ProductCategory INT NULL,
	ProductSubcategory INT NULL,
	StandardCost MONEY NULL,
    ListPrice MONEY NULL,
	Discontinued DATETIME NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    CONSTRAINT PK_Products_Preload PRIMARY KEY CLUSTERED ( ProductID )
);
GO
-- Customer
CREATE TABLE dbo.Customers_Preload( 
    CustomerID INT NOT NULL,
    FirstName NVARCHAR(50) NULL,
    LastName NVARCHAR(50) NULL,
    EmailAddress NVARCHAR(50) NULL,
    PhoneNumber NVARCHAR(25) NULL,
    Address_ NVARCHAR(120) NULL,
    City NVARCHAR(30) NULL,
    StateProvince NVARCHAR(50) NULL,
    CountryRegion NVARCHAR(50) NULL,
    PostalCode NVARCHAR(15) NULL,
    StartDate DATE NOT NULL,
	EndDate DATE NULL,
    CONSTRAINT PK_Customers_Preload PRIMARY KEY CLUSTERED (CustomerID) 
);
-- Salesperson
CREATE TABLE dbo.Salesperson_Preload (
    SalespersonID INT NOT NULL,
    FirstName NVARCHAR(50) NULL,
    LastName NVARCHAR(50) NULL,
    Territory NVARCHAR(50) NULL,
    CommissionPct DECIMAL(5,2) NULL,
    SalesQuota MONEY NULL,
    EmailAddress NVARCHAR(50) NULL,
    PhoneNumber NVARCHAR(25) NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NULL,
    CONSTRAINT PK_Salesperson_Preload PRIMARY KEY CLUSTERED (SalespersonID)
);
GO
-- Promotion
CREATE TABLE dbo.Promotion_Preload (
    PromotionID INT NOT NULL,
    PromotionName NVARCHAR(50) NOT NULL,
    PromotionType NVARCHAR(50) NOT NULL,
    PromotionStartDate DATE NOT NULL,
    PromotionEndDate DATE  NULL,
    DiscountPct DECIMAL(18,2) NOT NULL,
    MinQuantity INT NOT NULL,
    MaxQuantity INT NULL,
    StartDate DATE NOT NULL,
	EndDate DATE NULL,
    CONSTRAINT PK_Promotion_Preload PRIMARY KEY CLUSTERED (PromotionID)
);
GO
-- Fact
CREATE TABLE dbo.Sales_Preload (
	ProductID INT,
    CustomerID INT,
    DateID INT,
    SalespersonID INT,
    PromotionID INT,
    OrderQuantity INT,
    UnitPrice DECIMAL(18, 2),
    Discount DECIMAL(5, 2),
    LineTotal DECIMAL(18, 2),
);
GO

CREATE SEQUENCE dbo.ProductID START WITH 1;
CREATE SEQUENCE dbo.CustomerID START WITH 1;
CREATE SEQUENCE dbo.SalespersonID START WITH 1;
CREATE SEQUENCE dbo.PromotionID START WITH 1;
CREATE SEQUENCE dbo.SalesID START WITH 1;
GO

---- Transform
-- Products
CREATE PROCEDURE dbo.Products_Transform    -- Type 2 SCD
    @StartDate DATE
AS
BEGIN;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
	
    TRUNCATE TABLE dbo.Products_Preload;

    -- DECLARE @StartDate DATE = GETDATE();
    DECLARE @EndDate DATE = DATEADD(dd,-1,@StartDate);

    BEGIN TRANSACTION;

	/*ADD UPDATED RECORDS*/
    INSERT INTO dbo.Products_Preload 
    SELECT NEXT VALUE FOR dbo.ProductID AS ProductID,
           ps.ProductName,
           ps.ProductNumber,
           ps.ProductCategory,
           ps.ProductSubcategory,
           ps.StandardCost,
           ps.ListPrice,
           ps.Discontinued,
           @StartDate,
           NULL
    FROM dbo.Products_Stage ps
    JOIN dbo.DimProducts dp
        ON ps.ProductName = dp.ProductName
    WHERE ps.ProductNumber <> dp.ProductNumber
          OR ps.ProductCategory <> dp.ProductCategory
          OR ps.ProductSubcategory <> dp.ProductSubcategory
          OR ps.StandardCost <> dp.StandardCost
          OR ps.ListPrice <> dp.ListPrice
          OR ps.Discontinued <> dp.Discontinued;

	/*ADD EXISTING RECORDS, AND EXPIRE AS NECESSARY*/
    INSERT INTO dbo.Products_Preload 
    SELECT dp.ProductID,
           dp.ProductName,
           dp.ProductNumber,
           dp.ProductCategory,
           dp.ProductSubcategory,
           dp.StandardCost,
           dp.ListPrice,
           dp.Discontinued,
           dp.StartDate,
           CASE
            WHEN dp.ProductName IS NULL THEN NULL
            ELSE @EndDate
           END AS EndDate
    FROM dbo.DimProducts dp
    LEFT JOIN dbo.Products_Preload pp
        ON dp.ProductName = pp.ProductName
    
	/*CREATE NEW RECORDS*/
    INSERT INTO dbo.Products_Preload 
    SELECT NEXT VALUE FOR dbo.ProductID AS ProductID,
           ps.ProductName,
           ps.ProductNumber,
           ps.ProductCategory,
           ps.ProductSubcategory,
           ps.StandardCost,
           ps.ListPrice,
           ps.Discontinued,
           @StartDate,
           NULL
    FROM dbo.Products_Stage ps
    WHERE NOT EXISTS ( SELECT 1 FROM dbo.DimProducts dp WHERE dp.ProductName = ps.ProductName );

	/*EXPRIRE MISSING RECORDS*/
    INSERT INTO dbo.Products_Preload 
    SELECT dp.ProductID,
           dp.ProductName,
           dp.ProductNumber,
           dp.ProductCategory,
           dp.ProductSubcategory,
           dp.StandardCost,
           dp.ListPrice,
           dp.Discontinued,
           dp.StartDate,
           @EndDate
    FROM dbo.DimProducts dp
    WHERE NOT EXISTS ( SELECT 1 FROM dbo.Products_Stage ps WHERE ps.ProductName = dp.ProductName )
	    AND dp.EndDate IS NULL;
    COMMIT TRANSACTION;
END; --END OF PROCEDURE Products_Transform
GO

CREATE PROCEDURE dbo.Customers_Transform    -- Type 2 SCD
    @StartDate DATE
AS
BEGIN;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
	
    TRUNCATE TABLE dbo.Customers_Preload;

    -- DECLARE @StartDate DATE = GETDATE();
    DECLARE @EndDate DATE = DATEADD(dd,-1,@StartDate);

    BEGIN TRANSACTION;

	/*ADD UPDATED RECORDS*/
    INSERT INTO dbo.Customers_Preload 
    SELECT NEXT VALUE FOR dbo.CustomerID AS CustomerID,
           cs.FirstName,
           cs.LastName,
           cs.EmailAddress,
           cs.PhoneNumber,
           cs.Address_,
           cs.City,
           cs.StateProvince,
           cs.CountryRegion,
           cs.PostalCode,
           @StartDate,
           NULL
    FROM dbo.Customers_Stage cs
    JOIN dbo.DimCustomers dc
        ON cs.FirstName = dc.FirstName AND cs.LastName = dc.LastName
    WHERE cs.EmailAddress <> dc.EmailAddress
          OR cs.PhoneNumber <> dc.PhoneNumber
          OR cs.City <> dc.City
          OR cs.StateProvince <> dc.StateProvince
          OR cs.CountryRegion <> dc.CountryRegion
          OR cs.PostalCode <> dc.PostalCode;

	/*ADD EXISTING RECORDS, AND EXPIRE AS NECESSARY*/
    INSERT INTO dbo.Customers_Preload 
    SELECT dc.CustomerID,
           dc.FirstName,
           dc.LastName,
           dc.EmailAddress,
           dc.PhoneNumber,
           dc.Address_,
           dc.City,
           dc.StateProvince,
           dc.CountryRegion,
           dc.PostalCode,
           dc.StartDate,
           CASE
            WHEN dc.FirstName IS NULL AND dc.LastName IS NULL THEN NULL
            ELSE @EndDate
           END AS EndDate
    FROM dbo.DimCustomers dc
    LEFT JOIN dbo.Customers_Preload cp
        ON dc.FirstName = cp.LastName AND dc.LastName = cp.LastName
    
	/*CREATE NEW RECORDS*/
    INSERT INTO dbo.Customers_Preload 
    SELECT NEXT VALUE FOR dbo.CustomerID AS CustomerID,
           cs.FirstName,
           cs.LastName,
           cs.EmailAddress,
           cs.PhoneNumber,
           cs.Address_,
           cs.City,
           cs.StateProvince,
           cs.CountryRegion,
           cs.PostalCode,
           @StartDate,
           NULL
    FROM dbo.Customers_Stage cs
    WHERE NOT EXISTS ( SELECT 1 FROM dbo.DimCustomers dc WHERE dc.FirstName = cs.FirstName AND dc.LastName = cs.LastName);

	/*EXPRIRE MISSING RECORDS*/
    INSERT INTO dbo.Customers_Preload 
    SELECT dc.CustomerID,
           dc.FirstName,
           dc.LastName,
           dc.EmailAddress,
           dc.PhoneNumber,
           dc.Address_,
           dc.City,
           dc.StateProvince,
           dc.CountryRegion,
           dc.PostalCode,
           dc.StartDate,
           @EndDate
    FROM dbo.DimCustomers dc
    WHERE NOT EXISTS ( SELECT 1 FROM dbo.Customers_Stage cs WHERE dc.FirstName = cs.FirstName AND dc.LastName = cs.LastName )
	    AND dc.EndDate IS NULL;
    COMMIT TRANSACTION;
END; --END OF PROCEDURE Products_Transform
GO
-- Salesperson
CREATE OR ALTER PROCEDURE dbo.Salesperson_Transform
	@StartDate DATE
AS
BEGIN;
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	TRUNCATE TABLE dbo.Salesperson_Preload;

	--DECLARE @StartDate DATE = GETDATE();
	DECLARE @EndDate DATE = DATEADD(dd,-1,GETDATE());

	BEGIN TRANSACTION;
	-- Add updated records
	INSERT INTO dbo.Salesperson_Preload /* Column list excluded for brevity */
	SELECT NEXT VALUE FOR dbo.SalespersonID AS SalespersonID,
		stg.FirstName,
		stg.LastName,
		stg.Territory,
		stg.CommissionPct,
		stg.SalesQuota,
		stg.EmailAddress,
		stg.PhoneNumber,
		@StartDate,
		NULL
	FROM dbo.Salesperson_Stage stg
	JOIN dbo.DimSalesperson sa
		ON stg.FirstName = sa.FirstName AND stg.LastName = sa.LastName AND sa.EndDate IS NULL
	WHERE stg.Territory <> sa.Territory
		OR stg.CommissionPct <> sa.CommissionPct
		OR stg.SalesQuota <> sa.SalesQuota
		OR stg.EmailAddress <> sa.EmailAddress
		OR stg.PhoneNumber <> sa.PhoneNumber;
	-- Add existing records, and expire as necessary
	INSERT INTO dbo.Salesperson_Preload /* Column list excluded for brevity */
	SELECT sa.SalespersonID,
		sa.FirstName,
		sa.LastName,
		sa.Territory,
		sa.CommissionPct,
		sa.SalesQuota,
		sa.EmailAddress,
		sa.PhoneNumber,
		sa.StartDate,
		CASE
			WHEN pl.FirstName IS NULL THEN NULL
			ELSE @EndDate
			END AS EndDate
	FROM dbo.DimSalesperson sa
	LEFT JOIN dbo.Salesperson_Preload pl    
		ON pl.FirstName = sa.FirstName AND pl.LastName = sa.LastName
		AND sa.EndDate IS NULL;
	
	-- Create new records
	INSERT INTO dbo.Salesperson_Preload /* Column list excluded for brevity */
	SELECT NEXT VALUE FOR dbo.SalespersonID AS SalespersonID,
		stg.FirstName,
		stg.LastName,
		stg.Territory,
		stg.CommissionPct,
		stg.SalesQuota,
		stg.EmailAddress,
		stg.PhoneNumber,
		@StartDate,
		NULL
	FROM dbo.Salesperson_Stage stg
	WHERE NOT EXISTS ( SELECT 1 FROM dbo.DimSalesperson sa WHERE stg.FirstName = sa.FirstName AND stg.LastName = sa.LastName );

	-- Expire missing records
	INSERT INTO dbo.Salesperson_Preload /* Column list excluded for brevity */
	SELECT sa.SalespersonID,
		sa.FirstName,
		sa.LastName,
		sa.Territory,
		sa.CommissionPct,
			sa.SalesQuota,
		sa.EmailAddress,
		sa.PhoneNumber,
		sa.StartDate,
		@EndDate
	FROM dbo.DimSalesperson sa
	WHERE NOT EXISTS ( SELECT 1 FROM dbo.Salesperson_Stage stg WHERE stg.FirstName = sa.FirstName AND stg.LastName = sa.LastName )
		AND sa.EndDate IS NULL;
	COMMIT TRANSACTION;
END;
GO
-- Promotion
CREATE PROCEDURE dbo.Promotion_Transform
    @StartDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    TRUNCATE TABLE dbo.Promotion_Preload;

    DECLARE @EndDate DATE = DATEADD(dd, -1, @StartDate);

    BEGIN TRANSACTION;

    -- ADD UPDATED RECORDS
    INSERT INTO dbo.Promotion_Preload (
        PromotionID,
        PromotionName,
        PromotionType,
        PromotionStartDate,
        PromotionEndDate,
        DiscountPct,
        MinQuantity,
        MaxQuantity,
        StartDate,
        EndDate
    )
    SELECT
        cu.PromotionID,
        stg.PromotionName,
        stg.PromotionType,
        stg.PromotionStartDate,
        stg.PromotionEndDate,
        stg.DiscountPct,
        stg.MinQuantity,
        stg.MaxQuantity,
        @StartDate,
        NULL
    FROM
        dbo.Promotion_Stage stg
        JOIN dbo.DimPromotion cu ON stg.PromotionName = cu.PromotionName AND cu.EndDate IS NULL
    WHERE
        stg.PromotionType <> cu.PromotionType
        OR stg.PromotionStartDate <> cu.PromotionStartDate
        OR stg.PromotionEndDate <> cu.PromotionEndDate
        OR stg.DiscountPct <> cu.DiscountPct
        OR stg.MinQuantity <> cu.MinQuantity
        OR stg.MaxQuantity <> cu.MaxQuantity;

    -- ADD EXISTING RECORDS, AND EXPIRE AS NECESSARY
    INSERT INTO dbo.Promotion_Preload (
        PromotionID,
        PromotionName,
        PromotionType,
        PromotionStartDate,
        PromotionEndDate,
        DiscountPct,
        MinQuantity,
        MaxQuantity,
        StartDate,
        EndDate
    )
    SELECT
        cu.PromotionID,
        cu.PromotionName,
        cu.PromotionType,
        cu.PromotionStartDate,
        cu.PromotionEndDate,
        cu.DiscountPct,
        cu.MinQuantity,
        cu.MaxQuantity,
        cu.StartDate,
        CASE WHEN pl.PromotionName IS NULL THEN NULL ELSE @EndDate END AS EndDate
    FROM
        dbo.DimPromotion cu
        LEFT JOIN dbo.Promotion_Preload pl ON pl.PromotionName = cu.PromotionName AND cu.EndDate IS NULL;

    -- CREATE NEW RECORDS
    INSERT INTO dbo.Promotion_Preload (
        PromotionID,
        PromotionName,
        PromotionType,
        PromotionStartDate,
        PromotionEndDate,
        DiscountPct,
        MinQuantity,
        MaxQuantity,
        StartDate,
        EndDate
    )
    SELECT
        NEXT VALUE FOR dbo.PromotionID AS PromotionID,
        stg.PromotionName,
        stg.PromotionType,
        stg.PromotionStartDate,
        stg.PromotionEndDate,
        stg.DiscountPct,
        stg.MinQuantity,
        stg.MaxQuantity,
        @StartDate,
        NULL
    FROM
        dbo.Promotion_Stage stg
    WHERE
        NOT EXISTS (
            SELECT 1 FROM dbo.DimPromotion cu WHERE stg.PromotionName = cu.PromotionName
        );

    -- EXPIRE MISSING RECORDS
    INSERT INTO dbo.Promotion_Preload (
        PromotionID,
        PromotionName,
        PromotionType,
        PromotionStartDate,
        PromotionEndDate,
        DiscountPct,
        MinQuantity,
        MaxQuantity,
        StartDate,
        EndDate
    )
    SELECT
        cu.PromotionID,
        cu.PromotionName,
        cu.PromotionType,
        cu.PromotionStartDate,
        cu.PromotionEndDate,
        cu.DiscountPct,
        cu.MinQuantity,
        cu.MaxQuantity,
        cu.StartDate,
        @EndDate
    FROM
        dbo.DimPromotion cu
    WHERE
        NOT EXISTS (
            SELECT 1 FROM dbo.Promotion_Stage stg WHERE stg.PromotionName = cu.PromotionName
        )
        AND cu.EndDate IS NULL;

    COMMIT TRANSACTION;
END;
GO
-- Fact
CREATE PROCEDURE dbo.Sales_Transform
AS
BEGIN;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    TRUNCATE TABLE dbo.Sales_Preload;

    INSERT INTO dbo.Sales_Preload (
        ProductID,
        CustomerID,
        DateID,
        SalespersonID,
        PromotionID,
        OrderQuantity,
        UnitPrice,
        Discount,
        LineTotal
    )
    SELECT 
        dp.ProductID,
        cp.CustomerID,
		CAST( YEAR(ss.OrderDate) * 10000 + MONTH(ss.OrderDate) * 100 + DAY(ss.OrderDate) AS INT),
        spp.SalespersonID,
        pp.PromotionID,
        ss.OrderQuantity,
        ss.UnitPrice,
        ss.Discount,
        ss.LineTotal
    FROM dbo.Sales_Stage ss
    JOIN dbo.Products_Preload dp
        ON ss.ProductName = dp.ProductName
    JOIN dbo.Customers_Preload cp
        ON ss.CustomerName = CONCAT(cp.FirstName, ' ', cp.LastName)
    JOIN dbo.Salesperson_Preload spp
        ON ss.SalespersonName = CONCAT(spp.FirstName, ' ', spp.LastName)
    LEFT JOIN dbo.Promotion_Preload pp
        ON ss.PromotionName = pp.PromotionName;
END;
GO
EXECUTE dbo.Products_Transform '2013-01-01';
-- SELECT * FROM Products_Preload;
EXECUTE dbo.Customers_Transform '2013-01-01';
-- SELECT * FROM Customers_Preload;
EXECUTE dbo.Salesperson_Transform '2013-01-01';
-- SELECT * FROM Salesperson_Preload;
EXECUTE dbo.Promotion_Transform '2013-01-01';
-- SELECT * FROM Promotion_Preload;
EXECUTE dbo.Sales_Transform;
-- SELECT * FROM Sales_Preload;
GO
-- Load
-- Products
CREATE PROCEDURE dbo.Products_Load
AS
BEGIN;

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    DELETE dp
    FROM dbo.DimProducts dp
    JOIN dbo.Products_Preload pp
        ON dp.ProductID = pp.ProductID;

    INSERT INTO dbo.DimProducts
    SELECT * 
    FROM dbo.Products_Preload;

    COMMIT TRANSACTION;
END;
GO
-- Customer
CREATE PROCEDURE dbo.Customers_Load
AS
BEGIN;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    
    BEGIN TRANSACTION;
    
    DELETE dc
    FROM dbo.DimCustomers dc
    JOIN dbo.Customers_Preload cp
        ON dc.CustomerID = cp.CustomerID;
    
    INSERT INTO dbo.DimCustomers 
    SELECT * 
    FROM dbo.Customers_Preload;
    
    COMMIT TRANSACTION;
END;
GO
-- Salesperson
CREATE PROCEDURE dbo.Salesperson_Load
AS
BEGIN;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    
    BEGIN TRANSACTION;
    
    DELETE sp
    FROM dbo.DimSalesperson sp
    JOIN dbo.Salesperson_Preload pl
    ON sp.SalespersonID = pl.SalespersonID;
    
    INSERT INTO dbo.DimSalesperson 
    SELECT * 
    FROM dbo.Salesperson_Preload;
    
    COMMIT TRANSACTION;
END;
GO
-- Promotion
CREATE PROCEDURE dbo.Promotion_Load
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    DELETE cu
    FROM dbo.DimPromotion cu
    JOIN dbo.Promotion_Preload pl ON cu.PromotionID = pl.PromotionID;

    INSERT INTO dbo.DimPromotion
    SELECT *
    FROM dbo.Promotion_Preload;

    COMMIT TRANSACTION;
END;
GO
-- Fact

CREATE PROCEDURE dbo.Sales_Load
AS
BEGIN;

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    INSERT INTO dbo.FactSales 
    SELECT  *
    FROM dbo.Sales_Preload sp;

END;
GO
EXECUTE dbo.Products_Load;
-- SELECT * FROM DimProducts;
EXECUTE dbo.Customers_Load;
-- SELECT * FROM DimCustomers;
EXECUTE dbo.Salesperson_Load;
-- SELECT * FROM DimSalesperson;
EXECUTE dbo.Promotion_Load;
-- SELECT * FROM DimPromotion;
EXECUTE dbo.Sales_Load;
SELECT * FROM FactSales;