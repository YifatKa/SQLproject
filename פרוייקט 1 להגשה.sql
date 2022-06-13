use master

Create database sales 

use sales

 
 --טבלה 1  creditcard

create table dbo.creditcard
(creditcardID int 
         constraint creditc_ccID_pk Primary key(creditcardID), 
CardType NVARCHAR (50) 
		 constraint creditc_ct_nn not null,
CardNumber NVARCHAR (25)
		 constraint creditc_cn_nn not null,
ExpMonth tinyint 
		constraint creditc_em_nn not null,
ExpYear smallint
		constraint creditc_ey_nn not null,
ModifiedDate datetime default getdate ())	

select * from sales.dbo.creditcard

begin tran
insert into sales.dbo.creditcard  
select [CreditCardID] , [CardType],
[CardNumber], 
[ExpMonth],
[ExpYear],
[ModifiedDate]
from sales.dbo.creditcard_temp
commit

--טבלה 2   SalesTerritory

create type name from nvarchar(50) 			

create table dbo.SalesTerritory
(TerritoryID int 
         constraint salest_ttID_pk Primary key(TerritoryID),   
NAME name
		constraint salest_n_nn not null,
CountryRegionCode nvarchar (3) 
		constraint salest_crc_nn not null,
[Group] name
		constraint salest_g_nn not null,
SalesYTD money
		constraint salest_sy_nn not null,
SalesLastYear money
		constraint salest_sly_nn not null,
CostYTD money
		constraint salest_cytd_nn not null,
CostLastYear money
		constraint salest_cly_nn not null,
rowguid uniqueidentifier  
		constraint salest_rg_nn not null,
ModifiedDate datetime default getdate ())			        

select * from SalesTerritory

begin tran
insert into sales.dbo.SalesTerritory  
select [TerritoryID] ,
[NAME],
[CountryRegionCode], 
[Group],
[SalesYTD],
[SalesLastYear],
[CostYTD],
[CostLastYear],
[rowguid],
isnull (convert (datetime, ModifiedDate, 120), getdate ())
from sales.dbo.salestarritory_temp
commit

--טבלה 3   SpecialOfferProduct

create table dbo.SpecialOfferProduct
(ProductID int not null ,
SpecialOfferID int not null ,
Rowguid uniqueidentifier not null,
ModifiedDate datetime default getdate (),
Primary key(ProductID))

select * from SpecialOfferProduct 

begin tran
insert into sales.dbo.SpecialOfferProduct  
select ProductID,
[SpecialOfferID] ,
ISNULL (cast(Rowguid as uniqueidentifier), NEWID()),  
[ModifiedDate]
from sales.dbo.SpecialOfferProduct_temp
commit


--טבלה 4  CurrencyRate

create table dbo.CurrencyRate
(CurrencyRateID int,
 CurrencyRateDate datetime not null,
 FromCurrencyCode nchar (3) not null,
 ToCurrencyCode nchar (3) not null,
 AverageRate money not null,
 EndOfDayRate money not null,
ModifiedDate datetime default getdate () not null,
Primary key(CurrencyRateID))

select * from CurrencyRate

begin tran
insert into sales.dbo.CurrencyRate  
select [CurrencyRateID] ,
[CurrencyRateDate],
[FromCurrencyCode], 
[ToCurrencyCode],
[AverageRate],
[EndOfDayRate],
[modifieddate]
from sales.dbo.CurrencyRate_temp
commit

 
 --טבלה 5  ShipMethod
 
 create type name from nvarchar(50) 			
 
 create table dbo.ShipMethod
(ShipMethodID int, 
 constraint sm_smID_pk Primary key(ShipMethodID),
 NAME name  not null ,
 ShipBase money not null,
 ShipRate money not null,
Rowguid uniqueidentifier not null default newid (),
ModifiedDate datetime not null)

select * from ShipMethod

begin tran
insert into sales.dbo.ShipMethod  
select [ShipMethodID] ,
[NAME] ,
[ShipBase], 
[ShipRate],
ISNULL (cast(Rowguid as uniqueidentifier), NEWID()),
[modifieddate]
from sales.dbo.ShipMethod_temp
commit

-- טבלה 6  Address

create table dbo.Address
(AddressID int , 
 constraint ad_adID_pk Primary key(AddressID),
 AddressLine1 nvarchar(60) not null,
 AddressLine2 nvarchar(60),
 city nvarchar (30) not null,
StateProvinceID int not null,
PostalCode nvarchar(15) not null,
Rowguid uniqueidentifier not null default newid (),
ModifiedDate datetime not null)

select * from address

begin tran
insert into sales.dbo.address 
select [AddressID] ,
[AddressLine1] ,
[AddressLine2], 
[city],
[StateProvinceID],
[PostalCode],
ISNULL (cast(Rowguid as uniqueidentifier), NEWID()),
[modifieddate]
from sales.dbo.address_temp
commit

--טבלה 7  SalesPerson

create table dbo.SalesPerson
(BusinessEntityID int, 
TerritoryID int,
SalesQuota money,
bonus money,
CommissionPct smallmoney not null,
SalesYTD money not null,
SalesLastYear money not null,
rowguid uniqueidentifier not null default newid (),
ModifiedDate datetime not null,
Primary key(BusinessEntityID),
foreign key (TerritoryID) references salesterritory (territoryID))

select* from sales.dbo.salesperson

begin tran
insert into sales.dbo.SalesPerson 
select [BusinessEntityID] ,
[TerritoryID] ,
[SalesQuota], 
[bonus],
[CommissionPct],
[SalesYTD],
[SalesLastYear],
ISNULL (cast(Rowguid as uniqueidentifier), NEWID()),
[modifieddate]
from sales.dbo.salesperson_temp
commit

--טבלה 8  customer


 create table dbo.customer
(customerID int, 
personID int,
storeID int,
TerritoryID int,
AccountNumber nvarchar (50) not null,
rowguid uniqueidentifier  not null default newid (),
ModifiedDate datetime  
Primary key(customerID))

select * from customer

begin tran
insert into sales.dbo.customer 
select [customerID],
[personID] ,
[storeID], 
[TerritoryID],
[AccountNumber],
[rowguid],
[modifieddate]
from sales.dbo.customer_temp

commit


--טבלה 9  SalesOrderHeader
-- להעביר לmaster  כשמגדירים שם לtype
 
 create type Flag from bit 	
 
 create type ordernumber from nvarchar (25) 			

create type accountnumber from nvarchar (50) 			
  
-- לא לשכוח להחזיר לsales

create table dbo.SalesOrderHeader
(SalesOrderID int ,
 RevisionNumber tinyint not null,
OrderDate datetime not null,
DueDate datetime not null,
ShipDate datetime,
Status tinyint not null,
OnlineOrderFlag flag not null,
SalesOrderNumber nvarchar (50) not null,
PurchaseOrderNumber ordernumber,
AccountNumber accountnumber,
CustomerID int ,
SalesPersonID int,
TerritoryID int,
BillToAddressID int ,
ShipToAddressID int ,
ShipMethodID int ,
CreditCardID int,
CreditCardApprovalCode varchar (15),
CurrencyRateID int,
SubTotal money not null,
TaxAmt money not null,
Freight money not null,
TotalDue smallmoney not null,
Comment nvarchar (128),
rowguid uniqueidentifier not null default newid (),
ModifiedDate datetime default getdate (),
Primary key(SalesOrderID),
foreign key (TerritoryID) references salesterritory (territoryID),
foreign key (CustomerID) references customer (CustomerID),
foreign key (SalesPersonID) references SalesPerson (BusinessEntityID),
foreign key (CreditCardID) references CreditCard (CreditCardID),
foreign key (CurrencyRateID) references CurrencyRate (CurrencyRateID),
foreign key (ShipMethodID) references ShipMethod (ShipMethodID),
foreign key (BillToAddressID) references Address (AddressID))

select * from SalesOrderHeader

begin tran
insert into sales.dbo.SalesOrderHeader 
select [SalesOrderID],
[RevisionNumber] ,
[OrderDate], 
[DueDate],
[ShipDate],
[Status],
[OnlineOrderFlag],
[SalesOrderNumber],
[PurchaseOrderNumber],
[AccountNumber],
[CustomerID],
[SalesPersonID],
[TerritoryID],
[BillToAddressID],
[ShipToAddressID],
[ShipMethodID],
[CreditCardID],
[CreditCardApprovalCode],
[CurrencyRateID],
[SubTotal],
[TaxAmt],
[Freight],
[TotalDue],
[Comment],
[rowguid],
[modifieddate]
from sales.dbo.salesorderheader_temp

commit
 
--טבלה 10  SalesOrderDetail


create table dbo.SalesOrderDetail
(SalesOrderID int, 
SalesOrderdetailID int,
CarrierTrackingNumber nvarchar(25), 
OrderQty smallint not null,
productID int not null,
SpecialOfferID int not null,
UnitPrice money not null, 
UnitPriceDiscount money not null,
LineTotal smallmoney not null,
rowguid uniqueidentifier not null default newid (),
ModifiedDate datetime default getdate (),
   primary key (SalesOrderdetailID),
   foreign key (SalesOrderID) references salesorderheader (SalesOrderID),
   foreign key (productID) references specialofferproduct (productID))

select * from SalesOrderDetail
   
begin tran
insert into sales.dbo.SalesOrderDetail 
select [SalesOrderID],
[SalesOrderDetailID] ,
[CarrierTrackingNumber], 
[OrderQty],
[ProductID],
[SpecialOfferID],
[UnitPrice],
[UnitPriceDiscount],
[LineTotal],
[rowguid],
[modifieddate]
from sales.dbo.SalesOrderDetail_temp

commit

-- לא לשכוח לסגור טרן
