BEGIN TRAN

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_ExtractDatabase TABLE (ID uniqueidentifier, Type uniqueidentifier, DatabaseType uniqueidentifier, Server varchar(64), DatabaseOwner varchar(64), DatabaseName varchar(128), Username varchar(32), Password varchar(32), LinkedServer varchar(100), IsLinkedServerManaged bit, LastExtractDate datetime, LastLoadDate datetime, SucceededEmail varchar(500), SucceededSubject text, SucceededMessage text, FailedEmail varchar(500), FailedSubject text, FailedMessage text, RetainSnapshot bit, DestTableTempSuffix varchar(30), DestTableFinalSuffix varchar(30), FileGroup varchar(64), Schedule uniqueidentifier, Name varchar(100), Enabled bit)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_ExtractDatabase VALUES ( '54DD3C28-8F7F-4A54-BCF1-975173CB485C', 'ACBEF25A-A8EB-465B-97D8-9738F07C3023', 'CBE6E716-95F0-44BC-837C-BBC4FD59506C', NULL, NULL, 'Bamberg1_EO_SC', 'sa', 'vc3go!!', NULL, 0, '1/1/1970', '1/1/1970', NULL, '[{BrandName}] {SisDatabase} import completed', 'Successfully imported {SisDatabase} data into {BrandName}.  {SisDatabase} data in {BrandName} is now current as of {SnapshotDate}.', NULL, '[{BrandName}] {SisDatabase} import failed', 'There was a problem importing {SisDatabase} data into {BrandName}:  {ErrorMessage}', 1, '_NEW', '_LOCAL', NULL, NULL, 'SPEDDatavalidation_EO', 1)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_ExtractTable TABLE (ID uniqueidentifier, ExtractDatabase uniqueidentifier, SourceTable varchar(100), DestSchema varchar(50), DestTable varchar(50), PrimaryKey varchar(100), Indexes varchar(200), LastSuccessfulCount int, CurrentCount int, Filter varchar(1000), Enabled bit, IgnoreMissing bit, Columns varchar(4000), Comments varchar(1000))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_ExtractTable VALUES ('2B5855E1-F52C-4317-B75E-B7810B8A4518', '54DD3C28-8F7F-4A54-BCF1-975173CB485C', 'SelectLists_EO', 'x_DATAVALIDATION', 'SelectLists', 'Line_No', NULL, 0, 0, NULL, 1, 0, NULL, NULL)
INSERT INTO @VC3ETL_ExtractTable VALUES ('F0F552E9-F2A6-4081-906F-C7542C3EBB9D', '54DD3C28-8F7F-4A54-BCF1-975173CB485C', 'District_EO', 'x_DATAVALIDATION', 'District', 'Line_No', NULL, 0, 0, NULL, 1, 0, NULL, NULL)
INSERT INTO @VC3ETL_ExtractTable VALUES ('ECA30168-3737-4D10-A243-45C9694AE11A', '54DD3C28-8F7F-4A54-BCF1-975173CB485C', 'School_EO', 'x_DATAVALIDATION', 'School', 'Line_No', NULL, 0, 0, NULL, 1, 0, NULL, NULL)
INSERT INTO @VC3ETL_ExtractTable VALUES ('93048F0D-D557-4136-AC06-AC1F595FF9D0', '54DD3C28-8F7F-4A54-BCF1-975173CB485C', 'Student_EO', 'x_DATAVALIDATION', 'Student', 'Line_No', NULL, 0, 0, NULL, 1, 0, NULL, NULL)
INSERT INTO @VC3ETL_ExtractTable VALUES ('191BBBE1-48DF-4B18-814C-CD02B2CE5D9D', '54DD3C28-8F7F-4A54-BCF1-975173CB485C', 'IEP_EO', 'x_DATAVALIDATION', 'IEP', 'Line_No', NULL, 0, 0, NULL, 1, 0, NULL, NULL)
INSERT INTO @VC3ETL_ExtractTable VALUES ('0E8B64ED-BA35-4044-BDF0-CD654F90B30B', '54DD3C28-8F7F-4A54-BCF1-975173CB485C', 'SpedStaffMember_EO', 'x_DATAVALIDATION', 'SpedStaffMember', 'Line_No', NULL, 0, 0, NULL, 1, 0, NULL, NULL)
INSERT INTO @VC3ETL_ExtractTable VALUES ('0D930F3F-F8F6-4E16-9F6D-BBF44698D784', '54DD3C28-8F7F-4A54-BCF1-975173CB485C', 'Service_EO', 'x_DATAVALIDATION', 'Service', 'Line_No', NULL, 0, 0, NULL, 1, 0, NULL, NULL)
INSERT INTO @VC3ETL_ExtractTable VALUES ('1E2836F3-933A-4C59-96DC-91869D24851E', '54DD3C28-8F7F-4A54-BCF1-975173CB485C', 'Goal_EO', 'x_DATAVALIDATION', 'Goal', 'Line_No', NULL, 0, 0, NULL, 1, 0, NULL, NULL)
INSERT INTO @VC3ETL_ExtractTable VALUES ('9DA1CE10-BE59-4E3E-970C-7E4DF3BA7E75', '54DD3C28-8F7F-4A54-BCF1-975173CB485C', 'Objective_EO', 'x_DATAVALIDATION', 'Objective', 'Line_No', NULL, 0, 0, NULL, 1, 0, NULL, NULL)
INSERT INTO @VC3ETL_ExtractTable VALUES ('BD49ABC8-9F7F-4C27-A228-6F0BBC834033', '54DD3C28-8F7F-4A54-BCF1-975173CB485C', 'TeamMember_EO', 'x_DATAVALIDATION', 'TeamMember', 'Line_No', NULL, 0, 0, NULL, 1, 0, NULL, NULL)
INSERT INTO @VC3ETL_ExtractTable VALUES ('B379A9C8-7476-4027-9E3F-E795D139C6DA', '54DD3C28-8F7F-4A54-BCF1-975173CB485C', 'StaffSchool_EO', 'x_DATAVALIDATION', 'StaffSchool','Line_No', NULL, 0, 0, NULL, 1, 0, NULL, NULL)

DECLARE @VC3ETL_LoadTable TABLE (ID uniqueidentifier, ExtractDatabase uniqueidentifier, Sequence int, SourceTable varchar(100), DestTable varchar(100), HasMapTable bit, MapTable varchar(100), KeyField varchar(250), DeleteKey varchar(50), ImportType int, DeleteTrans bit, UpdateTrans bit, InsertTrans bit, Enabled bit, SourceTableFilter varchar(1000), DestTableFilter varchar(1000), PurgeCondition varchar(1000), KeepMappingAfterDelete bit, StartNewTransaction bit, LastLoadDate datetime, MapTableMapID varchar(250), Comments varchar(1000))

INSERT INTO @VC3ETL_LoadTable VALUES ('D25B860A-C22E-45EB-B330-254A5B9E9FFF', '54DD3C28-8F7F-4A54-BCF1-975173CB485C', 1, 'x_DATAVALIDATION.ExtractDataFile_EO', NULL, 0, NULL, NULL, NULL, 4, 0, 0, 0, 1, NULL, NULL, NULL, 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)

-- refactor 
delete Destination 
from VC3ETL.ExtractTable Destination left join 
@VC3ETL_ExtractTable Source on Destination.ID = Source.ID
where Destination.ExtractDatabase = '54DD3C28-8F7F-4A54-BCF1-975173CB485C' and
Source.ID is null

-- Insert records in the destination tables that do not already exist
INSERT INTO VC3ETL.ExtractDatabase SELECT Source.* FROM @VC3ETL_ExtractDatabase Source LEFT JOIN VC3ETL.ExtractDatabase Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.ExtractTable SELECT Source.* FROM @VC3ETL_ExtractTable Source LEFT JOIN VC3ETL.ExtractTable Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.LoadTable SELECT Source.* FROM @VC3ETL_LoadTable Source LEFT JOIN VC3ETL.LoadTable Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL

-- Update records in the destination table that already exist
UPDATE Destination SET Destination.Type = Source.Type, Destination.DatabaseType = Source.DatabaseType, Destination.Server = Source.Server, Destination.DatabaseOwner = Source.DatabaseOwner, Destination.DatabaseName = Source.DatabaseName, Destination.Username = Source.Username, Destination.Password = Source.Password, Destination.LinkedServer = Source.LinkedServer, Destination.IsLinkedServerManaged = Source.IsLinkedServerManaged, Destination.LastExtractDate = Source.LastExtractDate, Destination.LastLoadDate = Source.LastLoadDate, Destination.SucceededEmail = Source.SucceededEmail, Destination.SucceededSubject = Source.SucceededSubject, Destination.SucceededMessage = Source.SucceededMessage, Destination.FailedEmail = Source.FailedEmail, Destination.FailedSubject = Source.FailedSubject, Destination.FailedMessage = Source.FailedMessage, Destination.RetainSnapshot = Source.RetainSnapshot, Destination.DestTableTempSuffix = Source.DestTableTempSuffix, Destination.DestTableFinalSuffix = Source.DestTableFinalSuffix, Destination.FileGroup = Source.FileGroup, Destination.Schedule = Source.Schedule, Destination.Name = Source.Name, Destination.Enabled = Source.Enabled FROM @VC3ETL_ExtractDatabase Source JOIN VC3ETL.ExtractDatabase Destination ON Source.ID = Destination.ID

UPDATE Destination SET Destination.ExtractDatabase = Source.ExtractDatabase, Destination.SourceTable = Source.SourceTable, Destination.DestSchema = Source.DestSchema, Destination.DestTable = Source.DestTable, Destination.PrimaryKey = Source.PrimaryKey, Destination.Indexes = Source.Indexes, Destination.LastSuccessfulCount = Source.LastSuccessfulCount, Destination.CurrentCount = Source.CurrentCount, Destination.Filter = Source.Filter, Destination.Enabled = Source.Enabled, Destination.IgnoreMissing = Source.IgnoreMissing, Destination.Columns = Source.Columns, Destination.Comments = Source.Comments FROM @VC3ETL_ExtractTable Source JOIN VC3ETL.ExtractTable Destination ON Source.ID = Destination.ID

UPDATE Destination SET Destination.ExtractDatabase = Source.ExtractDatabase, Destination.Sequence = Source.Sequence, Destination.SourceTable = Source.SourceTable, Destination.DestTable = Source.DestTable, Destination.HasMapTable = Source.HasMapTable, Destination.MapTable = Source.MapTable, Destination.KeyField = Source.KeyField, Destination.DeleteKey = Source.DeleteKey, Destination.ImportType = Source.ImportType, Destination.DeleteTrans = Source.DeleteTrans, Destination.UpdateTrans = Source.UpdateTrans, Destination.InsertTrans = Source.InsertTrans, Destination.Enabled = Source.Enabled, Destination.SourceTableFilter = Source.SourceTableFilter, Destination.DestTableFilter = Source.DestTableFilter, Destination.PurgeCondition = Source.PurgeCondition, Destination.KeepMappingAfterDelete = Source.KeepMappingAfterDelete, Destination.StartNewTransaction = Source.StartNewTransaction, Destination.LastLoadDate = Source.LastLoadDate, Destination.MapTableMapID = Source.MapTableMapID, Destination.Comments = Source.Comments FROM @VC3ETL_LoadTable Source JOIN VC3ETL.LoadTable Destination ON Source.ID = Destination.ID

set nocount off;

COMMIT TRAN



