-- SC
/*
	If the state codes were the same in all 50 states we could put this code in the transform files, 
	but so that the transforms can be used in all states, we are separating the state-specific code into this file.

*/

-- Ensure GradeLevel StateCode is populated.  Specific to South Carolina
update gl set StateCode = case when Name like 'K%' then 'KG' when Name = '00' then NULL else Name end from GradeLevel gl where (ISNUMERIC(Name) = 1 or Name in ('K', 'PK', 'KG'))
go


--	01	01
--	02	02
--	03	03
--	04	04
--	05	05
--	06	06
--	07	07
--	08	08
--	09	09
--	10	10
--	11	11
--	12	12
--	AE	AE
--	KG	Kindergarten
--	PK	Pre-Kindergarten

--select * from GradeLevel order by StateCode


-- NEW powerschool map to indicate up to how many leading zeros to add to district and school numbers
-- This is necessary because PowerSchool trims leading zeros from District Numbers and SchoolNumbers, but the sped program does not.
-- See Transform_OrgUnit and Transform_School to see how this view is used
IF EXISTS (SELECT * FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id WHERE s.name = 'LEGACYSPED' and o.Name ='DistrictSchoolLeadingZeros' and type = 'U')
drop table LEGACYSPED.DistrictSchoolLeadingZeros
GO

CREATE TABLE LEGACYSPED.DistrictSchoolLeadingZeros
(
	Entity	varchar(10) not null,
	Zeros	varchar(10) not null
)

-- SC:  District 4 characters, School 3 characters
insert LEGACYSPED.DistrictSchoolLeadingZeros values ('District', '0000')
insert LEGACYSPED.DistrictSchoolLeadingZeros values ('School', '000') -- I think it's 3
go



update GradeLevel set StateCode = case Name when 'K' then 'KG' when '00' then NULL else Name end
go
/*

	Ensure IepDisability.StateCode is populated
	If the state code is not populated on Template we need to run this script every time we run ImportExtactLoad or ExtractLoadOnly.  Otherwise there will be an error.
	LEGACYSPED.MAP_IepDisability is populated with ETL from legacy data.  Legacy data must have the StateCode.
	Legacy disabilities without a state code will be added to the database and hidden from the UI.

*/
set nocount on;
insert @Map_IepDisabilityID values ('SDE01', '79450790-72A4-4F16-8840-6193DB199A1E') -- Intellectual Disability
insert @Map_IepDisabilityID values ('SDE02', '52431290-0B16-4732-840B-10986A1FBE1E') -- Deaf and Hard of Hearing
insert @Map_IepDisabilityID values ('SDE03', '5CEAB474-9E65-4190-82CA-C71387C3B03B') -- Speech/Language Impaired
insert @Map_IepDisabilityID values ('SDE04', 'D31E4ED0-9A37-490F-B49B-FF18133644FE') -- Visual Impairment
insert @Map_IepDisabilityID values ('SDE05', 'A1504419-19F6-434B-B4A3-1E5A69E99A9B') -- Emotional Disability
insert @Map_IepDisabilityID values ('SDE06', '607943A6-7CFA-4BD1-9044-6A3634AB1ED5') -- Orthopedic Impairment
insert @Map_IepDisabilityID values ('SDE07', '3567F202-646F-4A7E-860A-2100242C7182') -- Other Health Impairment
insert @Map_IepDisabilityID values ('SDE10', '2F8DD08D-00C6-4C23-859E-718B1E347722') -- Specific Learning Disability
insert @Map_IepDisabilityID values ('SDE11', 'AC7D83DA-B896-4A27-A983-A48243819BC6') -- Deaf-Blindness
insert @Map_IepDisabilityID values ('SDE12', '902770E8-02EE-4538-B6F4-1BB1A691A131') -- Multiple Disabilities
insert @Map_IepDisabilityID values ('SDE13', '555B1135-5B09-419D-9DA7-C7F316B71A3B') -- Autism Spectrum Disorder
insert @Map_IepDisabilityID values ('SDE14', 'F1A19B97-8A22-4498-9E44-C07AB3963736') -- Traumatic Brain Injury
insert @Map_IepDisabilityID values ('SDE15', '6ACBABEA-F128-4D52-A7C4-9478A9B9FACB') -- Developmental Delay

set nocount off;
update d set StateCode = m.StateCode
from @Map_IepDisabilityID m
join IepDisability d on m.DestID = d.ID
go
-- from EO
--SDE01	*Intellectual Disability
--SDE01A	Intellectual Disability (mild)
--SDE01B	Intellectual Disability (moderate)
--SDE01C	Intellectual Disability (severe)
--SDE02	Deaf and Hard of Hearing
--SDE03	Speech or Language Impairment
--SDE04	Visual Impairment
--SDE05	Emotional Disability
--SDE06	Orthopedic Impairment
--SDE07	Other Health Impairment
--SDE10	Specific Learning Disability
--SDE11	Deafblindness
--SDE12	Multiple Disabilities
--SDE13	Autism
--SDE14	Traumatic Brain Injury
--SDE15	Developmental Delay
--SDE21	 No Disability Currently Specified


-- (comments after the insert line are the ServiceFrequency description from EO)
set nocount on;
declare @servfreq table (ID uniqueidentifier, StateCode varchar(20), Name varchar(max),sequence int,weekfactor float)

insert @servfreq values ('E2996A26-3DB5-42F3-907A-9F251F58AB09', 'SDE01', 'only once',4,0.02) -- only once
insert @servfreq values ('C9DFF9A1-6CC2-4900-BA7B-3F94833C0F86', 'SDE02', 'Twice',5,1) -- Twice
insert @servfreq values ('3AE42C6C-8B3C-4CFD-B24A-323A549F5702', 'SDE03', 'Three Times',6,1) -- Three Times
insert @servfreq values ('69DEA0B9-F8F0-4516-8167-FB8876ED9C83', 'SDE04', 'Quarterly',7,1) -- Quarterly
insert @servfreq values ('3D4B557B-0C2E-4A41-9410-BA331F1D20DD', 'SDE05', 'monthly',2,0.23) -- monthly
insert @servfreq values ('A2080478-1A03-4928-905B-ED25DEC259E6', 'SDE06', 'weekly',1,1) -- weekly
insert @servfreq values ('41A951D7-ED35-4AF4-945D-89F228624014', 'SDE07', 'Biweekly',8,1) -- Biweekly
insert @servfreq values ('71590A00-2C40-40FF-ABD9-E73B09AF46A1', 'SDE08', 'daily',0,5) -- daily
insert @servfreq values ('9DE6A916-BC39-47BB-8D2B-15EDEC5C5FE3', 'SDE09', 'Consultation',9,1) -- Consultation
insert @servfreq values ('5F3A2822-56F3-49DA-9592-F604B0F202C3', NULL, 'yearly',3,0.02) -- yearly

--SDE01	Twice Daily
--SDE02	Alternating days as per schedule
--SDE03	Twice weekly
--SDE04	Three times per week
--SDE05	Four times per week
--SDE06	Weekly
--SDE07	Biweekly
--SDE08	Monthly
--SDE09	Quarterly
--SDE10	One semester
--SDE11	Semester
--SDE12	Yearly
--SDE13	One time
--SDE14	Two times
--SDE15	Three times
--SDE16	Four times
--SDE17	Daily
--SDE18	Consultation


--select * From @servfreq
set nocount off;
UPDATE sfq
SET StateCode = tfq.StateCode
--SELECT tfq.* 
FROM @servfreq tfq 
JOIN ServiceFrequency sfq ON sfq.ID = tfq.ID


insert ServiceFrequency (ID , StateCode , Name ,sequence ,weekfactor)
SELECT tfq.ID,tfq.StateCode,tfq.Name,tfq.sequence,tfq.weekfactor
FROM @servfreq tfq 
LEFT JOIN ServiceFrequency sfq ON sfq.ID = tfq.ID
WHERE sfq.ID IS NULL 


--PrgLocation (ServiceLocationCode)
DECLARE @prgloc table (ID uniqueidentifier, Name varchar(max),StateCode varchar(20))
INSERT @prgloc VALUES ('7A691C77-B4D6-4D4D-8A29-131FC1E7A33A','Home','SDE07')
INSERT @prgloc VALUES ('465C097B-DEC0-4E20-ACDC-2ACF9E7F5DEF','Therapy Room','SDE15')
INSERT @prgloc VALUES ('2B72B8C6-01DC-47C5-8623-2F230225B300','School Environment','SDE11')
INSERT @prgloc VALUES ('2087ECC6-914C-486B-81C1-4A1C0A6F0552','Special Education Support Room','SDE13')
INSERT @prgloc VALUES ('B1DA5BF5-325B-496F-A0B2-4AEAA6085C64','Behavior Health Counselor Room','SDE01')
INSERT @prgloc VALUES ('F41868AE-61D1-48A7-8CE0-58B69E5725BD','Cafeteria','SDE03')
INSERT @prgloc VALUES ('52C74FE7-5685-4F8C-AAF2-63B40A8E4B51','Special Education Classroom','SDE12')
INSERT @prgloc VALUES ('6102B96C-1549-4C65-AD59-683FF00639BA','Occupational Therapy Room','SDE09')
INSERT @prgloc VALUES ('27D86DFE-218E-4E1B-A6DB-8B8E74D6F8BA','General Education Classroom','SDE05')
INSERT @prgloc VALUES ('87A9F34F-E5E3-414B-A3B9-91273AD606DF','Physical Therapy Room','SDE10')
INSERT @prgloc VALUES ('E9DD5433-BC4C-4817-BF1D-A0B9203BAB8B','Nurses Room','SDE08')
INSERT @prgloc VALUES ('2D48D839-511D-4CBA-9E72-BDE1348EDCFB','Bus/District Transportation','SDE02')
INSERT @prgloc VALUES ('AA221ED5-CCB4-4A76-B0C6-D0A2B7E2835E','Speech Therapy Room','SDE14')
INSERT @prgloc VALUES ('701DF30A-7C66-423D-9796-DE5B5CB97139','Guidance Counselor Room','SDE06')
INSERT @prgloc VALUES ('1BE8AF70-A842-4ECF-9C50-E67C1F9A80C7','Vocational Rehabilitation Workshop',NULL)
INSERT @prgloc VALUES ('8FC37445-260F-4185-8E43-F5EC8AFCDDB3','Community','SDE04')

--SDE01	Behavior Health Counselor Room
--SDE02	Bus/District Transportation
--SDE03	Cafeteria
--SDE04	Community
--SDE05	General Education Classroom
--SDE06	Guidance Counselor Room
--SDE07	Home
--SDE08	Nurse's Room
--SDE09	Occupational Therapy Room
--SDE10	Physical Therapy Room
--SDE11	School Environment
--SDE12	Special Education Classroom
--SDE13	Special Education Support Room
--SDE14	Speech Therapy Room
--SDE15	Therapy Room

--SELECT * FROM @prgloc


UPDATE ploc
SET StateCode = tloc.StateCode
--SELECT tloc.* 
FROM @prgloc tloc 
JOIN PrgLocation ploc ON ploc.ID = tloc.ID

--INSERT PrgLocation (ID,Name,StateCode)
--SELECT tloc.ID,tloc.Name,tloc.StateCode
--FROM @prgloc tloc 
--LEFT JOIN PrgLocation ploc ON ploc.ID = tloc.ID
--WHERE ploc.ID IS NULL



DECLARE @servdef table (ID uniqueidentifier,TypeID uniqueidentifier,Name varchar(max),StateCode varchar(20),MinutesPerUnit int,UserDefined int )

INSERT @servdef VALUES ('8C054380-B22F-4D2A-98DE-568498E06EAB','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Assistive Technology Services','SDE01',15,1)
INSERT @servdef VALUES ('79969098-F7DC-4280-93AF-73658279F945','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Behavioral Health Screening',NULL,15,1)
INSERT @servdef VALUES ('9DE4CBF9-BD8D-490C-8E1B-34F5E73DEF11','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Classroom Instruction',NULL,15,1)
INSERT @servdef VALUES ('CD96747D-3D67-4207-86FD-FD754A498102','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Community Support Services',NULL,15,1)
INSERT @servdef VALUES ('F6C60A4E-774E-4AE1-80F4-70848B52F846','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Crisis Management',NULL,15,1)
INSERT @servdef VALUES ('F71E1EB1-1322-4AA4-9267-F8039F888D74','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Follow-up Comprehensive Assessment',NULL,15,1)
INSERT @servdef VALUES ('3427C7E6-0501-4860-8055-D284524BEEC7','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Initial Comprehensive Assessment',NULL,15,1)
INSERT @servdef VALUES ('B874A136-2F0E-4955-AA1E-1F0D45F263FB','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Occupational Therapy','SDE05',15,1)
INSERT @servdef VALUES ('73107912-4959-4137-910B-B17E52076074','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Physical Therapy','SDE07',15,1)
INSERT @servdef VALUES ('7BBAAB01-398D-4835-B4B0-13D543FAC564','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Psychological Services','SDE13',60,1)
INSERT @servdef VALUES ('75D07F63-F586-4C55-8FDE-A5B6D0737157','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','School Health Services','SDE15',15,1)
INSERT @servdef VALUES ('FF86821E-A810-4C91-B8FE-240D96278AAB','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Service Plan Development',NULL,15,1)
INSERT @servdef VALUES ('A7E0C2B7-2CA5-4838-BF7E-23E05CCB6564','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Therapy Services',NULL,15,1)
INSERT @servdef VALUES ('003CF444-D485-43B9-8508-8D3B7E27FCB4','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Transportation','SDE10',0,0)
INSERT @servdef VALUES ('B630AE87-E461-4DAC-B5B9-3FB85C78F56D','D3945E9D-AA0E-4555-BCB2-F8CA95CC7784','Transportation Services',NULL,15,1)

--SDE01	Assistive Technology services
--SDE02	Audiological Services
--SDE03	Counseling
--SDE04	Nursing Services
--SDE05	Occupational Therapy
--SDE06	Orientation and Mobility
--SDE07	Physical Therapy
--SDE08	Rehabilitation Counseling
--SDE09	Social Work Services
--SDE10	Transportation
--SDE11	Speech-Language Services
--SDE12	Interpreting Services
--SDE13	Psychological Service
--SDE14	Recreation
--SDE15	School Health Services
--SDE16	Parent Counseling and Training

--select * from @servdef
/*
SDE02	Audiological Services
SDE04	Nursing Services
SDE06	Orientation and Mobility
*/

UPDATE sd
SET StateCode = tsd.StateCode
--SELECT tloc.* 
FROM @servdef tsd 
JOIN ServiceDef sd ON sd.ID = tsd.ID

INSERT servicedef(ID,TypeID,Name,StateCode,MinutesPerUnit ,UserDefined )
SELECT tsd.ID,tsd.TypeID,tsd.Name,tsd.StateCode,tsd.MinutesPerUnit ,tsd.UserDefined
FROM @servdef tsd 
LEFT JOIN ServiceDef sd ON tsd.ID = sd.ID
WHERE sd.ID IS NULL
--

-- for future projects use this code to create table variable insert statements to update manually

--select t.Name, o.Sequence, 'insert @p values ('''+convert(varchar(36), o.ID)+''', ' + isnull(o.StateCode,''''', ''')+ o.Text+''')'
--from IepPlacementType t 
--join IepPlacementOption o on t.ID = o.TypeID
--order by t.name, o.Text

------------------ NOTE:  Received the LRE information from Joe Tebaldi, who received it from the state of SC DOE

-- (comments after the insert line are the LRE description from EO)
declare @p table (ID uniqueidentifier, StateCode varchar(20), Text varchar(max))
-- PK 
insert @p values ('0980382F-594C-453F-A0C9-77D54A0443B1', '7', 'Home') -- In Neither a Regular Early Childhood Program Nor a Special Education Program - Home
insert @p values ('DC20B53C-0559-44F6-A463-3A92D9D4F69A', '9', 'In Regular Education at least 10 hrs per week - EC Program') -- In Regular Education at Least 10 HRS Per WK - Regular Early Childhood Program
insert @p values ('E5741B2C-CE35-4F3B-8AD5-58774E31C531', '10', 'In Regular Education at least 10 hrs per week - Other Location') -- In Regular Education at Least 10 HRS Per WK - Other Location
insert @p values ('A3FA6E17-E828-4A7C-A002-0A49B834BD1E', '11', 'In Regular Education less than 10 hrs per week - EC Program') -- In Regular Education Less Than 10 HRS Per WK - Regular Early Childhood Program
insert @p values ('4F03529D-9E60-4D76-8E0B-DACD3D207768', '12', 'In Regular Education less than 10 hrs per week - Other Location') -- In Regular Education Less Than 10 HRS Per WK - Other Location
insert @p values ('0DA48AA5-183C-4434-91C1-AC3C9941BE15', '6', 'Residential Facility') -- In Special Education Program Only - Residential Facility
insert @p values ('0B2E63D7-6493-44A7-95B1-8DF327D77C38', '4', 'Separate Class') -- In Special Education Program Only - Separate Class
insert @p values ('2E45FDA2-0767-43D0-892D-D1BB40AFCEC1', '5', 'Separate School') -- In Special Education Program Only - Separate School
insert @p values ('1945D36A-8D62-4FDB-9F22-5836F553A958', '8', 'Service Provider Location') -- In Neither a Regular Early Childhood Program Nor a Special Education Program - Service Provider Location or Other Location
-- K12
insert @p values ('84DAF081-F700-4F57-99DA-A2A983FDE919', '9', 'Correctional Facilities') -- Correctional Facilities
insert @p values ('521ACE5E-D04B-4E30-80E3-517516383536', '2', 'Inside Regular Class and activities 79-40% of the day') -- Inside Regular Class 79-40% of the day
insert @p values ('FEFF9910-F320-4097-AFC2-A3D9713470BD', '1', 'Inside Regular Class and activities 80% or more of the day') -- Inside Regular Class 80% or more of the day
insert @p values ('9CD2726E-6461-4F6C-B65F-B4232FB4D36E', '3', 'Inside Regular Class and activities less than 40% of the day') -- Inside Regular Class For Less Than 40% Of Day
insert @p values ('304AEBA5-3162-4B40-89D3-F094602CFF2D', '10', 'Parentally Placed In Private Schools') -- Parentally Placed In Private Schools
insert @p values ('E4EE85F2-8307-4C8D-BA77-4EB5D12D8470', '6', 'Residential Facility') -- Residential Facility
insert @p values ('77E0EE80-143B-41E5-84B9-5076605CCC9A', '4', 'Separate School') -- Separate School
-- Homebound/Hospital
insert @p values ('D634CD6A-C22F-4B34-89A8-340A13891E24', '8c', 'Homebound/Hospital - Home-based')
insert @p values ('5EE0CA16-1F59-4BC8-9AFA-BAED97D29B77', '8b', 'Homebound/Hospital - Hospital')
insert @p values ('91EF0ECE-A770-4D05-8868-F19180A000DB', '8a', 'Homebound/Hospital - Medical Homebound')

--select * from @p
update plop
set statecode = p.statecode 
--select plop.* 
From IepPlacementoption plop
join @p p on p.ID = plop.ID

---- 
--select UsageID, IEPCode, PlacementDesc
--from [10.0.1.8\SQLServer2005].QASCConvert2005.dbo.LK_LREPlacements 
--where UsageID <> 'LREplaceHosp' 
--and (UsageID = 'LREplace') -- or (UsageID = 'LREPlacePK' and IEPCode not in ('1', '2', '3'))) 
--order by UsageID Desc, PlacementDesc


--select p.AgeGroup, p.LREPlacement, p.HomeHosPlace, k.PlacementDesc, count(*) tot
--from [10.0.1.8\SQLServer2005].QASCConvert2005.dbo.ReportICIEPLRETblPlace p
--join [10.0.1.8\SQLServer2005].QASCConvert2005.dbo.LK_LREPlacements k on p.HomeHosPlace = k.IEPCode and k.USageID = 'LREplaceHosp'
--where HomeHosPlace <> 0
--group by p.AgeGroup, p.LREPlacement, p.HomeHosPlace, k.PlacementDesc


--select * from [10.0.1.8\SQLServer2005].QASCConvert2005.dbo.LK_LREPlacements 

--select * from [10.0.1.8\SQLServer2005].QASCConvert2005.sys.objects where name like 'Report%Place%'


-- this may need to be modified for states that don't have a specific code for each race, but set a flag for it (such as FL).  Eather that, or we can derive a code for those statues (first 2 letters of the fed name?)
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_FederalRace') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
create table LEGACYSPED.MAP_FederalRace 
	(
	StateRaceCode varchar(150) NOT NULL,
	FederalRaceName varchar(150) NOT NULL
	)
ALTER TABLE LEGACYSPED.MAP_FederalRace ADD CONSTRAINT
	PK_MAP_FederalRace PRIMARY KEY CLUSTERED
	(
	StateRaceCode
	)
END
GO


DECLARE @ga table (ID uniqueidentifier,Name varchar(max),StateCode varchar(20))
INSERT @ga VALUES ('973314EF-844B-455A-A261-15014BFF2A82','Behavior','Behavior')
--INSERT @ga VALUES ('E457C745-FC98-423B-A13B-0DB7274C5AD2','Functional',NULL)
INSERT @ga VALUES ('D2DEE272-E7CF-4C77-B06E-FF3FBEA5B2EC','Functional Skills','Funct')
INSERT @ga VALUES ('504CE0ED-537F-4EA0-BD97-0349FB1A4CA8','Math','Math')
--INSERT @ga VALUES ('37EA0554-EC3F-4B95-AAD7-A52DECC7377C','Reading',NULL)
INSERT @ga VALUES ('0E95D360-5CBE-4ECA-820F-CC25864D70D8','Speech/Language/Communication','Speech')
INSERT @ga VALUES ('E7D626B6-22FF-41E1-B7BA-6ACD55292F01','Transition','LTrans')
--INSERT @ga VALUES ('590AAE80-4B49-4432-96BC-267701DD934B','Written Expression',NULL)

UPDATE gad
SET StateCode =g.StateCode
--select * 
FROM PrgGoalAreaDef  gad
JOIN @ga g ON g.ID = gad.ID 

GO

--insert LEGACYSPED.MAP_FederalRace values ('A', 'Asian')
--insert LEGACYSPED.MAP_FederalRace values ('I', 'American Indian')
--insert LEGACYSPED.MAP_FederalRace values ('P', 'Hawaiian Pacific Islander')
--insert LEGACYSPED.MAP_FederalRace values ('H', 'Hispanic')
--insert LEGACYSPED.MAP_FederalRace values ('W', 'White')
--insert LEGACYSPED.MAP_FederalRace values ('B', 'Black African American')
go

-- select * from EnumValue where type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and isactive = 1


-- #############################################################################
--		Goal Area Def MAP

IF EXISTS (SELECT * FROM sys.objects WHERE Name = 'LEGACYSPED.MAP_GoalAreaDefID')
drop table LEGACYSPED.MAP_GoalAreaDefID
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgGoalareaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgGoalareaDefID
(
	GoalAreaCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgGoalareaDefID ADD CONSTRAINT
PK_MAP_PrgGoalareaDefID PRIMARY KEY CLUSTERED
(
	GoalAreaCode
)


insert LEGACYSPED.MAP_PrgGoalareaDefID values ('ZZZ', 'FED37909-91FF-43F6-8772-C7D5513F1A01')

if not exists (select 1 from PrgGoalareaDef where ID = 'FED37909-91FF-43F6-8772-C7D5513F1A01')
insert PrgGoalAreaDef (ID, ProgramID,Sequence, Name, AllowCustomProbes, RequireGoal) values ('FED37909-91FF-43F6-8772-C7D5513F1A01', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',99, 'Not Defined', 0, 0)


END
GO

-- select * from PrgGoalareadef




-- #############################################################################
--		Post School Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PostSchoolAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PostSchoolAreaDefID
(
	PostSchoolAreaCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PostSchoolAreaDefID ADD CONSTRAINT
PK_MAP_PostSchoolAreaDefID PRIMARY KEY CLUSTERED
(
	PostSchoolAreaCode
)

create index IX_LEGACYSPED_MAP_PostSchoolAreaDefID_DestID on LEGACYSPED.MAP_PostSchoolAreaDefID (DestID)

-- thse IDs are exported with Enrich configuration for Colorado.  This should be in the State config file
set nocount on;
declare @psa table (PostSchoolAreaCode varchar(20), DestID uniqueidentifier)
insert @psa values ('01', 'ADB5C7FD-C09F-41E3-9C0E-9AF403C741D1')
insert @psa values ('02', '823BA9DB-AF13-42BD-9CC2-EAA884701523')
insert @psa values ('03', '2B5D9C8A-7FA7-4E74-9F0C-53327209E751')

insert LEGACYSPED.MAP_PostSchoolAreaDefID
select * from @psa where PostSchoolAreaCode not in (select PostSchoolAreaCode from LEGACYSPED.MAP_PostSchoolAreaDefID)
END
GO

--Map_SubGoalArea
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.Map_SubGoalArea') AND type in (N'U'))
DROP TABLE LEGACYSPED.Map_SubGoalArea
GO
CREATE TABLE LEGACYSPED.Map_SubGoalArea (
Sequence int not null,
SubGoalAreaName varchar(100) not null,
)
GO

ALTER TABLE LEGACYSPED.Map_SubGoalArea
	ADD CONSTRAINT PK_Map_SubGoalArea PRIMARY KEY CLUSTERED
(
	Sequence,SubGoalAreaName
)
GO

declare @map_subgoalarea table (Sequence int, Name varchar(100))
insert @map_subgoalarea values (0, 'Instructional/Special Education')
insert @map_subgoalarea values (1, 'Transition')
insert @map_subgoalarea values (2, 'Related Service')

insert LEGACYSPED.Map_SubGoalArea
select * from @map_subgoalarea where Name not in (select Name from LEGACYSPED.Map_SubGoalArea)
go
-- last line
