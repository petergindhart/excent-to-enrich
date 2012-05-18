--#assume VC3ETL:20

-- #############################################################################
-- Task Configuration
INSERT INTO VC3TaskScheduler.ScheduledTaskType VALUES ( 
'BDFBC128-AFA3-4215-8A36-88D4BFD21CDC', 
'Data Import', 
'VC3.TestView.ScheduledTasks.DataImportTask,VC3.TestView' )

INSERT INTO VC3ETL.ExtractType values (
'ACBEF25A-A8EB-465B-97D8-9738F07C3023', 
'Data Import')

-- #############################################################################
-- ExtractDatabase Configuration
INSERT INTO VC3ETL.ExtractDatabase VALUES ( 
'9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 
'ACBEF25A-A8EB-465B-97D8-9738F07C3023', 
'CBE6E716-95F0-44BC-837C-BBC4FD59506C', 
NULL, 
NULL, 
'ExcentOnlineFL', 
'DCB1_FL_LEE', 
'vc3go!!', 
NULL, 
0, 
NULL, 
NULL, 
NULL, 
'[{BrandName}] {SisDatabase} import completed', 
'Successfully imported {SisDatabase} data into {BrandName}.  {SisDatabase} data in {BrandName} is now current as of {SnapshotDate}.', 
NULL, 
'[{BrandName}] {SisDatabase} import failed', 'There was a problem importing {SisDatabase} data into {BrandName}:  {ErrorMessage}', 
1, 
'_NEW', 
'_LOCAL', 
NULL, 
NULL, 
'Excent Online', 
0)
