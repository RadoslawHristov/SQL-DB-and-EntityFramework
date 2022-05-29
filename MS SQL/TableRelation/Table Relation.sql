CREATE DATABASE TEST

USE TEST


CREATE TABLE Passports
(
	PassportID INT IDENTITY(101,1) PRIMARY KEY NOT NULL,
	PassportNumber VARCHAR(12) NOT NULL
)

CREATE TABLE Persons
(
	PersonID INT IDENTITY PRIMARY KEY NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	Salary DECIMAL(10,2) NULL,
	PassportID INT
	FOREIGN KEY REFERENCES Passports (PassportID)
)

INSERT INTO Passports
	VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')

INSERT INTO Persons
	VALUES

('Roberto',43300.00,102),
('Tom',56100.00,103),
('Yana',60200.00,101)

SELECT * FROM Persons
SELECT * FROM Passports



-----============One-To-Many Relationship =============



CREATE TABLE Manufacturers
(
	ManufacturerID INT IDENTITY PRIMARY KEY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	EstablishedOn DATE NOT NULL
)


CREATE TABLE Models
(
	ModelID INT IDENTITY(101,1) PRIMARY KEY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	ManufacturerID INT
	FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)



INSERT INTO Manufacturers
	VALUES
	('BMW','07-03-1916'),
	('Tesla','01-01-2003'),
	('Lada','01-05-1966')

INSERT INTO Models
	VALUES

('X1',1),
('i6',1),
('Model S',2),
('Model X',2),
('Model 3',2),
('Nova',3)


SELECT * FROM Manufacturers
SELECT * FROM Models


--============Many-To-Many Relationship==========

CREATE TABLE Students
(
	StudentID INT IDENTITY PRIMARY KEY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Exams
(
	ExamID INT IDENTITY(	101,1) PRIMARY KEY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE StudentsExams
(
	StudentID INT 
	FOREIGN KEY REFERENCES Students(StudentID),
	ExamID INT 
	FOREIGN KEY REFERENCES Exams (ExamID)
	PRIMARY KEY(	StudentID ,ExamID)
)

INSERT INTO Students
	VALUES
	('Mia'),
	('Toni'),
	('Ron')

INSERT INTO Exams
	VALUES
	('SpringMVC'),
	('Neo4j'),
	('Oracle 11g')


INSERT INTO StudentsExams
	VALUES
	(1,101),
	(1,102),
	(2,101),
	(3,103),
	(2,102),
	(2,103)


SELECT * FROM Students
SELECT * FROM Exams
SELECT * FROM StudentsExams

SELECT  [StudentID],[ExamID] FROM StudentsExams

--==========Self-Referencing  ===========

CREATE TABLE Teachers
(
	TeacherID INT PRIMARY KEY IDENTITY(101, 1) NOT NULL,
	[Name] VARCHAR(30) NOT NULL,
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers VALUES
('John', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101)


--===========05. Online Store Database============

CREATE DATABASE OnlineStore

USE OnlineStore

CREATE TABLE Orders
(
	OrderID INT IDENTITY PRIMARY KEY NOT NULL,
	CustomerID INT 
	FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE Customersr
(
	CustomerID INT IDENTITY PRIMARY KEY NOT NULL,
	[Name]  VARCHAR(50) NOT NULL,
	Birthday DATE NOT NULL,
	CityID INT 
	FOREIGN KEY REFERENCES Cities (CityID)
)

CREATE TABLE Cities
(
	CityID INT IDENTITY PRIMARY KEY NOT NULL,
	[Name]  VARCHAR(50) NOT NULL
)

CREATE TABLE OrderItems
(
	OrderID INT 
	FOREIGN KEY REFERENCES Orders(OrderID),
	ItemID INT
	FOREIGN KEY REFERENCES Items(ItemsID)
)

CREATE TABLE Items
(
	ItemsID INT IDENTITY PRIMARY KEY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	ItemTypeID INT 
	FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE ItemTypes
(
	ItemTypeID INT IDENTITY PRIMARY KEY NOT NULL,
	[Name]  VARCHAR(50) NOT NULL
)


--===========06. University Database==========

CREATE DATABASE University 

USE University


CREATE TABLE Majors
(
	MajorID INT IDENTITY PRIMARY KEY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Students
(
	StudentID INT IDENTITY PRIMARY KEY NOT NULL,
	StudentNumber INT NOT NULL,
	StudentName  VARCHAR(50) NOT NULL,
	MajorID INT 
	FOREIGN KEY REFERENCES MajorS(MajorID)
)

CREATE TABLE Payments
(
	PaymentID INT IDENTITY PRIMARY KEY NOT NULL,
	PaymentDate DATE NOT NULL,
	PaymentAmaunt DECIMAL(10,2) NOT NULL,
	StudentID INT 
	FOREIGN KEY REFERENCES Students(StudentID)
)

CREATE TABLE Subjects
(
	SubjectID INT IDENTITY PRIMARY KEY NOT NULL,
	SubjectName VARCHAR(50) NOT NULL
)

CREATE TABLE Agenda
(
	StudentID INT 
	FOREIGN KEY REFERENCES Students(StudentID),
	SubjectID int
	FOREIGN KEY REFERENCES Subjects(SubjectID)
	PRIMARY KEY (StudentID, SubjectID)
)

--=========09. *Peaks in Rila===========

USE Geography

SELECT MountainRange,
       PeakName,
       Elevation
FROM Peaks
     JOIN Mountains ON Peaks.MountainId = Mountains.Id
WHERE Peaks.MountainId =
(
    SELECT Id
    FROM Mountains
    WHERE MountainRange = 'Rila'
)
ORDER BY Peaks.Elevation DESC;