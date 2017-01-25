USE MetroAlt

CREATE table BusService
(
	BusServiceKey int identity(1,1) primary key,
	BusServiceName nvarchar(255) not null,
	BusServiceDescription nvarchar(255)
)

CREATE table Maintenaince
(
	MaintenanceKey int identity(1,1) primary key,
	MaintenanceDate date not null,
	BusKey int foreign key references Bus(BusKey) not null,
)

CREATE table MentainanceDetail
(
	MaintenanceDetailKey int identity(1,1),
	MaintenanceKey int not null,
	EmployeeKey int not null,
	BusServiceKey int not null,
	MaintenanceNotes nvarchar(255)
)

ALTER table MentainanceDetail
ADD Constraint PK_MentainanceDetail primary key (MaintenanceDetailKey);

ALTER table MentainanceDetail
ADD Constraint FK_Maintainance foreign key (MaintenanceKey)
references Maintenaince(MaintenanceKey);

ALTER table MentainanceDetail
ADD Constraint FK_BusService foreign key (BusServiceKey)
references BusService(BusServiceKey);

ALTER table BusType
ADD BusTypeAccessible bit;

ALTER table Employee
ADD constraint EmployeeEmail unique(EmployeeEmail);