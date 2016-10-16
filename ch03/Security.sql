/*
	Script:		Security.sql
	Purpose:	Create a database for security examples
	Copyright:	BlueSyntax 2010
	Comments:	You may reuse, modify and distribute this code at will.
	
*/

-- ASSUMPTION: YOU MUST HAVE CREATED A DATABASE ALREADY.
--		If you are running in SQL Azure, connect to the master database and run a CREATE DATABASE statement
--		Then reconnect to the new database and run this script. 

IF ((SELECT DB_NAME()) = 'master')
BEGIN

	Print 'You should not be running this script on the master database.'
	Print 'You must be connected to a user database to run this script.'
	return
END

	-- DROP TABLE UserProperties 
	IF (NOT Exists(SELECT * FROM sys.sysobjects WHERE Name = 'UserProperties' AND Type = 'U'))
	CREATE TABLE UserProperties 
	(
		ID int identity(1,1) PRIMARY KEY,		-- identity of the record
		PropertyName nvarchar(255) NOT NULL,	-- name of the property
		Value varbinary(max) NOT NULL,			-- encrypted value
		Vector binary(16) NOT NULL,				-- vector of the encrypted value
		LastUpdated datetime NOT NULL,			-- date of last modification
		Token binary(32) NOT NULL				-- record hash
	)

	GO

	IF (Exists(SELECT * FROM sys.sysobjects WHERE Name = 'proc_SaveProperty' AND Type = 'P'))
		DROP PROC proc_SaveProperty

	GO

	-- SELECT * FROM UserProperties	
	CREATE PROC proc_SaveProperty
		@name nvarchar(255),
		@value varbinary(max),
		@vector binary(16),
		@lastUpdated datetime,
		@hash binary(32)
	AS

	IF (Exists(SELECT * FROM UserProperties WHERE PropertyName = @name))
	BEGIN
		UPDATE UserProperties SET
			Value = @value,
			Vector = @vector,
			LastUpdated = @lastUpdated,
			Token = @hash
		WHERE
			PropertyName = @name
	END
	ELSE
	BEGIN
		INSERT INTO UserProperties 
			(PropertyName, Value, Vector, LastUpdated, Token)
		VALUES (
			@name,
			@value,
			@vector,
			@lastUpdated,
			@hash )
	END
	

SELECT HASHBYTES('sha1', 'MySecret')


/*


-- 1 Create the schema with DBO ownership
CREATE SCHEMA MyReadOnlySchema AUTHORIZATION DBO

-- 2 Move the schema ownership of the table under the new schema
ALTER SCHEMA MyReadOnlySchema TRANSFER DBO.UserProperties

-- 3 Set the default schema of the user to the new schema
ALTER USER MyTestLoginUser WITH DEFAULT_SCHEMA = MyReadOnlySchema

-- 4 GRANT SELECT on the schema to the user
GRANT SELECT ON SCHEMA :: MyReadOnlySchema TO MyTestLoginUser

*/


