USE AdventureWorks2014
GO

SET NOCOUNT ON
GO


--print '------------------ complex query with timers ----------------'

Declare @StartTime datetime , @EndTime datetime , @difference datetime

Set @startTime = getdate()

SELECT ProductID, SUM(UnitPrice) SumUnitPrice, AVG(UnitPrice) AvgUnitPrice,
SUM(OrderQty) SumOrderQty, AVG(OrderQty) AvgOrderQty
FROM [dbo].[MySalesOrderDetail_Row]
GROUP BY ProductID
ORDER BY ProductID

Set @EndTime = getdate()
PRint '
---------------- selecting from ROW statement took '+ convert(varchar(10), DATEDIFF(millisecond,@StartTime,@EndTime), 108) + 'ms  ----------------'

--Table 'MySalesOrderDetail_CS_NC'. Scan count 3, logical reads 113588, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

Set @startTime = getdate()

SELECT ProductID, SUM(UnitPrice) SumUnitPrice, AVG(UnitPrice) AvgUnitPrice,
SUM(OrderQty) SumOrderQty, AVG(OrderQty) AvgOrderQty
FROM [dbo].[MySalesOrderDetail_Column]
GROUP BY ProductID
ORDER BY ProductID

Set @EndTime = getdate()
PRint '
---------------- selecting from Column statement took '+ convert(varchar(10), DATEDIFF(millisecond,@StartTime,@EndTime), 108) + 'ms ----------------'


--drop table MySalesOrderDetail_Row
--drop table MySalesOrderDetail_Column


SET NOCOUNT OFF
GO