
-- Not currently in VC3ETL.LoadTable.  We are populating MAP_GoalAreaDefID in the state specific ETL Prep file.
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
END
GO

-- ############################################################################# 
-- Transform
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
	GoalAreaCode = isnull(k.LegacySpedCode, left(k.EnrichLabel, 150)),
	DestID = coalesce(i.ID, n.ID, t.ID,  m.DestID, k.EnrichID),
	Sequence = coalesce(i.Sequence, n.Sequence, t.Sequence, 99),
	Name = coalesce(i.Name, n.Name, t.Name, cast(k.EnrichLabel as varchar(50))),
	AllowCustomProbes = cast(0 as bit),
	StateCode = coalesce(i.StateCode, n.StateCode, t.StateCode),
	DeletedDate = case when k.EnrichID is not null then NULL  else coalesce(i.DeletedDate, n.DeletedDate, t.DeletedDate) end,
	RequireGoal = cast(1 as bit)
  FROM
	LEGACYSPED.SelectLists k LEFT JOIN
	dbo.IepGoalAreaDef i on k.EnrichID = i.ID left join
	dbo.IepGoalAreaDef n on k.EnrichLabel = n.Name and n.DeletedDate is null left join -- only match on the name if not soft-deleted?
	LEGACYSPED.MAP_IepGoalAreaDefID m on k.LegacySpedCode = m.GoalAreaCode LEFT JOIN 
	dbo.IepGoalAreaDef t on m.DestID = t.ID 
WHERE k.Type = 'GoalArea'
GO


/*

select * from VC3ETL.LoadTable where DestTable = 'IepGoalAreaDef'
select * from VC3ETL.LoadTable where DestTable = 'PrgLocation'

select Enabled, * from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' order by Sequence

update lt set Sequence = Sequence+1
from VC3ETL.LoadTable lt
where lt.ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' 
and Sequence between 28 and 30


update lt set Sequence = Sequence-1
from VC3ETL.LoadTable lt
where lt.ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' 
and Sequence between 30 and 33





update vc3etl.loadtable set sequence = 28 where id = 'B63C39F8-A605-4988-B2FD-B905ACC25E4C'

update vc3etl.loadtable set sequence = 32 where id = 'DCAA0626-5046-4B9C-93D9-F448F77DE1BD'

update vc3etl.loadtable set sequence = 33 where id = '1D683708-D043-4CE3-8427-E5E9AD0D6256'




declare @lt uniqueidentifier ; select @lt = 'B63C39F8-A605-4988-B2FD-B905ACC25E4C'
delete vc3etl.loadcolumn where loadtable = @lt
delete vc3etl.loadtable where id = @lt


-- copy and paste this code into the SSMS window, then fill in the appropriate values, including those set to null below  
exec GEO.ScriptCreate_LoadTable  
 @Schema = 'LEGACYSPED',   
 @Xform = 'IepGoalAreaDef',  -- do not include .Transform_  
 @Target = 'IepGoalAreaDef',   
 @HasMap = '1',   -- 0 or 1  
 @MapTable = 'MAP_IepGoalAreaDefID',   
 @MapKey = 'GoalAreaCode',  
 @DelKey = NULL,  
 @ImportType = '1',  -- 1, 2, 3, 4  
 @Deleteable = '0',  -- 0 or 1  
 @Updatable = '1',  -- 0 or 1  
 @Insertable = '1',  -- 0 or 1  
 @SrcFilt = NULL,   
 @DestFilt = 's.DestID in (select DestID from LEGACYSPED.MAP_IepGoalAreaDefID)',   
 @PurgeCondition = NULL,   
 @KeepMappingAfterDelete = 0,   
 @StartNewTransaction = 0  



-- copy and paste this code into the SSMS window, then fill in the appropriate values, including those set to null below    
exec GEO.ScriptCreate_LoadColumn  
 @ExtractDBname = 'Special Ed Data',
 @SourceSchema = 'LEGACYSPED',  
 @TargetSchema = 'dbo',  
 @DestTable = 'IepGoalAreaDef'



if not exists (select 1 from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' AND DestTable = 'IepGoalAreaDef')  
begin  
 insert VC3ETL.LoadTable (ID, ExtractDatabase, Sequence, SourceTable, DestTable, HasMapTable, MapTable, KeyField, DeleteKey, ImportType, DeleteTrans, UpdateTrans, InsertTrans, Enabled, SourceTableFilter, DestTableFilter, PurgeCondition, KeepMappingAfterDelete, StartNewTransaction)  
 values ('B63C39F8-A605-4988-B2FD-B905ACC25E4C', '29D14961-928D-4BEE-9025-238496D144C6', 33, 'LEGACYSPED.Transform_IepGoalAreaDef', 'IepGoalAreaDef', 1, 'LEGACYSPED.MAP_IepGoalAreaDefID', 'GoalAreaCode', NULL, 1, 0, 1, 1, 1, NULL, 's.DestID in (select DestID from LEGACYSPED.MAP_IepGoalAreaDefID)', NULL, '0', '0')  
end  


if not exists (select 1 from VC3ETL.LoadColumn where LoadTable = 'B63C39F8-A605-4988-B2FD-B905ACC25E4C' and DestColumn = 'ID')  
begin
 insert VC3ETL.LoadColumn (ID, LoadTable, SourceColumn, DestColumn, ColumnType, UpdateOnDelete, DeletedValue, NullValue)  
 values ('F879C713-E39C-4AC3-AF58-EB5ABF5ACF36', 'B63C39F8-A605-4988-B2FD-B905ACC25E4C', 'DestID', 'ID', 'K', 0, NULL, NULL)  
end  

if not exists (select 1 from VC3ETL.LoadColumn where LoadTable = 'B63C39F8-A605-4988-B2FD-B905ACC25E4C' and DestColumn = 'Sequence')  
begin
 insert VC3ETL.LoadColumn (ID, LoadTable, SourceColumn, DestColumn, ColumnType, UpdateOnDelete, DeletedValue, NullValue)  
 values ('B8B0F945-E4F4-48D4-B018-FFA0DCAB87F0', 'B63C39F8-A605-4988-B2FD-B905ACC25E4C', 'Sequence', 'Sequence', 'C', 0, NULL, NULL)  
end  

if not exists (select 1 from VC3ETL.LoadColumn where LoadTable = 'B63C39F8-A605-4988-B2FD-B905ACC25E4C' and DestColumn = 'Name')  
begin
 insert VC3ETL.LoadColumn (ID, LoadTable, SourceColumn, DestColumn, ColumnType, UpdateOnDelete, DeletedValue, NullValue)  
 values ('6F68F70C-867C-4317-8564-0F1B6F955BFF', 'B63C39F8-A605-4988-B2FD-B905ACC25E4C', 'Name', 'Name', 'C', 0, NULL, NULL)  
end  

if not exists (select 1 from VC3ETL.LoadColumn where LoadTable = 'B63C39F8-A605-4988-B2FD-B905ACC25E4C' and DestColumn = 'AllowCustomProbes')  
begin
 insert VC3ETL.LoadColumn (ID, LoadTable, SourceColumn, DestColumn, ColumnType, UpdateOnDelete, DeletedValue, NullValue)  
 values ('FC439105-2111-4EE8-95A7-C81F94830C4E', 'B63C39F8-A605-4988-B2FD-B905ACC25E4C', 'AllowCustomProbes', 'AllowCustomProbes', 'C', 0, NULL, NULL)  
end  

if not exists (select 1 from VC3ETL.LoadColumn where LoadTable = 'B63C39F8-A605-4988-B2FD-B905ACC25E4C' and DestColumn = 'StateCode')  
begin
 insert VC3ETL.LoadColumn (ID, LoadTable, SourceColumn, DestColumn, ColumnType, UpdateOnDelete, DeletedValue, NullValue)  
 values ('9998F0AF-4ECC-46D7-AF6E-972AC4CA9D12', 'B63C39F8-A605-4988-B2FD-B905ACC25E4C', 'StateCode', 'StateCode', 'C', 0, NULL, NULL)  
end  

if not exists (select 1 from VC3ETL.LoadColumn where LoadTable = 'B63C39F8-A605-4988-B2FD-B905ACC25E4C' and DestColumn = 'DeletedDate')  
begin
 insert VC3ETL.LoadColumn (ID, LoadTable, SourceColumn, DestColumn, ColumnType, UpdateOnDelete, DeletedValue, NullValue)  
 values ('F5FC203E-6F24-4E58-A9FC-BC31E834D770', 'B63C39F8-A605-4988-B2FD-B905ACC25E4C', 'DeletedDate', 'DeletedDate', 'C', 0, NULL, NULL)  
end  


  
exec VC3ETL.LoadTable_Run   
 @LoadTable = 'B63C39F8-A605-4988-B2FD-B905ACC25E4C',  
 @ConstantsSql = '',  
 @printSql = 1,  
 @executeSql = 0  

  
  

-- delete LEGACYSPED.MAP_GoalAreaDefID

select d.*
-- UPDATE IepGoalAreaDef SET Sequence=s.Sequence, Name=s.Name, StateCode=s.StateCode, DeletedDate=s.DeletedDate, AllowCustomProbes=s.AllowCustomProbes
FROM  IepGoalAreaDef d JOIN 
	LEGACYSPED.Transform_IepGoalAreaDef  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from LEGACYSPED.MAP_IepGoalAreaDefID)

-- INSERT LEGACYSPED.MAP_IepGoalAreaDefID
SELECT GoalAreaCode, NEWID()
FROM LEGACYSPED.Transform_IepGoalAreaDef s
WHERE NOT EXISTS (SELECT * FROM IepGoalAreaDef d WHERE s.DestID=d.ID)

-- INSERT IepGoalAreaDef (ID, Sequence, Name, StateCode, DeletedDate, AllowCustomProbes)
SELECT s.DestID, s.Sequence, s.Name, s.StateCode, s.DeletedDate, s.AllowCustomProbes
FROM LEGACYSPED.Transform_IepGoalAreaDef s
WHERE NOT EXISTS (SELECT * FROM IepGoalAreaDef d WHERE s.DestID=d.ID)


rollback tran testgr





set nocount on;
declare @n varchar(100) ; select @n = 'IepGoalAreaDef'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set Enabled = 1
	, HasMapTable = 1
	, MapTable = 'LEGACYSPED.MAP_IepGoalArea'
	, KeyField = 'InstanceID, DefID'
	, DeleteKey = 'DestID'
	, DeleteTrans = 1
	, UpdateTrans = 0
	, DestTableFilter = NULL
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


*/
