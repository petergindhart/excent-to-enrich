if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'AURORAX' and TABLE_NAME = 'MAP_StudentRefID' and COLUMN_NAME = 'LegacyData')
BEGIN
	exec ('select m.StudentRefID, LegacyData = CAST(case when s.ManuallyEntered = 1 then 1 else 0 end as Bit), m.DestID
		into AURORAX.TEMP_MAP_StudentRefID
		from AURORAX.MAP_StudentRefID m join
			dbo.Student s on m.DestID = s.ID
		
		DROP TABLE AURORAX.MAP_StudentRefID 

		select StudentRefID, LegacyData, DestID
		into AURORAX.MAP_StudentRefID
		from AURORAX.TEMP_MAP_StudentRefID
		
		DROP TABLE AURORAX.TEMP_MAP_StudentRefID')
END
GO
