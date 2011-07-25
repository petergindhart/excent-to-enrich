IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_IepServices]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_IepServices]
GO

CREATE VIEW [AURORAX].[Transform_IepServices]
AS
	SELECT
		IEP.IepRefId,
		m.DestID,
		DeliveryStatement = x.ServiceDeliveryStatement
	FROM
		AURORAX.Transform_Iep iep JOIN		
		AURORAX.Map_SectionID m on 
			m.DefID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F' and
			m.VersionID = iep.VersionDestID JOIN
		AURORAX.IEP x on iep.IepRefID = x.IepRefID
GO
--