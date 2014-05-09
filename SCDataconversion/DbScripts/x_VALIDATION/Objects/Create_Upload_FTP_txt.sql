
set nocount on;
-- insert x_DATAVALIDATION.ParamValues values ('enrichDataSource', '.')
-- select * from x_DATAVALIDATION.ParamValues order by RowNumber
declare @ftpUser varchar(20), 
	@ftpPassword varchar(20), 
	@locFolder varchar(255); 
select @ftpUser = ParamValue from x_DATAVALIDATION.ParamValues where ParamName = 'ftpUser'
select @ftpPassword = ParamValue from x_DATAVALIDATION.ParamValues where ParamName = 'ftpPassword'
select @locFolder = ParamValue from x_DATAVALIDATION.ParamValues where ParamName = 'locFolder'

-- ValidationReport_Upload_FTP.txt
select '# Automatically abort script on errors
option batch abort
# Disable overwrite confirmations that conflict with the previous
option confirm off
# Connect using a password
# open ftp://'+@ftpUser+':'+@ftpPassword+'@ftp.excent.com:21
# Connect
open ftp://'+@ftpUser+':'+@ftpPassword+'@ftp.excent.com:21 -explicittls
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
