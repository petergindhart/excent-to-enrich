IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[IEP_Data_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[IEP_Data_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[IEP_Data]'))
DROP VIEW [AURORAX].[IEP_Data]
GO

CREATE TABLE [AURORAX].[IEP_Data_LOCAL](
SASID					  	varchar(20),
StudentId				varchar(20),
InitialConsentDate		datetime,
InitialEvalCompleteDate	datetime,
IEPMeetingDate			datetime,
NextAnnualDate			datetime,
NextTriennialDate		datetime,
Disability1				varchar(5),
Disability2				varchar(5),
LRE						varchar(5)
)
GO


CREATE VIEW [AURORAX].[IEP_Data]
AS
	SELECT * FROM [AURORAX].[IEP_Data_LOCAL]
GO