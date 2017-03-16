USE Community_Assist;

--scalar functions

--variables have @
--begin and end are curly braces
--as starts function
--must have returnS + datatype before begin
GO
CREATE FUNCTION fx_cube
(@number int) 
RETURNS int
AS
	BEGIN
		DECLARE @cube int
		SET @cube = @number * @number *@number
		RETURN @cube
	END;

GO
SELECT dbo.fx_cube(7);

--create OneLineAddress to test if null apartment works

GO
CREATE FUNCTION fx_OneLineAddress
(
	@Apartment nvarchar(255),
	@Street nvarchar(255),
	@City nvarchar(255),
	@State nchar(2),
	@Zip nchar(9)
)
RETURNS nvarchar(255)
AS
	BEGIN
		DECLARE @address nvarchar(255)
		SET @address = 'test'
		RETURN @address
	END;



SELECT dbo.fx_OneLineAddress(null, '1000 1st', 'seattle', 'wa', '98125');

--alter the function to actually do what we want

ALTER FUNCTION fx_OneLineAddress
(
	@Apartment nvarchar(255),
	@Street nvarchar(255),
	@City nvarchar(255),
	@State nchar(2),
	@Zip nchar(9)
)
RETURNS nvarchar(255)
AS
	BEGIN
		DECLARE @address nvarchar(255)
		IF @Apartment is NULL
			BEGIN
				SET @address = @Street + ', ' + @City + ', ' + @State + @Zip
			END
		ELSE
			BEGIN
				SET @address = @Street + ' #' + @Apartment + ', ' + ', ' + @City + ', ' + @State + @Zip
			END
		RETURN @address
	END;



SELECT PersonLastName, dbo.fx_OneLineAddress
(
	[PersonAddressApt],
	[PersonAddressStreet],
	[PersonAddressCity],
	[PersonAddressState],
	[PersonAddressZip]
)as [Address]
FROM Person p
INNER JOIN PersonAddress pa
on p.PersonKey=pa.PersonKey;

--

GO
CREATE FUNCTION fx_RequestvsAllocationAmounts
(
	@Request money,
	@Allocation money
)
RETURNS money
AS
	BEGIN
		RETURN @Request-@Allocation
	END

SELECT GrantTypeKey, YEAR(GrantRequestDate) as [Year], SUM(GrantRequestAmount) AS Request, SUM(GrantAllocationAmount) AS Allocated, dbo.fx_RequestvsAllocationAmounts
(
	GrantRequestAmount,
	GrantAllocationAmount
)
AS [difference]
FROM GrantRequest gr
INNER JOIN GrantReview rev
ON gr.GrantRequestKey = rev.GrantRequestKey;


--Stored function for hashing passwords
GO

/****** Object:  UserDefinedFunction [dbo].[fx_HashPassword]    Script Date: 2/14/2017 11:26:24 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create function [dbo].[fx_HashPassword]
(@seed int, @password nvarchar(50))
returns varbinary(500)
As
Begin
Declare @ToHash nvarchar(70)
Set @ToHash=@password + cast(@seed as nvarchar(20))
Declare @hashed varbinary(500)
set @hashed=hashbytes('sha2_512',@ToHash)
return @hashed
End


GO
--END has password

