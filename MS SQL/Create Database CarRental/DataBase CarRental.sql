CREATE DATABASE CarRental 

USE CarRental


CREATE TABLE Categories 
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	CategoryName VARCHAR(50) NOT NULL,
	DailyRate DECIMAL(10,2) NULL,
	WeeklyRate DECIMAL(10,2) NULL,
	MonthlyRate DECIMAL(10,2) NULL,
	WeekendRate  DECIMAL(10,2) NULL
) 

INSERT INTO Categories
	VALUES
	('Sedan',1.20,13.1,11.0,6.11),
	('Combi',NULL,NULL,NULL,NULL),
	('SUV',1.2,1.6,7.1,NULL)

CREATE TABLE Cars 
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	PlateNumber VARCHAR(50) NOT NULL,
	Manufacturer VARCHAR(50) NOT NULL,
	Model VARCHAR(50) NOT NULL,
	CarYear INT NOT NULL,
	CategoryId INT 
	FOREIGN KEY REFERENCES Categories(id),
	Doors INT NULL,
	Picture IMAGE NULL,
	Condition VARCHAR(10) NULL,
	Available BIT NULL
) 

INSERT INTO Cars
	VALUES
	('SF1246KK','BMW','525',2000,1,4,NULL,'NO',0),
	('PL1345AA','VW','GOLF',2001,3,4,NULL,'Yes',1),
	('SF3111KA','BMW','520',2015,2,4,NULL,'NO',1)


CREATE TABLE Employees
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Title VARCHAR(50	) NULL,
	Notes VARCHAR(MAX) NULL
) 


INSERT INTO Employees
	VALUES
	('Radoslav', 'Valentinov','Make a Car',NULL),
	('Gosho', 'Cakov','Drive Car',NULL),
	('Nadia', 'Hristova',NULL,NULL)


CREATE TABLE Customers 
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	DriverLicenceNumber VARCHAR(50) NOT NULL,
	FullName VARCHAR(50) NOT NULL,
	Address VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL,
	ZIPCode INT NULL,
	Notes VARCHAR(MAX) NULL
) 

INSERT INTO Customers
	VALUES
	('123SKF345','Gosho Cakev','Doiran 74','Plovdiv',4000,'To do Best Skills Driving'),
	('6453344666','Petia Ivanova','Gen.Stoletov 114','Sofia',1000,NULL),
	('S124566A2','Ivan Aleksandrov','27-june','Varna',NULL,NULL)


CREATE TABLE RentalOrders 
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	EmployeeId INT 
	FOREIGN KEY REFERENCES Employees(id),
	CustomerId INT
	FOREIGN KEY REFERENCES Customers(id),
	CarId INT
	FOREIGN KEY REFERENCES Cars(id),
	TankLevel DECIMAL(10,2) NOT NULL,
	KilometrageStart DECIMAL(10,2) NULL,
	KilometrageEnd DECIMAL(10,2) NULL,
	TotalKilometrage DECIMAL (10,2) NULL,
	StartDate DATE NULL,
	EndDate DATE NULL,
	TotalDays INT NULL,
	RateApplied DECIMAL(2,2) NULL,
	TaxRate DECIMAL(2,2) NULL,
	OrderStatus DECIMAL(2,2) NULL,
	Notes VARCHAR(MAX) NULL
) 

INSERT INTO RentalOrders
	VALUES
	(1,1,2,45.6,NULL,NULL,NULL,GETDATE(),GETDATE(),0,NULL,NULL,NULL,'Order is not aplayed'),
	(3,3,2,65.0,12345.2,12512.6,2500.50,NULL,GETDATE(),0,NULL,NULL,NULL,'Order is not aplayed'),
	(2,3,2,45.0,NULL,NULL,NULL,GETDATE(),GETDATE(),0,NULL,NULL,NULL,'Order is not aplayed')


	SELECT * FROM RentalOrders