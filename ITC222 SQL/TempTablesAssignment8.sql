USE MetroAlt;


    --Create a temp table to show how many stops each route has. the table should have fields for the route 
	--number and the number of stops. Insert into it from BusRouteStops and then select from the temp table.
    
CREATE table #TempStops
(
	RouteKey int,
	Stops int
);

INSERT INTO #TempStops(RouteKey, Stops)
SELECT BusRouteKey, BusRouteStopKey
FROM BusRouteStops;

SELECT * from #TempStops;

	
	--Do the same but using a global temp table.
    
CREATE table ##GlobalTempStops
(
	RouteKey int,
	Stops int
);

INSERT INTO ##GlobalTempStops(RouteKey, Stops)
SELECT BusRouteKey, BusRouteStopKey
FROM BusRouteStops;

SELECT * from ##GlobalTempStops;	
	
	--Create a function to create an employee email address. Every employee Email follows the pattern of 
	--"firstName.lastName@metroalt.com"
    
GO
CREATE FUNCTION fx_email
(	
	@EmpFirst nvarchar(255),
	@EmpLast nvarchar(255)
)
RETURNS nvarchar(255)
AS
	BEGIN
		DECLARE @email nvarchar(255)
		BEGIN
			SET @email = @EmpFirst + '.' + @EmpLast + '@metroalt.com'
		END
		RETURN @email
	END;
GO

SELECT dbo.fx_email
(
	[EmployeeFirstName],
	[EmployeeLastName]
)
	as [email]
	FROM Employee e;

	
	--Create a function to determine a two week pay check of an individual employee.
    
GO
CREATE FUNCTION fx_biweeklypay
(	
	@HourlyPayRate money
)
RETURNS money
AS
	BEGIN
		RETURN @HourlyPayRate * 80
	END

GO
SELECT dbo.fx_biweeklypay
(
	[EmployeeHourlyPayRate]
)
	as [Biweekly]
	FROM EmployeePosition ep;
	
	--Create a function to determine a hourly rate for a new employee. Take difference between top and bottom 
	--pay for the new employees position (say driver) and then subtract the difference from the maximum pay. 
	--(and yes this is very arbitrary).


DROP TABLE ##PayRates
GO
CREATE TABLE ##PayRates
(
	Maximum money,
	Minimum money,
	Diff money,
	Position int
)


INSERT INTO ##PayRates(Maximum, Minimum, Diff, Position)
SELECT MAX(ep.EmployeeHourlyPayRate), MIN(ep.EmployeeHourlyPayRate), 
	(MAX(ep.EmployeeHourlyPayRate) - MIN(ep.EmployeeHourlyPayRate)), ep.PositionKey
	FROM dbo.EmployeePosition ep
	GROUP BY PositionKey;

GO

SELECT * FROM ##PayRates;

SELECT * FROM 

GO
CREATE FUNCTION fx_newpayrate
(
	@Maximum money,
	@Minimum money,
	@Diff money,
	@Position int
)
RETURNS money
AS
	BEGIN
		DECLARE @NewRate money
		BEGIN
			SET @NewRate = @Maximum - @Diff
		END
		RETURN @NewRate
	END;
GO

SELECT dbo.fx_newpayrate
(
	[Maximum],
	[Minimum],
	[Diff],
	[Position]
)
	as [NewPayRate]
	FROM ##PayRates pr
	WHERE [Position] = 3;