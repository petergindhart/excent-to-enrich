
set nocount on;
-- this needs to be run on the CDE Sandbox template for CO instanaces as well as on all CO import databases
declare @IepDisability table (ID uniqueidentifier, Name varchar(50), Definition text, DeterminationFormTemplateID uniqueidentifier, StateCode varchar(20), DeletedDate datetime)

insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values ('BBB4773F-4A8A-49E5-A0D4-952D2A0D1F18', 'Autism Spectrum Disorders', '<b>Definition:</b> A student with a physical disability in the area of autism spectrum disorder has a developmental disability significantly affecting verbal and non-verbal communication and social interaction, generally evident before age three that adversely affects a child’s educational performance. The autism prevents a child from receiving reasonable educational benefit from general education.', '4CE41830-47B9-47B9-878F-4E0C57CC18CF', '13')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values ('0C02B702-D681-4C66-BA67-8F9D3847E6A9', 'Hearing Impairment, Including Deafness', '<b>Definition:</b> A student with a hearing impairment, including deafness shall have a deficiency in hearing sensitivity as demonstrated by an elevated threshold of auditory sensitivity to pure tones or speech where, even with the help of amplification, the student is prevented from receiving reasonable educational benefit from general education.', '9411DB74-237D-4858-B573-1626AE232675', '05')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values ('12F08D30-1ADA-4F9A-AD2A-EF5451BB2325', 'Intellectual Disability', '<b>Definition:</b> A child with an intellectual disability shall have reduced general intellectual functioning, which prevents the child from receiving reasonable benefit from general education.  Reduced general intellectual capacity shall mean limited functioning or ability which usually originates in the developmental period and exists concurrently with impairment in adaptive behavior.', '73783E65-D10C-42D9-9096-B413F4CC17DA', '01')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values ('CA41A561-16BE-4E21-BE8A-BC59ED86C921', 'Multiple Disabilities', '<b>Definition:</b> A student with multiple disabilities shall have two or more areas of significant impairment, one of which shall be a cognitive impairment except in the case of deaf-blindness.  Cognitive impairment shall mean significant limited intellectual capacity.  The other areas of significant impairment include:  physical, visual, auditory, communicative or emotional.  The combination of such impairments creates a unique condition that is evidenced through a multiplicity of needs which prevents the student from receiving reasonable educational benefit from general education. The definition of impairment shall be the same as that for each of the single disabilities  (include determination of eligibility form for each disability identified).', '50D6EC12-7A01-4F74-BB0A-898BB262FCAE', '10')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values ('07093979-0C3F-414D-9750-8080C6BB7C45', 'Physical Disability', '<b>Definition:</b> A child with a physical disability shall have a sustained illness or disabling physical condition which prevents the child from receiving reasonable educational benefit from general education. A sustained illness means a prolonged, abnormal physical condition requiring continued monitoring characterized by limited strength, vitality, or alertness due to chronic or acute health problems and a disabling condition means a severe physical impairment.  Conditions such as, but not limited to, traumatic brain injury, autism, attention deficit disorder and cerebral palsy may qualify as a physical disability, if they prevent a child from receiving reasonable educational benefit from general education.', '878A69B8-0E3D-4031-B9B4-A65541BE25B6', '07')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values ('917D79C8-8604-49E5-A64F-0ADCFD85819B', 'Preschooler with a Disability', '<b>Definition:</b> A preschooler with a disability shall be three through five years of age and shall, by reason of one or more of the following conditions, be unable to receive reasonable educational benefit from general education:  long-term physical impairment or illness, significant limited intellectual capacity, significant identifiable emotional disorder, specific learning disability or speech language impairment.', '58147D79-2213-4C32-8481-0420615125A8', '11')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values ('41500452-3FEB-4EBF-87A0-BFC5F385A973', 'Serious Emotional Disability', '<b>Definition:</b> A child with a serious emotional disability shall have emotional or social functioning, which prevents the child from receiving reasonable benefit from general education.', '14DCBC68-E999-4EB6-B5DF-D7BEA576A9EF', '03')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values ('0E026822-6B22-43A1-BD6E-C1412E3A6FA3', 'Specific Learning Disability', '<b>Definition:</b> Specific Learning Disability means a disorder in one or more of the basic psychological processes involved in understanding or in using language, spoken or written, that may manifest itself in the imperfect ability to listen, think, speak, read, write, spell or do mathematical calculations, including conditions such as perceptual disabilities, brain injury, minimal brain dysfunction, dyslexia, and developmental aphasia. Specific Learning Disability does not include problems that are primarily the result of: visual, hearing, or motor disabilities; significant limited intellectual capacity; significant identifiable emotional disability; cultural factors; environmental or economic disadvantage; or limited English proficiency. The specific learning disability prevents a student from receiving reasonable educational benefit from general education alone.', '55E49B38-0F76-4D32-8E3C-C308CF3ADF37', '04')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values ('96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09', 'Speech or Language Impairment', '<b>Definition:</b> A student with a speech or language impairment shall have a communicative disorder which prevents the student from receiving reasonable educational benefit from general education.', '5EC5E4BF-43C2-4CE5-8400-F7B81B2E0A7A', '08')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values ('E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3', 'Traumatic Brain Injury', '<b>Definition:</b> Traumatic brain injury (TBI) means an acquired injury to the brain caused by an external physical force, resulting in total or partial functional disability or psychosocial impairment, or both, that adversely affects a child''s educational performance. Traumatic brain injury applies to open or closed head injuries resulting in impairments in one or more areas, such as: cognition; language; memory; attention; reasoning; abstract thinking; judgment; problem-solving; sensory, perceptual, and motor abilities; psychosocial behavior; physical functions; information processing; and speech. Traumatic brain injury does not apply to brain injuries that are congenital or degenerative, or to brain injuries induced by birth trauma.', '802F7E2A-6850-431A-AAFA-77D1A1496EF2', '14')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID, StateCode) values ('E77D061F-0E5B-4CF8-AB46-A0D4042E8601', 'Vision Impairment, Including Blindness', '<b>Definition:</b> A student with vision impairment, including blindness shall have a deficiency in visual acuity and/or visual field and/or visual performance where, even with the use of lenses or corrective devices, he/she is prevented from receiving reasonable educational benefit from general education.', '71BE7387-5ED1-470C-9A79-0C0974A9627E', '06')

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


declare T cursor for 
select x.ID
from IepDisability x left join
@IepDisability t on x.ID = t.ID 
where t.ID is null 

open T
fetch T into @toss

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
		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID' --------------- Column name here
	order by SchemaName, TableName, ColumnName

	open R
	fetch R into @relschema, @RelTable, @relcolumn

	while @@fetch_status = 0
	begin

 	exec ('delete x from dbo.IepDisability x left join '+@RelTable+' r on x.ID = r.'+@RelColumn+' where x.ID = '''+@toss+''' and r.'+@RelColumn+' is null')

-- print 

	fetch R into @relschema, @RelTable, @relcolumn
	end
	close R
	deallocate R

fetch T into @toss
end
close T
deallocate T



---- delete test -------------------------------------------------------- If there remain no values to be updated, the following query will return 0 rows.  
---- In this case the section "populate MAP" can be skipped
--select x.*, t.StateCode
--from IepDisability x left join
--@IepDisability t on x.ID = t.ID 
--where t.ID is null order by x.Name



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


-- populate MAP
-- this needs to be done by visual inspection because IepDisability names can vary widely
insert @MAP_IepDisability  values ('BBB4773F-4A8A-49E5-A0D4-952D2A0D1F18', 'B9AAA2A4-A395-4BF2-B5C1-6AF98CCEA676') -- 'Autism Spectrum Disorders'
insert @MAP_IepDisability  values ('0C02B702-D681-4C66-BA67-8F9D3847E6A9', 'D1CFA1E9-D8D8-4317-92A4-94621F5C3466') -- 'Hearing Impairment, Including Deafness'
--insert @MAP_IepDisability  values ('12F08D30-1ADA-4F9A-AD2A-EF5451BB2325', '') -- 'Intellectual Disability'
--insert @MAP_IepDisability  values ('CA41A561-16BE-4E21-BE8A-BC59ED86C921', '') -- 'Multiple Disabilities'
--insert @MAP_IepDisability  values ('07093979-0C3F-414D-9750-8080C6BB7C45', '') -- 'Physical Disability'
insert @MAP_IepDisability  values ('917D79C8-8604-49E5-A64F-0ADCFD85819B', '1D0B34DD-55BF-42EB-A0CA-7D2542EBC059') -- 'Preschooler with a Disability'
insert @MAP_IepDisability  values ('41500452-3FEB-4EBF-87A0-BFC5F385A973', '7599B90D-8842-4B49-9BFC-B5CDBAAAA074') -- 'Serious Emotional Disability'
--insert @MAP_IepDisability  values ('0E026822-6B22-43A1-BD6E-C1412E3A6FA3', '') -- 'Specific Learning Disability'
--insert @MAP_IepDisability  values ('96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09', '') -- 'Speech or Language Impairment'
--insert @MAP_IepDisability  values ('E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3', '') -- 'Traumatic Brain Injury'
insert @MAP_IepDisability  values ('E77D061F-0E5B-4CF8-AB46-A0D4042E8601', 'CF411FEB-F76E-4EC0-BE2F-0F84AA453292') -- 'Vision Impairment, Including Blindness'


--B9AAA2A4-A395-4BF2-B5C1-6AF98CCEA676	Autism Spectrum Disorders
--D1CFA1E9-D8D8-4317-92A4-94621F5C3466	Hearing Impairment, Including Deafness
--1D0B34DD-55BF-42EB-A0CA-7D2542EBC059	Preschooler with a Disability
--7599B90D-8842-4B49-9BFC-B5CDBAAAA074	Serious Emotional Disability
--CF411FEB-F76E-4EC0-BE2F-0F84AA453292	Vision Impairment, Including Blindness

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


------ insert test (should return no rows)
--select t.ID, t.Name, t.Definition, t.DeterminationFormTemplateID, t.StateCode
--from IepDisability x right join
--@IepDisability t on x.ID = t.ID 
--where x.ID is null order by x.Name

------ delete test (should return no rows)
--select x.*, t.StateCode
--from IepDisability x left join
--@IepDisability t on x.ID = t.ID 
--where t.ID is null order by x.Name

-- View the final result.  Compare to the SelectLists template 
--select * from IepDisability d order by d.Name

