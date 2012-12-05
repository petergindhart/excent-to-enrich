declare @SelectLists table (Type varchar(20), SubType varchar(20), EnrichID uniqueidentifier, StateCode varchar(10), EnrichLabel varchar(254))

insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '932CB806-3EEA-4D95-9973-01A3E05F55E0', '18', 'Assistive Technology Device')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '2C1096E4-BA93-42BB-8C1A-0EE1C5C5B6B0', '14', 'Family Support Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '42A2EC5D-FB02-4680-A27B-11BB873EDA5F', '22', 'Hearing Interpretive Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'DA5809CF-21EB-4B48-A071-143A33402F7B', '17', 'Vocational Rehabilitation')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'AE882D0F-926F-46B3-ABB2-255494A959B7', '04', 'Physical Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'CDE709CD-8A11-43C9-9D7B-2ACF4EC4C051', '11', 'Vision Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '18CB6534-7E68-409A-A64D-307C190530D5', '09', 'School Health')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '3B17CA1F-D52C-4D93-BBFF-32DA033D4D5B', '20', 'Intensive Behavior Intervention')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'B9E8033A-EF97-4283-8BC8-419DFDFD3463', '01', 'Speech Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'FD34680D-E368-41CF-A7F9-472DF7C8609A', '03', 'Occupational Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '5CDABA40-A230-4E80-9C77-49A541231730', '34', 'Extended school year')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'A619217E-0A76-4F63-A13E-4CB60E6E42BA', '19', 'Assistive Technology Service')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '1556C098-DE6C-4324-B4F9-5B31C1690A91', '05', 'School Psychological Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '3860C66C-7D62-4C29-A692-65F0E1F43CD0', '06', 'Social Work')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '2832170F-9BFD-4222-8032-6FA6C00A907A', '21', 'One to one aide outside genera')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '00967470-8A60-41E8-9D32-7084538EEE4E', '32', 'Community Based Education')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '73436B05-6A48-4F48-AD12-81787469D743', '99', 'Other Spec Ed Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'E10274DB-2ED7-4A46-958C-837E18460766', '15', 'One-to-One Aide/General class')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'B44DAB63-CAB0-4E98-83DE-8910B1B4E676', '23', 'Title One Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'C4D5D929-0D74-45D7-8F42-8AA86DD6CDEB', '10', 'Counseling')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '8B762FD6-02C6-4DB9-8A71-93F213AB7210', '31', 'Orientation and Mobility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'F3094011-D87E-4942-A486-A0953904F68D', '25', 'Psycho-Social Rehabilitation')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '93C18E55-ED8E-4537-9EC7-B653DEA388AD', '08', 'Adaptive P.E.')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'A53B1E53-2FE5-4254-B622-D3A24B9CA034', '13', 'Specially Arranged Transport')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '85140049-E850-4650-AE1B-D550BA85F0C0', '02', 'Language Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '6ED9C679-F52D-4453-9770-E0DF86318335', '12', 'Hearing Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '361C98C1-B835-4448-981B-E9046A1C8867', '33', 'Emotion/behavior intervention')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'CF8B709A-CF54-47E7-916D-EC8CCB9883D4', '16', 'Vocational Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'E287E083-C477-4461-8373-F79FA22F82DF', '07', 'Licensed Psychologist/Psychiat')


----========================================================================================================
----					ServiceDef
----========================================================================================================
--select * from @SelectLists where Type = 'Service'  order by EnrichLabel
--select * from ServiceDef 

declare @ServiceDef table (ID uniqueidentifier, CategoryID uniqueidentifier, Name varchar(100), Description text, DefaultLocationID uniqueidentifier, MinutesPerUnit int) 

insert @ServiceDef (ID, CategoryID, Name) values ('93C18E55-ED8E-4537-9EC7-B653DEA388AD','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Adaptive P.E.')
insert @ServiceDef (ID, CategoryID, Name) values ('932CB806-3EEA-4D95-9973-01A3E05F55E0','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Assistive Technology Device')
insert @ServiceDef (ID, CategoryID, Name) values ('A619217E-0A76-4F63-A13E-4CB60E6E42BA','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Assistive Technology Service')
insert @ServiceDef (ID, CategoryID, Name) values ('00967470-8A60-41E8-9D32-7084538EEE4E','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Community Based Education')	
insert @ServiceDef (ID, CategoryID, Name) values ('C4D5D929-0D74-45D7-8F42-8AA86DD6CDEB','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Counseling')	
insert @ServiceDef (ID, CategoryID, Name) values ('361C98C1-B835-4448-981B-E9046A1C8867','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Emotion/behavior intervention')	
insert @ServiceDef (ID, CategoryID, Name) values ('5CDABA40-A230-4E80-9C77-49A541231730','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Extended school year')	
insert @ServiceDef (ID, CategoryID, Name) values ('2C1096E4-BA93-42BB-8C1A-0EE1C5C5B6B0','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Family Support Services')	
insert @ServiceDef (ID, CategoryID, Name) values ('42A2EC5D-FB02-4680-A27B-11BB873EDA5F','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Hearing Interpretive Services')	
insert @ServiceDef (ID, CategoryID, Name) values ('6ED9C679-F52D-4453-9770-E0DF86318335','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Hearing Services')		
insert @ServiceDef (ID, CategoryID, Name) values ('3B17CA1F-D52C-4D93-BBFF-32DA033D4D5B','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Intensive Behavior Intervention')		
insert @ServiceDef (ID, CategoryID, Name) values ('85140049-E850-4650-AE1B-D550BA85F0C0','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Language Therapy')		
insert @ServiceDef (ID, CategoryID, Name) values ('E287E083-C477-4461-8373-F79FA22F82DF','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Licensed Psychologist/Psychiat')		
insert @ServiceDef (ID, CategoryID, Name) values ('FD34680D-E368-41CF-A7F9-472DF7C8609A','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Occupational Therapy')		
insert @ServiceDef (ID, CategoryID, Name) values ('2832170F-9BFD-4222-8032-6FA6C00A907A','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','One to one aide outside genera')		
insert @ServiceDef (ID, CategoryID, Name) values ('E10274DB-2ED7-4A46-958C-837E18460766','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','One-to-One Aide/General class')		
insert @ServiceDef (ID, CategoryID, Name) values ('8B762FD6-02C6-4DB9-8A71-93F213AB7210','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Orientation and Mobility')		
insert @ServiceDef (ID, CategoryID, Name) values ('73436B05-6A48-4F48-AD12-81787469D743','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Other Spec Ed Services')		
insert @ServiceDef (ID, CategoryID, Name) values ('AE882D0F-926F-46B3-ABB2-255494A959B7','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Physical Therapy')		
insert @ServiceDef (ID, CategoryID, Name) values ('F3094011-D87E-4942-A486-A0953904F68D','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Psycho-Social Rehabilitation')		
insert @ServiceDef (ID, CategoryID, Name) values ('18CB6534-7E68-409A-A64D-307C190530D5','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','School Health')		
insert @ServiceDef (ID, CategoryID, Name) values ('1556C098-DE6C-4324-B4F9-5B31C1690A91','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','School Psychological Services')		
insert @ServiceDef (ID, CategoryID, Name) values ('3860C66C-7D62-4C29-A692-65F0E1F43CD0','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Social Work')		
insert @ServiceDef (ID, CategoryID, Name) values ('A53B1E53-2FE5-4254-B622-D3A24B9CA034','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Specially Arranged Transport')		
insert @ServiceDef (ID, CategoryID, Name) values ('B9E8033A-EF97-4283-8BC8-419DFDFD3463','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Speech Therapy')		
insert @ServiceDef (ID, CategoryID, Name) values ('B44DAB63-CAB0-4E98-83DE-8910B1B4E676','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Title One Services')		
insert @ServiceDef (ID, CategoryID, Name) values ('CDE709CD-8A11-43C9-9D7B-2ACF4EC4C051','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Vision Services')		
insert @ServiceDef (ID, CategoryID, Name) values ('DA5809CF-21EB-4B48-A071-143A33402F7B','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Vocational Rehabilitation')		
insert @ServiceDef (ID, CategoryID, Name) values ('CF8B709A-CF54-47E7-916D-EC8CCB9883D4','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Vocational Services')
--select ID from @ServiceDef order by Name

update tsd set Description = sd.Description, DefaultLocationID = sd.DefaultLocationID, MinutesPerUnit = sd.MinutesPerUnit
from (select * from @SelectLists where Type = 'Service') x join 
@ServiceDef tsd on x.EnrichID = tsd.ID JOIN 
ServiceDef sd on tsd.Name = sd.Name



--select * from ServiceDef order by Name
--select ID, 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', Name from @ServiceDef order by Name

-- insert test
select t.EnrichID, TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', t.EnrichLabel, tsd.Description, tsd.DefaultLocationID, tsd.MinutesPerUnit
from ServiceDef x right join
(select * from @SelectLists where Type = 'Service') t on x.ID =t.EnrichID JOIN 
@ServiceDef tsd on t.EnrichID = tsd.ID 
where x.ID is null order by x.Name

------ delete test		-- we will not be deleting services that were entered manually by the customer.
select x.*
from ServiceDef x left join
(select * from @SelectLists where Type = 'Service') t on x.ID =t.EnrichID  
 where t.EnrichID is null
order by x.Name

-- update test - deleted date
select sd.*
-- update sd set DeletedDate = GETDATE()
from ServiceDef sd left join
@ServiceDef t on sd.ID = t.ID 
where t.ID is null

Begin tran fixservdef

insert ServiceDef (ID, TypeID, Name, Description, DefaultLocationID, MinutesPerUnit,UserDefined)
select t.EnrichID, TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', t.EnrichLabel, tsd.Description, tsd.DefaultLocationID, tsd.MinutesPerUnit,1
from ServiceDef x right join
(select * from @SelectLists where Type = 'Service') t on x.ID =t.EnrichID JOIN 
@ServiceDef tsd on t.EnrichID = tsd.ID 
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
--insert @MAP_ServiceDef values ('93C18E55-ED8E-4537-9EC7-B653DEA388AD','D845912D-8FDF-442B-A7F1-97C92AD7CACC')--Adaptive P.E.
--insert @MAP_ServiceDef values ('932CB806-3EEA-4D95-9973-01A3E05F55E0','45441F0E-84DC-4746-8629-7E45C406CDE9')--	Assistive Technology Device
insert @MAP_ServiceDef values ('A619217E-0A76-4F63-A13E-4CB60E6E42BA','8C054380-B22F-4D2A-98DE-568498E06EAB')--	Assistive Technology Service
insert @MAP_ServiceDef values ('00967470-8A60-41E8-9D32-7084538EEE4E','CD96747D-3D67-4207-86FD-FD754A498102')--Community Based Education
--insert @MAP_ServiceDef values ('C4D5D929-0D74-45D7-8F42-8AA86DD6CDEB','A8A6FB3F-7EFC-47C5-8FB5-D97A4852E964')--Counseling
--insert @MAP_ServiceDef values ('361C98C1-B835-4448-981B-E9046A1C8867','')--Emotion/behavior intervention
--insert @MAP_ServiceDef values ('5CDABA40-A230-4E80-9C77-49A541231730','0B05CD43-2829-4D3C-AAF7-C045DA553DB0')--Extended school year
--insert @MAP_ServiceDef values ('2C1096E4-BA93-42BB-8C1A-0EE1C5C5B6B0','9DA3A043-5CAF-44A7-A79E-9CD99FC7D3EE')--Family Support Services
--insert @MAP_ServiceDef values ('42A2EC5D-FB02-4680-A27B-11BB873EDA5F','4C4226F6-5188-4396-BF62-32CA2251E348')--Hearing Interpretive Services
--insert @MAP_ServiceDef values ('6ED9C679-F52D-4453-9770-E0DF86318335','FB84D772-5DAB-42E7-8B1B-44A2D716F6E8')--Hearing Services
--insert @MAP_ServiceDef values ('3B17CA1F-D52C-4D93-BBFF-32DA033D4D5B','982D81E2-ABA4-411E-B4BA-4D75EC8F0541')--Intensive Behavior Intervention
--insert @MAP_ServiceDef values ('85140049-E850-4650-AE1B-D550BA85F0C0','93F77552-3134-43D8-8A70-E754215130F8')--Language Therapy
--insert @MAP_ServiceDef values ('E287E083-C477-4461-8373-F79FA22F82DF','1FB4A0D4-36E5-4F56-8AAE-B88A91F03720')--Licensed Psychologist/Psychiat
insert @MAP_ServiceDef values ('FD34680D-E368-41CF-A7F9-472DF7C8609A','B874A136-2F0E-4955-AA1E-1F0D45F263FB')--Occupational Therapy
--insert @MAP_ServiceDef values ('2832170F-9BFD-4222-8032-6FA6C00A907A','94298B87-BA02-40CF-8E3E-5C257B63FFDF')--One to one aide outside genera
--insert @MAP_ServiceDef values ('E10274DB-2ED7-4A46-958C-837E18460766','FE9238F3-7707-41E4-8DA5-8F82D4DF62AA')--One-to-One Aide/General class
--insert @MAP_ServiceDef values ('8B762FD6-02C6-4DB9-8A71-93F213AB7210','275B088C-8FB1-4574-A6F6-983F36343AD8')--Orientation and Mobility
--insert @MAP_ServiceDef values ('73436B05-6A48-4F48-AD12-81787469D743','')--Other Spec Ed Services
insert @MAP_ServiceDef values ('AE882D0F-926F-46B3-ABB2-255494A959B7','73107912-4959-4137-910B-B17E52076074')--Physical Therapy
--insert @MAP_ServiceDef values ('F3094011-D87E-4942-A486-A0953904F68D','62C696F1-AEF3-4636-A425-BEF95584CFD1')--Psycho-Social Rehabilitation
--insert @MAP_ServiceDef values ('18CB6534-7E68-409A-A64D-307C190530D5','75D07F63-F586-4C55-8FDE-A5B6D0737157')--School Health
insert @MAP_ServiceDef values ('1556C098-DE6C-4324-B4F9-5B31C1690A91','7BBAAB01-398D-4835-B4B0-13D543FAC564')--School Psychological Services
--insert @MAP_ServiceDef values ('3860C66C-7D62-4C29-A692-65F0E1F43CD0','BB0B78C6-5B61-44C9-B1C8-F301DE831028')--Social Work
insert @MAP_ServiceDef values ('A53B1E53-2FE5-4254-B622-D3A24B9CA034','B630AE87-E461-4DAC-B5B9-3FB85C78F56D')--Specially Arranged Transport
insert @MAP_ServiceDef values ('B9E8033A-EF97-4283-8BC8-419DFDFD3463','BF859DEF-67A2-4285-A871-E80315AF3BD5')--Speech Therapy
--insert @MAP_ServiceDef values ('B44DAB63-CAB0-4E98-83DE-8910B1B4E676','4A220C42-559C-4E03-A591-7DEF6DE16061')--Title One Services
--insert @MAP_ServiceDef values ('CDE709CD-8A11-43C9-9D7B-2ACF4EC4C051','7FA2A03B-D9AF-482C-9027-32333081E1B9')--Vision Services
--insert @MAP_ServiceDef values ('DA5809CF-21EB-4B48-A071-143A33402F7B','93A101A0-4278-4EFA-BB75-16CA0CF3A60F')--Vocational Rehabilitation
--insert @MAP_ServiceDef values ('CF8B709A-CF54-47E7-916D-EC8CCB9883D4','75426BD7-DD80-4D61-B19A-8EE5F14E2714')--Vocational Services


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

--select * from ServiceDef order by Name
-- another way to handle this:  delete unused records with delete script, and in trannsform, set all new records to deleleteddate not null.  
-- however, that may have a negative impact on FL districts, who may want to keep the services that have entered in their Staging instance.
--update sd set DeletedDate = GETDATE()
--from ServiceDef sd left join
--@ServiceDef t on sd.ID = t.ID 
--where t.ID is null


insert IepServiceDef (ID, CategoryID, ScheduleFreqOnly,UseServiceAmountRange) 
select s.ID, s.CategoryID,  0,0
from @ServiceDef s left join
IepServiceDef t on s.ID = t.ID
where t.ID is null



-- select * from ServiceDef order by Name
--select * from IepServiceDef

commit tran fixservdef
------rollback tran fixservdef
