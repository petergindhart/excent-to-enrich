begin tran fixspt
/* ============================================	IMPORTANT! ============================================
	
	This script is designed to ensure that the values in the CO Select Lists Template file are pre-populated 
	in the Enrich database for any given CO distrcit before data conversion is run.
	
	Before using this script you must update the section below to populate the @MAP_ServiceProviderTitle table
	with the KeepID and the TossID.
	
	The cursor query looks for all of the FK relationships for GradeLevel.ID and updates the ID that is to be deleted
	with the ID that is to be kept.

   ============================================	IMPORTANT! ============================================ */

set nocount on;
declare @ServiceProviderTitle table (ID uniqueidentifier, Name varchar(75), StateCode varchar(20))

insert @ServiceProviderTitle(ID , Name, StateCode )  values ('D2130FB0-1E2A-4827-B1D0-92BC49E94A22','Adapted PE Teacher','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('7F0EABB5-286D-473C-BFC2-79A2658D9879','Audiologist','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('56460F78-90AB-485A-B829-0C78B0332BA8','Counselor','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('0CDE139C-787F-4E30-9A74-E6535C85EDB0','Early Childhood Special Educator','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('149F36E1-DF2D-4CD3-BA4B-96D58C52012A','Educational Interpreter','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('385ABF0C-567E-44B0-9684-AFB27B5AE5B9','Licensed Practical Nurse','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('6F563A7A-EBCA-4438-8819-F4266600F5E0','Occupational Therapist','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('0FB24F63-7A71-42A7-ABCA-1B9E58093194','Orientation & Mobility Specialist','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('74DF6273-69EA-4CA3-AD38-510A457BAA25','Physical Therapist','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('839A1D38-EB55-474F-BF97-297FE372F866','Registered Nurse','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('A3471353-6064-4C5C-9E24-8FDE3E05B084','School Psychologist','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('0E23822F-678E-4532-A28A-B42BA569C617','Social Worker','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('7F0195EC-B20A-443E-B13B-8DD0139FF115','Special Education Teacher','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('5D0EB909-4245-40EE-94EA-11F7E9F0A42E','Speech Language Pathologist','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('12E058BB-7407-4CC9-AB5A-15ED8BACE440','Teacher of Deaf/Hard of Hearing','')
insert @ServiceProviderTitle(ID , Name, StateCode )  values ('B4464F73-BEF2-4D84-88E4-23EB8D0CAE7D','Teacher of the Blind/Visually Impaired','')

select * from ServiceProviderTitle order by Name
select * from @ServiceProviderTitle order by Name


---- insert test
select t.ID, t.Name, t.StateCode
from ServiceProviderTitle g right join
@ServiceProviderTitle t on g.ID = t.ID 
where g.ID is null
order by  g.Name


---- delete test
select g.*
from ServiceProviderTitle g left join
@ServiceProviderTitle t on g.ID = t.ID 
where t.ID is null
 


--update g set StateCode = t.StateCode -- service provider title in CO does not have a state code
-- --select g.*, t.StateCode
--from ServiceProviderTitle g left join
--@ServiceProviderTitle t on g.ID = t.ID 

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

--insert @MAP_ServiceProviderTitle  values ('D2130FB0-1E2A-4827-B1D0-92BC49E94A22','') -- Adapted PE Teacher
--insert @MAP_ServiceProviderTitle  values ('7F0EABB5-286D-473C-BFC2-79A2658D9879','') -- 
--insert @MAP_ServiceProviderTitle  values ('56460F78-90AB-485A-B829-0C78B0332BA8','')
--insert @MAP_ServiceProviderTitle  values ('0CDE139C-787F-4E30-9A74-E6535C85EDB0','')
--insert @MAP_ServiceProviderTitle  values ('149F36E1-DF2D-4CD3-BA4B-96D58C52012A','')
--insert @MAP_ServiceProviderTitle  values ('385ABF0C-567E-44B0-9684-AFB27B5AE5B9','')
--insert @MAP_ServiceProviderTitle  values ('6F563A7A-EBCA-4438-8819-F4266600F5E0','')
--insert @MAP_ServiceProviderTitle  values ('0FB24F63-7A71-42A7-ABCA-1B9E58093194','')
--insert @MAP_ServiceProviderTitle  values ('74DF6273-69EA-4CA3-AD38-510A457BAA25','')
--insert @MAP_ServiceProviderTitle  values ('839A1D38-EB55-474F-BF97-297FE372F866','')
--insert @MAP_ServiceProviderTitle  values ('A3471353-6064-4C5C-9E24-8FDE3E05B084','')
--insert @MAP_ServiceProviderTitle  values ('0E23822F-678E-4532-A28A-B42BA569C617','')
--insert @MAP_ServiceProviderTitle  values ('7F0195EC-B20A-443E-B13B-8DD0139FF115','')
--insert @MAP_ServiceProviderTitle  values ('5D0EB909-4245-40EE-94EA-11F7E9F0A42E','')
--insert @MAP_ServiceProviderTitle  values ('12E058BB-7407-4CC9-AB5A-15ED8BACE440','')
--insert @MAP_ServiceProviderTitle  values ('B4464F73-BEF2-4D84-88E4-23EB8D0CAE7D','')


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
from ServiceProviderTitle g left join
@MAP_ServiceProviderTitle t on g.ID = t.TossID 


commit tran fixspt



--select * from ServiceProviderTitle order by Name

--D2130FB0-1E2A-4827-B1D0-92BC49E94A22			Adapted PE Teacher
--7F0EABB5-286D-473C-BFC2-79A2658D9879			Audiologist
--56460F78-90AB-485A-B829-0C78B0332BA8			Counselor
--0CDE139C-787F-4E30-9A74-E6535C85EDB0			Early Childhood Special Educator
--149F36E1-DF2D-4CD3-BA4B-96D58C52012A			Educational Interpreter
--385ABF0C-567E-44B0-9684-AFB27B5AE5B9			Licensed Practical Nurse
--6F563A7A-EBCA-4438-8819-F4266600F5E0			Occupational Therapist
--0FB24F63-7A71-42A7-ABCA-1B9E58093194			Orientation & Mobility Specialist
--74DF6273-69EA-4CA3-AD38-510A457BAA25			Physical Therapist
--839A1D38-EB55-474F-BF97-297FE372F866			Registered Nurse
--A3471353-6064-4C5C-9E24-8FDE3E05B084			School Psychologist
--0E23822F-678E-4532-A28A-B42BA569C617			Social Worker
--7F0195EC-B20A-443E-B13B-8DD0139FF115			Special Education Teacher
--5D0EB909-4245-40EE-94EA-11F7E9F0A42E			Speech Language Pathologist
--12E058BB-7407-4CC9-AB5A-15ED8BACE440			Teacher of Deaf/Hard of Hearing
--B4464F73-BEF2-4D84-88E4-23EB8D0CAE7D			Teacher of the Blind/Visually Impaired