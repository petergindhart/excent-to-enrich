
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.EPPresentLevelsPivot') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.EPPresentLevelsPivot
GO

create view x_LEGACYGIFT.EPPresentLevelsPivot
as
select u.*, InputItemType =  iit.Name, InputItemTypeID = iit.ID
from (
	select s.EPRefID, PresentLevelType = 'pl1Contribute', PresentLevel = cast(NULL as varchar(max)), InputFieldID = '4F8DA6FB-9CF6-4056-9D06-534A675E7380' -- pl1Contribute 
	from x_LEGACYGIFT.Transform_Student s
	union all
	select s.EPRefID, PresentLevelType = 'pl2Strengths', PresentLevel = cast(NULL as varchar(max)), InputFieldID = '2E21A087-BDA2-435E-8D70-2701D27C9C96' -- pl2Strengths 
	from x_LEGACYGIFT.Transform_Student s
	union all
	select s.EPRefID, PresentLevelType = 'pl3Beyond', PresentLevel = cast(NULL as varchar(max)), InputFieldID = '019D9A47-60B0-405C-B585-7C0616F18FAA' -- pl3Beyond 
	from x_LEGACYGIFT.Transform_Student s
	union all
	select s.EPRefID, PresentLevelType = 'pl4Results', PresentLevel = cast(NULL as varchar(max)), InputFieldID = '33A9E439-CD8C-4E3C-B334-9F8B37185695' -- pl4Results
	from x_LEGACYGIFT.Transform_Student s
	union all
	select s.EPRefID, PresentLevelType = 'pl5Language', PresentLevel = cast(NULL as varchar(max)), InputFieldID = '04E73B63-654F-4B20-88A1-BFF9D214E9F5' -- pl5Language 
	from x_LEGACYGIFT.Transform_Student s
	) u join
FormTemplateInputItem ftii on u.InputFieldID = ftii.Id join
FormTemplateInputItemType iit on ftii.TypeId = iit.Id
go

--IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_FormInput_EP_Present_Levels_TextID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
--BEGIN
--create table x_LEGACYGIFT.MAP_FormInput_EP_Present_Levels_TextID (
--	EPRefID	varchar(150)	not null,
--	InputFieldID	uniqueidentifier not null,
--	DestID	uniqueidentifier	not null -- InstanceInputID
--)
--END
--go

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_FormInput_EP_Present_Levels_Text') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_FormInput_EP_Present_Levels_Text
GO

create view x_LEGACYGIFT.Transform_FormInput_EP_Present_Levels_Text
as
select f.EPRefID, 
	v.FormTemplateID,
	v.InputFieldID,
	ftii.Sequence, 
	ftii.Code, 
	ftii.Label, 
	InputItemType = iit.Name, 
	f.FormInstanceID, 
	mv.DestID,
	plp.PresentLevel
from x_LEGACYGIFT.Transform_PrgSectionFormInstance f join 
	x_LEGACYGIFT.FormInputValueFields v on f.TemplateID = v.FormTemplateID join
	dbo.FormTemplateInputItem ftii on v.InputFieldID = ftii.Id join 
	dbo.FormTemplateInputItemType iit on ftii.TypeId = iit.Id left join 
	x_LEGACYGIFT.EPPresentLevelsPivot plp on f.EPRefID = plp.EPRefID and ftii.id = plp.InputFieldID left join 
		x_LEGACYGIFT.MAP_FormInputValueID mv on plp.InputFieldID = mv.InputFieldID and f.FormInstanceIntervalID = mv.IntervalID left join 
	dbo.FormInputTextValue tv on mv.DestID = tv.Id
where f.TemplateID = '347DBCFC-495B-43A9-89B3-12430552D080' --Bay
and plp.InputItemType = 'Text'
go
-- 


