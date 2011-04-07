-- If and when a specific disabilities file is imported from APS, we will use this file for the LOCAL table definition.
-- Until then, the disability information is in the IEP_Data.csv file
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.StudentDisability') AND OBJECTPROPERTY(id, N'IsUserView') = 1)
	DROP VIEW AURORAX.StudentDisability
GO

create view AURORAX.StudentDisability
as
select s.StudentRefId, i.IepRefId, s.Disability1Code DisabilityCode, cast(0 as int) DisabilitySequence
from AURORAX.Student s JOIN
	AURORAX.IEP i on s.StudentRefId = i.StudentRefId
union
select s.StudentRefId, i.IepRefId, s.Disability2Code, cast(1 as int)
from AURORAX.Student s JOIN
	AURORAX.IEP i on s.StudentRefId = i.StudentRefId
where Disability2Code is not null
GO

-- #############################################################################
-- Map Table
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_EligibilityActivityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_EligibilityActivityID
GO
CREATE TABLE AURORAX.MAP_EligibilityActivityID
	(
	StudentRefID varchar(20) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
GO

ALTER TABLE AURORAX.MAP_EligibilityActivityID ADD CONSTRAINT
	PK_MAP_EligibilityActivityID PRIMARY KEY CLUSTERED
	(
	StudentRefID
	)
GO


-- #############################################################################
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_DisabilityEligibilityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_DisabilityEligibilityID
GO

CREATE TABLE AURORAX.MAP_DisabilityEligibilityID (
IepRefID		varchar(150)	not null,
DisabilitySequence	int	not null,
DestID	uniqueidentifier not null
)
GO

ALTER TABLE AURORAX.MAP_DisabilityEligibilityID ADD CONSTRAINT
	PK_MAP_DisabilityEligibilityID PRIMARY KEY CLUSTERED
	(IepRefID, DisabilitySequence)
GO
--