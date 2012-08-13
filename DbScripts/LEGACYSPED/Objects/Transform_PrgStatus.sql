
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
  PrgStatusCode = isnull(k.LegacySpedCode, left(k.EnrichLabel, 150)), 
  DestID = coalesce(i.ID, n.ID, t.ID, m.DestID),
  ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 
  Sequence = coalesce(i.Sequence, n.Sequence, t.Sequence, 99), 
  Name = coalesce(i.Name, n.Name, t.Name, left(k.EnrichLabel, 50)), 
  IsExit = cast(1 as bit), 
  IsEntry = cast(0 as bit), 
  StatusStyleID = coalesce(i.StatusStyleID, n.StatusStyleID, t.StatusStyleID, 'FA528C27-E567-4CC9-A328-FF499BB803F6'), 
  StateCode = coalesce(i.StateCode, n.StateCode, t.StateCode), 
  Description = coalesce(i.Description, n.Description, t.Description), 
  DeletedDate = case when k.EnrichID is not null then NULL when coalesce(i.ID, n.ID, t.ID) is null then NULL else coalesce(i.DeletedDate, n.DeletedDate, t.DeletedDate) end
 FROM 
  LEGACYSPED.SelectLists k LEFT JOIN
  dbo.PrgStatus i on k.EnrichID = i.ID left join
  dbo.PrgStatus n on k.EnrichLabel = i.Name left join
  LEGACYSPED.MAP_PrgStatusID m on isnull(k.LegacySpedCode, convert(varchar(150), k.EnrichLabel)) = m.PrgStatusCode left join
  dbo.PrgStatus t on m.DestID = t.ID
 WHERE
  k.Type = 'Exit' 
GO 
-- last line
