
-- Florida
-- Polk
-- GIFTED

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.name = 'MAP_PrgStatus_ConvertedEP')
drop table x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP
go

create table x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP (DestID uniqueidentifier not null)
insert x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP values ('DA52C2A1-5265-4DE6-9509-B4B97FCA3900') -- should eventually coordinate with VC3 how the sequence should be coordinated.  
go

declare @PrgStatusSeq int ;
select @PrgStatusSeq = sequence from PrgStatus where ProgramID = '2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E' and DeletedDate is null and Name = 'Eligible'
If not exists (select 1 from PrgStatus where Name = 'Converted EP')
begin
	update PrgStatus set Sequence = Sequence+1 where ProgramID = '2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E' and DeletedDate is null and Sequence > @PrgStatusSeq

	insert PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) 
	values ('DA52C2A1-5265-4DE6-9509-B4B97FCA3900', '2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E', 3, convert(varchar(50), 'Converted EP'), 0, 0, '85AAB540-503F-4613-9F1F-A14C72764285', NULL, NULL)
end
GO


-- ImportPrgSections
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.ImportPrgSections') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.ImportPrgSections
GO

CREATE TABLE x_LEGACYGIFT.ImportPrgSections (
Enabled	bit	not null,
Sequence	int	not null,
SectionType		varchar(100)	not null,
SectionDefID	uniqueidentifier not null,
FooterFormTemplateID	uniqueidentifier null,
HeaderFormTemplateID	uniqueidentifier null
)

ALTER TABLE x_LEGACYGIFT.ImportPrgSections
	ADD CONSTRAINT PK_ImportPrgSectionss PRIMARY KEY CLUSTERED
(
	SectionDefID
)
GO
set nocount on;
insert x_LEGACYGIFT.ImportPrgSections values (1, 0, 'Custom Form / Dates', '49370EFB-E531-4B61-86A3-3D1C132AB480',  '1D2FD18F-9E14-4772-B728-1CA3E6EAE21E',  NULL) -- Custom Form   F: Dates   H:  (none)
insert x_LEGACYGIFT.ImportPrgSections values (1, 1, 'Custom Form / EP Present Levels', 'DF806BE1-85C9-4A5C-A4D9-12D41D14147C',  'B659273D-D369-45BF-8F85-01B7857F0635',  NULL) -- Custom Form   F: EP Present Levels   H:  (none)
insert x_LEGACYGIFT.ImportPrgSections values (1, 2, 'IEP Goals', 'F9BCB1A3-D7D2-43E8-9B92-E269B80A2C62',  NULL,  NULL) -- IEP Goals   F:  (none)   H:  (none)
insert x_LEGACYGIFT.ImportPrgSections values (1, 3, 'IEP Services', '8EFD24A0-46F0-4734-999A-0B4CCE2C1519',  NULL,  NULL) -- IEP Services   F:  (none)   H:  (none)

-- select * from x_LEGACYGIFT.ImportPrgSections order by Sequence


/*   use this query to create the ImportFormTemplates insert queries (copy the insertline column date and paste above.  Change the PrgItemDef ID in different states if necessary.  
	
		the method of using the insert lines instead of directly inserting from the query facilitates changing Enabled to False where required.

select ItemDef = i.Name, SectionType = t.Name, SectionDefID = s.ID, s.Sequence, 
	FooterFormCode = f.Code, FooterFormName = f.Name, FooterFormID = f.Id, 
	HeaderFormCode = h.Code, HeaderFormName = h.Name, HeaderFormID = h.Id,
	insertline = replace('insert x_LEGACYGIFT.ImportPrgSections values ('+convert(char(1), 1)+', '+convert(varchar(3), s.Sequence)+', '''+t.Name+isnull(' / '+f.name,'')+isnull(' / '+h.name,'')+''', '''+convert(varchar(36),  s.ID)+''',  '''+isnull(convert(varchar(36), f.ID),'NULL')+''',  '''+isnull(convert(varchar(36), h.ID),'NULL'')'), '''NULL''', 'NULL')+' -- '+t.name+'   F: '+isnull(f.Name,' (none)') +'   H: '+isnull(h.Name,' (none)')
from PrgItemDef i 
join PrgSectionDef s on i.ID = s.ItemDefID
join PrgSectionType t on s.TypeID = t.ID
left join FormTemplate f on s.FormTemplateID = f.Id
left join FormTemplate h on s.HeaderFormTemplateID = h.Id
where i.ID = '69942840-0E78-498D-ADE3-7454F69EA178' -- EP - Converted
order by s.Sequence




*/



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.FormInputValueFields') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.FormInputValueFields
GO

create table x_LEGACYGIFT.FormInputValueFields (
FormTemplateID	uniqueidentifier	not null,
InputFieldID	uniqueidentifier	not null
)


ALTER TABLE x_LEGACYGIFT.FormInputValueFields
	ADD CONSTRAINT PK_FormInputValueFields PRIMARY KEY CLUSTERED
(
	InputFieldID
)

create index IX_x_LEGACYGIFT_FormInputValueFields_FormTemplateID on x_LEGACYGIFT.FormInputValueFields (FormTemplateID)
GO

insert x_LEGACYGIFT.FormInputValueFields
select ftl.TemplateID, ftii.ID
-- select ft.Name, ftii.InputAreaID, ftc.IsRepeatable, ftii.Sequence, ftii.Label, ftl.TemplateID, FormTemplateInputItemID = ftii.ID, insertline = 'insert x_LEGACYGIFT.FormInputValueFields values ('''+convert(varchar(36), ftl.TemplateID)+''', '''+convert(varchar(36), ftii.ID)+''') -- '+ftii.Label+''
from dbo.FormTemplate ft 
join dbo.FormTemplateLayout ftl on ft.ID = ftl.TemplateID
join dbo.FormTemplateControl ftc on ftl.ControlID = ftc.ID
join dbo.FormTemplateControlType ftct on ftc.TypeID = ftct.ID
join dbo.FormTemplateInputItem ftii on ftc.ID = ftii.InputAreaID 
join (select TemplateID = FooterFormTemplateID from x_LEGACYGIFT.ImportPrgSections where FooterFormTemplateID is not null
	union all
	select TemplateID = HeaderFormTemplateID from x_LEGACYGIFT.ImportPrgSections where HeaderFormTemplateID is not null
	) s on ftl.TemplateID = s.TemplateID
where ftct.Name = 'Input Area'
and ftii.ID not in (select InputFieldID from x_LEGACYGIFT.FormInputValueFields)
order by ft.Name, ftii.Sequence


--insert x_LEGACYGIFT.FormInputValueFields values ('1D2FD18F-9E14-4772-B728-1CA3E6EAE21E', '228379F1-0C95-4D69-95DA-BFB437FFB6C5') -- EP Meeting Date:
--insert x_LEGACYGIFT.FormInputValueFields values ('1D2FD18F-9E14-4772-B728-1CA3E6EAE21E', '63CB1358-9540-4469-8C2C-6DBFB6613037') -- EP Initiation Date:
--insert x_LEGACYGIFT.FormInputValueFields values ('1D2FD18F-9E14-4772-B728-1CA3E6EAE21E', '4C561605-316A-498F-8793-E74300782C9B') -- Last EP Date:
--insert x_LEGACYGIFT.FormInputValueFields values ('1D2FD18F-9E14-4772-B728-1CA3E6EAE21E', '94CD1E37-59A4-4B4C-B7AC-811E657F94FE') -- Duration Date:
--insert x_LEGACYGIFT.FormInputValueFields values ('1D2FD18F-9E14-4772-B728-1CA3E6EAE21E', '88558694-9018-4941-80BE-71D2D1BE5112') -- EP Level:

--insert x_LEGACYGIFT.FormInputValueFields values ('B659273D-D369-45BF-8F85-01B7857F0635', '4F8DA6FB-9CF6-4056-9D06-534A675E7380') -- Parents, student and other EP members contribute information in the following areas:
--insert x_LEGACYGIFT.FormInputValueFields values ('B659273D-D369-45BF-8F85-01B7857F0635', '2E21A087-BDA2-435E-8D70-2701D27C9C96') -- Strengths and interests of student.
--insert x_LEGACYGIFT.FormInputValueFields values ('B659273D-D369-45BF-8F85-01B7857F0635', '019D9A47-60B0-405C-B585-7C0616F18FAA') -- Needs beyond general curriculum as a result of student's giftedness.
--insert x_LEGACYGIFT.FormInputValueFields values ('B659273D-D369-45BF-8F85-01B7857F0635', '33A9E439-CD8C-4E3C-B334-9F8B37185695') -- Results of recent evaluations, state or district assessments, and class work.
--insert x_LEGACYGIFT.FormInputValueFields values ('B659273D-D369-45BF-8F85-01B7857F0635', '04E73B63-654F-4B20-88A1-BFF9D214E9F5') -- Language needs of LEP student.




/*		use the following query to create the insert statements for the x_LEGACYGIFT.FormInputValueFields table


select ft.Name, ftii.InputAreaID, ftc.IsRepeatable, ftii.Sequence, ftii.Label, ftl.TemplateID, FormTemplateInputItemID = ftii.ID,
	insertline = 'insert x_LEGACYGIFT.FormInputValueFields values ('''+convert(varchar(36), ftl.TemplateID)+''', '''+convert(varchar(36), ftii.ID)+''') -- '+ftii.Label+''
from dbo.FormTemplate ft 
join dbo.FormTemplateLayout ftl on ft.ID = ftl.TemplateID
join dbo.FormTemplateControl ftc on ftl.ControlID = ftc.ID
join dbo.FormTemplateControlType ftct on ftc.TypeID = ftct.ID
join dbo.FormTemplateInputItem ftii on ftc.ID = ftii.InputAreaID 
join (select TemplateID = FooterFormTemplateID from x_LEGACYGIFT.ImportPrgSections where FooterFormTemplateID is not null
	union all
	select TemplateID = HeaderFormTemplateID from x_LEGACYGIFT.ImportPrgSections where HeaderFormTemplateID is not null
	) s on ftl.TemplateID = s.TemplateID
where ftct.Name = 'Input Area'
order by ft.Name, ftii.Sequence



This is an extract from the formletviewbuilder query that shows the input field ids that we will need to insert the date values

	--	EP Meeting Date:     < Date1 >    (Date)
	FormInputValue v_0_0 on
		v_0_0.InputFieldId = '228379F1-0C95-4D69-95DA-BFB437FFB6C5' AND
		v_0_0.Intervalid = i.ID JOIN
	FormInputDateValue vv_0_0 on vv_0_0.ID = v_0_0.ID JOIN

	--	EP Initiation Date:     < Date2 >    (Date)
	FormInputValue v_0_1 on
		v_0_1.InputFieldId = '63CB1358-9540-4469-8C2C-6DBFB6613037' AND
		v_0_1.Intervalid = i.ID JOIN
	FormInputDateValue vv_0_1 on vv_0_1.ID = v_0_1.ID JOIN

	--	Last EP Date:     < Date3 >    (Date)
	FormInputValue v_0_2 on
		v_0_2.InputFieldId = '4C561605-316A-498F-8793-E74300782C9B' AND
		v_0_2.Intervalid = i.ID JOIN
	FormInputDateValue vv_0_2 on vv_0_2.ID = v_0_2.ID JOIN

	--	Duration Date:     < Date5 >    (Date)
	FormInputValue v_0_3 on
		v_0_3.InputFieldId = '94CD1E37-59A4-4B4C-B7AC-811E657F94FE' AND
		v_0_3.Intervalid = i.ID JOIN
	FormInputDateValue vv_0_3 on vv_0_3.ID = v_0_3.ID JOIN
*/





------ #############################################################################
------		Goal Area MAP
--IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_EPSubGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
--BEGIN
--CREATE TABLE x_LEGACYGIFT.MAP_EPSubGoalAreaDefID 
--(
--	SubGoalAreaCode	varchar(150) NOT NULL,
--	DestID uniqueidentifier NOT NULL,
--	ParentID uniqueidentifier not null
--)

--ALTER TABLE x_LEGACYGIFT.MAP_EPSubGoalAreaDefID ADD CONSTRAINT
--PK_MAP_EPSubGoalAreaDefID PRIMARY KEY CLUSTERED
--(
--	SubGoalAreaCode
--)

--END
--GO

---- select 'insert x_LEGACYGIFT.MAP_EPSubGoalAreaDefID values ('''+SubGoalAreaCode+''', '''+convert(varchar(36), DestID)+''', '''+convert(varchar(36), ParentID)+''')' from x_LEGACYGIFT.Transform_EPSubGoalAreaDef
--if not exists (select 1 from x_LEGACYGIFT.MAP_EPSubGoalAreaDefID where SubGoalAreaCode = 'GAReading')
--insert x_LEGACYGIFT.MAP_EPSubGoalAreaDefID values ('GAReading', 'A7506FED-1F87-484C-97DF-99517AC26971', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')

--if not exists (select 1 from x_LEGACYGIFT.MAP_EPSubGoalAreaDefID where SubGoalAreaCode = 'GAWriting')
--insert x_LEGACYGIFT.MAP_EPSubGoalAreaDefID values ('GAWriting', '7099C2E7-02C9-4903-8A01-8F0774364E5B', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')

--if not exists (select 1 from x_LEGACYGIFT.MAP_EPSubGoalAreaDefID where SubGoalAreaCode = 'GAMath')
--insert x_LEGACYGIFT.MAP_EPSubGoalAreaDefID values ('GAMath', 'D58C5141-DD5D-4C80-BB93-7CC88A234B2D', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')

--if not exists (select 1 from x_LEGACYGIFT.MAP_EPSubGoalAreaDefID where SubGoalAreaCode = 'GAOther')
--insert x_LEGACYGIFT.MAP_EPSubGoalAreaDefID values ('GAOther', 'DEEB5A06-156D-43D0-B976-4B30245C6784', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')

---- Lee County had a MAP_ServiceFrequencyID from a previouos ETL run that had bogus frequency data. delete that data and insert the good.
--declare @Map_ServiceFrequencyID table (ServiceFrequencyCode varchar(30), ServiceFrequencyName varchar(50), DestID uniqueidentifier)
--set nocount on;
--insert @Map_ServiceFrequencyID values ('day', 'daily', '71590A00-2C40-40FF-ABD9-E73B09AF46A1')
--insert @Map_ServiceFrequencyID values ('week', 'weekly', 'A2080478-1A03-4928-905B-ED25DEC259E6')
--insert @Map_ServiceFrequencyID values ('month', 'monthly', '3D4B557B-0C2E-4A41-9410-BA331F1D20DD')
--insert @Map_ServiceFrequencyID values ('year', 'yearly', '5F3A2822-56F3-49DA-9592-F604B0F202C3')
--insert @Map_ServiceFrequencyID values ('ZZZ', 'unknown', 'C42C50ED-863B-44B8-BF68-B377C8B0FA95')

--if (select COUNT(*) from @Map_ServiceFrequencyID t join x_LEGACYGIFT.MAP_ServiceFrequencyID m on t.DestID = m.DestID) <> 5
--	delete x_LEGACYGIFT.MAP_ServiceFrequencyID

--set nocount off;
--insert x_LEGACYGIFT.MAP_ServiceFrequencyID
--select m.ServiceFrequencyCode, m.ServiceFrequencyName, m.DestID
--from @Map_ServiceFrequencyID m left join
--	x_LEGACYGIFT.MAP_ServiceFrequencyID t on m.DestID = t.DestID
--where t.DestID is null

---- this is seed data, but maybe this is not the best place for this code.....
--insert ServiceFrequency (ID, Name, Sequence, WeekFactor)
--select DestID, m.ServiceFrequencyName, 99, 0
--from x_LEGACYGIFT.MAP_ServiceFrequencyID m left join
--	ServiceFrequency t on m.DestID = t.ID
--where t.ID is null
--GO


if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.name = 'GiftedConversionWrapUp')
drop procedure x_LEGACYGIFT.GiftedConversionWrapUp
go

create procedure x_LEGACYGIFT.GiftedConversionWrapUp
as
-- this should run for all districts in all states
update d set IsReevaluationNeeded = 1, StartDate = dateadd(dd, -d.MaxDaysToComplete, dateadd(yy, -d.MaxYearsToComplete, getdate())) from PrgMilestoneDef d where d.ID in ('27C002AF-ED92-4152-8B8C-7CA1ADEA2C81', 'AC043E4C-55EC-4F10-BCED-7E9201D7D0E2')

exec dbo.Util_VerifyProgramDataAssumptions '2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E'

GO


