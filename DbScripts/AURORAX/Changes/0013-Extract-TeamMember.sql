IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[TeamMember_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[TeamMember_LOCAL]  
GO  
  
IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[TeamMember]'))  
DROP VIEW [AURORAX].[TeamMember]  
GO  
  
CREATE TABLE [AURORAX].[TeamMember_LOCAL](  
  SpedStaffRefId	varchar(150)	not null,
  StudentRefId	varchar(150)	not null,
  CaseManager	varchar(1)	not null
)  
GO  
  
  
CREATE VIEW [AURORAX].[TeamMember]  
AS  
 SELECT * FROM [AURORAX].[TeamMember_LOCAL]  
GO
--