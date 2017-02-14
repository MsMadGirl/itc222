USE MetroAlt;


    --This involves joining tables, then using a subquery. Return the employee key, last name and first name, position name and hourly 
	--rate for those employees receiving the maximum pay rate.
SELECT e.EmployeeKey, EmployeeLastName, EmployeeFirstname, p.PositionName, ep.EmployeeHourlyPayRate
FROM Employee e
	INNER JOIN EmployeePosition ep
	ON e.EmployeeKey = ep.EmployeeKey
		INNER JOIN  Position p
		ON ep.PositionKey = p.PositionKey
		WHERE ep.EmployeeHourlyPayRate = (Select Max(EmployeeHourlyPayRate) from EmployeePosition);

    --Use only subqueries to do this. Return the key, last name and first name of every employee who has the position name “manager.”
SELECT e.EmployeeKey, e.EmployeeLastName, e.EmployeeFirstName
FROM Employee e
WHERE e.EmployeeKey in
	(SELECT ep.EmployeeKey FROM EmployeePosition ep
	WHERE ep.PositionKey in 
		(SELECT p.PositionKey FROM Position p
		WHERE p.PositionName = 'Manager'));

    --This is very difficult. It combines regular aggregate functions, a scalar function, a cast, subqueries and a join. But it 
	--produces a useful result. The results should look like this: Use Ridership totals for the numbers. 
	--Columns in Ridership: RidershipKey, BusScheduleAssignmentKey, Riders
	--Columns in BusScheduleAssignment: BusScheduleAssignmentKey, BusDriverShift, EmployeeKey, BusScheduleAssignmentDate, BusKey
    --aggregatefunctions.png Year, Annual Total, Annual Average, Total, Percent
    --The Total  is the grand total for all the years. The Percent is Annual Total / Grand Total * 100
SELECT DatePart(Year,bsa.BusScheduleAssignmentDate) AS Year, (SUM(r.Riders) GROUP BY DatePart(Year,bsa.BusScheduleAssignmentDate)) AS Annual Total,
AVG(r.Riders) as Annual Average, SUM(r.Riders) as Total, CAST((SUM(r.Riders) GROUP BY DatePart(Year,bsa.BusScheduleAssignmentDate) / SUM(r.Riders) * 100) AS real) AS Percent
	FROM BusScheduleAssignment bsa 
	INNER JOIN Ridership r
		ON r.Riders
			WHERE r.BusScheduleAssignmentKey = bsa.BusScheduleAssignmentKey 
			WHERE (SELECT DatePart(Year,bsa.BusScheduleAssignmentDate) 
			FROM BusScheduleAssignment bsa);

    --Create a new table called EmployeeZ. It should have the following structure:
    --EmployeeKey int,
    --EmployeeLastName nvarchar(255),
    --EmployeeFirstName nvarchar(255),
    --EmployeeEmail Nvarchar(255)
CREATE TABLE EmployeeZ
(
	EmployeeKey int identity(1,1) primary key,
	EmployeeLastname nvarchar(255) not null,
	EmployeeFirstName nvarchar(255) not null,
	EmployeeEmail nvarchar(255) not null,
);

    --Use an insert with a subquery to copy all the employees from the employee table whose last name starts with “Z.”
    --This is a correlated subquery. Return the position key, the employee key and the hourly pay rate for those employees 
	--who are receiving the highest pay in their positions. Order it by position key.
INSERT INTO EmployeeZ (EmployeeLastName, EmployeeFirstName, EmployeeEmail)
SELECT EmployeeLastName, EmployeeFirstName, EmployeeEmail 
FROM Employee WHERE EmployeeLastName LIKE 'Z%';--Cannot insert explicit value for identity column in table 'EmployeeZ' when IDENTITY_INSERT is set to OFF.

SELECT * FROM EmployeeZ



SELECT * FROM Ridership;
SELECT * FROM BusScheduleAssignment;