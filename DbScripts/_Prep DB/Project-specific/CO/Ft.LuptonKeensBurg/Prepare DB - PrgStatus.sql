
set nocount on;

declare @PrgStatus table (ID uniqueidentifier, ProgramID uniqueidentifier, Sequence int, Name varchar(50), IsExit bit, IsEntry bit,  StatusStyleID uniqueidentifier, StateCode varchar(20), Description text)

insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('BF898F66-AD71-451F-AD11-3639155A431F', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Reached Maximum Age For Services'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '01', 'Reached Maximum Age For Services')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('4878A47C-1AAA-4697-BE30-42106F214E7D', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Death'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '02', 'Death')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('C425DBDE-4DBD-4A9D-B1F5-6C3D99262AFD', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'PK-6 Student Exited, not known to continue'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '06', 'PK-6 Student Exited, not known to continue')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('C2DF5F3F-D0EE-4493-BBA7-6D8327EA36D8', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transferred to Regular Education'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '09', 'Transferred to Regular Education')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('8DCBA0CA-9560-4E3A-88AB-805FD659C9C2', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transfer to a Public School in a Different District, known to continue'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '13', 'Transfer to a Public School in a Different District, known to continue')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('05F914D8-2A29-489A-82ED-A7506341A83F', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transfer to a School in a Different State/Country'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '14', 'Transfer to a School in a Different State/Country')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('DFBE9247-8EBC-447B-87C2-A8FAEB37A96D', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transfer to a Non-Public School'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '15', 'Transfer to a Non-Public School')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('3C35632F-8323-4CB7-8585-B7D3D4586152', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transfer to Home-Based Education'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '16', 'Transfer to Home-Based Education')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('2D966F92-A821-47EF-B785-DE1E32C84C3A', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transfer to a Career and Technical Education Program (Non-CO district or BOCES operated)'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '18', 'Transfer to a Career and Technical Education Program (Non-CO district or BOCES operated)')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('BB19EFF0-AF1F-4F8A-A8F2-EC11F2A56711', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transfer to a Facility Operated by CO Dept of Youth Corrections'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '21', 'Transfer to a Facility Operated by CO Dept of Youth Corrections')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('E8959582-644B-4AAC-B3FF-0580B1BE158F', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Discontinued Schooling / Dropped out'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '40', 'Discontinued Schooling / Dropped out')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('59BBBBE9-BF7C-44E0-B9FB-0E376A26E0B8', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Explusion'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '50', 'Explusion')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('A24AEA49-735D-425F-B803-168769054306', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Parent Revokes Consent for Services'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '60', 'Parent Revokes Consent for Services')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('825305B4-0600-4098-8B17-381499942419', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'GED Transfer'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '70', 'GED Transfer')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('3A7DEAC1-7A66-42D6-B452-3A0529DA133D', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Graduated with a Regular Deploma'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '90', 'Graduated with a Regular Deploma')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('2477C14E-7939-46D6-99E4-43F6E35701A4', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Completed (non-diploma certificate)'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '92', 'Completed (non-diploma certificate)')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('977D0FE7-B5EA-4656-B193-5B0BF784EDCC', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'General Education Development Certificate (GED)'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '93', 'General Education Development Certificate (GED)')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('E6DB43DE-03DF-4C27-A61B-6B1277102B73', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Student received GED certificate at Non-District Program same year of transfer.'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '94', 'Student received GED certificate at Non-District Program same year of transfer.')

--select * from PrgStatus order by name --33

update t set Sequence = g.Sequence
from PrgStatus g left join
@PrgStatus t on g.StateCode = t.StateCode
where g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and g.IsExit = 1
and g.Sequence not between 5 and 9

---- insert test
select t.ID, t.ProgramID, t.Sequence, t.Name, t.IsExit, t.IsEntry, t.StatusStyleID, t.StateCode, t.Description
from PrgStatus g right join
@PrgStatus t on g.ID = t.ID and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C'
where g.ID is null
order by t.Sequence, t.stateCode, t.Name

---- delete test
select g.*
from PrgStatus g left join
@PrgStatus t on g.ID = t.ID 
where t.ID is null and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and g.IsExit = 1
and g.Sequence not between 5 and 9
order by g.DeletedDate desc, g.Sequence, g.stateCode, g.Name


begin tran FixPrgStatus

declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50), @toss varchar(50);

--/* ============================================================================= NOTE ============================================================================= 

--	This cursor is to delete as many values as possible without having to MAP them visually below in order to save time and effort that would be required to 
--	match them by sight.

--   ============================================================================= NOTE ============================================================================= */

--declare T cursor for 
--select x.ID
--from PrgStatus x left join
--@PrgStatus t on x.ID = t.ID 
--where t.ID is null 

--open T
--fetch T into @toss

--while @@fetch_status = 0

--begin

--	declare R cursor for 
--	SELECT 
--		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
--		OBJECT_NAME(f.parent_object_id) AS TableName,
--		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
--	FROM sys.foreign_keys AS f
--		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
--		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
--	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
--		and OBJECT_NAME (f.referenced_object_id) = 'PrgStatus' ------------------------- Table name here
--		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID' --------------- Column name here
--	order by SchemaName, TableName, ColumnName

--	open R
--	fetch R into @relschema, @RelTable, @relcolumn

--	while @@fetch_status = 0
--	begin

-- 	exec ('delete x from dbo.PrgStatus x left join '+@RelTable+' r on x.ID = r.'+@RelColumn+' where x.ID = '''+@toss+''' and r.'+@RelColumn+' is null')

---- print 

--	fetch R into @relschema, @RelTable, @relcolumn
--	end
--	close R
--	deallocate R

--fetch T into @toss
--end
--close T
--deallocate T


-- insert missing.  This has to be done before updating the records to be deleted and before deleting.
insert PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description)
select t.ID, t.ProgramID, t.Sequence, t.Name, t.IsExit, t.IsEntry, t.StatusStyleID, t.StateCode, t.Description
from PrgStatus g right join
@PrgStatus t on g.ID = t.ID and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C'
where g.ID is null
order by g.DeletedDate desc, g.Sequence, g.stateCode, g.Name




------ delete test -------------------------------------------------------- If there remain no values to be updated, the following query will return 0 rows.  
select g.*
from PrgStatus g left join
@PrgStatus t on g.ID = t.ID 
where t.ID is null and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and g.IsExit = 1
and g.Sequence not between 5 and 9
order by g.DeletedDate desc, g.Sequence, g.stateCode, g.Name





--/* ============================================================================= NOTE ============================================================================= 

--	It is expected that the ID values in the rows below for Autism, Hearing Impairment, Preschooler with a Disability, Serious Emotional and Vision Impairment
--	will need to be updated for all hosted districts in Coloardo.  
	
--	HOWEVER
	
--	it is very important to verify that these are the only values need to be updated / deleted.  Please use the     "delete test"    query above to verify.

--   ============================================================================= NOTE ============================================================================= */

declare @MAP_PrgStatus table (KeepID uniqueidentifier, TossID uniqueidentifier)

insert @MAP_PrgStatus (KeepID, TossID) values ('BF898F66-AD71-451F-AD11-3639155A431F', '6EB49F85-5662-46B3-AD08-903DFBE6D090') -- 'Reached Maximum Age For Services')
insert @MAP_PrgStatus (KeepID, TossID) values ('4878A47C-1AAA-4697-BE30-42106F214E7D', '0C105E02-5FC2-49E0-9B8F-7BA0D0D196E8') -- 'Death')
insert @MAP_PrgStatus (KeepID, TossID) values ('C425DBDE-4DBD-4A9D-B1F5-6C3D99262AFD', '4C809168-6D25-4B48-A9EA-0C1C9CB49D39') -- 'PK-6 Student Exited, not known to continue')
insert @MAP_PrgStatus (KeepID, TossID) values ('C2DF5F3F-D0EE-4493-BBA7-6D8327EA36D8', '25F39C6E-DBA1-4499-BEE4-D5EF87588CE0') -- 'Transferred to Regular Education')
--insert @MAP_PrgStatus (KeepID, TossID) values ('8DCBA0CA-9560-4E3A-88AB-805FD659C9C2', '') -- 'Transfer to a Public School in a Different District, known to continue')
insert @MAP_PrgStatus (KeepID, TossID) values ('05F914D8-2A29-489A-82ED-A7506341A83F', '9CA7F697-301B-48C5-A3E8-C776F77C362F') -- 'Transfer to a School in a Different State/Country')
insert @MAP_PrgStatus (KeepID, TossID) values ('DFBE9247-8EBC-447B-87C2-A8FAEB37A96D', 'F0AA3505-42FB-490A-AB24-9CA239978BC1') -- 'Transfer to a Non-Public School')
insert @MAP_PrgStatus (KeepID, TossID) values ('3C35632F-8323-4CB7-8585-B7D3D4586152', 'BAC31361-D952-4416-8463-98D79881AF69') -- 'Transfer to Home-Based Education')
insert @MAP_PrgStatus (KeepID, TossID) values ('2D966F92-A821-47EF-B785-DE1E32C84C3A', '5951577A-7192-42AE-B1BD-385628B14369') -- 'Transfer to a Career and Technical Education Program (Non-CO district or BOCES operated)')
insert @MAP_PrgStatus (KeepID, TossID) values ('BB19EFF0-AF1F-4F8A-A8F2-EC11F2A56711', '338F2F0A-A8FF-47C4-AF04-423D6094243A') -- 'Transfer to a Facility Operated by CO Dept of Youth Corrections')
insert @MAP_PrgStatus (KeepID, TossID) values ('E8959582-644B-4AAC-B3FF-0580B1BE158F', '979F387E-8AE3-473E-9854-2649A82B15F0') -- 'Discontinued Schooling / Dropped out')
insert @MAP_PrgStatus (KeepID, TossID) values ('59BBBBE9-BF7C-44E0-B9FB-0E376A26E0B8', '7F95788C-4317-4450-9540-3C14A7316E3B') -- 'Explusion')
insert @MAP_PrgStatus (KeepID, TossID) values ('A24AEA49-735D-425F-B803-168769054306', 'B92F951E-5C89-476D-9B16-E8F89A1DD120') -- 'Parent Revokes Consent for Services')
insert @MAP_PrgStatus (KeepID, TossID) values ('825305B4-0600-4098-8B17-381499942419', 'AA9CE34B-71BC-440A-B29F-1E3613A8919E') -- 'GED Transfer')
----insert @MAP_PrgStatus (KeepID, TossID) values ('3A7DEAC1-7A66-42D6-B452-3A0529DA133D', '') -- 'Graduated with a Regular Deploma')
----insert @MAP_PrgStatus (KeepID, TossID) values ('2477C14E-7939-46D6-99E4-43F6E35701A4', '') -- 'Completed (non-diploma certificate)')
----insert @MAP_PrgStatus (KeepID, TossID) values ('977D0FE7-B5EA-4656-B193-5B0BF784EDCC', '') -- 'General Education Development Certificate (GED)')
insert @MAP_PrgStatus (KeepID, TossID) values ('E6DB43DE-03DF-4C27-A61B-6B1277102B73', '15D33468-D8A9-4E96-800A-AEAEE92A8025') -- 'Student received GED certificate at Non-District Program same year of transfer.')


declare I cursor for 
select KeepID, TossID from @MAP_PrgStatus 

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
		and OBJECT_NAME (f.referenced_object_id) = 'PrgStatus' ------------------------- Table name here
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

-- delete unneeded
delete x
-- select g.*, t.StateCode
from PrgStatus x  join
@MAP_PrgStatus t on x.ID = t.TossID 

--delete g
--from PrgStatus g left join
--@PrgStatus t on g.ID = t.ID 
--where t.ID is null
--and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and g.IsExit = 1
--and g.Sequence not between 5 and 9



commit tran FixPrgStatus
-- rollback tran FixPrgStatus

/*
-- delete unneeded values
delete g
-- select g.*, t.StateCode
from PrgStatus g left join
@PrgStatus t on g.ID = t.ID 
where t.ID is null
and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and g.IsExit = 1
and g.Sequence not between 5 and 9

--Msg 547, Level 16, State 0, Line 55
--The DELETE statement conflicted with the REFERENCE constraint "FK_PrgItemOutcome#NextStatus#ItemOutcomes". The conflict occurred in database "Enrich_DCB7_CO_DYC", table "dbo.PrgItemOutcome", column 'NextStatusID'.

select * from PrgItemOutcome


*/


