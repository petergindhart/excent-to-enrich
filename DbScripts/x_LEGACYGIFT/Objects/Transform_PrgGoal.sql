-- ############################################################################# ------- duplicated in Transform_IepGoalArea.sql
--		EP Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_IepGoalAreaID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_IepGoalAreaID
(
	EPRefID	varchar(150) not null,
	DefID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE x_LEGACYGIFT.MAP_IepGoalAreaID ADD CONSTRAINT 
PK_MAP_IepGoalAreaID PRIMARY KEY CLUSTERED
(
	DefID, EPRefID
)
END
GO

-- #############################################################################
-- create a placeholder object since this view does not exist yet.  cannot create view within begin/end, so create a table instead
-- IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.GiftedGoalAreaPivotView'))
-- begin
-- create table x_LEGACYGIFT.GiftedGoalAreaPivotView (
-- EPRefID varchar(150),
-- GoalRefID varchar(150),
-- GoalAreaCode varchar(20),
-- GoalAreaDefIndex int
-- )
-- end
-- this object will be dropped when we create the view later
-- go

------------------------------------------------------------------------------------------- end code duplicated from Transform_IepGoalArea.sql

-- #############################################################################
-- Goal
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_PrgGoalID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN 
CREATE TABLE x_LEGACYGIFT.MAP_PrgGoalID
	(
	GoalRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL,
	CrossVersionGoalID uniqueidentifier NOT NULL
	)

ALTER TABLE x_LEGACYGIFT.MAP_PrgGoalID ADD CONSTRAINT
	PK_MAP_PrgGoalID PRIMARY KEY CLUSTERED
	(
	GoalRefID
	)
CREATE INDEX IX_x_LEGACYGIFT_MAP_PrgGoalID_DestID on x_LEGACYGIFT.MAP_PrgGoalID (DestID)
END

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_GiftedGoal_LOCAL_EPRefID')
CREATE NONCLUSTERED INDEX  IX_x_LEGACYGIFT_GiftedGoal_LOCAL_EPRefID ON [x_LEGACYGIFT].[GiftedGoal_LOCAL] ([EPRefID]) INCLUDE ([GoalRefID])

-- belongs in a different file
if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_IepGoalArea_DefID_InstanceID')
CREATE NONCLUSTERED INDEX IX_x_LEGACYGIFT_IepGoalArea_DefID_InstanceID ON [dbo].[IepGoalArea] ([DefID],[InstanceID])

GO


-- #############################################################################
--		Transform
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_PrgGoal') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_PrgGoal
GO

CREATE VIEW x_LEGACYGIFT.Transform_PrgGoal
AS
 SELECT 
-- Source
  g.EPRefID,
  g.GoalRefID,
-- PrgGoal 
  DestID = m.DestID,
  TypeID = cast('AB74929E-B03F-4A51-82CA-659CA90E291A'  as uniqueidentifier), 
  InstanceID = i.DestID,
  Sequence = (select count(*) from x_LEGACYGIFT.GoalAreaPivotView gpvt where gpvt.EPRefID = ga1.EPRefID and gpvt.GoalAreaCode = ga1.GoalAreaCode and gpvt.GoalRefID < g.GoalRefID),												-- source
  IsProbeGoal = cast(0 as bit),
  TargetDate = stu.DurationDate, 
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
  StartDate = stu.EPMeetingDate,
-- IepGoal
  EsyID = case when g.IsEsy = 'Y' then 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' else 'F7E20A86-2709-4170-9810-15B601C61B79' end,
  CrossVersionGoalID = isnull(m.CrossVersionGoalID, NEWID())
 FROM
  x_LEGACYGIFT.GiftedStudent stu join 
  x_LEGACYGIFT.GiftedGoal g on stu.EPRefID = g.EPRefID JOIN
  x_LEGACYGIFT.GoalAreaExists e on g.GoalRefID = e.GoalRefID left join
  x_LEGACYGIFT.Transform_IepGoalArea_goals ga on g.GoalRefID = ga.GoalRefID left join ----------------- May be able to use MAP table for speed
	(
	select g.EPRefID, ga.DefID, gad.GoalAreaCode 
	from x_LEGACYGIFT.GiftedGoal g join
	x_LEGACYGIFT.Transform_IepGoalArea_goals ga on g.GoalRefID = ga.GoalRefID join ----------------- May be able to use MAP table for speed
	LEGACYSPED.MAP_IepGoalAreaDefID gad on ga.DefID = gad.DestID
	group by g.EPRefID, ga.DefID, gad.GoalAreaCode
	) ga1 on g.EPRefID = ga1.EPRefID and ga.DefID = ga1.DefID LEFT JOIN 
  x_LEGACYGIFT.MAP_PrgGoalID m on g.GoalRefID = m.GoalRefID LEFT JOIN 
  x_LEGACYGIFT.Transform_PrgGoals i on g.EPRefID = i.EPRefID LEFT JOIN -- getting a null instance id for students that have been deleted, but goal records are imported.  bad data, but handle it here anyway.
  dbo.PrgGoal pg on m.DestID = pg.ID 
 WHERE
  i.DestID is not null 
GO
