set nocount on;

declare @district varchar(20), 
	@locFolder varchar(255), 
	@enrichDataSource varchar(50), 
	@enrichDbname varchar(50); 
select @locFolder = ParamValue from x_DATAVALIDATION.ParamValues where ParamName = 'locFolder'
select @enrichDataSource = ParamValue from x_DATAVALIDATION.ParamValues where ParamName = 'enrichDataSource'
select @enrichDbname = ParamValue from x_DATAVALIDATION.ParamValues where ParamName = 'enrichDbname'

-- generate ValidationReport_UploadFTP_IEPwStuInfo.dtsConfig
select '<?xml version="1.0" encoding="UTF-8"?>
<DTSConfiguration>
   <DTSConfigurationHeading>
      <DTSConfigurationFileInfo GeneratedBy="RENEGADE\muthuv" GeneratedFromPackageName="ValidationReport_UploadFTP_IEPwStuInfo" GeneratedFromPackageID="{3722C935-5C80-400D-ACF7-6636501A292E}" GeneratedDate="3/7/2014 6:31:57 AM" />
   </DTSConfigurationHeading>
   <Configuration ConfiguredType="Property" Path="\Package.Connections[Excel Connection Manager].Properties[ExcelFilePath]" ValueType="String">
      <ConfiguredValue>'+@locFolder+'\ValidationReport_Detail.xls</ConfiguredValue>
   </Configuration>
   <Configuration ConfiguredType="Property" Path="\Package.Connections[SC Enrich DataBase].Properties[ConnectionString]" ValueType="String">
      <ConfiguredValue>Data Source='+@enrichDataSource+';Initial Catalog='+@enrichDbName+';Provider=SQLNCLI10.1;Integrated Security=SSPI;Auto Translate=False;Application Name=SSIS-ValidationReport_Detail-{EA204716-4D5F-4A6B-9135-8451C8596A35}Enrich Database;</ConfiguredValue>
   </Configuration>
   <Configuration ConfiguredType="Property" Path="\Package\Upload Validation Report To FTP.Properties[Arguments]" ValueType="String">
      <ConfiguredValue>-script="'+@locFolder+'\ValidationReport_Upload_FTP.txt" /log="'+@locFolder+'\log.txt"</ConfiguredValue>
   </Configuration>
   <Configuration ConfiguredType="Property" Path="\Package\Upload Validation Report To FTP.Properties[Executable]" ValueType="String">
      <ConfiguredValue>C:\Program Files (x86)\WinSCP\WinSCP.exe</ConfiguredValue>
   </Configuration>
</DTSConfiguration>
'
