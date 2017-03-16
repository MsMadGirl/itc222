 Table Expressions

--Table expression

--a sub query in the from clause--querying a result set

use Community_Assist

Select PersonKey, [Last], [First], City 
From
(Select p.Personkey, PersonLastName [Last], PersonFirstName [First], PersonAddressCity City
From Person p
inner join PersonAddress pa
on p.PersonKey=pa.PersonKey
Where PersonAddressCity = 'Bellevue') as BellevueResidents

Select PersonKey, [Last], [First], City 
From
(Select p.Personkey, PersonLastName [Last], PersonFirstName [First], PersonAddressCity City
From Person p
inner join PersonAddress pa
on p.PersonKey=pa.PersonKey) as Residents
Where City = 'Bellevue' 

Select RequestMonth, [Grant Type Name],  Count([Grant Type Name]) as [Count]
from
(Select Month(GrantRequestDate) RequestMonth, GrantTypeName [Grant Type Name]
   From GrantRequest gr
   inner join GrantType gt
   on gt.GrantTypeKey=gr.GrantTypeKey ) as [Grant Type Counts]
group by RequestMonth, [Grant Type Name]

--CTE (Common Table Expression)
go
with Residents as
(
Select p.Personkey, PersonLastName [Last], PersonFirstName [First], PersonAddressCity City
From Person p
inner join PersonAddress pa
on p.PersonKey=pa.PersonKey

)
Select PersonKey, [Last], [First], City  From Residents Where City = 'Kent'

with GrantCount as
(
   Select Month(GrantRequestDate) RequestMonth, GrantTypeName [Grant Type Name]
   From GrantRequest gr
   inner join GrantType gt
   on gt.GrantTypeKey=gr.GrantTypeKey 
)
Select RequestMonth, [Grant Type Name], Count([Grant Type Name]) as [Count]
From GrantCount
Group by RequestMonth, [Grant Type Name]


Declare @City nvarchar(255)
Set @city='Redmond'

Select Distinct PersonKey, [Last], [First], City 
From
(Select p.Personkey, PersonLastName [Last], PersonFirstName [First], PersonAddressCity City
From Person p
inner join PersonAddress pa
on p.PersonKey=pa.PersonKey) as Residents
Where City = @City


--views
go
Create view vw_Employees
As 
Select 
PersonLastName LastName, 
PersonFirstName FirstName,
EmployeeHireDate HireDate,
EmployeeAnnualSalary Salary,
PositionName [Position]
From Person p
inner join Employee e
on p.PersonKey=e.PersonKey
inner join EmployeePosition ep
on e.EmployeeKey=ep.EmployeeKey
inner join Position po
on po.PositionKey=ep.PositionKey

go

--order by is forbidden in views
Select LastName, FirstName, Position from vw_Employees
order by LastName

/*
insert or update through view if
no column is aliased
no joins
sub queries */
go
Alter view vw_Employees with schemabinding
As 
Select 
PersonLastName LastName, 
PersonFirstName FirstName,
EmployeeHireDate HireDate,
EmployeeAnnualSalary Salary,
PositionName [Position]
From dbo.Person p
inner join dbo.Employee e
on p.PersonKey=e.PersonKey
inner join dbo.EmployeePosition ep
on e.EmployeeKey=ep.EmployeeKey
inner join dbo.Position po
on po.PositionKey=ep.PositionKey
go
Create schema Donor

Create view Donor.vw_DonorInfo
As
Select PersonLastName,PersonFIrstname, PersonEmail,
DonationDate, DonationAmount
From Person p
inner Join Donation d
on p.PersonKey=d.PersonKey
go
--table valued function
create function fx_EmployeeGrantCount
(@EmployeeKey int)
returns table
as 
Return
Select gr.GrantRequestKey, GrantRequestDate, GrantReviewDate,
 PersonKey, GrantRequestExplanation, 
 GrantRequestAmount, GrantAllocationAmount
 From GrantRequest gr
 inner join GrantReview gv
 on gr.GrantRequestKey=gv.GrantRequestKey
 Where employeeKey = @EmployeeKey

 Select Sum(GrantRequestAmount) Request, Sum (GrantAllocationAmount) allocation 
 from dbo.fx_EmployeeGrantCount(2)

 Select distinct employeeKey from GrantReview

 Select distinct gr1.GrantTypeKey, c.GrantRequestAmount
 From dbo.GrantRequest as gr1
 Cross Apply
 (Select GrantTypeKey, GrantRequestAmount, GrantRequestKey
 From dbo.GrantRequest as gr2
 where gr1.GrantTypeKey = gr2.GrantTypeKey
 order by GrantRequestAmount desc, GrantTypeKey desc
 offset 0 rows fetch first 3 rows only) as c





