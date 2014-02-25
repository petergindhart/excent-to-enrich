if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'LEGACYSPED' and TABLE_NAME = 'MAP_ServiceDefID' and COLUMN_NAME = 'ServiceCategoryCode')
BEGIN 
exec ('
	select 
		ServiceCategoryCode = cast(left(ServiceDefCode, charindex(''|'', ServiceDefCode)-1) as varchar(20)), 
		ServiceDefCode = reverse(left(reverse(ServiceDefCode), charindex(''|'', reverse(ServiceDefCode))-1)), 
		DestID
	into LEGACYSPED.TEMP_MAP_ServiceDefID
	from LEGACYSPED.MAP_ServiceDefID

	DROP TABLE LEGACYSPED.MAP_ServiceDefID 

	select ServiceCategoryCode, ServiceDefCode, DestID
	into LEGACYSPED.MAP_ServiceDefID
	from LEGACYSPED.TEMP_MAP_ServiceDefID
	
	DROP TABLE LEGACYSPED.TEMP_MAP_ServiceDefID
	
	alter table LEGACYSPED.MAP_ServiceDefID 
		alter column ServiceCategoryCode varchar(20) not null
	alter table LEGACYSPED.MAP_ServiceDefID 
		alter column ServiceDefCode varchar(150) not null
	alter table LEGACYSPED.MAP_ServiceDefID 
		alter column DestID uniqueidentifier not null
	
	ALTER TABLE LEGACYSPED.MAP_ServiceDefID ADD CONSTRAINT
		PK_MAP_ServiceDefID PRIMARY KEY CLUSTERED
		(
			ServiceCategoryCode, ServiceDefCode
		) 

	CREATE INDEX IX_MAP_ServiceDefID_DestID on LEGACYSPED.MAP_ServiceDefID (DestID)
	
	delete m
	from LEGACYSPED.MAP_ServiceDefID m left join
		ServiceDef t on m.DestID = t.ID
	where
		t.ID is null
	')
END
GO
