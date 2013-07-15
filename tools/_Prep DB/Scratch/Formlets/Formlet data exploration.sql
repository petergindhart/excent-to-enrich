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


select * from FormInterval where Id = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D'



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
select TemplateID = t.ID, TemplateName = t.Name, TemplateType = tt.Name, 
	FormInterval = fi.Name, IntervalSeriesID = t.IntervalSeriesId, IntervalSeries = fis.Name, 
	Program = p.Name, t.Code, t.ProgramID, t.TypeId
from dbo.FormTemplate t 
join dbo.FormTemplateType tt on t.TypeId = tt.Id
join dbo.FormIntervalSeries fis on t.IntervalSeriesId = fis.Id
join dbo.Program p on t.ProgramID = p.ID
join dbo.FormTemplateFormInterval ftfi on t.Id = ftfi.TemplateId
join dbo.FormInterval fi on ftfi.IntervalId = fi.Id
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



ALTER view EXCENTDATATEAM.FormInput
as
select ftl.TemplateID, ftl.TemplateName, 
	ft.Program,
	ftc.ControlType, ftc.ControlCode, ftc.IsShared, ftc.IsRepeatable, 
	tii.InputItemLabel, tii.InputItemType, InputItemCode = tii.Code, tii.IsRequired, tii.Sequence,
	iv.InputFieldID, iv.ValueType
from EXCENTDATATEAM.FormTemplate ft
join EXCENTDATATEAM.FormTemplateLayout ftl on ft.TemplateID = ftl.TemplateID
join EXCENTDATATEAM.FormTemplateControl ftc on ftl.ControlID = ftc.ControlID
join EXCENTDATATEAM.FormTemplateInputItem tii on ftc.ControlID = tii.InputAreaID
join EXCENTDATATEAM.FormInputValue iv on tii.InputItemID = iv.InputFieldId -- select * from EXCENTDATATEAM.FormInputValue
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


alter view EXCENTDATATEAM.PrgItemForm
as
select FormName = id.Name, FormInstanceID = pif.ID, pif.ItemID, pif.AssociationTypeID
from dbo.PrgItemForm pif
join dbo.PrgItem i on pif.ItemID = i.ID
join dbo.PrgItemDef id on i.DefID = id.ID
go


alter view EXCENTDATATEAM.FormInstanceItem
as
select fi.Program, 
	pif.FormName, pif.ItemID,
	fi.TemplateName, pif.FormInstanceID, 
	fi.ControlType, fi.InputItemLabel, fi.InputItemType, fi.InputItemCode, fi.ValueType, fi.Sequence,
	pif.AssociationTypeID
from EXCENTDATATEAM.FormInstance fi 
join EXCENTDATATEAM.PrgItemForm pif on fi.FormInstanceID = pif.FormInstanceID
--order by Program, FormName, TemplateName, Sequence
go

alter view EXCENTDATATEAM.PrgSection
as
select st.Name, sd.Code, sd.Title, s.*
from dbo.PrgSection s
join dbo.PrgSectionDef sd on s.DefID = sd.ID
join dbo.PrgSectionType st on sd.TypeID = st.ID
--where s.ItemID = '3B8B7751-2B25-44F1-97C0-28620EAD8159'
go



create view EXCENTDATATEAM.FormInterval
as
select FormIntervalID = fi.id, FormInterval = fi.Name, fi.Sequence, fi.SeriesId, FormIntervalSeries = fis.Name, CumulativeUpToID = fi.CumulativeUpTo, CumulativeUpTo = fic.Name
from dbo.FormInterval fi 
join dbo.FormIntervalSeries fis on fi.SeriesId = fis.Id
left join dbo.FormInterval fic on fi.CumulativeUpTo = fic.Id
go


select * 
from EXCENTDATATEAM.PrgSection ps
join EXCENTDATATEAM.FormInstanceItem fii on ps.FormInstanceID = fii.FormInstanceID
-- query works


select * from EXCENTDATATEAM.FormTemplateLayout -- select * from dbo.FormTemplateLayout
select * from EXCENTDATATEAM.FormTemplateControl
select * from EXCENTDATATEAM.FormTemplateInputItem 
select * from EXCENTDATATEAM.FormInputValue
select * from EXCENTDATATEAM.PrgItemForm 
select * from EXCENTDATATEAM.FormInstance
select * from EXCENTDATATEAM.FormInstanceItem


go



------------------------------------------------------------------------
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
select * from Forminstance where ID = '177C67F9-50F1-40AA-939A-25453D70B76E'
select * from PrgItemDef where Name = 'EP - Gifted Education' and DeletedDate is null
-- select * from PrgItemDef where Name = 'EP - Gifted Education' and DeletedDate is not null --------- 97D5BB9E-D93D-43E9-BF07-68F30D0A2F94 this one was Special Ed instead of Gifted
select * from dbo.FormInstanceInterval

select s.name, o.name, c.name
from sys.schemas s 
join sys.objects o on s.schema_id = o.schema_id 
join sys.columns c on o.object_id = c.object_id 
where o.name like '%Interval%'

select * from FormInterval order by Sequence -- value, Q1, Q2, Q3, Q4, year
select * from FormIntervalSeries -- once, quarterly
select * from FormTemplateFormInterval -- TemplateID, IntervalID.  Each template has an interval associated with it
select * from FormInstanceInterval -- The instance probably takes the interval from FormTemplateFormInterval
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




select NameType = case when name like '%.%' then 	left(name, patindex('%.%', Name)-1) else Name end, count(*) tot
from dbo.Feature 
group by case when name like '%.%' then 	left(name, patindex('%.%', Name)-1) else Name end

select * from Feature where name like 'Programs%' order by name
-- Special Ed should be okay for Gifted, because Gifted students are "special"
select * from PrgItemDef where name like 'EP%'
--select * from dbo.PrgItemType where ID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870'
select * from dbo.PrgItemType where ID = 'AA8A82A3-ED26-49AD-BA9E-56004D8779E5'
select FeatureID, count(*) tot from PrgItemType group by FeatureID -- okay to have more than one record with the same featureID, so we can add an EP with the same FeatureID as an IEP
select * from dbo.Feature where ID = '426D5613-B398-4556-BF3F-765040E5617F'
select * from dbo.PrgItemType where FeatureID = '426D5613-B398-4556-BF3F-765040E5617F'
select * from dbo.PrgSectionType where FeatureID = '426D5613-B398-4556-BF3F-765040E5617F'
select * from dbo.Program where FeatureID = '426D5613-B398-4556-BF3F-765040E5617F'
select * from dbo.Report where ViewFeatureID = '426D5613-B398-4556-BF3F-765040E5617F'
select * from dbo.ReportType where ViewFeatureId = '426D5613-B398-4556-BF3F-765040E5617F'


-- select newid()


select c.name+', '
from sys.objects o 
join sys.columns c on o.object_id = c.object_id 
where o.name = 'PrgItem'


--select * from dbo.PrgItemDef where TypeID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870'
--select * from dbo.PrgItemRelDef where InitiatingItemTypeID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870'
--select * from dbo.PrgItemRelDef where ResultingItemTypeID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870'
--select * from dbo.PrgItemTypeAttributes where PrgItemTypeID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870'
--select * from dbo.PrgMilestoneEvent where ItemTypeID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870'


-- the program item type used was IEP, but we want to see if it can be EP, so create a prgitemtype of EP and update the PrgItemDef record to refer to the EP type
insert PrgItemType (ID, Name, Description, FeatureID, CanCopy) values ('AA8A82A3-ED26-49AD-BA9E-56004D8779E5', 'EP', 'TEST ONLY BY GEORGE', '426D5613-B398-4556-BF3F-765040E5617F', 0)
update PrgItemDef set TypeID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870' where ID = '9F8156ED-AC5B-432B-BB12-8F8B302EF02B'
delete prgitemtype where ID = 'AA8A82A3-ED26-49AD-BA9E-56004D8779E5'

--   well, I guess that answers that question......................................
--TypeId "aa8a82a3-ed26-49ad-ba9e-56004d8779e5" cannot be mapped to a class. 
--Please apply a TypeId("aa8a82a3-ed26-49ad-ba9e-56004d8779e5") attribute to VC3.TestView.Business.PrgItem or one of its sub classes. 
--Known TypeIds: 
--	'03670605-58B2-40B2-99D5-4A1A70156C73'->PrgIntervention, 
--	'1511F713-B210-40BB-ACCA-624212BB38F4'->PrgActivity, 
--	'6002D022-4D8F-48A9-A0B7-918863631B13'->PrgActivity, 
--	'D7B183D8-5BBD-4471-8829-3C8D82A92478'->PrgSimplePlan, 
--	'283EC3E3-FA3E-4D68-A82D-8AA65EEC17DD'->PrgMatrixOfServices, 
--	'3322BB0A-BD76-4E38-9019-0E4DAA985901'->PrgMatrixOfServices, 
--	'A5990B5E-AFAD-4EF0-9CCA-DC3685296870'->PrgIep, 
--	'B1B9173E-C987-4752-82DE-D7237A2BC060'->PrgMeeting, 
--	'2A37FB49-1977-48C7-9031-56148AEE8328'->PrgActivity Support 
--Code: UC-8G-HT



update SystemSettings set SecurityRebuiltDate = NULL


-- select * from FormInputSingleSelectValue where ID = '663588E8-2B8A-4BB0-8782-64C80B250DEE'


Select * from EXCENTDATATEAM.prgsection

select * from PrgItem
select * from PrgVersion where ItemID = '0D629769-1716-46C4-876B-E23400372A0F' -- 

select * from PrgItem where Id = '3B8B7751-2B25-44F1-97C0-28620EAD8159'

select newID()

select * from PrgSection where DefID = 'D675D88A-199A-4F1C-81D0-1F497B472EC7'


--DC3596BD-8ECF-475A-966D-0D090C825580 -- template
select * from EXCENTDATATEAM.FormInputValue


select * from dbo.FormInputValue where InputFieldId = 'C0803C31-6D32-4700-A1EA-03B93F1369BA'
select * from dbo.FormTemplateInputItem where Id = 'C0803C31-6D32-4700-A1EA-03B93F1369BA'



select * from FormInterval where ID = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D'
select * from dbo.FormInstanceInterval where Id = 'DF5C83ED-3A44-4F0B-BD90-2CB452A11B40'
select * from dbo.FormInputValue where IntervalId = 'DF5C83ED-3A44-4F0B-BD90-2CB452A11B40'



select * from dbo.FormInputValue where InputFieldId = 'A2E3EB67-6A1F-4B88-99C9-4027B37D4ECA'
select * from dbo.FormTemplateInputItem where Id = 'A2E3EB67-6A1F-4B88-99C9-4027B37D4ECA'
select * from dbo.FormTemplateInputSelectField where ID = 'A2E3EB67-6A1F-4B88-99C9-4027B37D4ECA'
select * from dbo.FormTemplateInputSelectFieldOption where SelectFieldId = 'A2E3EB67-6A1F-4B88-99C9-4027B37D4ECA'


--select * from PrgItemDef where ID = '9F8156ED-AC5B-432B-BB12-8F8B302EF02B' -- EP - Gifted Education

--select * from Student where lastname like 'Gidd%'

-- 372582	COURTNEY	LYNN	GIDDINGS	9644FD42-018F-4AB9-9D49-A557B7415C93

select * from PrgItem where ID = '3B8B7751-2B25-44F1-97C0-28620EAD8159'

select * from StudentSchool where StudentID = '9644FD42-018F-4AB9-9D49-A557B7415C93' and RosterYearID = 'A332BC88-B400-42E2-85AA-3A7F8C6ACA54'
-- select * from RosterYear where getdate() between startdate and EndDate

select * from StudentGradeLevelHistory where StudentID = '9644FD42-018F-4AB9-9D49-A557B7415C93'


select * from GradeLevel where ID = 'D3C1BD80-0D32-4317-BAB8-CAF196D19350' -- 03
--BE4F651A-D5B5-4B05-8237-9FD33E4D2B68 -- 04

select * from EXCENTDATATEAM.FormInput where TemplateID = 'DC3596BD-8ECF-475A-966D-0D090C825580' order by Sequence

select * from FormInputValue 

select * from dbo.FormTemplateControl where TypeId = 'D4C549BA-5874-4693-BB20-A890F2D3C274'
select * from dbo.FormTemplateControlType where Id = 'D4C549BA-5874-4693-BB20-A890F2D3C274'








--create view [dbo].[FormTemplateLayoutView]
--as
	select ftl.*, ControlTypeId = ftc.TypeId
	from 
		FormTemplateLayout ftl join
		FormTemplateControl ftc on ftl.ControlId = ftc.ID

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- prepare test student record - ensure enrollment
insert StudentGradeLevelHistory values ('9644FD42-018F-4AB9-9D49-A557B7415C93', 'BE4F651A-D5B5-4B05-8237-9FD33E4D2B68', '8/21/2012', NULL)

-- PrgInvolvement
insert PrgInvolvement (ID, StudentID, ProgramID, VariantID, StartDate, IsManuallyEnded) 
	values ('A959F58F-A533-4C04-86F5-0E0DC77DA669', '9644FD42-018F-4AB9-9D49-A557B7415C93', 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1', '43E1AF01-0A27-41B3-90E1-D7322CE5CD37', '4/1/2013', 0)

-- PrgItem
insert PrgItem (ID, DefID, StudentID, StartDate, EndDate, ItemOutcomeID, CreatedDate, CreatedBy, EndedDate, EndedBy, 
	SchoolID, GradeLevelID, InvolvementID, StartStatusID, EndStatusID, 
	PlannedEndDate, IsEnded, LastModifiedDate, LastModifiedByID, Revision, IsApprovalPending, ApprovedDate, ApprovedByID)
	values ('0D629769-1716-46C4-876B-E23400372A0F', '9F8156ED-AC5B-432B-BB12-8F8B302EF02B', '9644FD42-018F-4AB9-9D49-A557B7415C93', '4/2/2013', NULL, NULL, getdate(), 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', NULL, NULL, 
		'A60E5028-E178-4AD1-9601-7DE7F6536022', 'BE4F651A-D5B5-4B05-8237-9FD33E4D2B68', 'A959F58F-A533-4C04-86F5-0E0DC77DA669', '5671233A-B650-400C-955F-184930A33A85', NULL,
		'3/31/2014', 0, getdate(), 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', 0, 0, NULL, NULL)

-- FormInstance
insert FormInstance (ID, TemplateId) values ('C4831254-69E9-4D26-8EC6-9170059CFD53', 'DC3596BD-8ECF-475A-966D-0D090C825580') -- generated newid()

insert PrgItemForm (ID, ItemID, CreatedDate, CreatedBy, AssociationTypeID) -- ID is the FormInstanceID
	values ('C4831254-69E9-4D26-8EC6-9170059CFD53', '0D629769-1716-46C4-876B-E23400372A0F', getdate(), 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', 'DE0AFD97-84C8-488E-94DC-E17CAAA62082')

-- Attempted to initialize PrgIep 0d629769-1716-46c4-876b-e23400372a0f*A5990B5E-AFAD-4EF0-9CCA-DC3685296870, however it didn't initialize. This may be because it has been deleted. Support Code: A4-PU-EN

-- though it would be better for the FL clients that wish to see a separation between disabled and gifted, this is how it is for now.
insert PrgIep values ('0D629769-1716-46C4-876B-E23400372A0F', 0)

insert FormInstanceInterval (id, InstanceId, IntervalId) values ('84BD44B5-60CB-46F7-B6FC-CCB1B25E341E', 'C4831254-69E9-4D26-8EC6-9170059CFD53', 'FBE8314C-E0A0-4C5A-9361-7201081BD47D')



--------------------------------------------------------- dates

--5A25FA40-9E96-4421-88C2-24C177CAF414	0	Date	EP Meeting Date:
--9BD0C775-AD94-46C3-953D-2005854E2D13	1	Date	EP Initiation Date:
--2C41063F-F8A1-45A9-9A7F-96794A77419B	2	Date	Last EP Date:
--FDD3B407-77D3-4FB2-8EAE-3DE0D35A6821	3	Date	Special Review Date:
--D022A416-7E74-4CF0-9007-4224949D1702	4	Date	Duration Date:
--A2E3EB67-6A1F-4B88-99C9-4027B37D4ECA	5	Single Select	EP Level:

-- hard code the ID from FormInstance Interval : 84BD44B5-60CB-46F7-B6FC-CCB1B25E341E
select 'insert FormInputValue (ID, IntervalId, InputFieldId, Sequence) values ('''+ convert(varchar(36), newID())+''', ''84BD44B5-60CB-46F7-B6FC-CCB1B25E341E'', '''+convert(varchar(36), InputFieldId)+''', 0) --'+ convert(varchar(3), Sequence)+' '+ValueType+' '+InputItemLabel
from EXCENTDATATEAM.FormInput 
where TemplateID = 'DC3596BD-8ECF-475A-966D-0D090C825580' 
order by Sequence

insert FormInputValue (ID, IntervalId, InputFieldId, Sequence) values ('A16681CD-FE2F-4B06-939D-FAC428A4D0D0', '84BD44B5-60CB-46F7-B6FC-CCB1B25E341E', '5A25FA40-9E96-4421-88C2-24C177CAF414', 0) --0 Date EP Meeting Date:
insert FormInputValue (ID, IntervalId, InputFieldId, Sequence) values ('0D5BE69D-7305-436C-A331-518C524D8A90', '84BD44B5-60CB-46F7-B6FC-CCB1B25E341E', '9BD0C775-AD94-46C3-953D-2005854E2D13', 0) --1 Date EP Initiation Date:
insert FormInputValue (ID, IntervalId, InputFieldId, Sequence) values ('3D74B0A7-77B2-4B04-80C0-41188EB717C7', '84BD44B5-60CB-46F7-B6FC-CCB1B25E341E', '2C41063F-F8A1-45A9-9A7F-96794A77419B', 0) --2 Date Last EP Date:
insert FormInputValue (ID, IntervalId, InputFieldId, Sequence) values ('FFF38ADF-05D2-4044-940B-34C4B071342C', '84BD44B5-60CB-46F7-B6FC-CCB1B25E341E', 'FDD3B407-77D3-4FB2-8EAE-3DE0D35A6821', 0) --3 Date Special Review Date:
insert FormInputValue (ID, IntervalId, InputFieldId, Sequence) values ('EC2824C7-2942-47E0-8E6D-64A6CE72D2E6', '84BD44B5-60CB-46F7-B6FC-CCB1B25E341E', 'D022A416-7E74-4CF0-9007-4224949D1702', 0) --4 Date Duration Date:
insert FormInputValue (ID, IntervalId, InputFieldId, Sequence) values ('240D5A4A-D598-4D94-A60D-5F1CD1034F39', '84BD44B5-60CB-46F7-B6FC-CCB1B25E341E', 'A2E3EB67-6A1F-4B88-99C9-4027B37D4ECA', 0) --5 Single Select EP Level:

--Msg 547, Level 16, State 0, Line 1
--The INSERT statement conflicted with the FOREIGN KEY constraint "FK_FormInputValue#Interval#Values". The conflict occurred in database "Enrich_DC4_FL_Collier_SQL2012", table "dbo.FormInstanceInterval", column 'Id'.
--The statement has been terminated.

insert FormInputDateValue (ID, Value) values ('A16681CD-FE2F-4B06-939D-FAC428A4D0D0', '4/1/2013') --0 Date EP Meeting Date:
insert FormInputDateValue (ID, Value) values ('0D5BE69D-7305-436C-A331-518C524D8A90', '4/2/2013') --1 Date EP Initiation Date:
insert FormInputDateValue (ID, Value) values ('3D74B0A7-77B2-4B04-80C0-41188EB717C7', '4/2/2013') --2 Date Last EP Date:
insert FormInputDateValue (ID, Value) values ('FFF38ADF-05D2-4044-940B-34C4B071342C', NULL) --3 Date Special Review Date:
insert FormInputDateValue (ID, Value) values ('EC2824C7-2942-47E0-8E6D-64A6CE72D2E6', '4/1/2014') --4 Date Duration Date:
insert FormInputSingleSelectValue (ID, SelectedOptionId) values ('240D5A4A-D598-4D94-A60D-5F1CD1034F39', 'B8E49B16-F1D3-451E-97B1-5DD41D1CB098') --5 Single Select EP Level:


-- there was no version record for this one
insert PrgSection (ID, DefID, ItemID, VersionID, FormInstanceID, OnLatestVersion) values ('C3BF166D-E6AB-4F41-944D-385389D2B0AE', 'D675D88A-199A-4F1C-81D0-1F497B472EC7', '0D629769-1716-46C4-876B-E23400372A0F', NULL, 'C4831254-69E9-4D26-8EC6-9170059CFD53', 1)
-- (triggers were fired off after inserting this record)


--------------------------------------------------------- Meeting Part. Final.
select fi.*
-- select 'insert FormInputValue (ID, IntervalId, InputFieldId, Sequence) values ('''+ convert(varchar(36), newID())+''', ''84BD44B5-60CB-46F7-B6FC-CCB1B25E341E'', '''+convert(varchar(36), InputFieldId)+''', 0) --'+ convert(varchar(3), Sequence)+' '+ValueType+' '+InputItemLabel
from EXCENTDATATEAM.FormInput fi
--where fi.TemplateID = 'DC3596BD-8ECF-475A-966D-0D090C825580' 
order by fi.IsRequired desc, fi.TemplateName, fi.Sequence



select 'insert FormInputValue (ID, IntervalId, InputFieldId, Sequence) values ('''+ convert(varchar(36), newID())+''', ''84BD44B5-60CB-46F7-B6FC-CCB1B25E341E'', '''+convert(varchar(36), InputFieldId)+''', 0) --'+ convert(varchar(3), Sequence)+' '+ValueType+' '+InputItemLabel
from EXCENTDATATEAM.FormInput fi
where fi.TemplateID = '6698C009-F059-4DF4-B724-A580A22C160B' 
order by fi.IsRequired desc, fi.TemplateName, fi.Sequence

insert FormInputValue (ID, IntervalId, InputFieldId, Sequence) values ('650F6EF8-8EAF-41DC-A968-9E01B5B5B87E', '84BD44B5-60CB-46F7-B6FC-CCB1B25E341E', 'A8893B61-8F90-4337-9D4A-B570949CEAD4', 0) --0 Flag Meeting participants finalized

----- this is how I found out what to insert and where
--select * from dbo.FormInputValue where InputFieldId = 'A8893B61-8F90-4337-9D4A-B570949CEAD4'
--select * from dbo.FormTemplateInputItem where Id = 'A8893B61-8F90-4337-9D4A-B570949CEAD4'
--select * from EXCENTDATATEAM.FormInputValue where InputFieldId = 'A8893B61-8F90-4337-9D4A-B570949CEAD4'
--select * from FormInputFlagValue 
insert FormInputFlagValue values ('650F6EF8-8EAF-41DC-A968-9E01B5B5B87E', 1)

select newid()
insert PrgSection (ID, DefID, ItemID, VersionID, FormInstanceID, OnLatestVersion) values ('F69A2379-E2C9-4ABF-8EAF-ED3F0C1A3DCF', '1734C532-2D04-4F51-9B9F-93731D9C0CDA', '0D629769-1716-46C4-876B-E23400372A0F', NULL, 'C4831254-69E9-4D26-8EC6-9170059CFD53', 1)

select * from PrgItem

select * from EXCENTDATATEAM.PrgSection order by title

select * from EXCENTDATATEAM.FormInstance order by TemplateName

select * from FormInstance where ID = 'BBB7CE75-7324-443B-B82A-841C059A92BD'


-- PrgInvolvementID, PrgItemID, 

select * from EXCENTDATATEAM.FormTemplate where Program = 'Gifted' order by TemplateName

select * from EXCENTDATATEAM.FormInputValue


go


select * from FormInterval order by Sequence

select * from FormIntervalSeries

go

select * from EXCENTDATATEAM.FormInterval order by Sequence





select * from FormIntervalSeries where Id = 'AE9D47E2-5F84-4017-AACE-7D6DF1C9590F'


select * from dbo.FormInterval where Id = '9FF2068B-724E-4F50-B90D-65983BCF1E3A'

---------------------------------------------------------------------------------------------------------------------------------------------------------


declare @s varchar(150), @o varchar(150), @c varchar(150), @g varchar(36) ; select @g = '9FF2068B-724E-4F50-B90D-65983BCF1E3A'

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

