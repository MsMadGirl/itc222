 Stored Procedures

--stored procedures
--register a new person
--check to see if person exists
--pass in all the info we need
--insert to person
-- created seed hash the password 
--insert into personAddress
--insert into person Contact
--all or none happen

--or 1 = 1;Drop Table Student--

--version 1
Create procedure usp_Registration
@PersonLastName nvarchar(255), 
@PersonFirstName nvarchar(255), 
@PersonEmail nvarchar(255), 
@PersonPassWord nvarchar(20), 
@PersonAddressApt nvarchar(255)=null, 
@PersonAddressStreet nvarchar(255), 
@PersonAddressCity nvarchar(255) = 'Seattle', 
@PersonAddressState nchar(2)='Wa',
@PersonAddressZip nchar(9), 
@HomePhone nvarchar(255)=null,
@WorkPhone nvarchar(255)=null
As
Declare @seed int
Set @seed = dbo.fx_GetSeed()
Declare @pass varbinary(500)
set @pass=dbo.fx_HashPassword(@seed, @PersonPassword)

Insert into Person(
PersonLastName, 
PersonFirstName, 
PersonEmail, 
PersonPassWord, 
PersonEntryDate, 
PersonPassWordSeed)
Values(
@PersonLastName,
@PersonFirstName,
@PersonEmail,
@pass,
GetDate(),
@Seed)

Declare @PersonKey int
Set @personKey = ident_current('Person')

Insert into PersonAddress(
PersonAddressApt, 
PersonAddressStreet, 
PersonAddressCity, 
PersonAddressState, 
PersonAddressZip, 
PersonKey)
Values(
@PersonAddressApt,
@PersonAddressStreet,
@PersonAddressCity,
@PersonAddressState,
@PersonAddressZip,
@PersonKey)

IF Not @HomePhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
Values(@HomePhone, 1, @personKey)
End


IF Not @WorkPhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
Values(@WorkPhone, 2, @personKey)
End
go
exec usp_Registration
@PersonLastName='Rezenor', 
@PersonFirstName='Trent', 
@PersonEmail='tresenor@gmai;.com', 
@PersonPassWord='rPass', 
@PersonAddressStreet='10010 NIN South', 
@PersonAddressCity='Renton', 
@PersonAddressZip='98010', 
@HomePhone='3605551356'

go--version 2
Alter procedure usp_Registration
@PersonLastName nvarchar(255), 
@PersonFirstName nvarchar(255), 
@PersonEmail nvarchar(255), 
@PersonPassWord nvarchar(20), 
@PersonAddressApt nvarchar(255)=null, 
@PersonAddressStreet nvarchar(255), 
@PersonAddressCity nvarchar(255) = 'Seattle', 
@PersonAddressState nchar(2)='Wa',
@PersonAddressZip nchar(9), 
@HomePhone nvarchar(255)=null,
@WorkPhone nvarchar(255)=null
As
Declare @seed int
Set @seed = dbo.fx_GetSeed()
Declare @pass varbinary(500)
set @pass=dbo.fx_HashPassword(@seed, @PersonPassword)
Begin try--
Begin tran
Insert into Person(
PersonLastName, 
PersonFirstName, 
PersonEmail, 
PersonPassWord, 
PersonEntryDate, 
PersonPassWordSeed)
Values(
@PersonLastName,
@PersonFirstName,
@PersonEmail,
@pass,
GetDate(),
@Seed)

Declare @PersonKey int
Set @personKey = ident_current('Person')

Insert into PersonAddress(
PersonAddressApt, 
PersonAddressStreet, 
PersonAddressCity, 
PersonAddressState, 
PersonAddressZip, 
PersonKey)
Values(
@PersonAddressApt,
@PersonAddressStreet,
@PersonAddressCity,
@PersonAddressState,
@PersonAddressZip,
@PersonKey)

IF Not @HomePhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
Values(@HomePhone, 1, @personKey)
End


IF Not @WorkPhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
Values(@WorkPhone, 2, @personKey)
End
Commit tran
End try
Begin catch
Rollback tran
print Error_Message()
return -1
End catch

exec usp_Registration
@PersonLastName='Rogers', 
@PersonFirstName='Tina', 
@PersonEmail='tresenor@gmai;.com', 
@PersonPassWord='rPass', 
@PersonAddressStreet='1001 somewhere South', 
@PersonAddressCity='Seattle', 

@PersonAddressZip='98010', 
@HomePhone='3605551356'

go
Select * from Person
Select * from PersonAddress
Select * from Contact
go
Alter procedure usp_Registration
@PersonLastName nvarchar(255), 
@PersonFirstName nvarchar(255), 
@PersonEmail nvarchar(255), 
@PersonPassWord nvarchar(20), 
@PersonAddressApt nvarchar(255)=null, 
@PersonAddressStreet nvarchar(255), 
@PersonAddressCity nvarchar(255) = 'Seattle', 
@PersonAddressState nchar(2)='Wa',
@PersonAddressZip nchar(9), 
@HomePhone nvarchar(255)=null,
@WorkPhone nvarchar(255)=null
As
If not exists
  (Select PersonKey from Person 
    Where PersonEmail = @personEmail)
Begin
Declare @seed int
Set @seed = dbo.fx_GetSeed()
Declare @pass varbinary(500)
set @pass=dbo.fx_HashPassword(@seed, @PersonPassword)
Begin try--
Begin tran
Insert into Person(
PersonLastName, 
PersonFirstName, 
PersonEmail, 
PersonPassWord, 
PersonEntryDate, 
PersonPassWordSeed)
Values(
@PersonLastName,
@PersonFirstName,
@PersonEmail,
@pass,
GetDate(),
@Seed)

Declare @PersonKey int
Set @personKey = ident_current('Person')

Insert into PersonAddress(
PersonAddressApt, 
PersonAddressStreet, 
PersonAddressCity, 
PersonAddressState, 
PersonAddressZip, 
PersonKey)
Values(
@PersonAddressApt,
@PersonAddressStreet,
@PersonAddressCity,
@PersonAddressState,
@PersonAddressZip,
@PersonKey)

IF Not @HomePhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
Values(@HomePhone, 1, @personKey)
End


IF Not @WorkPhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
Values(@WorkPhone, 2, @personKey)
End
Commit tran
End try
Begin catch
Rollback tran
print Error_Message()
return -1
End catch
end
Else
Begin
print 'person already exists'
End

go
--update Procedure
create proc usp_UpdatePersonInfo
@PersonKey int, 
@PersonLastName nvarchar(255), 
@PersonFirstName nvarchar(255), 
@PersonEmail nvarchar(255), 
@PersonAddressApt nvarchar(255)=null, 
@PersonAddressStreet nvarchar(255), 
@PersonAddressCity nvarchar(255)='Seattle', 
@PersonAddressState nchar(2) = 'WA', 
@PersonAddressZip nchar(9)
As
Begin try
Begin tran
Update Person
Set PersonLastName =@PersonLastName,
PersonFirstName=@PersonFirstName,
PersonEmail=@PersonEmail
Where Personkey = @PersonKey

Update PersonAddress
set PersonAddressApt=@PersonAddressApt,
PersonAddressStreet=@PersonAddressStreet,
PersonAddressCity=@PersonAddressCity,
PersonAddressState=@PersonAddressState,
PersonAddressZip=@PersonAddressZip
Where PersonKey = @PersonKey
Commit tran
End Try
Begin Catch
Rollback tran
print Error_Message()
End Catch

Select * from Person

exec usp_UpdatePersonInfo
@PersonKey=4,
@PersonLastName='Carmel', 
@PersonFirstName='Bob', 
@PersonEmail='BobCarmel@gmail.com', 
@PersonAddressStreet='213 Walnut Street', 
@PersonAddressCity='Bellevue', 
@PersonAddressZip='98002'

Select * from PersonAddress where personkey=4
--another way to get a value into a variable
Declare @PersonKeyb int
Select @PersonKeyb = personKey from Person
  Where PersonEmail = 'BobCarmel@gmail.com'
print @PersonKeyb
