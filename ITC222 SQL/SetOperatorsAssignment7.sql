USE MetroAlt
    --Create a Union between Person and PersonAddress in Community assist and 
    --Employee in MetroAlt. You will need to fully qualify the tables in the 
    --CommunityAssist part of the query:
    --CommunityAssist.dbo.Person etc.
    
SELECT p.PersonFirstName, p.PersonLastName, EmployeeHireDate
FROM Community_Assist.dbo.Person p
	INNER JOIN MetroAlt.dbo.Employee e
	ON p.PersonEmail = e.EmployeeEmail
UNION
	SELECT EmployeeFirstName, EmployeeLastName, EmployeeHireDate
	FROM MetroAlt.dbo.Employee;

    --Do an intersect between the PersonAddress and Employee that returns the 
    --cities that are in both.

SELECT PersonAddressCity FROM Community_Assist.dbo.PersonAddress
INTERSECT
SELECT  EmployeeCity FROM MetroAlt.dbo.Employee;

    --Do an except between PersonAddress and Employee that returns the cities 
    --that are not in both.

SELECT PersonAddressCity FROM Community_Assist.dbo.PersonAddress
EXCEPT
SELECT  EmployeeCity FROM MetroAlt.dbo.Employee;

    --For this we will use the Data Tables we made in Assignment 1. Insert the 
    --following services into BusService: General Maintenance, Brake service, 
    --hydraulic maintenance, and Mechanical Repair. You can add descriptions if 
    --you like. Next add entries into the Maintenance table for busses 12 and 
    --24. You can use today’s date. For the details on 12 add General 
    --Maintenance and Brake Service, for 24 just General Maintenance. You can 
    --use employees 60 and 69 they are both mechanics.

INSERT INTO BusService(BusServiceName, BusServiceDescription)
	VALUES('General Maintenance', 'general maintenance duties'), ('Brake service', 'brake services'),
	('Hydraulic maintenance', 'hydraulic maintenance'), ('Mechanical repair', 'Mechanical repair');

SELECT * FROM BusService;

INSERT INTO Maintenaince(BusKey, MaintenanceDate)
	VALUES(12, GetDate()), (24, GetDate());

SELECT * FROM Maintenaince;

    --Create a table that has the same structure as Employee, name it Drivers. 
    --Use the Select form of an insert to copy all the employees whose position 
    --is driver (1) into the new table.

CREATE TABLE Drivers
(
EmployeeKey int PRIMARY KEY, 
EmployeeLastName nvarchar(255) not null,
EmployeeFirstName nvarchar(255) not null,
EmployeeAddress nvarchar(255) not null,
EmployeeCity nvarchar(255) not null,
EmployeeZipCode nchar(5) not null,
EmployeePhone nchar(10),
EmployeeEmail nvarchar(255) not null,
EmployeeHireDate date not null
);

INSERT INTO Drivers(
EmployeeKey, 
EmployeeLastName,
EmployeeFirstName,
EmployeeAddress,
EmployeeCity,
EmployeeZipCode,
EmployeePhone,
EmployeeEmail,
EmployeeHireDate)
	SELECT 
	e.EmployeeKey, 
	EmployeeLastName,
	EmployeeFirstName,
	EmployeeAddress,
	EmployeeCity,
	EmployeeZipCode,
	EmployeePhone,
	EmployeeEmail,
	EmployeeHireDate
	FROM Employee e
	INNER JOIN 
	EmployeePosition ep
	ON e.EmployeeKey = ep.EmployeeKey
	WHERE ep.PositionKey = 1;



    --Edit the record for Bob Carpenter (Key 3) so that his first name is 
    --Robert and is City is Bellevue

UPDATE Employee
SET EmployeeFirstName='Robert',EmployeeCity='Bellevue'
WHERE EmployeeKey=3;

    --Give everyone a 3% Cost of Living raise.

UPDATE EmployeePosition
SET EmployeeHourlyPayRate=(EmployeeHourlyPayRate + (EmployeeHourlyPayRate*.03));

    --Delete the position Detailer
SELECT * FROM Position;

DELETE FROM Position
WHERE PositionName='Detailer'; 