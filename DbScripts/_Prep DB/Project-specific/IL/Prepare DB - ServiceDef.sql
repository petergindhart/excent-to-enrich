
Begin tran fixservdef

set nocount on;

declare @ServiceDef table (ID uniqueidentifier, CategoryID uniqueidentifier, Name varchar(100), Description text, DefaultLocationID uniqueidentifier, MinutesPerUnit int) 

insert @ServiceDef (ID, CategoryID, Name) values ('76C23361-F9E0-4BBB-9CFA-2F6C23170EF7','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Academic Program Only')
insert @ServiceDef (ID, CategoryID, Name) values ('FFC6DBBC-C509-4AE8-89D1-AF1BA52EA45C','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Acquisition of Daily Living Skills')
insert @ServiceDef (ID, CategoryID, Name) values ('E82106FB-28EF-4507-915B-D8E9F7D07CCC','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Adapted Driver Education')
insert @ServiceDef (ID, CategoryID, Name) values ('C4EACCE2-B4ED-4456-8482-5A32E6DC898C','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Adapted Physical Education')
insert @ServiceDef (ID, CategoryID, Name) values ('84F08D2A-1273-41F2-A018-A781B199C66B','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Aide-Class')
insert @ServiceDef (ID, CategoryID, Name) values ('094FFD46-BC6E-40EE-852B-6CE5023CCB54','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Aide-Individual Student')
insert @ServiceDef (ID, CategoryID, Name) values ('D2DE1380-17A1-4896-B609-7B733B93C2F4','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Art Therapy')
insert @ServiceDef (ID, CategoryID, Name) values ('1BD44FD5-B553-4F35-A59E-F4873F33833A','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Assistive Device')
insert @ServiceDef (ID, CategoryID, Name) values ('1CE6205D-EA3D-4B62-98EF-AFFE01E8EFB1','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Audiology')
insert @ServiceDef (ID, CategoryID, Name) values ('46DE2328-F85E-43CD-9EF2-322D6513AB72','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Behavioral Intervention Plan')
insert @ServiceDef (ID, CategoryID, Name) values ('7DEEDF7D-E024-4112-809F-AFEA266A4D73','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Braillist/Reader')
insert @ServiceDef (ID, CategoryID, Name) values ('36DD09DD-16DF-4762-ABE3-FD5D56E24B31','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Career and Technical Education')
insert @ServiceDef (ID, CategoryID, Name) values ('1B181ABD-4B48-45EA-A53E-C6458B5F554E','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Competetive Employment')
insert @ServiceDef (ID, CategoryID, Name) values ('F00AEC99-8AA5-4ED5-8051-63A9471F1DFE','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Consultant Services')
insert @ServiceDef (ID, CategoryID, Name) values ('FFCF41E6-E085-477E-A720-B466DDE53952','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Counseling Services')
insert @ServiceDef (ID, CategoryID, Name) values ('8FC14A48-AFC9-4F04-AB0A-4E0C515268F5','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Orientation and Mobility')
insert @ServiceDef (ID, CategoryID, Name) values ('5B371197-4356-49E0-99AE-7EB7DC166506','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Other Related Services')
insert @ServiceDef (ID, CategoryID, Name) values ('568B04D7-A82F-4533-A2E8-29969F2C2738','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Outdoor Education')
insert @ServiceDef (ID, CategoryID, Name) values ('624FC352-5B2C-45FB-86FB-14104D0BC109','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Parent Counseling')
insert @ServiceDef (ID, CategoryID, Name) values ('F67F72EA-6B1B-4B02-8878-7029A4FCF264','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Physical Therapy')
insert @ServiceDef (ID, CategoryID, Name) values ('5FAE3593-251E-4544-A570-B906B1BAFDED','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Psychiatric Services')
insert @ServiceDef (ID, CategoryID, Name) values ('FC64E35D-91EF-4B9D-BF10-74609018FB90','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Psychological Services')
insert @ServiceDef (ID, CategoryID, Name) values ('52C11455-D27B-466E-84B1-2C4DC823D768','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Recreation')
insert @ServiceDef (ID, CategoryID, Name) values ('55311FCC-C14B-46E9-B3BD-6AA1B3723074','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','School Health Services')
insert @ServiceDef (ID, CategoryID, Name) values ('6050FA45-ABF8-4179-90E9-09E0DA602B95','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Social Work Services')
insert @ServiceDef (ID, CategoryID, Name) values ('6517DE48-5B6A-4628-93CA-426487EDC178','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Speech/Language Related Services')
insert @ServiceDef (ID, CategoryID, Name) values ('AC2C659A-F8C3-47DC-BBC0-69C784A3C28A','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Supported Employment')
insert @ServiceDef (ID, CategoryID, Name) values ('8A9946E8-F7ED-43EB-B0B7-262D33578CA1','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Supports for Transition to Post-Secondary Education')
insert @ServiceDef (ID, CategoryID, Name) values ('D9A3625C-9913-4DE9-9F66-70A12FE39D84','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Transition/STEP by Division of Rehabilitation Services')
insert @ServiceDef (ID, CategoryID, Name) values ('3BB59E9F-462A-4A73-AAA0-6238DB518D53','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Transportation (Special)')
insert @ServiceDef (ID, CategoryID, Name) values ('6AEAC101-C396-4926-8423-C810EB226C12','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Travel Training')
insert @ServiceDef (ID, CategoryID, Name) values ('9CED8FD3-33E4-48B9-9805-ADB839C75BCB','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Vision Itinerant Service')
insert @ServiceDef (ID, CategoryID, Name) values ('4779B5FA-4D9E-4ED4-A4C2-0DC12CA37166','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Vision Screening Related')
insert @ServiceDef (ID, CategoryID, Name) values ('68D0E99D-B81E-4EF9-BE17-331BD6F94570','4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7','Direct Instruction Math')
insert @ServiceDef (ID, CategoryID, Name) values ('54EA1D2A-EF1C-40C9-9276-425C675ED4DF','4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7','Direct Instruction Math/Reading')
insert @ServiceDef (ID, CategoryID, Name) values ('6ECF44DF-FA82-430B-82D7-7C0AD7E1443B','4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7','Orientation and Mobility')
insert @ServiceDef (ID, CategoryID, Name) values ('5FACFB25-6651-4C09-8770-1BFFFFD719FE','4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7','Resource')
insert @ServiceDef (ID, CategoryID, Name) values ('6E077483-6E86-4789-9E44-A331E9555F9F','4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7','Speech/Language Services')
insert @ServiceDef (ID, CategoryID, Name) values ('82953DE8-5608-4723-A85F-3B0A1BD4FAC5','4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7','Vision Screening')
insert @ServiceDef (ID, CategoryID, Name) values ('3F3CE74E-B435-4227-85ED-32463D4C9F1C','4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7','Visually Impaired')



update x set Description = sd.Description, DefaultLocationID = sd.DefaultLocationID, MinutesPerUnit = sd.MinutesPerUnit
from @ServiceDef x join 
ServiceDef sd on x.Name = sd.Name

--select * from @ServiceDef order by Name

--select * from ServiceDef order by Name
--select ID, 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', Name from @ServiceDef order by Name

---- insert test
select t.ID, TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', t.Name, t.Description, t.DefaultLocationID, t.MinutesPerUnit
from ServiceDef x right join
@ServiceDef t on x.ID = t.ID 
where x.ID is null order by x.Name

------ delete test		-- we will not be deleting services that were entered manually by the customer.
select x.*
from ServiceDef x join
@ServiceDef t on x.Name = t.Name left join
@ServiceDef d on x.ID = d.ID 
where d.ID is null
order by x.Name

-- update test - deleted date
select sd.*
-- update sd set DeletedDate = GETDATE()
from ServiceDef sd left join
@ServiceDef t on sd.ID = t.ID 
where t.ID is null



insert ServiceDef (ID, TypeID, Name, Description, DefaultLocationID, MinutesPerUnit,UserDefined)
select t.ID, TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', t.Name, t.Description, t.DefaultLocationID, t.MinutesPerUnit,0
from ServiceDef x right join
@ServiceDef t on x.ID = t.ID 
where x.ID is null order by x.Name



--------------------------------------------------------------------------------------------------------------------------------------------------------------------


declare @MAP_ServiceDef table (KeepID uniqueidentifier, TossID uniqueidentifier)


/* ============================================================================= NOTE ============================================================================= 

	It is expected that the ID values in the rows below for Autism, Hearing Impairment, Preschooler with a Disability, Serious Emotional and Vision Impairment
	will need to be updated for all hosted districts in Coloardo.  
	
	HOWEVER
	
	it is very important to verify that these are the only values need to be updated / deleted.  Please use the     "delete test"    query above to verify.

   ============================================================================= NOTE ============================================================================= */


declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50), @toss varchar(50);
-- populate MAP
-- this needs to be done by visual inspection because IepDisability names can vary widely
--insert @MAP_ServiceDef values ('76C23361-F9E0-4BBB-9CFA-2F6C23170EF7','')--'Academic Program Only'
--insert @MAP_ServiceDef values ('FFC6DBBC-C509-4AE8-89D1-AF1BA52EA45C','')--'Acquisition of Daily Living Skills'
--insert @MAP_ServiceDef values ('E82106FB-28EF-4507-915B-D8E9F7D07CCC','')--'Adapted Driver Education'
--insert @MAP_ServiceDef values ('C4EACCE2-B4ED-4456-8482-5A32E6DC898C','')--'Adapted Physical Education'
--insert @MAP_ServiceDef values ('84F08D2A-1273-41F2-A018-A781B199C66B','')--'Aide-Class'
--insert @MAP_ServiceDef values ('094FFD46-BC6E-40EE-852B-6CE5023CCB54','')--'Aide-Individual Student'
--insert @MAP_ServiceDef values ('D2DE1380-17A1-4896-B609-7B733B93C2F4','')--'Art Therapy'
--insert @MAP_ServiceDef values ('1BD44FD5-B553-4F35-A59E-F4873F33833A','')--'Assistive Device'
--insert @MAP_ServiceDef values ('1CE6205D-EA3D-4B62-98EF-AFFE01E8EFB1','')--'Audiology'
--insert @MAP_ServiceDef values ('46DE2328-F85E-43CD-9EF2-322D6513AB72','')--'Behavioral Intervention Plan'
--insert @MAP_ServiceDef values ('7DEEDF7D-E024-4112-809F-AFEA266A4D73','')--'Braillist/Reader'
--insert @MAP_ServiceDef values ('36DD09DD-16DF-4762-ABE3-FD5D56E24B31','')--'Career and Technical Education'
--insert @MAP_ServiceDef values ('1B181ABD-4B48-45EA-A53E-C6458B5F554E','')--'Competetive Employment'
--insert @MAP_ServiceDef values ('F00AEC99-8AA5-4ED5-8051-63A9471F1DFE','')--'Consultant Services'
--insert @MAP_ServiceDef values ('FFCF41E6-E085-477E-A720-B466DDE53952','')--'Counseling Services'
--insert @MAP_ServiceDef values ('8FC14A48-AFC9-4F04-AB0A-4E0C515268F5','')--'Orientation and Mobility'
--insert @MAP_ServiceDef values ('5B371197-4356-49E0-99AE-7EB7DC166506','')--'Other Related Services'
--insert @MAP_ServiceDef values ('568B04D7-A82F-4533-A2E8-29969F2C2738','')--'Outdoor Education'
--insert @MAP_ServiceDef values ('624FC352-5B2C-45FB-86FB-14104D0BC109','')--'Parent Counseling'
--insert @MAP_ServiceDef values ('F67F72EA-6B1B-4B02-8878-7029A4FCF264','')--'Physical Therapy'
--insert @MAP_ServiceDef values ('5FAE3593-251E-4544-A570-B906B1BAFDED','')--'Psychiatric Services'
--insert @MAP_ServiceDef values ('FC64E35D-91EF-4B9D-BF10-74609018FB90','')--'Psychological Services'
--insert @MAP_ServiceDef values ('52C11455-D27B-466E-84B1-2C4DC823D768','')--'Recreation'
--insert @MAP_ServiceDef values ('55311FCC-C14B-46E9-B3BD-6AA1B3723074','')--'School Health Services'
--insert @MAP_ServiceDef values ('6050FA45-ABF8-4179-90E9-09E0DA602B95','')--'Social Work Services'
--insert @MAP_ServiceDef values ('6517DE48-5B6A-4628-93CA-426487EDC178','')--'Speech/Language Related Services'
--insert @MAP_ServiceDef values ('AC2C659A-F8C3-47DC-BBC0-69C784A3C28A','')--'Supported Employment'
--insert @MAP_ServiceDef values ('8A9946E8-F7ED-43EB-B0B7-262D33578CA1','')--'Supports for Transition to Post-Secondary Education'
--insert @MAP_ServiceDef values ('D9A3625C-9913-4DE9-9F66-70A12FE39D84','')--'Transition/STEP by Division of Rehabilitation Services'
--insert @MAP_ServiceDef values ('3BB59E9F-462A-4A73-AAA0-6238DB518D53','')--'Transportation (Special)'
--insert @MAP_ServiceDef values ('6AEAC101-C396-4926-8423-C810EB226C12','')--'Travel Training'
--insert @MAP_ServiceDef values ('9CED8FD3-33E4-48B9-9805-ADB839C75BCB','')--'Vision Itinerant Service'
--insert @MAP_ServiceDef values ('4779B5FA-4D9E-4ED4-A4C2-0DC12CA37166','')--'Vision Screening Related'
--insert @MAP_ServiceDef values ('68D0E99D-B81E-4EF9-BE17-331BD6F94570','')--'Direct Instruction Math'
--insert @MAP_ServiceDef values ('54EA1D2A-EF1C-40C9-9276-425C675ED4DF','')--'Direct Instruction Math/Reading'
--insert @MAP_ServiceDef values ('6ECF44DF-FA82-430B-82D7-7C0AD7E1443B','')--'Orientation and Mobility'
--insert @MAP_ServiceDef values ('5FACFB25-6651-4C09-8770-1BFFFFD719FE','')--'Resource'
--insert @MAP_ServiceDef values ('6E077483-6E86-4789-9E44-A331E9555F9F','')--'Speech/Language Services'
--insert @MAP_ServiceDef values ('82953DE8-5608-4723-A85F-3B0A1BD4FAC5','')--'Vision Screening'
--insert @MAP_ServiceDef values ('3F3CE74E-B435-4227-85ED-32463D4C9F1C','')--'Visually Impaired'




declare I cursor for 
select KeepID, TossID from @MAP_ServiceDef 

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
		and OBJECT_NAME (f.referenced_object_id) = 'ServiceDef' ------------------------- Table name here
		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
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

fetch I into @KeepID, @TossID
end
close I
deallocate I

-- delete unneeded
delete x
-- select g.*, t.StateCode
from ServiceDef x join
@MAP_ServiceDef t on x.ID = t.TossID 


-- another way to handle this:  delete unused records with delete script, and in trannsform, set all new records to deleleteddate not null.  
-- however, that may have a negative impact on FL districts, who may want to keep the services that have entered in their Staging instance.
--update sd set DeletedDate = GETDATE()
--from ServiceDef sd left join
--@ServiceDef t on sd.ID = t.ID 
--where t.ID is null


insert IepServiceDef (ID, CategoryID, ScheduleFreqOnly) 
select s.ID, s.CategoryID,  0
from @ServiceDef s left join
IepServiceDef t on s.ID = t.ID
where t.ID is null



-- select * from ServiceDef order by Name


commit tran fixservdef
--rollback tran fixservdef










