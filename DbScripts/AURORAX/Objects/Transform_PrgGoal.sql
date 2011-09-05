--#include Transform_PrgGoals.sql
-- #############################################################################
-- Goal
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_PrgGoalID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_PrgGoalID
	(
	GoalRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)

ALTER TABLE AURORAX.MAP_PrgGoalID ADD CONSTRAINT
	PK_MAP_PrgGoalID PRIMARY KEY CLUSTERED
	(
	GoalRefID
	)
CREATE INDEX IX_AURORAX_MAP_PrgGoalID_DestID on AURORAX.MAP_PrgGoalID (DestID)
END
GO




-- #############################################################################
--		Transform


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_PrgGoal') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_PrgGoal
GO

CREATE VIEW AURORAX.Transform_PrgGoal
AS
 SELECT 
-- Source
  g.IepRefID,
  g.GoalRefID,
-- PrgGoal -- select * from PrgGoal
  DestID = m.DestID,
  TypeID = cast('AB74929E-B03F-4A51-82CA-659CA90E291A'  as uniqueidentifier), -- IEP goal as opposed to an Objective (both stored in same table)
  InstanceID = i.DestID,
  Sequence = (
	SELECT count(*)
	FROM AURORAX.Goal
	WHERE IepRefID = g.IepRefID AND
	Sequence < g.Sequence
	),												-- source
  IsProbeGoal = cast(0 as bit),
  TargetDate = cast(NULL as datetime),
  GoalStatement = cast(g.GoalStatement as text),	-- source
  ProbeTypeID = cast(NULL as uniqueidentifier),
  NumericTarget = cast(0 as float),
  RubricTargetID = cast(NULL as uniqueidentifier),
  RatioPartTarget = cast(0 as float),
  RatioOutOfTarget = cast(0 as float),
  BaselineScoreID = cast(NULL as uniqueidentifier),
  IndDefID = cast(NULL as uniqueidentifier),
  IndTarget = cast(0 as float),
  ProbeScheduleID = cast(NULL as uniqueidentifier), 
  ParentID = CAST(NULL as uniqueidentifier),
  FormInstanceID = CAST(NULL as uniqueidentifier),
-- IepGoal
  EsyID = case when g.IsEsy = 'Y' then 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' else 'F7E20A86-2709-4170-9810-15B601C61B79' end -- source.    Consider getting PrgGoal.ID from PrgGoal table
 FROM
  AURORAX.Goal g LEFT JOIN -- 34737
  AURORAX.MAP_PrgGoalID m on g.GoalRefID = m.GoalRefID LEFT JOIN -- 34737
  AURORAX.Transform_PrgGoals i on g.IepRefID = i.IepRefID LEFT JOIN -- getting a null instance id for students that have been deleted, but goal records are imported.  bad data, but handle it here anyway.
--   AURORAX.MAP_PostSchoolGoalAreaDefID ps on g.PostSchoolAreaCode = ps.PostSchoolAreaID LEFT JOIN
  dbo.PrgGoal pg on m.DestID = pg.ID 
 WHERE
  i.DestID is not null 
  and g.GACommunication+g.GAEmotional+g.GAHealth+g.GAIndependent+g.GAMath+g.GAOther+g.GAReading+g.GAWriting like '%Y%'
GO

/*

GEO.ShowLoadTables PrgGoal


set nocount on;
declare @n varchar(100) ; select @n = 'PrgGoal'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n And SourceTable = 'AURORAX.Transform_PrgGoal'
-- select * from vc3etl.loadtable where id = @t
update t set Enabled = 1
	, HasMapTable = 1
	, MapTable = 'AURORAX.MAP_PrgGoalID'
	, KeyField = 'GoalRefID'
	, DeleteKey = 'DestID'
	, DeleteTrans = 1
	, UpdateTrans = 1
	, DestTableFilter = NULL
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n



select d.*
-- DELETE AURORAX.MAP_PrgGoalID
FROM AURORAX.Transform_PrgGoal AS s RIGHT OUTER JOIN 
	AURORAX.MAP_PrgGoalID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)


select d.*
-- UPDATE PrgGoal SET Sequence=s.Sequence, IndDefID=s.IndDefID, ProbeTypeID=s.ProbeTypeID, ProbeScheduleID=s.ProbeScheduleID, IsProbeGoal=s.IsProbeGoal, TargetDate=s.TargetDate, IndTarget=s.IndTarget, RubricTargetID=s.RubricTargetID, BaselineScoreID=s.BaselineScoreID, InstanceID=s.InstanceID, NumericTarget=s.NumericTarget, RatioPartTarget=s.RatioPartTarget, GoalStatement=s.GoalStatement, TypeID=s.TypeID, RatioOutOfTarget=s.RatioOutOfTarget
FROM  PrgGoal d JOIN 
	AURORAX.Transform_PrgGoal  s ON s.DestID=d.ID

-- INSERT AURORAX.MAP_PrgGoalID
SELECT GoalRefID, NEWID()
FROM AURORAX.Transform_PrgGoal s
WHERE NOT EXISTS (SELECT * FROM PrgGoal d WHERE s.DestID=d.ID)

-- INSERT PrgGoal (ID, Sequence, IndDefID, ProbeTypeID, ProbeScheduleID, IsProbeGoal, TargetDate, IndTarget, RubricTargetID, BaselineScoreID, InstanceID, NumericTarget, RatioPartTarget, GoalStatement, TypeID, RatioOutOfTarget)
SELECT s.DestID, s.Sequence, s.IndDefID, s.ProbeTypeID, s.ProbeScheduleID, s.IsProbeGoal, s.TargetDate, s.IndTarget, s.RubricTargetID, s.BaselineScoreID, s.InstanceID, s.NumericTarget, s.RatioPartTarget, s.GoalStatement, s.TypeID, s.RatioOutOfTarget
FROM AURORAX.Transform_PrgGoal s
WHERE NOT EXISTS (SELECT * FROM PrgGoal d WHERE s.DestID=d.ID)

select * from PrgGoal

*/

