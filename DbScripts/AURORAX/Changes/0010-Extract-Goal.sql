IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[Goal_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[Goal_LOCAL]  
GO  
  
IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[Goal]'))  
DROP VIEW [AURORAX].[Goal]  
GO  
  
CREATE TABLE [AURORAX].[Goal_LOCAL](  
GoalRefID		  varchar(150), 
IepRefID		  varchar(150), 
Sequence		  varchar(2), 
GoalAreaCode		  varchar(150), 
PostSchoolAreaCode		  varchar(150), 
IsEsy		  varchar(1), 
GoalStatement		  varchar(8000)
)  
GO  
  
  
CREATE VIEW [AURORAX].[Goal]  
AS  
 SELECT * FROM [AURORAX].[Goal_LOCAL]  
GO
--