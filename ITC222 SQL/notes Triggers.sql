--trigger
--events insert update and delete

Use Community_Assist

Select * from GrantType
go
Create trigger tr_OneTimeMaximum on GrantRequest
instead of insert
as
--declare variables
Declare @OneTimeMax money
Declare @GrantType int
Declare @RequestAmount Money

--assign values from inserted and Granttype
Select @GrantType = GrantTypeKey from Inserted
Select @OneTimeMax=GrantTypeMaximum 
From GrantType where GrantTypeKey=@grantType
Select @RequestAmount= GrantRequestAmount 
From inserted
if @RequestAmount <= @OneTimeMax
begin
Insert into GrantRequest(GrantRequestDate, PersonKey, GrantTypeKey, 
GrantRequestExplanation, GrantRequestAmount)
Select GrantRequestDate, PersonKey, GrantTypeKey, 
GrantRequestExplanation, GrantRequestAmount
From inserted
end
Else
Begin
if not exists
  (Select name from sys.Tables where name ='DumpTable')
  Begin
  Create table Dumptable
  (
      GrantRequestDate Datetime,
   PersonKey int,
   GrantTypeKey int,
   GrantRequestExplanation nvarchar(255),
   GrantRequestAmount money
  )

  End
  Insert into Dumptable(GrantRequestDate, PersonKey, GrantTypeKey, 
 GrantRequestExplanation, GrantRequestAmount)
 Select GrantRequestDate, PersonKey, GrantTypeKey, 
    GrantRequestExplanation, GrantRequestAmount
    From inserted

End
Go
Insert into GrantRequest(GrantRequestDate, PersonKey, 
GrantTypeKey, GrantRequestExplanation, GrantRequestAmount)
Values (GetDate(), 4, 1, 'Hungry',250)

Select * from GrantRequest
Select * from DumpTable


Create Table #TempTable
(
   GrantRequestDate Datetime,
   PersonKey int,
   GrantTypeKey int,
   GrantRequestExplanation nvarchar(255),
   GrantRequestAmount money
)

Begin tran
Insert into GrantRequest(GrantRequestDate, PersonKey, 
GrantTypeKey, GrantRequestExplanation, GrantRequestAmount)
Values (GetDate(), 1, 1, 'Hungry',250)
RollBack tran
go
Create trigger tr_testInsert on Donation
after insert
As
Declare @Confirm UniqueIdentifier = NewID()
Declare @Amount money
Select @Amount = DonationAmount from inserted
if @Amount < 1000
Begin
Declare @Id int = ident_current('Donation')
update Donation
set DonationConfirmation = @confirm
where DonationKey = @ID
End

Insert into Donation(PersonKey, DonationDate, DonationAmount)
Values(3,GetDate(), 1200)

Select * from Donation