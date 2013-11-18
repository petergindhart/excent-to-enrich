
-- Florida
-- Brevard
-- GIFTED

-- select * from PrgItemDef where ProgramID = '3B19FAD7-22BF-47CC-8FA6-2E0464EB6DC6'



--
--  NOTE:  Check this first section of code with the other 2 files in the Gifted District folder - MAP tables already have these IDs
-- 




declare @giftedProgramID varchar(36) ; select @giftedProgramID = '3B19FAD7-22BF-47CC-8FA6-2E0464EB6DC6'
declare @convertedEPname varchar(50); set @convertedEPname = 'EP - Converted'

declare @PrgStatusSeq int ;
select @PrgStatusSeq = sequence from PrgStatus where ProgramID = @giftedProgramID and DeletedDate is null and Name = 'Eligible'
If not exists (select 1 from PrgStatus where ProgramID = @giftedProgramID and Name = 'Converted EP')
begin
	update PrgStatus set Sequence = Sequence+1 where ProgramID = @giftedProgramID and DeletedDate is null and Sequence > @PrgStatusSeq

	insert PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) 
	values ('DA52C2A1-5265-4DE6-9509-B4B97FCA3900', @giftedProgramID, 3, convert(varchar(50), 'Converted EP'), 0, 0, '85AAB540-503F-4613-9F1F-A14C72764285', NULL, NULL) -- DA5... used in other districts.
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
-- run the query below to produce the insert lines 
insert x_LEGACYGIFT.ImportPrgSections values (1, 0, 'Custom Form / Dates', '9018DAAB-EE41-44C6-BE47-1E3F344BAE98',  '4F15C29C-8CBB-49E4-A5B5-258E80ACFC2D',  NULL) -- Custom Form   F: Dates   H:  (none)
insert x_LEGACYGIFT.ImportPrgSections values (0, 1, 'IEP Goals', '06578702-1A1D-4CA0-8E5C-FAF7578F3033',  NULL,  NULL) -- IEP Goals   F:  (none)   H:  (none)
insert x_LEGACYGIFT.ImportPrgSections values (0, 2, 'IEP Services', '5DB15BC0-2FFD-48E3-9769-9A8138CEFDFE',  NULL,  NULL) -- IEP Services   F:  (none)   H:  (none)

-- select * from x_LEGACYGIFT.ImportPrgSections order by Sequence

--delete x_LEGACYGIFT.ImportPrgSections 


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
where i.ID = '698AB523-C815-4776-A0EA-4CF796A314A9' -- EP - Converted
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


-- since this will evidently always be different from district to district, create this view here with the hard-coded IDs
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.EPDatesPivot') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.EPDatesPivot
GO

create view x_LEGACYGIFT.EPDatesPivot
as
select u.*, InputItemType =  iit.Name, InputItemTypeID = iit.ID
from (
	select EPRefID, DateValue = EPMeetingDate, InputFieldID = '9560E498-B842-49CE-B634-C2A0FB96D4B6' -- EP Meeting Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
	select EPRefID, EPMeetingDate, InputFieldID = 'B74C211B-8DE0-404A-AB7E-4D1744C89506' -- EP Initiation Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
	select EPRefID, s.LastEPDate, InputFieldID = '13A5F33B-537C-4F0E-A8EA-A9C6E42D107F' -- Last EP Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
--
	select EPRefID, NULL, InputFieldID = '0073518B-C8BE-4726-94F4-72DD1DD97CB9' -- Special Review Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
---
	select EPRefID, s.DurationDate, InputFieldID = 'F4024E5D-8DEE-4B73-8079-0036B1EC618A' -- Duration Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
	select EPRefID, NULL, InputFieldID = 'AF24267B-E081-478E-B29B-2475E92D1AAB' -- EP Level: (SingleSelect)
	from x_LEGACYGIFT.GiftedStudent s
	) u join
FormTemplateInputItem ftii on u.InputFieldID = ftii.Id join 
FormTemplateInputItemType iit on ftii.TypeId = iit.Id
go








/*		different approach (not automated): use the following query to create the insert statements for the x_LEGACYGIFT.FormInputValueFields table


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

exec x_DATATEAM.FormletViewBuilder '4F15C29C-8CBB-49E4-A5B5-258E80ACFC2D', 1, 'Date1
Date2
Date3
Date4
Date5
Single1'


	--	EP Meeting Date:     < Date1 >    (Date)
	FormInputValue v_0_0 on
		v_0_0.InputFieldId = '9560E498-B842-49CE-B634-C2A0FB96D4B6' AND
		v_0_0.Intervalid = i.ID JOIN
	FormInputDateValue vv_0_0 on vv_0_0.ID = v_0_0.ID JOIN

	--	EP Initiation Date:     < Date2 >    (Date)
	FormInputValue v_0_1 on
		v_0_1.InputFieldId = 'B74C211B-8DE0-404A-AB7E-4D1744C89506' AND
		v_0_1.Intervalid = i.ID JOIN
	FormInputDateValue vv_0_1 on vv_0_1.ID = v_0_1.ID JOIN

	--	Last EP Date:     < Date3 >    (Date)
	FormInputValue v_0_2 on
		v_0_2.InputFieldId = '13A5F33B-537C-4F0E-A8EA-A9C6E42D107F' AND
		v_0_2.Intervalid = i.ID JOIN
	FormInputDateValue vv_0_2 on vv_0_2.ID = v_0_2.ID JOIN

	--	Special Review Date:     < Date4 >    (Date)
	FormInputValue v_0_3 on
		v_0_3.InputFieldId = '0073518B-C8BE-4726-94F4-72DD1DD97CB9' AND
		v_0_3.Intervalid = i.ID JOIN
	FormInputDateValue vv_0_3 on vv_0_3.ID = v_0_3.ID JOIN

	--	Duration Date:     < Date5 >    (Date)
	FormInputValue v_0_4 on
		v_0_4.InputFieldId = 'F4024E5D-8DEE-4B73-8079-0036B1EC618A' AND
		v_0_4.Intervalid = i.ID JOIN
	FormInputDateValue vv_0_4 on vv_0_4.ID = v_0_4.ID JOIN

	--	EP Level:     < Single1 >    (SingleSelect)
	FormInputValue v_0_5 on
		v_0_5.InputFieldId = 'AF24267B-E081-478E-B29B-2475E92D1AAB' AND
		v_0_5.Intervalid = i.ID JOIN
	FormInputSingleSelectValue vv_0_5 on vv_0_5.ID = v_0_5.ID LEFT JOIN

	--### LEFT join actual value tables where needed ###

	FormTemplateInputSelectFieldOption lft_0_5 on vv_0_5.SelectedOptionID = lft_0_5.ID

*/





if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.name = 'GiftedConversionWrapUp')
drop procedure x_LEGACYGIFT.GiftedConversionWrapUp
go

create procedure x_LEGACYGIFT.GiftedConversionWrapUp
as
-- this should run for all districts in all states
update d set IsReevaluationNeeded = 1, StartDate = dateadd(dd, -d.MaxDaysToComplete, dateadd(yy, -d.MaxYearsToComplete, getdate())) from PrgMilestoneDef d where d.ID in ('27C002AF-ED92-4152-8B8C-7CA1ADEA2C81', 'AC043E4C-55EC-4F10-BCED-7E9201D7D0E2')

exec dbo.Util_VerifyProgramDataAssumptions 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1'

GO


--select * from PrgMilestoneDef where ID in ('27C002AF-ED92-4152-8B8C-7CA1ADEA2C81', 'AC043E4C-55EC-4F10-BCED-7E9201D7D0E2')
-- select * from PrgMilestoneDef where ProgramID = 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1'
