USE Community_Assist;

--use temp table, # indicates temp
CREATE table #TempPerson
(
	PersonKey int,
	PersonLastName nvarchar(255),
	PersonFirstName nvarchar(255),
	PersonEmail nvarchar(255)
);

INSERT INTO #TempPerson(PersonKey, PersonLastName, PersonFirstName, PersonEmail)
SELECT PersonKey, PersonLastName, PersonFirstName, PersonEmail
FROM Person;

SELECT * from #TempPerson;

--temp table disappears when you close session, does not exist in other queries or sessions
--global temp will cross active sessions, indicated by ##
--other people logged into the db can see global temp
--disappears when all sessions close

CREATE table ##GlobalTempPerson
(
	PersonKey int,
	PersonLastName nvarchar(255),
	PersonFirstName nvarchar(255),
	PersonEmail nvarchar(255)
);

INSERT INTO ##GlobalTempPerson(PersonKey, PersonLastName, PersonFirstName, PersonEmail)
SELECT PersonKey, PersonLastName, PersonFirstName, PersonEmail
FROM Person;

	SELECT * from ##GlobalTempPerson;