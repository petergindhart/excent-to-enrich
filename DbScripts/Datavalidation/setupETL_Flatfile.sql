BEGIN TRAN

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_ExtractDatabase TABLE (ID uniqueidentifier, Type uniqueidentifier, DatabaseType uniqueidentifier, Server varchar(64), DatabaseOwner varchar(64), DatabaseName varchar(128), Username varchar(32), Password varchar(32), LinkedServer varchar(100), IsLinkedServerManaged bit, LastExtractDate datetime, LastLoadDate datetime, SucceededEmail varchar(500), SucceededSubject text, SucceededMessage text, FailedEmail varchar(500), FailedSubject text, FailedMessage text, RetainSnapshot bit, DestTableTempSuffix varchar(30), DestTableFinalSuffix varchar(30), FileGroup varchar(64), Schedule uniqueidentifier, Name varchar(100), Enabled bit)

declare @dbo_EnrichFileFormatExtractDatabase table (ID uniqueidentifier, LastLoadRosteryearID uniqueidentifier, LastExtractRosterYearID uniqueidentifier, OrgUnitID uniqueidentifier)
insert @dbo_EnrichFileFormatExtractDatabase (ID, LastLoadRosteryearID, LastExtractRosterYearID, OrgUnitID) values ('EA75038A-D059-44BD-B49A-4CD68E0249B6', 'A332BC88-B400-42E2-85AA-3A7F8C6ACA54', 'A332BC88-B400-42E2-85AA-3A7F8C6ACA54', '6531EF88-352D-4620-AF5D-CE34C54A9F53')

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_ExtractDatabase VALUES ('EA75038A-D059-44BD-B49A-4CD68E0249B6', '049884c0-518a-4c24-8772-cda3aeeefe0d', '58ba0c59-5087-4f38-b00b-f3480c93064b', NULL, NULL, NULL, NULL, NULL, NULL, 0, '12/17/2012 10:16:51 AM', '12/17/2012 10:16:51 AM', NULL, '{BrandName} {SisDatabase} import completed', 'Successfully imported {SnapshotRosterYear} {SisDatabase} data into {BrandName}.  {SisDatabase} data in {BrandName} is now current as of {SnapshotDate}.      Next Scheduled Import Time: {NextImportTime}', NULL, NULL, '{BrandName} {SisDatabase} import failed', 1, '_NEW', '_LOCAL', NULL,NULL, 'Datavalidation', 1)

DECLARE @VC3ETL_LoadTable TABLE (ID uniqueidentifier, ExtractDatabase uniqueidentifier, Sequence int, SourceTable varchar(100), DestTable varchar(100), HasMapTable bit, MapTable varchar(100), KeyField varchar(250), DeleteKey varchar(50), ImportType int, DeleteTrans bit, UpdateTrans bit, InsertTrans bit, Enabled bit, SourceTableFilter varchar(1000), DestTableFilter varchar(1000), PurgeCondition varchar(1000), KeepMappingAfterDelete bit, StartNewTransaction bit, LastLoadDate datetime, MapTableMapID varchar(250), Comments varchar(1000))

INSERT INTO @VC3ETL_LoadTable VALUES ('CC18CE47-F092-4631-9F0A-0D482DF4A4CD', 'EA75038A-D059-44BD-B49A-4CD68E0249B6', 1, 'Datavalidation.ExtractData_FlatFile @datafilelocationpath = ''E:\EnrichDataFiles\FL\Flagler''', NULL, 0, NULL, NULL, NULL, 4, 0, 0, 0, 1, NULL, NULL, NULL, 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('62BEFA3D-06D5-4280-8216-7E84F726E90A', 'EA75038A-D059-44BD-B49A-4CD68E0249B6', 1, 'Datavalidation.ReportFile_Preparation ''Enrich_DC2_FL_Flagler'',''E:\EnrichDataFiles\FL\Flagler\Valid''', NULL, 0, NULL, NULL, NULL, 4, 0, 0, 0, 1, NULL, NULL, NULL, 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)

 --Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_FlatFileExtractDatabase TABLE (ID uniqueidentifier, LocalCopyPath varchar(1000))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_FlatFileExtractDatabase VALUES ('EA75038A-D059-44BD-B49A-4CD68E0249B6', 'E:\EnrichDataFiles\FL\Flagler') -- not using VC3 flat file extract

-- Declare a temporary table to hold the data to be synchronized
DECLARE @dbo_InformExtractDatabase TABLE (ID uniqueidentifier, LastExtractRosterYear uniqueidentifier, LastLoadRosterYear uniqueidentifier)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @dbo_InformExtractDatabase VALUES ('EA75038A-D059-44BD-B49A-4CD68E0249B6', NULL, NULL)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_FlatFileExtractTableType TABLE (ID char(1), Name varchar(50), TextQualifier char(1), ColumnDelimiter char(1))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_FlatFileExtractTableType VALUES ('C', 'Comma Delimitted File (CSV)', '"', ',')
INSERT INTO @VC3ETL_FlatFileExtractTableType VALUES ('D', 'Comma Delimitted File Dynamic', '"', ',')
INSERT INTO @VC3ETL_FlatFileExtractTableType VALUES ('P', 'Pipe Delimited File', NULL, '|')
INSERT INTO @VC3ETL_FlatFileExtractTableType VALUES ('W', 'Comma Delimitted File (CSV,Quoted Text)', '"', ',')

DECLARE @VC3ETL_ExtractTable TABLE (ID uniqueidentifier, ExtractDatabase uniqueidentifier, SourceTable varchar(100), DestSchema varchar(50), DestTable varchar(50), PrimaryKey varchar(100), Indexes varchar(200), LastSuccessfulCount int, CurrentCount int, Filter varchar(1000), Enabled bit, IgnoreMissing bit, Columns varchar(4000), Comments varchar(1000))
--INSERT INTO @VC3ETL_ExtractTable VALUES ('45374B74-5423-40EE-A85D-AE0F592E235B', 'EA75038A-D059-44BD-B49A-4CD68E0249B6', 'TeamMember', 'Datavalidation', 'TeamMember', 'StaffEmail,StudentRefID,IsCaseManager', NULL, 4, 4, NULL, 1, 1, NULL, NULL)

DECLARE @VC3ETL_FlatFileExtractTable TABLE (ID uniqueidentifier, Type char(1), FileName varchar(50))
--INSERT INTO @VC3ETL_FlatFileExtractTable VALUES ('45374B74-5423-40EE-A85D-AE0F592E235B', 'P', 'TeamMember.csv')

-- Insert records in the destination tables that do not already exist
INSERT INTO VC3ETL.ExtractDatabase SELECT Source.* FROM @VC3ETL_ExtractDatabase Source LEFT JOIN VC3ETL.ExtractDatabase Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.LoadTable SELECT Source.* FROM @VC3ETL_LoadTable Source LEFT JOIN VC3ETL.LoadTable Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
insert into dbo.EnrichFileFormatExtractDatabase select source.* from @dbo_EnrichFileFormatExtractDatabase source left join dbo.EnrichFileFormatExtractDatabase destination on source.ID = destination.ID where destination.ID is null
INSERT INTO dbo.InformExtractDatabase SELECT Source.* FROM @dbo_InformExtractDatabase Source LEFT JOIN dbo.InformExtractDatabase Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.FlatFileExtractTableType SELECT Source.* FROM @VC3ETL_FlatFileExtractTableType Source LEFT JOIN VC3ETL.FlatFileExtractTableType Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.ExtractTable SELECT Source.* FROM @VC3ETL_ExtractTable Source LEFT JOIN VC3ETL.ExtractTable Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.FlatFileExtractTable SELECT Source.* FROM @VC3ETL_FlatFileExtractTable Source LEFT JOIN VC3ETL.FlatFileExtractTable Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.FlatFileExtractDatabase SELECT Source.* FROM @VC3ETL_FlatFileExtractDatabase Source LEFT JOIN VC3ETL.FlatFileExtractDatabase Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL

-- Update records in the destination table that already exist
UPDATE Destination SET Destination.Type = Source.Type, Destination.DatabaseType = Source.DatabaseType, Destination.Server = Source.Server, Destination.DatabaseOwner = Source.DatabaseOwner, Destination.DatabaseName = Source.DatabaseName, Destination.Username = Source.Username, Destination.Password = Source.Password, Destination.LinkedServer = Source.LinkedServer, Destination.IsLinkedServerManaged = Source.IsLinkedServerManaged, Destination.LastExtractDate = Source.LastExtractDate, Destination.LastLoadDate = Source.LastLoadDate, Destination.SucceededEmail = Source.SucceededEmail, Destination.SucceededSubject = Source.SucceededSubject, Destination.SucceededMessage = Source.SucceededMessage, Destination.FailedEmail = Source.FailedEmail, Destination.FailedSubject = Source.FailedSubject, Destination.FailedMessage = Source.FailedMessage, Destination.RetainSnapshot = Source.RetainSnapshot, Destination.DestTableTempSuffix = Source.DestTableTempSuffix, Destination.DestTableFinalSuffix = Source.DestTableFinalSuffix, Destination.FileGroup = Source.FileGroup, Destination.Schedule = Source.Schedule, Destination.Name = Source.Name, Destination.Enabled = Source.Enabled FROM @VC3ETL_ExtractDatabase Source JOIN VC3ETL.ExtractDatabase Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.LocalCopyPath = Source.LocalCopyPath FROM @VC3ETL_FlatFileExtractDatabase Source JOIN VC3ETL.FlatFileExtractDatabase Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.LastExtractRosterYear = Source.LastExtractRosterYear, Destination.LastLoadRosterYear = Source.LastLoadRosterYear FROM @dbo_InformExtractDatabase Source JOIN dbo.InformExtractDatabase Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.Name = Source.Name, Destination.TextQualifier = Source.TextQualifier, Destination.ColumnDelimiter = Source.ColumnDelimiter FROM @VC3ETL_FlatFileExtractTableType Source JOIN VC3ETL.FlatFileExtractTableType Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.ExtractDatabase = Source.ExtractDatabase, Destination.SourceTable = Source.SourceTable, Destination.DestSchema = Source.DestSchema, Destination.DestTable = Source.DestTable, Destination.PrimaryKey = Source.PrimaryKey, Destination.Indexes = Source.Indexes, Destination.LastSuccessfulCount = Source.LastSuccessfulCount, Destination.CurrentCount = Source.CurrentCount, Destination.Filter = Source.Filter, Destination.Enabled = Source.Enabled, Destination.IgnoreMissing = Source.IgnoreMissing, Destination.Columns = Source.Columns, Destination.Comments = Source.Comments FROM @VC3ETL_ExtractTable Source JOIN VC3ETL.ExtractTable Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.Type = Source.Type, Destination.FileName = Source.FileName FROM @VC3ETL_FlatFileExtractTable Source JOIN VC3ETL.FlatFileExtractTable Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.ExtractDatabase = Source.ExtractDatabase, Destination.Sequence = Source.Sequence, Destination.SourceTable = Source.SourceTable, Destination.DestTable = Source.DestTable, Destination.HasMapTable = Source.HasMapTable, Destination.MapTable = Source.MapTable, Destination.KeyField = Source.KeyField, Destination.DeleteKey = Source.DeleteKey, Destination.ImportType = Source.ImportType, Destination.DeleteTrans = Source.DeleteTrans, Destination.UpdateTrans = Source.UpdateTrans, Destination.InsertTrans = Source.InsertTrans, Destination.Enabled = Source.Enabled, Destination.SourceTableFilter = Source.SourceTableFilter, Destination.DestTableFilter = Source.DestTableFilter, Destination.PurgeCondition = Source.PurgeCondition, Destination.KeepMappingAfterDelete = Source.KeepMappingAfterDelete, Destination.StartNewTransaction = Source.StartNewTransaction, Destination.LastLoadDate = Source.LastLoadDate, Destination.MapTableMapID = Source.MapTableMapID, Destination.Comments = Source.Comments FROM @VC3ETL_LoadTable Source JOIN VC3ETL.LoadTable Destination ON Source.ID = Destination.ID

set nocount off;

COMMIT TRAN
