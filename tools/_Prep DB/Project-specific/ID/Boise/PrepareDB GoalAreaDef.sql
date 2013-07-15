set nocount on;

declare @SelectLists table (Type varchar(20), SubType varchar(20), EnrichID uniqueidentifier, StateCode varchar(10), EnrichLabel varchar(254))

insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7', NULL, 'Behavior')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '4F131BE0-D2A9-4EB2-8639-D772E05F3D5E', NULL, 'Developmental Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '0E95D360-5CBE-4ECA-820F-CC25864D70D8', NULL, 'Mathematics')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '6BBAADD8-BD9D-4C8F-A573-80F136B0A9FB', NULL, 'Occupational Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '0C0783DD-3D11-47A2-A1C1-CFE2F8F1FB4C', NULL, 'Orientation and Mobility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '702A94A6-9D11-408B-B003-11B9CCDE092E', NULL, 'Other')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, 'B23994DB-2DEB-4D87-B77E-86E76F259A3E', NULL, 'Physical Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '504CE0ED-537F-4EA0-BD97-0349FB1A4CA8', NULL, 'Reading')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '25D890C3-BCAE-4039-AC9D-2AE21686DEB0', NULL, 'Speech/Language Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '37EA0554-EC3F-4B95-AAD7-A52DECC7377C', NULL, 'Written Language')



--=========================================================================================================================
--				IepGoalAreaDef
--=========================================================================================================================

select EnrichID, EnrichLabel from @SelectLists where Type ='GoalArea'
select * from IepGoalAreaDef order by Sequence		


declare @IepGoalAreaDef table (ID uniqueidentifier,Sequence int, Name varchar(50),AllowCustomProbes bit,RequireGoal bit)

insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7',0,'Behavior',0,1)
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('4F131BE0-D2A9-4EB2-8639-D772E05F3D5E',1,'Developmental Therapy',0,1)
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('0E95D360-5CBE-4ECA-820F-CC25864D70D8',3,'Mathematics',0,1)	
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('6BBAADD8-BD9D-4C8F-A573-80F136B0A9FB',4,'Occupational Therapy',0,1)
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('0C0783DD-3D11-47A2-A1C1-CFE2F8F1FB4C',5,'Orientation and Mobility',0,1)	
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('702A94A6-9D11-408B-B003-11B9CCDE092E',6,'Other',0,1)	
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('B23994DB-2DEB-4D87-B77E-86E76F259A3E',7,'Physical Therapy',0,1)	
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('504CE0ED-537F-4EA0-BD97-0349FB1A4CA8',8,'Reading',0,1)	
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('25D890C3-BCAE-4039-AC9D-2AE21686DEB0',9,'Speech/Language Therapy',0,1)	
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('37EA0554-EC3F-4B95-AAD7-A52DECC7377C',10,'Written Language',0,1)			
	
	
--insert test
select t.EnrichID, tig.Sequence , t.EnrichLabel,t.StateCode,tig.RequireGoal
from IepGoalAreaDef g right join
(select * from @SelectLists where Type ='GoalArea') t on g.ID = t.EnrichID JOIN 
@IepGoalAreaDef tig on t.EnrichID =tig.ID
where g.ID is null
order by  g.Name

---- delete test
select g.*, t.StateCode
from IepGoalAreaDef g left join
(select * from @SelectLists where Type ='GoalArea') t on g.ID = t.EnrichID 
where t.EnrichID is null

Begin tran fixgoal

update tig set RequireGoal = g.RequireGoal,
		 Sequence = g.Sequence,
		 AllowCustomProbes = g.AllowCustomProbes
--select g.*, t.StateCode
from IepGoalAreaDef g  join
(select * from @SelectLists where Type ='GoalArea') t on g.ID = t.EnrichID JOIN 
@IepGoalAreaDef tig on t.EnrichID =tig.ID
where g.ID is null

insert IepGoalAreaDef (ID,Sequence,Name,StateCode,AllowCustomProbes,RequireGoal)
select t.EnrichID, tig.Sequence , t.EnrichLabel,t.StateCode,tig.AllowCustomProbes, tig.RequireGoal
from IepGoalAreaDef g right join
(select * from @SelectLists where Type ='GoalArea') t on g.ID = t.EnrichID JOIN 
@IepGoalAreaDef tig on t.EnrichID =tig.ID
where g.ID is null
order by  g.Name

update g set Name = t.EnrichLabel
--select g.*, t.StateCode
from IepGoalAreaDef g  join
(select * from @SelectLists where Type ='GoalArea') t on g.ID = t.EnrichID

declare @MAP_IepGoalAreaDef table (KeepID uniqueidentifier, TossID uniqueidentifier)

-- populate a mapping that to update FK related records of GradeLevvel records that will be deleted   
	-- this needs to be done by visual inspection because Grade Level names can vary widely
-- 1. un-comment the rows required to map for updating FK related tables.  
-- 2. Add the ID that needs to be deleted in the Empty quotes of the Values insert
--insert @MAP_IepGoalAreaDef values('51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7','')
--insert @MAP_IepGoalAreaDef values('6BBAADD8-BD9D-4C8F-A573-80F136B0A9FB','')
--insert @MAP_IepGoalAreaDef values('0E95D360-5CBE-4ECA-820F-CC25864D70D8','')
--insert @MAP_IepGoalAreaDef values('0C0783DD-3D11-47A2-A1C1-CFE2F8F1FB4C','')
--insert @MAP_IepGoalAreaDef values('702A94A6-9D11-408B-B003-11B9CCDE092E','')
--insert @MAP_IepGoalAreaDef values('504CE0ED-537F-4EA0-BD97-0349FB1A4CA8','')
--insert @MAP_IepGoalAreaDef values('25D890C3-BCAE-4039-AC9D-2AE21686DEB0','')
--insert @MAP_IepGoalAreaDef values('4F131BE0-D2A9-4EB2-8639-D772E05F3D5E','')
--insert @MAP_IepGoalAreaDef values('37EA0554-EC3F-4B95-AAD7-A52DECC7377C','')

declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50)

declare I cursor for 
select KeepID, TossID from @MAP_IepGoalAreaDef 

open I
fetch I into @KeepID, @TossID

while @@fetch_status = 0

begin

	declare R cursor for 
	SELECT 
		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
		OBJECT_NAME(f.parent_object_id) AS TableName,
		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
	FROM sys.foreign_keys AS f
		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
		and OBJECT_NAME (f.referenced_object_id) = 'IepGoalAreaDef' ------------------------------- table name
		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
	order by SchemaName, TableName, ColumnName

	open R
	fetch R into @relschema, @RelTable, @relcolumn

	while @@fetch_status = 0
	begin

 	exec ('update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' )

	fetch R into @relschema, @RelTable, @relcolumn
	end
	close R
	deallocate R

fetch I into @KeepID, @TossID
end
close I
deallocate I

delete g
 --select g.*, t.StateCode
from IepGoalAreaDef g join
@MAP_IepGoalAreaDef t on g.ID = t.TossID 

select * from IepGoalAreaDef where DeletedDate is null order by Name

commit tran fixgoal

--ROLLBACK  tran fixgoal
