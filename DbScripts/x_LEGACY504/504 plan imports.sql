

/*

delete PrgSection where ID in (select SectionDestID from x_LEGACY504.Transform_504Data)
delete FormInstanceInterval where ID in (select InstanceIntervalDestID from x_LEGACY504.Transform_504Data)
delete FormInstance where ID in (select FormInstanceDestID from x_LEGACY504.Transform_504Data)
-- delete PrgItemForm where ID in (select x.FormInstanceDestID from x_LEGACY504.Transform_504Data x) -- may have been cascade deleted
	delete PrgDocument where VersionID in (select VersionDestID from x_LEGACY504.Transform_504Data)
delete PrgVersion where ID in (select VersionDestID from x_LEGACY504.Transform_504Data)
	delete PrgItemRel where ResultingItemID in (select ItemDestID from x_LEGACY504.Transform_504Data)
delete PrgItem where ID in (select ItemDestID from x_LEGACY504.Transform_504Data)
	delete PrgDocument where VersionID in (select VersionID from PrgItem where InvolvementID in (select InvolvementDestID from x_LEGACY504.Transform_504Data)) -- 350
--
	delete PrgSection where FormInstanceID in (select FormInstanceID from PrgItemForm where ItemID in (select ID from PrgItem where InvolvementID in (select InvolvementDestID from x_LEGACY504.Transform_504Data))) -- 1617 
	delete PrgItemForm where ItemID in (select ID from PrgItem where InvolvementID in (select InvolvementDestID from x_LEGACY504.Transform_504Data)) -- 19
		delete PrgDocument where ItemID in (select ID from PrgItem where InvolvementID in (select InvolvementDestID from x_LEGACY504.Transform_504Data)) -- 16
	delete PrgItem where InvolvementID in (select InvolvementDestID from x_LEGACY504.Transform_504Data) -- 19
delete PrgInvolvement where ID in (select InvolvementDestID from x_LEGACY504.Transform_504Data) -- 3563

(4466 row(s) affected)

(4466 row(s) affected)

(4466 row(s) affected)

(0 row(s) affected)

(4466 row(s) affected)

(0 row(s) affected)

(4466 row(s) affected)

(0 row(s) affected)

(0 row(s) affected)

(0 row(s) affected)

(0 row(s) affected)

(0 row(s) affected)

(4466 row(s) affected)


select 'drop table '+s.Name+'.'+o.name 
from sys.schemas s 
join sys.objects o on s.schema_id = o.schema_id
where o.name like '%504%'
-- and s.name like '%504%'
order by s.name, o.name


drop table LEGACYSPED.MAP_504data
drop table LEGACY504.MAP_504data_Dates
--drop table x_LEGACY504.Student504Dates

drop view LEGACY504.Transform_504dates
drop view LEGACYSPED.Transform_504Data
drop view LEGACYSPED.Transform_504dates

drop schema LEGACY504


*/


--select * from PrgItemDef where name like '%504%'
--select * from PrgItemDef where ID = 'FE2248C1-8BD6-4010-B02F-79C9F830E5AC'

--declare 
--	@ID	uniqueidentifier,
--	@TypeID	uniqueidentifier,
--	@ProgramID	uniqueidentifier,
--	@StatusID	uniqueidentifier,
--	@Name	varchar(50),
--	@Description	text,
--	@DeletedDate	datetime,
--	@UseTeam	bit,
--	@TeamLabel	varchar(50),
--	@UsePlannedEndDate	bit,
--	@LastModifiedDate	datetime,
--	@LastModifiedUserID	uniqueidentifier,
--	@UseComments	bit,
--	@CanCopy	bit,
--	@MeetingExcusalFormTemplateId	uniqueidentifier,
--	@TeamLeadRequired	bit,
--	@StereotypeID	uniqueidentifier,
--	@IsApprovalRequired	bit,
--	@UseLimitedValidation	bit,
--	@TypeLabel	varchar(50)

--if not exists (select 1 from PrgItemDef where ID = 'FE2248C1-8BD6-4010-B02F-79C9F830E5AC')
--insert PrgItemDef (ID, TypeID, ProgramID, StatusID, Name, Description, DeletedDate, UseTeam, TeamLabel, UsePlannedEndDate, LastModifiedDate, LastModifiedUserID, UseComments, CanCopy, MeetingExcusalFormTemplateId, TeamLeadRequired, StereotypeID, IsApprovalRequired, UseLimitedValidation, TypeLabel)
--values ('FE2248C1-8BD6-4010-B02F-79C9F830E5AC', 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870', 'A1F33015-4D93-4768-B273-EA0CA77274BE', '63E39991-4C5A-48A4-B1B4-93062EA02B89', 'Converted 504 Placeholder', NULL,	NULL,	0,	NULL,	1, getdate(), '514898FB-5257-497E-B637-5688643D25C9', 0, 	0, 	NULL, 	0, 	NULL, 	0, 	1, 	NULL)
---- modify the above to return the values for different databases, which may have been configured with different GUIDs
--go

create schema x_LEGACY504
go



alter view x_LEGACY504.Student504Dates
as
select StudentNumber = ID, StartDate = cast(StartDate as datetime), EndDate = cast(EndDate as datetime) from x_LEGACY504.Student504Dates where ID <> ''
go



if not exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACY504' and o.name = 'MAP_504data')
begin
create table x_LEGACY504.MAP_504data (
StudentNumber	varchar(20)  not null,
StudentID uniqueidentifier not null,
InvolvementDestID	uniqueidentifier not null, 
ItemDestID	uniqueidentifier not null,
VersionDestID uniqueidentifier not null,
FormInstanceDestID uniqueidentifier not null,
InstanceIntervalDestID uniqueidentifier not null,
SectionDestID uniqueidentifier not null -- currently there is only one section referencing this itemdef
)

alter table x_LEGACY504.MAP_504data add constraint PK_MAP_504data primary key (StudentID)
end

go


if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACY504' and o.name = 'Transform_504Data')
drop view x_LEGACY504.Transform_504Data
go

create view x_LEGACY504.Transform_504Data
as 
select 
-- key
	StudentNumber = x.StudentNumber,
	StudentID = s.ID,
-- map ids
	InvolvementDestID = isnull(m.InvolvementDestID, inv.ID),
	ItemDestID = isnull(m.ItemDestID, item.ID),
	VersionDestID = isnull(m.VersionDestID, ver.ID),
	--ItemFormID = itf.ID, --------------------------------------------------- testing only
	FormInstanceDestID = isnull(m.FormInstanceDestID, fi.ID),
	InstanceIntervalDestID = isnull(m.InstanceIntervalDestID, fii.ID),
	SectionDestID  = isnull(sec.ID, m.SectionDestID),
-- Other Common fields
	StartDate = x.StartDate,
	EndDate = x.EndDate,
	TodayDate = getdate(),
	AdminID = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB',
	IsApprovalPending = 0,
-- PrgInvolvement (ID, StudentID, ProgramID, VariantID, StartDate, IsManuallyEnded)
	ProgramID = 'A1F33015-4D93-4768-B273-EA0CA77274BE', -- programid -- select * from Program
	VariantID = '759C6054-DF3B-452E-AF68-A8EAC2EEA182', -- variantid
	IsManuallyEnded = 0,
-- PrgItem (ID, DefID, StudentID, StartDate, CreatedDate, CreatedBy, SchoolID, GradeLevelID, InvolvementID, StartStatusID, PlannedEndDate, IsEnded, LastModifiedDate, LastModifiedByID, Revision, IsApprovalPending)
	ItemDefID = 'FE2248C1-8BD6-4010-B02F-79C9F830E5AC',
	SchoolID = sch.SchoolID,
	GradeLevelID = gr.GradeLevelID,
	StartStatusID = '63E39991-4C5A-48A4-B1B4-93062EA02B89', ---------------------------------------------------------------------------------- eligible.  this may be wrong
	IsEnded = 0,
	Revision = 1, 
-- PrgVersion (ID, ItemID, DateCreated, DateFinalized, IsApprovalPending, CreatedByID)  -- all of these fields already available inthe view
-- PrgItemForm (ID, ItemID, CreatedDate, CreatedBy, AssociationTypeID)
	AssociationTypeID = 'DE0AFD97-84C8-488E-94DC-E17CAAA62082',
-- FormInstance (ID, TemplateID) --- already available
	TemplateID = '09A8246E-D110-40B7-AF04-7B09F724799B', ----------------------------------------------------------------------------------------- may need to export this form template from an instance that has it in order to import it on the target instance
-- FormInstanceInterval (ID, InstanceID, IntervalID)
	IntervalID = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D', ------------------ this is the real IntervalID.   the FormInstanceInterval.ID is also called IntervalID in the FormInputValue table !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- PrgSection (ID, DefID, ItemID, FormInstanceID, OnLatestVersion)
	SectionDefID = '4BC1459E-3B35-4D6D-A8B2-1A639E897A40',
	OnLatestVersion = 1
from x_LEGACY504.Student504Dates x
join dbo.Student s on x.StudentNumber = s.Number
left join dbo.PrgInvolvement inv on s.ID = inv.StudentID and inv.ProgramID = 'A1F33015-4D93-4768-B273-EA0CA77274BE' -- select * from Program
left join dbo.PrgItem item on s.ID = item.StudentID and item.DefID = 'FE2248C1-8BD6-4010-B02F-79C9F830E5AC' -- select * from PrgItemDef where ID = 'FE2248C1-8BD6-4010-B02F-79C9F830E5AC' -- Converted 504 Placeholder
left join dbo.PrgVersion ver on item.ID = ver.ItemID -- check the latest version
left join dbo.PrgItemForm itf on item.ID = itf.ItemID  -- select * from PrgItemForm
left join dbo.FormInstance fi on itf.ID = fi.ID -- and fi.TemplateID = '09A8246E-D110-40B7-AF04-7B09F724799Bf'-- converted 504 only.  what if the other 504 plan exists for this student?
left join dbo.FormInstanceInterval fii on fi.ID = fii.InstanceID -- select * from FormInstanceInterval -- ID, InstanceID, IntervalID (always the same)
left join dbo.PrgSection sec on fi.ID = sec.FormInstanceID -- select top 1 * from PrgSection 
left join dbo.StudentSchoolHistory sch on s.ID = sch.StudentID and sch.EndDate is null ---------------------------------------- risky?
left join dbo.StudentGradeLevelHistory gr on s.ID = gr.StudentID and gr.EndDate is null ---------------------------------------- risky?
left join x_LEGACY504.MAP_504data m on s.ID = m.StudentID 
where sch.SchoolID is not null
go


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
join dbo.FormTemplateLayout l on x.TemplateID = l.TemplateId and l.Id = '3D907906-D5E9-444E-86D2-0801271599EB' -- and x.StudentID = '2402D32B-03C7-4D10-B2E0-15788BD715E5' --- this particular view assumes one section in the layout
--join dbo.FormTemplateControl c on l.ControlId = c.Id
join dbo.FormTemplateInputItem ii on l.ControlId = ii.InputAreaId 
left join x_LEGACY504.Student504Dates pstart on x.StudentNumber = pstart.ID and ii.Id = '2F086A80-58EB-4488-824F-126691F15F37' -- startdate
left join x_LEGACY504.Student504Dates pend on x.StudentNumber = pend.ID and ii.Id = '6B346762-B709-4187-B787-C1D3A0BEAB98' -- enddate
left join x_LEGACY504.MAP_504data_Dates m on x.InstanceIntervalDestID = m.IntervalID and ii.ID = InputFieldID
go


-- =======================================================================================================================================================================================
-- =======================================================================================================================================================================================


begin tran
insert x_LEGACY504.MAP_504data 
select 
	StudentNumber,
	StudentID,
	InvolvementDestID = isnull(InvolvementDestID, newid()),
	ItemDestID = isnull(ItemDestID, newid()),
	VersionDestID = isnull(VersionDestID, newid()),
	FormInstanceDestID = isnull(FormInstanceDestID, newid()),
	InstanceIntervalDestID = isnull(InstanceIntervalDestID, newid()),
	SectionDestID = isnull(SectionDestID, newid())
from x_LEGACY504.Transform_504Data
where InvolvementDestID is null

insert PrgInvolvement (ID, StudentID, ProgramID, VariantID, StartDate, IsManuallyEnded)
select x.InvolvementDestID, x.StudentID, x.ProgramID, x.VariantID, x.StartDate, x.IsManuallyEnded from x_LEGACY504.Transform_504Data x 
left join PrgInvolvement y on x.InvolvementDestID = y.ID where y.ID is null

insert PrgItem (ID, DefID, StudentID, StartDate, CreatedDate, CreatedBy, SchoolID, GradeLevelID, InvolvementID, StartStatusID, PlannedEndDate, IsEnded, LastModifiedDate, LastModifiedByID, Revision, IsApprovalPending,OID)
select x.ItemDestID, x.ItemDefID, x.StudentID, x.StartDate, x.TodayDate, x.AdminID, x.SchoolID, x.GradeLevelID, x.InvolvementDestID, x.StartStatusID, x.EndDate, x.IsEnded, x.TodayDate, x.AdminID, x.Revision, x.IsApprovalPending,x.OID from x_LEGACY504.Transform_504Data x
left join PrgItem y on x.ItemDestID = y.ID where y.ID is null

-- new
insert PrgIep
select x.ItemDestID, 0 from  x_LEGACY504.Transform_504Data x
left join Prgiep y on x.ItemDestID = y.ID where y.ID is null

insert PrgVersion (ID, ItemID, DateCreated, DateFinalized, IsApprovalPending, CreatedByID)
select x.VersionDestID, x.ItemDestID, x.TodayDate, x.TodayDate, x.IsApprovalPending, x.AdminID from x_LEGACY504.Transform_504Data x
left join PrgVersion y on x.VersionDestID = y.id where y.ID is null

insert FormInstance (ID, TemplateID)
select x.FormInstanceDestID, x.TemplateID from x_LEGACY504.Transform_504Data x
left join FormInstance y on x.FormInstanceDestID = y.Id where y.id is null

insert PrgItemForm (ID, ItemID, CreatedDate, CreatedBy, AssociationTypeID)
select x.FormInstanceDestID, x.ItemDestID, x.TodayDate, x.AdminID, x.AssociationTypeID from x_LEGACY504.Transform_504Data x
left join PrgItemForm y on x.FormInstanceDestID = y.ID where y.ID is null

insert  FormInstanceInterval (ID, InstanceID, IntervalID)
select x.InstanceIntervalDestID, x.FormInstanceDestID, x.IntervalID from x_LEGACY504.Transform_504Data x -- InterrvalID is correct.  InstanceIntervalDestID will be IntervalID in FormInputValue !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
left join FormInstanceInterval y on x.InstanceIntervalDestID = y.Id where y.id is null

-- view assumes there is only one section associated with this item
insert PrgSection (ID, DefID, ItemID, FormInstanceID, OnLatestVersion)
select x.SectionDestID, x.SectionDefID, x.ItemDestID, x.FormInstanceDestID, x.OnLatestVersion from x_LEGACY504.Transform_504Data x
left join PrgSection y on x.SectionDestID = y.ID where y.id is null


insert x_LEGACY504.MAP_504data_Dates 
select DestID = newID(), x.IntervalID, x.InputFieldID 
from x_LEGACY504.Transform_504dates x 
left join x_LEGACY504.MAP_504data_Dates t on x.IntervalID = t.IntervalID and x.InputFieldID = t.InputFieldID
where t.IntervalID is null

------------------- now for the date values in the formlets
insert FormInputValue 
select x.DestID, x.IntervalID, x.InputFieldID, x.Sequence
from x_LEGACY504.Transform_504dates x 
left join dbo.FormInputValue  t on x.IntervalID = t.IntervalID and x.InputFieldID = t.InputFieldID
where t.IntervalID is null

insert FormInputDateValue 
select x.DestID, x.Section504DateValue
from x_LEGACY504.Transform_504dates x
left join dbo.FormInputDateValue d on x.DestID = d.ID
where d.ID is null


-- rollback 

commit

go

exec dbo.PrgInvolvement_RecalculateStatuses NULL


--exec x_DATATEAM.FindGuid 'A72EE1D4-0E9F-463D-B38C-0B43DD3ED464'
--exec x_DATATEAM.FindGuid 'DE13DA21-5058-4AF9-9EFD-8813200F2A2A'

--select * from dbo.FormInstanceInterval where Id = 'DE13DA21-5058-4AF9-9EFD-8813200F2A2A'


--select IntervalId, count(*) tot
--from FormInputValue
--group by IntervalId
--having count(*) > 1
--order by tot desc


--exec x_DATATEAM.FindGuid 'D46A03F1-0561-41F1-BE84-591A20731428'
--select * from dbo.FormInstanceInterval where Id = 'D46A03F1-0561-41F1-BE84-591A20731428' -- this has an intervalid, and the ID of this table is used as the InstanceInterval in the FormInputValue table
--select * from dbo.FormInputValue where IntervalId = 'D46A03F1-0561-41F1-BE84-591A20731428'



--exec x_DATATEAM.FindGuid '206EB866-2D29-4C7A-B7C2-2DBF81231066'

--select * from dbo.FormInstanceInterval where Id = '206EB866-2D29-4C7A-B7C2-2DBF81231066' 
--select * from dbo.FormInputValue where IntervalId = '206EB866-2D29-4C7A-B7C2-2DBF81231066' -- FormInstanceInterval.ID.     intervalID means different things in different contexts?   


--exec x_DATATEAM.FindGuid 'FBE8314C-E0A0-4C5A-9361-7201081BD47D'

--select * from dbo.FormInterval where Id = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D'
--select * from dbo.FormInstanceInterval where IntervalId = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D' 
--select * from dbo.FormTemplateFormInterval where IntervalId = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D'





--select * from FormTemplateLayout where TemplateID = '09A8246E-D110-40B7-AF04-7B09F724799B'
--select * from FormTemplateControl where ID = 'FC26C667-6DA1-4835-8B89-8E04E229F7F7' 

--exec x_DATATEAM.FindGuid 'FC26C667-6DA1-4835-8B89-8E04E229F7F7'

--select * from dbo.FormTemplateLayout where ControlId = 'FC26C667-6DA1-4835-8B89-8E04E229F7F7'
--select * from dbo.FormTemplateControl where Id = 'FC26C667-6DA1-4835-8B89-8E04E229F7F7'
--select * from dbo.FormTemplateControlProperty where ControlId = 'FC26C667-6DA1-4835-8B89-8E04E229F7F7'
--select * from dbo.FormTemplateInputItem where InputAreaId = 'FC26C667-6DA1-4835-8B89-8E04E229F7F7' --------------------





--select * from FormInputValue where IntervalId = '47331DDA-7FA0-4BCA-B8A5-4905852050E5'



--select * from x_LEGACY504.Student504Dates

-- Attempted to initialize PrgIep 46f337ed-6bf6-452b-bdbd-0ba2ad4d5109*A5990B5E-AFAD-4EF0-9CCA-DC3685296870, however it didn't initialize. This may be because it has been deleted. 



--Msg 547, Level 16, State 0, Line 2
--The INSERT statement conflicted with the FOREIGN KEY constraint "FK_PrgItemForm_FormInstance". The conflict occurred in database "Enrich_DC3_FL_Polk", table "dbo.FormInstance", column 'Id'.
--The statement has been terminated.






-- select * from PrgStatus where ID = '63E39991-4C5A-48A4-B1B4-93062EA02B89' -- questionable



























