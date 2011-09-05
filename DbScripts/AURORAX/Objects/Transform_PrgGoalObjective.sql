-- #############################################################################
-- Objective
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_PrgGoalObjectiveID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_PrgGoalObjectiveID
	(
	ObjectiveRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)

ALTER TABLE AURORAX.MAP_PrgGoalObjectiveID ADD CONSTRAINT
	PK_MAP_PrgGoalObjectiveID PRIMARY KEY CLUSTERED
	(
	ObjectiveRefID
	)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_PrgGoalObjective') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_PrgGoalObjective
GO

CREATE VIEW AURORAX.Transform_PrgGoalObjective
AS
 SELECT
  o.ObjectiveRefID,
  DestID = m.DestID,
  TypeID = cast('4440EBD6-2AAD-4B78-9018-F52EC89A8D49'  as uniqueidentifier),
  InstanceID = g.InstanceID,
  Sequence = (
	SELECT count(*)
	FROM AURORAX.Objective
	WHERE GoalRefID = g.GoalRefID AND
	Sequence < o.Sequence
	),
  IsProbeGoal = cast(0 as bit),
  TargetDate = g.TargetDate,
  GoalStatement = cast(o.ObjText as text),
  ParentID = g.DestID
 FROM
  AURORAX.Transform_PrgGoal g JOIN
  AURORAX.Objective o on g.GoalRefID = o.GoalRefID LEFT JOIN
  AURORAX.MAP_PrgGoalObjectiveID m on o.ObjectiveRefID = m.ObjectiveRefID LEFT JOIN
  dbo.PrgGoal obj on m.DestID = obj.ID
GO
---
/*

select * from AURORAX.Objective


GEO.ShowLoadTables PrgGoal

select * from PrgGoal where ID = '2F498F3E-3013-4BE6-B8C4-7C968E624A27'


select * from vc3etl.loadcolumn where loadtable = '1D683708-D043-4CE3-8427-E5E9AD0D6256'

insert vc3etl.loadcolumn values (newid(), '1D683708-D043-4CE3-8427-E5E9AD0D6256', 'GoalStatement', 'GoalStatement', 'C', 0, NULL, NULL)





set nocount on;
declare @n varchar(100) ; select @n = 'PrgGoal'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n and SourceTable = 'AURORAX.Transform_PrgGoalObjective'
update t set Enabled = 1
	, HasMapTable = 1
	, MapTable = 'AURORAX.MAP_PrgGoalObjectiveID'
	, KeyField = 'ObjectiveRefID'
	, DeleteKey = 'DestID'
	, DeleteTrans = 1
	, UpdateTrans = 1
	, DestTableFilter = 'd.ParentID in (SELECT DestID from AURORAX.Transform_PrgGoal)'
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.*
-- DELETE AURORAX.MAP_PrgGoalObjectiveID
FROM AURORAX.Transform_PrgGoalObjective AS s RIGHT OUTER JOIN 
	AURORAX.MAP_PrgGoalObjectiveID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

select d.*
-- UPDATE PrgGoal SET TypeID=s.TypeID, ParentID=s.ParentID, GoalStatement=s.GoalStatement, IsProbeGoal=s.IsProbeGoal, Sequence=s.Sequence, TargetDate=s.TargetDate, InstanceID=s.InstanceID
FROM  PrgGoal d JOIN 
	AURORAX.Transform_PrgGoalObjective  s ON s.DestID=d.ID
	AND d.ParentID in (SELECT DestID from AURORAX.Transform_PrgGoal)

-- INSERT AURORAX.MAP_PrgGoalObjectiveID
SELECT ObjectiveRefID, NEWID()
FROM AURORAX.Transform_PrgGoalObjective s
WHERE NOT EXISTS (SELECT * FROM PrgGoal d WHERE s.DestID=d.ID)

-- INSERT PrgGoal (ID, TypeID, ParentID, GoalStatement, IsProbeGoal, Sequence, TargetDate, InstanceID)
SELECT s.DestID, s.TypeID, s.ParentID, s.GoalStatement, s.IsProbeGoal, s.Sequence, s.TargetDate, s.InstanceID
FROM AURORAX.Transform_PrgGoalObjective s
WHERE NOT EXISTS (SELECT * FROM PrgGoal d WHERE s.DestID=d.ID)

select * from PrgGoal where parentid is not null





select * from PrgGoal where parentid is not null





*/


