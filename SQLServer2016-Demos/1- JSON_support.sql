--Drop everything

----------------select data as JSON ----------------

if exists (select * From INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CustomersJSON')
	drop table CustomersJSON

create table CustomersJSON
(
Id int primary key,
Name varchar(100) not null,
Mobile varchar(15) not null
);

insert into CustomersJSON
values
(1,'Emad E','0173547282'),
(2,'Bobby L','0456789174'),
(3,'Matt D','04601374527');

select * from CustomersJSON

select top 3* From CustomersJSON
for JSON AUTO 


---------------- Convert JSON to rows and columns ----------------
USE master
declare @json nvarchar(500)
SET @json = N'{
    "info":{  
      "type":1,
      "address":{  
        "town":"Bristol",
        "county":"Avon",
        "country":"England"
      },
      "tags":["Sport", "Water polo"]
   },
   "type":"Basic"
}'

SELECT * FROM OPENJSON(@json, N'lax $.info')


----------------  another example fro loading JSON ----------------
DECLARE @JSalestOrderDetails nvarchar(2000) 
set @JSalestOrderDetails = '{"OrdersArray": [
{"Number":1, "Date": "8/10/2014", "Customer": "Mohamed", "Quantity": 1200},
{"Number":4, "Date": "5/11/2015", "Customer": "Rob", "Quantity": 100},
{"Number":6, "Date": "1/3/2013", "Customer": "Matt", "Quantity": 250},
{"Number":8, "Date": "12/7/2010", "Customer": "Dennis", "Quantity": 22400}
]}';

SELECT Number, Customer, [Date], Quantity
FROM OPENJSON (@JSalestOrderDetails, '$.OrdersArray')
WITH (
	Number varchar(200),
    Date datetime,
    Customer varchar(200),
    Quantity int
) AS OrdersArray

---------------- Querying JSON ----------------
DECLARE @JSalestOrderDetails2 nvarchar(2000) 
set @JSalestOrderDetails2 = '{"OrdersArray": [
{"Number":1, "Date": "8/10/2014", "Customer": "Mohamed", "Quantity": 1200},
{"Number":4, "Date": "5/11/2015", "Customer": "Rob", "Quantity": 100},
{"Number":6, "Date": "1/3/2013", "Customer": "Matt", "Quantity": 250},
{"Number":8, "Date": "12/7/2010", "Customer": "Dennis", "Quantity": 22400}
]}';

declare @customer3 nvarchar(500) 
SET @customer3 = JSON_VALUE(@JSalestOrderDetails2, '$.OrdersArray[2].Customer')
select @customer3



---------------- validate JSON ----------------
if exists (select * From INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CustomerDetailsJSON')
	drop table CustomerDetailsJSON

create table CustomerDetailsJSON
(
Id int primary key,
DetailsJson varchar(1000) not null
);

insert into CustomerDetailsJSON 
values
(1,'{"Name":"Moahemd Zaatar", "DoB": "17/7/1984", "Address": "South Perth"}'),
(2,'{"Name":"Martin Leech", "DoB": "11/2/1980", "Address": "Wembley"}'),
(3,'{"Name":"Gian L", "DoB": "25/3/1981", "Address": "Leederville"');

--return 3 rows 
select * from CustomerDetailsJSON

-- return Only 2 rows // missing "}" for Gian Record !
SELECT id, DetailsJson
FROM CustomerDetailsJSON
WHERE ISJSON(DetailsJson) > 0

