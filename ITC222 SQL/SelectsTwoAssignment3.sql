--Alias all calculated fields

USE MetroAlt

    --List the years in which employees were hired, sort by year and then last name.
SELECT EmployeeHireDate, EmployeeLastName, EmployeeFirstName
FROM Employee
ORDER BY EmployeeHireDate, EmployeeLastName;


    --What is the difference in Months between the first employee hired and the last one.
SELECT DateDiff(Month, Min(EmployeeHireDate), Max(EmployeeHireDate)) as difference
FROM Employee;


    --Output the employee phone number so it looks like (206)555-1234.
SELECT '(' +
SUBSTRING(EmployeePhone, 1, 3) + ') ' + 
SUBSTRING(EmployeePhone, 4, 3) + '-' + 
SUBSTRING(EmployeePhone, 7, 4) AS Phone
FROM Employee;

    --Output the employee hourly wage so it looks like $45.00 (EmployeePosition).
SELECT format(EmployeeHourlyPayRate, '#0.00') AS Hourly
FROM EmployeePosition;

    --List only the employees who were hired between 2013 and 2015.
SELECT EmployeeLastName, EmployeeFirstName, EmployeeHireDate 
FROM Employee
WHERE 2013 <= DATEPART(year, EmployeeHireDate) 
AND DATEPART(year, EmployeeHireDate) <= 2015;


    --Output the position, the hourly wage and the hourly wage multiplied by 40 to see 
	--what a weekly wage might look like.
SELECT PositionKey, EmployeeHourlyPayRate, (EmployeeHourlyPayRate * 40) as Weekly
FROM EmployeePosition;


    --What is the highest hourly pay rate (EmployeePosition)?
SELECT MAX(EmployeeHourlyPayRate)
FROM EmployeePosition;


    --What is the lowest hourly pay rate?
SELECT MIN(EmployeeHourlyPayRate)
FROM EmployeePosition;


    --What is the average hourly pay rate?
SELECT AVG(EmployeeHourlyPayRate)
FROM EmployeePosition;


    --What is the average pay rate by position?
SELECT FORMAT(Avg(EmployeeHourlyPayRate),'$#0.00') as Average
 from EmployeePosition
GROUP BY PositionKey;



    --Provide a count of how many employees were hired each year and each month of the year.
SELECT YEAR(EmployeeHireDate) AS Year, 
MONTH(EmployeeHireDate) AS Month, 
COUNT(EmployeeHireDate) AS Total
FROM Employee
GROUP BY MONTH(EmployeeHireDate), YEAR(EmployeeHireDate);



    --Do the query 11 again but with a case structure to output the months as words.
SELECT YEAR(EmployeeHireDate) AS [Year], 
DATENAME(MONTH, EmployeeHireDate) AS [Month],
COUNT(EmployeeHireDate) AS [Total]
FROM Employee
GROUP BY DATENAME(MONTH, EmployeeHireDate), YEAR(EmployeeHireDate);


    --Return which positions average more than $50 an hour.
SELECT PositionKey, AVG(EmployeeHourlyPayRate) AS Average
FROM EmployeePosition
GROUP BY PositionKey;


    --List the total number of riders on Metroalt busses (RiderShip).
SELECT SUM(Riders) AS Total
FROM Ridership;


    --List all the tables in the metroAlt databases (system views).
SELECT * FROM sys.Tables;


    --List all the databases on server.
SELECT * FROM sys.databases;