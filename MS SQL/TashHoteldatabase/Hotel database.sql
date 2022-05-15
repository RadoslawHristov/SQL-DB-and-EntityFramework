

--Id, FirstName, LastName, Title, Notes
CREATE TABLE Employees 
(
	id INT NOT NULL IDENTITY(1,1) PRIMARY KEY ,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Title VARCHAR(50) NULL,
	Notes VARCHAR(MAX) NULL,
)

INSERT INTO Employees
	VALUES
    ('Radoslav','Hristov', 'Weckend Room',NULL),
	('Asen','Popov', 'One Room',NULL),
	('Silvia','Georgieva', 'Vip Room','tHE ROOM 2 bed and balkony')

--AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes

CREATE TABLE Customers 
(
	AccountNumber INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	PhoneNumber INT NOT NULL,
	EmergencyName  VARCHAR(50) NULL,
	EmergencyNumber INT NULL,
	Notes VARCHAR(MAX) NULL
)

INSERT INTO Customers
	VALUES
	('Gosho','Ivanov',0888899192,NULL,NULL,null),
	('kALOIAN','Shopov',0999123446,'Park Lake',123344566,null),
	('Gosho','Simov',0888899192,NULL,NULL,null)


--(RoomStatus, Notes
CREATE TABLE RoomStatus
(
	RoomStatus VARCHAR(50) PRIMARY KEY NOT NULL,
	Notes VARCHAR(MAX) NULL
)

INSERT INTO RoomStatus
	VALUES
	('FREE',NULL),
	('BUSY',NULL),
	('Not Information',null)

--RoomType, Notes
CREATE TABLE RoomTypes
(
	RoomType VARCHAR(50) PRIMARY KEY NOT NULL,
	Notes VARCHAR(50) NULL
)

INSERT INTO RoomTypes
	VALUES
	('Apartment','One bed'),
	('Vip Apartment',NULL),
	('ONE',NULL)

--BedType, Notes
CREATE TABLE BedTypes
(
	BedType VARCHAR(50) PRIMARY KEY NOT NULL,
	Notes VARCHAR(MAX) NULL,
)


INSERT INTO BedTypes
	VALUES
	('Single',NULL),
	('Double',NULL),
	('BedRoom',NULL)


--(RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes
CREATE TABLE Rooms
(
	RoomNumber INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	RoomType VARCHAR(50)
	FOREIGN KEY (RoomType) REFERENCES RoomTypes(RoomType),
	BedType varchar(50)
	FOREIGN KEY (BedType) REFERENCES BedTypes(BedType),
	Rate DECIMAL(2,2) NULL,
	RoomStatus VARCHAR(50)
	FOREIGN KEY (RoomStatus) REFERENCES RoomStatus(RoomStatus),
	Notes VARCHAR(MAX) NULL
)
INSERT INTO Rooms
	VALUES
	(2,1,12.2,3,NULL),
	(3,2,8.2,1,NULL),
	(1,3,2.2,2,NULL)

--(Id, EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes) 

CREATE TABLE Payments
(
	id INT  PRIMARY KEY IDENTITY(1,1) NOT NULL,
	EmployeeId INT
	FOREIGN KEY (EmployeeId) REFERENCES Employees(id),
	PaymentDate DATE NULL,
	AccountNumber INT
	FOREIGN KEY (AccountNumber) REFERENCES Customers(AccountNumber),
	FirstDateOccupied DATE NULL,
	LastDateOccupied DATE NULL,
	TotalDays INT NULL,
	AmountCharged DECIMAL(10,2) NULL,
	TaxRate DECIMAL(2,2) NULL,
	TaxAmount DECIMAL(10,2) NULL,
	PaymentTotal DECIMAL(10,2) NULL,
	Notes VARCHAR(MAX) NULL,
)
--(Id, EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes) 
INSERT INTO Payments
		VALUES
		(1,null,10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
		(1,null,10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
		(1,null,10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
		

--Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes

CREATE TABLE Occupancies
(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	EmployeeId INT
	FOREIGN KEY (EmployeeId) REFERENCES Employees(id),
	DateOccupied DATE NULL,
	AccountNumber INT
	FOREIGN KEY (AccountNumber) REFERENCES Customers(AccountNumber),
	RoomNumber INT 
	FOREIGN KEY (RoomNumber) REFERENCES Rooms(RoomNumber),
	RateApplied DECIMAL(2,2) NULL,
	PhoneCharge VARCHAR(50) NULL,
	Notes VARCHAR(MAX) NULL
) 


INSERT INTO Occupancies
	VALUES
	(1,null,100,2,NULL,'YES',NULL),
	(3,null,100,3,NULL,'YES',NULL),
	(1,null,100,1,NULL,'YES',NULL)
