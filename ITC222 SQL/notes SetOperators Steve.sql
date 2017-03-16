--Set operators
--Data modification
--Windows functions

use Community_Assist
--union
Select PersonFirstName, PersonLastName, EmployeeHireDate
From person p
inner join Employee e
on p.PersonKey=e.PersonKey
union
Select EmployeeFirstName, EmployeeLastName, EmployeeHireDate
From MetroAlt.dbo.Employee
--intersect
Select PersonAddressCity from PersonAddress
intersect
Select  EmployeeCity from MetroAlt.dbo.Employee
--except
Select PersonAddressCity from PersonAddress
except
Select  EmployeeCity from MetroAlt.dbo.Employee

Select  EmployeeCity from MetroAlt.dbo.Employee
except
Select PersonAddressCity from PersonAddress

/***********************
Not on assignment
***********************/
--ranking function
Select GrantRequestKey, GrantTypeKey, GrantRequestAmount,
row_Number() over (order by GrantRequestAmount desc) as RowNumber,
Rank() over (order by GrantRequestAmount desc) as [Rank],
Dense_Rank() over (order by  GrantRequestAmount desc) as [Dense Rank],
Ntile(10) over (order by  GrantRequestAmount desc) as [NTile]
From GrantRequest
Order by GrantRequestAmount desc

--windows partition function
Select distinct Year(GrantRequestDate) as[Year], GrantTypeKey, 
sum(GrantRequestAmount) over () as TotalRequests,
sum (GrantRequestAmount) over (partition by Year(GrantRequestDate)) as [AmountPerYear],
Sum(GrantRequestAmount) over (partition by GrantTypeKey) as perGrantType
From GrantRequest
order by Year(GrantRequestDate),GrantTypeKey 

--insert update delete

Insert into Person(PersonLastName, PersonFirstName,
PersonEmail,  PersonEntryDate)
Values('Conger', 'Steve', 'steve@gmail.com', GetDate())

Insert into PersonAddress(PersonAddressApt, PersonAddressStreet,
 PersonAddressCity, PersonAddressState, PersonAddressZip, PersonKey)
 Values(Null, '1701 Broadway','Seattle','Wa','98122',ident_current('Person'))

 Insert into Person(PersonLastName, PersonFirstName,
PersonEmail,  PersonEntryDate)
Values('Simpson', 'Bart', 'Bart@fox.com',GetDate()),
('Simpson', 'Homer', 'Homer@fox.com',GetDate()),
('Simpson', 'Lisa', 'Lisa@fox.com',GetDate())

 Select * from PersonAddress

 Insert into Person(PersonLastName, PersonFirstName,
PersonEmail,  PersonEntryDate)
Values(N'κονγεροσ',N'στεφανοσ', N'στεπηανοσ@γμαιλ.κομ', GetDate())

Select * from Person


Begin tran
update Person
Set PersonFirstName='Jason',
PersonEmail='jasonAnderson@gmail.com'
where PersonKey =1

Select * from Person

Commit tran
Rollback tran

Begin Tran
Delete from PersonAddress

Create
Alter
Drop
