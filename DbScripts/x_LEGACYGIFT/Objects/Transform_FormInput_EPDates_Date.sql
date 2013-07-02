
alter view x_LEGACYGIFT.EPDatesPivot
as
select u.*, InputItemType =  iit.Name, InputItemTypeID = iit.ID
from (
	select EPRefID, DateValue = EPMeetingDate, InputFieldID = '228379F1-0C95-4D69-95DA-BFB437FFB6C5' -- EP Meeting Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
	select EPRefID, EPMeetingDate, InputFieldID = '63CB1358-9540-4469-8C2C-6DBFB6613037' -- EP Initiation Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
	select EPRefID, s.LastEPDate, InputFieldID = '4C561605-316A-498F-8793-E74300782C9B' -- Last EP Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
	select EPRefID, s.DurationDate, InputFieldID = '94CD1E37-59A4-4B4C-B7AC-811E657F94FE' -- Duration Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
	select EPRefID, NULL, InputFieldID = '88558694-9018-4941-80BE-71D2D1BE5112' -- EP Level: (SingleSelect)
	from x_LEGACYGIFT.GiftedStudent s
	) u join
FormTemplateInputItem ftii on u.InputFieldID = ftii.Id join
FormTemplateInputItemType iit on ftii.TypeId = iit.Id
go
-- 22715

select * from x_LEGACYGIFT.Transform_FormInput_EPDates_Date -- 71872

-- select * from x_LEGACYGIFT.FormInputValueFields where InputFieldID = '94CD1E37-59A4-4B4C-B7AC-811E657F94FE' -- interesting table.   Is this a shortcut?

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
where f.TemplateID = '1D2FD18F-9E14-4772-B728-1CA3E6EAE21E'
and dp.InputItemType = 'Date'
go

