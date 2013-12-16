
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'LEGACYSPED' and TABLE_NAME = 'MAP_PrgLocationID' and COLUMN_NAME = 'Code')
BEGIN
	exec ('
		select ServiceLocationCode = Code, DestID
		into LEGACYSPED.TEMP_MAP_PrgLocationID
		from LEGACYSPED.MAP_PrgLocationID
		
		DROP TABLE LEGACYSPED.MAP_PrgLocationID 

		select ServiceLocationCode, DestID
		into LEGACYSPED.MAP_PrgLocationID
		from LEGACYSPED.TEMP_MAP_PrgLocationID
		
		DROP TABLE LEGACYSPED.TEMP_MAP_PrgLocationID
		
		ALTER TABLE LEGACYSPED.MAP_PrgLocationID ADD CONSTRAINT
		PK_MAP_PrgLocationID PRIMARY KEY CLUSTERED
		(
			ServiceLocationCode
		)
		')
END
go
