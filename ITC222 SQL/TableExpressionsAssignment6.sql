USE MetroAlt;


    --Create a derived table that returns the position name as position and count of employees at that position. 
	--(I know that this can be done as a simple join, but do it in the format of a derived table. There still will 
	--be a join in the subquery portion).

SELECT * 
	FROM (SELECT PositionName AS [Position], (SELECT COUNT(EmployeeKey) FROM EmployeePosition) AS [Count]
		FROM Position p WHERE p.PositionKey IN (SELECT ep.PositionKey FROM EmployeePosition ep)) AS [Employee Count];

    --Create a derived table that returns a column HireYear and the count of employees who were hired that year. 
	--(Same comment as above).

SELECT *
	FROM (SELECT YEAR(EmployeeHireDate) AS [HireYear], COUNT(EmployeeHireDate) as [Number] FROM Employee 
	GROUP BY YEAR(EmployeeHireDate)) AS [HiredByYear];

    --Redo problem 1 as a Common Table Expression (CTE).

WITH EmployeeCount AS
	(
		Select PositionName AS [Position],
		(SELECT COUNT(EmployeeKey) FROM EmployeePosition) AS [Count]
		FROM Position p WHERE p.PositionKey IN (SELECT ep.PositionKey 
			FROM EmployeePosition ep)
	)
SELECT * FROM EmployeeCount;

    --Redo problem 2 as a CTE.

WITH HiredByYear AS
	(
		SELECT YEAR(EmployeeHireDate) AS [HireYear], 
		COUNT(EmployeeHireDate) as [Number] FROM Employee 
		GROUP BY YEAR(EmployeeHireDate)
	)
SELECT * FROM HiredByYear;

    --Create a CTE that takes a variable argument called @BusBarn and returns the count of busses grouped by the 
	--description of that bus type at a particular Bus barn. Set @BusBarn to 3.

DECLARE @BusBarn AS INT= 3;

WITH CountBusBarn AS
	(
		SELECT COUNT(BusBarnKey) AS [Count]
		FROM Bus
		WHERE BusBarnKey = @BusBarn
	)
SELECT * FROM CountBusBarn;

    --Create a View of Employees for Human Resources it should contain all the information in the Employee table 
	--plus their position and hourly pay rate

GO
DROP VIEW dbo.Employees_HR
GO
CREATE VIEW Employees_HR
AS
SELECT 
	e.EmployeeLastName, e.EmployeeFirstname, e.EmployeeAddress, 
	e.EmployeeCity, e.EmployeeZipCode, e.EmployeePhone, 
	e.EmployeeEmail, e.EmployeeHireDate, ep.EmployeeHourlyPayRate,
	p.PositionName
FROM Employee e
	INNER JOIN EmployeePosition ep
	ON e.EmployeeKey = ep.EmployeeKey
	INNER JOIN Position p
	ON ep.PositionKey = p.PositionKey;
GO

SELECT * FROM Employees_HR;

    --Alter the view in 6 to bind the schema

GO
ALTER VIEW [dbo].[Employees_HR] WITH SCHEMABINDING
AS
SELECT 
	e.EmployeeLastName, e.EmployeeFirstname, e.EmployeeAddress, 
	e.EmployeeCity, e.EmployeeZipCode, e.EmployeePhone, 
	e.EmployeeEmail, e.EmployeeHireDate, ep.EmployeeHourlyPayRate,
	p.PositionName
FROM dbo.Employee e
	INNER JOIN dbo.EmployeePosition ep
	ON e.EmployeeKey = ep.EmployeeKey
	INNER JOIN dbo.Position p
	ON ep.PositionKey = p.PositionKey;
GO

    --Create a view of the Bus Schedule assignment that returns the Shift times, The Employee first and last name, 
	--the bus route (key) and the Bus (key). Use the view to list the shifts for Neil Pangle in October of 2014

GO
DROP VIEW dbo.Schedule_Assignment
GO
CREATE VIEW dbo.Schedule_Assignment
AS
SELECT 
	bds.BusDriverShiftStartTime, bds.BusDriverShiftStopTime,
	e.EmployeeFirstName, e.EmployeeLastName,
	bsa.BusRouteKey, bsa.BusKey
FROM
	dbo.BusScheduleAssignment bsa
	INNER JOIN dbo.Employee e
	ON bsa.EmployeeKey = e.EmployeeKey
	INNER JOIN dbo.BusDriverShift bds
	ON bsa.BusDriverShiftKey = bds.BusDriverShiftKey;
GO

SELECT * FROM dbo.Schedule_Assignment
WHERE dbo.Schedule_Assignment.EmployeeLastName = 
'Pangle' AND dbo.Schedule_Assignment.EmployeeFirstname = 'Neil';


    --Create a table valued function that takes a parameter of city and returns all the employees who live in that city

USE MetroAlt;
DROP FUNCTION dbo.Employee_City;
GO
CREATE FUNCTION dbo.Employee_city
	(@city NVARCHAR(255)) RETURNS TABLE
AS
RETURN
	SELECT 
		e.EmployeeLastname, e.EmployeeFirstname, e.EmployeeCity
	FROM Employee e
	WHERE EmployeeCity = @city;
GO

SELECT * 
FROM dbo.Employee_City('Seattle');



    --Use the cross apply operator to return the last 3 routes driven by each driver

SELECT EmployeeKey, bsa.BusRouteKey, BusScheduleAssignmentDate
FROM BusScheduleAssignment bsa
	CROSS APPLY 
		(SELECT TOP (3) BusRouteKey, BusRouteZone
			FROM BusRoute as br
			WHERE br.BusRouteKey = bsa.BusRouteKey
			ORDER BY bsa.BusScheduleAssignmentDate DESC, bsa.EmployeeKey DESC) AS R;
