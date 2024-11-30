create database Ecommerc

------------------------------------------------------------------

create view vw_Ord_OrdDet_Prod_Cust_Emp_Shipp as

select
p.ProductID,p.ProductName,p.QuantityPerUnit,p.UnitsInStock,p.Discontinued,p.CategoryID,p.SupplierID,
od.Discount,od.Quantity,od.UnitPrice,(od.Quantity*od.UnitPrice) as Sales,
o.OrderID,o.Freight,o.OrderDate,o.ShippedDate,o.RequiredDate, o.ShipAddress,o.ShipCity,o.ShipCountry,o.ShipName,o.ShipPostalCode,
c.CustomerID,c.Address,c.ContactName,c.ContactTitle,c.CustomerCity,c.CustomerCompanyName,c.CustomerCountry,c.Fax,c.Phone,
e.EmployeeID,e.FirstName,e.LastName,e.BirthDate,e.EmployeesCity,e.EmployeesCountry,e.Extension,e.HireDate,e.HomePhone,e.Region,e.Title,
e.TitleOfCourtesy,
s.ShipperID,s.CompanyName

from

[dbo].[OrdersDetails] od join [dbo].[Product] p on od.ProductID = p.ProductID join
[dbo].[Orders] o on od.OrderID= o.OrderID join
[dbo].[Customers] c on c.CustomerID= o.CustomerID join
[dbo].[Employees] e on e.EmployeeID= o.EmployeeID join
[dbo].[Shippers] s on s.ShipperID= o.ShipperID

-------------------------------------------------------------------------------------------
--total sales per category

select [CategoryName], sum([Sales]) as Total_sales

from   [dbo].[vw_Ord_OrdDet_Prod_Cust_Emp_Shipp] vw  join [dbo].[Categories] c on vw.CategoryID=c.CategoryID
group by [CategoryName]
order by Total_sales desc

--------------------------------------------------------------------------------------------
--total sales--

select sum([Sales]) as Total_sales
from [dbo].[vw_Ord_OrdDet_Prod_Cust_Emp_Shipp]

----------------------------------------------------------------------------------
--total_quantity--

select sum([Quantity]) as Total_Quantity
from [dbo].[OrdersDetails]

-------------------------------------------------------------------------------------------
--top 10 products based on sales--

select top 10 [ProductName], sum([Sales]) as Total_sales
from [dbo].[vw_Ord_OrdDet_Prod_Cust_Emp_Shipp]
group by [ProductName]
order by sum([Sales]) desc

--------------------------------------------------------------------------------------------
--top 3 categories based on sales--

select top 3 [CategoryName], sum([Sales]) as Total_sales
from [dbo].[vw_Ord_OrdDet_Prod_Cust_Emp_Shipp] vw join [dbo].[Categories] c 
on c.CategoryID=vw.CategoryID
group by [CategoryName]
order by sum([Sales]) desc

---------------------------------------------------------------------------------------------
--top N customers based on buying-- 
create procedure Top_Buying_Customers
@num int
As Begin
select top (@num) [ContactName] , sum([Sales]) as Total_sales
from [dbo].[vw_Ord_OrdDet_Prod_Cust_Emp_Shipp]
group by [ContactName]
order by Total_sales desc
End

execute Top_Buying_Customers 7
-----------------------------------------------------------------------------------------------
--  top N customers based on total orders-- 

create procedure TopN_Customers
@num int
As Begin
select top (@num) [ContactName] , count(distinct [OrderID]) as Num_Of_Orders
from [dbo].[vw_Ord_OrdDet_Prod_Cust_Emp_Shipp]
group by [ContactName]
order by Num_Of_Orders desc
End

execute TopN_Customers 10
------------------------------------------------------------------------------------------------
--  top 5 Country based on Orders

select top 5 [CustomerCity] , count(distinct [OrderID]) as Num_Of_Orders
from [dbo].[vw_Ord_OrdDet_Prod_Cust_Emp_Shipp]
group by [CustomerCity]
order by Num_Of_Orders desc

-------------------------------------------------------------------------------------------------
-- contact title vs total sales and orders--

select 
COALESCE([ContactTitle], 'Sales Representative') AS ContactTitle,
sum([Sales]) as Total_sales,
count(distinct [OrderID]) as Num_Of_Orders

from [dbo].[vw_Ord_OrdDet_Prod_Cust_Emp_Shipp]
group by COALESCE([ContactTitle], 'Sales Representative') 

---------------------------------------------------------------------------------------------------
-- most shipping company based on Total Orders--

select [CompanyName] , count(distinct [OrderID]) as Total_Orders
from [dbo].[vw_Ord_OrdDet_Prod_Cust_Emp_Shipp]
group by [CompanyName]
order by Total_Orders desc

----------------------------------------------------------------------------------------------------
