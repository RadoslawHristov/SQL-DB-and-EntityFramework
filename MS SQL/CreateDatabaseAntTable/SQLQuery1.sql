use Minions

CREATE TABLE People
(
	id int PRIMARY KEY IDENTITY (1,1),
	[Name] nvarchar(200) NOT NULL,
	Picture VARCHAR(MAX) NULL,
	height DECIMAL(15, 2) NULL,
	[weight] DECIMAL(15,2) NULL,
	Gender CHAR(1) NOT NULL,
	Birthdate DATETIME NOT NULL,
	Biography NVARCHAR(max) NULL
)

INSERT INTO People
VALUES

	('Radoslav','https://avatars.githubusercontent.com/u/9088813?v=4' ,3.23,2.16,'M',31/1/1986,'Programer'),
	('Jesica','https://avatars.githubusercontent.com/u/9088813?v=4' ,3.23,2.16,'F',1-3-1986,'Phones'),
	('Ico','https://avatars.githubusercontent.com/u/9088813?v=4' ,3.23,2.16,'M',1-3-2000,null),
	('Gosho','https://avatars.githubusercontent.com/u/9088813?v=4' ,3.23,2.16,'M',1-8-2010,'Programer'),
	('Ana','https://avatars.githubusercontent.com/u/9088813?v=4' ,3.23,2.16,'F',2-6-1999,null)
