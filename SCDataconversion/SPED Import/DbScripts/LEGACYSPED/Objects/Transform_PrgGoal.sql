-- ############################################################################# ------- duplicated in Transform_IepGoalArea.sql
--		Iep Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepGoalAreaID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepGoalAreaID
(
	IEPRefID	varchar(150) not null,
	DefID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepGoalAreaID ADD CONSTRAINT 
PK_MAP_IepGoalAreaID PRIMARY KEY CLUSTERED
(
	DefID, IEPRefID
)
END
GO

-- #############################################################################
-- create a placeholder object since this view does not exist yet.  cannot create view within begin/end, so create a table instead
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.GoalAreaPivotView'))
begin
create table LEGACYSPED.GoalAreaPivotView (
IepRefID varchar(150),
GoalRefID varchar(150),
GoalAreaCode varchar(20),
GoalAreaDefIndex int
)
end
-- this object will be dropped when we create the view later
go

------------------------------------------------------------------------------------------- end code duplicated from Transform_IepGoalArea.sql

-- #############################################################################
-- Goal
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgGoalID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
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
  Sequence = (select count(*) from LEGACYSPED.GoalAreaPivotView gpvt where gpvt.IepRefID = ga1.IepRefID and gpvt.GoalAreaCode = ga1.GoalAreaCode and gpvt.GoalRefID < g.GoalRefID),												-- source
  IsProbeGoal = cast(0 as bit),
  TargetDate = iep.IEPEndDate, 
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
  StartDate = iep.IEPStartDate,
-- IepGoal
  EsyID = case when g.IsEsy = 'Y' then 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' else 'F7E20A86-2709-4170-9810-15B601C61B79' end, -- source.    Consider getting PrgGoal.ID from PrgGoal table
  i.DoNotTouch,
  CrossVersionGoalID = isnull(m.CrossVersionGoalID, NEWID())
 FROM
  LEGACYSPED.IEP iep join 
  LEGACYSPED.Goal g on iep.IepRefID = g.IepRefID JOIN
  LEGACYSPED.GoalAreaExists e on g.GoalRefID = e.GoalRefID left join
  LEGACYSPED.Transform_IepGoalArea_goals ga on g.GoalRefID = ga.GoalRefID left join ----------------- May be able to use MAP table for speed
	(
	select g.IepRefID, ga.DefID, gad.GoalAreaCode 
	from LEGACYSPED.Goal g join
	LEGACYSPED.Transform_IepGoalArea_goals ga on g.GoalRefID = ga.GoalRefID join ----------------- May be able to use MAP table for speed
	LEGACYSPED.MAP_IepGoalAreaDefID gad on ga.DefID = gad.DestID
	group by g.IepRefID, ga.DefID, gad.GoalAreaCode
	) ga1 on g.IepRefId = ga1.IepRefID and ga.DefID = ga1.DefID LEFT JOIN 
  LEGACYSPED.MAP_PrgGoalID m on g.GoalRefID = m.GoalRefID LEFT JOIN 
  LEGACYSPED.Transform_PrgGoals i on g.IepRefID = i.IepRefID LEFT JOIN -- getting a null instance id for students that have been deleted, but goal records are imported.  bad data, but handle it here anyway.
--   LEGACYSPED.MAP_PostSchoolGoalAreaDefID ps on g.PostSchoolAreaCode = ps.PostSchoolAreaID LEFT JOIN
  dbo.PrgGoal pg on m.DestID = pg.ID 
 WHERE
  i.DestID is not null 
GO
