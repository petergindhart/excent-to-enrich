
Begin tran fixservdef

set nocount on;

declare @ServiceDef table (ID uniqueidentifier, CategoryID uniqueidentifier, Name varchar(100), Description text, DefaultLocationID uniqueidentifier, MinutesPerUnit int) 

insert @ServiceDef (ID, CategoryID, Name) values ('52AD0E2D-3A97-499A-95F4-5B4BB02912DF', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Adapted Physical Education')
insert @ServiceDef (ID, CategoryID, Name) values ('8C054380-B22F-4D2A-98DE-568498E06EAB', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Assistive Technology Services')
insert @ServiceDef (ID, CategoryID, Name) values ('6C1EA4EC-C0F0-4C7D-99F2-7AFBB2DBB68C', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Audiology Services')
	-- insert @ServiceDef (ID, CategoryID, Name) values ('61D1B5E8-C054-4EA8-B9CB-F61EBDB1F629', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Consultation')
insert @ServiceDef (ID, CategoryID, Name) values ('94C0C353-6595-4A7E-873E-CE77A52474FA', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Counseling')
	--insert @ServiceDef (ID, CategoryID, Name) values ('D4149322-3A4A-42C1-8590-5A5D919E7B28', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Indirect')
	--insert @ServiceDef (ID, CategoryID, Name) values ('2991CDE7-FB2A-4FDA-AD00-6BF56DCD4D09', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Instruction-Co-Teach')
	--insert @ServiceDef (ID, CategoryID, Name) values ('42176279-A1A0-4699-B01B-187FD0FF07E2', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Instruction-Direct In Gen Ed Class')
	--insert @ServiceDef (ID, CategoryID, Name) values ('E2819193-5118-4DC9-8433-6F35851C14FC', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Instruction-Direct Outside Gen Ed Class')
insert @ServiceDef (ID, CategoryID, Name) values ('E3A7E8E5-72C4-4871-8381-E081EC81D1D6', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Interpreting Services')
insert @ServiceDef (ID, CategoryID, Name) values ('B874A136-2F0E-4955-AA1E-1F0D45F263FB', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Occupational Therapy')
insert @ServiceDef (ID, CategoryID, Name) values ('CABB2C1E-BC93-4D52-9E2D-AF52A259AD17', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Orientation & Mobility Services')
insert @ServiceDef (ID, CategoryID, Name) values ('AA695BB6-947F-44A8-8AB3-43E1B01B6877', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Parent Counseling and Training')
insert @ServiceDef (ID, CategoryID, Name) values ('829EA69A-629D-4883-B2A1-446E3ED2872D', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Personal Care Services')
insert @ServiceDef (ID, CategoryID, Name) values ('73107912-4959-4137-910B-B17E52076074', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Physical Therapy')
insert @ServiceDef (ID, CategoryID, Name) values ('7BBAAB01-398D-4835-B4B0-13D543FAC564', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Psychological Services')
insert @ServiceDef (ID, CategoryID, Name) values ('75D07F63-F586-4C55-8FDE-A5B6D0737157', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'School Health Services')
insert @ServiceDef (ID, CategoryID, Name) values ('9DE4CBF9-BD8D-490C-8E1B-34F5E73DEF11', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Specialized Instruction')
insert @ServiceDef (ID, CategoryID, Name) values ('BF859DEF-67A2-4285-A871-E80315AF3BD5', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Speech/Language Services')
insert @ServiceDef (ID, CategoryID, Name) values ('B630AE87-E461-4DAC-B5B9-3FB85C78F56D', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Transportation Services')


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
select t.ID, TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', t.Name, t.Description, t.DefaultLocationID, t.MinutesPerUnit,1
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
--insert @MAP_ServiceDef values ('BBB4773F-4A8A-49E5-A0D4-952D2A0D1F18', 'B9AAA2A4-A395-4BF2-B5C1-6AF98CCEA676') -- 'Autism Spectrum Disorders'

--insert @MAP_ServiceDef values ('8C054380-B22F-4D2A-98DE-568498E06EAB', '') -- 'Assistive Technology Services')
insert @MAP_ServiceDef values ('52AD0E2D-3A97-499A-95F4-5B4BB02912DF', 'D44BA4E2-D4A4-4F50-BD98-26209C7265A8') -- 'Adapted Physical Education')
insert @MAP_ServiceDef values ('6C1EA4EC-C0F0-4C7D-99F2-7AFBB2DBB68C', '6B793DAA-06F7-425B-BD1E-859C3C9DAAEA') -- 'Audiology Services')
	--insert @MAP_ServiceDef values ('61D1B5E8-C054-4EA8-B9CB-F61EBDB1F629', '54AD7B8C-D44B-45C2-9C80-7BBF87579AB4') -- 'Consultation')
insert @MAP_ServiceDef values ('94C0C353-6595-4A7E-873E-CE77A52474FA', '3842F0E3-D70D-4F18-AE83-A56B6AF740AD') -- 'Counseling')
insert @MAP_ServiceDef values ('E3A7E8E5-72C4-4871-8381-E081EC81D1D6', '05566D5F-66C2-4675-A71D-9A775E7C6C68') -- 'Interpreting Services')
--insert @MAP_ServiceDef values ('B874A136-2F0E-4955-AA1E-1F0D45F263FB', '') -- 'Occupational Therapy')
insert @MAP_ServiceDef values ('CABB2C1E-BC93-4D52-9E2D-AF52A259AD17', '2AC4CF91-88B9-4982-94BF-4B5ABEB568C4') -- 'Orientation & Mobility Services')
insert @MAP_ServiceDef values ('AA695BB6-947F-44A8-8AB3-43E1B01B6877', 'CF418544-FF69-4977-A7CA-C512744C3B21') -- 'Parent Counseling and Training')
insert @MAP_ServiceDef values ('829EA69A-629D-4883-B2A1-446E3ED2872D', '01C3DAB7-4ED9-429D-9731-6509AAF7FA20') -- 'Personal Care Services')
--insert @MAP_ServiceDef values ('73107912-4959-4137-910B-B17E52076074', '') -- 'Physical Therapy')
--insert @MAP_ServiceDef values ('7BBAAB01-398D-4835-B4B0-13D543FAC564', '') -- 'Psychological Services')
--insert @MAP_ServiceDef values ('75D07F63-F586-4C55-8FDE-A5B6D0737157', '') -- 'School Health Services')
--insert @MAP_ServiceDef values ('B630AE87-E461-4DAC-B5B9-3FB85C78F56D', '') -- 'Transportation Services')
	--insert @MAP_ServiceDef values ('D4149322-3A4A-42C1-8590-5A5D919E7B28', '89BEE326-69D3-4ECF-9C1F-A117D4293F38') -- 'Indirect')
	--insert @MAP_ServiceDef values ('2991CDE7-FB2A-4FDA-AD00-6BF56DCD4D09', '315884B0-8B78-46F0-8423-E06FDD41319C') -- 'Instruction-Co-Teach')
	--insert @MAP_ServiceDef values ('42176279-A1A0-4699-B01B-187FD0FF07E2', '4B3948BD-70BF-4684-B93E-F2B29772FBCF') -- 'Instruction-Direct In Gen Ed Class')
	--insert @MAP_ServiceDef values ('E2819193-5118-4DC9-8433-6F35851C14FC', '95D0A92D-784A-447C-B94B-AF407ABAA3E5') -- 'Instruction-Direct Outside Gen Ed Class')
insert @MAP_ServiceDef values ('9DE4CBF9-BD8D-490C-8E1B-34F5E73DEF11', 'FF3E14C1-6482-46DC-BB4E-08E2BFA39B85') -- 'Specialized Instruction')
--insert @MAP_ServiceDef values ('BF859DEF-67A2-4285-A871-E80315AF3BD5', '') -- 'Speech/Language Services')

--5D70A02F-F9E9-40BD-B30C-9144E419882A	Adapted Physical Education
--54AD7B8C-D44B-45C2-9C80-7BBF87579AB4	Consultation

--BA58A524-BF79-4527-90C1-C3A3A487AD7B	Audiology Services
--B111C18D-AA0C-4982-9CFE-4E9C3F75611A	Counseling
--FB6F9141-CE06-4B61-AA29-A14FED8C1CCC	Interpreting Services
--B6AC6BB7-E6D3-4C45-AA93-438B015DB2B2	Orientation & Mobility Services
--4161C328-1AAE-41E1-9CA8-3699031912FF	Parent Counseling and Training
--AF88E635-7B1C-4F95-B43D-847AA466C669	Personal Care Services
--FF3E14C1-6482-46DC-BB4E-08E2BFA39B85	Specialized Instruction

--89BEE326-69D3-4ECF-9C1F-A117D4293F38	Indirect
--315884B0-8B78-46F0-8423-E06FDD41319C	Instruction-Co-Teach
--4B3948BD-70BF-4684-B93E-F2B29772FBCF	Instruction-Direct In Gen Ed Class
--95D0A92D-784A-447C-B94B-AF407ABAA3E5	Instruction-Direct Outside Gen Ed Class

--52AD0E2D-3A97-499A-95F4-5B4BB02912DF	Adapted Physical Education
--61D1B5E8-C054-4EA8-B9CB-F61EBDB1F629	Consultation

-- list all tables with FK on GradeLevel and update them 


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


insert IepServiceDef (ID, CategoryID, ScheduleFreqOnly,UseServiceAmountRange) 
select s.ID, s.CategoryID,  0, 0
from @ServiceDef s left join
IepServiceDef t on s.ID = t.ID
where t.ID is null



-- select * from ServiceDef order by Name
--select * from IepServicedef

commit tran fixservdef
--rollback tran fixservdef










