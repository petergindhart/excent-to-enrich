
begin tran
insert x_LEGACYRTI.Map_RTIData 
select 
	StudentNumber,
	StudentID,
	InvolvementDestID = isnull(InvolvementDestID, newid()),
	InvolvementStatusDestID = isnull(InvolvementStatusDestID, newid()),
	ItemDestID = isnull(ItemDestID, newid()),
	VersionDestID = isnull(VersionDestID, newid()),
	FormInstanceDestID = isnull(FormInstanceDestID, newid()),
	InstanceIntervalDestID = isnull(InstanceIntervalDestID, newid()),
	SectionDestID = isnull(SectionDestID, newid())
from x_LEGACYRTI.Transform_RTIData
where InvolvementDestID is null or ItemDestID is null


insert PrgInvolvement (ID, StudentID, ProgramID, VariantID, StartDate, IsManuallyEnded)
select x.InvolvementDestID, x.StudentID, x.ProgramID, x.VariantID, x.StartDate, x.IsManuallyEnded from x_LEGACYRTI.Transform_RTIData x 
left join PrgInvolvement y on x.InvolvementDestID = y.ID where y.ID is null and x.InvolvementDestID is not null

insert PrgInvolvementStatus (ID,InvolvementID,StatusID,StartDate)
select x.InvolvementStatusDestID,x.InvolvementDestID,x.StatusID,x.StartDate from x_LEGACYRTI.Transform_RTIData x 
left join PrgInvolvementStatus invst on invst.InvolvementID = x.InvolvementDestID 
where invst.InvolvementID is null and x.InvolvementDestID is not null and x.InvolvementStatusDestID is not null

insert PrgItem (ID, DefID, StudentID, StartDate, CreatedDate, CreatedBy, SchoolID, GradeLevelID, InvolvementID, StartStatusID, PlannedEndDate, IsEnded, LastModifiedDate, LastModifiedByID, Revision, IsApprovalPending,OID)
select x.ItemDestID, x.ItemDefID, x.StudentID, x.StartDate, x.TodayDate, x.AdminID, x.SchoolID, x.GradeLevelID, x.InvolvementDestID, x.StartStatusID, x.EndDate, x.IsEnded, x.TodayDate, x.AdminID, x.Revision, x.IsApprovalPending,x.OID from x_LEGACYRTI.Transform_RTIData x
left join PrgItem y on x.ItemDestID = y.ID where y.ID is null and x.InvolvementDestID is not null

-- new
insert PrgIep
select x.ItemDestID, 0 from  x_LEGACYRTI.Transform_RTIData x
left join Prgiep y on x.ItemDestID = y.ID where y.ID is null and x.InvolvementDestID is not null

insert PrgVersion (ID, ItemID, DateCreated, DateFinalized, IsApprovalPending, CreatedByID)
select x.VersionDestID, x.ItemDestID, x.TodayDate, x.TodayDate, x.IsApprovalPending, x.AdminID from x_LEGACYRTI.Transform_RTIData x
left join PrgVersion y on x.VersionDestID = y.id where y.ID is null and x.InvolvementDestID is not null

insert FormInstance (ID, TemplateID)
select x.FormInstanceDestID, x.TemplateID from x_LEGACYRTI.Transform_RTIData x
left join FormInstance y on x.FormInstanceDestID = y.Id where y.id is null and x.InvolvementDestID is not null

insert PrgItemForm (ID, ItemID, CreatedDate, CreatedBy, AssociationTypeID)
select x.FormInstanceDestID, x.ItemDestID, x.TodayDate, x.AdminID, x.AssociationTypeID from x_LEGACYRTI.Transform_RTIData x
left join PrgItemForm y on x.FormInstanceDestID = y.ID where y.ID is null and x.InvolvementDestID is not null

insert  FormInstanceInterval (ID, InstanceID, IntervalID)
select x.InstanceIntervalDestID, x.FormInstanceDestID, x.IntervalID from x_LEGACYRTI.Transform_RTIData x -- InterrvalID is correct.  InstanceIntervalDestID will be IntervalID in FormInputValue !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
left join FormInstanceInterval y on x.InstanceIntervalDestID = y.Id where y.id is null and x.InvolvementDestID is not null

-- view assumes there is only one section associated with this item
insert PrgSection (ID, DefID, ItemID, FormInstanceID, OnLatestVersion)
select x.SectionDestID, x.SectionDefID, x.ItemDestID, x.FormInstanceDestID, x.OnLatestVersion from x_LEGACYRTI.Transform_RTIData x
left join PrgSection y on x.SectionDestID = y.ID where y.id is null and x.InvolvementDestID is not null

-- below are having data related to dates
insert x_LEGACYRTI.Map_RTIData_Dates 
select DestID = newID(), x.IntervalID, x.InputFieldID 
from x_LEGACYRTI.Transform_RTIDates x 
left join x_LEGACYRTI.Map_RTIData_Dates t on x.IntervalID = t.IntervalID and x.InputFieldID = t.InputFieldID
where t.IntervalID is null

------------------- now for the date values in the formlets
insert FormInputValue 
select x.DestID, x.IntervalID, x.InputFieldID, x.Sequence
from x_LEGACYRTI.Transform_RTIDates x 
left join dbo.FormInputValue  t on x.IntervalID = t.IntervalID and x.InputFieldID = t.InputFieldID
where t.IntervalID is null

insert FormInputDateValue 
select x.DestID, x.RTIDateValue
from x_LEGACYRTI.Transform_RTIDates x
left join dbo.FormInputDateValue d on x.DestID = d.ID
where d.ID is null


-- rollback 

commit

go

exec dbo.PrgInvolvement_RecalculateStatuses NULL