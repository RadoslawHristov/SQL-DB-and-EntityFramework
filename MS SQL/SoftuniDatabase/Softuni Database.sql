CREATE DATABASE Softuni

USE Softuni

CREATE TABLE Towns 
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
)

INSERT INTO Towns
	VALUES
	(' Sofia'),
	('Plovdiv'),
	('Varna'),
	('Burgas')


CREATE TABLE Addresses 
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	AddressText VARCHAR(50) NULL,
	TownId INT
	FOREIGN KEY REFERENCES Towns(id) NULL
) 


CREATE TABLE Departments 
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
) 

INSERT INTO Departments
	VALUES
	('Engineering'),
	('Sales'),
	('Marketing'),
	('Software Development'),
	('Quality Assurance')

CREATE TABLE Employees 
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	MiddleName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	JobTitle VARCHAR(50) NOT NULL,
	DepartmentId INT
	FOREIGN KEY REFERENCES Departments(id),
	HireDate DATETIME NOT NULL,
	Salary DECIMAL(10,2) NOT NULL,
	AddressId INT
	FOREIGN KEY REFERENCES Addresses(id)NULL
)

INSERT INTO Employees
	VALUES
	('Ivan','Ivanov','Ivanov','.NET Developer',4,01/02/2013,3500.00,NULL),
	('Petar','Petrov','Petrov','Senior Engineer',1,02/03/2004,4000.00,NULL),
	('Maria','Petrova','Ivanova','Intern',5,28/08/2016,525.25,NULL),
	('Georgi','Teziev','Ivanov','CEO',3,09/12/2007,3000.00,NULL),
	('Peter','Pan','Pan','Intern',3,28/08/2011,599.88,NULL)


	SELECT Name FROM Towns
		ORDER BY Name;
	
	SELECT NAME FROM Departments
		ORDER BY Name;

	SELECT FirstName, LastName, JobTitle, Salary FROM Employees
		ORDER BY Salary DESC;

		SELECT Salary * 1.1 FROM Employees
			



