

begin tran FixPrgStatus

set nocount on;

declare @PrgStatus table (ID uniqueidentifier, ProgramID uniqueidentifier, Sequence int, Name varchar(50), IsExit bit, IsEntry bit,  StatusStyleID uniqueidentifier, StateCode varchar(20), Description text)

insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('88C72843-7005-4945-8338-FE15B6C1DDC5','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Reached maximum age for Special Education Service'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','14', 'Reached maximum age for Special Education Service')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('CF29F9AD-AF69-4969-9000-5E851205787F','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Discontinued Schooling / Dropped out'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','09', 'Discontinued Schooling / Dropped out')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('2526C9C9-3079-4A4A-821F-B644355A3919','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Death'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','07', 'Death')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('488748F2-60D7-495C-895F-69C48B310833','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Moved, not known to be continuing'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','11', 'Moved, not known to be continuing')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('0873838E-85FF-4948-A0F8-6DA148FC26C9','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Transfer to another public school within the district'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','02', 'Transfer to another public school within the district')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('D8DF3100-C036-4048-9AE6-AFF6CC1FE415','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Transfer to Home Schooled'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','03', 'Transfer to Home Schooled')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('9B31EA23-A09A-4CB1-A813-CB199A86D5E5','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Transfer to Private School'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','04', 'Transfer to Private School')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('8AFB63A6-A7A0-4E86-809B-610023AA5BD0','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Promotion'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','05', 'Promotion')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('395B51A0-D3EB-46BE-8B02-22326D504B20','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Retained in same grade or demoted to a lower grade'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','12', 'Retained in same grade or demoted to a lower grade')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('4CAADA77-611E-44D8-9006-31DEDA8EF04B','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Certificate of Completion'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','15', 'Certificate of Completion')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('AE339B0C-BB65-4FC6-9E23-75054624D809','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Victim of a Violent Crime'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','16', 'Victim of a Violent Crime')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('539DD468-E2D7-4430-89F8-D25A9F6F69F4','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Change in Serving School or Full Time Equivalent (FTE)'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','17', 'Change in Serving School or Full Time Equivalent (FTE)')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('B53FE183-D52F-4183-867F-74D7C238050D','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Moved Out of the United States'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','18', 'Moved Out of the United States')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('810AF969-7E43-4599-B068-C8A01FE9712B','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Transfer to another public school district out of Illinois'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','19', 'Transfer to another public school district out of Illinois')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('5868C69C-25CC-43DD-BF28-B37A8928DB61','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Transfer to another public school district in Illinois'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','20', 'Transfer to another public school district in Illinois')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('105E844D-7DAA-4590-9628-864D7F04F11D','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Erroneous enrollment'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','99', 'Erroneous enrollment')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('13BE36B4-F53B-40B8-A3BA-AAD7BADF7DE8','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Explusion'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','08', 'Explusion')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('0CED7BBA-32B6-4EAA-8A54-A7FCA9857EAF','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Transfer to GED program'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','10', 'Transfer to GED program')
insert @PrgStatus (ID, ProgramID,Sequence,Name,IsExit,IsEntry, StatusStyleID,StateCode,Description) values ('0154C70A-EF02-4222-ABEE-26347F2A835D','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' ,'99',Convert(varchar(50),'Graduated with regular, advanced, International Baccalaureate, or other type of diploma'),1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6','06', 'Graduated with regular, advanced, International Baccalaureate, or other type of diploma')




--select * from PrgStatus where ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and IsExit = 1 order by  sequence

--update t set Sequence = g.Sequence
--from PrgStatus g left join
--@PrgStatus t on g.StateCode = t.StateCode
--where g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and g.IsExit = 1
--and g.Sequence not between 5 and 9

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

--insert @MAP_PrgStatus (KeepID, TossID) values ('88C72843-7005-4945-8338-FE15B6C1DDC5','')--'Reached maximum age for Special Education Service'
--insert @MAP_PrgStatus (KeepID, TossID) values ('CF29F9AD-AF69-4969-9000-5E851205787F','')--'Discontinued Schooling / Dropped out'
--insert @MAP_PrgStatus (KeepID, TossID) values ('2526C9C9-3079-4A4A-821F-B644355A3919','')--'Death'
--insert @MAP_PrgStatus (KeepID, TossID) values ('488748F2-60D7-495C-895F-69C48B310833','')--'Moved, not known to be continuing'
--insert @MAP_PrgStatus (KeepID, TossID) values ('0873838E-85FF-4948-A0F8-6DA148FC26C9','')--'Transfer to another public school within the district'
--insert @MAP_PrgStatus (KeepID, TossID) values ('D8DF3100-C036-4048-9AE6-AFF6CC1FE415','')--'Transfer to Home Schooled'
--insert @MAP_PrgStatus (KeepID, TossID) values ('9B31EA23-A09A-4CB1-A813-CB199A86D5E5','')--'Transfer to Private School'
--insert @MAP_PrgStatus (KeepID, TossID) values ('8AFB63A6-A7A0-4E86-809B-610023AA5BD0','')--'Promotion'
--insert @MAP_PrgStatus (KeepID, TossID) values ('395B51A0-D3EB-46BE-8B02-22326D504B20','')--'Retained in same grade or demoted to a lower grade'
--insert @MAP_PrgStatus (KeepID, TossID) values ('4CAADA77-611E-44D8-9006-31DEDA8EF04B','')--'Certificate of Completion'
--insert @MAP_PrgStatus (KeepID, TossID) values ('AE339B0C-BB65-4FC6-9E23-75054624D809','')--'Victim of a Violent Crime'
--insert @MAP_PrgStatus (KeepID, TossID) values ('539DD468-E2D7-4430-89F8-D25A9F6F69F4','')--'Change in Serving School or Full Time Equivalent (FTE)'
--insert @MAP_PrgStatus (KeepID, TossID) values ('B53FE183-D52F-4183-867F-74D7C238050D','')--'Moved Out of the United States'
--insert @MAP_PrgStatus (KeepID, TossID) values ('810AF969-7E43-4599-B068-C8A01FE9712B','')--'Transfer to another public school district out of Illinois'
--insert @MAP_PrgStatus (KeepID, TossID) values ('5868C69C-25CC-43DD-BF28-B37A8928DB61','')--'Transfer to another public school district in Illinois'
--insert @MAP_PrgStatus (KeepID, TossID) values ('105E844D-7DAA-4590-9628-864D7F04F11D','')--'Erroneous enrollment'
--insert @MAP_PrgStatus (KeepID, TossID) values ('13BE36B4-F53B-40B8-A3BA-AAD7BADF7DE8','')--'Explusion'
--insert @MAP_PrgStatus (KeepID, TossID) values ('0CED7BBA-32B6-4EAA-8A54-A7FCA9857EAF','')--'Transfer to GED program'
--insert @MAP_PrgStatus (KeepID, TossID) values ('0154C70A-EF02-4222-ABEE-26347F2A835D','')--'Graduated with regular, advanced, International Baccalaureate, or other type of diploma'



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


