DECLARE @Server VARCHAR(150), @UserName VARCHAR(150), @Password VARCHAR(150);

SET @Server = (select ParamValue from x_DATAVALIDATION.ParamValues where ParamName = 'server');
SET @UserName = (select ParamValue from x_DATAVALIDATION.ParamValues where ParamName = 'EOdatabaseUserName');
SET @Password = (select ParamValue from x_DATAVALIDATION.ParamValues where ParamName = 'EOdatabasepwd');

IF EXISTS ( SELECT 1 FROM master.dbo.sysservers WHERE srvname = @Server )
BEGIN
EXEC master.dbo.sp_dropserver @Server, 'droplogins'
END

/****** Object:  LinkedServer [10.10.10.123]    Script Date: 02/25/2014 04:25:47 ******/
EXEC master.dbo.sp_addlinkedserver @server = @Server, @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=@Server,@useself=N'False',@locallogin=NULL,@rmtuser=@UserName,@rmtpassword=@Password

EXEC master.dbo.sp_serveroption @server=@Server, @optname=N'collation compatible', @optvalue=N'false'


EXEC master.dbo.sp_serveroption @server=@Server, @optname=N'data access', @optvalue=N'true'


EXEC master.dbo.sp_serveroption @server=@Server, @optname=N'dist', @optvalue=N'False'


EXEC master.dbo.sp_serveroption @server=@Server, @optname=N'pub', @optvalue=N'false'


EXEC master.dbo.sp_serveroption @server=@Server, @optname=N'rpc', @optvalue=N'true'


EXEC master.dbo.sp_serveroption @server=@Server, @optname=N'rpc out', @optvalue=N'true'


EXEC master.dbo.sp_serveroption @server=@Server, @optname=N'sub', @optvalue=N'false'


EXEC master.dbo.sp_serveroption @server=@Server, @optname=N'connect timeout', @optvalue=N'0'


EXEC master.dbo.sp_serveroption @server=@Server, @optname=N'collation name', @optvalue=null


EXEC master.dbo.sp_serveroption @server=@Server, @optname=N'lazy schema validation', @optvalue=N'false'


EXEC master.dbo.sp_serveroption @server=@Server, @optname=N'query timeout', @optvalue=N'0'


EXEC master.dbo.sp_serveroption @server=@Server, @optname=N'use remote collation', @optvalue=N'true'


EXEC master.dbo.sp_serveroption @server=@Server, @optname=N'remote proc transaction promotion', @optvalue=N'true'

GO

