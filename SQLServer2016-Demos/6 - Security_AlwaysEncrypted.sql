-- DB
Use AdventureWorks2014
GO

-- Table
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ManagerSalaries')
Drop table ManagerSalaries
GO

-- create Table
Create table ManagerSalaries
(
Id varchar(128) not null,
Name varchar(128),
Amount decimal(10,0) 
);


insert into ManagerSalaries values
(NEWID(), 'Sally' , 124000.5),
(NEWID(), 'Micheal' , 400000.0),
(NEWID(), 'Sam' , 80000.1);
GO

-- plain data
Select * from ManagerSalaries

-- wizard : activate encrypt columns in DB

-- create master key !

-- select 
Select * from ManagerSalaries


drop table ManagerSalaries