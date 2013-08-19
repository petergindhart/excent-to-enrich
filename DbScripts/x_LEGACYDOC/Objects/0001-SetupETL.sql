BEGIN TRAN

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_ExtractDatabase TABLE (ID uniqueidentifier, Type uniqueidentifier, DatabaseType uniqueidentifier, Server varchar(64), DatabaseOwner varchar(64), DatabaseName varchar(128), Username varchar(32), Password varchar(32), LinkedServer varchar(100), IsLinkedServerManaged bit, LastExtractDate datetime, LastLoadDate datetime, SucceededEmail varchar(500), SucceededSubject text, SucceededMessage text, FailedEmail varchar(500), FailedSubject text, FailedMessage text, RetainSnapshot bit, DestTableTempSuffix varchar(30), DestTableFinalSuffix varchar(30), FileGroup varchar(64), Schedule uniqueidentifier, Name varchar(100), Enabled bit)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_ExtractDatabase VALUES ( '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 'ACBEF25A-A8EB-465B-97D8-9738F07C3023', 'CBE6E716-95F0-44BC-837C-BBC4FD59506C', NULL, NULL, 'SPEDDOC', 'enrich_db_user', 'vc3go!!', NULL, 0, '1/1/1970', '1/1/1970', NULL, '[{BrandName}] {SisDatabase} import completed', 'Successfully imported {SisDatabase} data into {BrandName}.  {SisDatabase} data in {BrandName} is now current as of {SnapshotDate}.', NULL, '[{BrandName}] {SisDatabase} import failed', 'There was a problem importing {SisDatabase} data into {BrandName}:  {ErrorMessage}', 1, '_NEW', '_LOCAL', NULL, NULL, 'Legacy Documents', 1)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_ExtractTable TABLE (ID uniqueidentifier, ExtractDatabase uniqueidentifier, SourceTable varchar(100), DestSchema varchar(50), DestTable varchar(50), PrimaryKey varchar(100), Indexes varchar(200), LastSuccessfulCount int, CurrentCount int, Filter varchar(1000), Enabled bit, IgnoreMissing bit, Columns varchar(4000), Comments varchar(1000))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_ExtractTable VALUES ('642BB649-FF50-418E-9866-FE605880F8A1', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 'AllDocs', 'x_LEGACYDOC', 'AllDocs', 'DocumentRefID, DocumentType', NULL, 0, 0, NULL, 1, 0, NULL, NULL)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_LoadTable TABLE (ID uniqueidentifier, ExtractDatabase uniqueidentifier, Sequence int, SourceTable varchar(100), DestTable varchar(100), HasMapTable bit, MapTable varchar(100), KeyField varchar(250), DeleteKey varchar(50), ImportType int, DeleteTrans bit, UpdateTrans bit, InsertTrans bit, Enabled bit, SourceTableFilter varchar(1000), DestTableFilter varchar(1000), PurgeCondition varchar(1000), KeepMappingAfterDelete bit, StartNewTransaction bit, LastLoadDate datetime, MapTableMapID varchar(250), Comments varchar(1000))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_LoadTable VALUES ('5903F2EE-5984-4322-A3DF-9140F46A70F4', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 0, 'x_LEGACYDOC.Transform_FileData', 'FileData', 1, 'x_LEGACYDOC.MAP_FileDataID', 'DocumentRefID, StudentRefID, DocumentType', 'DestID', 1, 1, 0, 1, 1, null, 's.DestID in (select DestID from x_LEGACYDOC.MAP_FileDataID)', NULL, 0, 0, '1/1/1970', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('BD05E043-13D4-4250-85E2-D2976EDAB08F', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 1, 'x_LEGACYDOC.Transform_Attachment', 'Attachment', 1, 'x_LEGACYDOC.MAP_AttachmentID', 'DocumentRefID, StudentRefID, DocumentType', 'DestID', 1, 1, 0, 1, 1, null, 's.DestID in (select DestID from x_LEGACYDOC.MAP_AttachmentID)', NULL, 0, 0, '1/1/1970', NULL, NULL)

-- Declare a temporary table to hold the data to be synchronized    
DECLARE @VC3ETL_LoadColumn TABLE (ID uniqueidentifier, LoadTable uniqueidentifier, SourceColumn varchar(500), DestColumn varchar(500), ColumnType char(1), UpdateOnDelete bit, DeletedValue varchar(500), NullValue varchar(500), Comments varchar(1000))

--Insert the records represent each column in FileData Table
INSERT INTO @VC3ETL_LoadColumn VALUES ('7935E441-4DAD-4C72-8E75-5D8F7414F928', '5903F2EE-5984-4322-A3DF-9140F46A70F4', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('7E943201-DB4D-4564-9196-1CE796C2A202', '5903F2EE-5984-4322-A3DF-9140F46A70F4', 'OriginalName', 'OriginalName', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('67A6267D-705F-4D66-8714-81E5A727C09E', '5903F2EE-5984-4322-A3DF-9140F46A70F4', 'ReceivedDate', 'ReceivedDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('1777F73F-868A-4A95-9B66-A5BBE37B4BF8', '5903F2EE-5984-4322-A3DF-9140F46A70F4', 'MimeType', 'MimeType', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('9788C924-837C-4B72-89D0-70E21BE42562', '5903F2EE-5984-4322-A3DF-9140F46A70F4', 'Content', 'Content', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('A3426A15-853C-4BAB-BBD5-2B5813A17CB1', '5903F2EE-5984-4322-A3DF-9140F46A70F4', 'isTemporary', 'isTemporary', 'C', 0, NULL, NULL, NULL)

--Insert the records represent each column in Attachment Table
INSERT INTO @VC3ETL_LoadColumn VALUES ('697A8CE2-2A2F-4B27-8793-DE62C89977F5', 'BD05E043-13D4-4250-85E2-D2976EDAB08F', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('D370300D-22E7-4089-B355-C8D77FE605A2', 'BD05E043-13D4-4250-85E2-D2976EDAB08F', 'StudentID', 'StudentID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('691A7C4B-EFB9-4D45-A953-7860BBE75562', 'BD05E043-13D4-4250-85E2-D2976EDAB08F', 'ItemID', 'ItemID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('0FC6D3B4-E3E1-4AB6-9CDE-E1FF235223A0', 'BD05E043-13D4-4250-85E2-D2976EDAB08F', 'VersionID', 'VersionID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('D5D4F4A5-DED2-4E50-A971-41A778C7641B', 'BD05E043-13D4-4250-85E2-D2976EDAB08F', 'Label', 'Label', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('6E647552-DE0B-428E-8693-254A61DD2B42', 'BD05E043-13D4-4250-85E2-D2976EDAB08F', 'UploadUserID', 'UploadUserID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('53053677-B7C0-46AD-9EF4-5A9CD7185CB9', 'BD05E043-13D4-4250-85E2-D2976EDAB08F', 'FileID', 'FileID', 'C', 0, NULL, NULL, NULL)

--select * from VC3ETL.LoadTable Destination where ExtractDatabase = '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16'
--select * from VC3ETL.ExtractTable Destination where ExtractDatabase = '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16'

-- select * from VC3Deployment.Version where module = 'x_LEGACYDOC'


-- refactor 
delete Destination 
from VC3ETL.ExtractTable Destination left join 
@VC3ETL_ExtractTable Source on Destination.ID = Source.ID
where Destination.ExtractDatabase = '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16' and
Source.ID is null


delete Destination 
from VC3ETL.LoadTable Destination left join 
@VC3ETL_LoadTable Source on Destination.ID = Source.ID
where Destination.ExtractDatabase = '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16' and
Source.ID is null

--Delete the records from the VC3ETL.LoadColumn table by matching the constraints LoadColumn ID == null.  
delete Destination
from VC3ETL.LoadTable lt join
VC3ETL.LoadColumn Destination on lt.ID = Destination.LoadTable left join
@VC3ETL_LoadColumn Source on Destination.ID = Source.ID
where lt.ExtractDatabase = '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16' and
Source.ID is null


-- Insert records in the destination tables that do not already exist
INSERT INTO VC3ETL.ExtractDatabase SELECT Source.* FROM @VC3ETL_ExtractDatabase Source LEFT JOIN VC3ETL.ExtractDatabase Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.ExtractTable SELECT Source.* FROM @VC3ETL_ExtractTable Source LEFT JOIN VC3ETL.ExtractTable Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.LoadTable SELECT Source.* FROM @VC3ETL_LoadTable Source LEFT JOIN VC3ETL.LoadTable Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.LoadColumn SELECT Source.*, 1 FROM @VC3ETL_LoadColumn Source LEFT JOIN VC3ETL.LoadColumn Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL

-- Update records in the destination table that already exist
UPDATE Destination SET Destination.Type = Source.Type, Destination.DatabaseType = Source.DatabaseType, Destination.Server = Source.Server, Destination.DatabaseOwner = Source.DatabaseOwner, Destination.DatabaseName = Source.DatabaseName, Destination.Username = Source.Username, Destination.Password = Source.Password, Destination.LinkedServer = Source.LinkedServer, Destination.IsLinkedServerManaged = Source.IsLinkedServerManaged, Destination.LastExtractDate = Source.LastExtractDate, Destination.LastLoadDate = Source.LastLoadDate, Destination.SucceededEmail = Source.SucceededEmail, Destination.SucceededSubject = Source.SucceededSubject, Destination.SucceededMessage = Source.SucceededMessage, Destination.FailedEmail = Source.FailedEmail, Destination.FailedSubject = Source.FailedSubject, Destination.FailedMessage = Source.FailedMessage, Destination.RetainSnapshot = Source.RetainSnapshot, Destination.DestTableTempSuffix = Source.DestTableTempSuffix, Destination.DestTableFinalSuffix = Source.DestTableFinalSuffix, Destination.FileGroup = Source.FileGroup, Destination.Schedule = Source.Schedule, Destination.Name = Source.Name, Destination.Enabled = Source.Enabled FROM @VC3ETL_ExtractDatabase Source JOIN VC3ETL.ExtractDatabase Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.ExtractDatabase = Source.ExtractDatabase, Destination.SourceTable = Source.SourceTable, Destination.DestSchema = Source.DestSchema, Destination.DestTable = Source.DestTable, Destination.PrimaryKey = Source.PrimaryKey, Destination.Indexes = Source.Indexes, Destination.LastSuccessfulCount = Source.LastSuccessfulCount, Destination.CurrentCount = Source.CurrentCount, Destination.Filter = Source.Filter, Destination.Enabled = Source.Enabled, Destination.IgnoreMissing = Source.IgnoreMissing, Destination.Columns = Source.Columns, Destination.Comments = Source.Comments FROM @VC3ETL_ExtractTable Source JOIN VC3ETL.ExtractTable Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.ExtractDatabase = Source.ExtractDatabase, Destination.Sequence = Source.Sequence, Destination.SourceTable = Source.SourceTable, Destination.DestTable = Source.DestTable, Destination.HasMapTable = Source.HasMapTable, Destination.MapTable = Source.MapTable, Destination.KeyField = Source.KeyField, Destination.DeleteKey = Source.DeleteKey, Destination.ImportType = Source.ImportType, Destination.DeleteTrans = Source.DeleteTrans, Destination.UpdateTrans = Source.UpdateTrans, Destination.InsertTrans = Source.InsertTrans, Destination.Enabled = Source.Enabled, Destination.SourceTableFilter = Source.SourceTableFilter, Destination.DestTableFilter = Source.DestTableFilter, Destination.PurgeCondition = Source.PurgeCondition, Destination.KeepMappingAfterDelete = Source.KeepMappingAfterDelete, Destination.StartNewTransaction = Source.StartNewTransaction, Destination.LastLoadDate = Source.LastLoadDate, Destination.MapTableMapID = Source.MapTableMapID, Destination.Comments = Source.Comments FROM @VC3ETL_LoadTable Source JOIN VC3ETL.LoadTable Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.LoadTable = Source.LoadTable, Destination.SourceColumn = Source.SourceColumn, Destination.DestColumn = Source.DestColumn, Destination.ColumnType = Source.ColumnType, Destination.UpdateOnDelete = Source.UpdateOnDelete, Destination.DeletedValue = Source.DeletedValue, Destination.NullValue = Source.NullValue, Destination.Comments = Source.Comments FROM @VC3ETL_LoadColumn Source JOIN VC3ETL.LoadColumn Destination ON Source.ID = Destination.ID


--Rollback TRAN
set nocount off;

COMMIT TRAN

--select * from VC3ETL.LoadTable where ExtractDatabase = '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16'
--select * from VC3Deployment.Version where Module = 'x_LEGACYDOC'

--delete VC3Deployment.Version where Module = 'x_LEGACYDOC' and ID in (2718, 2719)
--select * from x_LEGACYDOC.IEPDoc

--17857 (active and referred).  16000+ active



