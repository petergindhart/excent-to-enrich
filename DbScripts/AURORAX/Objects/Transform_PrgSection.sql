
-- ############################################################################# 
-- Section
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_PrgSectionID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_PrgSectionID
(
	DefID uniqueidentifier NOT NULL,
	ItemID uniqueidentifier NOT NULL,
	DestID uniqueidentifier
)

ALTER TABLE AURORAX.MAP_PrgSectionID ADD CONSTRAINT
PK_MAP_PrgSectionID PRIMARY KEY CLUSTERED
(
	DefID, ItemID
)
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_PrgSection') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_PrgSection
GO

CREATE VIEW AURORAX.Transform_PrgSection
AS
	-- versioned sections -- select * from PrgSection
	SELECT
		s.DestID,
		ItemID = i.DestID,
		DefID = d.ID,
		VersionID = i.VersionDestID,
		FormInstanceID = cast(NULL as uniqueidentifier)
	FROM
		AURORAX.Transform_PrgIep i CROSS JOIN
		PrgSectionDef d LEFT JOIN 
		AURORAX.MAP_PrgSectionID s ON 
			s.ItemId = i.DestID AND
			s.DefID = d.ID
		--LEFT JOIN
		--FormInstance fi ON 
		--	s.FormInstanceID = fi.ID -- is it necessary to join to PrgItemForm ? -- select * from FormInstance
	WHERE
		d.ID IN
			(
				--'84E5A67D-CC9A-4D5B-A7B8-C04E8C3B8E0A', --IEP Goals
				'F050EF5E-3ED8-43D5-8FE7-B122502DE86A', --Sped Eligibility Determination
				'0CBA436F-8043-4D22-8F3D-289E057F1AAB', --IEP LRE
				'9AC79680-7989-4CC9-8116-1CCDB1D0AE5F', --IEP Services
				'427AF47C-A2D2-47F0-8057-7040725E3D89', --IEP Demographics
				'EE479921-3ECB-409A-96D7-61C8E7BA0E7B'  --IEP Dates
				/*
				-- SUPPORTED SECTION DEFINITION OPTIONS --
				select '''' + CAST(d.ID as varchar(36)) + ''', --' + t.Name, d.ItemDefID, t.*
				from PrgSectionType t join
				PrgSectionDef d on d.TypeID = t.ID and d.ItemDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' -- IEP - Converted
				where d.IsVersioned = 1
				order by t.Name
				*/
		)
union all
	-- non-versioned sections
	SELECT
		DestID = s.DestID,
		ItemID = i.DestID,
		DefID = d.ID,
		VersionID = NULL,
		FormInstanceID = cast(NULL as uniqueidentifier)
	FROM
		AURORAX.Transform_PrgIep i CROSS JOIN
		PrgSectionDef d LEFT JOIN -- left join???????
		AURORAX.MAP_PrgSectionID s ON 
			s.ItemId = i.DestID AND
			s.DefID = d.ID 
		--FormInstance fi ON
		--	s.FormInstanceID = fi.ID -- is it necessary to join to PrgItemForm ?
	WHERE
		d.ID IN
			(
				'D83A4710-A69F-4310-91F8-CB5BFFB1FE4C' --Sped Consent Services -- non-versioned, don't set the versionid, don't fail the join 
				/*
				-- SUPPORTED SECTION DEFINITION OPTIONS --
				select '''' + CAST(d.ID as varchar(36)) + ''', --' + t.Name, d.ItemDefID, t.*, d.*
				from PrgSectionType t join
					PrgSectionDef d on d.TypeID = t.ID and d.ItemDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' -- IEP - Converted
				where d.IsVersioned = 0
				order by t.Name
				*/
		)
GO
-- 



/*




GEO.ShowLoadTables PrgSection


set nocount on;
declare @n varchar(100) ; select @n = 'PrgSection'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	SourceTable = 'AURORAX.Transform_PrgSection'
	, HasMapTable = 1
	, MapTable = 'AURORAX.MAP_PrgSectionID'
	, KeyField = 'DefID, ItemID'
-- per Pete, after I made the ItemID part of the PK for MAP:      you'll need to avoid deleting sections for subsequent revisions of your converted IEPs though, right?
	--, DeleteKey = 'DestID'
	--, DeleteTrans = 1
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = 'd.ItemID in (select DestID from AURORAX.MAP_IepRefID)'
	, Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.*
-- UPDATE PrgSection SET VersionID=s.VersionID, DefID=s.DefID, FormInstanceID=s.FormInstanceID, ItemID=s.ItemID
FROM  PrgSection d JOIN 
	AURORAX.Transform_PrgSection  s ON s.DestID=d.ID
	AND d.ItemID in (select DestID from AURORAX.MAP_IepRefID)

-- INSERT AURORAX.MAP_PrgSectionID
SELECT DefID, ItemID, NEWID()
FROM AURORAX.Transform_PrgSection s
WHERE NOT EXISTS (SELECT * FROM PrgSection d WHERE s.DestID=d.ID)

-- INSERT PrgSection (ID, VersionID, DefID, FormInstanceID, ItemID)
SELECT s.DestID, s.VersionID, s.DefID, s.FormInstanceID, s.ItemID
FROM AURORAX.Transform_PrgSection s
WHERE NOT EXISTS (SELECT * FROM PrgSection d WHERE s.DestID=d.ID)




*/
