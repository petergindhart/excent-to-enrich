

set nocount on;
-- this needs to be run on the CDE Sandbox template for CO instanaces as well as on all CO import databases
declare @PrgLocation table (ID uniqueidentifier, Name varchar(50), Definition text, DeterminationFormTemplateID uniqueidentifier, StateCode varchar(20), DeletedDate datetime)

insert @PrgLocation  (ID, Name) values ('27D86DFE-218E-4E1B-A6DB-8B8E74D6F8BA', 'General Education Classroom')
insert @PrgLocation  (ID, Name) values ('B21973A7-5A68-4D9A-B93D-18B0335D7257', 'Outside General Classroom')

--select * from PrgLocation
--select * from @PrgLocation

---- insert test
select t.ID, t.Name, t.Definition, t.DeterminationFormTemplateID, t.StateCode
from PrgLocation x right join
@PrgLocation t on x.ID = t.ID 
where x.ID is null order by x.Name

---- delete test
select x.*, t.StateCode
from PrgLocation x left join
@PrgLocation t on x.ID = t.ID 
where t.ID is null order by x.Name


declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50), @toss varchar(50);

begin tran FixLocation

---- delete test -------------------------------------------------------- If there remain no values to be updated, the following query will return 0 rows.  
---- In this case the section "populate MAP" can be skipped
--select x.*, t.StateCode
--from PrgLocation x left join
--@PrgLocation t on x.ID = t.ID 
--where t.ID is null order by x.Name

-- update state code
update x set StateCode = t.StateCode
-- select g.*, t.StateCode
from PrgLocation x left join
@PrgLocation t on x.ID = t.ID 

-- insert missing.  This has to be done before updating the records to be deleted and before deleting.
insert PrgLocation (ID, Name) 
select t.ID, t.Name
from PrgLocation x right join
@PrgLocation t on x.ID = t.ID 
where x.ID is null
order by x.Name


/* ============================================================================= NOTE ============================================================================= 

	It is expected that the ID values in the rows below for Autism, Hearing Impairment, Preschooler with a Disability, Serious Emotional and Vision Impairment
	will need to be updated for all hosted districts in Coloardo.  
	
	HOWEVER
	
	it is very important to verify that these are the only values need to be updated / deleted.  Please use the     "delete test"    query above to verify.

   ============================================================================= NOTE ============================================================================= */

-- populate MAP
-- this needs to be done by visual inspection because PrgLocation names can vary widely
declare @MAP_PrgLocation table (KeepID uniqueidentifier, TossID uniqueidentifier)

--insert @MAP_PrgLocation values ('27D86DFE-218E-4E1B-A6DB-8B8E74D6F8BA', '') -- 'General Education Classroom')
insert @MAP_PrgLocation values ('B21973A7-5A68-4D9A-B93D-18B0335D7257', '6102B96C-1549-4C65-AD59-683FF00639BA') -- 'Outside General Classroom')
-- 6102B96C-1549-4C65-AD59-683FF00639BA	Outside General Classroom

declare I cursor for 
select KeepID, TossID from @MAP_PrgLocation 

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
		and OBJECT_NAME (f.referenced_object_id) = 'PrgLocation' ------------------------- Table name here
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
from PrgLocation x join
@MAP_PrgLocation t on x.ID = t.TossID 

commit tran FixLocation


------ insert test (should return no rows)
--select t.ID, t.Name, t.Definition, t.DeterminationFormTemplateID, t.StateCode
--from PrgLocation x right join
--@PrgLocation t on x.ID = t.ID 
--where x.ID is null order by x.Name

------ delete test (should return no rows)
--select x.*, t.StateCode
--from PrgLocation x left join
--@PrgLocation t on x.ID = t.ID 
--where t.ID is null order by x.Name

-- View the final result.  Compare to the SelectLists template 
-- select * from PrgLocation d order by d.Name



