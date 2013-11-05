
if not exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYRTI' and 
o.name = 'MAP_RTIData_Dates')
begin
create table x_LEGACYRTI.MAP_RTIData_Dates (
DestID	uniqueidentifier not null,
IntervalID uniqueidentifier not null, -- key
InputFieldID uniqueidentifier not null -- key
)

alter table x_LEGACYRTI.MAP_RTIData_Dates add constraint PK_MAP_RTIData_Dates_IntervalID_InputFieldID primary key (IntervalID, InputFieldID)
end
go

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYRTI' and o.name = 'Transform_RTIdates')
drop view x_LEGACYRTI.Transform_RTIdates
go

create view x_LEGACYRTI.Transform_RTIdates
as
select 
	DestID = m.DestID,
	IntervalID = x.InstanceIntervalDestID, -- FormInputValue.IntervalID --========================================================================================== LOOK HERE.  Confusing name of columns !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	InputFieldID = ii.ID, --- FormInputValue.InputFieldID
	--InputAreaId = ii.InputAreaId,
	--l.TemplateId,
	--l.ControlId,
	InputItemLabel = ii.Label,
	InputItemSequence = ii.Sequence,
	Sequence = cast(0 as int), -- this is the one that gets inserted into FormInptValue
	RTIDateValue = cast(case when ii.Id = 'EF38E95E-6ECA-4987-A598-DDE14A8C85E4' then pstart.StartDate 
	when ii.Id = '8EB1A89B-663E-4373-B3E0-3B132349B8EB' then pend.EndDate end as datetime)
from x_LEGACYRTI.Transform_RTIData x
join dbo.FormTemplateLayout l on x.TemplateID = l.TemplateId and l.Id = 'EFB02972-46F9-40E0-84A9-5DB5EC3FAD31'  -- and x.StudentID = '2402D32B-03C7-4D10-B2E0-15788BD715E5' --- this particular view assumes one section in the layout
--join dbo.FormTemplateControl c on l.ControlId = c.Id
join dbo.FormTemplateInputItem ii on l.ControlId = ii.InputAreaId 
left join x_LEGACYRTI.RTIStudent pstart on x.StudentNumber = pstart.StudentLocalID and x.Startdate = pstart.Startdate and (select Name from Prgvariant where ID = x.VariantID) = isnull(pstart.Area,'Reading') and ii.Id = 'EF38E95E-6ECA-4987-A598-DDE14A8C85E4' -- startdate
left join x_LEGACYRTI.RTIStudent pend on x.StudentNumber = pend.StudentLocalID and x.Startdate = pend.Startdate and (select Name from Prgvariant where ID = x.VariantID) = isnull(pend.Area,'Reading') and ii.Id = '8EB1A89B-663E-4373-B3E0-3B132349B8EB' -- enddate
left join x_LEGACYRTI.MAP_RTIData_Dates m on x.InstanceIntervalDestID = m.IntervalID and ii.ID = InputFieldID
go
