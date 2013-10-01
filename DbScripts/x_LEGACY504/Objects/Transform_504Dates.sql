
if not exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACY504' and o.name = 'MAP_504data_Dates')
begin
create table x_LEGACY504.MAP_504data_Dates (
DestID	uniqueidentifier not null,
IntervalID uniqueidentifier not null, -- key
InputFieldID uniqueidentifier not null -- key
)

alter table x_LEGACY504.MAP_504data_Dates add constraint PK_MAP_504data_Dates_IntervalID_InputFieldID primary key (IntervalID, InputFieldID)
end
go

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACY504' and o.name = 'Transform_504dates')
drop view x_LEGACY504.Transform_504dates
go

create view x_LEGACY504.Transform_504dates
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
	Section504DateValue = cast(case when ii.Id = '2F086A80-58EB-4488-824F-126691F15F37' then pstart.StartDate when ii.Id = '6B346762-B709-4187-B787-C1D3A0BEAB98' then pend.EndDate end as datetime)
from x_LEGACY504.Transform_504Data x
join dbo.FormTemplateLayout l on x.TemplateID = l.TemplateId and l.Id = '32163F19-4A96-4C96-AAB5-74206932B175' -- and x.StudentID = '2402D32B-03C7-4D10-B2E0-15788BD715E5' --- this particular view assumes one section in the layout
--join dbo.FormTemplateControl c on l.ControlId = c.Id
join dbo.FormTemplateInputItem ii on l.ControlId = ii.InputAreaId 
left join x_LEGACY504.Student504Dates pstart on x.StudentNumber = pstart.StudentNumber and ii.Id = '2F086A80-58EB-4488-824F-126691F15F37' -- startdate
left join x_LEGACY504.Student504Dates pend on x.StudentNumber = pend.StudentNumber and ii.Id = '6B346762-B709-4187-B787-C1D3A0BEAB98' -- enddate
left join x_LEGACY504.MAP_504data_Dates m on x.InstanceIntervalDestID = m.IntervalID and ii.ID = InputFieldID
go
