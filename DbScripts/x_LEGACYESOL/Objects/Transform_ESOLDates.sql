
if not exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYESOL' and o.name = 'MAP_ESOLData_Dates')
begin
create table x_LEGACYESOL.MAP_ESOLData_Dates (
DestID	uniqueidentifier not null,
IntervalID uniqueidentifier not null, -- key
InputFieldID uniqueidentifier not null -- key
)

alter table x_LEGACYESOL.MAP_ESOLData_Dates add constraint PK_MAP_ESOLData_Dates_IntervalID_InputFieldID primary key (IntervalID, InputFieldID)
end
go

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYESOL' and o.name = 'Transform_ESOLdates')
drop view x_LEGACYESOL.Transform_ESOLdates
go

create view x_LEGACYESOL.Transform_ESOLdates
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
	ESOLDateValue = cast(case when ii.Id = '838C9D61-C047-492C-AC88-040E2D0081A0' then pstart.StartDate when ii.Id = '1AAA357C-589D-447E-8A4E-1A99025AC15B' then NULL when ii.Id = 'A175F6EE-1648-4431-9143-D695498F1BAD' then NULL when ii.Id = 'CC761983-585C-42B5-AA2D-01D993F6DA79' then NULL end as datetime)
from x_LEGACYESOL.Transform_ESOLData x
join dbo.FormTemplateLayout l on x.TemplateID = l.TemplateId and l.Id = '505D2624-A59E-48CF-A459-1ED2D1D4A5C7' -- and x.StudentID = '2402D32B-03C7-4D10-B2E0-15788BD715E5' --- this particular view assumes one section in the layout
--join dbo.FormTemplateControl c on l.ControlId = c.Id
join dbo.FormTemplateInputItem ii on l.ControlId = ii.InputAreaId 
left join x_LEGACYESOL.ESOLStudent pstart on x.StudentNumber = pstart.StudentLocalID and ii.Id = '838C9D61-C047-492C-AC88-040E2D0081A0' -- startdate
--left join x_LEGACYESOL.ESOLStudent pend on x.StudentNumber = pend.StudentNumber and ii.Id = '6B346762-B709-4187-B787-C1D3A0BEAB98' -- enddate
left join x_LEGACYESOL.MAP_ESOLData_Dates m on x.InstanceIntervalDestID = m.IntervalID and ii.ID = InputFieldID
go
