-- 1- Run this on DB
use master
go 
sp_configure 'remote data archive',1
GO
reconfigure with override 
go

-- 2 - Create DB and Tables 
if NOT exists (select * From sys.databases where name = 'PerthStore')
CREATE DATABASE PerthStore
GO

if exists (select * From INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Customer')
drop table Customer
GO

-- 3 - run advisor (optinal)


-- 4 - Enable stretching on DB
-- Right click on your DB --> Tasks --> Enable Stretch ( Enter Azure subscription and follow the instructions)


-- 5 - Create a DB master key 
USE PerthStore;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'testP@ssw0rd1234';
GO


-- 6 - Now you have the stretching - insert data and watch the sizes using these queries

-- linking between tables
select * from sys.tables where name like '%order%'
select * from sys.remote_data_archive_tables 

--- linking between DB
select * from sys.databases
select * from sys.remote_data_archive_databases

--migration rows
select * from sys.dm_db_rda_migration_status