-- #############################################################################
-- Objective
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgGoalObjectiveID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgGoalObjectiveID
	(
	ObjectiveRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)

ALTER TABLE LEGACYSPED.MAP_PrgGoalObjectiveID ADD CONSTRAINT
	PK_MAP_PrgGoalObjectiveID PRIMARY KEY CLUSTERED
	(
	ObjectiveRefID
	)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgGoalObjective') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgGoalObjective
GO

CREATE VIEW LEGACYSPED.Transform_PrgGoalObjective
AS
 SELECT
  o.ObjectiveRefID,
  DestID = m.DestID,
  TypeID = cast('4440EBD6-2AAD-4B78-9018-F52EC89A8D49'  as uniqueidentifier),
  InstanceID = g.InstanceID,
  Sequence = (
	SELECT count(*)
	FROM LEGACYSPED.Objective
	WHERE GoalRefID = g.GoalRefID AND
	Sequence < o.Sequence
	),
  IsProbeGoal = cast(0 as bit),
  TargetDate = g.TargetDate,
  GoalStatement = cast(o.ObjText as text),
  ParentID = g.DestID
 FROM
  LEGACYSPED.Transform_PrgGoal g JOIN
  LEGACYSPED.Objective o on g.GoalRefID = o.GoalRefID LEFT JOIN
  LEGACYSPED.MAP_PrgGoalObjectiveID m on o.ObjectiveRefID = m.ObjectiveRefID LEFT JOIN
  dbo.PrgGoal obj on m.DestID = obj.ID
GO
---
/*

select * from LEGACYSPED.Objective


GEO.ShowLoadTables PrgGoal

select * from PrgGoal where ID = '2F498F3E-3013-4BE6-B8C4-7C968E624A27'


select * from vc3etl.loadcolumn where loadtable = '1D683708-D043-4CE3-8427-E5E9AD0D6256'

insert vc3etl.loadcolumn values (newid(), '1D683708-D043-4CE3-8427-E5E9AD0D6256', 'GoalStatement', 'GoalStatement', 'C', 0, NULL, NULL)





set nocount on;
declare @n varchar(100) ; select @n = 'PrgGoal'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n and SourceTable = 'LEGACYSPED.Transform_PrgGoalObjective'
update t set Enabled = 1
	, HasMapTable = 1
	, MapTable = 'LEGACYSPED.MAP_PrgGoalObjectiveID'
	, KeyField = 'ObjectiveRefID'
	, DeleteKey = 'DestID'
	, DeleteTrans = 1
	, UpdateTrans = 1
	, DestTableFilter = 'd.ParentID in (SELECT DestID from LEGACYSPED.Transform_PrgGoal)'
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.*
-- DELETE LEGACYSPED.MAP_PrgGoalObjectiveID
FROM LEGACYSPED.Transform_PrgGoalObjective AS s RIGHT OUTER JOIN 
	LEGACYSPED.MAP_PrgGoalObjectiveID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

select d.*
-- UPDATE PrgGoal SET TypeID=s.TypeID, ParentID=s.ParentID, GoalStatement=s.GoalStatement, IsProbeGoal=s.IsProbeGoal, Sequence=s.Sequence, TargetDate=s.TargetDate, InstanceID=s.InstanceID
FROM  PrgGoal d JOIN 
	LEGACYSPED.Transform_PrgGoalObjective  s ON s.DestID=d.ID
	AND d.ParentID in (SELECT DestID from LEGACYSPED.Transform_PrgGoal)

-- INSERT LEGACYSPED.MAP_PrgGoalObjectiveID
SELECT ObjectiveRefID, NEWID()
FROM LEGACYSPED.Transform_PrgGoalObjective s
WHERE NOT EXISTS (SELECT * FROM PrgGoal d WHERE s.DestID=d.ID)

-- INSERT PrgGoal (ID, TypeID, ParentID, GoalStatement, IsProbeGoal, Sequence, TargetDate, InstanceID)
SELECT s.DestID, s.TypeID, s.ParentID, s.GoalStatement, s.IsProbeGoal, s.Sequence, s.TargetDate, s.InstanceID
FROM LEGACYSPED.Transform_PrgGoalObjective s
WHERE NOT EXISTS (SELECT * FROM PrgGoal d WHERE s.DestID=d.ID)

select * from PrgGoal where parentid is not null





select * from PrgGoal where parentid is not null





*/


