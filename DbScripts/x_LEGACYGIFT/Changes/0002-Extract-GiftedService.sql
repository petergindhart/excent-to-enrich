
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.GiftedService_Local') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.GiftedService_Local
GO


CREATE TABLE x_LEGACYGIFT.GiftedService_Local(
ServiceType    varchar(20) not null, 
ServiceRefId    varchar(150) not null, 
EpRefId    varchar(150) not null,
ServiceDefinitionCode    varchar(150) null,
BeginDate    datetime not null, 
EndDate    datetime null, 
IsRelated    varchar(1) not null, 
IsDirect    varchar(1) not null, 
ExcludesFromGenEd    varchar(1) not null, 
ServiceLocationCode    varchar(150) not null, 
ServiceProviderTitleCode    varchar(150) not null,
Sequence    int null, 
IsESY    varchar(1) null,
ServiceTime    int not null, 
ServiceFrequencyCode    varchar(150) not null,
ServiceProviderSSN    varchar(11) null, 
StaffEmail varchar(150) null,
ServiceAreaText    varchar(254) null
)
GO

alter table x_LEGACYGIFT.GiftedService_Local 
add constraint PK_x_LEGACYGIFT_GiftedService_Local_ServiceRefId primary key (ServiceRefId)
Go

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.GiftedService'))
DROP VIEW x_LEGACYGIFT.GiftedService
GO  

CREATE VIEW x_LEGACYGIFT.GiftedService
AS
 SELECT * FROM x_LEGACYGIFT.GiftedService_Local
GO
--