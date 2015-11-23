USE AdventureWorks2014
GO

SET NOCOUNT ON
GO

-- Drop everything
IF exists ( Select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'MySalesOrderDetail_Row')
Drop table MySalesOrderDetail_Row
GO
IF exists ( Select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'MySalesOrderDetail_Column')
Drop table MySalesOrderDetail_Column
GO

---- turn off statistics
--SET STATISTICS IO OFF
--GO
--SET STATISTICS TIME OFF
--GO


print '---------------- Creating tables ----------------'

-- Create New Table
CREATE TABLE [dbo].[MySalesOrderDetail_Row](
[SalesOrderID] [int] NOT NULL,
[SalesOrderDetailID] [int] NOT NULL,
[CarrierTrackingNumber] [nvarchar](25) NULL,
[OrderQty] [smallint] NOT NULL,
[ProductID] [int] NOT NULL,
[SpecialOfferID] [int] NOT NULL,
[UnitPrice] [money] NOT NULL,
[UnitPriceDiscount] [money] NOT NULL,
[LineTotal] [numeric](38, 6) NOT NULL,
[rowguid] [uniqueidentifier] NOT NULL,
[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [PK_MySalesOrderDetail_RS] ON [dbo].[MySalesOrderDetail_Row]
( [SalesOrderDetailID])
GO

--------- create clustered Column store 

CREATE TABLE [dbo].[MySalesOrderDetail_Column](
[SalesOrderID] [int] NOT NULL,
[SalesOrderDetailID] [int] NOT NULL,
[CarrierTrackingNumber] [nvarchar](25) NULL,
[OrderQty] [smallint] NOT NULL,
[ProductID] [int] NOT NULL,
[SpecialOfferID] [int] NOT NULL,
[UnitPrice] [money] NOT NULL,
[UnitPriceDiscount] [money] NOT NULL,
[LineTotal] [numeric](38, 6) NOT NULL,
[rowguid] [uniqueidentifier] NOT NULL,
[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

CREATE CLUSTERED COLUMNSTORE INDEX [PK_SalesOrderDetailID_CS] ON [dbo].[MySalesOrderDetail_Column]
GO


-- Create Sample Data Table
print '---------------- Start inserting into row store ----------------'
GO
INSERT INTO [dbo].[MySalesOrderDetail_Row]
SELECT S1.*
FROM Sales.SalesOrderDetail S1
GO 10

print '---------------- END inserting into row store ----------------'
GO

print '---------------- inserting into columnStore ----------------'
GO
INSERT INTO [dbo].[MySalesOrderDetail_Column]
SELECT S1.*
FROM Sales.SalesOrderDetail S1
GO 10


print '---------------- END inserting into column store ----------------'
GO


---- turn off statistics
--SET STATISTICS IO OFF
--GO
--SET STATISTICS TIME OFF
--GO
--SET NOCOUNT OFF
--GO


-- select count
select 'Count rows in Rows table = ' + CONVERT(varchar,count(*)) from [MySalesOrderDetail_Row]
select 'Count rows in Columns table = ' + CONVERT(varchar,count(*)) from [MySalesOrderDetail_Column]