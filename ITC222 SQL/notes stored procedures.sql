USE Community_Assist;

--stored procedures
--register a new person
--check to see if person exists
--pass in all the info we need
--insert to person
-- created seed hash the password 
--insert into personAddress
--insert into person Contact
--all or none happen

--SQL Injection looks like:
--or 1=1;DROP TABLE Student--
--works anywhere it's not a WHERE statement


--Stored Procedures

--Version 1

GO
CREATE PROCEDURE usp_Registration
	@PersonLastName nvarchar(255),
	@PersonFirstName nvarchar(255),
	@PersonEmail nvarchar(255),
	@PersonPassword nvarchar(20),
	@PersonAddressApt nvarchar(255) = null,
	@PersonAddressStreet nvarchar(255),
	@PersonAddressCity nvarchar(255) = 'Seattle',
	@PersonAddressState nvarchar(2) = 'WA',
	@PersonAddressZip nchar(9),
	@HomePhone nchar(11) = null,
	@WorkPhone nchar(11) = null
AS 
DECLARE @seed int
SET @seed = dbo.fx_GetSeed()
DECLARE @pass varbinary(500)
SET @pass = dbo.fx_HashPassword(@seed, @PersonPassword)

INSERT INTO Person(PersonLastName,
	PersonFirstName,
	PersonEmail,
	PersonPassword,
	PersonEntryDate,
	PersonPassWordSeed)
VALUES (
	@PersonLastName,
	@PersonFirstName,
	@PersonEmail,
	@pass,
	GetDate(),
	@Seed)

DECLARE @PersonKey int
SET @PersonKey = ident_current('Person');

INSERT INTO PersonAddress(PersonAddressApt,
	PersonAddressStreet,
	PersonAddressCity,
	PersonAddressState,
	PersonAddressZip,
	PersonKey)
VALUES(@PersonAddressApt,
	@PersonAddressStreet,
	@PersonAddressCity,
	@PersonAddressState,
	@PersonAddressZip,
	@PersonKey);

IF NOT @HomePhone IS NULL
	BEGIN
		INSERT INTO Contact(
		ContactNumber,
		ContactTypeKey,
		PersonKey)
		VALUES(@HomePhone, 1, @PersonKey)
	END;

IF NOT @WorkPhone IS NULL
	BEGIN
		INSERT INTO Contact(
		ContactNumber,
		ContactTypeKey,
		PersonKey)
		VALUES(@WorkPhone, 1, @PersonKey)
	END;

GO
EXEC usp_Registration
	@PersonLastName='Reznor', 
	@PersonFirstName='Trent', 
	@PersonEmail='treznor@gmail.com', 
	@PersonPassword='rPass',  
	@PersonAddressStreet='10010 NIN Rd', 
	@PersonAddressCity='Renton', 
	@PersonAddressState='WA', 
	@PersonAddressZip='98010', 
	@HomePhone='555-100-1000';
	
SELECT * FROM Person;
SELECT * FROM PersonAddress;
SELECT * FROM Contact;

--/end version1

--Version 2

GO
ALTER PROCEDURE usp_Registration
	@PersonLastName nvarchar(255),
	@PersonFirstName nvarchar(255),
	@PersonEmail nvarchar(255),
	@PersonPassword nvarchar(20),
	@PersonAddressApt nvarchar(255) = null,
	@PersonAddressStreet nvarchar(255),
	@PersonAddressCity nvarchar(255) = 'Seattle',
	@PersonAddressState nvarchar(2) = 'WA',
	@PersonAddressZip nchar(9),
	@HomePhone nchar(11) = null,
	@WorkPhone nchar(11) = null
AS 
DECLARE @seed int
SET @seed = dbo.fx_GetSeed()
DECLARE @pass varbinary(500)
SET @pass = dbo.fx_HashPassword(@seed, @PersonPassword)
BEGIN TRY --
BEGIN TRAN --

INSERT INTO Person(PersonLastName,
	PersonFirstName,
	PersonEmail,
	PersonPassword,
	PersonEntryDate,
	PersonPassWordSeed)
VALUES (
	@PersonLastName,
	@PersonFirstName,
	@PersonEmail,
	@pass,
	GetDate(),
	@Seed)

DECLARE @PersonKey int
SET @PersonKey = ident_current('Person');

INSERT INTO PersonAddress(PersonAddressApt,
	PersonAddressStreet,
	PersonAddressCity,
	PersonAddressState,
	PersonAddressZip,
	PersonKey)
VALUES(@PersonAddressApt,
	@PersonAddressStreet,
	@PersonAddressCity,
	@PersonAddressState,
	@PersonAddressZip,
	@PersonKey);

IF NOT @HomePhone IS NULL
	BEGIN
		INSERT INTO Contact(
		ContactNumber,
		ContactTypeKey,
		PersonKey)
		VALUES(@HomePhone, 1, @PersonKey)
	END;

IF NOT @WorkPhone IS NULL
	BEGIN
		INSERT INTO Contact(
		ContactNumber,
		ContactTypeKey,
		PersonKey)
		VALUES(@WorkPhone, 1, @PersonKey)
	END



COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
PRINT Error_Message()
RETURN -1
END 

GO
EXEC usp_Registration
	@PersonLastName='Turner', 
	@PersonFirstName='Tina', 
	@PersonEmail='jcash@gmail.com', 
	@PersonPassword='rPass',  
	@PersonAddressStreet='10010 NIN Rd', 
	@PersonAddressCity='Renton', 
	@PersonAddressState='WA', 
	@PersonAddressZip='98010', 
	@HomePhone='5551001000';
	
SELECT * FROM Person;
SELECT * FROM PersonAddress;
SELECT * FROM Contact;


--/end version 2

--version 3

GO
ALTER PROCEDURE usp_Registration
	@PersonLastName nvarchar(255),
	@PersonFirstName nvarchar(255),
	@PersonEmail nvarchar(255),
	@PersonPassword nvarchar(20),
	@PersonAddressApt nvarchar(255) = null,
	@PersonAddressStreet nvarchar(255),
	@PersonAddressCity nvarchar(255) = 'Seattle',
	@PersonAddressState nvarchar(2) = 'WA',
	@PersonAddressZip nchar(9),
	@HomePhone nchar(11) = null,
	@WorkPhone nchar(11) = null
AS 
IF not exists
	(SELECT PersonKey FROM Person
	WHERE PersonEmail = @PersonEmail)
	BEGIN
DECLARE @seed int
SET @seed = dbo.fx_GetSeed()
DECLARE @pass varbinary(500)
SET @pass = dbo.fx_HashPassword(@seed, @PersonPassword)
BEGIN TRY --
BEGIN TRAN --

INSERT INTO Person(PersonLastName,
	PersonFirstName,
	PersonEmail,
	PersonPassword,
	PersonEntryDate,
	PersonPassWordSeed)
VALUES (
	@PersonLastName,
	@PersonFirstName,
	@PersonEmail,
	@pass,
	GetDate(),
	@Seed)

DECLARE @PersonKey int
SET @PersonKey = ident_current('Person');

INSERT INTO PersonAddress(PersonAddressApt,
	PersonAddressStreet,
	PersonAddressCity,
	PersonAddressState,
	PersonAddressZip,
	PersonKey)
VALUES(@PersonAddressApt,
	@PersonAddressStreet,
	@PersonAddressCity,
	@PersonAddressState,
	@PersonAddressZip,
	@PersonKey);

IF NOT @HomePhone IS NULL
	BEGIN
		INSERT INTO Contact(
		ContactNumber,
		ContactTypeKey,
		PersonKey)
		VALUES(@HomePhone, 1, @PersonKey)
	END;

IF NOT @WorkPhone IS NULL
	BEGIN
		INSERT INTO Contact(
		ContactNumber,
		ContactTypeKey,
		PersonKey)
		VALUES(@WorkPhone, 1, @PersonKey)
	END



COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	PRINT Error_Message()
	RETURN -1
END CATCH
	END--end If not exists
	ELSE
	BEGIN
		PRINT 'person already exists';
	END

GO
EXEC usp_Registration
	@PersonLastName='Turner', 
	@PersonFirstName='Tina', 
	@PersonEmail='jcash@gmail.com', 
	@PersonPassword='rPass',  
	@PersonAddressStreet='10010 NIN Rd', 
	@PersonAddressCity='Renton', 
	@PersonAddressState='WA', 
	@PersonAddressZip='98010', 
	@HomePhone='5551001000';
	
SELECT * FROM Person;
SELECT * FROM PersonAddress;
SELECT * FROM Contact;



GO 
--update procedure
GO
CREATE PROC usp_UpdatePersonInfo
	@PersonKey int,
	@PersonLastName nvarchar(255), 
	@PersonFirstName nvarchar(255), 
	@PersonEmail nvarchar(255), 
	@PersonAddressApt nvarchar(255) = null,
	@PersonAddressStreet nvarchar(255), 
	@PersonAddressCity nvarchar(255) ='Seattle', 
	@PersonAddressState nvarchar(2) = 'WA', 
	@PersonAddressZip nchar(9) 
AS
BEGIN TRY
BEGIN TRAN
UPDATE Person
SET PersonLastName = @PersonLastName,
	PersonFirstName = @PersonFirstName,
	PersonEmail = @PersonEmail
WHERE PersonKey = @PersonKey;

UPDATE PersonAddress
SET	PersonAddressApt = @PersonAddressApt,
	PersonAddressStreet = @PersonAddressStreet,
	PersonAddressCity = @PersonAddressCity,
	PersonAddressState = @PersonAddressState
WHERE PersonKey = @PersonKey;

COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	PRINT Error_Message()
END CATCH



EXEC usp_UpdatePersonInfo
	@PersonKey = 4,
	@PersonLastName = 'Carmel', 
	@PersonFirstName = 'Bob', 
	@PersonEmail = 'bobcarmel@gmail.com', 
	@PersonAddressStreet = '213 Walnut St', 
	@PersonAddressCity = 'Bellvue', 
	@PersonAddressZip = '98002' 

SELECT * FROM Person;
SELECT * FROM PersonAddress;

--/end update procedure

--declare variable by assigning from tablw

DECLARE @PersonKeyb int
SELECT @PersonKeyb = PersonKey FROM Person
	WHERE PersonEmail = 'bobcarmel@gmail.com'
PRINT @PersonKeyb;