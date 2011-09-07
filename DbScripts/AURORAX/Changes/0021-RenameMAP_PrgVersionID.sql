if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'AURORAX' and TABLE_NAME = 'MAP_VersionID')
BEGIN
	exec ('
		if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = ''AURORAX'' and TABLE_NAME = ''MAP_PrgVersionID'')
		DROP TABLE AURORAX.MAP_PrgVersionID
		
		select IepRefID, DestID
 		into AURORAX.MAP_PrgVersionID
		from AURORAX.MAP_VersionID
		
		DROP TABLE AURORAX.MAP_VersionID 
		
		ALTER TABLE AURORAX.MAP_PrgVersionID ADD CONSTRAINT
		PK_MAP_PrgVersionID PRIMARY KEY CLUSTERED
		(
			IepRefID
		)
		')
END
go

