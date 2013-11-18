IF not exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYESOL' and o.name = 'Map_ESOLData')
begin
create table x_LEGACYESOL.Map_ESOLData (
StudentNumber	varchar(20)  not null,
StudentID uniqueidentifier not null,
InvolvementDestID	uniqueidentifier not null, 
InvolvementStatusDestID	uniqueidentifier not null, 
ItemDestID	uniqueidentifier not null,
VersionDestID uniqueidentifier not null,
FormInstanceDestID uniqueidentifier not null,
InstanceIntervalDestID uniqueidentifier not null,
SectionDestID uniqueidentifier not null -- currently there is only one section referencing this itemdef
)

alter table x_LEGACYESOL.Map_ESOLData add constraint PK_Transform_Map_ESOLData primary key (StudentID)
end

go

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYESOL' and o.name = 'Transform_ESOLData')
drop view x_LEGACYESOL.Transform_ESOLData
go

create view x_LEGACYESOL.Transform_ESOLData
as 
select 
-- key
	StudentNumber = x.StudentLocalID,
	StudentID = s.ID,
-- map ids
	InvolvementDestID = isnull(m.InvolvementDestID, inv.ID),
	ItemDestID = isnull(m.ItemDestID, item.ID),
	VersionDestID = isnull(m.VersionDestID, ver.ID),
	--ItemFormID = itf.ID, --------------------------------------------------- testing only
	FormInstanceDestID = isnull(m.FormInstanceDestID, fi.ID),
	InstanceIntervalDestID = isnull(m.InstanceIntervalDestID, fii.ID),
	SectionDestID  = isnull(sec.ID, m.SectionDestID),
	InvolvementStatusDestID = isnull(invst.ID,m.InvolvementStatusDestID),
-- Other Common fields
	StartDate = x.StartDate,
	EndDate = x.EndDate,
	TodayDate = getdate(),
	AdminID = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB',
	IsApprovalPending = 0,
-- PrgInvolvement (ID, StudentID, ProgramID, VariantID, StartDate, IsManuallyEnded)
	ProgramID = 'E34B1901-840C-4B74-A69D-C167EB91D2CB', -- programid -- select * from Program
	VariantID = '5BB1E651-6B72-4C7D-8175-1BF70AAB9492', -- variantid
	IsManuallyEnded = 0,
--PrgInvolvementStatus
    StatusID ='CBC1E926-C329-44F9-A817-56B43C86FB08',
-- PrgItem (ID, DefID, StudentID, StartDate, CreatedDate, CreatedBy, SchoolID, GradeLevelID, InvolvementID, StartStatusID, PlannedEndDate, IsEnded, LastModifiedDate, LastModifiedByID, Revision, IsApprovalPending)
	ItemDefID = 'EDB7D5BB-42A8-4473-8E44-1E97E88104A8',
	SchoolID = sch.SchoolID,
	GradeLevelID = gr.GradeLevelID,
	StartStatusID = 'CBC1E926-C329-44F9-A817-56B43C86FB08', ---------------------------------------------------------------------------------- eligible.  this may be wrong
	IsEnded = 0,
	Revision = 1, 
-- PrgVersion (ID, ItemID, DateCreated, DateFinalized, IsApprovalPending, CreatedByID)  -- all of these fields already available inthe view
-- PrgItemForm (ID, ItemID, CreatedDate, CreatedBy, AssociationTypeID)
	AssociationTypeID = 'DE0AFD97-84C8-488E-94DC-E17CAAA62082',
-- FormInstance (ID, TemplateID) --- already available
	TemplateID = '6DC92D5A-6196-496E-87B3-93BD5E3290AB', ----------------------------------------------------------------------------------------- may need to export this form template from an instance that has it in order to import it on the target instance
-- FormInstanceInterval (ID, InstanceID, IntervalID)
	IntervalID = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D', ------------------ this is the real IntervalID.   the FormInstanceInterval.ID is also called IntervalID in the FormInputValue table !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- PrgSection (ID, DefID, ItemID, FormInstanceID, OnLatestVersion)
	SectionDefID = 'ECF315D8-A502-4276-8755-9B556FF64F58',
	OnLatestVersion = 1,
	s.OID	
from x_LEGACYESOL.ESOLStudent x
join dbo.Student s on RIGHT(x.StudentLocalID,9) = s.Number --we don't nedd RIGHT() for other districts (Due to Bay's data)
left join dbo.PrgInvolvement inv on s.ID = inv.StudentID and inv.ProgramID = 'E34B1901-840C-4B74-A69D-C167EB91D2CB' -- select * from Program
LEFT join dbo.PrgInvolvementStatus invst on invst.InvolvementID = inv.ID AND inv.StartDate =invst.StartDate
left join dbo.PrgItem item on s.ID = item.StudentID and item.DefID = 'EDB7D5BB-42A8-4473-8E44-1E97E88104A8' -- select * from PrgItemDef where ID = 'FE2248C1-8BD6-4010-B02F-79C9F830E5AC' -- Converted 504 Placeholder
left join dbo.PrgVersion ver on item.ID = ver.ItemID -- check the latest version
left join dbo.PrgItemForm itf on item.ID = itf.ItemID  -- select * from PrgItemForm
left join dbo.FormInstance fi on itf.ID = fi.ID -- and fi.TemplateID = '09A8246E-D110-40B7-AF04-7B09F724799Bf'-- converted 504 only.  what if the other 504 plan exists for this student?
left join dbo.FormInstanceInterval fii on fi.ID = fii.InstanceID -- select * from FormInstanceInterval -- ID, InstanceID, IntervalID (always the same)
left join dbo.PrgSection sec on fi.ID = sec.FormInstanceID -- select top 1 * from PrgSection 
left join dbo.StudentSchoolHistory sch on s.ID = sch.StudentID and sch.EndDate is null ---------------------------------------- risky?
left join dbo.StudentGradeLevelHistory gr on s.ID = gr.StudentID and gr.EndDate is null ---------------------------------------- risky?
left join x_LEGACYESOL.Map_ESOLData m on s.Number = RIGHT(m.StudentNumber,9)
where sch.SchoolID is not null
go
