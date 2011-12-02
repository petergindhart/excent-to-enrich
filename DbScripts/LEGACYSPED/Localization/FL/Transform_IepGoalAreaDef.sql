
-- This transform is not currently in LoadTable.  We are populating MAP_GoalAreaDefID in the state specific ETL Prep file.


---- #############################################################################
----		Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepGoalAreaDefID 
(
	GoalAreaCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepGoalAreaDefID ADD CONSTRAINT
PK_MAP_IepGoalAreaDefID PRIMARY KEY CLUSTERED
(
	GoalAreaCode
)

---- this exist elsewhere 
----set nocount on;
----declare @mgad table (Name varchar(20), DestID uniqueidentifier)
----insert @mgad values ('GACommunication', '51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7')
----insert @mgad values ('GAMath', '0E95D360-5CBE-4ECA-820F-CC25864D70D8')
----insert @mgad values ('GAReading', '504CE0ED-537F-4EA0-BD97-0349FB1A4CA8')
----insert @mgad values ('GAWriting', '37EA0554-EC3F-4B95-AAD7-A52DECC7377C')
----set nocount off;
----insert LEGACYSPED.MAP_GoalAreaDefID -- select * from LEGACYSPED.MAP_GoalAreaDefID 
----select * from @mgad where DestID not in (select DestID from LEGACYSPED.MAP_GoalAreaDefID) -- select * from IepGoalAreaDef where Sequence <> 99

END
GO

-- #############################################################################
---- Transform
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoalAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepGoalAreaDef
GO

CREATE VIEW LEGACYSPED.Transform_IepGoalAreaDef  --- select * from IepGoalAreaDef order by sequence, deleteddate  -- select * from LEGACYSPED.Transform_IepGoalAreaDef -- delete IepGoalAreaDef where deleteddate is not null
AS
/*
	This view should work for both CO and FL, though FL's map table is populated in the Prep_State file
	
	Note:  Test FL Map table setup.  mapping table should be pre-populated, so this query should not affect mapping table for FL.

*/
SELECT
	GoalAreaCode = k.Code,
	DestID = coalesce(n.ID, t.ID,  m.DestID),
	Sequence = coalesce(n.Sequence, t.Sequence, 99),
	Name = coalesce(n.Name, t.Name, cast(k.Label as varchar(50))),
	AllowCustomProbes = 0,
	StateCode = cast(NULL as varchar(20)),
	DeletedDate = coalesce(n.DeletedDate, t.DeletedDate, GETDATE())
  FROM
	LEGACYSPED.Lookups k LEFT JOIN
	dbo.IepGoalAreaDef n on k.Label = n.Name left join
	LEGACYSPED.MAP_IepGoalAreaDefID m on k.Code = m.GoalAreaCode LEFT JOIN 
	dbo.IepGoalAreaDef t on m.DestID = t.ID 
WHERE k.Type = 'GoalArea'
GO

--- select * from IepGoalAreaDef 

