
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
-- non-standard
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('C808C991-CA93-4F51-AF41-A8BA494AC10F', 'Infant', 1, 0, 0, '002') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('4B0ED575-7C9A-451D-A8E6-2D9F22F31349', 'Half Day K', 1, 2, 0, '006') 
-- standard
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('6061CD90-8BEC-4389-A140-CF645A5D47FE', 'Pre-K', 1, 1, 0, '004') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('7269BD32-C052-455B-B3E3-FF5BCB199679', '00', 1, 2, 0, '007') -- name chosen by someone else
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('07975B7A-8A1A-47AE-A71F-7ED97BA9D48B', '01', 1, 4, 2, '010') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('DDC4180A-64FC-49BD-AC11-DAA185059885', '02', 1, 8, 3, '020') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('D3C1BD80-0D32-4317-BAB8-CAF196D19350', '03', 1, 16, 4, '030') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('BE4F651A-D5B5-4B05-8237-9FD33E4D2B68', '04', 1, 32, 5, '040') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('5A021B34-D33B-43B5-BD8A-40446AC2E972', '05', 1, 64, 6, '050') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('92B484A3-2DBD-4952-9519-03B848AE1215', '06', 1, 128, 7, '060') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('81FEC824-DB83-4C5D-91A5-2DFE72DE93EC', '07', 1, 256, 8, '070') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('245F48A7-6927-4EFA-A3F2-AF30463C9B4D', '08', 1, 512, 9, '080') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3', '09', 1, 1024, 10, '090') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('8085537C-8EA9-4801-8EC8-A8BDA7E61DB6', '10', 1, 2048, 11, '100') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('EA727CED-8A2C-4434-974A-6D8D924D95C6', '11', 1, 4096, 12, '110') 
insert @GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode) values ('0D7B8529-62C7-4F25-B78F-2A4724BD7990', '12', 1, 8192, 13, '120') 

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
update g set StateCode = t.StateCode
-- select g.*, t.StateCode
from GradeLevel g left join
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
--insert @MAP_GradeLevel values ('C808C991-CA93-4F51-AF41-A8BA494AC10F', '') --  '') --  'Infant', 1, 0, 0, '002') 
--insert @MAP_GradeLevel values ('4B0ED575-7C9A-451D-A8E6-2D9F22F31349', '') --  'Half Day K', 1, 0, 0, '006') 
--insert @MAP_GradeLevel values ('6061CD90-8BEC-4389-A140-CF645A5D47FE', '') --  'Pre-K', 1, 1, 0, '004') 
insert @MAP_GradeLevel values ('7269BD32-C052-455B-B3E3-FF5BCB199679', '10B6907F-2675-4610-983E-B460338569BE') --  '00', 1, 2, 0, '007') 
--insert @MAP_GradeLevel values ('07975B7A-8A1A-47AE-A71F-7ED97BA9D48B', '') --  '01', 1, 4, 2, '010') 
--insert @MAP_GradeLevel values ('DDC4180A-64FC-49BD-AC11-DAA185059885', '') --  '02', 1, 8, 3, '020') 
--insert @MAP_GradeLevel values ('D3C1BD80-0D32-4317-BAB8-CAF196D19350', '') --  '03', 1, 16, 4, '030') 
--insert @MAP_GradeLevel values ('BE4F651A-D5B5-4B05-8237-9FD33E4D2B68', '') --  '04', 1, 32, 5, '040') 
--insert @MAP_GradeLevel values ('5A021B34-D33B-43B5-BD8A-40446AC2E972', '') --  '05', 1, 64, 6, '050') 
--insert @MAP_GradeLevel values ('92B484A3-2DBD-4952-9519-03B848AE1215', '') --  '06', 1, 128, 7, '060') 
--insert @MAP_GradeLevel values ('81FEC824-DB83-4C5D-91A5-2DFE72DE93EC', '') --  '07', 1, 256, 8, '070') 
--insert @MAP_GradeLevel values ('245F48A7-6927-4EFA-A3F2-AF30463C9B4D', '') --  '08', 1, 512, 9, '080') 
--insert @MAP_GradeLevel values ('FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3', '') --  '09', 1, 1024, 10, '090') 
--insert @MAP_GradeLevel values ('8085537C-8EA9-4801-8EC8-A8BDA7E61DB6', '') --  '10', 1, 2048, 11, '100') 
--insert @MAP_GradeLevel values ('EA727CED-8A2C-4434-974A-6D8D924D95C6', '') --  '11', 1, 4096, 12, '110') 
--insert @MAP_GradeLevel values ('0D7B8529-62C7-4F25-B78F-2A4724BD7990', '') --  '12', 1, 8192, 13, '120') 


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


/* -- these tables from Ute Pass BOCES database were successfully updated during testing, permitting the deletion of the uneeded records from GradeLevel

ClassRoster
ContentAreaRequirement
GradeGoal
Student
StudentGradeLevelHistory
TestScoreGoalValue

*/

---- delete unneeded
delete g
-- select g.*, t.StateCode
from GradeLevel g join
@MAP_GradeLevel t on g.ID = t.TossID 

commit tran fixgrad

--Rollback tran fixgrad


/*
select * from GradeLevel g order by g.Active desc, g.Sequence, g.BitMask, g.stateCode, g.Name

6061CD90-8BEC-4389-A140-CF645A5D47FE	PK	1	1		0	PK
7269BD32-C052-455B-B3E3-FF5BCB199679	K	0	2		0	KG
07975B7A-8A1A-47AE-A71F-7ED97BA9D48B	01	1	4		2	01
DDC4180A-64FC-49BD-AC11-DAA185059885	02	1	8		3	02
D3C1BD80-0D32-4317-BAB8-CAF196D19350	03	1	16		4	03
BE4F651A-D5B5-4B05-8237-9FD33E4D2B68	04	1	32		5	04
5A021B34-D33B-43B5-BD8A-40446AC2E972	05	1	64		6	05
92B484A3-2DBD-4952-9519-03B848AE1215	06	1	128		7	06
81FEC824-DB83-4C5D-91A5-2DFE72DE93EC	07	1	256		8	07
245F48A7-6927-4EFA-A3F2-AF30463C9B4D	08	1	512		9	08
FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3	09	1	1024	10	09
8085537C-8EA9-4801-8EC8-A8BDA7E61DB6	10	1	2048	11	10
EA727CED-8A2C-4434-974A-6D8D924D95C6	11	1	4096	12	11
0D7B8529-62C7-4F25-B78F-2A4724BD7990	12	1	8192	13	12

*/






