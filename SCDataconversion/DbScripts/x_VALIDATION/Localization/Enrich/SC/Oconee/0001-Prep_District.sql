
-- call this after creating usp_GetParams.sql, because the ParamValues table is created there.
declare @etlRoot varchar(100), 
	@locFolder varchar(500), 
	@district varchar(100), 
	@linkedServerAlias varchar(100), 
	@linkedServerAddress varchar(100), 
	@remoteDbUser varchar(50),
	@remoteDbPwd varchar(20),
	@enrichDataSource varchar(100),
	@enrichDbname varchar(50),
	@enrichDbUser varchar(50),
	@enrichDbPwd varchar(20),
	@ftpUser varchar(20),
	@ftpPwd varchar(20)
	; 
select 	
	@etlRoot='C:\EnrichETL', -- consider setting this dynamically by inserting x_DATAVALIDATION.ParamValues using batch command 
	@district = 'Oconee', -- for simplicity with the majority of districts, this will be the name of the EO hosted database minus _SC_EO
	@locFolder=@etlRoot+rtrim('\DbScripts\x_VALIDATION\Localization\Enrich\SC\ ')+@district, -- backslash interpreted as escape character in this notepad++ highlighter, throwing off the highlighting
	@linkedServerAddress = '10.10.10.124'
select
	@linkedServerAlias = @linkedServerAddress+upper(@district),
	@remoteDbUser = @district+'Conv',
	@remoteDbPwd = 'pdpoff25', 
	@enrichDataSource='.',
	@enrichDbname = 'Enrich_DCB8_SC_Oconee',
	@enrichDbUser = 'enrich_db_user',
	@enrichDbPwd = 'vc3go!!',
	@ftpUser = 'oconee',
	@ftpPwd = 'r5h8ks3'

set nocount on;
truncate table x_DATAVALIDATION.ParamValues 
insert x_DATAVALIDATION.ParamValues values ('district', @district)
insert x_DATAVALIDATION.ParamValues values ('locFolder', @locFolder)
insert x_DATAVALIDATION.ParamValues values ('etlRoot', @etlRoot)

--insert x_DATAVALIDATION.ParamValues values ('server', @Server)
insert x_DATAVALIDATION.ParamValues values ('linkedServerAlias', @linkedServerAlias)
insert x_DATAVALIDATION.ParamValues values ('linkedServerAddress', @linkedServerAddress)
insert x_DATAVALIDATION.ParamValues values ('databaseOwner', 'dbo')
insert x_DATAVALIDATION.ParamValues values ('databaseName', @district+'_SC_EO')
insert x_DATAVALIDATION.ParamValues values ('EOdatabaseUserName', @remoteDbUser)
insert x_DATAVALIDATION.ParamValues values ('EOdatabasepwd', @remoteDbPwd)

insert x_DATAVALIDATION.ParamValues values ('enrichDataSource', @enrichDataSource)
insert x_DATAVALIDATION.ParamValues values ('EnrichDbname', @enrichDbname)
insert x_DATAVALIDATION.ParamValues values ('EnrichDbuser', @enrichDbUser)
insert x_DATAVALIDATION.ParamValues values ('EnrichDbPwd', @enrichDbPwd)

insert x_DATAVALIDATION.ParamValues values ('remoteConnStr', '-S'+@linkedServerAddress+' -U'+@remoteDbUser+' -P'+@remoteDbPwd+' -d'+@district+'_SC_EO')

insert x_DATAVALIDATION.ParamValues values ('ftpUser', @ftpUser)
insert x_DATAVALIDATION.ParamValues values ('ftpPassword', @ftpPwd)

insert x_DATAVALIDATION.ParamValues values ('DTEXC_PATH', 'C:\Program Files (x86)\Microsoft SQL Server\100\DTS\Binn')
-- check the following 2 records to see if they can be generalized to re-use code
insert x_DATAVALIDATION.ParamValues values ('Config_PATH', @locFolder+'\ValidationReport_UploadFTP_IEPwStuInfo.dtsConfig')
insert x_DATAVALIDATION.ParamValues values ('Package_PATH', @locFolder+'\ValidationReport_UploadFTP_IEPwStuInfo.dtsx')

insert x_DATAVALIDATION.ParamValues values ('vpnYN', 'Y')
insert x_DATAVALIDATION.ParamValues values ('VPNConnectFile', @etlRoot+'\Support\VPNConnect.bat')
insert x_DATAVALIDATION.ParamValues values ('VPNDisconnectFile', @etlRoot+'\Support\VPNDisconnect.bat')

insert x_DATAVALIDATION.ParamValues values ('ValidationreportFile', @etlRoot+'\DbScripts\x_VALIDATION\Localization\Enrich\SC\ValidationReport.bat') 
insert x_DATAVALIDATION.ParamValues values ('populateDVSpeedObj', @etlRoot+'\DbScripts\x_VALIDATION\Localization\EO\SC\PopulateRemoteSpeedObjects.bat') 

insert x_DATAVALIDATION.ParamValues values ('Check_AccomMod','1')
insert x_DATAVALIDATION.ParamValues values ('Check_AssessAccomm','1')
insert x_DATAVALIDATION.ParamValues values ('Check_ClassroomAccommMod','1')
insert x_DATAVALIDATION.ParamValues values ('Check_District','1')
insert x_DATAVALIDATION.ParamValues values ('Check_Evaluation','1')
insert x_DATAVALIDATION.ParamValues values ('Check_EvaluationAssess','1')
insert x_DATAVALIDATION.ParamValues values ('Check_Goal','1')
insert x_DATAVALIDATION.ParamValues values ('Check_IEP','1')
insert x_DATAVALIDATION.ParamValues values ('Check_Objective','1')
insert x_DATAVALIDATION.ParamValues values ('Check_PostSchoolConsider','1')
insert x_DATAVALIDATION.ParamValues values ('Check_PostSchoolStatement','1')
insert x_DATAVALIDATION.ParamValues values ('Check_PresentLevel','1')
insert x_DATAVALIDATION.ParamValues values ('Check_PriorWrittenNotice','1')
insert x_DATAVALIDATION.ParamValues values ('Check_School','1')
insert x_DATAVALIDATION.ParamValues values ('Check_SchoolProgressFrequency','1')
insert x_DATAVALIDATION.ParamValues values ('Check_SelectLists','1')
insert x_DATAVALIDATION.ParamValues values ('Check_Service','1')
insert x_DATAVALIDATION.ParamValues values ('Check_SpecialFactors','1')
insert x_DATAVALIDATION.ParamValues values ('Check_SpedStaffMember','1')
insert x_DATAVALIDATION.ParamValues values ('Check_StaffSchool','1')
insert x_DATAVALIDATION.ParamValues values ('Check_Student','1')
insert x_DATAVALIDATION.ParamValues values ('Check_TeamMember','1')


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


