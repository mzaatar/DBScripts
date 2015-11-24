USe AdventureWorks2014
GO

if exists ( select * from INFORMATION_SCHEMA.tables where table_name = 'SpecialCreditcards')
begin
drop table dbo.SpecialCreditcards
End
CREATE TABLE SpecialCreditcards
	([Id] [int] IDENTITY PRIMARY KEY,
	[Number] [char](16) MASKED WITH (FUNCTION = 'partial(0,"XXXXXXXXXXXX",4)') NULL,
	[ExpirationDate] [date] NOT NULL,
	[CCV] [char](3) MASKED WITH (FUNCTION = 'default()') NULL,
	[CustomerName] [nvarchar](100) NOT NULL);

INSERT into SpecialCreditcards (Number, ExpirationDate, CCV, CustomerName) VALUES 
('4545319826351345', '2018/11/11' , '121', 'Mohamed Zaatar'),
('8712439812534211', '2019/2/2' , '111', 'Cormac Long'),
('2345234523450909', '2020/9/9' , '973', 'Rob Moore')
SELECT * FROM SpecialCreditcards;


--create a new user
If not Exists (select * from sys.database_principals where name = 'CSAgnet')
BEGIN
	CREATE USER CSAgnet WITHOUT LOGIN;
END
GO
GRANT SELECT ON SpecialCreditcards TO CSAgnet;

--see the masked data as the new user
EXECUTE AS USER = 'CSAgnet';
SELECT * FROM SpecialCreditcards;
REVERT;

-- drop table
drop table SpecialCreditcards