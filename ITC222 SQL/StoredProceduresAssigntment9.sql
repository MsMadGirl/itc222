USE MetroAlt;

--1. Create a stored procedure to enter a new employee, 
--position and pay rate which uses the functions to create 
--an email address and the one to determine initial pay. 
--Also make sure that the employee does not already exist. 
--Use the stored procedure to add a new employee.

--DROP PROC IF EXISTS MetroAlt.NewEmployee;
GO

ALTER PROC usp_NewEmployee
	@EmployeeLastName nvarchar(255),
	@EmployeeFirstName nvarchar(255),
	@EmployeeAddress nvarchar(255),
	@EmployeeCity nvarchar(255) = 'Seattle',
	@EmployeeZipCode nchar(5),
	@EmployeePhone nchar(10) = null,
	@PositionKey int

AS 
DECLARE @EmployeeEmail nvarchar(255)
DECLARE @EmployeeHourlyPayRate decimal
SET @EmployeeEmail = dbo.fx_email(@EmployeeFirstName, @EmployeeLastName);

BEGIN TRY
BEGIN TRAN

INSERT INTO Employee(
	EmployeeLastName,
	EmployeeFirstName,
	EmployeeAddress,
	EmployeeCity,
	EmployeeZipCode,
	EmployeePhone,
	EmployeeEmail,
	EmployeeHireDate
	)
VALUES(
	@EmployeeLastName,
	@EmployeeFirstName,
	@EmployeeAddress,
	@EmployeeCity,
	@EmployeeZipCode,
	@EmployeePhone,
	@EmployeeEmail,
	GetDate()
	);

DECLARE @Maximum money
SELECT @Maximum = Max(EmployeeHourlyPayRate) FROM EmployeePosition WHERE PositionKey = @PositionKey
DECLARE @Minimum money
SELECT @Minimum = MIN(EmployeeHourlyPayRate) FROM EmployeePosition WHERE PositionKey = @PositionKey
DECLARE @Diff money
SET @Diff = @Maximum - @Minimum

SET @EmployeeHourlyPayRate = dbo.fx_newpayrate(@Maximum, @Minimum, @Diff, @PositionKey);

Declare @EmployeeKey INT
Set @EmployeeKey = ident_current('Employee');

INSERT INTO EmployeePosition(
	EmployeeKey,
	PositionKey,
	EmployeeHourlyPayRate,
	EmployeePositionDateAssigned
	)
VALUES(
	@EmployeeKey,
	@PositionKey,
	@EmployeeHourlyPayRate,
	GetDate()
	);

COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
PRINT Error_Message()
RETURN -1
END CATCH



EXEC usp_NewEmployee
	@EmployeeLastName = 'Mouse',
	@EmployeeFirstName = 'Mickey',
	@EmployeeAddress ='1200 Disney Ave',
	@EmployeeCity = 'Seattle',
	@EmployeeZipCode = 98125,
	@EmployeePhone = 2065551212,
	@PositionKey = 2;
	
SELECT * FROM Employee;
SELECT * FROM EmployeePosition;

--needs check to see if employee exists

--2. Create a stored procedure that allows an employee to edit 
--their own information name, address, city, zip, not email etc.  
--The employee key should be one of its parameters. Use the 
--procedure to alter one of the employees information. Add 
--error trapping to catch any errors.



CREATE PROC usp_UpdateEmployeeInfo
	@EmployeeKey int, 
	@EmployeeLastName nvarchar(255), 
	@EmployeeFirstName nvarchar(255), 
	@EmployeeAddress nvarchar(255),
	@EmployeeCity nvarchar(255) = 'Seattle',
	@EmployeeZipCode nchar(5),
	@EmployeePhone nchar(10) = null,
	@EmployeeEmail nvarchar(255)


AS
BEGIN TRY
BEGIN TRAN
UPDATE Employee
SET EmployeeLastName =@EmployeeLastName,
	EmployeeFirstName=@EmployeeFirstName,
	EmployeeAddress=@EmployeeAddress,
	EmployeeCity=@EmployeeCity,
	EmployeeZipCode=@EmployeeZipCode,
	EmployeePhone=@EmployeePhone,
	EmployeeEmail=@EmployeeEmail
WHERE EmployeeKey = @EmployeeKey

COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
PRINT Error_Message()
END CATCH;
