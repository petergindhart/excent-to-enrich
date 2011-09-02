
-- This transform is not currently in LoadTable.  We are populating MAP_GoalAreaDefID in the state specific ETL Prep file.


---- #############################################################################
----		Goal Area MAP
--IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_GoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
--BEGIN
--CREATE TABLE AURORAX.MAP_GoalAreaDefID
--(
--	GoalAreaCode	varchar(150) NOT NULL,
--	DestID uniqueidentifier NOT NULL
--)

--ALTER TABLE AURORAX.MAP_GoalAreaDefID ADD CONSTRAINT
--PK_MAP_GoalAreaDefID PRIMARY KEY CLUSTERED
--(
--	GoalAreaCode
--)

---- this exist elsewhere 
----set nocount on;
----declare @mgad table (Name varchar(20), DestID uniqueidentifier)
----insert @mgad values ('GACommunication', '51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7')
----insert @mgad values ('GAMath', '0E95D360-5CBE-4ECA-820F-CC25864D70D8')
----insert @mgad values ('GAReading', '504CE0ED-537F-4EA0-BD97-0349FB1A4CA8')
----insert @mgad values ('GAWriting', '37EA0554-EC3F-4B95-AAD7-A52DECC7377C')
----set nocount off;
----insert AURORAX.MAP_GoalAreaDefID -- select * from AURORAX.MAP_GoalAreaDefID 
----select * from @mgad where DestID not in (select DestID from AURORAX.MAP_GoalAreaDefID) -- select * from IepGoalAreaDef where Sequence <> 99

--END
--GO

---- #############################################################################
---- Transform
--IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_IepGoalAreaDef]') AND OBJECTPROPERTY(id, N'IsView') = 1)
--DROP VIEW [AURORAX].Transform_IepGoalAreaDef
--GO

--CREATE VIEW AURORAX.Transform_IepGoalAreaDef  --- select * from IepGoalAreaDef order by sequence, deleteddate  -- select * from AURORAX.Transform_IepGoalAreaDef -- delete IepGoalAreaDef where deleteddate is not null
--AS
--SELECT
--	GoalAreaCode = k.Code,
--	m.DestID,
--	Sequence = 99,
--	Name = k.Label,
--	AllowCustomProbes = 0,
--	StateCode = cast(NULL as varchar(20)),
--	DeletedDate = GETDATE(),
--		d.ID
--FROM
--	AURORAX.Lookups k LEFT JOIN -- select * from AURORAX.Lookups k where k.Type = 'GoalArea' -- 8
--	AURORAX.MAP_GoalAreaDefID m on k.Code = m.GoalAreaCode LEFT JOIN -- select * from AURORAX.MAP_GoalAreaDefID -- 8 
--	dbo.IepGoalAreaDef d on m.DestID = d.ID -- and d.DeletedDate is null -- select * from IepGoalAreaDef -- 12  --  select * from AURORAX.Lookups k join IepGoalAreaDef ga on left(k.label, 4) = left(ga.name, 4) where k.Type = 'GoalArea' 
--WHERE k.Type = 'GoalArea'

--GO
--- select * from IepGoalAreaDef 

