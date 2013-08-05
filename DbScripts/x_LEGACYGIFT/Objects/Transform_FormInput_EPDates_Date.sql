
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_FormInput_EPDates_DateID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

create table x_LEGACYGIFT.MAP_FormInput_EPDates_DateID (
	EPRefID	varchar(150)	not null,
	InputFieldID	uniqueidentifier not null,
	DestID	uniqueidentifier	not null -- InstanceInputID
)
END
go

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_FormInput_EPDates_Date') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_FormInput_EPDates_Date
GO

create view x_LEGACYGIFT.Transform_FormInput_EPDates_Date
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
	IntervalID = f.FormInstanceIntervalID,
	DestID = mv.DestID,
	dp.DateValue 
from x_LEGACYGIFT.Transform_PrgSectionFormInstance f join 
	x_LEGACYGIFT.FormInputValueFields v on f.TemplateID = v.FormTemplateID join 
	dbo.FormTemplateInputItem ftii on v.InputFieldID = ftii.Id join 
	dbo.FormTemplateInputItemType iit on ftii.TypeId = iit.Id left join 
	x_LEGACYGIFT.EPDatesPivot dp on f.EPRefID = dp.EPRefID and ftii.id = dp.InputFieldID left join 
	x_LEGACYGIFT.MAP_FormInputValueID mv on dp.InputFieldID = mv.InputFieldID and f.FormInstanceIntervalID = mv.IntervalID left join 
	dbo.FormInputDateValue dv on mv.DestID = dv.ID
where f.TemplateID = (select FooterFormTemplateID from x_LEGACYGIFT.ImportPrgSections where SectionType = 'Custom Form / Dates') ---------------- need to make sure it is always named this way, or find another method...
and dp.InputItemType = 'Date'
go




