IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepServices') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepServices
GO

CREATE VIEW LEGACYSPED.Transform_IepServices
AS
	SELECT
		IEP.IepRefId,
		m.DestID,
		DeliveryStatement = x.ServiceDeliveryStatement, -- since Transform_IepServices is use in a lot of operations, leave the text field out of the transform for speed
		iep.DoNotTouch
	FROM
		LEGACYSPED.Transform_PrgIep iep JOIN		
		LEGACYSPED.MAP_PrgSectionID m on 
			m.DefID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F' and
			m.VersionID = iep.VersionDestID JOIN
		LEGACYSPED.IEP x on iep.IepRefID = x.IepRefID
GO
--



