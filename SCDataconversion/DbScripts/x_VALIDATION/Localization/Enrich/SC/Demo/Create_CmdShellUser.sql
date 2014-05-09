--CREATE xp_cmdShell Proxy account

--!!Change the Username and Password!!!
IF EXISTS(SELECT * FROM sys.credentials where name = '##xp_cmdshell_proxy_account##')
DROP CREDENTIAL ##xp_cmdshell_proxy_account##
GO
CREATE CREDENTIAL ##xp_cmdshell_proxy_account## WITH IDENTITY = 'username',
SECRET = 'Password'
GO

--Create login
IF EXISTS(SELECT * FROM sys.syslogins WHERE name = 'cmdshelluser')
DROP LOGIN cmdshelluser
GO
CREATE LOGIN [cmdshelluser] WITH PASSWORD=N'vc3123!!', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE master
GO
IF EXISTS(SELECT * FROM sys.sysusers WHERE name = 'cmdshelluser')
DROP USER cmdshelluser
GO
CREATE USER [cmdshelluser] FOR LOGIN [cmdshelluser] WITH DEFAULT_SCHEMA=[dbo]
GO
GRANT EXEC ON xp_cmdshell TO cmdshelluser;
GO

USE Enrich_DCB8_SC_Demo
GO
IF EXISTS(SELECT * FROM sys.sysusers WHERE name = 'cmdshelluser')
DROP USER cmdshelluser
GO
CREATE USER [cmdshelluser] FOR LOGIN [cmdshelluser] WITH DEFAULT_SCHEMA=[dbo]
GO