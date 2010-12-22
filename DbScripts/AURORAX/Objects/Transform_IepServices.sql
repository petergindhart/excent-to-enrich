IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_IepServices]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_IepServices]
GO

CREATE VIEW [AURORAX].[Transform_IepServices]
AS
	SELECT 
		IEP.SASID,
		DestID = sec.ID,
		DeliveryStatement = cast(NULL as text)
	FROM
		AURORAX.Transform_Iep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F' LEFT JOIN --IEP Services
		dbo.IepServices iv on iv.ID = sec.ID 
GO
