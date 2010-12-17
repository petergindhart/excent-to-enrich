-- If and when a specific disabilities file is imported from APS, we will use this file for the LOCAL table definition.
-- Until then, the disability information is in the IEP_Data.csv file

create view AURORAX.StudentDisability
as
select IEPPKID, SASID, right('0'+Disability1, 2) DisabilityCode, 0 DisabilitySequence
from AURORAX.IEP_Data
union
select IEPPKID, SASID, right('0'+Disability2, 2) DisabilityCode, 1 DisabilitySequence
from AURORAX.IEP_Data
where Disability2 is not null
GO


-- #############################################################################
-- Map Table
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_EligibilityActivityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_EligibilityActivityID
GO
CREATE TABLE AURORAX.MAP_EligibilityActivityID
	(
	SASID varchar(20) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON PRIMARY
GO

ALTER TABLE AURORAX.MAP_EligibilityActivityID ADD CONSTRAINT
	PK_MAP_EligibilityActivityID PRIMARY KEY CLUSTERED
	(
	SASID
	) ON PRIMARY
GO


-- #############################################################################
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_DisabilityEligibilityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_DisabilityEligibilityID
GO

CREATE TABLE AURORAX.MAP_DisabilityEligibilityID (
IEPPKID		varchar(20)	not null,
DisabilitySequence	int	not null,
DestID	uniqueidentifier not null
)
GO

ALTER TABLE AURORAX.MAP_DisabilityEligibilityID ADD CONSTRAINT
	PK_MAP_DisabilityEligibilityID PRIMARY KEY CLUSTERED
	(IEPPKID, DisabilitySequence) 
GO

