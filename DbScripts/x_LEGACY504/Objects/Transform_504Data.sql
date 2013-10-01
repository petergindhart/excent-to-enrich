

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
	ProgramID = 'CCE3AC71-DF9D-47F6-97BD-217CCA054FFB', -- programid -- select * from Program
	VariantID = '6EFE9798-08F6-4121-8999-18A208C438E2', -- variantid
	IsManuallyEnded = 0,
-- PrgItem (ID, DefID, StudentID, StartDate, CreatedDate, CreatedBy, SchoolID, GradeLevelID, InvolvementID, StartStatusID, PlannedEndDate, IsEnded, LastModifiedDate, LastModifiedByID, Revision, IsApprovalPending)
	ItemDefID = '7EF6FD12-F800-489D-A5FC-44A13802FE02',
	SchoolID = sch.SchoolID,
	GradeLevelID = gr.GradeLevelID,
	StartStatusID = 'ECBEBB56-6EF6-4D1C-9366-0107A3AF1A2C', ---------------------------------------------------------------------------------- eligible.  this may be wrong
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
	SectionDefID = '43DEA8E1-1334-44C5-9C52-061BA3ACF3A3',
	OnLatestVersion = 1,
	s.OID
from x_LEGACY504.Student504Dates x
join dbo.Student s on RIGHT(x.StudentNumber,9) = s.Number
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
