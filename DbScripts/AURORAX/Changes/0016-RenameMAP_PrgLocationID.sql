
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'AURORAX' and TABLE_NAME = 'MAP_PrgLocationID' and COLUMN_NAME = 'Code')
BEGIN
	exec ('
		select ServiceLocationCode = Code, DestID
		into AURORAX.TEMP_MAP_PrgLocationID
		from AURORAX.MAP_PrgLocationID
		
		DROP TABLE AURORAX.MAP_PrgLocationID 

		select ServiceLocationCode, DestID
		into AURORAX.MAP_PrgLocationID
		from AURORAX.TEMP_MAP_PrgLocationID
		
		DROP TABLE AURORAX.TEMP_MAP_PrgLocationID
		
		ALTER TABLE AURORAX.MAP_PrgLocationID ADD CONSTRAINT
		PK_MAP_PrgLocationID PRIMARY KEY CLUSTERED
		(
			ServiceLocationCode
		)
		')
END
go
