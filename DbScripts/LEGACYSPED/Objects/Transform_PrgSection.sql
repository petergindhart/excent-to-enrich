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


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgSection') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgSection
GO

CREATE VIEW LEGACYSPED.Transform_PrgSection
AS
	SELECT
		s.DestID,
		ItemID = i.DestID,
		DefID = d.ID,
		VersionID = i.VersionDestID,
		FormInstanceID = cast(NULL as uniqueidentifier)
	FROM
		LEGACYSPED.Transform_PrgIep i CROSS JOIN
		PrgSectionDef d JOIN 
		LEGACYSPED.ImportPrgSections p on d.ID = p.SectionDefID and p.Enabled = 1 LEFT JOIN 
		LEGACYSPED.MAP_PrgSectionID s ON 
			s.VersionID = i.VersionDestID AND
			s.DefID = d.ID
GO




/*


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

begin tran testPrgSection
DELETE LEGACYSPED.MAP_PrgSectionID
FROM LEGACYSPED.Transform_PrgSection AS s RIGHT OUTER JOIN 
	LEGACYSPED.MAP_PrgSectionID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

DELETE PrgSection
FROM LEGACYSPED.MAP_PrgSectionID AS s RIGHT OUTER JOIN 
	PrgSection as d ON s.DestID=d.ID
WHERE s.DestID IS NULL AND 1=1 AND  d.VersionID in (select DestID from LEGACYSPED.MAP_PrgVersionID)

UPDATE PrgSection
SET VersionID=s.VersionID, DefID=s.DefID, FormInstanceID=s.FormInstanceID, ItemID=s.ItemID
FROM  PrgSection d JOIN 
	LEGACYSPED.Transform_PrgSection  s ON s.DestID=d.ID
	AND d.VersionID in (select DestID from LEGACYSPED.MAP_PrgVersionID)

INSERT LEGACYSPED.MAP_PrgSectionID
SELECT DefID, VersionID, NEWID()
FROM LEGACYSPED.Transform_PrgSection s
WHERE NOT EXISTS (SELECT * FROM PrgSection d WHERE s.DestID=d.ID)

Msg 2627, Level 14, State 1, Line 19
Violation of PRIMARY KEY constraint 'PK_MAP_PrgSectionID'. Cannot insert duplicate key in object 'LEGACYSPED.MAP_PrgSectionID'.
The statement has been terminated.


INSERT PrgSection (ID, VersionID, DefID, FormInstanceID, ItemID)
SELECT s.DestID, s.VersionID, s.DefID, s.FormInstanceID, s.ItemID
FROM LEGACYSPED.Transform_PrgSection s
WHERE NOT EXISTS (SELECT * FROM PrgSection d WHERE s.DestID=d.ID)





	SELECT DefID, VersionID, count(*) 
	FROM LEGACYSPED.Transform_PrgSection s
	WHERE NOT EXISTS (SELECT * FROM PrgSection d WHERE s.DestID=d.ID)
	group by DefID, VersionID
	-- 0 dups

	SELECT s.DefID, s.VersionID, m.*
	FROM LEGACYSPED.Transform_PrgSection s left join
		LEGACYSPED.MAP_PrgSectionID m on s.DefID = m.DefID and s.VersionID = m.VersionID
	WHERE NOT EXISTS (SELECT * FROM PrgSection d WHERE s.DestID=d.ID)
and m.DefID is not null

select m.*
from LEGACYSPED.MAP_PrgSectionID m 
left join PrgSection s on m.DestID = s.ID
where s.ID is null





rollback tran testPrgSection

select * from PrgSection



*/
