Use Community_Assist;

Select * from Person;

Create database TestTables;

USE TestTables;

Create table Student
(
	StudentKey int identity(1,1) primary key,
	StudentLastName nvarchar(255) not null,
	StudentFirstName nvarchar(255) null,
	StudentEmail nvarchar(255) not null,

)

CREATE table Course
(
	CourseKey int identity(1,1) primary key,
	CourseName nvarchar(255) not null,
	CourseCredits int default 5 not null,
)

CREATE table Section
(
	SectionKey int identity(1,1),
	CourseKey int not null foreign key references Course(CourseKey),
	SectionYear int not null,
	SectionQuarter nvarchar(6),
	Constraint constraint_quarter check (SectionQuarter in ('Fall', 'Winter', 'Spring', 'Summer')),
	Constraint PK_SectionKey primary key (SectionKey),
)

Create table Roster
(
	RosterKey int identity (1,1) not null,
	SectionKey int not null,
	StudentKey int not null,
	RosterGrade decimal(2,1) null,

)

ALTER table Roster
Add Constraint PK_Roster primary key (RosterKey);

ALTER table Roster
Add Constraint FK_Section foreign key (SectionKey)
references Section(SectionKey);

ALTER table Roster
Add Constraint FK_Student foreign key (StudentKey)
references Student(StudentKey);

ALTER table Roster
Add Constraint ck_Gade Check (RosterGrade between 0 and 4); 

ALTER table Student
Add Constraint unique_email unique(StudentEmail);

ALTER table Student 
Add StudentId nvarchar(9);

ALTER table Student
Drop column StudentId;