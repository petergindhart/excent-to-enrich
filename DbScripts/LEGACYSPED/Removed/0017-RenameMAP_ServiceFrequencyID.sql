-- Keep the existing data if the data conversion has been run previously
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'LEGACYSPED' and TABLE_NAME = 'MAP_ServiceFrequencyID' and COLUMN_NAME = 'ServiceFrequencyName')
BEGIN
exec ('
	select ServiceFrequencyCode, ServiceFrequencyName = convert(varchar(50), ServiceFrequencyCode), DestID
	into LEGACYSPED.TEMP_MAP_ServiceFrequencyID
	from LEGACYSPED.MAP_ServiceFrequencyID

	DROP TABLE LEGACYSPED.MAP_ServiceFrequencyID 

	select ServiceFrequencyCode, ServiceFrequencyName, DestID
	into LEGACYSPED.MAP_ServiceFrequencyID
	from LEGACYSPED.TEMP_MAP_ServiceFrequencyID
	
	DROP TABLE LEGACYSPED.TEMP_MAP_ServiceFrequencyID
	

	ALTER TABLE LEGACYSPED.MAP_ServiceFrequencyID ADD CONSTRAINT
		PK_MAP_ServiceFrequencyID PRIMARY KEY CLUSTERED
		(
			ServiceFrequencyCode
		)

	CREATE INDEX IX_Map_ServiceFrequencyID_ServiceFrequencyName on LEGACYSPED.Map_ServiceFrequencyID (ServiceFrequencyName)
	')
END
