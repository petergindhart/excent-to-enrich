if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'LEGACYSPED' and TABLE_NAME = 'MAP_StudentRefID' and COLUMN_NAME = 'LegacyData')
BEGIN
	exec ('select m.StudentRefID, LegacyData = CAST(case when s.ManuallyEntered = 1 then 1 else 0 end as Bit), m.DestID
		into LEGACYSPED.TEMP_MAP_StudentRefID
		from LEGACYSPED.MAP_StudentRefID m join
			dbo.Student s on m.DestID = s.ID
		
		DROP TABLE LEGACYSPED.MAP_StudentRefID 

		select StudentRefID, LegacyData, DestID
		into LEGACYSPED.MAP_StudentRefID
		from LEGACYSPED.TEMP_MAP_StudentRefID
		
		DROP TABLE LEGACYSPED.TEMP_MAP_StudentRefID
		
		ALTER TABLE LEGACYSPED.MAP_StudentRefID ADD CONSTRAINT
		PK_MAP_StudentRefID PRIMARY KEY CLUSTERED
		(
		StudentRefID
		) 
		')
END
GO
