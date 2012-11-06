set nocount on;
declare @SelectLists table (Type varchar(20), SubType varchar(20), EnrichID uniqueidentifier, StateCode varchar(10), EnrichLabel varchar(254))

insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '0E026822-6B22-43A1-BD6E-C1412E3A6FA3', '01', 'Specific Learning Disability')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'BF42D497-E9A0-436B-8F86-6FF9DD2F648E', '02', 'Cognitive Impairment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09', '04', 'Speech Impairment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'E26404CB-F3D2-44CA-9F82-82AFDAA90735', '05', 'Language Impairment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '96AB644C-1AFE-4D75-8A94-39F832D558E0', '06', 'Emotional Disturbance')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '3ECBA21A-577B-4973-A074-F040127EB736', '07', 'Health Impairment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'CA10B0A9-D7CB-4709-9A70-36D8E18D988F', '08', 'Orthopedic Impairment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '7A8F92E3-92BB-4B32-A958-174ABED2B17E', '09', 'Deafness')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'D1CFA1E9-D8D8-4317-92A4-94621F5C3466', '10', 'Hearing Impairment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'CF411FEB-F76E-4EC0-BE2F-0F84AA453292', '11', 'Vision Impairment, Including Blindness')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '1DB91C77-1898-463B-AC07-A9E7534FFB5E', '12', 'Deaf-Blindness')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'CA41A561-16BE-4E21-BE8A-BC59ED86C921', '13', 'Multiple Disabilities')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '0AF6F9ED-D011-4FBE-83F4-33B4BC657FD3', '14', 'Developmental Delay')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'B9AAA2A4-A395-4BF2-B5C1-6AF98CCEA676', '15', 'Autism')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3', '16', 'Traumatic Brain Injury')

--==================================================================================================================
--								Disability
--==================================================================================================================
select * from @SelectLists where Type = 'Disab' order by EnrichLabel
select * from IepDisability d order by d.Name

declare @IepDisability table (ID uniqueidentifier, Name varchar(50), Definition text, DeterminationFormTemplateID uniqueidentifier)

insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values ('B9AAA2A4-A395-4BF2-B5C1-6AF98CCEA676','Autism','<b>Definition:</b> Autism is a developmental disability, generally evident before age 3, significantly affecting verbal and nonverbal communication and social interaction, and adversely affecting educational performance. A student who manifests the characteristics of autism after age 3 could be diagnosed as having autism. Other characteristics often associated with autism include, but are not limited to, engagement in repetitive activities and stereotyped movements, resistance to environmental change or change in daily routines, and unusual responses to sensory experiences. Characteristics vary from mild to severe as well as in the number of symptoms present. Diagnoses may include, but are not limited to, the following autism spectrum disorders: Childhood Disintegrative Disorder, Autistic Disorder, Asperger’s Syndrome, or Pervasive Developmental Disorder: Not Otherwise Specified (PDD:NOS).',NULL)
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
('BF42D497-E9A0-436B-8F86-6FF9DD2F648E','Cognitive Impairment','<b>Definition:</b> Cognitive impairment is defined as significantly sub-average intellectual functioning that exists concurrently with deficits in adaptive behavior. These deficits are manifested during the student’s developmental period, and adversely affect the student’s educational performance.',NULL)
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
('1DB91C77-1898-463B-AC07-A9E7534FFB5E','Deaf-Blindness','<b>Definition:</b> A student with deaf-blindness demonstrates both hearing and visual impairments, the combination of which causes such severe communication and other developmental and educational needs that the student cannot be appropriately educated with special education services designed solely for students with deafness or blindness.',
NULL)
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
('7A8F92E3-92BB-4B32-A958-174ABED2B17E','Deafness','<b>Definition:</b> Deafness is a hearing impairment that adversely affects educational performance and is so severe that with or without amplification the student is limited in processing linguistic information through hearing.',NULL)
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
('0AF6F9ED-D011-4FBE-83F4-33B4BC657FD3','Developmental Delay','<b>Definition:</b> The term developmental delay may be used only for students ages 3 through 9 who are experiencing developmental delays as measured by appropriate diagnostic instruments and procedures in one or more of the following areas: (1) cognitive development – includes skills involving perceptual discrimination, memory, reasoning, academic skills, and conceptual development; (2) physical development – includes skills involving coordination of both the large and small muscles of the body (i.e., gross, fine, and perceptual motor skills); (3) communication development – includes skills involving expressive and receptive communication abilities, both verbal and nonverbal; (4) social or emotional development – includes skills involving meaningful social interactions with adults and other children including self-expression and coping skills; or (5) adaptive development – includes daily living skills (e.g., eating, dressing, and toileting) as well as skills involving attention and personal responsibility.',NULL)
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
('96AB644C-1AFE-4D75-8A94-39F832D558E0','Emotional Disturbance','<b>Definition:</b> A student with emotional disturbance has a condition exhibiting one or more of the following characteristics over a long period of time, and to a marked degree, that adversely affects his or her educational performance: (1) an inability to learn that cannot be explained by intellectual, sensory, or health factors; (2) an inability to build or maintain satisfactory interpersonal relationships with peers and teachers; (3) inappropriate types of behavior or feelings under normal circumstances; (4) a general pervasive mood of unhappiness or depression; or (5) a tendency to develop physical symptoms or fears associated with personal or school problems.  The term <i>does not</i> include students who are socially maladjusted unless it is determined they have an emotional disturbance. The term emotional disturbance <i>does</i> include students who are diagnosed with schizophrenia.',NULL)
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
('3ECBA21A-577B-4973-A074-F040127EB736','Health Impairment','',NULL)
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
('D1CFA1E9-D8D8-4317-92A4-94621F5C3466','Hearing Impairment','<b>Definition:</b> A hearing impairment is a permanent or fluctuating hearing loss that adversely affects a student’s educational performance but is not included under the category of deafness.
Language Impairment	<b>Definition:</b> A language impairment exists when there is a disorder or delay in the development of comprehension and/or the uses of spoken or written language and/or other symbol systems. The impairment may involve any one or a combination of the following: (1) the form of language (morphological and syntactic systems); (2) the content of language (semantic systems); and/or (3) the function of language in communication (pragmatic systems).',NULL)
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
('E26404CB-F3D2-44CA-9F82-82AFDAA90735','Language Impairment','<b>Definition:</b> A language impairment exists when there is a disorder or delay in the development of comprehension and/or the uses of spoken or written language and/or other symbol systems. The impairment may involve any one or a combination of the following: (1) the form of language (morphological and syntactic systems); (2) the content of language (semantic systems); and/or (3) the function of language in communication (pragmatic systems).',
NULL)
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
('CA41A561-16BE-4E21-BE8A-BC59ED86C921','Multiple Disabilities','<b>Definition:</b> Multiple disabilities are two or more co-existing severe impairments, one of which usually includes a cognitive impairment, such as cognitive impairment/blindness, cognitive impairment/orthopedic, etc. Students with multiple disabilities exhibit impairments that are likely to be life long, significantly interfere with independent functioning, and may necessitate environmental modifications to enable the student to participate in school and society. The term does not include deaf-blindness.',NULL)
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values
('CA10B0A9-D7CB-4709-9A70-36D8E18D988F','Orthopedic Impairment','<b>Definition:</b> Orthopedic impairment means a severe physical limitation that adversely affects a student’s educational performance. The term includes impairments caused by congenital anomaly (clubfoot, or absence of an appendage), an impairment caused by disease (poliomyelitis, bone tuberculosis, etc.), or an impairment from other causes (cerebral palsy, amputations, and fractures or burns that cause contracture).',NULL)
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values
('0E026822-6B22-43A1-BD6E-C1412E3A6FA3','Specific Learning Disability','<b>Definition:</b> Specific Learning Disability (SLD) means a disorder in one or more of the basic psychological processes involved in understanding or in using language, spoken or written, that may manifest itself in the imperfect ability to listen, think, speak, read, write, spell, or to do mathematical calculations, including conditions such as perceptual disabilities, brain injury, minimal brain dysfunction, dyslexia, and developmental aphasia. Specific Learning Disability does not include learning problems that are primarily the result of visual, hearing, or motor disabilities, of cognitive impairment, of emotional disturbance, or of environmental, cultural, or economic disadvantage.','714A1265-86A3-4166-8D9E-FE36BE7F6F71')
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values
('96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09','Speech Impairment','<b>Definition:</b> The term speech impairment includes articulation/phonology disorders, voice disorders, or fluency disorders that adversely impact a child’s educational performance: (1) Articulation disorders are incorrect productions of speech sounds including omissions, distortions, substitutions, and/or additions that may interfere with intelligibility. Phonology disorders are errors involving phonemes, sound patterns, and the rules governing their combinations; (2) A fluency disorder consists of stoppages in the flow of speech that is abnormally frequent and/or abnormally long. The stoppages usually take the form of repetitions of sounds, syllables, or single syllable words; prolongations of sounds; or blockages of airflow and/or voicing in speech; (3) Voice disorders are the absence or abnormal production of voice quality, pitch, intensity, or resonance. Voice disorders may be the result of a functional or an organic condition.',NULL)
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values
('E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3','Traumatic Brain Injury','<b>Definition:</b> Traumatic brain injury refers to an acquired injury to the brain caused by an external physical force resulting in a total or partial functional disability or psychosocial impairment, or both, that adversely affects educational performance. The term applies to open or closed head injuries resulting in impairments in one or more areas such as cognition, language, memory, attention, reasoning, abstract thinking, judgment, problem solving, sensory, perceptual and motor abilities, psychosocial behavior, physical functions, information processing, and speech. The term does not apply to congenital or degenerative brain injuries or to brain injuries induced by birth trauma.',NULL)
insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values
('CF411FEB-F76E-4EC0-BE2F-0F84AA453292','Vision Impairment, Including Blindness','<b>Definition:</b> Visual impairment refers to an impairment in vision that, even with correction, adversely affects a student’s educational performance. The term includes both partial sight and blindness. Partial sight refers to the ability to use vision as one channel of learning if educational materials are adapted. Blindness refers to the prohibition of vision as a channel of learning, regardless of the adaptation of materials.',NULL)

-- insert test
select t.EnrichID, t.EnrichLabel, ti.Definition, ti.DeterminationFormTemplateID, t.StateCode
from IepDisability x right join
(select * from @SelectLists where Type = 'Disab') t on x.ID = t.EnrichID JOIN 
 @IepDisability ti on t.EnrichID = ti.ID
where x.ID is null order by x.Name

-- delete test
select x.*, t.StateCode
from IepDisability x left join
(select * from @SelectLists where Type = 'Disab') t on x.ID = t.EnrichID 
where t.EnrichID is null order by x.Name


declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50), @toss varchar(50);

begin tran FixDisab


/* ============================================================================= NOTE ============================================================================= 

	This cursor is to delete as many values as possible without having to MAP them visually below in order to save time and effort that would be required to 
	match them by sight.

   ============================================================================= NOTE ============================================================================= */


-- delete test -------------------------------------------------------- If there remain no values to be updated, the following query will return 0 rows.  
-- In this case the section "populate MAP" can be skipped
select x.*, t.StateCode
from IepDisability x left join
(select * from @SelectLists where Type = 'Disab') t on x.ID = t.EnrichID 
where t.EnrichID is null order by x.Name



 --update state code
update x set StateCode = t.StateCode,
			 Definition = ti.Definition,
			 DeterminationFormTemplateID = ti.DeterminationFormTemplateID
 --select g.*, t.StateCode
from IepDisability x  join
(select * from @SelectLists where Type = 'Disab') t on x.ID = t.EnrichID JOIN 
 @IepDisability ti on t.EnrichID = ti.ID


 --insert missing.  This has to be done before updating the records to be deleted and before deleting.
insert IepDisability (ID, Name, Definition, DeterminationFormTemplateID, StateCode, IsOutOfState)
select t.EnrichID, t.EnrichLabel, ti.Definition, NULL, t.StateCode,0   ---Formtemplate table has no records
from IepDisability x right join
(select * from @SelectLists where Type = 'Disab') t on x.ID = t.EnrichID JOIN 
 @IepDisability ti on t.EnrichID = ti.ID
where x.ID is null order by x.Name


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
--insert @MAP_IepDisability  values ('BBB4773F-4A8A-49E5-A0D4-952D2A0D1F18', 'B9AAA2A4-A395-4BF2-B5C1-6AF98CCEA676') -- 'Autism Spectrum Disorders'
--insert @MAP_IepDisability  values ('0C02B702-D681-4C66-BA67-8F9D3847E6A9', 'D1CFA1E9-D8D8-4317-92A4-94621F5C3466') -- 'Hearing Impairment, Including Deafness'
--insert @MAP_IepDisability  values ('12F08D30-1ADA-4F9A-AD2A-EF5451BB2325', '') -- 'Intellectual Disability'
--insert @MAP_IepDisability  values ('CA41A561-16BE-4E21-BE8A-BC59ED86C921', '') -- 'Multiple Disabilities'
--insert @MAP_IepDisability  values ('07093979-0C3F-414D-9750-8080C6BB7C45', '') -- 'Physical Disability'
--insert @MAP_IepDisability  values ('917D79C8-8604-49E5-A64F-0ADCFD85819B', '1D0B34DD-55BF-42EB-A0CA-7D2542EBC059') -- 'Preschooler with a Disability'
--insert @MAP_IepDisability  values ('41500452-3FEB-4EBF-87A0-BFC5F385A973', '7599B90D-8842-4B49-9BFC-B5CDBAAAA074') -- 'Serious Emotional Disability'
--insert @MAP_IepDisability  values ('0E026822-6B22-43A1-BD6E-C1412E3A6FA3', '') -- 'Specific Learning Disability'
--insert @MAP_IepDisability  values ('96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09', '') -- 'Speech or Language Impairment'
--insert @MAP_IepDisability  values ('E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3', '') -- 'Traumatic Brain Injury'
--insert @MAP_IepDisability  values ('E77D061F-0E5B-4CF8-AB46-A0D4042E8601', 'CF411FEB-F76E-4EC0-BE2F-0F84AA453292') -- 'Vision Impairment, Including Blindness'

 --list all tables with FK on GradeLevel and update them 


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



 --delete unneeded
delete x
 --select g.*, t.StateCode
from IepDisability x join
@MAP_IepDisability t on x.ID = t.TossID 

commit tran FixDisab
----rollback tran FixDisab 