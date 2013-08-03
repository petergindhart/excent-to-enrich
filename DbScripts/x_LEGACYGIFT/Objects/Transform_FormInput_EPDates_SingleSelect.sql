
-- using a single map table for all non-duplicated input values

--IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_FormInput_EPDates_SingleSelectID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
--BEGIN

--create table x_LEGACYGIFT.MAP_FormInput_EPDates_SingleSelectID (
--	EPRefID	varchar(150)	not null,
--	InputFieldID	uniqueidentifier not null,
--	DestID	uniqueidentifier	not null -- InstanceInputID
--)

--END
--go

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_FormInput_EPDates_SingleSelect') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_FormInput_EPDates_SingleSelect
GO

create view x_LEGACYGIFT.Transform_FormInput_EPDates_SingleSelect
as
select 
	f.EPRefID, 
	v.FormTemplateID, 
	v.InputFieldID, 
	ftii.Sequence, 
	ftii.Code, 
	ftii.Label, 
	InputItemType = iit.Name, 
	f.FormInstanceID, 
	DestID = mv.DestID,
	SelectedOptionID = ssv1.ID
from x_LEGACYGIFT.Transform_PrgSectionFormInstance f join 
	x_LEGACYGIFT.FormInputValueFields v on f.TemplateID = v.FormTemplateID join
	dbo.FormTemplateInputItem ftii on v.InputFieldID = ftii.Id join 
	dbo.FormTemplateInputItemType iit on ftii.TypeId = iit.Id left join 
	x_LEGACYGIFT.EPDatesPivot dp on f.EPRefID = dp.EPRefID and ftii.id = dp.InputFieldID left join 
	x_LEGACYGIFT.MAP_FormInputValueID mv on dp.InputFieldID = mv.InputFieldID and f.FormInstanceIntervalID = mv.IntervalID left join 
	dbo.FormInputSingleSelectValue ssv on ftii.Id = ssv.ID and
		dp.InputFieldID = v.InputFieldID left join
	FormTemplateInputSelectFieldOption ssv1 on mv.DestID = ssv1.ID -- We are inserting a NULL, so this is not signifcant at this point.           should this be in a separate transform?
where f.TemplateID = (select FooterFormTemplateID from x_LEGACYGIFT.ImportPrgSections where SectionType = 'Custom Form / Dates')
and dp.InputItemType = 'SingleSelect'
go

