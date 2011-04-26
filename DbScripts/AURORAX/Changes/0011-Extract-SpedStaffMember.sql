IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[SpedStaffMember_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[SpedStaffMember_LOCAL]  
GO  
  
IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[SpedStaffMember]'))  
DROP VIEW [AURORAX].[SpedStaffMember]  
GO  
  
CREATE TABLE [AURORAX].[SpedStaffMember_LOCAL](  
SpedStaffRefID		  varchar(150), 
SpedStaffLocalID		  varchar(20), 
Lastname		  varchar(50), 
Firstname		  varchar(50), 
Email		  varchar(75), 
SISStaffRefID		  varchar(150), 
LDAPUsername		  varchar(200), 
MedicaidCert		  varchar(1), 
CertificationDate		  datetime, 
SSN		  varchar(11)
)  
GO  
  
  
CREATE VIEW [AURORAX].[SpedStaffMember]  
AS  
 SELECT * FROM [AURORAX].[SpedStaffMember_LOCAL]  
GO  
--