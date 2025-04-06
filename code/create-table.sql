CREATE SCHEMA dbo;
-- u_sarba.dbo.CourseOrderLog definition

-- Drop table

-- DROP TABLE u_sarba.dbo.CourseOrderLog;

CREATE TABLE CourseOrderLog (
	LogID int IDENTITY(1,1) NOT NULL,
	OrderDetailsID int NOT NULL,
	CourseID int NOT NULL,
	BuyPrice money NOT NULL,
	LogTimestamp datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__CourseOr__5E5499A80C991AE1 PRIMARY KEY (LogID)
);


-- u_sarba.dbo.EmployeeTypes definition

-- Drop table

-- DROP TABLE u_sarba.dbo.EmployeeTypes;

CREATE TABLE EmployeeTypes (
	EmployeeTypeID int IDENTITY(1,1) NOT NULL,
	EmployeeTypeName varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT EmployeeTypes_pk PRIMARY KEY (EmployeeTypeID)
);
ALTER TABLE u_sarba.dbo.EmployeeTypes WITH NOCHECK ADD CONSTRAINT CHK_EmployeeTypeName_Length CHECK ((len(ltrim(rtrim([EmployeeTypeName])))>=(3)));
ALTER TABLE u_sarba.dbo.EmployeeTypes WITH NOCHECK ADD CONSTRAINT CHK_EmployeeTypeName_Alphanumeric CHECK ((NOT [EmployeeTypeName] like '%[^A-Za-z0-9 ]%'));


-- u_sarba.dbo.Languages definition

-- Drop table

-- DROP TABLE u_sarba.dbo.Languages;

CREATE TABLE Languages (
	LanguageID int IDENTITY(1,1) NOT NULL,
	LanguageName varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT Languages_pk PRIMARY KEY (LanguageID)
);
ALTER TABLE u_sarba.dbo.Languages WITH NOCHECK ADD CONSTRAINT CHK_LanguageName_Alphabetic CHECK ((NOT [LanguageName] like '%[^A-Za-z ]%'));
ALTER TABLE u_sarba.dbo.Languages WITH NOCHECK ADD CONSTRAINT CHK_LanguageName_Length CHECK ((len(ltrim(rtrim([LanguageName])))>=(2)));


-- u_sarba.dbo.OrderCourses definition

-- Drop table

-- DROP TABLE u_sarba.dbo.OrderCourses;

CREATE TABLE OrderCourses (
	OrderDetailsID int NOT NULL,
	CourseID int NOT NULL,
	BuyPrice money DEFAULT 0.0 NOT NULL,
	CONSTRAINT OrderCourses_pk PRIMARY KEY (OrderDetailsID)
);
ALTER TABLE u_sarba.dbo.OrderCourses WITH NOCHECK ADD CONSTRAINT CHK_BuyPrice_Positive CHECK (([BuyPrice]>=(0)));
ALTER TABLE u_sarba.dbo.OrderCourses WITH NOCHECK ADD CONSTRAINT CHK_CourseID_Positive CHECK (([CourseID]>(0)));


-- u_sarba.dbo.OrderDetails definition

-- Drop table

-- DROP TABLE u_sarba.dbo.OrderDetails;

CREATE TABLE OrderDetails (
	OrderDetailsID int IDENTITY(1,1) NOT NULL,
	OrderID int NOT NULL,
	PaymentDate datetime NULL,
	CONSTRAINT PK__OrderDet__9DD74D9D8D9D35CD PRIMARY KEY (OrderDetailsID)
);
ALTER TABLE u_sarba.dbo.OrderDetails WITH NOCHECK ADD CONSTRAINT CHK_OrderID_Positive CHECK (([OrderID]>(0)));


-- u_sarba.dbo.Reunions definition

-- Drop table

-- DROP TABLE u_sarba.dbo.Reunions;

CREATE TABLE Reunions (
	[Date] datetime NOT NULL,
	ReunionID int IDENTITY(1,1) NOT NULL,
	ReunionName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT Reunions_pk PRIMARY KEY (ReunionID)
);


-- u_sarba.dbo.Students definition

-- Drop table

-- DROP TABLE u_sarba.dbo.Students;

CREATE TABLE Students (
	StudentID int IDENTITY(1,1) NOT NULL,
	FirstName varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	LastName varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Address varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CityID int NOT NULL,
	Zip varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Phone varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Email varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT Students_pk PRIMARY KEY (StudentID)
);
ALTER TABLE u_sarba.dbo.Students WITH NOCHECK ADD CONSTRAINT CHK_Email_Format CHECK (([Email] like '%_@__%.__%'));


-- u_sarba.dbo.Translators definition

-- Drop table

-- DROP TABLE u_sarba.dbo.Translators;

CREATE TABLE Translators (
	TranslatorID int IDENTITY(1,1) NOT NULL,
	FirstName varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	LastName varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	HireDate date NULL,
	BirthDate date NULL,
	Phone varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Email varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT Translators_pk PRIMARY KEY (TranslatorID)
);
ALTER TABLE u_sarba.dbo.Translators WITH NOCHECK ADD CONSTRAINT CHK_BirthDate_LessThan_HireDate CHECK (([BirthDate]<=[HireDate]));


-- u_sarba.dbo.Employees definition

-- Drop table

-- DROP TABLE u_sarba.dbo.Employees;

CREATE TABLE Employees (
	EmployeeID int IDENTITY(1,1) NOT NULL,
	FirstName varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	LastName varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	HireDate date NULL,
	BirthDate date NULL,
	Phone varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Email varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	EmployeeTypeID int NOT NULL,
	CONSTRAINT Employees_pk PRIMARY KEY (EmployeeID),
	CONSTRAINT Employees_EmployeeTypes FOREIGN KEY (EmployeeTypeID) REFERENCES EmployeeTypes(EmployeeTypeID)
);
ALTER TABLE u_sarba.dbo.Employees WITH NOCHECK ADD CONSTRAINT CHK_FirstName_Length CHECK ((len(ltrim(rtrim([FirstName])))>=(2)));
ALTER TABLE u_sarba.dbo.Employees WITH NOCHECK ADD CONSTRAINT CHK_LastName_Length CHECK ((len(ltrim(rtrim([LastName])))>=(2)));
ALTER TABLE u_sarba.dbo.Employees WITH NOCHECK ADD CONSTRAINT CHK_HireDate_After_BirthDate CHECK (([HireDate] IS NULL OR [BirthDate] IS NULL OR [HireDate]>[BirthDate]));
ALTER TABLE u_sarba.dbo.Employees WITH NOCHECK ADD CONSTRAINT CHK_BirthDate_Adult CHECK (([BirthDate] IS NULL OR [BirthDate]<=dateadd(year,(-18),getdate())));


-- u_sarba.dbo.Orders definition

-- Drop table

-- DROP TABLE u_sarba.dbo.Orders;

CREATE TABLE Orders (
	OrderID int IDENTITY(1,1) NOT NULL,
	StudentID int NOT NULL,
	Payment money NULL,
	OrderDate datetime NOT NULL,
	CONSTRAINT Orders_pk PRIMARY KEY (OrderID),
	CONSTRAINT Orders_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
ALTER TABLE u_sarba.dbo.Orders WITH NOCHECK ADD CONSTRAINT CHK_Payment_Positive CHECK (([Payment] IS NULL OR [Payment]>=(0)));


-- u_sarba.dbo.Studies definition

-- Drop table

-- DROP TABLE u_sarba.dbo.Studies;

CREATE TABLE Studies (
	StudyID int IDENTITY(1,1) NOT NULL,
	StudyName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	StudyDescription text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	StudyPrice money NOT NULL,
	StudyCoordinator int NOT NULL,
	PriceIncrease money NOT NULL,
	CONSTRAINT Studies_pk PRIMARY KEY (StudyID),
	CONSTRAINT Studies_Employees FOREIGN KEY (StudyCoordinator) REFERENCES Employees(EmployeeID)
);
ALTER TABLE u_sarba.dbo.Studies WITH NOCHECK ADD CONSTRAINT CHK_StudyPrice_Positive CHECK (([StudyPrice]>=(0)));
ALTER TABLE u_sarba.dbo.Studies WITH NOCHECK ADD CONSTRAINT CHK_PriceIncrease_Positive CHECK (([PriceIncrease]>=(0)));
ALTER TABLE u_sarba.dbo.Studies WITH NOCHECK ADD CONSTRAINT CHK_StudyCoordinator_Positive CHECK (([StudyCoordinator]>(0)));
ALTER TABLE u_sarba.dbo.Studies WITH NOCHECK ADD CONSTRAINT CHK_StudyName_NotEmpty CHECK ((ltrim(rtrim([StudyName]))<>''));


-- u_sarba.dbo.TranslatorLanguages definition

-- Drop table

-- DROP TABLE u_sarba.dbo.TranslatorLanguages;

CREATE TABLE TranslatorLanguages (
	TranslatorID int NOT NULL,
	LanguageID int NOT NULL,
	CONSTRAINT TranslatorLanguages_pk PRIMARY KEY (TranslatorID,LanguageID),
	CONSTRAINT TranslatorLanguages_Languages FOREIGN KEY (LanguageID) REFERENCES Languages(LanguageID),
	CONSTRAINT TranslatorLanguages_Translators FOREIGN KEY (TranslatorID) REFERENCES Translators(TranslatorID)
);
ALTER TABLE u_sarba.dbo.TranslatorLanguages WITH NOCHECK ADD CONSTRAINT CHK_TranslatorID_Positive CHECK (([TranslatorID]>(0)));
ALTER TABLE u_sarba.dbo.TranslatorLanguages WITH NOCHECK ADD CONSTRAINT CHK_LanguageID_Positive CHECK (([LanguageID]>(0)));


-- u_sarba.dbo.Webinars definition

-- Drop table

-- DROP TABLE u_sarba.dbo.Webinars;

CREATE TABLE Webinars (
	WebinarID int IDENTITY(1,1) NOT NULL,
	TeacherID int NOT NULL,
	TranslatorID int NULL,
	WebinarName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	WebinarPrice money NULL,
	VideoLink varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	WebinarDate datetime NOT NULL,
	DurationTime time(0) NULL,
	WebinarDescription text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LanguageID int NULL,
	CONSTRAINT Webinars_pk PRIMARY KEY (WebinarID),
	CONSTRAINT Webinars_Employees FOREIGN KEY (TeacherID) REFERENCES Employees(EmployeeID),
	CONSTRAINT Webinars_Languages FOREIGN KEY (LanguageID) REFERENCES Languages(LanguageID),
	CONSTRAINT Webinars_Translators FOREIGN KEY (TranslatorID) REFERENCES Translators(TranslatorID)
);
ALTER TABLE u_sarba.dbo.Webinars WITH NOCHECK ADD CONSTRAINT CHK_WebinarPrice_Positive CHECK (([WebinarPrice]>=(0)));
ALTER TABLE u_sarba.dbo.Webinars WITH NOCHECK ADD CONSTRAINT CHK_VideoLink_NotEmpty CHECK ((len([VideoLink])>(0)));


-- u_sarba.dbo.Classes definition

-- Drop table

-- DROP TABLE u_sarba.dbo.Classes;

CREATE TABLE Classes (
	ClassID int IDENTITY(1,1) NOT NULL,
	StudyID int NOT NULL,
	CoordinatorID int NOT NULL,
	ClassName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ClassDescription text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT Classes_pk PRIMARY KEY (ClassID),
	CONSTRAINT Classes_Employees FOREIGN KEY (CoordinatorID) REFERENCES Employees(EmployeeID),
	CONSTRAINT Classes_Studies FOREIGN KEY (StudyID) REFERENCES Studies(StudyID)
);
ALTER TABLE u_sarba.dbo.Classes WITH NOCHECK ADD CONSTRAINT CHK_ClassName_Length CHECK ((datalength([ClassName])>=(3)));


-- u_sarba.dbo.Courses definition

-- Drop table

-- DROP TABLE u_sarba.dbo.Courses;

CREATE TABLE Courses (
	CourseID int IDENTITY(1,1) NOT NULL,
	CourseName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CourseDescription text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CoursePrice money NOT NULL,
	CoordinatorID int NOT NULL,
	CONSTRAINT Courses_pk PRIMARY KEY (CourseID),
	CONSTRAINT Courses_Employees FOREIGN KEY (CoordinatorID) REFERENCES Employees(EmployeeID)
);
ALTER TABLE u_sarba.dbo.Courses WITH NOCHECK ADD CONSTRAINT CHK_CoursePrice_Positive CHECK (([CoursePrice]>(0)));
ALTER TABLE u_sarba.dbo.Courses WITH NOCHECK ADD CONSTRAINT CHK_CoordinatorID_Positive CHECK (([CoordinatorID]>(0)));
ALTER TABLE u_sarba.dbo.Courses WITH NOCHECK ADD CONSTRAINT CHK_CourseName_Length CHECK ((len(ltrim(rtrim([CourseName])))>=(3)));


-- u_sarba.dbo.Internships definition

-- Drop table

-- DROP TABLE u_sarba.dbo.Internships;

CREATE TABLE Internships (
	InternshipID int IDENTITY(1,1) NOT NULL,
	StudyID int NOT NULL,
	BeginDate date NOT NULL,
	CONSTRAINT Interships_pk PRIMARY KEY (InternshipID),
	CONSTRAINT Interships_Studies FOREIGN KEY (StudyID) REFERENCES Studies(StudyID)
);
ALTER TABLE u_sarba.dbo.Internships WITH NOCHECK ADD CONSTRAINT CHK_StudyID_Positive CHECK (([StudyID]>(0)));


-- u_sarba.dbo.Modules definition

-- Drop table

-- DROP TABLE u_sarba.dbo.Modules;

CREATE TABLE Modules (
	ModuleID int IDENTITY(1,1) NOT NULL,
	CourseID int NOT NULL,
	TeacherID int NOT NULL,
	ModuleName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Date] date NOT NULL,
	DurationTime time(0) NULL,
	TranslatorID int NULL,
	LanguageID int NULL,
	[Limit] int NULL,
	Room varchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	VideoLink varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LiveLink varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT Modules_pk PRIMARY KEY (ModuleID),
	CONSTRAINT Modules_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
	CONSTRAINT Modules_Employees FOREIGN KEY (TeacherID) REFERENCES Employees(EmployeeID),
	CONSTRAINT Modules_Languages FOREIGN KEY (LanguageID) REFERENCES Languages(LanguageID),
	CONSTRAINT Modules_Translators FOREIGN KEY (TranslatorID) REFERENCES Translators(TranslatorID)
);
ALTER TABLE u_sarba.dbo.Modules WITH NOCHECK ADD CONSTRAINT CHK_ModuleName_Length CHECK ((len(ltrim(rtrim([ModuleName])))>=(2)));


-- u_sarba.dbo.OrderStudies definition

-- Drop table

-- DROP TABLE u_sarba.dbo.OrderStudies;

CREATE TABLE OrderStudies (
	OrderDetailsID int NOT NULL,
	StudyID int NOT NULL,
	GradeID int DEFAULT 0 NOT NULL,
	BuyPrice money DEFAULT 0.0 NOT NULL,
	GradeValue int NULL,
	CONSTRAINT OrderStudies_pk PRIMARY KEY (OrderDetailsID),
	CONSTRAINT OrderStudies_Studies FOREIGN KEY (StudyID) REFERENCES Studies(StudyID)
);
ALTER TABLE u_sarba.dbo.OrderStudies WITH NOCHECK ADD CONSTRAINT CHK_GradeValue_Range CHECK (([GradeValue] IS NULL OR [GradeValue]>=(2) AND [GradeValue]<=(5)));


-- u_sarba.dbo.OrderWebinars definition

-- Drop table

-- DROP TABLE u_sarba.dbo.OrderWebinars;

CREATE TABLE OrderWebinars (
	OrderDetailsID int NOT NULL,
	WebinarID int NOT NULL,
	BuyPrice money DEFAULT 0.0 NOT NULL,
	CONSTRAINT OrderWebinars_pk PRIMARY KEY (OrderDetailsID),
	CONSTRAINT OrderWebinars_Webinars FOREIGN KEY (WebinarID) REFERENCES Webinars(WebinarID)
);
ALTER TABLE u_sarba.dbo.OrderWebinars WITH NOCHECK ADD CONSTRAINT CHK_Webinars_BuyPrice_Positive CHECK (([BuyPrice]>=(0)));
ALTER TABLE u_sarba.dbo.OrderWebinars WITH NOCHECK ADD CONSTRAINT CHK_WebinarID_Positive CHECK (([WebinarID]>(0)));


-- u_sarba.dbo.StudyMeetings definition

-- Drop table

-- DROP TABLE u_sarba.dbo.StudyMeetings;

CREATE TABLE StudyMeetings (
	StudyMeetingID int IDENTITY(1,1) NOT NULL,
	ClassID int NOT NULL,
	TeacherID int NOT NULL,
	MeetingName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	MeetingPrice money NOT NULL,
	[Date] datetime NOT NULL,
	DurationTime time(0) NOT NULL,
	TranslatorID int NULL,
	LanguageID int NULL,
	Room varchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Limit] int NULL,
	VideoLink varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LiveLink varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ReunionID int NOT NULL,
	CONSTRAINT StudyMeetings_pk PRIMARY KEY (StudyMeetingID),
	CONSTRAINT StudyMeetings_Classes FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
	CONSTRAINT StudyMeetings_Employees FOREIGN KEY (TeacherID) REFERENCES Employees(EmployeeID),
	CONSTRAINT StudyMeetings_Languages FOREIGN KEY (LanguageID) REFERENCES Languages(LanguageID),
	CONSTRAINT StudyMeetings_Reunions FOREIGN KEY (ReunionID) REFERENCES Reunions(ReunionID),
	CONSTRAINT StudyMeetings_Translators FOREIGN KEY (TranslatorID) REFERENCES Translators(TranslatorID)
);
ALTER TABLE u_sarba.dbo.StudyMeetings WITH NOCHECK ADD CONSTRAINT CHK_MeetingPrice_Positive CHECK (([MeetingPrice]>(0)));
ALTER TABLE u_sarba.dbo.StudyMeetings WITH NOCHECK ADD CONSTRAINT CHK_Limit_Positive CHECK (([Limit]>=(0) OR [Limit] IS NULL));
ALTER TABLE u_sarba.dbo.StudyMeetings WITH NOCHECK ADD CONSTRAINT CHK_DurationTime_NotNull CHECK (([DurationTime] IS NOT NULL));
ALTER TABLE u_sarba.dbo.StudyMeetings WITH NOCHECK ADD CONSTRAINT CHK_Room_Length CHECK ((len([Room])<=(5) OR [Room] IS NULL));


-- u_sarba.dbo.WebinarDetails definition

-- Drop table

-- DROP TABLE u_sarba.dbo.WebinarDetails;

CREATE TABLE WebinarDetails (
	StudentID int NOT NULL,
	WebinarID int NOT NULL,
	AvailableUntil date NOT NULL,
	CONSTRAINT WebinarDetails_pk PRIMARY KEY (StudentID,WebinarID),
	CONSTRAINT WebinarDetails_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
	CONSTRAINT WebinarDetails_Webinars FOREIGN KEY (WebinarID) REFERENCES Webinars(WebinarID)
);


-- u_sarba.dbo.CourseDetails definition

-- Drop table

-- DROP TABLE u_sarba.dbo.CourseDetails;

CREATE TABLE CourseDetails (
	CourseID int NOT NULL,
	StudentID int NOT NULL,
	CONSTRAINT CourseDetails_pk PRIMARY KEY (CourseID,StudentID),
	CONSTRAINT CourseDetails_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
	CONSTRAINT CourseDetails_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);


-- u_sarba.dbo.InternshipDetails definition

-- Drop table

-- DROP TABLE u_sarba.dbo.InternshipDetails;

CREATE TABLE InternshipDetails (
	InternshipID int NOT NULL,
	StudentID int NOT NULL,
	IsDone bit NULL,
	CONSTRAINT IntershipDetails_pk PRIMARY KEY (InternshipID,StudentID),
	CONSTRAINT IntershipDetails_Interships FOREIGN KEY (InternshipID) REFERENCES Internships(InternshipID),
	CONSTRAINT IntershipDetails_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
ALTER TABLE u_sarba.dbo.InternshipDetails WITH NOCHECK ADD CONSTRAINT CHK_InternshipID_Positive CHECK (([InternshipID]>(0)));
ALTER TABLE u_sarba.dbo.InternshipDetails WITH NOCHECK ADD CONSTRAINT CHK_StudentID_Positive CHECK (([StudentID]>(0)));


-- u_sarba.dbo.ModuleDetails definition

-- Drop table

-- DROP TABLE u_sarba.dbo.ModuleDetails;

CREATE TABLE ModuleDetails (
	ModuleID int NOT NULL,
	StudentID int NOT NULL,
	IsPresent bit NOT NULL,
	CONSTRAINT ModuleDetails_pk PRIMARY KEY (ModuleID,StudentID),
	CONSTRAINT ModuleDetails_Modules FOREIGN KEY (ModuleID) REFERENCES Modules(ModuleID),
	CONSTRAINT ModuleDetails_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
ALTER TABLE u_sarba.dbo.ModuleDetails WITH NOCHECK ADD CONSTRAINT CHK_ModuleID_Positive CHECK (([ModuleID]>(0)));


-- u_sarba.dbo.OrderStudyMeetings definition

-- Drop table

-- DROP TABLE u_sarba.dbo.OrderStudyMeetings;

CREATE TABLE OrderStudyMeetings (
	OrderDetailsID int NOT NULL,
	StudyMeetingID int NOT NULL,
	BuyPrice money DEFAULT 0.0 NOT NULL,
	CONSTRAINT OrderStudyMeetings_pk PRIMARY KEY (OrderDetailsID),
	CONSTRAINT OrderStudyMeetings_StudyMeetings FOREIGN KEY (StudyMeetingID) REFERENCES StudyMeetings(StudyMeetingID)
);
ALTER TABLE u_sarba.dbo.OrderStudyMeetings WITH NOCHECK ADD CONSTRAINT CHK_Studies_BuyPrice_Positive CHECK (([BuyPrice]>=(0)));
ALTER TABLE u_sarba.dbo.OrderStudyMeetings WITH NOCHECK ADD CONSTRAINT CHK_StudyMeetingID_Positive CHECK (([StudyMeetingID]>(0)));
ALTER TABLE u_sarba.dbo.OrderStudyMeetings WITH NOCHECK ADD CONSTRAINT CHK_OrderDetailsID_Positive CHECK (([OrderDetailsID]>(0)));


-- u_sarba.dbo.StudyMeetingDetails definition

-- Drop table

-- DROP TABLE u_sarba.dbo.StudyMeetingDetails;

CREATE TABLE StudyMeetingDetails (
	StudyMeetingID int NOT NULL,
	StudentID int NOT NULL,
	IsPresent bit NULL,
	CONSTRAINT StudyMeetingDetails_pk PRIMARY KEY (StudyMeetingID,StudentID),
	CONSTRAINT StudyMeetingDetails_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
	CONSTRAINT StudyMeetingDetails_StudyMeetings FOREIGN KEY (StudyMeetingID) REFERENCES StudyMeetings(StudyMeetingID)
);