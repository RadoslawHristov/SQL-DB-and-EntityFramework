CREATE DATABASE Hotel 

USE Hotel 

CREATE TABLE Employees 
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Title VARCHAR(50) NULL,
	Notes VARCHAR(MAX) NULL
) 

INSERT INTO Employees
	VALUES
	('Radoslav', 'Gushev',NULL,NULL),
	('Ico', 'Ivanov',NULL,NULL),
	('Pesho', 'Gushev','Apartment',NULL)


CREATE TABLE Customers 
(
	AccountNumber INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(20) NULL,
	EmergencyName VARCHAR(50) NULL,
	EmergencyNumber VARCHAR(50) NULL,
	Notes VARCHAR(MAX) NULL,
) 

INSERT INTO Customers
	VALUES
	('Raia','Spasova','9898991123',NULL,NULL,'Apartment is reserv'),
	('Ralica','Kunova','0811236745',NULL,NULL,NULL),
	('Desi','Todorova','1234567890',NULL,NULL,NULL)


CREATE TABLE RoomStatus 
(
	id	INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	RoomStatus BIT  NOT NULL,	
	Notes VARCHAR(MAX) NULL
) 

INSERT INTO RoomStatus
	VALUES
	(1,'Clean'),
	(1,'Not Clean'),
	(0,'Reserve')

CREATE TABLE RoomTypes 
(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	RoomType VARCHAR(50) NOT NULL,
	Notes VARCHAR(MAX) NULL
) 

INSERT INTO RoomTypes
	VALUES
	('Apartment','One bed two member'),
	('VIP Apartment',NULL),
	('Mesonet',NULL)

CREATE TABLE BedTypes 
(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	BedType VARCHAR(50) NOT NULL,
	Notes VARCHAR(MAX)  NULL
) 

INSERT INTO BedTypes
	VALUES
	('One Bed',NULL),
	('Bedroom',NULL),
	('Prista',NULL)


CREATE TABLE Rooms 
(
	RoomNumber INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	RoomType INT
	FOREIGN KEY REFERENCES RoomTypes(id),
	BedType INT
	FOREIGN KEY REFERENCES BedTypes(id),
	Rate DECIMAL(10,2) NULL,
	RoomStatus INT
	FOREIGN KEY REFERENCES RoomStatus(id),
	Notes VARCHAR(MAX) NULL
) 
INSERT INTO Rooms
	VALUES
	(2,3,10.6,1,NULL),
	(2,3,10.6,1,NULL),
	(2,3,10.6,1,NULL)

CREATE TABLE Payments 
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(id),
	PaymentDate DATE NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber),
	FirstDateOccupied DATE NULL,
	LastDateOccupied DATE NULL,
	TotalDays INT NULL,
	AmountCharged DECIMAL(10,2) NULL,
	TaxRate DECIMAL(10,2) NULL,
	TaxAmount DECIMAL(10,2) NULL,
	PaymentTotal DECIMAL(10,2) NULL,
	Notes VARCHAR(MAX)  NULL
) 

INSERT INTO Payments
	VALUES
	(1,GETDATE(),2,NULL,NULL,0,NULL,NULL,10.2,123.0,NULL),
	(3,GETDATE(),3,NULL,NULL,0,NULL,NULL,10.2,123.0,NULL),
	(2,GETDATE(),2,NULL,NULL,0,NULL,NULL,10.2,123.0,NULL)




CREATE TABLE Occupancies 
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES EmployeeS(id),
	DateOccupied DATE NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber),
	RoomNumber INT NULL,
	RateApplied DECIMAL(10,2) NULL,
	PhoneCharge VARCHAR(10) NULL,
	Notes VARCHAR(MAX) NULL
) 


INSERT INTO Occupancies
	VALUES
	(3,GETDATE(),2,213,11.4,'YES',NULL),
	(2,GETDATE(),1,213,10.4,'No',NULL),
	(1,GETDATE(),3,213,1.4,'YES',NULL)


	UPDATE Payments
		SET TaxRate = TaxRate-(TaxRate * 0.03);

		SELECT TaxRate FROM Payments



		DELETE  Occupancies
		SELECT * FROM Occupancies
