IF not exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYRTI' and o.name = 'MAP_RTIData')
begin
create table x_LEGACYRTI.MAP_RTIData (
StudentNumber	varchar(20)  not null,
StudentID uniqueidentifier not null,
InvolvementDestID	uniqueidentifier not null, 
InvolvementStatusDestID	uniqueidentifier not null, 
ItemDestID	uniqueidentifier not null,
VersionDestID uniqueidentifier not null,
FormInstanceDestID uniqueidentifier not null,
InstanceIntervalDestID uniqueidentifier not null,
Area Varchar(150) not null,
StartDate varchar(10)  not null,
SectionDestID uniqueidentifier not null -- currently there is only one section referencing this itemdef
)

alter table x_LEGACYRTI.MAP_RTIData add constraint PK_MAP_RTIData primary key (StudentID)
end

go
if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYRTI' and o.name = 'Transform_RTIData')
drop view x_LEGACYRTI.Transform_RTIData
go

create view x_LEGACYRTI.Transform_RTIData
as 
select
Distinct 
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
	Area = x.Area,
-- PrgInvolvement (ID, StudentID, ProgramID, VariantID, StartDate, IsManuallyEnded)
	ProgramID = '7DE3B3D7-B60F-48AC-9681-78D46A5E74D4', -- programid -- select * from Program
	VariantID = (select ID from Prgvariant where Programid = '7DE3B3D7-B60F-48AC-9681-78D46A5E74D4' and Name = ISNULL(case x.Area when 'Math' then 'Mathematics' else x.Area end,'Reading')) ,-- '3314601D-9D08-CB4D-9D70-6A157C07C8EF', -- variantid
	IsManuallyEnded = 0,
	--PrgInvolvementStatus
    StatusID = (SELECT ID FROM PrgStatus WHERE ProgramID = '7DE3B3D7-B60F-48AC-9681-78D46A5E74D4' AND Name = ISNULL(x.Status,'Tier 1')),--'53D737C1-CDBF-40D0-9B80-BDBFBE738C9D',
-- PrgItem (ID, DefID, StudentID, StartDate, CreatedDate, CreatedBy, SchoolID, GradeLevelID, InvolvementID, StartStatusID, PlannedEndDate, IsEnded, LastModifiedDate, LastModifiedByID, Revision, IsApprovalPending)
	ItemDefID = 'C9D91356-735B-4659-A445-D53D81A04974',
	SchoolID = sch.SchoolID,
	GradeLevelID = gr.GradeLevelID,
	StartStatusID = '53D737C1-CDBF-40D0-9B80-BDBFBE738C9D', ---------------------------------------------------------------------------------- eligible.  this may be wrong
	IsEnded = 0,
	Revision = 1, 
-- PrgVersion (ID, ItemID, DateCreated, DateFinalized, IsApprovalPending, CreatedByID)  -- all of these fields already available inthe view
-- PrgItemForm (ID, ItemID, CreatedDate, CreatedBy, AssociationTypeID)
	AssociationTypeID = 'DE0AFD97-84C8-488E-94DC-E17CAAA62082',
-- FormInstance (ID, TemplateID) --- already available
	TemplateID = '97788A6F-A165-46FB-B4F7-46F50702C926', ----------------------------------------------------------------------------------------- may need to export this form template from an instance that has it in order to import it on the target instance
-- FormInstanceInterval (ID, InstanceID, IntervalID)
	IntervalID = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D', ------------------ this is the real IntervalID.   the FormInstanceInterval.ID is also called IntervalID in the FormInputValue table !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- PrgSection (ID, DefID, ItemID, FormInstanceID, OnLatestVersion)
	SectionDefID = 'EE8B8EA9-5ECB-4625-8647-FF2AD2C78B98',
	OnLatestVersion = 1,
	s.OID
from x_LEGACYRTI.RTIStudent x
join dbo.Student s on RIGHT(x.StudentLocalID,9) = s.Number --we don't nedd RIGHT() for other districts (Due to Bay's data)
left join dbo.PrgInvolvement inv on s.ID = inv.StudentID and inv.ProgramID = '7DE3B3D7-B60F-48AC-9681-78D46A5E74D4' and inv.Startdate = x.startdate and inv.variantid = (select ID from Prgvariant where Programid = '7DE3B3D7-B60F-48AC-9681-78D46A5E74D4' and Name = ISNULL(case x.Area when 'Math' then 'Mathematics' else x.Area end,'Reading')) -- select * from Program
LEFT join dbo.PrgInvolvementStatus invst on invst.InvolvementID = inv.ID  AND inv.StartDate =invst.StartDate and x.startdate =invst.startdate
left join dbo.PrgItem item on s.ID = item.StudentID and inv.ID = item.InvolvementID and item.DefID = 'C9D91356-735B-4659-A445-D53D81A04974'and item.InvolvementID = inv.ID and x.Startdate= item.startdate -- select * from PrgItemDef where ID = 'FE2248C1-8BD6-4010-B02F-79C9F830E5AC' -- Converted 504 Placeholder
left join dbo.PrgVersion ver on item.ID = ver.ItemID -- check the latest version
left join dbo.PrgItemForm itf on item.ID = itf.ItemID  -- select * from PrgItemForm
left join dbo.FormInstance fi on itf.ID = fi.ID -- and fi.TemplateID = '09A8246E-D110-40B7-AF04-7B09F724799Bf'-- converted 504 only.  what if the other 504 plan exists for this student?
left join dbo.FormInstanceInterval fii on fi.ID = fii.InstanceID -- select * from FormInstanceInterval -- ID, InstanceID, IntervalID (always the same)
left join dbo.PrgSection sec on fi.ID = sec.FormInstanceID -- select top 1 * from PrgSection 
left join dbo.StudentSchoolHistory sch on s.ID = sch.StudentID and sch.EndDate is null ---------------------------------------- risky?
left join dbo.StudentGradeLevelHistory gr on s.ID = gr.StudentID and gr.EndDate is null ---------------------------------------- risky?
left join x_LEGACYRTI.MAP_RTIData m on s.Number = RIGHT(m.StudentNumber,9) and x.startdate= m.startdate and isnull(x.Area,'Reading')  =m.Area  and x.studentlocalid =m.studentnumber
where sch.SchoolID is not null
GO