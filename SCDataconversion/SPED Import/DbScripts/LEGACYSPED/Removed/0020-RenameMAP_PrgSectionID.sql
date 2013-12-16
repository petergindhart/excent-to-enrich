-- NOTE:  This assumes that LEGACYSPED.MAP_PrgSectionID is empty!

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'LEGACYSPED' and TABLE_NAME = 'MAP_SectionID')
BEGIN
	exec ('
		SELECT m.DefID, m.VersionID, m.DestID
		INTO LEGACYSPED.MAP_PrgSectionID
		FROM LEGACYSPED.Map_SectionID m
		
		DROP TABLE LEGACYSPED.Map_SectionID 
		
		ALTER TABLE LEGACYSPED.MAP_PrgSectionID ALTER COLUMN DestID uniqueidentifier NOT NULL
		
		ALTER TABLE LEGACYSPED.MAP_PrgSectionID ADD CONSTRAINT
		PK_MAP_PrgSectionID PRIMARY KEY CLUSTERED
		(
			DefID, VersionID
		)
		
		-- delete map orphans
		delete m
		from LEGACYSPED.MAP_PrgSectionID m 
		left join PrgSection s on m.DestID = s.ID
		where s.ID is null
		')
END


-- unwinding this change after discovering attempt to insert duplicate records into PrgSection where target database had multiple versions of a section

--if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'LEGACYSPED' and TABLE_NAME = 'MAP_SectionID')
--BEGIN
--	exec ('
--		if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = ''LEGACYSPED'' and TABLE_NAME = ''MAP_PrgSectionID'')
--		DROP TABLE LEGACYSPED.MAP_PrgSectionID

--		select m.DefID, m.VersionID, m.DestID
--		into LEGACYSPED.MAP_PrgSectionID
--		from LEGACYSPED.Map_SectionID 
		
--		DROP TABLE LEGACYSPED.Map_SectionID 
		
--		ALTER TABLE LEGACYSPED.MAP_PrgSectionID ALTER COLUMN DestID uniqueidentifier NOT NULL
		
--		ALTER TABLE LEGACYSPED.MAP_PrgSectionID ADD CONSTRAINT
--		PK_MAP_PrgSectionID PRIMARY KEY CLUSTERED
--		(
--			DefID, VersionID
--		)
--		')
--END
--GO

