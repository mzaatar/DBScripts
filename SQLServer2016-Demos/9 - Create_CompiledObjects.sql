-- Make sure that you created a folder "C:\DBDemo"

-------------------------- delete the folder and run this script !! --------------------------
use master
go
if exists ( select * From sys.databases where name = 'CompiledDB')
Drop database CompiledDB
GO

create database CompiledDB
go
alter database CompiledDB add filegroup CompiledDB_mod contains memory_optimized_data
go
-- adapt filename as needed
alter database CompiledDB add file (name='CompiledDB_mod', filename='C:\DBDemo\CompiledDB_mod') to filegroup CompiledDB_mod
go

-------------------------- use the comipled DB and create table ------------------------
use CompiledDB
go

create table dbo.CompiledTable
   (c1 int not null primary key nonclustered,
    c2 INT)
with (memory_optimized=on)
go

-- retrieve the path of the DLL for table t1
select name, description FROM sys.dm_os_loaded_modules
where name like '%xtp_t_' + cast(db_id() as varchar(10)) + '_' + cast(object_id('dbo.t1') as varchar(10)) + '.dll'
go

SELECT name, description FROM sys.dm_os_loaded_modules
where description = 'XTP Native DLL'

-- insert into that table

declare @counter int 
set @counter = 1000
While @counter > 0
BEGIN
	insert into CompiledTable values (@counter,@counter)
	SET @counter = @counter  -1
END
GO


select count(*) From CompiledTable 
