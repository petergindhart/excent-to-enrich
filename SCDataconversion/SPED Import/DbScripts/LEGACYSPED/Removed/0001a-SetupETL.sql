--#assume VC3ETL:20

-- #############################################################################
-- ExtractDatabase Configuration
IF NOT EXISTS (select 1 from VC3TaskScheduler.ScheduledTaskSchedule  where ID = 'B588BEC0-05E5-4891-8CF3-1D4FEDEE9EDC')
INSERT INTO VC3TaskScheduler.ScheduledTaskSchedule (ID, TaskTypeID, Parameters, IsEnabled, EnabledDate, LastRunTime, FrequencyAmount, FrequencyTypeID, YearTrigger, MonthTrigger, DayTrigger, HourTrigger, MinuteTrigger, MonTrigger, TuesTrigger, WedsTrigger, ThursTrigger, FriTrigger, SatTrigger, SunTrigger) VALUES ('B588BEC0-05E5-4891-8CF3-1D4FEDEE9EDC', 'F03A0C51-7294-4B57-AFB7-AFF136E4025F', '<?xml version="1.0" encoding="utf-16"?>  <ArrayOfDictionaryEntry xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">    <DictionaryEntry>      <Key xsi:type="xsd:string">DatabaseId</Key>      <Value xsi:type="xsd:string">29d14961-928d-4bee-9025-238496d144c6*84d37f9e-a389-4e56-812f-7378401f3347</Value>    </DictionaryEntry>    <DictionaryEntry>      <Key xsi:type="xsd:string">CreateSnapshot</Key>      <Value xsi:type="xsd:boolean">true</Value>    </DictionaryEntry>  </ArrayOfDictionaryEntry>', 0, getdate(), NULL, 1, 'D', NULL, NULL, NULL, 1, 30, 0, 0, 0, 0, 0, 0, 0)
-- INSERT VC3ETL.ExtractDatabase (ID,Type,DatabaseType,Server,DatabaseOwner,DatabaseName,Username,Password,LinkedServer,IsLinkedServerManaged,LastExtractDate,LastLoadDate,SucceededEmail,SucceededSubject,SucceededMessage,FailedEmail,FailedSubject,FailedMessage,RetainSnapshot,DestTableTempSuffix,DestTableFinalSuffix,FileGroup,Schedule,Name,Enabled) VALUES ('29D14961-928D-4BEE-9025-238496D144C6','84D37F9E-A389-4E56-812F-7378401F3347','58BA0C59-5087-4F38-B00B-F3480C93064B','\\10.0.1.26\FFDB\CO\AuroraPS',NULL,NULL,'DEVSERVER\FlatFileUser','vc3go!!',NULL,0,NULL,NULL,NULL,'{BrandName} {SisDatabase} import completed','Successfully imported {SnapshotRosterYear} {SisDatabase} data into {BrandName}.  {SisDatabase} data in {BrandName} is now current as of {SnapshotDate}.      Next Scheduled Import Time: {NextImportTime}',NULL,NULL,'{BrandName} {SisDatabase} import failed',1,'_NEW','_LOCAL',NULL,'B588BEC0-05E5-4891-8CF3-1D4FEDEE9EDC','Aurora PS Special Ed',1)
-- INSERT INTO VC3ETL.FlatFileExtractDatabase VALUES ('29D14961-928D-4BEE-9025-238496D144C6', 'E:\EnrichDataFiles')

--/****** Object:  StoredProcedure VC3ETL.FlatFileExtractTableType_GetAllRecords    Script Date: 04/18/2011 12:40:42 ******/
--IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'VC3ETL.FlatFileExtractTableType_GetAllRecords') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
--DROP PROCEDURE VC3ETL.FlatFileExtractTableType_GetAllRecords
--GO

--/****** Object:  StoredProcedure VC3ETL.FlatFileExtractTableType_UpdateRecord    Script Date: 04/18/2011 12:40:42 ******/
--IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'VC3ETL.FlatFileExtractTableType_UpdateRecord') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
--DROP PROCEDURE VC3ETL.FlatFileExtractTableType_UpdateRecord
--GO

--/****** Object:  StoredProcedure VC3ETL.FlatFileExtractTableType_DeleteRecord    Script Date: 04/18/2011 12:40:42 ******/
--IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'VC3ETL.FlatFileExtractTableType_DeleteRecord') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
--DROP PROCEDURE VC3ETL.FlatFileExtractTableType_DeleteRecord
--GO

--/****** Object:  StoredProcedure VC3ETL.FlatFileExtractTableType_GetRecords    Script Date: 04/18/2011 12:40:42 ******/
--IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'VC3ETL.FlatFileExtractTableType_GetRecords') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
--DROP PROCEDURE VC3ETL.FlatFileExtractTableType_GetRecords
--GO

--/****** Object:  StoredProcedure VC3ETL.FlatFileExtractTableType_InsertRecord    Script Date: 04/18/2011 12:40:42 ******/
--IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'VC3ETL.FlatFileExtractTableType_InsertRecord') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
--DROP PROCEDURE VC3ETL.FlatFileExtractTableType_InsertRecord
--GO

--/****** Object:  StoredProcedure VC3ETL.FlatFileExtractTableType_GetAllRecords    Script Date: 04/18/2011 12:40:42 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

-- /*
--<summary>
--Gets all records from the FlatFileExtractTableType table
--</summary>
--<returns>An <see cref="IDataReader"/> containing the requested data</returns>
--<model isGenerated="True" returnType="System.Data.IDataReader" />
--*/
--CREATE PROCEDURE VC3ETL.FlatFileExtractTableType_GetAllRecords
--AS
--	SELECT
--		f.*
--	FROM
--		FlatFileExtractTableType f
--	ORDER BY f.Name
--GO

--/****** Object:  StoredProcedure VC3ETL.FlatFileExtractTableType_UpdateRecord    Script Date: 04/18/2011 12:40:43 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

-- /*
--<summary>
--Updates a record in the FlatFileExtractTableType table with the specified values
--</summary>
--<param name="id">Value to assign to the ID field of the record</param>
--<param name="name">Value to assign to the Name field of the record</param>
--<param name="textQualifier">Value to assign to the TextQualifier field of the record</param>
--<param name="columnDelimiter">Value to assign to the ColumnDelimiter field of the record</param>

--<model isGenerated="True" returnType="System.Void" />
--*/
--CREATE PROCEDURE VC3ETL.FlatFileExtractTableType_UpdateRecord
--	@id char(1), 
--	@name varchar(50), 
--	@textQualifier char(1), 
--	@columnDelimiter char(1)
--AS
--	UPDATE FlatFileExtractTableType
--	SET
--		Name = @name, 
--		TextQualifier = @textQualifier, 
--		ColumnDelimiter = @columnDelimiter
--	WHERE 
--		ID = @id
--GO

--/****** Object:  StoredProcedure VC3ETL.FlatFileExtractTableType_DeleteRecord    Script Date: 04/18/2011 12:40:43 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

-- /*
--<summary>
--Deletes a FlatFileExtractTableType record
--</summary>

--<model isGenerated="True" returnType="System.Void" />
--*/
--CREATE PROCEDURE VC3ETL.FlatFileExtractTableType_DeleteRecord
--	@id char(1)
--AS
--	DELETE FROM 
--		FlatFileExtractTableType
--	WHERE
--		Id = @id
--GO

--/****** Object:  StoredProcedure VC3ETL.FlatFileExtractTableType_GetRecords    Script Date: 04/18/2011 12:40:43 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

-- /*
--<summary>
--Gets records from the FlatFileExtractTableType table
--with the specified id's
--</summary>
--<param name="ids">Ids of the records to retrieve</param>
--<returns>An <see cref="IDataReader"/> containing the requested data</returns>
--<model isGenerated="True" returnType="System.Data.IDataReader" />
--*/
--CREATE PROCEDURE VC3ETL.FlatFileExtractTableType_GetRecords
--	@ids	chararray
--AS
--	SELECT	
--		f.*		
--	FROM
--		FlatFileExtractTableType f INNER JOIN
--		GetChars(@ids) Keys ON f.Id = Keys.Id
--GO

--/****** Object:  StoredProcedure VC3ETL.FlatFileExtractTableType_InsertRecord    Script Date: 04/18/2011 12:40:43 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

-- /*
--<summary>
--Inserts a new record into the FlatFileExtractTableType table with the specified values
--</summary>
--<param name="id">Value to assign to the ID field of the record</param>
--<param name="name">Value to assign to the Name field of the record</param>
--<param name="textQualifier">Value to assign to the TextQualifier field of the record</param>
--<param name="columnDelimiter">Value to assign to the ColumnDelimiter field of the record</param>
--<returns>The identifiers for the inserted record</returns>
--<model isGenerated="True" returnType="System.Void" />
--*/
--CREATE PROCEDURE VC3ETL.FlatFileExtractTableType_InsertRecord
--	@id char(1), 
--	@name varchar(50), 
--	@textQualifier char(1), 
--	@columnDelimiter char(1)
--AS
--	INSERT INTO FlatFileExtractTableType
--	(
--		Id, 
--		Name, 
--		TextQualifier, 
--		ColumnDelimiter
--	)
--	VALUES
--	(
--		@id, 
--		@name, 
--		@textQualifier, 
--		@columnDelimiter
--	)
--GO

---- new proc
--IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'VC3ETL.FlatFileDBProvider_FileExistsLocally') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
--DROP PROCEDURE VC3ETL.FlatFileDBProvider_FileExistsLocally
--GO

--CREATE PROCEDURE VC3ETL.FlatFileDBProvider_FileExistsLocally
--	@fileName				varchar(64)
--AS
--BEGIN


--declare		
--		@hr int,	
--		@result varchar(10),
--		@objFileSystem int
		
--	EXECUTE @hr = sp_OACreate  'Scripting.FileSystemObject' , @objFileSystem OUT
--	if @HR=0 execute @hr = sp_OAMethod   @objFileSystem   , 'FileExists', @result OUT, @fileName

--	SELECT case when @result = 'True' then 1 else 0 end
--END



-- note:  this block of code is necessary only uuntil the update that contains the changes is released, after which the update will fail


INSERT dbo.InformExtractDatabase (ID) values ('29D14961-928D-4BEE-9025-238496D144C6') -- note :  this was added after upgrade_db was run, but this was already in the db from earlier testing
--


/*

*/