IF EXISTS (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'LEGACYSPED' and TABLE_NAME = 'MAP_IepServiceCategoryID' and COLUMN_NAME = 'SubType')
BEGIN
	exec ('
		Select ServiceCategoryCode = SubType, DestID
		into LEGACYSPED.TEMP_MAP_IepServiceCategoryID 
		from LEGACYSPED.MAP_IepServiceCategoryID

		DROP TABLE LEGACYSPED.MAP_IepServiceCategoryID 

		select ServiceCategoryCode, DestID
		into LEGACYSPED.MAP_IepServiceCategoryID 
		from LEGACYSPED.TEMP_MAP_IepServiceCategoryID

		DROP TABLE LEGACYSPED.TEMP_MAP_IepServiceCategoryID
		
		ALTER TABLE LEGACYSPED.MAP_IepServiceCategoryID ADD CONSTRAINT
		PK_MAP_IepServiceCategoryID PRIMARY KEY CLUSTERED
		(
			ServiceCategoryCode
		)
		
		ALTER TABLE LEGACYSPED.MAP_IepServiceCategoryID ALTER COLUMN DestID uniqueidentifier NOT NULL
		')
END
GO
