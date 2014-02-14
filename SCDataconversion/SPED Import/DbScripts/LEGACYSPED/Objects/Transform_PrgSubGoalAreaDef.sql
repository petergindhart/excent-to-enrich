-- PrgGoalareaDef is currently populated in the state-specific localization file.  
-- IepSubGoalAreaDef may need to be in the district-specific localization file for now...

---- #############################################################################
----		Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgSubGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgSubGoalAreaDefID 
(
	SubGoalAreaCode	varchar(150) NOT NULL,
	Sequence int NOT NULL,
	ParentID uniqueidentifier not null,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgSubGoalAreaDefID ADD CONSTRAINT
PK_MAP_PrgSubGoalAreaDefID PRIMARY KEY CLUSTERED
(
	SubGoalAreaCode,Sequence
)

END
GO

-- #############################################################################
---- Transform
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgSubGoalAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgSubGoalAreaDef
GO

create view LEGACYSPED.Transform_PrgSubGoalAreaDef
as

select
	SubGoalAreaCode = tpg.GoalAreaCode,
	DestID = m.DestID,
	ParentID = tpg.DestID,
	Sequence = msubga.Sequence,
	Name = msubga.SubGoalAreaName,
	StateCode = cast(NULL as varchar(10)),
	DeletedDate = GETDATE()
--select tpg.*,t.*
from Legacysped.Transform_PrgGoalAreaDef tpg  --16
cross join LEGACYSPED.Map_SubGoalArea msubga
left join LEGACYSPED.MAP_PrgSubGoalAreaDefID m on m.SubGoalAreaCode = tpg.GoalAreaCode and m.ParentID = tpg.DestID and m.Sequence = msubga.Sequence
left join PrgSubGoalAreaDef subgadef on msubga.SubGoalAreaName = subgadef.Name and subgadef.ParentID = tpg.DestID
where subgadef.ID is null and tpg.sequence = 99
go

--DROP TABLE LEGACYSPED.MAP_PrgSubGoalAreaDefID 