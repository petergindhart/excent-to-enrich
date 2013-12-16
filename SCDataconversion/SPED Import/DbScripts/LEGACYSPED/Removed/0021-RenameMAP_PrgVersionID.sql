if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'LEGACYSPED' and TABLE_NAME = 'MAP_VersionID')
BEGIN
	exec ('
		if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = ''LEGACYSPED'' and TABLE_NAME = ''MAP_PrgVersionID'')
		DROP TABLE LEGACYSPED.MAP_PrgVersionID
		
		select IepRefID, DestID
 		into LEGACYSPED.MAP_PrgVersionID
		from LEGACYSPED.MAP_VersionID
		
		DROP TABLE LEGACYSPED.MAP_VersionID 
		
		ALTER TABLE LEGACYSPED.MAP_PrgVersionID ADD CONSTRAINT
		PK_MAP_PrgVersionID PRIMARY KEY CLUSTERED
		(
			IepRefID
		)

		-- delete map orphans		
		delete m 
		from LEGACYSPED.MAP_PrgVersionID m left join 
			dbo.PrgVersion v on m.DestID = v.ID
		where v.ID is null
		')
END
go

