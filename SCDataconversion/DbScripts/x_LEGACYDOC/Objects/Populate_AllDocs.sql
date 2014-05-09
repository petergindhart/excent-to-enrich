IF EXISTS (SELECT 1 FROM sys.schemas s JOIN sys.objects o on s.schema_id = o.schema_id WHERE s.name = 'x_LEGACYDOC' AND o.name = 'Populate_AllDocs')
DROP PROC x_LEGACYDOC.Populate_AllDocs
GO

CREATE PROC x_LEGACYDOC.Populate_AllDocs
AS
BEGIN
/*
To Populate the source data in Enrich database from the EO database
*/
DECLARE @etlRoot varchar(255), @VpnConnectFile varchar(255), @VpnDisconnectFile varchar(255), @PopulateDCSpeedObj varchar(255), @q varchar(8000),@district varchar(50), @vpnYN char(1),@locfolder varchar(250) ; 

DECLARE @ro varchar(100), @et varchar(100), @deleteq NVARCHAR(max), @insertq NVARCHAR(max), @LinkedserverAddress VARCHAR(100), @DatabaseOwner VARCHAR(100), @DatabaseName VARCHAR(100), @newline varchar(5) ; set @newline = '
'

SELECT @LinkedserverAddress = LinkedServer, @DatabaseOwner = DatabaseOwner, @DatabaseName = DatabaseName -- SELECT *
FROM VC3ETL.ExtractDatabase 
WHERE ID = '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16'

SELECT @etlRoot = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='etlRoot'
SELECT @VpnConnectFile = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='VpnConnectFile'
SELECT @VpnDisconnectFile = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='VpnDisconnectFile'
SELECT @PopulateDCSpeedObj = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='populateDVSpeedObj'
SELECT @district = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='district'
SELECT @vpnYN = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='vpnYN'
SELECT @locfolder = ParamValue FROM x_DATAVALIDATION.ParamValues WHERE ParamName='locfolder'

SET @q = 'cd '+@etlRoot
SET @VpnConnectFile = '"'+@VpnConnectFile+'"';
SET @PopulateDCSpeedObj = '"'+@PopulateDCSpeedObj+'"';
SET @PopulateDCSpeedObj = @PopulateDCSpeedObj+' '+@locfolder;

PRINT @district
PRINT @q
PRINT @VpnConnectFile
PRINT @PopulateDCSpeedObj
PRINT @VpnDisconnectFile


--SELECT * FROM x_DATAVALIDATION.ParamValues 


IF (@vpnYN = 'Y')
BEGIN
EXEC master..xp_CMDShell @q
EXECUTE AS LOGIN = 'cmdshelluser'
EXEC master..xp_CMDShell @VpnConnectFile
REVERT
END

SET @deleteq = 'DELETE x_LEGACYDOC.AllDocs_LOCAL'

SET @insertq = 'INSERT x_LEGACYDOC.AllDocs_LOCAL (DocumentRefID,DocumentType,DocumentDate,StudentRefID,StudentLocalID,MimeType,Content)
SELECT
 DocumentRefID = x.iepseqnum,
 DocumentType = CAST(''IEP'' AS varchar(100)),
 DocumentDate = ISNULL(x.MeetDate, ic.CreateDate),
 StudentRefID = x.GStudentID,
 StudentLocalID =  st.StudentID,
 MimeType = CAST(''document/pdf'' AS varchar(25)),
 Content = PDFImage
FROM '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.dbo.SpecialEdStudentsAndIEPs x 
JOIN '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.dbo.Student st on st.GStudentID = x.GStudentID
JOIN '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.dbo.IEPCompleteTbl ic ON x.IEPSeqNum = ic.IEPSeqNum
JOIN '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.dbo.IEPArchiveDocTbl ad ON ic.RecNum = ad.RecNum AND ic.GStudentID = ad.GStudentID -- 11506
WHERE ad.RecNum = (
 SELECT MAX(y.RecNum)
 FROM '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.dbo.IEPArchiveDocTbl y 
 WHERE ad.GStudentID = y.GStudentID
 )'
  
 EXEC (@deleteq)
 EXEC (@insertq)
 
END
