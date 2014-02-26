DECLARE @Server VARCHAR(150), @UserName VARCHAR(150), @Password VARCHAR(150), @linkedServerAlias varchar(100), @linkedServerAddress varchar(100) ;

SET @linkedServerAlias = (select ParamValue from x_DATAVALIDATION.ParamValues where ParamName = 'linkedServerAlias');
SET @linkedServerAddress = (select ParamValue from x_DATAVALIDATION.ParamValues where ParamName = 'linkedServerAddress');
SET @UserName = (select ParamValue from x_DATAVALIDATION.ParamValues where ParamName = 'EOdatabaseUserName');
SET @Password = (select ParamValue from x_DATAVALIDATION.ParamValues where ParamName = 'EOdatabasepwd');

IF EXISTS ( SELECT 1 FROM master.dbo.sysservers WHERE srvname = @Server )
BEGIN
EXEC master.dbo.sp_dropserver @Server, 'droplogins'
END

--Msg 15028, Level 16, State 1, Server RENEGADE, Procedure sp_addlinkedserver, Line 82
--The server '[10.10.10.123DILLON4]' already exists.

if not exists (select 1 from sys.servers where name = @linkedServerAlias)
begin
EXEC master.dbo.sp_addlinkedserver @server = @linkedServerAlias, @srvproduct=N'SQL_Server', -- don't forget the underscore
	@provider=N'SQLNCLI', @datasrc=@linkedServerAddress -- new lines
end
EXEC master.dbo.sp_serveroption @server=@linkedServerAlias, @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@linkedServerAlias, @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@linkedServerAlias, @optname=N'dist', @optvalue=N'False'
EXEC master.dbo.sp_serveroption @server=@linkedServerAlias, @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@linkedServerAlias, @optname=N'rpc', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@linkedServerAlias, @optname=N'rpc out', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@linkedServerAlias, @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@linkedServerAlias, @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=@linkedServerAlias, @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=@linkedServerAlias, @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@linkedServerAlias, @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=@linkedServerAlias, @optname=N'use remote collation', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@linkedServerAlias, @optname=N'remote proc transaction promotion', @optvalue=N'true'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=@linkedServerAlias,@useself=N'False',@locallogin=NULL,@rmtuser=@UserName,@rmtpassword=@Password

GO

