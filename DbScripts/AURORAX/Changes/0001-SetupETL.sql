--#assume VC3ETL:20

-- #############################################################################
-- ExtractDatabase Configuration
INSERT INTO VC3TaskScheduler.ScheduledTaskSchedule (ID, TaskTypeID, Parameters, IsEnabled, EnabledDate, LastRunTime, FrequencyAmount, FrequencyTypeID, YearTrigger, MonthTrigger, DayTrigger, HourTrigger, MinuteTrigger, MonTrigger, TuesTrigger, WedsTrigger, ThursTrigger, FriTrigger, SatTrigger, SunTrigger) VALUES ('B588BEC0-05E5-4891-8CF3-1D4FEDEE9EDC', 'F03A0C51-7294-4B57-AFB7-AFF136E4025F', '<?xml version="1.0" encoding="utf-16"?>  <ArrayOfDictionaryEntry xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">    <DictionaryEntry>      <Key xsi:type="xsd:string">DatabaseId</Key>      <Value xsi:type="xsd:string">A8385067-D3E0-4DEB-A646-08C2C2DF289B*84D37F9E-A389-4E56-812F-7378401F3347</Value>    </DictionaryEntry>    <DictionaryEntry>      <Key xsi:type="xsd:string">CreateSnapshot</Key>      <Value xsi:type="xsd:boolean">true</Value>    </DictionaryEntry>  </ArrayOfDictionaryEntry>', 0, getdate(), NULL, 1, 'D', NULL, NULL, NULL, 1, 30, 0, 0, 0, 0, 0, 0, 0)
INSERT VC3ETL.ExtractDatabase (ID,Type,DatabaseType,Server,DatabaseOwner,DatabaseName,Username,Password,LinkedServer,IsLinkedServerManaged,LastExtractDate,LastLoadDate,SucceededEmail,SucceededSubject,SucceededMessage,FailedEmail,FailedSubject,FailedMessage,RetainSnapshot,DestTableTempSuffix,DestTableFinalSuffix,FileGroup,Schedule,Name,Enabled) VALUES ('29D14961-928D-4BEE-9025-238496D144C6','84D37F9E-A389-4E56-812F-7378401F3347','58BA0C59-5087-4F38-B00B-F3480C93064B','\\10.0.1.26\FFDB\CO\AuroraPS',NULL,NULL,'DEVSERVER\FlatFileUser','vc3go!!',NULL,0,NULL,NULL,NULL,'[{BrandName}] {SisDatabase} import completed','Successfully imported {SnapshotRosterYear} {SisDatabase} data into {BrandName}.  {SisDatabase} data in {BrandName} is now current as of {SnapshotDate}.      Next Scheduled Import Time: {NextImportTime}',NULL,NULL,'[{BrandName}] {SisDatabase} import failed',1,'_NEW','_LOCAL',NULL,'B588BEC0-05E5-4891-8CF3-1D4FEDEE9EDC','Aurora PS Flat Files',1)
INSERT INTO VC3ETL.FlatFileExtractDatabase VALUES ('29D14961-928D-4BEE-9025-238496D144C6', 'D:\EnrichDataFiles')

INSERT dbo.InformExtractDatabase (ID) values ('29D14961-928D-4BEE-9025-238496D144C6') -- note :  this was added after upgrade_db was run, but this was already in the db from earlier testing
