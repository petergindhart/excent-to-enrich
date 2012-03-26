
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgItemOutcome') AND OBJECTPROPERTY(id, N'IsView') = 1) 
DROP VIEW LEGACYSPED.Transform_PrgItemOutcome
GO 
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_InvolvementStatus') AND OBJECTPROPERTY(id, N'IsView') = 1) 
DROP VIEW LEGACYSPED.Transform_InvolvementStatus
GO 

-- #############################################################################
-- PrgStatus -- using this for Exit code
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgStatusID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgStatusID
(
	PrgStatusCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgStatusID ADD CONSTRAINT
PK_MAP_PrgStatusID PRIMARY KEY CLUSTERED
(
	PrgStatusCode
)
END
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgStatus') AND OBJECTPROPERTY(id, N'IsView') = 1) 
DROP VIEW LEGACYSPED.Transform_PrgStatus
GO 

CREATE VIEW LEGACYSPED.Transform_PrgStatus 
AS 
 SELECT 
  PrgStatusCode = isnull(k.LegacySpedCode, convert(varchar(150), k.EnrichLabel)), -- Validation tool now ensures the existance of Code.  new values (prefs) use first 150 chars of Label as code.
  DestID = coalesce(s.ID, t.ID, m.DestID), -- may not need to coalesce below this line.
  ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 
  Sequence = coalesce(s.Sequence, t.Sequence, 99), 
  Name = convert(varchar(50), coalesce(s.Name, t.Name, k.EnrichLabel)), 
  IsExit = cast(1 as bit), 
  IsEntry = cast(0 as bit), 
  StatusStyleID = coalesce(s.StatusStyleID, t.StatusStyleID, 'FA528C27-E567-4CC9-A328-FF499BB803F6'), -- all the other PrgStatus rows for IEP and IsExit use this ID
  StateCode = coalesce(s.StateCode, t.StateCode, k.StateCode), 
  Description = coalesce(s.Description, t.Description, k.EnrichLabel), 
		-- this element is part of the config import
		DeletedDate = CASE 
			WHEN s.ID IS NOT NULL THEN s.DeletedDate 
			WHEN t.ID IS NOT NULL THEN t.DeletedDate 
				--ELSE 
					--CASE WHEN k.DisplayInUI = 'Y' THEN NULL -- User specified they want to see this in the UI.  Let them.
					ELSE GETDATE()
					--END
			END 
 FROM 
  LEGACYSPED.SelectLists k LEFT JOIN
  dbo.PrgStatus s on k.StateCode = s.StateCode left join
  LEGACYSPED.MAP_PrgStatusID m on isnull(k.LegacySpedCode, convert(varchar(150), k.EnrichLabel)) = m.PrgStatusCode left join
  dbo.PrgStatus t on m.DestID = t.ID
 WHERE
  k.Type = 'Exit' 
GO 


/*


This is a test comment to see how GitHub (Git Gui) behaves, since there is currently an error related to an unimportant file when I try to fetch remote and merge.



select * from PrgStatus where ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and IsExit = 1  order by sequence




GEO.ShowLoadTables PrgStatus

set nocount on;
declare @n varchar(100) ; select @n = 'PrgStatus'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	HasMapTable = 1, 
	MapTable = 'LEGACYSPED.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'PrgStatusCode'
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = 's.DestID in (select DestID from LEGACYSPED.MAP_PrgStatusID)'
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n

select d.*
-- UPDATE PrgStatus SET Name=s.Name, ProgramID=s.ProgramID, Description=s.Description, Sequence=s.Sequence, IsExit=s.IsExit, IsEntry=s.IsEntry, StateCode=s.StateCode, DeletedDate=s.DeletedDate, StatusStyleID=s.StatusStyleID
FROM  PrgStatus d JOIN 
	LEGACYSPED.Transform_PrgStatus  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from LEGACYSPED.MAP_PrgStatusID)

-- INSERT LEGACYSPED.MAP_PrgStatusID
SELECT PrgStatusCode, NEWID()
FROM LEGACYSPED.Transform_PrgStatus s
WHERE NOT EXISTS (SELECT * FROM PrgStatus d WHERE s.DestID=d.ID)

-- INSERT PrgStatus (ID, Name, ProgramID, Description, Sequence, IsExit, IsEntry, StateCode, DeletedDate, StatusStyleID)
SELECT s.DestID, s.Name, s.ProgramID, s.Description, s.Sequence, s.IsExit, s.IsEntry, s.StateCode, s.DeletedDate, s.StatusStyleID
FROM LEGACYSPED.Transform_PrgStatus s
WHERE NOT EXISTS (SELECT * FROM PrgStatus d WHERE s.DestID=d.ID)

select * from PrgStatus where ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and IsExit = 1 order by Sequence



*/

