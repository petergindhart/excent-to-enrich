IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'Populate_SpeedObjects')
DROP PROC x_DATAVALIDATION.Populate_SpeedObjects
GO

CREATE PROC x_DATAVALIDATION.Populate_SpeedObjects
AS
BEGIN

declare @etlRoot varchar(255), @VpnConnectFile varchar(255), @VpnDisconnectFile varchar(255), @PopulateDCSpeedObj varchar(255), @q varchar(8000),@district varchar(50), @vpnYN char(1),@locfolder varchar(250) ; 
select @etlRoot = ParamValue from x_DATAVALIDATION.ParamValues where ParamName='etlRoot'
select @VpnConnectFile = ParamValue from x_DATAVALIDATION.ParamValues where ParamName='VpnConnectFile'
select @VpnDisconnectFile = ParamValue from x_DATAVALIDATION.ParamValues where ParamName='VpnDisconnectFile'
select @PopulateDCSpeedObj = ParamValue from x_DATAVALIDATION.ParamValues where ParamName='populateDVSpeedObj'
select @district = ParamValue from x_DATAVALIDATION.ParamValues where ParamName='district'
select @vpnYN = ParamValue from x_DATAVALIDATION.ParamValues where ParamName='vpnYN'
select @locfolder = ParamValue from x_DATAVALIDATION.ParamValues where ParamName='locfolder'

set @q = 'cd '+@etlRoot
set @VpnConnectFile = '"'+@VpnConnectFile+'"';
set @PopulateDCSpeedObj = '"'+@PopulateDCSpeedObj+'"';
set @PopulateDCSpeedObj = @PopulateDCSpeedObj+' '+@locfolder;

print @district
print @q
print @VpnConnectFile
print @PopulateDCSpeedObj
print @VpnDisconnectFile


--select * from x_DATAVALIDATION.ParamValues 


if (@vpnYN = 'Y')
begin
EXEC master..xp_CMDShell @q
EXECUTE AS LOGIN = 'cmdshelluser'
EXEC master..xp_CMDShell @VpnConnectFile
REVERT
end

-- Batch file must reference different parameters for each district.  Connection string and path

--EXEC master..xp_CMDShell 'cd E:\GIT\excent-to-enrich\SCDataconversion\Common'
EXECUTE AS LOGIN = 'cmdshelluser'
EXEC master..xp_CMDShell @populateDCSpeedObj 
REVERT
END