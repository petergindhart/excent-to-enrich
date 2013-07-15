/* ============================================	IMPORTANT! ============================================
	
	Before using this script you must update the section below to populate the @MAP_IepGoalAreaDef table
	with the KeepID and the TossID.   

   ============================================	IMPORTANT! ============================================ */
Begin tran fixgoal
set nocount on;
declare @IepGoalAreaDef table (ID uniqueidentifier,Sequence int, Name varchar(50),AllowCustomProbes bit,  StateCode varchar(20),RequireGoal bit)

insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes ,StateCode,RequireGoal) values ('504CE0ED-537F-4EA0-BD97-0349FB1A4CA8',0,'Reading',0,NULL,1)
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes ,StateCode,RequireGoal) values ('37EA0554-EC3F-4B95-AAD7-A52DECC7377C',1,'Writing',0,NULL,1)
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes ,StateCode,RequireGoal) values ('0E95D360-5CBE-4ECA-820F-CC25864D70D8',2,'Mathematics',0,NULL,1)
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes ,StateCode,RequireGoal) values ('51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7',3,'Communication',0,NULL,1)
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes ,StateCode,RequireGoal) values ('4F131BE0-D2A9-4EB2-8639-D772E05F3D5E',4,'Time Management',0,NULL,1)
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes ,StateCode,RequireGoal) values ('25D890C3-BCAE-4039-AC9D-2AE21686DEB0',5,'Self Advocacy',0,NULL,1)
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes ,StateCode,RequireGoal) values ('6BBAADD8-BD9D-4C8F-A573-80F136B0A9FB',6,'Emotions',0,NULL,1)
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes ,StateCode,RequireGoal) values ('0C0783DD-3D11-47A2-A1C1-CFE2F8F1FB4C',7,'Organization',0,NULL,1)
insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes ,StateCode,RequireGoal) values ('702A94A6-9D11-408B-B003-11B9CCDE092E',8,'Other',0,NULL,1)

select * from IepGoalAreaDef order by Name
select * from @IepGoalAreaDef order by Name

--insert test
select t.ID, t.Sequence , t.Name,t.StateCode,t.RequireGoal
from IepGoalAreaDef g right join
@IepGoalAreaDef t on g.ID = t.ID 
where g.ID is null
order by  g.Name

---- delete test
select g.*, t.StateCode
from IepGoalAreaDef g left join
@IepGoalAreaDef t on g.ID = t.ID 
where t.ID is null


update t set RequireGoal = g.RequireGoal,
		 Sequence = g.Sequence,
		 AllowCustomProbes = g.AllowCustomProbes
--select g.*, t.StateCode
from IepGoalAreaDef g  join
@IepGoalAreaDef t on g.Name = t.Name 

-- insert missing.  This has to be done before updating the records to be deleted and before deleting.
insert IepGoalAreaDef (ID,Sequence,Name,StateCode,AllowCustomProbes,RequireGoal)
select t.ID, t.Sequence , t.Name,t.StateCode,t.AllowCustomProbes,t.RequireGoal
from IepGoalAreaDef g right join
@IepGoalAreaDef t on g.ID = t.ID 
where g.ID is null
order by  g.Name

update g set Name = t.Name
--select g.*, t.StateCode
from IepGoalAreaDef g  join
@IepGoalAreaDef t on g.ID = t.ID 
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


commit tran fixgoal

--ROLLBACK  tran fixgoal

