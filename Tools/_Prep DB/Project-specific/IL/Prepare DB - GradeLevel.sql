
/* ============================================	IMPORTANT! ============================================
	
	Before using this script you must update the section below to populate the @MAP_GradeLevel table
	with the KeepID and the TossID.   
	
	You will determine these values by comparing the Name field of the @GradeLevel table and the 
	Name field of GradeLevel.  
	
	Example:
	Suppose there are 2 records in GradeLevel for Pre-Kindergarten, one of them being the expected value and the
	other not.  Suppose that the good record has a name of PK and that the unneeded record has a name of Pre-K.

	The unexpected Pre-K record needs to be deleted from GradeLevel.  Since there are a lot of FK relationships 
	referring to GradeLevel.ID, the related tables need to be updated first.
	
	To do this, populate the @MAP_GradeLevel table as follows:
	1.  Uncomment the line for PK
	2.  Populate the empty quotes on that line with the ID from GradeLevel that corresponds to the Pre-K record.
	3.  Then simply run this entire script
	
	The cursor query looks for all of the FK relationships for GradeLevel.ID and updates the ID that is to be deleted
	with the ID that is to be kept.

   ============================================	IMPORTANT! ============================================ */


set nocount on;
declare @GradeLevel table (ID uniqueidentifier, Name varchar(10), Active bit, BitMask int, Sequence int, StateCode varchar(10))

insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('10B6907F-2675-4610-983E-B460338569BE', convert( varchar(10),'Birth to 3'), 1, 2, 0, '00') -- name chosen by someone else
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('07975B7A-8A1A-47AE-A71F-7ED97BA9D48B', convert( varchar(10),'Grade 1'), 1, 4, 2, '01') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('DDC4180A-64FC-49BD-AC11-DAA185059885', convert(varchar(10), 'Grade 2'), 1, 8, 3, '02') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('D3C1BD80-0D32-4317-BAB8-CAF196D19350', convert( varchar(10),'Grade 3'), 1, 16, 4, '03') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('BE4F651A-D5B5-4B05-8237-9FD33E4D2B68', convert( varchar(10),'Grade 4'), 1, 32, 5, '04') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('5A021B34-D33B-43B5-BD8A-40446AC2E972', convert( varchar(10),'Grade 5'), 1, 64, 6, '05') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('92B484A3-2DBD-4952-9519-03B848AE1215', convert( varchar(10),'Grade 6'), 1, 128, 7, '06') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('81FEC824-DB83-4C5D-91A5-2DFE72DE93EC', convert( varchar(10),'Grade 7'), 1, 256, 8, '07') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('245F48A7-6927-4EFA-A3F2-AF30463C9B4D', convert( varchar(10),'Grade 8'), 1, 512, 9, '08') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3', convert( varchar(10),'Grade 9'), 1, 1024, 10, '09') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('8085537C-8EA9-4801-8EC8-A8BDA7E61DB6', convert( varchar(10),'Grade 10'), 1, 2048, 11, '10') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('EA727CED-8A2C-4434-974A-6D8D924D95C6', convert( varchar(10),'Grade 11'), 1, 4096, 12, '11') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('0D7B8529-62C7-4F25-B78F-2A4724BD7990', convert( varchar(10),'Grade 12'), 1, 8192, 13, '12')
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('C7C1BEDA-B3D0-4D73-ABBB-9EC9E95ED92E', convert( varchar(10),'Pre-K'), 1, 1, 0, '14') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('4410F5E9-B2F1-40CD-8157-E8BB4F76CD2D', convert( varchar(10),'KinderGarten'), 1, 2, 0, '15') 

--select * from GradeLevel g order by g.Active desc, g.Sequence, g.BitMask, g.stateCode, g.Name
--select * from @GradeLevel g order by g.Active desc, g.Sequence, g.BitMask, g.stateCode, g.Name


---- insert test
select t.ID, t.Name, t.Active, t.BitMask, t.Sequence, t.StateCode
from GradeLevel g right join
@GradeLevel t on g.ID = t.ID 
where g.ID is null
order by g.Active desc, g.Sequence, g.BitMask, g.stateCode, g.Name

---- delete test
select g.*, t.StateCode
from GradeLevel g left join
@GradeLevel t on g.ID = t.ID 
where t.ID is null


Begin tran fixgrad


-- update state code
update g set StateCode = t.StateCode,
			 Active = t.Active	
-- select g.*, t.StateCode
from GradeLevel g  join
@GradeLevel t on g.ID = t.ID 

-- 7269BD32-C052-455B-B3E3-FF5BCB199679	00
-- insert missing.  This has to be done before updating the records to be deleted and before deleting.
insert GradeLevel 
select t.ID, t.Name, t.Active, t.BitMask, t.Sequence, t.StateCode
from GradeLevel g right join
@GradeLevel t on g.ID = t.ID 
where g.ID is null
order by g.Active desc, g.Sequence, g.BitMask, g.stateCode, g.Name


-- test for mapping table values
select g.*, t.StateCode
from GradeLevel g left join
@GradeLevel t on g.ID = t.ID 
where t.ID is null



--10B6907F-2675-4610-983E-B460338569BE	00

declare @MAP_GradeLevel table (KeepID uniqueidentifier, TossID uniqueidentifier)

-- populate a mapping that to update FK related records of GradeLevvel records that will be deleted   
	-- this needs to be done by visual inspection because Grade Level names can vary widely
-- 1. un-comment the rows required to map for updating FK related tables.  
-- 2. Add the ID that needs to be deleted in the Empty quotes of the Values insert
--insert @MAP_GradeLevel values ('10B6907F-2675-4610-983E-B460338569BE','')--'Birth to 3'
--insert @MAP_GradeLevel values ('C7C1BEDA-B3D0-4D73-ABBB-9EC9E95ED92E','')--'Pre-k'
--insert @MAP_GradeLevel values ('4410F5E9-B2F1-40CD-8157-E8BB4F76CD2D','')--'KinderGarten'
--insert @MAP_GradeLevel values ('07975B7A-8A1A-47AE-A71F-7ED97BA9D48B','')--'Grade 1'
--insert @MAP_GradeLevel values ('DDC4180A-64FC-49BD-AC11-DAA185059885','')--'Grade 2'
--insert @MAP_GradeLevel values ('D3C1BD80-0D32-4317-BAB8-CAF196D19350','')--'Grade 3'
--insert @MAP_GradeLevel values ('BE4F651A-D5B5-4B05-8237-9FD33E4D2B68','')--'Grade 4'
--insert @MAP_GradeLevel values ('5A021B34-D33B-43B5-BD8A-40446AC2E972','')--'Grade 5'
--insert @MAP_GradeLevel values ('92B484A3-2DBD-4952-9519-03B848AE1215','')--'Grade 6'
--insert @MAP_GradeLevel values ('81FEC824-DB83-4C5D-91A5-2DFE72DE93EC','')--'Grade 7'
--insert @MAP_GradeLevel values ('245F48A7-6927-4EFA-A3F2-AF30463C9B4D','')--'Grade 8'
--insert @MAP_GradeLevel values ('FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3','')--'Grade 9'
--insert @MAP_GradeLevel values ('8085537C-8EA9-4801-8EC8-A8BDA7E61DB6','')--'Grade 10'
--insert @MAP_GradeLevel values ('EA727CED-8A2C-4434-974A-6D8D924D95C6','')--'Grade 11'
--insert @MAP_GradeLevel values ('0D7B8529-62C7-4F25-B78F-2A4724BD7990','')--'Grade 12'


--10B6907F-2675-4610-983E-B460338569BE	00	1	2	1	NULL	NULL





-- list all tables with FK on GradeLevel and update them 

declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50)

declare I cursor for 
select KeepID, TossID from @MAP_GradeLevel 

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
		and OBJECT_NAME (f.referenced_object_id) = 'GradeLevel' 
		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
		and OBJECT_NAME(f.parent_object_id) <> 'StudentGradeLevelHistory'
	order by SchemaName, TableName, ColumnName

	open R
	fetch R into @relschema, @RelTable, @relcolumn

	while @@fetch_status = 0
	begin

 	exec ('update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' )
	--print 'update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' 
	fetch R into @relschema, @RelTable, @relcolumn
	end
	close R
	deallocate R

exec ('
update ts set GradeLevelID = '''+@KeepID+'''
-- select ts.*, kp.GradeLevelID
from dbo.StudentGradeLevelHistory ts 
left join dbo.StudentGradeLevelHistory kp on kp.StudentID = ts.StudentID and kp.StartDate = ts.StartDate and kp.GradeLevelID = '''+@KeepID+'''
where ts.GradeLevelID = '''+@TossID+'''
and kp.GradeLevelID is null

delete ts 
-- select ts.*, kp.GradeLevelID
from dbo.StudentGradeLevelHistory ts 
where ts.GradeLevelID = '''+@TossID+'''

')

fetch I into @KeepID, @TossID
end
close I
deallocate I

/* 
set nocount off;
update ts set GradeLevelID = '6061CD90-8BEC-4389-A140-CF645A5D47FE'
-- select ts.*, kp.GradeLevelID
from dbo.StudentGradeLevelHistory ts 
left join dbo.StudentGradeLevelHistory kp on kp.StudentID = ts.StudentID and kp.StartDate = ts.StartDate and kp.GradeLevelID = '6061CD90-8BEC-4389-A140-CF645A5D47FE'
where ts.GradeLevelID = 'D90C08C8-683F-4C2B-9D1F-769D904CD060'
and kp.GradeLevelID is null

delete ts 
-- select ts.*, kp.GradeLevelID
from dbo.StudentGradeLevelHistory ts 
where ts.GradeLevelID = 'D90C08C8-683F-4C2B-9D1F-769D904CD060'


*/

 --delete unneeded
delete g
-- select g.*, t.StateCode
from GradeLevel g join
@MAP_GradeLevel t on g.ID = t.TossID 

update GradeLevel set Active = 0 where ID not in (select ID from @GradeLevel)

commit tran fixgrad

--Rollback tran fixgrad

--select * from StudentGradeLevelHistory where GradeLevelID = 'D90C08C8-683F-4C2B-9D1F-769D904CD060'

--select * from GradeLevel  where active =1 order by bitmask







