
IF (Exists(SELECT * FROM sysobjects WHERE name = 'TestUsers' AND xtype = 'U'))
BEGIN
	DROP TABLE TestUsers
	DROP TABLE TestAgeGroup
	DROP TABLE TestUserType
END
GO

CREATE TABLE TestUsers
(
	ID int identity(1,1) PRIMARY KEY,
	Name nvarchar(255),
	UserType int DEFAULT (0),
	AgeGroup int DEFAULT (0)
)
CREATE TABLE TestAgeGroup
(
	ID int identity(1,1) PRIMARY KEY,
	AgeGroup int NOT NULL,
	AgeKey nvarchar(10) NOT NULL
)
CREATE TABLE TestUserType
(
	ID int identity(1,1) PRIMARY KEY,
	UserType int NOT NULL,
	UserTypeKey nvarchar(10) NOT NULL
)
GO

INSERT INTO TestAgeGroup VALUES (0, 'Old')
INSERT INTO TestAgeGroup VALUES (1, 'Young')
INSERT INTO TestUserType VALUES (0, 'Admin')
INSERT INTO TestUserType VALUES (1, 'Manager')
INSERT INTO TestUserType VALUES (2, 'Standard')

DECLARE @i INT
DECLARE @name NVARCHAR(255)
DECLARE @userType INT
DECLARE @ageGroup INT

SET @i = 100

WHILE (@i > 0)
BEGIN
	SET @name = 'user ' + CAST(@i AS nvarchar(10))
	IF (@i > 75) SET @userType = 1 ELSE SET @userType = 0
	IF (@i > 50) SET @ageGroup = 1 ELSE SET @ageGroup = 0
	INSERT INTO TestUsers VALUES (@name, @userType, @ageGroup)
	SET @i = @i - 1
END

