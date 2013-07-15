

begin tran FixPrgStatus

set nocount on;

declare @PrgStatus table (ID uniqueidentifier, ProgramID uniqueidentifier, Sequence int, Name varchar(50), IsExit bit, IsEntry bit,  StatusStyleID uniqueidentifier, StateCode varchar(20), Description text)

insert @PrgStatus values ('A21D3B81-13B0-4F58-BAE5-583EBDC60CF2', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Attending alternative educational setting'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '15', 'Attending alternative educational setting')
insert @PrgStatus values ('554D517A-0716-449C-B1AF-BD65CF2A0CA9', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Attending interim alternative educational setting for a maximum of 45 days'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '16', 'Attending interim alternative educational setting for a maximum of 45 days')
insert @PrgStatus values ('B960E06A-FC65-4CB2-AE20-51A231C50F42', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Changed spelling of name; changed fund code; private facility code, etc.'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '20', 'Changed spelling of name; changed fund code; private facility code, etc.')
insert @PrgStatus values ('A3365593-8B7B-4E01-8B07-D2535B54F9D9', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Completed the requirements for a GED'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '13', 'Completed the requirements for a GED')
insert @PrgStatus values ('BF350DF4-724C-4A61-9E33-313A74E64A72', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Deceased'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '05', 'Deceased')
insert @PrgStatus values ('33690948-DC85-4F5D-B1C8-DFD9CAC0A986', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Dropped out'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '04', 'Dropped out')
insert @PrgStatus values ('BB8D53D2-C053-407D-A243-5590BEF158AA', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Expelled; special education services provided in alternative setting'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '19', 'Expelled; special education services provided in alternative setting')
insert @PrgStatus values ('077DBBED-3F7E-49DB-A511-7D1CEC5CFFC8', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Graduated high school through certification of completion/fulfillment'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '02', 'Graduated high school through certification of completion/fulfillment')
insert @PrgStatus values ('9E473D16-9766-4272-B24E-040A128D2DE5', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Graduated high school with diploma'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '01', 'Graduated high school with diploma')
insert @PrgStatus values ('F4524BFB-E539-4693-960B-0012BC9BA6A7', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Moved from an elmentary district to a high school district'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '08', 'Moved from an elmentary district to a high school district')
insert @PrgStatus values ('51A315DB-21CE-49A9-BAD1-161F1F9FFBFB', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Moved out of district; known to be enrolled in another district'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '06', 'Moved out of district; known to be enrolled in another district')
insert @PrgStatus values ('917015F4-0441-432C-9E2A-074404B1297F', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Moved out of district; unknown if enrolled in another district'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '07', 'Moved out of district; unknown if enrolled in another district')
insert @PrgStatus values ('F272CCC1-0FF5-40A2-88F5-8BA5CF24D249', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'No funds available'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '21', 'No funds available')
insert @PrgStatus values ('D9A05D63-A34E-4F07-AB8A-4C4A253594DB', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Placed in a Dept. of Human Services school/Dept. of Corrections facility'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '11', 'Placed in a Dept. of Human Services school/Dept. of Corrections facility')
insert @PrgStatus values ('B2598B05-5A5F-4D0E-89B1-FB9794F95E60', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Prevent Fund Code'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '22', 'Prevent Fund Code')
insert @PrgStatus values ('8D8D4921-1C79-40CA-8C58-EBB5216DE113', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Ran away'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '14', 'Ran away')
insert @PrgStatus values ('2074C6EE-E7BF-46D1-A828-2BF5ADA8CB6E', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Reached maximum age for Special Education Service'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '03', 'Reached maximum age for Special Education Service')
insert @PrgStatus values ('58324909-6FDA-4BF9-9C9D-7913EE84237F', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Refused service'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '12', 'Refused service')
insert @PrgStatus values ('1F6E7B32-F9D6-4EA0-9CFB-C6F36B0A80D4', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Returned to regular education program full-time'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '09', 'Returned to regular education program full-time')
insert @PrgStatus values ('096DB772-E8B4-428C-99D5-9A908B52BEE8', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Suspended for 10 or fewer days'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '17', 'Suspended for 10 or fewer days')
insert @PrgStatus values ('9490767C-3328-40CC-A9B0-E9CB367AA1D3', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Suspended for more than 10 days during the school year & services provided'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '18', 'Suspended for more than 10 days during the school year & services provided')
insert @PrgStatus values ('F6A00942-5E8E-4AA0-9C9B-7AC9DD6547C9', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' , 99, convert(varchar(50), 'Withdrawn by parent/guardian from public school program'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '10', 'Withdrawn by parent/guardian from public school program')

--select * from @PrgStatus



--select * from PrgStatus where ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and IsExit = 1 order by  sequence

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
--	select SchemaName = 'dbo', TableName = 'PrgItemOutcome',  ColumnName = 'NextStatusID'
--	union all
--	select SchemaName = 'dbo', TableName = 'PrgItemRelDef', ColumnName = 'InitiatingItemOutcomeId'
--	union all
--	SELECT 
--		SCHEMA_NAME(f.SCHEMA_ID),
--		OBJECT_NAME(f.parent_object_id),
--		COL_NAME(fc.parent_object_id,fc.parent_column_id) 
--	FROM sys.foreign_keys AS f
--		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
--		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
--	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
--		and OBJECT_NAME (f.referenced_object_id) = 'PrgStatus' ------------------------- Table name here
--		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID' --------------- Column name here
---- totally cheating for now

--	open R
--	fetch R into @relschema, @RelTable, @relcolumn

--	while @@fetch_status = 0
--	begin

-- 	exec ('delete x from dbo.PrgStatus x left join '+@RelTable+' r on x.ID = r.'+@RelColumn+' where x.ID = '''+@toss+''' and x.Sequence not between 5 and 9 and r.'+@RelColumn+' is null')

----print 'delete x from dbo.PrgStatus x left join '+@RelTable+' r on x.ID = r.'+@RelColumn+' where x.ID = '''+@toss+''' and r.'+@RelColumn+' is null'

--	fetch R into @relschema, @RelTable, @relcolumn
--	end
--	close R
--	deallocate R

--fetch T into @toss
--end
--close T
--deallocate T


--print 'delete x from dbo.PrgStatus x left join '+@RelTable+' r on x.ID = r.'+@RelColumn+' where x.ID = '''+@toss+''' and x.Sequence not between 5 and 9 and r.'+@RelColumn+' is null'

--select x.* 
--	--, r.*
--from dbo.PrgStatus x left join 
--	PrgItemRelDef r on x.ID = r.InitiatingItemOutcomeId 
--where x.ID = '24827AAC-3DE7-432D-A15B-00BE41BF8BDF' 
--	and r.InitiatingItemOutcomeId is null
--and x.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and x.IsExit = 1



-- insert missing.  This has to be done before updating the records to be deleted and before deleting.
insert PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry,StatusStyleID ,StateCode, Description)
select t.ID, t.ProgramID, t.Sequence, t.Name, t.IsExit, t.IsEntry,t.StatusStyleID,  t.StateCode, t.Description
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

insert @MAP_PrgStatus (KeepID, TossID) values ('A21D3B81-13B0-4F58-BAE5-583EBDC60CF2','8D71D1F5-D5B2-4FFF-AAE0-D034559BA7F3')--'Attending alternative educational setting'
insert @MAP_PrgStatus (KeepID, TossID) values ('554D517A-0716-449C-B1AF-BD65CF2A0CA9','2C149C94-B2D7-4AB3-A8AA-EFB46D5880CF')--'Attending interim alternative educational setting for a maximum of 45 days'
insert @MAP_PrgStatus (KeepID, TossID) values ('B960E06A-FC65-4CB2-AE20-51A231C50F42','9FDED9AC-27E8-4CD6-AB5A-F134BBD9252A')--'Changed spelling of name; changed fund code; private facility code, etc.'
insert @MAP_PrgStatus (KeepID, TossID) values ('A3365593-8B7B-4E01-8B07-D2535B54F9D9','FD6AFB7A-EA40-4D16-826C-756E6DB18DCE')--'Completed the requirements for a GED'
insert @MAP_PrgStatus (KeepID, TossID) values ('BF350DF4-724C-4A61-9E33-313A74E64A72','3E04C2F9-7593-4681-AA15-F2341BF63FA3')--'Deceased'
insert @MAP_PrgStatus (KeepID, TossID) values ('33690948-DC85-4F5D-B1C8-DFD9CAC0A986','CF29F9AD-AF69-4969-9000-5E851205787F')--'Dropped out'
insert @MAP_PrgStatus (KeepID, TossID) values ('BB8D53D2-C053-407D-A243-5590BEF158AA','911D33C5-A6B9-4BCD-84F8-763FD24C2B92')--'Expelled; special education services provided in alternative setting'
insert @MAP_PrgStatus (KeepID, TossID) values ('077DBBED-3F7E-49DB-A511-7D1CEC5CFFC8','6403B747-B28A-4761-85B4-F873B4D5B86F')--'Graduated high school through certification of completion/fulfillment'
insert @MAP_PrgStatus (KeepID, TossID) values ('9E473D16-9766-4272-B24E-040A128D2DE5','1BA393D0-CF00-466D-A6B6-286B140B31B1')--'Graduated high school with diploma'
insert @MAP_PrgStatus (KeepID, TossID) values ('F4524BFB-E539-4693-960B-0012BC9BA6A7','25E9107E-7F7B-493D-94B3-C2DA0496D3A4')--'Moved from an elmentary district to a high school district'
insert @MAP_PrgStatus (KeepID, TossID) values ('51A315DB-21CE-49A9-BAD1-161F1F9FFBFB','FD37559E-96AC-435B-8715-BF48DB5EF7DA')--'Moved out of district; known to be enrolled in another district'
insert @MAP_PrgStatus (KeepID, TossID) values ('917015F4-0441-432C-9E2A-074404B1297F','D76E5983-3E2E-4AEF-9E33-51E3386B3479')--'Moved out of district; unknown if enrolled in another district'
--insert @MAP_PrgStatus (KeepID, TossID) values ('F272CCC1-0FF5-40A2-88F5-8BA5CF24D249','')--'No funds available'
insert @MAP_PrgStatus (KeepID, TossID) values ('D9A05D63-A34E-4F07-AB8A-4C4A253594DB','4FACF717-C278-4A68-BCD2-B68D894BDE0B')--'Placed in a Dept. of Human Services school/Dept. of Corrections facility'
--insert @MAP_PrgStatus (KeepID, TossID) values ('B2598B05-5A5F-4D0E-89B1-FB9794F95E60','')--'Prevent Fund Code'
insert @MAP_PrgStatus (KeepID, TossID) values ('8D8D4921-1C79-40CA-8C58-EBB5216DE113','C0EB4D65-6758-4809-9486-80087D146C05')--'Ran away'
insert @MAP_PrgStatus (KeepID, TossID) values ('2074C6EE-E7BF-46D1-A828-2BF5ADA8CB6E','88C72843-7005-4945-8338-FE15B6C1DDC5')--'Reached maximum age for Special Education Service'
--insert @MAP_PrgStatus (KeepID, TossID) values ('58324909-6FDA-4BF9-9C9D-7913EE84237F','')--'Refused service'
insert @MAP_PrgStatus (KeepID, TossID) values ('1F6E7B32-F9D6-4EA0-9CFB-C6F36B0A80D4','C614D725-C984-4E21-BC38-DB8F46713C2D')--'Returned to regular education program full-time'
insert @MAP_PrgStatus (KeepID, TossID) values ('096DB772-E8B4-428C-99D5-9A908B52BEE8','C9C03BA5-A4B4-4E58-AC56-738D38F106A1')--'Suspended for 10 or fewer days'
insert @MAP_PrgStatus (KeepID, TossID) values ('9490767C-3328-40CC-A9B0-E9CB367AA1D3','5014D6B6-98EC-4595-89F1-DD6B3BE3E241')--'Suspended for more than 10 days during the school year & services provided'
insert @MAP_PrgStatus (KeepID, TossID) values ('F6A00942-5E8E-4AA0-9C9B-7AC9DD6547C9','A5EC93AB-45CB-477F-ABC2-70C20AA39F74')--'Withdrawn by parent/guardian from public school program'



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
from PrgStatus x join
@MAP_PrgStatus t on x.ID = t.TossID 

--Msg 547, Level 16, State 0, Line 205
--The DELETE statement conflicted with the REFERENCE constraint "FK_PrgItemRelDef#InitiatingItemOutcome#ResultingItemDefs". The conflict occurred in database "Enrich_DCB6_CO_UtePassBOCES", table "dbo.PrgItemRelDef", column 'InitiatingItemOutcomeId'.


--delete g
--from PrgStatus g left join
--@PrgStatus t on g.ID = t.ID 
--where t.ID is null
--and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and g.IsExit = 1
--and g.Sequence not between 5 and 9
--select * from  PrgStatus order by Name


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


