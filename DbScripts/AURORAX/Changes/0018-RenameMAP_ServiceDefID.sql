if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'AURORAX' and TABLE_NAME = 'MAP_ServiceDefID' and COLUMN_NAME = 'ServiceCategoryCode')
BEGIN 
exec ('
	select 
		ServiceCategoryCode = cast(left(ServiceDefCode, charindex(''|'', ServiceDefCode)-1) as varchar(20)), 
		ServiceDefCode = reverse(left(reverse(ServiceDefCode), charindex(''|'', reverse(ServiceDefCode))-1)), 
		DestID
	into AURORAX.TEMP_MAP_ServiceDefID
	from AURORAX.MAP_ServiceDefID

	DROP TABLE AURORAX.MAP_ServiceDefID 

	select ServiceCategoryCode, ServiceDefCode, DestID
	into AURORAX.MAP_ServiceDefID
	from AURORAX.TEMP_MAP_ServiceDefID
	
	DROP TABLE AURORAX.TEMP_MAP_ServiceDefID
	
	alter table AURORAX.MAP_ServiceDefID 
		alter column ServiceCategoryCode varchar(20) not null
	alter table AURORAX.MAP_ServiceDefID 
		alter column ServiceDefCode varchar(150) not null
	alter table AURORAX.MAP_ServiceDefID 
		alter column DestID uniqueidentifier not null
	
	ALTER TABLE AURORAX.MAP_ServiceDefID ADD CONSTRAINT
		PK_MAP_ServiceDefID PRIMARY KEY CLUSTERED
		(
			ServiceCategoryCode, ServiceDefCode
		) 

	CREATE INDEX IX_MAP_ServiceDefID_DestID on AURORAX.MAP_ServiceDefID (DestID)
	
	delete m
	from AURORAX.MAP_ServiceDefID m left join
		ServiceDef t on m.DestID = t.ID
	where
		t.ID is null
	')
END
GO
