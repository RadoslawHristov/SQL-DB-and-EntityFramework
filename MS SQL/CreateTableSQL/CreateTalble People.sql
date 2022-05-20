USE Minions

CREATE TABLE People
(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[NAME] NVARCHAR(200) NOT NULL,
	Picture IMAGE NULL,
	Height DECIMAL(10,2) NULL,
	[Weight]  DECIMAL(10,2) NULL,
	Gender VARCHAR(10) NOT NULL,
	Birthdate DATETIME2 NOT NULL,
	Biography  NVARCHAR(MAX) NULL
)

INSERT INTO People
	VALUES
	('Kevin','https://avatars.githubusercontent.com/u/81433482?v=4',12.5,2.1,'m',GETDATE(),'I am Kevin'),
	('Chan','https://avatars.githubusercontent.com/u/81433482?v=4',10.5,2.1,'m',GETDATE(),'NULL'),
	('Jasmin','https://avatars.githubusercontent.com/u/81433482?v=4',NULL,2.0,'f',GETDATE(),'NULL'),
	('Nikol','https://avatars.githubusercontent.com/u/81433482?v=4',10.1,NULL,'f',GETDATE(),'I am Nikol'),
	('Stive','https://avatars.githubusercontent.com/u/81433482?v=4',8.5,1.1,'m',GETDATE(),'NULL')

	SELECT * FROM People

