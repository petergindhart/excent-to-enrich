
set nocount on;
-- this needs to be run on the CDE Sandbox template for CO instanaces as well as on all CO import databases
declare @IepDisability table (ID uniqueidentifier, Name varchar(50), Definition text, DeterminationFormTemplateID uniqueidentifier, StateCode varchar(20), DeletedDate datetime)

insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('8D9B3B54-4080-4D5E-A196-956D5223E479','Autism Spectrum Disorders','<b>Definition:</b> Autism impairment means a developmental disability significantly affecting verbal and nonverbal communication and social interaction, generally evident before age 3, which adversely affects a child’s educational performance.  Other characteristics often associated with autism are engagement in repetitive activities and stereotyped movements, resistance to environmental change or change in daily routines, and unusual responses to sensory experiences.  The term does not apply if a child’s educational performance is adversely affected primarily because the child has an emotional disturbance.  A child who manifests the characteristics of “autism” after age 3 could be diagnosed as having “autism” if the eligibility criteria are satisfied.','4CE41830-47B9-47B9-878F-4E0C57CC18CF','11')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('36032F6B-C23D-4B24-BA1A-82C29D6B0D9F','Hearing Impairment, Including Deafness','<b>Definition:</b> Hearing impairment means an impairment in hearing, whether permanent or fluctuating, that adversely affects a child’s educational performance but that is not included under the definition of deafness.','9411DB74-237D-4858-B573-1626AE232675','02')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('285C3C64-ED17-4BCF-8CBF-C720681112A8','Intellectual Disability','<b>Definition:</b> Intellectual Disability means significantly subaverage general intellectual functioning, existing concurrently with deficits in adaptive behavior and manifested during the developmental period, that adversely affects a child’s educational performance.','73783E65-D10C-42D9-9096-B413F4CC17DA','01')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('CA41A561-16BE-4E21-BE8A-BC59ED86C921','Multiple Disabilities','<b>Definition:</b> Multiple disabilities means concomitant impairments (such as mental, retardation-blindness, mental retardation-orthopedic impairment, etc.), the combination of which causes such severe educational needs that they cannot be accommodated in special education programs solely for one of the impairments.  The term does not include deaf-blindness.','50D6EC12-7A01-4F74-BB0A-898BB262FCAE','10')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('B9776137-2E71-4B1B-8536-D66E3E03C1F8','Deaf-Blindness','<b>Definition:</b> Deaf-blindness means concomitant hearing and visual impairments, the combination of which causes such severe communication and other developmental and educational needs that they cannot be accommodated in special education programs solely for children with deafness or children with blindness.','9C6BCB29-9ECE-46F3-97B0-24614AD7902E','09')
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('63BF2138-AD11-4E0A-823C-2901BA6E5DDE','None','','','99')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('160FFBB1-03C4-4945-A775-01614E9A6A2B','Orthopedic Impairments','<b>Definition:</b> Orthopedic impairment means a severe orthopedic impairment that adversely affects a child’s educational performance.  The term includes impairments caused by congenital anomaly (e.g., clubfoot, absence of some member, etc.), impairments caused by disease (e.g., poliomyelitis, bone tuberculosis, etc.), and impairments from other causes (e.g., cerebral palsy, amputations, and fractures or burns that cause contractions).','10B2B3DF-9F8B-4D7B-A585-7FDF89AB2C86','06')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('F717B282-C8D9-4EA4-8A7A-EB4411C34D16','Other Health Impairments','<b>Definition:</b> Other health impairment means having limited strength, vitality or alertness, including a heightened alertness to environmental stimuli, that results in limited alertness with respect to the educational environment, that due to chronic or acute health problems such as asthma, attention deficit disorder or attention deficit hyperactivity disorder, diabetes, epilepsy, a heart condition, hemophilia, lead poisoning, leukemia, nephritis, rheumatic fever, and sickle cell anemia, adversely affects a child’s education performance.','9AE72D98-93B2-4DE1-9953-C8D088F56D1E','07')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('46E8ADDC-4F9B-4A32-99B1-809DEE1CFF1B','Deafness','<b>Definition:</b> Deafness means a hearing impairment that is so severe that the child is impaired in processing linguistic information through hearing, with or without amplification that adversely affects a child’s educational performance.','17678C14-DC25-4203-88B3-E54D4A16D941','14')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('FA81FF15-0E35-4829-9ECC-23AD31B26EDB','Developmental Delay','<b>Definition:</b> Delay in physical development, cognitive development, communication development, social or emotional development, or adaptive development (may include children from three through nine years of age.)','E8B7649A-A181-4226-88B5-A640C9B11DA6','13')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('D0306BB5-7B69-48BB-ABA1-8E8FC4C74EF2','Emotional Disability','<b>Definition:</b> Emotional disability (includes schizophrenia but does not apply to children who are socially maladjusted unless it is determined that they have an emotional disturbance) means a condition exhibiting one or more of the following characteristics over a long period of time and to a marked degree that adversely affects a child’s educational performance:','E056471C-C8F2-472E-A992-8428824C7E71','05')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('0E026822-6B22-43A1-BD6E-C1412E3A6FA3','Specific Learning Disability','<b>Definition:</b> Specific Learning Disability means a disorder in one or more of the basic psychological processes involved in understanding or in using language, spoken or written, that may manifest itself in the imperfect ability to listen, think, speak, read, write, spell or do mathematical calculations, including conditions such as perceptual disabilities, brain injury, minimal brain dysfunction, dyslexia, and developmental aphasia. Specific Learning Disability does not include problems that are primarily the result of: visual, hearing, or motor disabilities; significant limited intellectual capacity; significant identifiable emotional disability; cultural factors; environmental or economic disadvantage; or limited English proficiency. The specific learning disability prevents a student from receiving reasonable educational benefit from general education alone.','55E49B38-0F76-4D32-8E3C-C308CF3ADF37','08')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09','Speech or Language Impairment','<b>Definition:</b> Speech or language impairment means a communication disorder, such as stuttering, impaired articulation, language impairment, or a voice impairment, that adversely affects a child educational performance.','5EC5E4BF-43C2-4CE5-8400-F7B81B2E0A7A','03')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3','Traumatic Brain Injury','<b>Definition:</b> Traumatic brain injury means an acquired injury to the brain caused by an external physical force, resulting in total or partial functional disability or psychosocial impairment, or both that adversely affects a child educational performance. The term applies to open or closed head injuries resulting in impairments in one or more areas, such as cognition; language; memory; attention; reasoning; abstract thinking; judgement; problem-solving; sensory, perceptual, and motor abilities; psychosocial behavior; physical functions; information processing; and speech. The term does not apply to brain injuries that are congenital or degenerative, or to brain injuries induced by birth trauma.','802F7E2A-6850-431A-AAFA-77D1A1496EF2','12')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values  ('D31E4ED0-9A37-490F-B49B-FF18133644FE','Vision Impairment, Including Blindness','<b>Definition:</b> Visual impairment including blindness means an impairment in vision that, even with correction, adversely affects a child’s educational performance.  The term includes both partial sight and blindness.','71BE7387-5ED1-470C-9A79-0C0974A9627E','04')



--select * from IepDisability order by name

---- insert test
select t.ID, t.Name, t.Definition, t.DeterminationFormTemplateID, t.StateCode
from IepDisability x right join
@IepDisability t on x.ID = t.ID 
where x.ID is null order by x.Name

---- delete test
select x.*, t.StateCode
from IepDisability x left join
@IepDisability t on x.ID = t.ID 
where t.ID is null order by x.Name


declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50), @toss varchar(50);

begin tran FixDisab


/* ============================================================================= NOTE ============================================================================= 

	This cursor is to delete as many values as possible without having to MAP them visually below in order to save time and effort that would be required to 
	match them by sight.

   ============================================================================= NOTE ============================================================================= */


--declare T cursor for 
--select x.ID
--from IepDisability x left join
--@IepDisability t on x.ID = t.ID 
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
--		and OBJECT_NAME (f.referenced_object_id) = 'IepDisability' ------------------------- Table name here
--		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID' --------------- Column name here
--	order by SchemaName, TableName, ColumnName

--	open R
--	fetch R into @relschema, @RelTable, @relcolumn

--	while @@fetch_status = 0
--	begin

-- 	exec ('delete x from dbo.IepDisability x left join '+@RelTable+' r on x.ID = r.'+@RelColumn+' where x.ID = '''+@toss+''' and r.'+@RelColumn+' is null')

---- print 

--	fetch R into @relschema, @RelTable, @relcolumn
--	end
--	close R
--	deallocate R

--fetch T into @toss
--end
--close T
--deallocate T



---- delete test -------------------------------------------------------- If there remain no values to be updated, the following query will return 0 rows.  
---- In this case the section "populate MAP" can be skipped
select x.*, t.StateCode
from IepDisability x left join
@IepDisability t on x.ID = t.ID 
where t.ID is null order by x.Name



-- update state code
update x set StateCode = t.StateCode
-- select g.*, t.StateCode
from IepDisability x left join
@IepDisability t on x.ID = t.ID 

-- insert missing.  This has to be done before updating the records to be deleted and before deleting.
insert IepDisability (ID, Name, Definition, DeterminationFormTemplateID, StateCode, IsOutOfState)
select t.ID, t.Name, t.Definition, t.DeterminationFormTemplateID, t.StateCode, 0
from IepDisability x right join
@IepDisability t on x.ID = t.ID 
where x.ID is null
order by x.Name



declare @MAP_IepDisability table (KeepID uniqueidentifier, TossID uniqueidentifier)


/* ============================================================================= NOTE ============================================================================= 

	It is expected that the ID values in the rows below for Autism, Hearing Impairment, Preschooler with a Disability, Serious Emotional and Vision Impairment
	will need to be updated for all hosted districts in Coloardo.  
	
	HOWEVER
	
	it is very important to verify that these are the only values need to be updated / deleted.  Please use the     "delete test"    query above to verify.

   ============================================================================= NOTE ============================================================================= */


--B9AAA2A4-A395-4BF2-B5C1-6AF98CCEA676	Autism Spectrum Disorders
--D1CFA1E9-D8D8-4317-92A4-94621F5C3466	Hearing Impairment, Including Deafness
--1D0B34DD-55BF-42EB-A0CA-7D2542EBC059	Preschooler with a Disability
--7599B90D-8842-4B49-9BFC-B5CDBAAAA074	Serious Emotional Disability
--CF411FEB-F76E-4EC0-BE2F-0F84AA453292	Vision Impairment, Including Blindness

-- populate MAP
-- this needs to be done by visual inspection because IepDisability names can vary widely
--insert @MAP_IepDisability  values ('8D9B3B54-4080-4D5E-A196-956D5223E479','')--'Autism Spectrum Disorders'
--insert @MAP_IepDisability  values ('36032F6B-C23D-4B24-BA1A-82C29D6B0D9F','')--'Hearing Impairment, Including Deafness'
insert @MAP_IepDisability  values ('285C3C64-ED17-4BCF-8CBF-C720681112A8','E9CD7BC7-E84F-4D27-B4E3-F11882173AF2')--'Intellectual Disability'
--insert @MAP_IepDisability  values ('CA41A561-16BE-4E21-BE8A-BC59ED86C921','')--'Multiple Disabilities'
--insert @MAP_IepDisability  values ('B9776137-2E71-4B1B-8536-D66E3E03C1F8','')--'Deaf-Blindness'
--insert @MAP_IepDisability  values ('63BF2138-AD11-4E0A-823C-2901BA6E5DDE','')--'None'
--insert @MAP_IepDisability  values ('160FFBB1-03C4-4945-A775-01614E9A6A2B','')--'Orthopedic Impairments'
--insert @MAP_IepDisability  values ('F717B282-C8D9-4EA4-8A7A-EB4411C34D16','')--'Other Health Impairments'
--insert @MAP_IepDisability  values ('46E8ADDC-4F9B-4A32-99B1-809DEE1CFF1B','')--'Deafness'
--insert @MAP_IepDisability  values ('FA81FF15-0E35-4829-9ECC-23AD31B26EDB','')--'Developmental Delay'
--insert @MAP_IepDisability  values ('D0306BB5-7B69-48BB-ABA1-8E8FC4C74EF2','')--'Emotional Disability'
--insert @MAP_IepDisability  values ('0E026822-6B22-43A1-BD6E-C1412E3A6FA3','')--'Specific Learning Disability'
--insert @MAP_IepDisability  values ('96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09','')--'Speech or Language Impairment'
--insert @MAP_IepDisability  values ('E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3','')--'Traumatic Brain Injury'
--insert @MAP_IepDisability  values ('D31E4ED0-9A37-490F-B49B-FF18133644FE','')--'Vision Impairment, Including Blindness'

-- list all tables with FK on GradeLevel and update them 


declare I cursor for 
select KeepID, TossID from @MAP_IepDisability 

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
		and OBJECT_NAME (f.referenced_object_id) = 'IepDisability' ------------------------- Table name here
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
from IepDisability x join
@MAP_IepDisability t on x.ID = t.TossID 

commit tran FixDisab
--Rollback tran FixDisab 

---- insert test (should return no rows)
select t.ID, t.Name, t.Definition, t.DeterminationFormTemplateID, t.StateCode
from IepDisability x right join
@IepDisability t on x.ID = t.ID 
where x.ID is null order by x.Name

---- delete test (should return no rows)
select x.*, t.StateCode
from IepDisability x left join
@IepDisability t on x.ID = t.ID 
where t.ID is null order by x.Name

-- View the final result.  Compare to the SelectLists template 
select ID,Name,Definition,DeterminationFormTemplateID,StateCode from IepDisability d order by d.Name

