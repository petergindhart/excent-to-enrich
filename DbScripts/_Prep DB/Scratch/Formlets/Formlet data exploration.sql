select * from FormTemplate where name like '%Gift%'


select * from Program where ID = 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1'

select * from PrgItemDef where ProgramID = 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1'

select * from dbo.PrgItemDef where ID = '9F8156ED-AC5B-432B-BB12-8F8B302EF02B'
	select * from dbo.PrgDocumentDef where ItemDefId = '9F8156ED-AC5B-432B-BB12-8F8B302EF02B'
--	select * from dbo.PrgItemOutcome where CurrentDefID = '9F8156ED-AC5B-432B-BB12-8F8B302EF02B'
	select * from dbo.PrgItemRelDef where ResultingItemDefID = '9F8156ED-AC5B-432B-BB12-8F8B302EF02B' -- meeting
	select st.name, sd.* from dbo.PrgSectionDef sd join PrgSectionType st on sd.TypeID = st.ID where sd.ItemDefID = '9F8156ED-AC5B-432B-BB12-8F8B302EF02B' order by sd.sequence
--	select * from dbo.SecurityTask where TargetID = '9F8156ED-AC5B-432B-BB12-8F8B302EF02B'
--	select * from dbo.SecurityTaskCategory where OwnerID = '9F8156ED-AC5B-432B-BB12-8F8B302EF02B'


select * from FormInstance

select * from FormTemplate where ProgramID = 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1' order by Name

select * from PrgInvolvement where ProgramID = 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1' -- ID = newid(), StudentID, ProgramID = 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1', VariantID = '43E1AF01-0A27-41B3-90E1-D7322CE5CD37', StartDate, EndDate = NULL, EndStatus = NULL, IsManuallyEnded = NULL
	select * from PrgVariant where ID = '43E1AF01-0A27-41B3-90E1-D7322CE5CD37' -- for Gifted, None
--

select * from Program where ID in ('AD9F855B-E054-46BF-ACA9-1884CBD6C8E1', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C')
--------------------------------------------------------------------------------------------------------------------------------------------


select * from PrgDocumentDef where name like '%EP%'

select * from PrgDocumentDef where ID = '674626AA-B627-4D72-94EB-5727F6C757BC'

select * from PrgDocument where DefId = '674626AA-B627-4D72-94EB-5727F6C757BC'

select * from FormTemplate where ProgramId  = 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1'

select * from FileData where ID = '711850C7-9214-4677-9D14-D2B68E5E76C3'

select * from PrgItem where StudentID = '730DE9DF-9AF4-40A5-B2C2-34D82CA3B02F'
select * from PrgItem where DefID = '9F8156ED-AC5B-432B-BB12-8F8B302EF02B' 


select * from PrgItemDef where ID = '9F8156ED-AC5B-432B-BB12-8F8B302EF02B' -- EP - Gifted Education

select * from FormTemplateLayout

select * from FormTemplate  where ProgramID = 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1'


select * from PrgDocument where ItemID = '3B8B7751-2B25-44F1-97C0-28620EAD8159'

select * from PrgDocumentDef where ID in ('80163C48-6FD3-4729-B4D6-E5F5EE236783', '674626AA-B627-4D72-94EB-5727F6C757BC')

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- item

select id.Name, i.* from dbo.PrgItem i join PrgItemDef id on i.DefID = id.ID where i.ID = '3B8B7751-2B25-44F1-97C0-28620EAD8159'
	select * from dbo.PrgVersion where ItemID = '3B8B7751-2B25-44F1-97C0-28620EAD8159'
	select st.Name, sd.Title, s.* from dbo.PrgSection s join PrgSectionDef sd on s.DefID = sd.ID join PrgSectionType st on sd.TypeID = st.ID where ItemID = '3B8B7751-2B25-44F1-97C0-28620EAD8159'
		select * from dbo.PrgIep where ID = '3B8B7751-2B25-44F1-97C0-28620EAD8159'
select dd.Name, fd.OriginalName, d.* from dbo.PrgDocument d join PrgDocumentDef dd on d.DefId = dd.id join FileData fd on d.ContentFileId = fd.ID where d.ItemId = '3B8B7751-2B25-44F1-97C0-28620EAD8159'
	-- select * from FileData where ID = '5AD3B71E-14EE-4078-AFDF-91E7598B5151' -- content file id.    EP.pdf
select id.Name, ty.Name, ft.Name, pif.* from dbo.PrgItemForm pif join PrgItem i on pif.ItemID = i.ID join PrgItemDef id on i.DefID = id.ID join FormInstance fi on pif.id = fi.Id join FormTemplate ft on fi.TemplateId = ft.Id join PrgItemFormType ty on pif.AssociationTypeID = ty.ID where pif.ItemID = '3B8B7751-2B25-44F1-97C0-28620EAD8159'
	select ft.Name, fi.* from FormInstance fi join FormTemplate ft on fi.TemplateId = ft.Id where fi.ID in (select ID from dbo.PrgItemForm where ItemID = '3B8B7751-2B25-44F1-97C0-28620EAD8159')
	--select * from dbo.PrgItemFormType where ID = 'DE0AFD97-84C8-488E-94DC-E17CAAA62082'
select rd.Name, * from dbo.PrgItemRel r join PrgItemRelDef rd on r.PrgItemRelDefID = rd.id where r.ResultingItemID = '3B8B7751-2B25-44F1-97C0-28620EAD8159'




select * from dbo.PrgItemForm where ID = 'D4953D8A-32D6-439F-9EC8-22735DD770E2'
select * from dbo.FormInstance where Id = 'D4953D8A-32D6-439F-9EC8-22735DD770E2'
select * from dbo.FormInstanceInterval where InstanceId = 'D4953D8A-32D6-439F-9EC8-22735DD770E2'
select * from dbo.PrgSection where FormInstanceID = 'D4953D8A-32D6-439F-9EC8-22735DD770E2'


select * from dbo.FormInstance where TemplateId = '94A59A3C-C6EE-4CB9-A993-3BE64D170D0C'
select * from dbo.FormTemplate where Id = '94A59A3C-C6EE-4CB9-A993-3BE64D170D0C'
select * from dbo.FormTemplateFormInterval where TemplateId = '94A59A3C-C6EE-4CB9-A993-3BE64D170D0C'
select * from dbo.FormTemplateLayout where TemplateId = '94A59A3C-C6EE-4CB9-A993-3BE64D170D0C'
select * from dbo.PrgSectionDef where FormTemplateID = '94A59A3C-C6EE-4CB9-A993-3BE64D170D0C'

select * from dbo.FormInstance where Id = 'D4953D8A-32D6-439F-9EC8-22735DD770E2'
select * from dbo.FormInstanceInterval where InstanceId = 'D4953D8A-32D6-439F-9EC8-22735DD770E2'
select * from dbo.PrgItemForm where ID = 'D4953D8A-32D6-439F-9EC8-22735DD770E2'
select * from dbo.PrgSection where FormInstanceID = 'D4953D8A-32D6-439F-9EC8-22735DD770E2'


----------------------------------- form template layout

select * from dbo.FormTemplate where Id = '94A59A3C-C6EE-4CB9-A993-3BE64D170D0C'

select t.Name, tl.*
from FormTemplateLayout tl 
join FormTemplate t on tl.TemplateId = t.id
where tl.TemplateId = '94A59A3C-C6EE-4CB9-A993-3BE64D170D0C'


select * from dbo.FormTemplateLayout where ControlId = 'BAB91733-FE3F-4573-8291-58102ADE860F'
select * from dbo.FormTemplateControl where Id = 'BAB91733-FE3F-4573-8291-58102ADE860F'
select * from dbo.FormTemplateControlProperty where ControlId = 'BAB91733-FE3F-4573-8291-58102ADE860F'
select * from dbo.FormTemplateInputItem where InputAreaId = 'BAB91733-FE3F-4573-8291-58102ADE860F'


select * from dbo.FormTemplateControl where TypeId = 'DB9713CF-24D9-4097-9E00-757E8630B14A'
select * from dbo.FormTemplateControlType where Id = 'DB9713CF-24D9-4097-9E00-757E8630B14A'



--------------------------------------- form template view
go

--create schema EXCENTDATATEAM

alter view EXCENTDATATEAM.FormTemplate
as
select TemplateID = t.ID, TemplateName = t.Name, TemplateType = tt.Name, IntervalSeries = fis.Name, Program = p.Name, t.Code, t.IntervalSeriesId, t.ProgramID, t.TypeId
from dbo.FormTemplate t 
join dbo.FormTemplateType tt on t.TypeId = tt.Id
join dbo.FormIntervalSeries fis on t.IntervalSeriesId = fis.Id
join dbo.Program p on t.ProgramID = p.ID
go




alter view EXCENTDATATEAM.FormTemplateLayout
as
select LayoutID = ftl.ID, 
	TemplateID = ft.ID, TemplateName = ft.Name, ControlID = ftc.ID, ControlCode = isnull(ftc.Code,''), ParentLayoutTemplate = isnull(pft.Name,''), ftl.Sequence
from dbo.FormTemplateLayout ftl 
join dbo.FormTemplate ft on ftl.TemplateId = ft.Id
join dbo.FormTemplateControl ftc on ftl.ControlId = ftc.ID
left join dbo.FormTemplateLayout pftl on ftl.ParentId = pftl.id
left join dbo.FormTemplate pft on pftl.TemplateId = pft.Id
go


-- form template control

alter view EXCENTDATATEAM.FormTemplateControl
as
select ControlID = tc.ID, ControlType = tct.Name, tc.TypeId, tc.IsShared, tc.IsRepeatable, ControlCode = isnull(tc.Code,'')
from dbo.FormTemplateControl tc
join dbo.FormTemplateControlType tct on tc.TypeId = tct.Id
go








-- input item (area)
alter view  EXCENTDATATEAM.FormTemplateInputItem -- AKA InputArea
as
select InputItemID = tii.ID,
	InputAreaID = tii.InputAreaId, TemplateControlID = tii.InputAreaId, -- Just want to show that these are the same value.  When it sticks in my head I'll revert to one column for this value.
	InputItemLabel = tii.Label, tii.Sequence, InputItemType = iit.Name, EnabledCondition = isnull(tii.EnabledCondition,''), tii.Code, tii.IsRequired, 
	tii.ShowIfInputItemId, ShowIfInputItem = shtii.Label,
	tii.ShowIfEquals, 
	tii.ShowIfValue, 
	tii.ShowIfOptionId, shoi.Label,
	tii.ParentId
from dbo.FormTemplateInputItem tii -- select * from dbo.FormTemplateInputItem where InputAreaID in (select ID from FormTemplateControl) ---- 100 %
join EXCENTDATATEAM.FormTemplateControl tc on tii.InputAreaId = tc.ControlID 
join  dbo.FormTemplateInputItemType iit on tii.TypeId = iit.Id
left join dbo.FormTemplateInputItem shtii on tii.ShowIfInputItemId = shtii.Id
left join dbo.FormTemplateInputSelectFieldOption shoi on tii.ShowIfOptionId = shoi.ID
go


alter view  EXCENTDATATEAM.FormTemplateInputArea -- just an alias
as
select * from EXCENTDATATEAM.FormTemplateInputItem 
go


alter view EXCENTDATATEAM.FormInputValue
as
select FormInputValueID = fiv.Id,
	ValueType = cast(
		case 
			when fivdt.id is not null then 'Date'
			when fivev.id is not null then 'Enum'
			when fivfv.id is not null then 'Flag'
			when fivp.id is not null then 'Person'
			when fivsel.ValueId is not null then 'Select'
			when fivsv.Id is not null then 'Single Select'
			when fivtv.Id is not null then 'Text'
			when fivuv.Id is not null then 'User'
		end as varchar(50)),
	fiv.IntervalId,
	fiv.InputFieldId, ftii.InputItemLabel, 
	DateValue = fivdt.Value,
	EnumValue = ev.DisplayValue,
	FlagValue = fivfv.Value,
	PersonValue = fivp.ValueID, -- later on this can be set to the person name/title, whatever, if nec.
	SelectOption = fivselo.Label,
	SingleSelectOption = fivsvo.Label,
	TextValue = fivtv.Value,
	UserValue = fivuvp.FirstName+' '+fivuvp.LastName
from dbo.FormInputValue fiv 
join EXCENTDATATEAM.FormTemplateInputItem ftii on fiv.InputFieldId = ftii.InputItemID
left join dbo.FormInputDateValue fivdt on fiv.id = fivdt.id
left join dbo.FormInputEnumValue fivev on fiv.id = fivev.id 
	left join dbo.EnumValue ev on fivev.EnumValueId = ev.ID
left join dbo.FormInputFlagValue fivfv on fiv.id = fivfv.id
left join dbo.FormInputPersonValue fivp on fiv.id = fivp.id
left join dbo.FormInputSelection fivsel on fiv.id = fivsel.ValueId
	left join dbo.FormTemplateInputSelectFieldOption fivselo on fivsel.OptionId = fivselo.ID
left join dbo.FormInputSingleSelectValue fivsv on fiv.id = fivsv.Id
	left join dbo.FormTemplateInputSelectFieldOption fivsvo on fivsv.SelectedOptionId = fivsvo.ID
left join dbo.FormInputTextValue fivtv on fiv.id = fivtv.id
left join dbo.FormInputUserValue fivuv on fiv.id = fivuv.Id
	left join dbo.Person fivuvp on fivuv.ValueID = fivuvp.ID
--order by ValueType, InputItemLabel
go





-- form instance interval
select * from dbo.FormInstanceInterval where Id = 'ABC3481B-4948-4046-9B0F-178C2F627BB3'
select * from dbo.FormInputValue where IntervalId = 'ABC3481B-4948-4046-9B0F-178C2F627BB3'



-- right.  what's an interval?
select * from dbo.FormInterval where Id = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D'

-- what's a series?
select * from dbo.FormIntervalSeries where Id = '6E839019-46CC-4246-BB42-5CA42ED4AE6B' -- once

-- select * from dbo.FormInterval where SeriesId = '6E839019-46CC-4246-BB42-5CA42ED4AE6B'
-- select * from dbo.FormTemplate where IntervalSeriesId = '6E839019-46CC-4246-BB42-5CA42ED4AE6B' -- all templates that use a series of once






select * from dbo.FormInstanceInterval where IntervalId = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D'
select * from dbo.FormTemplateFormInterval where IntervalId = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D'





select * from dbo.FormInputValue where InputFieldId = '9BD0C775-AD94-46C3-953D-2005854E2D13'
select * from dbo.FormTemplateInputItem where Id = '9BD0C775-AD94-46C3-953D-2005854E2D13'




















select * from EXCENTDATATEAM.FormTemplate where Program = 'Gifted'
go

ALTER view EXCENTDATATEAM.FormInput
as
select ftl.TemplateID, ftl.TemplateName, 
	ft.Program,
	ftc.ControlType, ftc.ControlCode, ftc.IsShared, ftc.IsRepeatable, 
	tii.InputItemLabel, tii.InputItemType, InputItemCode = tii.Code, tii.IsRequired, tii.Sequence,
	iv.ValueType
from EXCENTDATATEAM.FormTemplate ft
join EXCENTDATATEAM.FormTemplateLayout ftl on ft.TemplateID = ftl.TemplateID
join EXCENTDATATEAM.FormTemplateControl ftc on ftl.ControlID = ftc.ControlID
join EXCENTDATATEAM.FormTemplateInputItem tii on ftc.ControlID = tii.InputAreaID
join EXCENTDATATEAM.FormInputValue iv on tii.InputItemID = iv.InputFieldId
--where ft.Program = 'Gifted'
--order by ft.TemplateName, tii.Sequence
go

-- form instance
alter view EXCENTDATATEAM.FormInstance
as
select FormInstanceID = fi.id, inp.*
from dbo.FormInstance fi  
join EXCENTDATATEAM.FormInput inp on fi.TemplateId = inp.TemplateID 
-- where inp.Program = 'Gifted'
-- order by inp.TemplateName, Sequence
go

select * from FormInstance
select * from PrgItemForm
go

alter view EXCENTDATATEAM.PrgItemForm
as
select FormName = id.Name, FormID = pif.ID, pif.ItemID, pif.AssociationTypeID
from dbo.PrgItemForm pif
join dbo.PrgItem i on pif.ItemID = i.ID
join dbo.PrgItemDef id on i.DefID = id.ID
go


select * from EXCENTDATATEAM.FormInstance
select * from EXCENTDATATEAM.PrgItemForm


select fi.Program, 
	pif.FormName, pif.ItemID,
	fi.TemplateName, 
	fi.ControlType, fi.InputItemLabel, fi.InputItemType, fi.InputItemCode, fi.ValueType,
	pif.FormID, pif.AssociationTypeID
from EXCENTDATATEAM.FormInstance fi 
join EXCENTDATATEAM.PrgItemForm pif on fi.FormInstanceID = pif.FormID
order by Program, FormName, TemplateName


select * from PrgItemDef where Name = 'EP - Gifted Education' and DeletedDate is null
-- select * from PrgItemDef where Name = 'EP - Gifted Education' and DeletedDate is not null --------- 97D5BB9E-D93D-43E9-BF07-68F30D0A2F94 this one was Special Ed instead of Gifted




select * from EXCENTDATATEAM.FormTemplateLayout -- select * from dbo.FormTemplateLayout
select * from EXCENTDATATEAM.FormTemplateControl
select * from EXCENTDATATEAM.FormTemplateInputItem 
select * from EXCENTDATATEAM.FormInputValue


go





select * from FormInstanceInterval order by InstanceId



















select * from dbo.FormInputValue where InputFieldId = '648B60B2-C1DB-4D43-9168-0BEF7B8798C8'
select * from dbo.FormTemplateInputItem where Id = '648B60B2-C1DB-4D43-9168-0BEF7B8798C8'
select * from dbo.FormTemplateInputSelectField where ID = '648B60B2-C1DB-4D43-9168-0BEF7B8798C8'
select * from dbo.FormTemplateInputSelectFieldOption where SelectFieldId = '648B60B2-C1DB-4D43-9168-0BEF7B8798C8'





select * from dbo.FormInputValue where Id = '5589225B-7631-4154-ACB4-1CDF3844EC52'











select * from dbo.FormInputTextValue where Id = '15DFA06B-8801-44F9-81BF-FBED5428F3A2'
select * from dbo.FormInputValue where Id = '15DFA06B-8801-44F9-81BF-FBED5428F3A2'


-- select * from dbo.FormInputSingleSelectValue where SelectedOptionId = '13FDB523-086D-402F-B5AC-0767000DFD34'
select * from dbo.FormTemplateInputItem where ShowIfOptionId = '13FDB523-086D-402F-B5AC-0767000DFD34'
select * from dbo.FormTemplateInputSelectFieldOption where ID = '13FDB523-086D-402F-B5AC-0767000DFD34'



select * from FormInputSingleSelectValue 


select * from dbo.FormInputSelection where OptionId = 'FF429812-907E-48CB-9B22-939FC1A407FE'
select * from dbo.FormTemplateInputSelectFieldOption where ID = 'FF429812-907E-48CB-9B22-939FC1A407FE'


select * from dbo.FormInputValue where ID = 'C8C48D17-D506-4D6F-96F2-3B68EEFF26BF'
select * from dbo.FormInputSelection 




select * from dbo.FormInputPersonValue where Id = '1AA31642-769A-4927-BE44-B550243203F7' -- valueid is null




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

declare @s varchar(150), @o varchar(150), @c varchar(150), @g varchar(36) ; select @g = '9BD0C775-AD94-46C3-953D-2005854E2D13'

declare OC cursor for 
select s.name, o.name, c.name
from sys.schemas s join
sys.objects o on s.schema_id = o.schema_id join 
sys.columns c on o.object_id = c.object_id join
sys.types t on c.user_type_id = t.user_type_id
where o.type = 'U'
-- and s.name in ('dbo')
and (t.name = 'uniqueidentifier' or t.name = 'varchar' and c.max_length = 150)
-- and o.name not like '%[_]%'
order by o.name, c.name

open OC
fetch OC into @s, @o, @c

while @@FETCH_STATUS = 0
begin

exec ('if exists (select 1 from '+@s+'.'+@o+' where '+@c+' = '''+@g+''')
print ''select * from '+@s+'.'+@o+' where '+@c+' = '''''+@g+'''''''')

fetch OC into @s, @o, @c
end

close OC
deallocate OC

