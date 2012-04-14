
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

begin tran 

DELETE LEGACYSPED.MAP_IepRefID
FROM LEGACYSPED.Transform_PrgIep AS s RIGHT OUTER JOIN 
	LEGACYSPED.MAP_IepRefID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

UPDATE STATISTICS LEGACYSPED.MAP_IepRefID

delete msp -- select msp.*
FROM dbo.PrgItem i join 
	dbo.PrgSection s on i.ID = s.ItemID left join 
	dbo.IepServicePlan isp on s.ID = isp.InstanceID left join 
	LEGACYSPED.MAP_ServicePlanID msp on isp.ID = msp.DestID left join
	LEGACYSPED.MAP_IepRefID AS m on i.ID = m.DestID 
WHERE m.DestID IS NULL AND 1=1 AND i.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
and msp.DestID is not null

delete isp -- select isp.*
FROM dbo.PrgItem i join 
	dbo.PrgSection s on i.ID = s.ItemID left join 
	dbo.IepServicePlan isp on s.ID = isp.InstanceID left join 
	LEGACYSPED.MAP_IepRefID AS m on i.ID = m.DestID 
WHERE m.DestID IS NULL AND 1=1 AND i.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
and isp.ID is not null

UPDATE STATISTICS dbo.IepServicePlan

DELETE PrgItem
FROM LEGACYSPED.MAP_IepRefID AS s RIGHT OUTER JOIN 
	PrgItem as d ON s.DestID=d.ID
WHERE s.DestID IS NULL AND 1=1 AND  d.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'

UPDATE STATISTICS dbo.PrgItem

commit tran -- rollback tran
go


