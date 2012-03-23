IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.Service_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.Service_LOCAL  
GO  


CREATE TABLE LEGACYSPED.Service_LOCAL(  
ServiceType    varchar(20), 
ServiceRefId    varchar(150), 
IepRefId    varchar(150),
ServiceDefinitionCode    varchar(150),
BeginDate    datetime, 
EndDate    datetime, 
IsRelated    varchar(1), 
IsDirect    varchar(1), 
ExcludesFromGenEd    varchar(1), 
ServiceLocationCode    varchar(150), 
ServiceProviderTitleCode    varchar(150),
Sequence    varchar(2), 
IsESY    varchar(1),
ServiceTime    varchar(4), 
ServiceFrequencyCode    varchar(150),
ServiceProviderSSN    varchar(11), 
StaffEmail varchar(150),
ServiceAreaText    varchar(254)
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.Service'))
DROP VIEW LEGACYSPED.Service  
GO  

CREATE VIEW LEGACYSPED.Service  
AS  
 SELECT * FROM LEGACYSPED.Service_LOCAL  
GO  

