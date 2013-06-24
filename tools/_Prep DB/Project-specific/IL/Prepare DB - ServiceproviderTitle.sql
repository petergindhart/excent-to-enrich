/* ============================================	IMPORTANT! ============================================
	
	This script is designed to ensure that the values in the CO Select Lists Template file are pre-populated 
	in the Enrich database for any given CO distrcit before data conversion is run.
	
	Before using this script you must update the section below to populate the @MAP_ServiceProviderTitle table
	with the KeepID and the TossID.
	
	The cursor query looks for all of the FK relationships for GradeLevel.ID and updates the ID that is to be deleted
	with the ID that is to be kept.

   ============================================	IMPORTANT! ============================================ */

begin tran fixspt

set nocount on;
declare @ServiceProviderTitle table (ID uniqueidentifier, Name varchar(75), StateCode varchar(20))

insert @ServiceProviderTitle(ID , Name, StateCode )  values ('9C7A5E9C-3149-4628-8814-580A9EB184C5','Bus Company',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('233865DE-199C-4D78-A176-6ADBB652134B','Cab Company',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('87591D72-F1B8-43CC-B305-CFEE194DF7C6','Certified Audiometric Technician',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('2D437B1E-9074-4D2B-B71B-0FAE49C7DB32','Certified Vision Technician',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('036398B7-8E10-4832-99A7-63352973DC22','Counselor',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('D1E28DE9-31E4-412A-AAF3-E7014E6D6635','General Education Teacher',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('4237132C-8E87-44B9-B15A-818788B6BB63','H/V Technician',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('A67F6F5F-374A-4EEE-AB93-9EE1B00694AC','Hearing Itinerant',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('A6A2A3AF-2181-4EBA-BDB5-5BE1146261F8','Lake Forest Hospital',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('52F2BB51-4374-41F6-9723-EAAC45AEAA90','Nurse',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('AC33FCAB-39BB-47D2-A1F6-8BE5463C9923','O & M Specialist',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('1A3E5179-0356-4114-90D8-23BE4AC7AFB7','Occupational Therapist',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('E05C756F-BF0F-46E2-97C2-44446E38FF1C','Occupational Therapy Staff',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('7E9E4B2B-CF30-4B4E-9A03-8B678C2D0B82','Physical Therapist',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('14F5D644-E1AA-48F2-8173-C00D3D49C813','Physical Therapy Staff',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('EFAC3B61-16F6-403C-9AA1-2FBDBCB8AD18','Psychiatrist',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('462420E1-830E-40DA-AD3B-CB621CC1E676','Psychologist',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('EC9928ED-A759-4EFD-BB4C-94492D0C9E21','Sign Language Interpreter',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('8E0A046B-2134-44BD-95ED-ED9190A53554','Social Worker',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('BAE1740B-F145-4621-B7B3-4C20FFC7A2F5','Special Education Paraprofessional-Class',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('25418C2F-0E66-4F34-9C80-A2B1C2B24486','Special Education Paraprofessional-Individual Student',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('232C6E76-DC07-444A-8456-8E63E18E0AB4','Special Education Staff',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('EA081703-A485-4329-9BEE-EF7289E9A5FF','Special Education Teacher',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('13EF697B-CAB8-4BCC-AFBE-0BD70989E32C','Speech/Language Pathologist',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('07CD8B2A-6DB8-4DA4-A7C8-0F864254ED17','Teacher of the Deaf/Hard of Hearing',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('120679BE-8C1C-463F-9AAD-D25426062975','Teacher of the Visually Impaired',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('8F9ECF88-150B-4C57-8B0D-3E448148DDCC','Team',NULL)
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('F0761891-86C4-4F3C-B126-FDB367D220C8','Vision Itinerant',NULL)


---- insert test
select t.*
from ServiceProviderTitle x right join
@ServiceProviderTitle t on x.ID = t.ID 
where x.ID is null order by x.Name

---- delete test
select x.*
from ServiceProviderTitle x left join
@ServiceProviderTitle t on x.ID = t.ID 
where t.ID is null order by x.Name


declare @RelaSchema varchar(100), @RelaTable varchar(100), @RelaColumn varchar(100), @ID varchar(50)

--declare D cursor for 
--select dspt.ID from(select g.*
--from ServiceProviderTitle g left join
--@ServiceProviderTitle t on g.ID = t.ID 
--where t.ID is null ) dspt

--open D
--fetch D into @ID

--while @@fetch_status = 0

--begin

--	declare Re cursor for 
--	SELECT 
--		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
--		OBJECT_NAME(f.parent_object_id) AS TableName,
--		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
--	FROM sys.foreign_keys AS f
--		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
--		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
--	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
--		and OBJECT_NAME (f.referenced_object_id) = 'ServiceProviderTitle' 
--		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
--	order by SchemaName, TableName, ColumnName

--	open Re
--	fetch Re into @Relaschema, @RelaTable, @Relacolumn

--	while @@fetch_status = 0
--	begin

-- 	exec ('DELETE t  from '+@Relaschema+'.'+@Relatable+' t where t.'+@Relacolumn+' = '''+@ID+'''' )

--	fetch Re into @Relaschema, @RelaTable, @Relacolumn
--	end
--	close Re
--	deallocate Re

--fetch D into @ID
--end
--close D
--deallocate D




select t.ID, t.Name,  t.StateCode
from ServiceProviderTitle g right join
@ServiceProviderTitle t on g.ID = t.ID 
where g.ID is null
order by  g.Name



--delete g
select g.*
from ServiceProviderTitle g left join
@ServiceProviderTitle t on g.ID = t.ID 
where t.ID is null or g.DeletedDate is not null

select * from ServiceProviderTitle 


update g set StateCode = t.StateCode,
		     Name = t.Name
-- service provider title in CO does not have a state code
--select g.*, t.StateCode,t.Name
from ServiceProviderTitle g  join
@ServiceProviderTitle t on g.ID = t.ID 


insert ServiceProviderTitle (ID,Name,StateCode) 
select t.ID, t.Name,  t.StateCode
from ServiceProviderTitle g right join
@ServiceProviderTitle t on g.ID = t.ID 
where g.ID is null
order by  g.Name




declare @MAP_ServiceProviderTitle table (KeepID uniqueidentifier, TossID uniqueidentifier)

-- populate a mapping that to update FK related records of GradeLevvel records that will be deleted   
	-- this needs to be done by visual inspection because Grade Level names can vary widely
-- 1. un-comment the rows required to map for updating FK related tables.  
-- 2. Add the ID that needs to be deleted in the Empty quotes of the Values insert

--insert @MAP_ServiceProviderTitle values ('9C7A5E9C-3149-4628-8814-580A9EB184C5','') --'Bus Company'
--insert @MAP_ServiceProviderTitle values ('233865DE-199C-4D78-A176-6ADBB652134B','') --'Cab Company'
--insert @MAP_ServiceProviderTitle values ('87591D72-F1B8-43CC-B305-CFEE194DF7C6','') --'Certified Audiometric Technician'
--insert @MAP_ServiceProviderTitle values ('2D437B1E-9074-4D2B-B71B-0FAE49C7DB32','') --'Certified Vision Technician'
--insert @MAP_ServiceProviderTitle values ('036398B7-8E10-4832-99A7-63352973DC22','') --'Counselor'
--insert @MAP_ServiceProviderTitle values ('D1E28DE9-31E4-412A-AAF3-E7014E6D6635','') --'General Education Teacher'
--insert @MAP_ServiceProviderTitle values ('4237132C-8E87-44B9-B15A-818788B6BB63','') --'H/V Technician'
--insert @MAP_ServiceProviderTitle values ('A67F6F5F-374A-4EEE-AB93-9EE1B00694AC','') --'Hearing Itinerant'
--insert @MAP_ServiceProviderTitle values ('A6A2A3AF-2181-4EBA-BDB5-5BE1146261F8','') --'Lake Forest Hospital'
--insert @MAP_ServiceProviderTitle values ('52F2BB51-4374-41F6-9723-EAAC45AEAA90','') --'Nurse'
insert @MAP_ServiceProviderTitle values ('AC33FCAB-39BB-47D2-A1F6-8BE5463C9923','0FB24F63-7A71-42A7-ABCA-1B9E58093194') --'O & M Specialist'
--insert @MAP_ServiceProviderTitle values ('1A3E5179-0356-4114-90D8-23BE4AC7AFB7','') --'Occupational Therapist'
--insert @MAP_ServiceProviderTitle values ('E05C756F-BF0F-46E2-97C2-44446E38FF1C','') --'Occupational Therapy Staff'
insert @MAP_ServiceProviderTitle values ('7E9E4B2B-CF30-4B4E-9A03-8B678C2D0B82','74DF6273-69EA-4CA3-AD38-510A457BAA25') --'Physical Therapist'
--insert @MAP_ServiceProviderTitle values ('14F5D644-E1AA-48F2-8173-C00D3D49C813','') --'Physical Therapy Staff'
--insert @MAP_ServiceProviderTitle values ('EFAC3B61-16F6-403C-9AA1-2FBDBCB8AD18','') --'Psychiatrist'
--insert @MAP_ServiceProviderTitle values ('462420E1-830E-40DA-AD3B-CB621CC1E676','') --'Psychologist'
--insert @MAP_ServiceProviderTitle values ('EC9928ED-A759-4EFD-BB4C-94492D0C9E21','') --'Sign Language Interpreter'
insert @MAP_ServiceProviderTitle values ('8E0A046B-2134-44BD-95ED-ED9190A53554','0E23822F-678E-4532-A28A-B42BA569C617') --'Social Worker'
--insert @MAP_ServiceProviderTitle values ('BAE1740B-F145-4621-B7B3-4C20FFC7A2F5','') --'Special Education Paraprofessional-Class'
--insert @MAP_ServiceProviderTitle values ('25418C2F-0E66-4F34-9C80-A2B1C2B24486','') --'Special Education Paraprofessional-Individual Student'
--insert @MAP_ServiceProviderTitle values ('232C6E76-DC07-444A-8456-8E63E18E0AB4','') --'Special Education Staff'
insert @MAP_ServiceProviderTitle values ('EA081703-A485-4329-9BEE-EF7289E9A5FF','7F0195EC-B20A-443E-B13B-8DD0139FF115') --'Special Education Teacher'
insert @MAP_ServiceProviderTitle values ('13EF697B-CAB8-4BCC-AFBE-0BD70989E32C','5D0EB909-4245-40EE-94EA-11F7E9F0A42E') --'Speech/Language Pathologist'
insert @MAP_ServiceProviderTitle values ('07CD8B2A-6DB8-4DA4-A7C8-0F864254ED17','12E058BB-7407-4CC9-AB5A-15ED8BACE440') --'Teacher of the Deaf/Hard of Hearing'
insert @MAP_ServiceProviderTitle values ('120679BE-8C1C-463F-9AAD-D25426062975','B4464F73-BEF2-4D84-88E4-23EB8D0CAE7D') --'Teacher of the Visually Impaired'
--insert @MAP_ServiceProviderTitle values ('8F9ECF88-150B-4C57-8B0D-3E448148DDCC','') --'Team'
--insert @MAP_ServiceProviderTitle values ('F0761891-86C4-4F3C-B126-FDB367D220C8','') --'Vision Itinerant'




---- delete test
select g.*
from ServiceProviderTitle g left join
@MAP_ServiceProviderTitle t on g.ID = t.TossID 


-- list all tables with FK on GradeLevel and update them 

declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50)

declare I cursor for 
select KeepID, TossID from @MAP_ServiceProviderTitle 

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
		and OBJECT_NAME (f.referenced_object_id) = 'ServiceProviderTitle' 
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
delete g
from ServiceProviderTitle g  join
@MAP_ServiceProviderTitle t on g.ID = t.TossID


commit tran fixspt
-- Rollback tran fixspt





--select * from ServiceProviderTitle where deleteddate is  null order by Name  

