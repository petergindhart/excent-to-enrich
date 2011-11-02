--#include Transform_PrgIep.sql
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_Section') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_Section
GO
-- ############################################################################# 
-- Section
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgSectionID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgSectionID
(
	DefID uniqueidentifier NOT NULL,
	VersionID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgSectionID ADD CONSTRAINT
PK_MAP_PrgSectionID PRIMARY KEY CLUSTERED
(
	DefID, VersionID
)
END
GO

-- ############################################################################# 
-- Section
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgSectionID_NonVersioned') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgSectionID_NonVersioned
(
	DefID uniqueidentifier NOT NULL,
	ItemID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgSectionID_NonVersioned ADD CONSTRAINT
PK_MAP_PrgSectionID_NonVersioned PRIMARY KEY CLUSTERED
(
	DefID, ItemID
)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgSection') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgSection
GO

CREATE VIEW LEGACYSPED.Transform_PrgSection
AS
	SELECT
		DestID = case when t.CanVersion = 1 then s.DestID else nvm.DestID end, -- when versioned, use the version map, when non-versioned use that map
		ItemID = i.DestID,
		DefID = d.ID,
		VersionID = CASE WHEN t.CanVersion = 1 THEN i.VersionDestID ELSE CAST(NULL as uniqueidentifier) END,
		FormInstanceID = cast(NULL as uniqueidentifier)
	FROM
		LEGACYSPED.Transform_PrgIep i CROSS JOIN
		PrgSectionDef d JOIN 
		PrgSectionType t on d.TypeID = t.ID JOIN
		LEGACYSPED.ImportPrgSections p on d.ID = p.SectionDefID and p.Enabled = 1 LEFT JOIN 
		LEGACYSPED.MAP_PrgSectionID s ON 
			s.VersionID = i.VersionDestID AND
			s.DefID = d.ID LEFT JOIN
		LEGACYSPED.MAP_PrgSectionID_NonVersioned nvm ON
			nvm.ItemID = i.DestID AND
			nvm.DefID = d.ID 
GO




/*

IF EXISTS (SELECT * FROM LEGACYSPED.ImportPrgSections a LEfT JOIN PrgSectionDef b ON a.SectionDefID = b.Id WHERE a.Enabled = 1)
	RAISERROR .....


GEO.ShowLoadTables PrgSection


set nocount on;
declare @n varchar(100) ; select @n = 'PrgSection'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	SourceTable = 'LEGACYSPED.Transform_PrgSection'
	, HasMapTable = 1
	, MapTable = 'LEGACYSPED.MAP_PrgSectionID'
	, KeyField = 'DefID, VersionID'
-- per Pete, after I made the ItemID part of the PK for MAP:      you'll need to avoid deleting sections for subsequent revisions of your converted IEPs though, right?
	--, DeleteKey = 'DestID'
	--, DeleteTrans = 1
	, DeleteKey = 'DestID'
	, DeleteTrans = 1
	, UpdateTrans = 1
	, DestTableFilter = 'd.VersionID in (select DestID from LEGACYSPED.MAP_PrgVersionID)'
	, Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n



select * from vc3etl.loadtable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' order by sequence

--insert vc3etl.loadcolumn 
--select newid(), 'CF569976-7A7D-4DE8-8BD8-26E0563E0751', SourceColumn, DestColumn, COlumnType, UpdateOnDelete, DeletedValue, NullValue
--from vc3etl.loadcolumn where loadtable = 'BED8E644-368F-4AE7-81D7-E7FFBDBFA9B6'


BED8E644-368F-4AE7-81D7-E7FFBDBFA9B6
CF569976-7A7D-4DE8-8BD8-26E0563E0751

declare @t uniqueidentifier ; select @t = 'BED8E644-368F-4AE7-81D7-E7FFBDBFA9B6'
exec VC3ETL.LoadTable_Run @t, '', 1, 0


begin tran testPrgSection

-- non-versioned

select d.*
-- DELETE LEGACYSPED.MAP_PrgSectionID_NonVersioned
FROM (select * from LEGACYSPED.Transform_PrgSection where VersionID IS NULL) AS s RIGHT OUTER JOIN 
	LEGACYSPED.MAP_PrgSectionID_NonVersioned as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

select d.*
-- DELETE PrgSection
FROM LEGACYSPED.MAP_PrgSectionID_NonVersioned AS s RIGHT OUTER JOIN 
	PrgSection as d ON s.DestID=d.ID
WHERE s.DestID IS NULL AND 1=1 AND  d.VersionID IS NULL AND d.ItemID in (select DestID from LEGACYSPED.MAP_IepRefID)

select d.*
-- UPDATE PrgSection SET ItemID=s.ItemID, VersionID=s.VersionID, FormInstanceID=s.FormInstanceID, DefID=s.DefID
FROM  PrgSection d JOIN 
	(select * from LEGACYSPED.Transform_PrgSection where VersionID IS NULL)  s ON s.DestID=d.ID
	AND d.VersionID IS NULL AND d.ItemID in (select DestID from LEGACYSPED.MAP_IepRefID)


begin tran testPrgSection2

INSERT LEGACYSPED.MAP_PrgSectionID_NonVersioned
SELECT DefID, ItemID, NEWID()
FROM (select * from LEGACYSPED.Transform_PrgSection where VersionID IS NULL) s
WHERE NOT EXISTS (SELECT * FROM PrgSection d WHERE s.DestID=d.ID)

INSERT PrgSection (ID, ItemID, VersionID, FormInstanceID, DefID)
SELECT s.DestID, s.ItemID, s.VersionID, s.FormInstanceID, s.DefID						-- s.DestID is null
FROM (select * from LEGACYSPED.Transform_PrgSection where VersionID IS NULL) s
WHERE NOT EXISTS (SELECT * FROM PrgSection d WHERE s.DestID=d.ID)

rollback tran testPrgSection2





-- versioned

begin tran testsec3
DELETE LEGACYSPED.MAP_PrgSectionID
FROM (select * from LEGACYSPED.Transform_PrgSection where VersionID IS NOT NULL) AS s RIGHT OUTER JOIN 
	LEGACYSPED.MAP_PrgSectionID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

DELETE PrgSection
FROM LEGACYSPED.MAP_PrgSectionID AS s RIGHT OUTER JOIN 
	PrgSection as d ON s.DestID=d.ID
WHERE s.DestID IS NULL AND 1=1 AND  d.VersionID in (select DestID from LEGACYSPED.MAP_PrgVersionID)


UPDATE PrgSection
SET VersionID=s.VersionID, DefID=s.DefID, FormInstanceID=s.FormInstanceID, ItemID=s.ItemID
FROM  PrgSection d JOIN 
	(select * from LEGACYSPED.Transform_PrgSection where VersionID IS NOT NULL)  s ON s.DestID=d.ID
	AND d.VersionID in (select DestID from LEGACYSPED.MAP_PrgVersionID)

INSERT LEGACYSPED.MAP_PrgSectionID
SELECT DefID, VersionID, NEWID()
FROM (select * from LEGACYSPED.Transform_PrgSection where VersionID IS NOT NULL) s
WHERE NOT EXISTS (SELECT * FROM PrgSection d WHERE s.DestID=d.ID)

INSERT PrgSection (ID, VersionID, DefID, FormInstanceID, ItemID)
SELECT s.DestID, s.VersionID, s.DefID, s.FormInstanceID, s.ItemID
FROM (select * from LEGACYSPED.Transform_PrgSection where VersionID IS NOT NULL) s
WHERE NOT EXISTS (SELECT * FROM PrgSection d WHERE s.DestID=d.ID)



rollback tran testsec3




rollback tran testPrgSection







select * from PrgSection



*/
