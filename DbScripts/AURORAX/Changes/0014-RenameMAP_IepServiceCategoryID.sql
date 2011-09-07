IF EXISTS (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'AURORAX' and TABLE_NAME = 'MAP_IepServiceCategoryID' and COLUMN_NAME = 'SubType')
BEGIN
	exec ('
		Select ServiceCategoryCode = SubType, DestID
		into AURORAX.TEMP_MAP_IepServiceCategoryID 
		from AURORAX.MAP_IepServiceCategoryID

		DROP TABLE AURORAX.MAP_IepServiceCategoryID 

		select ServiceCategoryCode, DestID
		into AURORAX.MAP_IepServiceCategoryID 
		from AURORAX.TEMP_MAP_IepServiceCategoryID

		DROP TABLE AURORAX.TEMP_MAP_IepServiceCategoryID
		
		ALTER TABLE AURORAX.MAP_IepServiceCategoryID ADD CONSTRAINT
		PK_MAP_IepServiceCategoryID PRIMARY KEY CLUSTERED
		(
			ServiceCategoryCode
		)
		
		ALTER TABLE AURORAX.MAP_IepServiceCategoryID ALTER COLUMN DestID uniqueidentifier NOT NULL
		')
END
GO
