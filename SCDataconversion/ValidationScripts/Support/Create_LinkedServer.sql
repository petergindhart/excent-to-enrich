/****** Object:  LinkedServer [10.0.1.8\SQLSERVER2005]    Script Date: 02/07/2014 05:19:34 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'10.0.1.8\SQLSERVER2005', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'10.0.1.8\SQLSERVER2005',@useself=N'False',@locallogin=NULL,@rmtuser=N'muthuv',@rmtpassword='########'

GO

EXEC master.dbo.sp_serveroption @server=N'10.0.1.8\SQLSERVER2005', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'10.0.1.8\SQLSERVER2005', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'10.0.1.8\SQLSERVER2005', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'10.0.1.8\SQLSERVER2005', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'10.0.1.8\SQLSERVER2005', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'10.0.1.8\SQLSERVER2005', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'10.0.1.8\SQLSERVER2005', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'10.0.1.8\SQLSERVER2005', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'10.0.1.8\SQLSERVER2005', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'10.0.1.8\SQLSERVER2005', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'10.0.1.8\SQLSERVER2005', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'10.0.1.8\SQLSERVER2005', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'10.0.1.8\SQLSERVER2005', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


