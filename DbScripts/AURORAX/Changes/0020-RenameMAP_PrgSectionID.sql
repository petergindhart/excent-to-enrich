-- NOTE:  This assumes that AURORAX.MAP_PrgSectionID is empty!

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'AURORAX' and TABLE_NAME = 'MAP_SectionID')
BEGIN
	exec ('
		SELECT m.DefID, m.VersionID, m.DestID
		INTO AURORAX.MAP_PrgSectionID
		FROM AURORAX.Map_SectionID m
		
		DROP TABLE AURORAX.Map_SectionID 
		
		ALTER TABLE AURORAX.MAP_PrgSectionID ALTER COLUMN DestID uniqueidentifier NOT NULL
		
		ALTER TABLE AURORAX.MAP_PrgSectionID ADD CONSTRAINT
		PK_MAP_PrgSectionID PRIMARY KEY CLUSTERED
		(
			DefID, VersionID
		)
		')
END


-- unwinding this change after discovering attempt to insert duplicate records into PrgSection where target database had multiple versions of a section

--if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'AURORAX' and TABLE_NAME = 'MAP_SectionID')
--BEGIN
--	exec ('
--		if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = ''AURORAX'' and TABLE_NAME = ''MAP_PrgSectionID'')
--		DROP TABLE AURORAX.MAP_PrgSectionID

--		select m.DefID, m.VersionID, m.DestID
--		into AURORAX.MAP_PrgSectionID
--		from AURORAX.Map_SectionID 
		
--		DROP TABLE AURORAX.Map_SectionID 
		
--		ALTER TABLE AURORAX.MAP_PrgSectionID ALTER COLUMN DestID uniqueidentifier NOT NULL
		
--		ALTER TABLE AURORAX.MAP_PrgSectionID ADD CONSTRAINT
--		PK_MAP_PrgSectionID PRIMARY KEY CLUSTERED
--		(
--			DefID, VersionID
--		)
--		')
--END
--GO

