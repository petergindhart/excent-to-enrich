IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_PrgLocation]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_PrgLocation]  
GO  
  
CREATE VIEW [AURORAX].[Transform_PrgLocation]  
AS  
	SELECT   
		m.DestID,
		Name = k.Label,
		Description = CAST(NULL as VARCHAR(500)),
		MedicaidLocationID = CAST(NULL as uniqueidentifier),
		StateCode = k.Code
	FROM  
		AURORAX.Lookups k LEFT JOIN
		AURORAX.MAP_PrgLocationID m on k.Code = m.Code LEFT JOIN
		dbo.PrgLocation t on m.DestID = t.ID
	WHERE
		k.Type = 'ServLoc'
GO
--