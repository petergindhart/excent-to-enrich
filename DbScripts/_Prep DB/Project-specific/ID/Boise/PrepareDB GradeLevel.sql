set nocount on;
declare @SelectLists table (Type varchar(20), SubType varchar(20), EnrichID uniqueidentifier, StateCode varchar(10), EnrichLabel varchar(254))

insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '6061CD90-8BEC-4389-A140-CF645A5D47FE', 'PK', 'PK')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '10B6907F-2675-4610-983E-B460338569BE', NULL, '00')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '7269BD32-C052-455B-B3E3-FF5BCB199679', 'KG', 'K')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '07975B7A-8A1A-47AE-A71F-7ED97BA9D48B', '1', '01')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, 'DDC4180A-64FC-49BD-AC11-DAA185059885', '2', '02')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, 'D3C1BD80-0D32-4317-BAB8-CAF196D19350', '3', '03')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, 'BE4F651A-D5B5-4B05-8237-9FD33E4D2B68', '4', '04')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '5A021B34-D33B-43B5-BD8A-40446AC2E972', '5', '05')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '92B484A3-2DBD-4952-9519-03B848AE1215', '6', '06')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '81FEC824-DB83-4C5D-91A5-2DFE72DE93EC', '7', '07')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '245F48A7-6927-4EFA-A3F2-AF30463C9B4D', '8', '08')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, 'FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3', '9', '09')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '8085537C-8EA9-4801-8EC8-A8BDA7E61DB6', '10', '10')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, 'EA727CED-8A2C-4434-974A-6D8D924D95C6', '11', '11')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '0D7B8529-62C7-4F25-B78F-2A4724BD7990', '12', '12')

--=====================================GradeLevel==================================================
select * from @SelectLists where Type = 'Grade'
select * from GradeLevel g order by g.Active desc, g.Sequence, g.BitMask, g.stateCode, g.Name

declare @GradeLevel table (ID uniqueidentifier, Name varchar(10), Active bit, BitMask int, Sequence int)

insert @GradeLevel (ID, Name, Active, BitMask, Sequence) values ('6061CD90-8BEC-4389-A140-CF645A5D47FE','PK',1,1,0)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('10B6907F-2675-4610-983E-B460338569BE','00',1,2,1)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('7269BD32-C052-455B-B3E3-FF5BCB199679','K',1,2,0)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('07975B7A-8A1A-47AE-A71F-7ED97BA9D48B','01',1,4,2)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('DDC4180A-64FC-49BD-AC11-DAA185059885','02',1,8,3)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('D3C1BD80-0D32-4317-BAB8-CAF196D19350','03',1,16,4)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('BE4F651A-D5B5-4B05-8237-9FD33E4D2B68','04',1,32,5)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('5A021B34-D33B-43B5-BD8A-40446AC2E972','05',1,64,6)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('92B484A3-2DBD-4952-9519-03B848AE1215','06',1,128,6)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('81FEC824-DB83-4C5D-91A5-2DFE72DE93EC','07',1,256,8)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('245F48A7-6927-4EFA-A3F2-AF30463C9B4D','08',1,512,9)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3','09',1,1024,10)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('8085537C-8EA9-4801-8EC8-A8BDA7E61DB6','10',1,2048,11)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('EA727CED-8A2C-4434-974A-6D8D924D95C6','11',1,4096,12)
insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('0D7B8529-62C7-4F25-B78F-2A4724BD7990','12',1,8192,13)

select t.EnrichID, t.EnrichLabel,tg.Active, tg.BitMask, tg.Sequence, t.StateCode
from GradeLevel g right join
(select * from @SelectLists where Type = 'Grade') t on g.ID = t.EnrichID  join 
@GradeLevel tg on g.ID =tg.ID
where g.ID is null
order by g.Active desc, g.Sequence, g.BitMask, g.stateCode, g.Name

---- delete test
select g.*, t.StateCode
from GradeLevel g left join
(select * from @SelectLists where Type = 'Grade') t on g.ID = t.EnrichID 
where t.EnrichID is null

Begin tran fixgrad


-- update state code
update g set StateCode = t.StateCode,
			 Active = tg.Active	
-- select g.*, t.StateCode
from GradeLevel g  join
(select * from @SelectLists where Type = 'Grade') t on g.ID = t.EnrichID join 
@GradeLevel tg on g.ID =tg.ID

---- 7269BD32-C052-455B-B3E3-FF5BCB199679	00
---- insert missing.  This has to be done before updating the records to be deleted and before deleting.
insert GradeLevel 
select t.EnrichID, t.EnrichLabel,tg.Active, tg.BitMask, tg.Sequence, t.StateCode,NULL
from GradeLevel g right join
(select * from @SelectLists where Type = 'Grade') t on g.ID = t.EnrichID  join 
@GradeLevel tg on g.ID =tg.ID
where g.ID is null
order by g.Active desc, g.Sequence, g.BitMask, g.stateCode, g.Name

---- test for mapping table values
--select g.*, t.StateCode
--from GradeLevel g left join
--@GradeLevel t on g.ID = t.ID 
--where t.ID is null



----10B6907F-2675-4610-983E-B460338569BE	00

declare @MAP_GradeLevel table (KeepID uniqueidentifier, TossID uniqueidentifier)

---- populate a mapping that to update FK related records of GradeLevvel records that will be deleted   
--	-- this needs to be done by visual inspection because Grade Level names can vary widely
---- 1. un-comment the rows required to map for updating FK related tables.  
---- 2. Add the ID that needs to be deleted in the Empty quotes of the Values insert
----insert @MAP_GradeLevel values ('C808C991-CA93-4F51-AF41-A8BA494AC10F', '') --  '') --  'Infant', 1, 0, 0, '002') 
----insert @MAP_GradeLevel values ('4B0ED575-7C9A-451D-A8E6-2D9F22F31349', '') --  'Half Day K', 1, 0, 0, '006') 
--insert @MAP_GradeLevel values ('6061CD90-8BEC-4389-A140-CF645A5D47FE', 'E4C4E846-B85F-4AB5-871B-A8976EE25A69') --  'Pre-K', 1, 1, 0, '004') 
--insert @MAP_GradeLevel values ('6061CD90-8BEC-4389-A140-CF645A5D47FE', 'D90C08C8-683F-4C2B-9D1F-769D904CD060') --  'Pre-K', 1, 1, 0, '004') 
--insert @MAP_GradeLevel values ('7269BD32-C052-455B-B3E3-FF5BCB199679', '10B6907F-2675-4610-983E-B460338569BE') --  '00', 1, 2, 0, '007') 
--insert @MAP_GradeLevel values ('7269BD32-C052-455B-B3E3-FF5BCB199679', 'AA2D13F2-ABFF-4245-8B48-EA13EE264B70') --  '00', 1, 2, 0, '007') 
----insert @MAP_GradeLevel values ('07975B7A-8A1A-47AE-A71F-7ED97BA9D48B', '') --  '01', 1, 4, 2, '010') 
----insert @MAP_GradeLevel values ('DDC4180A-64FC-49BD-AC11-DAA185059885', '') --  '02', 1, 8, 3, '020') 
----insert @MAP_GradeLevel values ('D3C1BD80-0D32-4317-BAB8-CAF196D19350', '') --  '03', 1, 16, 4, '030') 
----insert @MAP_GradeLevel values ('BE4F651A-D5B5-4B05-8237-9FD33E4D2B68', '') --  '04', 1, 32, 5, '040') 
----insert @MAP_GradeLevel values ('5A021B34-D33B-43B5-BD8A-40446AC2E972', '') --  '05', 1, 64, 6, '050') 
----insert @MAP_GradeLevel values ('92B484A3-2DBD-4952-9519-03B848AE1215', '') --  '06', 1, 128, 7, '060') 
----insert @MAP_GradeLevel values ('81FEC824-DB83-4C5D-91A5-2DFE72DE93EC', '') --  '07', 1, 256, 8, '070') 
----insert @MAP_GradeLevel values ('245F48A7-6927-4EFA-A3F2-AF30463C9B4D', '') --  '08', 1, 512, 9, '080') 
----insert @MAP_GradeLevel values ('FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3', '') --  '09', 1, 1024, 10, '090') 
----insert @MAP_GradeLevel values ('8085537C-8EA9-4801-8EC8-A8BDA7E61DB6', '') --  '10', 1, 2048, 11, '100') 
----insert @MAP_GradeLevel values ('EA727CED-8A2C-4434-974A-6D8D924D95C6', '') --  '11', 1, 4096, 12, '110') 
----insert @MAP_GradeLevel values ('0D7B8529-62C7-4F25-B78F-2A4724BD7990', '') --  '12', 1, 8192, 13, '120') 


----10B6907F-2675-4610-983E-B460338569BE	00	1	2	1	NULL	NULL





---- list all tables with FK on GradeLevel and update them 

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



 --delete unneeded
delete g
-- select g.*, t.StateCode
from GradeLevel g join
@MAP_GradeLevel t on g.ID = t.TossID 

commit tran fixgrad

--Rollback tran fixgrad

--select * from GradeLevel order by bitmask