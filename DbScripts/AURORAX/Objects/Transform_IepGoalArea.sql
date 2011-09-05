
-- AURORAX.MAP_GoalAreaDefID is created and inserted in AURORAX\Objects\0001a-ETLPrep_State_FL.sql
-- #############################################################################
--		Iep Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_IepGoalArea') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_IepGoalArea
(
	InstanceID	uniqueidentifier not null,
	GoalAreaDefID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE AURORAX.MAP_IepGoalArea ADD CONSTRAINT 
PK_MAP_IepGoalArea PRIMARY KEY CLUSTERED
(
	InstanceID, GoalAreaDefID
)
END
GO

-- #############################################################################

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.GoalAreaPivotView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.GoalAreaPivotView
GO

create view AURORAX.GoalAreaPivotView
as
	select IepRefID, GoalRefID, 'GAReading' GoalAreaCode, CAST(0 as int) GoalIndex
	from AURORAX.Goal
	where GAReading = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAWriting' GoalAreaCode, CAST(1 as int) GoalIndex
	from AURORAX.Goal
	where  GAWriting = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAMath' GoalAreaCode, CAST(2 as int) GoalIndex
	from AURORAX.Goal
	where  GAMath = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAOther' GoalAreaCode, CAST(3 as int) GoalIndex
	from AURORAX.Goal
	where  GAOther = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAEmotional' GoalAreaCode, CAST(4 as int) GoalIndex
	from AURORAX.Goal
	where  GAEmotional = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAIndependent' GoalAreaCode, CAST(5 as int) GoalIndex
	from AURORAX.Goal
	where  GAIndependent = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAHealth' GoalAreaCode, CAST(6 as int) GoalIndex
	from AURORAX.Goal
	where  GAHealth = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GACommunication' GoalAreaCode, CAST(7 as int) GoalIndex
	from AURORAX.Goal
	where  GACommunication = 'Y'
go

--create table AURORAX.GoalAreaPivotTable (
--IepRefID varchar(150) not null,
--GoalRefID varchar(150) not null,
--GoalAreaCode varchar(20) not null,
--GoalIndex int not null
--)

--alter table AURORAX.GoalAreaPivotTable 
--	add constraint PK_AURORAX_GoalAreaPivotTable primary key (IepRefID, GoalRefID, GoalAreaCode)
--go

--alter table AURORAX.GoalAreaPivotTable 
--	drop constraint PK_AURORAX_GoalAreaPivotTable 
--go


--insert AURORAX.GoalAreaPivotTable
--select * from AURORAX.GoalAreaPivotView

-- #############################################################################

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.GoalAreasPerGoalView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.GoalAreasPerGoalView
GO

create view AURORAX.GoalAreasPerGoalView 
as
/*

	Currently Enrich does not support more than 1 goal area per goal, so we need to arbitrarily but consistently pick one goal for now.
	In AURORAX.GoalAreaPivotView we devised an Index that will allow us to select the minimum GoalAreaIndex per Goal, which this view provides.
	The output of this view will be the one GoalArea selected for each Goal.
	This filter will no longer be necessary after support for multiple areas (domains) per goal is added to Enrich.

*/
	select
		ga.IepRefID,
		InstanceID = pgs.DestID,
		DefID = m.DestID,
		ga.GoalAreaCode,
		Ga.GoalRefID,
		ga.GoalIndex
	from AURORAX.GoalAreaPivotView ga JOIN
		AURORAX.Transform_PrgGoals pgs on ga.IepRefID = pgs.IepRefID join -- on left join some records do not have an instanceid  -- 4E367F51-09E0-41A6-9CA1-88F0230A05D1 
		AURORAX.MAP_GoalAreaDefID m on ga.GoalAreaCode = m.GoalAreaCode -- select * from AURORAX.MAP_GoalAreaDefID -- select * from IepGoalAreaDef order by deleteddate, sequence, Name -- select * from AURORAX.MAP_GoalAreaDefID
	where ga.GoalIndex = (				-- Enrich does not currently support multiple domains per Goal
		select top 1 minga.GoalIndex
		from  AURORAX.GoalAreaPivotView minga
		where ga.GoalRefID = minga.GoalRefID
		order by ga.GoalIndex)
go


-- #############################################################################


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_IepGoalArea') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_IepGoalArea
GO

create view AURORAX.Transform_IepGoalArea 
as
	select distinct
		gapg.IepRefID,
		gapg.GoalAreaCode,
		mga.DestID,
		gapg.InstanceID,
		gapg.DefID,
		FormInstanceID = CAST(NULL as uniqueidentifier)
	from 
		--select distinct -- if support is later added for multiple domains per goal this portion of the query may work
		--	ga.IepRefID,
		--	InstanceID = pgs.DestID,
		--	DefID = m.DestID,
		--	ga.GoalAreaCode
		--from AURORAX.GoalAreaPivotView ga JOIN 
		--AURORAX.Transform_PrgGoals pgs on ga.IepRefID = pgs.IepRefID join -- on left join some records do not have an instanceid  -- 4E367F51-09E0-41A6-9CA1-88F0230A05D1 
		--AURORAX.MAP_GoalAreaDefID m on ga.GoalAreaCode = m.GoalAreaCode
		AURORAX.GoalAreasPerGoalView gapg left join
		--) distga left join -- 32608
		AURORAX.MAP_IepGoalArea mga on gapg.InstanceID = mga.InstanceID and gapg.DefID = mga.GoalAreaDefID left join
		dbo.IepGoalArea tgt on mga.DestID = tgt.ID --- select * from IepGoalArea
		--where gapg.GoalIndex = 
		--	(select MIN(gaIn.GoalIndex) -- Enrich does not currently support multiple domains per Goal
		--	from AURORAX.GoalAreaPivotView gaIn
		--	where gaIn.GoalRefID = gapg.GoalRefID) 
go


/*

GEO.ShowLoadTables IepGoalArea

set nocount on;
declare @n varchar(100) ; select @n = 'IepGoalArea'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set Enabled = 1
	, HasMapTable = 1
	, MapTable = 'AURORAX.MAP_IepGoalArea'
	, KeyField = 'InstanceID, DefID'
	, DeleteKey = 'DestID'
	, DeleteTrans = 1
	, UpdateTrans = 0
	, DestTableFilter = NULL
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.*
-- DELETE AURORAX.MAP_IepGoalArea
FROM AURORAX.Transform_IepGoalArea AS s RIGHT OUTER JOIN 
	AURORAX.MAP_IepGoalArea as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

-- INSERT AURORAX.MAP_IepGoalArea
SELECT InstanceID, DefID, NEWID()
FROM AURORAX.Transform_IepGoalArea s
WHERE NOT EXISTS (SELECT * FROM IepGoalArea d WHERE s.DestID=d.ID)

-- INSERT IepGoalArea (ID, InstanceID, DefID, FormInstanceID)
SELECT s.DestID, s.InstanceID, s.DefID, s.FormInstanceID
FROM AURORAX.Transform_IepGoalArea s
WHERE NOT EXISTS (SELECT * FROM IepGoalArea d WHERE s.DestID=d.ID)

select * from IepGoalArea


*/

