IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.Service_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.Service_LOCAL  
GO  


CREATE TABLE LEGACYSPED.Service_LOCAL(  
ServiceType    varchar(20) not null, 
ServiceRefId    varchar(150) not null, 
IepRefId    varchar(150) not null,
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
Alter table LEGACYSPED.Service_LOCAL
add constraint PK_LEGACYSPED_Service_LOCAL_ServiceRefId primary key (ServiceRefId)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.Service'))
DROP VIEW LEGACYSPED.Service  
GO  

CREATE VIEW LEGACYSPED.Service  
AS  
 SELECT * FROM LEGACYSPED.Service_LOCAL  
GO  
