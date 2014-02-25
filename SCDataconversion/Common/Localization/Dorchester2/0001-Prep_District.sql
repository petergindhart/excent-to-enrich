-- call this after creating usp_GetParams.sql, because the ParamValues table is created there.

declare @etlRoot varchar(100), 
	@locFolder varchar(500), 
	@district varchar(100), 
	@remoteServer varchar(100), 
	@remoteDbUser varchar(50),
	@remoteDbPwd varchar(20),
	@ftpUser varchar(20),
	@ftpPwd varchar(20),
	@Server varchar(100)
	; 
select 	
	@etlRoot='E:\GIT\excent-to-enrich', -- consider setting this dynamically by inserting x_DATAVALIDATION.ParamValues using batch command 
	@district = 'Dorchester2', -- for simplicity with the majority of districts, this will be the name of the EO hosted database minus _SC_EO
	@locFolder=@etlRoot+rtrim('\SCDataconversion\Common\Localization\ ')+@district -- backslash interpreted as escape character in this notepad++ highlighter, throwing off the highlighting
select
	@Server = '10.10.10.123',
	@remoteServer = '[10.10.10.123DORCHESTER2]',
	@remoteDbUser = @district+'Conv',
	@remoteDbPwd = 'epsfs347', 
	@ftpUser = 'dillon4',
	@ftpPwd = 'g422t7k'

set nocount on;
truncate table x_DATAVALIDATION.ParamValues 
insert x_DATAVALIDATION.ParamValues values ('district', @district)
insert x_DATAVALIDATION.ParamValues values ('locFolder', @locFolder)
insert x_DATAVALIDATION.ParamValues values ('etlRoot', @etlRoot)

insert x_DATAVALIDATION.ParamValues values ('server', @Server)
insert x_DATAVALIDATION.ParamValues values ('linkedServer', @remoteServer)
insert x_DATAVALIDATION.ParamValues values ('databaseOwner', 'dbo')
insert x_DATAVALIDATION.ParamValues values ('databaseName', @district+'_SC_EO')
insert x_DATAVALIDATION.ParamValues values ('EOdatabaseUserName', @remoteDbUser)
insert x_DATAVALIDATION.ParamValues values ('EOdatabasepwd', @remoteDbPwd)

insert x_DATAVALIDATION.ParamValues values ('remoteConnStr', '-S'+@remoteServer+' -U'+@remoteDbUser+' -P'+@remoteDbPwd+' -d'+@district+'_SC_EO')

insert x_DATAVALIDATION.ParamValues values ('ftpUser', @ftpUser)
insert x_DATAVALIDATION.ParamValues values ('ftpPassword', @ftpPwd)

insert x_DATAVALIDATION.ParamValues values ('DTEXC_PATH', 'C:\Program Files (x86)\Microsoft SQL Server\100\DTS\Binn')
-- check the following 2 records to see if they can be generalized to re-use code
insert x_DATAVALIDATION.ParamValues values ('Config_PATH', @locFolder+'\ValidationReport_UploadFTP_IEPwStuInfo.dtsConfig')
insert x_DATAVALIDATION.ParamValues values ('Package_PATH', @locFolder+'\ValidationReport_UploadFTP_IEPwStuInfo.dtsx')

insert x_DATAVALIDATION.ParamValues values ('vpnYN', 'Y')
insert x_DATAVALIDATION.ParamValues values ('VPNConnectFile', @etlRoot+'\SCDataconversion\EnrichDB\SPED Import\Support\VPNConnect.bat')
insert x_DATAVALIDATION.ParamValues values ('VPNDisconnectFile', @etlRoot+'\SCDataconversion\EnrichDB\SPED Import\Support\VPNDisconnect.bat')

insert x_DATAVALIDATION.ParamValues values ('ValidationreportFile', @etlRoot+'\SCDataconversion\Common\ValidationReport.bat') 
insert x_DATAVALIDATION.ParamValues values ('populateDVSpeedObj', @etlRoot+'\SCDataconversion\Common\PopulateRemoteSpeedObjects.bat') 
--select * from x_DATAVALIDATION.ParamValues

-- now generate a file for FTP

declare @ftpConfigFileContent varchar(max);

set @ftpConfigFileContent='# Automatically abort script on errors
option batch abort
# Disable overwrite confirmations that conflict with the previous
option confirm off
# Connect using a password
# open ftp://'+@ftpUser+':'+@ftpPwd+'@ftp.excent.com:21
# Connect
open ftp://'+@ftpUser+':'+@ftpPwd+'@ftp.excent.com:21 -explicittls
# Force binary mode transfer
option transfer binary
lcd "'+@locFolder+'"
cd /
put "'+@locFolder+'\ValidationReport_Detail.xls"
# Disconnect
close
# Exit WinSCP
exit
'
------------------------- can the ValidationReport_Detail.xls file be re-used for all validation reports?


