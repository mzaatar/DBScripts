IF exists ( Select * from sys.databases where name = 'InMemoryOLTPDB')
Drop database InMemoryOLTPDB
GO

CREATE DATABASE InMemoryOLTPDB 
GO

--------------------------------------
-- create database with a memory-optimized filegroup and a container.
ALTER DATABASE InMemoryOLTPDB ADD FILEGROUP InMemoryOLTPDB_mod CONTAINS MEMORY_OPTIMIZED_DATA 
ALTER DATABASE InMemoryOLTPDB ADD FILE (name='InMemoryOLTPDB_mod1', filename='C:\DBs\New folder\InMemoryOLTPDB_mod1') TO FILEGROUP InMemoryOLTPDB_mod 
ALTER DATABASE InMemoryOLTPDB SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT=ON
GO

USE InMemoryOLTPDB
GO



-- create a durable (data will be persisted) memory-optimized table
-- two of the columns are indexed
  CREATE TABLE dbo.ShoppingCart ( 
    ShoppingCartId INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
    UserId int NOT NULL, 
    CreatedDate DATETIME2 NOT NULL, 
    TotalPrice MONEY
    ) WITH (MEMORY_OPTIMIZED=ON) 
  GO


   -- create a non-durable table. Data will not be persisted, data loss if the server turns off unexpectedly
 CREATE TABLE dbo.UserSession ( 
   SessionId INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED, 
   UserId int NOT NULL, 
   CreatedDate DATETIME2 NOT NULL,
   ShoppingCartId INT
 ) 
 WITH (MEMORY_OPTIMIZED=ON, DURABILITY=SCHEMA_ONLY) 
 GO


 -- insert data into the tables
INSERT dbo.UserSession VALUES (77, SYSDATETIME(), 4) 
INSERT dbo.UserSession VALUES (65, SYSDATETIME(), NULL) 
INSERT dbo.UserSession VALUES (8798, SYSDATETIME(), 1) 
INSERT dbo.UserSession VALUES (80, SYSDATETIME(), NULL) 
INSERT dbo.UserSession VALUES (4321, SYSDATETIME(), NULL) 
INSERT dbo.UserSession VALUES (8578, SYSDATETIME(), NULL) 

INSERT dbo.ShoppingCart VALUES (8798, SYSDATETIME(), NULL) 
INSERT dbo.ShoppingCart VALUES (23, SYSDATETIME(), 45.4) 
INSERT dbo.ShoppingCart VALUES (80, SYSDATETIME(), NULL) 
INSERT dbo.ShoppingCart VALUES (342, SYSDATETIME(), 65.4) 
GO


-- verify table contents 
  SELECT * FROM dbo.UserSession 
  SELECT * FROM dbo.ShoppingCart 
  GO


-- in an explicit transaction, assign a cart to a session and update the total price. 
-- SELECT/UPDATE/DELETE statements in explicit transactions 
  BEGIN TRAN 
   UPDATE dbo.UserSession SET ShoppingCartId=3 WHERE SessionId=4 
   UPDATE dbo.ShoppingCart SET TotalPrice=65.84 WHERE ShoppingCartId=3 
 COMMIT 
 GO 

 -- verify table contents 
 SELECT * 
 FROM dbo.UserSession u JOIN dbo.ShoppingCart s on u.ShoppingCartId=s.ShoppingCartId 
 WHERE u.SessionId=4 
 GO



 --- SP

 -- natively compiled stored procedure for inserting a large number of rows 
-- this demonstrates the performance of native procs 
 CREATE PROCEDURE dbo.usp_InsertSampleCarts @InsertCount int 
 WITH NATIVE_COMPILATION, SCHEMABINDING 
 AS 
 BEGIN ATOMIC 
 WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = N'us_english')

  DECLARE @i int = 0

  WHILE @i < @InsertCount 
  BEGIN 
    INSERT INTO dbo.ShoppingCart VALUES (1, SYSDATETIME() , NULL) 
	--Print 'Insert Row # ' + CAST(@i as varchar)
    SET @i += 1 
  END

END 
GO


-- insert 1,000,000 rows 
 EXEC usp_InsertSampleCarts 1000000 
 GO


 DROP Database InMemoryOLTPDB
 GO