use AdventureWorks2012

--1 --Display the SalesOrderID, ShipDate of the SalesOrderHeader table (Sales schema) 
--  to show SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’
select [Sales].[SalesOrderHeader].SalesOrderID , [Sales].[SalesOrderHeader].ShipDate
from [Sales].[SalesOrderHeader]
where [Sales].[SalesOrderHeader].OrderDate between '7/28/2002' and '7/29/2014';

--2 --Display only Products(Production schema)
--    with a StandardCost below $110.00 (show ProductID, Name only)
select [Production].[ProductCostHistory].ProductID
from [Production].[ProductCostHistory] 
where [Production].[ProductCostHistory].StandardCost < 110.00

--3 --Display ProductID, Name if its weight is unknown
select [Production].[Product].ProductID , [Production].[Product].Name
from [Production].[Product]
where [Production].[Product].Weight is null;

--4 --Display all Products with a Silver, Black, or Red Color
select [Production].[Product].ProductID
from [Production].[Product]
where [Production].[Product].Color in('Silver' , 'Black' , 'Red');

--5 --Display any Product with a Name starting with the letter B
select [Production].[Product].Name
from [Production].[Product]
where [Production].[Product].Name like 'B%';


--6 --Run the following Query
    --UPDATE Production.ProductDescription
    --SET Description = 'Chromoly steel_High of defects'
    --WHERE ProductDescriptionID = 3
update [Production].[ProductDescription]
set [Production].[ProductDescription].Description='Chromoly steel_High of defects'
where [Production].[ProductDescription].ProductDescriptionID=3;
-- Then write a query 
--that displays any Product description with underscore value in its description.
select [Production].[ProductDescription].Description
from [Production].[ProductDescription]
where [Production].[ProductDescription].Description like '%[_]%'


--7 --Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table
--    for the period between  '7/1/2001' and '7/31/2014'
select sum([Sales].[SalesOrderHeader].TotalDue) 
from [Sales].[SalesOrderHeader]
where [Sales].[SalesOrderHeader].OrderDate between  '7/1/2001' and '7/31/2014'
group by [Sales].[SalesOrderHeader].OrderDate;

--8 --Display the Employees HireDate (note no repeated values are allowed)
select distinct [HumanResources].[Employee].HireDate 
from [HumanResources].[Employee];

--9 --Calculate the average of the unique ListPrices in the Product table
select avg(distinct [Production].[Product].ListPrice)
from [Production].[Product];

--10 --Display the Product Name and its ListPrice 
--     within the values of 100 and 120 the list should has 
--     the following format "The [product name] is only! [List price]"
--    (the list will be sorted according to its ListPrice value)
select 'The ' + [Production].[Product].Name + ' is only! ' + convert(varchar(50),[Production].[Product].ListPrice)
from [Production].[Product]
where [Production].[Product].ListPrice between 100 and 120;

--11 --A --Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.Store table  
         --in a newly created table named [store_Archive]
         --Note: Check your database to see the new table and how many rows in it?
select [Sales].[Store].rowguid , [Sales].[Store].SalesPersonID , [Sales].[Store].Demographics
into [Sales].[Store_Archive]
from [Sales].[Store];

--11 --B --Try the previous query but without transferring the data
select [Sales].[Store].rowguid , [Sales].[Store].SalesPersonID , [Sales].[Store].Demographics
into [Sales].[Store_Archive2]
from [Sales].[Store]
where 1=2; --false condition to copy the stucture only

--12 --Using union statement, retrieve the today’s date in different styles 
--   using convert or format funtion.
select convert(smalldatetime , getdate())
union
select convert(datetimeoffset , getdate())

