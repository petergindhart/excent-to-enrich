--#include Transform_IepService.sql
IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepService_Snapshot') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

create table LEGACYSPED.Transform_IepService_Snapshot (
ServiceRefId	varchar(150) NOT NULL,
IepRefId	varchar(150),
DestID	uniqueidentifier,
DefId	uniqueidentifier,
InstanceID	uniqueidentifier NOT NULL,
StudentID	uniqueidentifier,
StartDate	datetime,
EndDate	datetime,
Amount	int NOT NULL,
FrequencyId	uniqueidentifier,
UnitID	varchar(36) NOT NULL,
ProviderTitleID	uniqueidentifier,
Sequence	int,
ServiceTypeID	varchar(36) NOT NULL,
CategoryCode	varchar(20) NOT NULL,
CategoryID	uniqueidentifier,
DirectID	varchar(36) NOT NULL,
ExcludesID	varchar(36) NOT NULL,
EsyID	varchar(36) NOT NULL,
DeliveryStatement	varchar(254),
UseAmountRange	bit
)

END

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepServicePlan_ss'))
DROP VIEW LEGACYSPED.Transform_IepServicePlan_ss
GO

create view LEGACYSPED.Transform_IepServicePlan_ss
as
select s.ServiceRefId, s.IepRefId, m.DestID, s.DefId, s.InstanceID, s.StudentID, s.StartDate, s.EndDate, s.Amount, s.FrequencyId, s.UnitID, s.ProviderTitleID, s.Sequence, s.ServiceTypeID, s.CategoryCode, s.CategoryID, s.DirectID, s.ExcludesID, s.EsyID, s.DeliveryStatement, s.UseAmountRange
from LEGACYSPED.Transform_IepService_Snapshot s left join 
LEGACYSPED.MAP_ServicePlanID m on s.ServiceRefId = m.ServiceRefID
go
