-- Keep the existing data if the data conversion has been run previously
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'AURORAX' and TABLE_NAME = 'MAP_ServiceFrequencyID' and COLUMN_NAME = 'ServiceFrequencyName')
BEGIN
exec ('
	select ServiceFrequencyCode, ServiceFrequencyName = convert(varchar(50), ServiceFrequencyCode), DestID
	into AURORAX.TEMP_MAP_ServiceFrequencyID
	from AURORAX.MAP_ServiceFrequencyID

	DROP TABLE AURORAX.MAP_ServiceFrequencyID 

	select ServiceFrequencyCode, ServiceFrequencyName, DestID
	into AURORAX.MAP_ServiceFrequencyID
	from AURORAX.TEMP_MAP_ServiceFrequencyID
	
	DROP TABLE AURORAX.TEMP_MAP_ServiceFrequencyID
	

	ALTER TABLE AURORAX.MAP_ServiceFrequencyID ADD CONSTRAINT
		PK_MAP_ServiceFrequencyID PRIMARY KEY CLUSTERED
		(
			ServiceFrequencyCode
		)

	CREATE INDEX IX_Map_ServiceFrequencyID_ServiceFrequencyName on AURORAX.Map_ServiceFrequencyID (ServiceFrequencyName)
	')
END
