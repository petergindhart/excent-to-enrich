if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'PrgItem_DeleteObsoleteRecords')
drop proc LEGACYSPED.PrgItem_DeleteObsoleteRecords
go

create proc LEGACYSPED.PrgItem_DeleteObsoleteRecords
as
/*
	Cannot create cascading delete on IepServicePlan, so we will delete downstream data that causes FK violation when deleting.
	Currently only IepServicePlan FK breaks.

	Delete IepServices > Delete IepServicePlan > Delete ServicePlan

*/
set nocount on; -- set nocount off;

delete m from LEGACYSPED.MAP_PrgInvolvementID m left join dbo.PrgInvolvement i on m.DestID = i.ID where i.ID is null ; print 'deleted MAP_PrgInvolvementID: '+convert(varchar(10), @@rowcount)

declare @item table (ItemID uniqueidentifier)
insert @item
select item.ID
from LEGACYSPED.MAP_IEPStudentRefID mi left join
LEGACYSPED.IEP iep on mi.IEPRefID = iep.IEPRefID left join
PrgItem item on mi.DestID = item.ID left join  -- now determine if the Items that are not in the incoming dataset have been touched 
PrgVersion v on item.ID = v.ItemID 
where iep.IEPRefID is null 
	and item.IsEnded = 0
	and item.Revision = 0
	and item.IsApprovalPending = 0 
	and v.IsApprovalPending = 0 -- I don't know how this would be incremented for a converted iep, but...
	and item.ID not in (select i.ID from PrgItem i join PrgSection s on i.ID = s.ItemID join IepServicePlan isp on s.ID = isp.InstanceID join ServiceDeliveryStudent sds on isp.ID = sds.PlanID) 

-- do not touch items associated with ended milestones 
delete d from @item d join PrgSection s on d.ItemID = s.ItemID join PrgMilestone ms on s.ID = ms.EndingSectionID
--FK_IepService#Instance#ServicePlans
-- from Pete
declare @services table (ID uniqueidentifier) 
insert @services 
select isp.ID 
from @item item join PrgSection sec on item.ItemID = sec.ItemID join IepServicePlan isp on sec.ID = isp.InstanceID 
--where isp.ID not in (Select PlanID from ServiceDeliveryStudent where PlanID is not null)

delete v from IepServices v where v.ID in (select distinct s.ID from @services s ) ; print 'deleted IepServices: '+convert(varchar(10), @@rowcount)
delete sds from ServiceDeliveryStudent sds join Serviceplan sp ON sp.ID = sds.PlanID Where Sp.ID in (select ID from @services) ; print 'deleted ServiceDeliveryStudent: '+convert(varchar(10), @@rowcount)
delete IepServicePlan where ID in (select ID from @services) ; print 'deleted IepServicePlan: '+convert(varchar(10), @@rowcount)
delete ServicePlan where ID in (select ID from @services) ; print 'deleted ServicePlan: '+convert(varchar(10), @@rowcount)
-- from Pete
/*
Msg 547, Level 16, State 0, Line 38
The DELETE statement conflicted with the REFERENCE constraint "FK_PrgSection#FormInstance#". The conflict occurred in database "Enrich_DCB8_CO_Douglas", table "dbo.PrgSection", column 'FormInstanceID'.
*/
delete sec from FormInstance ins join PrgSection sec on sec.FormInstanceID =ins.Id join @item i on i.ItemID = sec.ItemID ; print 'deleted PrgSection: '+convert(varchar(10), @@rowcount)
delete ins from FormInstance ins join PrgSection sec on sec.FormInstanceID =ins.Id join @item i on i.ItemID = sec.ItemID ; print 'deleted FormInstance: '+convert(varchar(10), @@rowcount)
delete itemrel from @item d join PrgItem item on d.ItemID = item.ID join PrgItemRel itemrel ON itemrel.ResultingItemID = item.ID  ; print 'deleted PrgItemRel: '+convert(varchar(10), @@rowcount)
delete doc from @item d join PrgDocument doc on d.ItemID = doc.ItemID ; print 'deleted PrgDocument: '+convert(varchar(10), @@rowcount)
delete itform from @item d join PrgItemform itform on d.ItemID = itform.ItemID ; print 'deleted PrgItemform: '+convert(varchar(10), @@rowcount)

delete doc from PrgDocument doc join PrgVersion v on doc.VersionId = v.ID join @item item on v.ItemID = item.ItemID

update PrgSection set FormInstanceID = NULL where FormInstanceID in (select ID from PrgItemForm form join @item item on form.ItemID = item.ItemID) -- update it here and lete the item delete cascade to this record

delete form from PrgItemForm form join @item item on form.ItemID = item.ItemID

delete att from @item d join PrgItem item on d.ItemID = item.ID join PrgVersion ver on item.ID = ver.ItemID join Attachment att on ver.ID = att.VersionID ; print 'deleted Attachment: '+convert(varchar(10), @@rowcount)

delete item from @item d join PrgItem item on d.ItemID = item.ID ; print 'deleted PrgItem: '+convert(varchar(10), @@rowcount)

-- while this could be performed without a table variable, we are using one to simplify the query
declare @inv table (StudentRefID varchar(150), InvolvementID uniqueidentifier, ItemID uniqueidentifier, InvolvementInUse bit)
insert @inv
select minv.StudentRefID, InvolvementID = minv.DestID, ItemID = item.ID,
	InvolvementInUse = cast(isnull((select distinct 1 from PrgItem xi where xi.StudentID = inv.StudentID), 0) as bit)
from LEGACYSPED.MAP_PrgInvolvementID minv join 
PrgInvolvement inv on minv.DestID = inv.ID left join 
PrgItem item on inv.StudentID = item.StudentID and item.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' left join 
LEGACYSPED.Student stu on minv.StudentRefID = stu.StudentRefID 
where stu.StudentRefID is null
order by case when item.ID is null then 0 else 1 end desc, involvementinuse desc

delete i from @inv inv join PrgInvolvement i on inv.InvolvementID = i.ID where inv.InvolvementInUse = 0 ; print 'deleted PrgInvolvement: '+convert(varchar(10), @@rowcount)

-- delete MAP records that don't exist in the target.  clean sweep may delete previous orphans also
delete m from @inv inv join LEGACYSPED.MAP_PrgInvolvementID m on inv.InvolvementID = m.DestID where inv.InvolvementInUse = 0 ; print 'deleted MAP_PrgInvolvementID: '+convert(varchar(10), @@rowcount)
delete m from LEGACYSPED.MAP_PrgSectionID_NonVersioned m left join PrgSection s on m.DestID = s.ID left join PrgItem i on m.ItemID = i.ID where s.ID is null and i.ID is null ; print 'deleted MAP_PrgSectionID_NonVersioned: '+convert(varchar(10), @@rowcount)
delete m from LEGACYSPED.MAP_PrgSectionID m left join PrgSection s on m.DestID = s.ID left join PrgVersion v on m.VersionID = v.ID where s.ID is null and v.ID is null ; print 'deleted MAP_PrgSectionID: '+convert(varchar(10), @@rowcount)
delete m from LEGACYSPED.MAP_PrgVersionID m left join PrgVersion x on m.DestID = x.ID where x.ID is null ; print 'deleted MAP_PrgVersionID: '+convert(varchar(10), @@rowcount)
delete m from LEGACYSPED.MAP_IEPStudentRefID m left join PrgItem x on m.DestID = x.ID where x.ID is null ; print 'deleted MAP_IEPStudentRefID: '+convert(varchar(10), @@rowcount)
delete m from LEGACYSPED.MAP_IepPlacementID m left join IepPlacement x on m.DestID = x.ID where x.ID is null ; print 'deleted MAP_IepPlacementID: '+convert(varchar(10), @@rowcount)
delete m from LEGACYSPED.MAP_IepDisabilityEligibilityID m left join IepDisabilityEligibility x on m.DestID = x.ID where x.ID is null ; print 'deleted MAP_IepDisabilityEligibilityID: '+convert(varchar(10), @@rowcount)
delete m from LEGACYSPED.MAP_ScheduleID m left join Schedule x on m.DestID = x.ID where x.ID is null ; print 'deleted MAP_ScheduleID: '+convert(varchar(10), @@rowcount)
delete m from LEGACYSPED.MAP_ServicePlanID m left join ServicePlan x on m.DestID = x.ID where x.ID is null ; print 'deleted MAP_ServicePlanID: '+convert(varchar(10), @@rowcount)
delete m from LEGACYSPED.MAP_PrgGoalAreaDefID m left join PrgGoalAreaDef x on m.DestID = x.ID where x.ID is null ; print 'deleted MAP_PrgGoalAreaDefID: '+convert(varchar(10), @@rowcount)
delete m from LEGACYSPED.MAP_PrgGoalAreaID m left join PrgGoalArea x on m.DestID = x.ID where x.ID is null ; print 'deleted MAP_PrgGoalAreaID: '+convert(varchar(10), @@rowcount)
delete m from LEGACYSPED.MAP_PrgGoalID m left join PrgGoal x on m.DestID = x.ID where x.ID is null ; print 'deleted MAP_PrgGoalID: '+convert(varchar(10), @@rowcount)
delete m from LEGACYSPED.MAP_PrgGoalObjectiveID m left join PrgGoal x on m.DestID = x.ID where x.ID is null ; print 'deleted MAP_PrgGoalObjectiveID: '+convert(varchar(10), @@rowcount)
delete m from LEGACYSPED.MAP_StudentRefID m left join dbo.Student s on m.DestID = s.ID where s.ID is null ; print 'deleted MAP_StudentRefID: '+convert(varchar(10), @@rowcount)


go


