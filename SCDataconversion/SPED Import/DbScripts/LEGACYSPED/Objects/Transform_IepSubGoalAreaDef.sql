
-- IepGoalAreaDef is currently populated in the state-specific localization file.  
-- IepSubGoalAreaDef may need to be in the district-specific localization file for now...

---- #############################################################################
----		Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepSubGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepSubGoalAreaDefID 
(
	SubGoalAreaCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL,
	ParentID uniqueidentifier not null
)

ALTER TABLE LEGACYSPED.MAP_IepSubGoalAreaDefID ADD CONSTRAINT
PK_MAP_IepSubGoalAreaDefID PRIMARY KEY CLUSTERED
(
	SubGoalAreaCode
)

END
GO

-- #############################################################################
---- Transform
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepSubGoalAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepSubGoalAreaDef
GO

create view LEGACYSPED.Transform_IepSubGoalAreaDef
as
select 
	SubGoalAreaCode = ks.LegacySpedCode,
	DestID = coalesce(i.ID, n.ID, t.ID, m.DestID),
	ParentID = kp.EnrichID,
	Sequence = coalesce(i.sequence, n.sequence, t.sequence, 
	case ks.LegacySpedCode ----------- this will have to do for now.  we may need to set all to 99 or something (for re-use with other districts/states).
		when 'GAReading' then 0
		when 'GAWriting' then 1
		when 'GAMath' then 2
		when 'GAOther' then 3
	end),
	Name = coalesce(i.name, n.name, t.name, ks.EnrichLabel), 
	StateCode = cast(NULL as varchar(10)),
	DeletedDate = cast(NULL as datetime)
from LEGACYSPED.SelectLists kp cross join
LEGACYSPED.SelectLists ks left join 
dbo.IepSubGoalAreaDef i on ks.EnrichID = i.ID left join
dbo.IepSubGoalAreaDef n on ks.EnrichLabel = n.Name left join 
LEGACYSPED.MAP_IepSubGoalAreaDefID m on ks.LegacySpedCode = m.SubGoalAreaCode left join 
dbo.IepSubGoalAreaDef t on m.DestID = t.ID
where ks.Type = 'GoalArea' and ks.SubType = 'sub'
and kp.Type = 'GoalArea' and kp.SubType = 'parent'
go




