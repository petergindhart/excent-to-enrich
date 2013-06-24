
begin tran SelectListsMod

declare @district varchar(50) ; select @district = case when Name not like '%Poudre%' then 'Aurora' else 'Poudre' end from OrgUnit where ID = (select top 1 OrgUnitID from School group by OrgUnitID order by COUNT(*) desc)


set nocount on;
declare @EnumValue table (
ID	uniqueidentifier NOT NULL,
Type	uniqueidentifier NOT NULL,
DisplayValue	varchar(512) NOT NULL,
Code	varchar(8),
IsActive	bit NOT NULL,
Sequence	int,
StateCode	varchar(50)
)


-- RACE
insert @EnumValue values ('E1611EE9-7FC3-4CEF-80D6-D67EE6EE1F6F', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Race: American Indian or Alaska Native', '01', 1, 0, '01')
insert @EnumValue values ('953025B8-4102-4C8F-B8AB-766068ACC978', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Race: Asian', '02', 1, 1, '02')
insert @EnumValue values ('628814D0-09B4-4B77-A1A7-A9CEEC360C2B', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Race: Black or African American', '03', 1, 2, '03')
insert @EnumValue values ('68F95480-110E-45EB-84DC-566A930E8C67', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Ethnicity: Hispanic or Latino', '04', 1, 3, '04')
insert @EnumValue values ('3A074939-80D2-4138-97E9-149345528E9F', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Race: White', '05', 1, 4, '05')
insert @EnumValue values ('80034B85-658B-497E-8793-E2382CB6AF51', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Race: Native Hawaiian or Other Pacific Islander', '06', 1, 5, '06')
insert @EnumValue values ('E97F2925-C985-4C26-BC60-1F0B42C1719D', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Race: Two or more races', '07', 1, 6, '07')


update ev 
set IsActive = 0
from EnumValue ev 
where Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535'
and ID not in (select ID from @EnumValue)





-- insert the special education state-reporting exit reasons
declare @PrgStatus table (
ID	uniqueidentifier NOT NULL,
ProgramID	uniqueidentifier NOT NULL,
Sequence	int NOT NULL,
Name	varchar(50) NOT NULL,
IsExit	bit NOT NULL,
IsEntry	bit NOT NULL,
DeletedDate	datetime,
StatusStyleID	uniqueidentifier NOT NULL,
StateCode	varchar(20),
Description	text
)

insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('01F29D3D-F871-453A-BA58-538110B1A191', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 12, 'Reached Maximum Age for Services', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '01', 'A student who left school because he or she has reached the maximum age to receive an education program allowed by federal, state, or local laws.')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('1830F6F5-2433-401D-B709-35267D5AF1EF', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 13, 'Death', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '02', 'A student whose membership is terminated because he or she died during or between regular school sessions.')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('4C809168-6D25-4B48-A9EA-0C1C9CB49D39', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 14, 'PK-6 Student Exited to an Unknown Setting/Status', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '06', 'Applicable ONLY to students in grades PK – 6. Applicable if the reporting district does not have information about the educational environment into which a student transferred. If the educational environment to which the student transferred is known, use the appropriate exit code (13 if transferring to another Colorado district, 14 if transferring to another state or country, etc.). Note that districts are required to obtain documentation of transfer for students exiting grades PK – 6.')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('56EC7143-B0D0-45BA-9AB0-1D06B61D3797', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 15, 'Transferred to Regular Education', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '09', 'A student who was served in Special Education at the start of the reporting period, but at some point during that 12-month period, returned to regular education. These are students who no longer have an IEP and are receiving all of their educational services from a regular education program (This code is not intended for students for whom the parent has revoked consent for services; for these students use code 60).')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('DABF1AAB-A174-42C6-86AB-2BA5858B6C0A', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 16, 'Transfer to a Different School District', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '13', 'A student who transfers to a public school in another school district/BOCES within the state (examples: a Special Education student who transfers to another administrative unit and is known to be continuing in a Special Education program, a student going to a detention center run by another school district, etc.). (This code should be used for students who transfer to CSDB or CMHI-Pueblo)')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('179C52E2-A6D6-4D53-A34A-2C9F71A382CB', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 17, 'Transfer to a Different State/Country', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '14', 'A student who transfers to a public school located in another state or country. This transfer must be documented by either an education records request from the receiving school, a signed confirmation of enrollment and attendance, or an official confirmation of emigration from a federal agency.')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('A2CB8201-6C72-41E9-966D-2E275098EF04', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 18, 'Transfer to a Non-Public School', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '15', 'A student who transfers to receiving an education program at a non-public school.')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('EC832058-A658-413B-83C6-357DFD1A339F', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 19, 'Transfer to Home-Based Education (home schooling)', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '16', 'A student who transfers to receiving an education program in a home-based education environment for reasons other than health.')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('27A6AD68-C5A6-4EFB-B31B-3C64129B8DC9', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 20, 'Transfer to a non-district Career program', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '18', 'A student who Transfers to an occupational training program, recognized but not administered by the school district, that leads to a certificate or other evidence of completion. (e.g., Job Corps)')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('DCAF4731-08DE-4141-9B95-70E15F6F5EF0', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 21, 'Transfer to Department of Corrections', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '21', 'Student is incarcerated in a correctional facility. NOTE: Students transferring to a detention center not operated by the reporting administrative unit should be coded with a 13 exit code (if the detention center is operated by a district within your administrative unit, this student should not be exited).')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('0BCE4325-A730-4149-AC3F-8A7CB899BF98', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 22, 'Discontinued Schooling/Dropped Out', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '40', 'A student who was enrolled in school at any time during the reporting period, but leaves school for any reason other than one of the following exclusionary conditions: 1) transfers (with official documentation) to another public school district, private school, home based education program or other state/district approved educational program; 2) temporary absence due to suspension or expulsion; or 3) serious illness or death. This would also include a student who was in membership the previous school year and who does not meet the above exclusionary conditions and does not return to school prior to the end of the school year.')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('8F400377-71D0-4823-AF7E-B4008FBE8121', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 23, 'Expulsion', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '50', 'A student who leaves school involuntarily due to an expulsion approved by appropriate school authorities and is not receiving any education benefits. Students who receive education benefits (such as tutoring) during expulsion are not considered expelled/exited for EOY purposes.')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('81B59F4C-45A4-4977-AAA7-B6F1C45C6854', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 24, 'Parent Revokes Consent for Services', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '60', 'Subsequent to the initial provision of Special Education and related services, the parent revokes consent.')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('4B3C2CF0-0815-4196-A876-C1E8A3908990', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 25, 'GED Transfer', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '70', 'A student exits to participate in a GED preparation program not administered by the district (i.e. a GED program offered through an institution of higher education).')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('F309BBFE-29C9-466A-BA32-DFC3A69E4AAD', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 26, 'Graduated with Regular Diploma', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '90', 'A student who received a regular high school diploma upon completion of local requirements for both course work and assessment. Includes students with disabilities who meet all requirements of an IEP aligned with state standards.')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('95A51BA1-1D83-4A68-9A62-8037AE01CE02', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 27, 'Completed (non-diploma certificate)', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '92', 'A student who has received a certificate of completion, attendance, or achievement. Also includes students who have not received a high school diploma but have been granted admission to an institution of higher education.')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('D5B55B2F-3E6C-44B9-A084-C37204B6E0C4', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 28, 'General Education Development Certificate (GED)', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '93', 'A student who has received a GED certificate upon completion of a GED preparation program administered by the reporting district.')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description) values ('3B0CEB51-01F5-4917-B28E-EAB3192FA3A9', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 29, 'GED certificate from a non-district run program', 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '94', 'Student received GED certificate from a non-district run program in the same school year in which s/he transferred to the GED program')

declare @GradeLevel table (
Customer varchar(50) not null,
ID	uniqueidentifier NOT NULL,
Name	varchar(10) NULL,
Active	bit NULL,
BitMask	int,
Sequence	int NULL,
StateCode	varchar(10) NULL
)

-- Insert ommited State values
insert @GradeLevel values ('Aurora/Poudre', 'C808C991-CA93-4F51-AF41-A8BA494AC10F', 'Infant', 1, 0, 0, '002') -- may set Active = 0 on a case-by-case basis
insert @GradeLevel values ('Aurora', 'D90C08C8-683F-4C2B-9D1F-769D904CD060', 'PK', 1, 0, 0, '004')
insert @GradeLevel values ('Aurora/Poudre', '4B0ED575-7C9A-451D-A8E6-2D9F22F31349', 'K Half Day', 1, 0, 0, '006')
insert @GradeLevel values ('Poudre', 'ECC42A34-8B47-45EA-A533-AA13476BE299', 'K Full Day', 1, 0, 0, '007')

-- records to update
insert @GradeLevel (Customer, StateCode, Name, ID) values ('Aurora/Poudre', '007', 'K Full Day', 'ECC42A34-8B47-45EA-A533-AA13476BE299')
insert @GradeLevel (Customer, StateCode, ID) values ('Aurora', '010', '1746A7BD-D878-423B-8B45-859F4B158F86')
insert @GradeLevel (Customer, StateCode, ID) values ('Aurora', '020', '81A1FD30-4FF0-4450-8337-941AB5ABEB3F')
insert @GradeLevel (Customer, StateCode, ID) values ('Aurora', '030', '63A534B6-D88D-4198-8CF2-D5D79D24AC7F')
insert @GradeLevel (Customer, StateCode, ID) values ('Aurora', '040', '88236013-C5C8-4E10-9DF3-9F2ABE22D908')
insert @GradeLevel (Customer, StateCode, ID) values ('Aurora', '050', '6CA10279-7AC4-452B-B518-A8A45D0C9539')
insert @GradeLevel (Customer, StateCode, ID) values ('Aurora', '060', 'CA97A52A-7E87-46DD-8ED4-FA01C954CAA1')
insert @GradeLevel (Customer, StateCode, ID) values ('Aurora', '070', '8313E4F8-D6FB-4308-8EE0-F200C7481996')
insert @GradeLevel (Customer, StateCode, ID) values ('Aurora', '080', 'F6B5A07F-D78A-4DCF-915A-1E924E019467')
insert @GradeLevel (Customer, StateCode, ID) values ('Aurora', '090', 'E09CADF6-BAEF-4C78-810F-7949BB9A0CAD')
insert @GradeLevel (Customer, StateCode, ID) values ('Aurora', '100', '2D434E66-6638-4008-86E1-208E555ECED8')
insert @GradeLevel (Customer, StateCode, ID) values ('Aurora', '110', 'AE342FDF-02DB-44A0-8916-161145D41D30')
insert @GradeLevel (Customer, StateCode, ID) values ('Aurora', '120', '86694A97-4DEB-44BE-9D22-6D7273B42319')
insert @GradeLevel (Customer, Active, ID) values ('Aurora/Poudre', 0, '7269BD32-C052-455B-B3E3-FF5BCB199679')

-- update existing values StateCode (Aurora values)
insert @GradeLevel (Customer, StateCode, ID) values ('Poudre', '010', '07975B7A-8A1A-47AE-A71F-7ED97BA9D48B')
insert @GradeLevel (Customer, StateCode, ID) values ('Poudre', '020', 'DDC4180A-64FC-49BD-AC11-DAA185059885')
insert @GradeLevel (Customer, StateCode, ID) values ('Poudre', '030', 'D3C1BD80-0D32-4317-BAB8-CAF196D19350')
insert @GradeLevel (Customer, StateCode, ID) values ('Poudre', '040', 'BE4F651A-D5B5-4B05-8237-9FD33E4D2B68')
insert @GradeLevel (Customer, StateCode, ID) values ('Poudre', '050', '5A021B34-D33B-43B5-BD8A-40446AC2E972')
insert @GradeLevel (Customer, StateCode, ID) values ('Poudre', '060', '92B484A3-2DBD-4952-9519-03B848AE1215')
insert @GradeLevel (Customer, StateCode, ID) values ('Poudre', '070', '81FEC824-DB83-4C5D-91A5-2DFE72DE93EC')
insert @GradeLevel (Customer, StateCode, ID) values ('Poudre', '080', '245F48A7-6927-4EFA-A3F2-AF30463C9B4D')
insert @GradeLevel (Customer, StateCode, ID) values ('Poudre', '090', 'FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3')
insert @GradeLevel (Customer, StateCode, ID) values ('Poudre', '100', '8085537C-8EA9-4801-8EC8-A8BDA7E61DB6')
insert @GradeLevel (Customer, StateCode, ID) values ('Poudre', '110', 'EA727CED-8A2C-4434-974A-6D8D924D95C6')
insert @GradeLevel (Customer, StateCode, ID) values ('Poudre', '120', '0D7B8529-62C7-4F25-B78F-2A4724BD7990')
insert @GradeLevel (Customer, Active, ID) values ('Poudre', 0, '10B6907F-2675-4610-983E-B460338569BE')
insert @GradeLevel (Customer, StateCode, ID) values ('Poudre', '004', '6061CD90-8BEC-4389-A140-CF645A5D47FE')


-- set all statecodes to null
update GradeLevel set StateCode = NULL
print 'Update GradeLevel StateCode to NULL: '+ convert(varchar(10), @@rowcount)


-- statecode and name
update t set Name = case when s.Name IS NULL then t.Name else s.Name end, StateCode = s.StateCode
from @GradeLevel s join
GradeLevel t on s.ID = t.ID
where s.Active is null and s.Customer like '%'+@district+'%' -- ids are unique between the two districts so this may be unnecessary
print 'Update GradeLevel name and/or statecode: '+ convert(varchar(10), @@rowcount)

-- add new gradelevel records
insert GradeLevel (ID, Name, Active, BitMask, Sequence, StateCode)
select s.ID, s.Name, s.Active, s.BitMask, s.Sequence, s.StateCode from @GradeLevel s left join GradeLevel d on s.ID = d.ID where s.Active = 1 and s.Customer like '%'+@district+'%'  and d.ID is null
print 'Insert GradeLevel: '+ convert(varchar(10), @@rowcount)

-- deactivate duplicate KG code
update t set Active = 0
from @GradeLevel s join
GradeLevel t on s.ID = t.ID
where s.Active = 0 and s.Customer like '%'+@district+'%' -- ids are unique between the two districts so this may be unnecessary
print 'Update GradeLevel Active = 0: '+ convert(varchar(10), @@rowcount)


-- RACE

update EnumValue set StateCode = NULL where Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and ID not in (select ID from @EnumValue)
print 'Update EnumValue StateCode = NULL where ETH: '+ convert(varchar(10), @@rowcount)

insert EnumValue 
select s.* 
from @EnumValue s left join 
EnumValue t on s.ID = t.ID
where t.ID is null
print 'Insert Race: '+ convert(varchar(10), @@rowcount)


-- BASIS OF EXIT 
-- hide the non-state reporting Special Education Exit reasons
-- wait for input from Linda before executing this code on target systems
UPDATE PrgStatus set DeletedDate = getdate() where ID in ('55BD7E98-8D7D-43A5-AF45-D7264FB9B67D' 
, '07CD2D4B-74D7-49BF-80BC-30B241CAC9C9'
, '12086FE0-B509-4F9F-ABD0-569681C59EE2'
, '1A10F969-4C63-4EB0-A00A-5F0563305D7A'
, '73DC240D-EF00-42C9-910D-3953ED3540D4'
, '24827AAC-3DE7-432D-A15B-00BE41BF8BDF')
and DeletedDate is null
print 'Deactivate 6 PrgStatus records: '+ convert(varchar(10), @@rowcount)

insert PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID, StateCode, Description)
select s.ID, s.ProgramID, s.Sequence, s.Name, s.IsExit, s.IsEntry, s.StatusStyleID, s.StateCode, s.Description
from @PrgStatus s left join
PrgStatus t on isnull(s.StateCode,'s') = isnull(t.StateCode,'t') and t.DeletedDate is null
where t.ID is null
print 'Insert PrgStatus: '+ convert(varchar(10), @@rowcount)





-- rollback tran SelectListsMod

-- commit tran SelectListsMod






update SystemSettings set SecurityRebuiltDate = NULL

/*



select * from GradeLevel order by active desc, case when StateCode IS NULL then 1 else 0 end, StateCode, bitmask


select StateCode, Name, Sequence, IsExit, IsEntry, DeletedDate, Description from PrgStatus where ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and isexit = 1 order by case when deleteddate is null then 0 else 1 end, StateCode, Sequence


select * from EnumValue where Type = (select ID from EnumType where Type = 'ETH') order by case when sequence is null then 1 else 0 end, sequence, Code

select * from IepDisability

select * from IepplacementOption where deleteddate is null order by statecode

select sd.*, isc.* from ServiceDef sd join IepServiceDef isd on sd.ID = isd.ID join IepServiceCategory isc on isd.categoryid = isc.id where sd.Deleteddate is null order by sd.name

select * from iepservicedef

select * from iepservicecategory








-- customer_co_aurora
Update GradeLevel StateCode to NULL: 40
Update GradeLevel name and/or statecode: 1
Insert GradeLevel: 3
Update GradeLevel Active = 0: 1
Insert Race: 7
Deactivate 6 PrgStatus records: 6
Insert PrgStatus: 18


*/



--select 'Compare with below' act, * from @GradeLevel where StateCode = '004'

--select 'Update name and statecode' act, s.*, NewName = case when s.Name IS NULL then t.Name else s.Name end, NewStateCode = s.StateCode
--from @GradeLevel s join
--GradeLevel t on s.ID = t.ID
--where s.Name is not null and s.Active is null -- and s.Customer = @district -- ids are unique between the two districts so this may be unnecessary

--select 'insert new' act, ID, Name, Active, BitMask, Sequence, StateCode from @GradeLevel where Active = 1 and Customer like '%'+@district+'%' -- IDs are unique so this is unecessary

--select 'set active = 0' act, s.*
--from @GradeLevel s join
--GradeLevel t on s.ID = t.ID
--where s.Active = 0 and s.Customer like '%'+@district+'%' -- ids are unique between the two districts so this may be unnecessary


--------------------------
-- AURORA GRADE LEVEL  ---
--------------------------

---- set all StateCode to NULL
--update GradeLevel set StateCode = NULL
--print 'Update GradeLevel StateCode to NULL: '+ convert(varchar(10), @@rowcount)


--insert GradeLevel 
--select s.*
--from @GradeLevel s left join
--GradeLevel t on s.ID = t.ID and s.Customer = 'Aurora'
--where t.ID is null
--print 'Insert New GradeLevels: '+ convert(varchar(10), @@rowcount)




----------------------------
---- POUDRE GRADE LEVEL  ---
----------------------------

---- set all StateCode to NULL
--update GradeLevel set StateCode = NULL

---- Insert ommited StateCodes (Poudre systems)
--insert GradeLevel values ('C808C991-CA93-4F51-AF41-A8BA494AC10F', 'Infant', 1, 0, 0, '002') -- may set Active = 0 on a case-by-case basis
--insert GradeLevel values ('4B0ED575-7C9A-451D-A8E6-2D9F22F31349', 'K Half Day', 1, 0, 0, '006')

---- update existing values StateCode (Poudre values)
--update GradeLevel set StateCode = '004' where ID = '6061CD90-8BEC-4389-A140-CF645A5D47FE'
--update GradeLevel set StateCode = '007', Name = 'K Full Day' where ID = '7269BD32-C052-455B-B3E3-FF5BCB199679'

--update GradeLevel set StateCode = '010' where ID = '07975B7A-8A1A-47AE-A71F-7ED97BA9D48B'
--update GradeLevel set StateCode = '020' where ID = 'DDC4180A-64FC-49BD-AC11-DAA185059885'
--update GradeLevel set StateCode = '030' where ID = 'D3C1BD80-0D32-4317-BAB8-CAF196D19350'
--update GradeLevel set StateCode = '040' where ID = 'BE4F651A-D5B5-4B05-8237-9FD33E4D2B68'
--update GradeLevel set StateCode = '050' where ID = '5A021B34-D33B-43B5-BD8A-40446AC2E972'
--update GradeLevel set StateCode = '060' where ID = '92B484A3-2DBD-4952-9519-03B848AE1215'
--update GradeLevel set StateCode = '070' where ID = '81FEC824-DB83-4C5D-91A5-2DFE72DE93EC'
--update GradeLevel set StateCode = '080' where ID = '245F48A7-6927-4EFA-A3F2-AF30463C9B4D'
--update GradeLevel set StateCode = '090' where ID = 'FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3'
--update GradeLevel set StateCode = '100' where ID = '8085537C-8EA9-4801-8EC8-A8BDA7E61DB6'
--update GradeLevel set StateCode = '110' where ID = 'EA727CED-8A2C-4434-974A-6D8D924D95C6'
--update GradeLevel set StateCode = '120' where ID = '0D7B8529-62C7-4F25-B78F-2A4724BD7990'

---- deactivate duplicate KG code
--update GradeLevel set Active = 0 where ID = '10B6907F-2675-4610-983E-B460338569BE'


-- PrgStatus - may end up deleting unneeded PrgStatus records















--select * from EnumValue where Type = (Select ID from EnumType where Type = 'ETH') order by StateCode, Code