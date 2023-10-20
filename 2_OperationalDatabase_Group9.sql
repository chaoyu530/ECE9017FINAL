USE [AdventureWorks2017]
GO

/****** Object:  Table [Sales].[SpecialOffer]    Script Date: 2023/4/21 11:29:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [Person].[PersonPhone](
	[BusinessEntityID] [int] NOT NULL,
	[PhoneNumber] [dbo].[Phone] NOT NULL,
	[PhoneNumberTypeID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID] PRIMARY KEY CLUSTERED 
(
	[BusinessEntityID] ASC,
	[PhoneNumber] ASC,
	[PhoneNumberTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Person].[PersonPhone] ADD  CONSTRAINT [DF_PersonPhone_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Person].[PersonPhone]  WITH CHECK ADD  CONSTRAINT [FK_PersonPhone_Person_BusinessEntityID] FOREIGN KEY([BusinessEntityID])
REFERENCES [Person].[Person] ([BusinessEntityID])
GO

ALTER TABLE [Person].[PersonPhone] CHECK CONSTRAINT [FK_PersonPhone_Person_BusinessEntityID]
GO

ALTER TABLE [Person].[PersonPhone]  WITH CHECK ADD  CONSTRAINT [FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID] FOREIGN KEY([PhoneNumberTypeID])
REFERENCES [Person].[PhoneNumberType] ([PhoneNumberTypeID])
GO

ALTER TABLE [Person].[PersonPhone] CHECK CONSTRAINT [FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID]
GO


CREATE TABLE [Person].[BusinessEntityAddress](
	[BusinessEntityID] [int] NOT NULL,
	[AddressID] [int] NOT NULL,
	[AddressTypeID] [int] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressTypeID] PRIMARY KEY CLUSTERED 
(
	[BusinessEntityID] ASC,
	[AddressID] ASC,
	[AddressTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Person].[BusinessEntityAddress] ADD  CONSTRAINT [DF_BusinessEntityAddress_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Person].[BusinessEntityAddress] ADD  CONSTRAINT [DF_BusinessEntityAddress_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Person].[BusinessEntityAddress]  WITH CHECK ADD  CONSTRAINT [FK_BusinessEntityAddress_Address_AddressID] FOREIGN KEY([AddressID])
REFERENCES [Person].[Address] ([AddressID])
GO

ALTER TABLE [Person].[BusinessEntityAddress] CHECK CONSTRAINT [FK_BusinessEntityAddress_Address_AddressID]
GO

ALTER TABLE [Person].[BusinessEntityAddress]  WITH CHECK ADD  CONSTRAINT [FK_BusinessEntityAddress_AddressType_AddressTypeID] FOREIGN KEY([AddressTypeID])
REFERENCES [Person].[AddressType] ([AddressTypeID])
GO

ALTER TABLE [Person].[BusinessEntityAddress] CHECK CONSTRAINT [FK_BusinessEntityAddress_AddressType_AddressTypeID]
GO

ALTER TABLE [Person].[BusinessEntityAddress]  WITH CHECK ADD  CONSTRAINT [FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID] FOREIGN KEY([BusinessEntityID])
REFERENCES [Person].[BusinessEntity] ([BusinessEntityID])
GO

ALTER TABLE [Person].[BusinessEntityAddress] CHECK CONSTRAINT [FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID]
GO


CREATE TABLE [Person].[EmailAddress](
	[BusinessEntityID] [int] NOT NULL,
	[EmailAddressID] [int] IDENTITY(1,1) NOT NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EmailAddress_BusinessEntityID_EmailAddressID] PRIMARY KEY CLUSTERED 
(
	[BusinessEntityID] ASC,
	[EmailAddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Person].[EmailAddress] ADD  CONSTRAINT [DF_EmailAddress_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Person].[EmailAddress] ADD  CONSTRAINT [DF_EmailAddress_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Person].[EmailAddress]  WITH CHECK ADD  CONSTRAINT [FK_EmailAddress_Person_BusinessEntityID] FOREIGN KEY([BusinessEntityID])
REFERENCES [Person].[Person] ([BusinessEntityID])
GO

ALTER TABLE [Person].[EmailAddress] CHECK CONSTRAINT [FK_EmailAddress_Person_BusinessEntityID]
GO

CREATE TABLE [Person].[Address](
	[AddressID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AddressLine1] [nvarchar](60) NOT NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[City] [nvarchar](30) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[PostalCode] [nvarchar](15) NOT NULL,
	[SpatialLocation] [geography] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Address_AddressID] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Person].[Address] ADD  CONSTRAINT [DF_Address_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Person].[Address] ADD  CONSTRAINT [DF_Address_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Person].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_StateProvince_StateProvinceID] FOREIGN KEY([StateProvinceID])
REFERENCES [Person].[StateProvince] ([StateProvinceID])
GO

ALTER TABLE [Person].[Address] CHECK CONSTRAINT [FK_Address_StateProvince_StateProvinceID]
GO

CREATE TABLE [Person].[StateProvince](
	[StateProvinceID] [int] IDENTITY(1,1) NOT NULL,
	[StateProvinceCode] [nchar](3) NOT NULL,
	[CountryRegionCode] [nvarchar](3) NOT NULL,
	[IsOnlyStateProvinceFlag] [dbo].[Flag] NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[TerritoryID] [int] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_StateProvince_StateProvinceID] PRIMARY KEY CLUSTERED 
(
	[StateProvinceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Person].[StateProvince] ADD  CONSTRAINT [DF_StateProvince_IsOnlyStateProvinceFlag]  DEFAULT ((1)) FOR [IsOnlyStateProvinceFlag]
GO

ALTER TABLE [Person].[StateProvince] ADD  CONSTRAINT [DF_StateProvince_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Person].[StateProvince] ADD  CONSTRAINT [DF_StateProvince_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Person].[StateProvince]  WITH CHECK ADD  CONSTRAINT [FK_StateProvince_CountryRegion_CountryRegionCode] FOREIGN KEY([CountryRegionCode])
REFERENCES [Person].[CountryRegion] ([CountryRegionCode])
GO

ALTER TABLE [Person].[StateProvince] CHECK CONSTRAINT [FK_StateProvince_CountryRegion_CountryRegionCode]
GO

ALTER TABLE [Person].[StateProvince]  WITH CHECK ADD  CONSTRAINT [FK_StateProvince_SalesTerritory_TerritoryID] FOREIGN KEY([TerritoryID])
REFERENCES [Sales].[SalesTerritory] ([TerritoryID])
GO

ALTER TABLE [Person].[StateProvince] CHECK CONSTRAINT [FK_StateProvince_SalesTerritory_TerritoryID]
GO

CREATE TABLE [Person].[CountryRegion](
	[CountryRegionCode] [nvarchar](3) NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CountryRegion_CountryRegionCode] PRIMARY KEY CLUSTERED 
(
	[CountryRegionCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Person].[CountryRegion] ADD  CONSTRAINT [DF_CountryRegion_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

CREATE TABLE [Person].[Person](
	[BusinessEntityID] [int] NOT NULL,
	[PersonType] [nchar](2) NOT NULL,
	[NameStyle] [dbo].[NameStyle] NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [dbo].[Name] NOT NULL,
	[MiddleName] [dbo].[Name] NULL,
	[LastName] [dbo].[Name] NOT NULL,
	[Suffix] [nvarchar](10) NULL,
	[EmailPromotion] [int] NOT NULL,
	[AdditionalContactInfo] [xml](CONTENT [Person].[AdditionalContactInfoSchemaCollection]) NULL,
	[Demographics] [xml](CONTENT [Person].[IndividualSurveySchemaCollection]) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Person_BusinessEntityID] PRIMARY KEY CLUSTERED 
(
	[BusinessEntityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Person].[Person] ADD  CONSTRAINT [DF_Person_NameStyle]  DEFAULT ((0)) FOR [NameStyle]
GO

ALTER TABLE [Person].[Person] ADD  CONSTRAINT [DF_Person_EmailPromotion]  DEFAULT ((0)) FOR [EmailPromotion]
GO

ALTER TABLE [Person].[Person] ADD  CONSTRAINT [DF_Person_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Person].[Person] ADD  CONSTRAINT [DF_Person_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Person].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_BusinessEntity_BusinessEntityID] FOREIGN KEY([BusinessEntityID])
REFERENCES [Person].[BusinessEntity] ([BusinessEntityID])
GO

ALTER TABLE [Person].[Person] CHECK CONSTRAINT [FK_Person_BusinessEntity_BusinessEntityID]
GO

ALTER TABLE [Person].[Person]  WITH CHECK ADD  CONSTRAINT [CK_Person_EmailPromotion] CHECK  (([EmailPromotion]>=(0) AND [EmailPromotion]<=(2)))
GO

ALTER TABLE [Person].[Person] CHECK CONSTRAINT [CK_Person_EmailPromotion]
GO

ALTER TABLE [Person].[Person]  WITH CHECK ADD  CONSTRAINT [CK_Person_PersonType] CHECK  (([PersonType] IS NULL OR (upper([PersonType])='GC' OR upper([PersonType])='SP' OR upper([PersonType])='EM' OR upper([PersonType])='IN' OR upper([PersonType])='VC' OR upper([PersonType])='SC')))
GO

ALTER TABLE [Person].[Person] CHECK CONSTRAINT [CK_Person_PersonType]
GO


CREATE TABLE [Production].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[ProductNumber] [nvarchar](25) NOT NULL,
	[MakeFlag] [dbo].[Flag] NOT NULL,
	[FinishedGoodsFlag] [dbo].[Flag] NOT NULL,
	[Color] [nvarchar](15) NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ReorderPoint] [smallint] NOT NULL,
	[StandardCost] [money] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Weight] [decimal](8, 2) NULL,
	[DaysToManufacture] [int] NOT NULL,
	[ProductLine] [nchar](2) NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDate] [datetime] NULL,
	[DiscontinuedDate] [datetime] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Product_ProductID] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Production].[Product] ADD  CONSTRAINT [DF_Product_MakeFlag]  DEFAULT ((1)) FOR [MakeFlag]
GO

ALTER TABLE [Production].[Product] ADD  CONSTRAINT [DF_Product_FinishedGoodsFlag]  DEFAULT ((1)) FOR [FinishedGoodsFlag]
GO

ALTER TABLE [Production].[Product] ADD  CONSTRAINT [DF_Product_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Production].[Product] ADD  CONSTRAINT [DF_Product_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_ProductModel_ProductModelID] FOREIGN KEY([ProductModelID])
REFERENCES [Production].[ProductModel] ([ProductModelID])
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [FK_Product_ProductModel_ProductModelID]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_ProductSubcategory_ProductSubcategoryID] FOREIGN KEY([ProductSubcategoryID])
REFERENCES [Production].[ProductSubcategory] ([ProductSubcategoryID])
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [FK_Product_ProductSubcategory_ProductSubcategoryID]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_UnitMeasure_SizeUnitMeasureCode] FOREIGN KEY([SizeUnitMeasureCode])
REFERENCES [Production].[UnitMeasure] ([UnitMeasureCode])
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [FK_Product_UnitMeasure_SizeUnitMeasureCode]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_UnitMeasure_WeightUnitMeasureCode] FOREIGN KEY([WeightUnitMeasureCode])
REFERENCES [Production].[UnitMeasure] ([UnitMeasureCode])
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [FK_Product_UnitMeasure_WeightUnitMeasureCode]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [CK_Product_Class] CHECK  ((upper([Class])='H' OR upper([Class])='M' OR upper([Class])='L' OR [Class] IS NULL))
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [CK_Product_Class]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [CK_Product_DaysToManufacture] CHECK  (([DaysToManufacture]>=(0)))
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [CK_Product_DaysToManufacture]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [CK_Product_ListPrice] CHECK  (([ListPrice]>=(0.00)))
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [CK_Product_ListPrice]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [CK_Product_ProductLine] CHECK  ((upper([ProductLine])='R' OR upper([ProductLine])='M' OR upper([ProductLine])='T' OR upper([ProductLine])='S' OR [ProductLine] IS NULL))
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [CK_Product_ProductLine]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [CK_Product_ReorderPoint] CHECK  (([ReorderPoint]>(0)))
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [CK_Product_ReorderPoint]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [CK_Product_SafetyStockLevel] CHECK  (([SafetyStockLevel]>(0)))
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [CK_Product_SafetyStockLevel]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [CK_Product_SellEndDate] CHECK  (([SellEndDate]>=[SellStartDate] OR [SellEndDate] IS NULL))
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [CK_Product_SellEndDate]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [CK_Product_StandardCost] CHECK  (([StandardCost]>=(0.00)))
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [CK_Product_StandardCost]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [CK_Product_Style] CHECK  ((upper([Style])='U' OR upper([Style])='M' OR upper([Style])='W' OR [Style] IS NULL))
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [CK_Product_Style]
GO

ALTER TABLE [Production].[Product]  WITH CHECK ADD  CONSTRAINT [CK_Product_Weight] CHECK  (([Weight]>(0.00)))
GO

ALTER TABLE [Production].[Product] CHECK CONSTRAINT [CK_Product_Weight]
GO


CREATE TABLE [Production].[ProductCategory](
	[ProductCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProductCategory_ProductCategoryID] PRIMARY KEY CLUSTERED 
(
	[ProductCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Production].[ProductCategory] ADD  CONSTRAINT [DF_ProductCategory_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Production].[ProductCategory] ADD  CONSTRAINT [DF_ProductCategory_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

CREATE TABLE [Production].[ProductSubcategory](
	[ProductSubcategoryID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCategoryID] [int] NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProductSubcategory_ProductSubcategoryID] PRIMARY KEY CLUSTERED 
(
	[ProductSubcategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Production].[ProductSubcategory] ADD  CONSTRAINT [DF_ProductSubcategory_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Production].[ProductSubcategory] ADD  CONSTRAINT [DF_ProductSubcategory_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Production].[ProductSubcategory]  WITH CHECK ADD  CONSTRAINT [FK_ProductSubcategory_ProductCategory_ProductCategoryID] FOREIGN KEY([ProductCategoryID])
REFERENCES [Production].[ProductCategory] ([ProductCategoryID])
GO

ALTER TABLE [Production].[ProductSubcategory] CHECK CONSTRAINT [FK_ProductSubcategory_ProductCategory_ProductCategoryID]
GO

CREATE TABLE [Sales].[Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PersonID] [int] NULL,
	[StoreID] [int] NULL,
	[TerritoryID] [int] NULL,
	[AccountNumber]  AS (isnull('AW'+[dbo].[ufnLeadingZeros]([CustomerID]),'')),
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Sales].[Customer] ADD  CONSTRAINT [DF_Customer_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Sales].[Customer] ADD  CONSTRAINT [DF_Customer_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Sales].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Person_PersonID] FOREIGN KEY([PersonID])
REFERENCES [Person].[Person] ([BusinessEntityID])
GO

ALTER TABLE [Sales].[Customer] CHECK CONSTRAINT [FK_Customer_Person_PersonID]
GO

ALTER TABLE [Sales].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_SalesTerritory_TerritoryID] FOREIGN KEY([TerritoryID])
REFERENCES [Sales].[SalesTerritory] ([TerritoryID])
GO

ALTER TABLE [Sales].[Customer] CHECK CONSTRAINT [FK_Customer_SalesTerritory_TerritoryID]
GO

ALTER TABLE [Sales].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Store_StoreID] FOREIGN KEY([StoreID])
REFERENCES [Sales].[Store] ([BusinessEntityID])
GO

ALTER TABLE [Sales].[Customer] CHECK CONSTRAINT [FK_Customer_Store_StoreID]
GO


CREATE TABLE [Sales].[SalesOrderHeader](
	[SalesOrderID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[OnlineOrderFlag] [dbo].[Flag] NOT NULL,
	[SalesOrderNumber]  AS (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID]),N'*** ERROR ***')),
	[PurchaseOrderNumber] [dbo].[OrderNumber] NULL,
	[AccountNumber] [dbo].[AccountNumber] NULL,
	[CustomerID] [int] NOT NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int] NOT NULL,
	[ShipToAddressID] [int] NOT NULL,
	[ShipMethodID] [int] NOT NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[CurrencyRateID] [int] NULL,
	[SubTotal] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[TotalDue]  AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))),
	[Comment] [nvarchar](128) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SalesOrderHeader_SalesOrderID] PRIMARY KEY CLUSTERED 
(
	[SalesOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Sales].[SalesOrderHeader] ADD  CONSTRAINT [DF_SalesOrderHeader_RevisionNumber]  DEFAULT ((0)) FOR [RevisionNumber]
GO

ALTER TABLE [Sales].[SalesOrderHeader] ADD  CONSTRAINT [DF_SalesOrderHeader_OrderDate]  DEFAULT (getdate()) FOR [OrderDate]
GO

ALTER TABLE [Sales].[SalesOrderHeader] ADD  CONSTRAINT [DF_SalesOrderHeader_Status]  DEFAULT ((1)) FOR [Status]
GO

ALTER TABLE [Sales].[SalesOrderHeader] ADD  CONSTRAINT [DF_SalesOrderHeader_OnlineOrderFlag]  DEFAULT ((1)) FOR [OnlineOrderFlag]
GO

ALTER TABLE [Sales].[SalesOrderHeader] ADD  CONSTRAINT [DF_SalesOrderHeader_SubTotal]  DEFAULT ((0.00)) FOR [SubTotal]
GO

ALTER TABLE [Sales].[SalesOrderHeader] ADD  CONSTRAINT [DF_SalesOrderHeader_TaxAmt]  DEFAULT ((0.00)) FOR [TaxAmt]
GO

ALTER TABLE [Sales].[SalesOrderHeader] ADD  CONSTRAINT [DF_SalesOrderHeader_Freight]  DEFAULT ((0.00)) FOR [Freight]
GO

ALTER TABLE [Sales].[SalesOrderHeader] ADD  CONSTRAINT [DF_SalesOrderHeader_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Sales].[SalesOrderHeader] ADD  CONSTRAINT [DF_SalesOrderHeader_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [FK_SalesOrderHeader_Address_BillToAddressID] FOREIGN KEY([BillToAddressID])
REFERENCES [Person].[Address] ([AddressID])
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [FK_SalesOrderHeader_Address_BillToAddressID]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [FK_SalesOrderHeader_Address_ShipToAddressID] FOREIGN KEY([ShipToAddressID])
REFERENCES [Person].[Address] ([AddressID])
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [FK_SalesOrderHeader_Address_ShipToAddressID]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [FK_SalesOrderHeader_CreditCard_CreditCardID] FOREIGN KEY([CreditCardID])
REFERENCES [Sales].[CreditCard] ([CreditCardID])
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [FK_SalesOrderHeader_CreditCard_CreditCardID]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [FK_SalesOrderHeader_CurrencyRate_CurrencyRateID] FOREIGN KEY([CurrencyRateID])
REFERENCES [Sales].[CurrencyRate] ([CurrencyRateID])
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [FK_SalesOrderHeader_CurrencyRate_CurrencyRateID]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [FK_SalesOrderHeader_Customer_CustomerID] FOREIGN KEY([CustomerID])
REFERENCES [Sales].[Customer] ([CustomerID])
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [FK_SalesOrderHeader_Customer_CustomerID]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [FK_SalesOrderHeader_SalesPerson_SalesPersonID] FOREIGN KEY([SalesPersonID])
REFERENCES [Sales].[SalesPerson] ([BusinessEntityID])
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [FK_SalesOrderHeader_SalesPerson_SalesPersonID]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [FK_SalesOrderHeader_SalesTerritory_TerritoryID] FOREIGN KEY([TerritoryID])
REFERENCES [Sales].[SalesTerritory] ([TerritoryID])
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [FK_SalesOrderHeader_SalesTerritory_TerritoryID]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [FK_SalesOrderHeader_ShipMethod_ShipMethodID] FOREIGN KEY([ShipMethodID])
REFERENCES [Purchasing].[ShipMethod] ([ShipMethodID])
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [FK_SalesOrderHeader_ShipMethod_ShipMethodID]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [CK_SalesOrderHeader_DueDate] CHECK  (([DueDate]>=[OrderDate]))
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [CK_SalesOrderHeader_DueDate]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [CK_SalesOrderHeader_Freight] CHECK  (([Freight]>=(0.00)))
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [CK_SalesOrderHeader_Freight]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [CK_SalesOrderHeader_ShipDate] CHECK  (([ShipDate]>=[OrderDate] OR [ShipDate] IS NULL))
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [CK_SalesOrderHeader_ShipDate]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [CK_SalesOrderHeader_Status] CHECK  (([Status]>=(0) AND [Status]<=(8)))
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [CK_SalesOrderHeader_Status]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [CK_SalesOrderHeader_SubTotal] CHECK  (([SubTotal]>=(0.00)))
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [CK_SalesOrderHeader_SubTotal]
GO

ALTER TABLE [Sales].[SalesOrderHeader]  WITH CHECK ADD  CONSTRAINT [CK_SalesOrderHeader_TaxAmt] CHECK  (([TaxAmt]>=(0.00)))
GO

ALTER TABLE [Sales].[SalesOrderHeader] CHECK CONSTRAINT [CK_SalesOrderHeader_TaxAmt]
GO


CREATE TABLE [Sales].[SalesOrderDetail](
	[SalesOrderID] [int] NOT NULL,
	[SalesOrderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[OrderQty] [smallint] NOT NULL,
	[ProductID] [int] NOT NULL,
	[SpecialOfferID] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[UnitPriceDiscount] [money] NOT NULL,
	[LineTotal]  AS (isnull(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0))),
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID] PRIMARY KEY CLUSTERED 
(
	[SalesOrderID] ASC,
	[SalesOrderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Sales].[SalesOrderDetail] ADD  CONSTRAINT [DF_SalesOrderDetail_UnitPriceDiscount]  DEFAULT ((0.0)) FOR [UnitPriceDiscount]
GO

ALTER TABLE [Sales].[SalesOrderDetail] ADD  CONSTRAINT [DF_SalesOrderDetail_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Sales].[SalesOrderDetail] ADD  CONSTRAINT [DF_SalesOrderDetail_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Sales].[SalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID] FOREIGN KEY([SalesOrderID])
REFERENCES [Sales].[SalesOrderHeader] ([SalesOrderID])
ON DELETE CASCADE
GO

ALTER TABLE [Sales].[SalesOrderDetail] CHECK CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID]
GO

ALTER TABLE [Sales].[SalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID] FOREIGN KEY([SpecialOfferID], [ProductID])
REFERENCES [Sales].[SpecialOfferProduct] ([SpecialOfferID], [ProductID])
GO

ALTER TABLE [Sales].[SalesOrderDetail] CHECK CONSTRAINT [FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID]
GO

ALTER TABLE [Sales].[SalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [CK_SalesOrderDetail_OrderQty] CHECK  (([OrderQty]>(0)))
GO

ALTER TABLE [Sales].[SalesOrderDetail] CHECK CONSTRAINT [CK_SalesOrderDetail_OrderQty]
GO

ALTER TABLE [Sales].[SalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [CK_SalesOrderDetail_UnitPrice] CHECK  (([UnitPrice]>=(0.00)))
GO

ALTER TABLE [Sales].[SalesOrderDetail] CHECK CONSTRAINT [CK_SalesOrderDetail_UnitPrice]
GO

ALTER TABLE [Sales].[SalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [CK_SalesOrderDetail_UnitPriceDiscount] CHECK  (([UnitPriceDiscount]>=(0.00)))
GO

ALTER TABLE [Sales].[SalesOrderDetail] CHECK CONSTRAINT [CK_SalesOrderDetail_UnitPriceDiscount]
GO


CREATE TABLE [Sales].[SalesPerson](
	[BusinessEntityID] [int] NOT NULL,
	[TerritoryID] [int] NULL,
	[SalesQuota] [money] NULL,
	[Bonus] [money] NOT NULL,
	[CommissionPct] [smallmoney] NOT NULL,
	[SalesYTD] [money] NOT NULL,
	[SalesLastYear] [money] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SalesPerson_BusinessEntityID] PRIMARY KEY CLUSTERED 
(
	[BusinessEntityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Sales].[SalesPerson] ADD  CONSTRAINT [DF_SalesPerson_Bonus]  DEFAULT ((0.00)) FOR [Bonus]
GO

ALTER TABLE [Sales].[SalesPerson] ADD  CONSTRAINT [DF_SalesPerson_CommissionPct]  DEFAULT ((0.00)) FOR [CommissionPct]
GO

ALTER TABLE [Sales].[SalesPerson] ADD  CONSTRAINT [DF_SalesPerson_SalesYTD]  DEFAULT ((0.00)) FOR [SalesYTD]
GO

ALTER TABLE [Sales].[SalesPerson] ADD  CONSTRAINT [DF_SalesPerson_SalesLastYear]  DEFAULT ((0.00)) FOR [SalesLastYear]
GO

ALTER TABLE [Sales].[SalesPerson] ADD  CONSTRAINT [DF_SalesPerson_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Sales].[SalesPerson] ADD  CONSTRAINT [DF_SalesPerson_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Sales].[SalesPerson]  WITH CHECK ADD  CONSTRAINT [FK_SalesPerson_Employee_BusinessEntityID] FOREIGN KEY([BusinessEntityID])
REFERENCES [HumanResources].[Employee] ([BusinessEntityID])
GO

ALTER TABLE [Sales].[SalesPerson] CHECK CONSTRAINT [FK_SalesPerson_Employee_BusinessEntityID]
GO

ALTER TABLE [Sales].[SalesPerson]  WITH CHECK ADD  CONSTRAINT [FK_SalesPerson_SalesTerritory_TerritoryID] FOREIGN KEY([TerritoryID])
REFERENCES [Sales].[SalesTerritory] ([TerritoryID])
GO

ALTER TABLE [Sales].[SalesPerson] CHECK CONSTRAINT [FK_SalesPerson_SalesTerritory_TerritoryID]
GO

ALTER TABLE [Sales].[SalesPerson]  WITH CHECK ADD  CONSTRAINT [CK_SalesPerson_Bonus] CHECK  (([Bonus]>=(0.00)))
GO

ALTER TABLE [Sales].[SalesPerson] CHECK CONSTRAINT [CK_SalesPerson_Bonus]
GO

ALTER TABLE [Sales].[SalesPerson]  WITH CHECK ADD  CONSTRAINT [CK_SalesPerson_CommissionPct] CHECK  (([CommissionPct]>=(0.00)))
GO

ALTER TABLE [Sales].[SalesPerson] CHECK CONSTRAINT [CK_SalesPerson_CommissionPct]
GO

ALTER TABLE [Sales].[SalesPerson]  WITH CHECK ADD  CONSTRAINT [CK_SalesPerson_SalesLastYear] CHECK  (([SalesLastYear]>=(0.00)))
GO

ALTER TABLE [Sales].[SalesPerson] CHECK CONSTRAINT [CK_SalesPerson_SalesLastYear]
GO

ALTER TABLE [Sales].[SalesPerson]  WITH CHECK ADD  CONSTRAINT [CK_SalesPerson_SalesQuota] CHECK  (([SalesQuota]>(0.00)))
GO

ALTER TABLE [Sales].[SalesPerson] CHECK CONSTRAINT [CK_SalesPerson_SalesQuota]
GO

ALTER TABLE [Sales].[SalesPerson]  WITH CHECK ADD  CONSTRAINT [CK_SalesPerson_SalesYTD] CHECK  (([SalesYTD]>=(0.00)))
GO

ALTER TABLE [Sales].[SalesPerson] CHECK CONSTRAINT [CK_SalesPerson_SalesYTD]
GO


CREATE TABLE [Sales].[SpecialOffer](
	[SpecialOfferID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[DiscountPct] [smallmoney] NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[MinQty] [int] NOT NULL,
	[MaxQty] [int] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SpecialOffer_SpecialOfferID] PRIMARY KEY CLUSTERED 
(
	[SpecialOfferID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Sales].[SpecialOffer] ADD  CONSTRAINT [DF_SpecialOffer_DiscountPct]  DEFAULT ((0.00)) FOR [DiscountPct]
GO

ALTER TABLE [Sales].[SpecialOffer] ADD  CONSTRAINT [DF_SpecialOffer_MinQty]  DEFAULT ((0)) FOR [MinQty]
GO

ALTER TABLE [Sales].[SpecialOffer] ADD  CONSTRAINT [DF_SpecialOffer_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Sales].[SpecialOffer] ADD  CONSTRAINT [DF_SpecialOffer_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Sales].[SpecialOffer]  WITH CHECK ADD  CONSTRAINT [CK_SpecialOffer_DiscountPct] CHECK  (([DiscountPct]>=(0.00)))
GO

ALTER TABLE [Sales].[SpecialOffer] CHECK CONSTRAINT [CK_SpecialOffer_DiscountPct]
GO

ALTER TABLE [Sales].[SpecialOffer]  WITH CHECK ADD  CONSTRAINT [CK_SpecialOffer_EndDate] CHECK  (([EndDate]>=[StartDate]))
GO

ALTER TABLE [Sales].[SpecialOffer] CHECK CONSTRAINT [CK_SpecialOffer_EndDate]
GO

ALTER TABLE [Sales].[SpecialOffer]  WITH CHECK ADD  CONSTRAINT [CK_SpecialOffer_MaxQty] CHECK  (([MaxQty]>=(0)))
GO

ALTER TABLE [Sales].[SpecialOffer] CHECK CONSTRAINT [CK_SpecialOffer_MaxQty]
GO

ALTER TABLE [Sales].[SpecialOffer]  WITH CHECK ADD  CONSTRAINT [CK_SpecialOffer_MinQty] CHECK  (([MinQty]>=(0)))
GO

ALTER TABLE [Sales].[SpecialOffer] CHECK CONSTRAINT [CK_SpecialOffer_MinQty]
GO


CREATE TABLE [Sales].[SpecialOfferProduct](
	[SpecialOfferID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SpecialOfferProduct_SpecialOfferID_ProductID] PRIMARY KEY CLUSTERED 
(
	[SpecialOfferID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Sales].[SpecialOfferProduct] ADD  CONSTRAINT [DF_SpecialOfferProduct_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Sales].[SpecialOfferProduct] ADD  CONSTRAINT [DF_SpecialOfferProduct_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Sales].[SpecialOfferProduct]  WITH CHECK ADD  CONSTRAINT [FK_SpecialOfferProduct_Product_ProductID] FOREIGN KEY([ProductID])
REFERENCES [Production].[Product] ([ProductID])
GO

ALTER TABLE [Sales].[SpecialOfferProduct] CHECK CONSTRAINT [FK_SpecialOfferProduct_Product_ProductID]
GO

ALTER TABLE [Sales].[SpecialOfferProduct]  WITH CHECK ADD  CONSTRAINT [FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID] FOREIGN KEY([SpecialOfferID])
REFERENCES [Sales].[SpecialOffer] ([SpecialOfferID])
GO

ALTER TABLE [Sales].[SpecialOfferProduct] CHECK CONSTRAINT [FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID]
GO
