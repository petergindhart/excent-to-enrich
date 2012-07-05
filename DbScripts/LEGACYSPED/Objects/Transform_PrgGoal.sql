-- #############################################################################
-- Goal
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgGoalID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN -- drop TABLE LEGACYSPED.MAP_PrgGoalID
CREATE TABLE LEGACYSPED.MAP_PrgGoalID
	(
	GoalRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL,
	CrossVersionGoalID uniqueidentifier NOT NULL
	)

ALTER TABLE LEGACYSPED.MAP_PrgGoalID ADD CONSTRAINT
	PK_MAP_PrgGoalID PRIMARY KEY CLUSTERED
	(
	GoalRefID
	)
CREATE INDEX IX_LEGACYSPED_MAP_PrgGoalID_DestID on LEGACYSPED.MAP_PrgGoalID (DestID)
END

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_Goal_LOCAL_IEPRefID')
CREATE NONCLUSTERED INDEX  IX_LEGACYSPED_Goal_LOCAL_IEPRefID ON [LEGACYSPED].[Goal_LOCAL] ([IepRefID]) INCLUDE ([GoalRefID])

-- belongs in a different file
if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_IepGoalArea_DefID_InstanceID')
CREATE NONCLUSTERED INDEX IX_LEGACYSPED_IepGoalArea_DefID_InstanceID ON [dbo].[IepGoalArea] ([DefID],[InstanceID])

GO


-- #############################################################################
--		Transform


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgGoal') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgGoal
GO

CREATE VIEW LEGACYSPED.Transform_PrgGoal
AS
 SELECT 
-- Source
  g.IepRefID,
  g.GoalRefID,
-- PrgGoal 
  DestID = m.DestID,
  TypeID = cast('AB74929E-B03F-4A51-82CA-659CA90E291A'  as uniqueidentifier), -- IEP goal as opposed to an Objective (both stored in same table)
  InstanceID = i.DestID,
  Sequence = (
	SELECT count(*)
	FROM LEGACYSPED.Goal
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
  EsyID = case when g.IsEsy = 'Y' then 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' else 'F7E20A86-2709-4170-9810-15B601C61B79' end, -- source.    Consider getting PrgGoal.ID from PrgGoal table
  i.DoNotTouch,
  CrossVersionGoalID = m.CrossVersionGoalID
 FROM
  LEGACYSPED.Goal g JOIN
  LEGACYSPED.GoalAreaExists e on g.GoalRefID = e.GoalRefID LEFT JOIN 
  LEGACYSPED.MAP_PrgGoalID m on g.GoalRefID = m.GoalRefID LEFT JOIN 
  LEGACYSPED.Transform_PrgGoals i on g.IepRefID = i.IepRefID LEFT JOIN -- getting a null instance id for students that have been deleted, but goal records are imported.  bad data, but handle it here anyway.
--   LEGACYSPED.MAP_PostSchoolGoalAreaDefID ps on g.PostSchoolAreaCode = ps.PostSchoolAreaID LEFT JOIN
  dbo.PrgGoal pg on m.DestID = pg.ID 
 WHERE
  i.DestID is not null 
--AND
--  i.DoNotTouch = 0
  -- and isnull(g.GACommunication,'')+isnull(g.GAEmotional,'')+isnull(g.GAHealth,'')+isnull(g.GAIndependent,'')+isnull(g.GAMath,'')+isnull(g.GAOther,'')+isnull(g.GAReading,'')+isnull(g.GAWriting,'') like '%Y%'
GO
