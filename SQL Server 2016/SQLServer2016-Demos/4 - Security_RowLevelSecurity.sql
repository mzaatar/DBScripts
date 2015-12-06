-- Change DB
use master
go
if exists ( select * From sys.databases where name = 'SecureDB')
	Drop database SecureDB
GO

create database SecureDB
go

--Drop everything
IF exists ( select * From sys.objects where name = 'SalesFilter')
	Drop Security Policy SalesFilter;

IF EXISTS (select * From INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fn_securitypredicate')
	Drop function Security.fn_securitypredicate

-- drop table
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Sales')
	Drop table Sales


IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'Security')
BEGIN
EXEC('Drop SCHEMA Security')
END

--delete users
If Exists (select * from sys.database_principals where name = 'Manager')
BEGIN
	drop USER Manager;
END
If Exists (select * from sys.database_principals where name = 'Sales1')
BEGIN
	drop USER Sales1;
END
If Exists (select * from sys.database_principals where name = 'Sales2')
BEGIN
	Drop USER Sales2;
END
GO

------------------------------------------------------------------------------------

-- create users

CREATE USER Manager WITHOUT LOGIN;
CREATE USER Sales1 WITHOUT LOGIN;
CREATE USER Sales2 WITHOUT LOGIN;

--Create a simple table to hold data.
CREATE TABLE Sales
(
    OrderID int,
    SalesRep sysname,
    Product varchar(10),
    Qty int
);

--Populate the table with 6 rows of data, showing 3 orders for each sales representative.
INSERT Sales VALUES 
(1, 'Sales1', 'Valve', 5), 
(2, 'Sales1', 'Wheel', 2), 
(3, 'Sales1', 'Valve', 4),
(4, 'Sales2', 'Bracket', 2), 
(5, 'Sales2', 'Wheel', 5), 
(6, 'Sales2', 'Seat', 5);

-- View the 6 rows in the table
SELECT * FROM Sales;

--Grant read access on the table to each of the users.
GRANT SELECT ON Sales TO Manager;
GRANT SELECT ON Sales TO Sales1;
GRANT SELECT ON Sales TO Sales2;

-- create schema
EXEC('CREATE SCHEMA Security')
GO

-- create funcion
CREATE FUNCTION Security.fn_securitypredicate(@SalesRep AS sysname)
    RETURNS TABLE
WITH SCHEMABINDING
AS
    RETURN SELECT 1 AS fn_securitypredicate_result 
WHERE @SalesRep = USER_NAME() OR USER_NAME() = 'Manager';
GO

--Create a security policy adding the function as a filter predicate. The state must be set to ON to enable the policy.
CREATE SECURITY POLICY SalesFilter
ADD FILTER PREDICATE Security.fn_securitypredicate(SalesRep) 
ON dbo.Sales
WITH (STATE = ON);
GO

--Now test the filtering predicate, by selected from the Sales table as each user.
EXECUTE AS USER = 'Sales1';
SELECT * FROM Sales; 
REVERT;

EXECUTE AS USER = 'Sales2';
SELECT * FROM Sales; 
REVERT;

EXECUTE AS USER = 'Manager';
SELECT * FROM Sales; 
REVERT;

--The Manager should see all 6 rows. The Sales1 and Sales2 users should only see their own sales.
--Alter the security policy to disable the policy.
ALTER SECURITY POLICY SalesFilter
WITH (STATE = OFF);

--Now the Sales1 and Sales2 users can see all 6 rows.
EXECUTE AS USER = 'Sales1';
SELECT * FROM Sales; 
REVERT;

EXECUTE AS USER = 'Sales2';
SELECT * FROM Sales; 
REVERT;

EXECUTE AS USER = 'Manager';
SELECT * FROM Sales; 
REVERT;

-- drop everything
	Drop database SecureDB