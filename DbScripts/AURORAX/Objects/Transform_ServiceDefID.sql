IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_ServiceDefID') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_ServiceDefID
GO

CREATE VIEW AURORAX.Transform_ServiceDefID 
AS
SELECT 
	t.DestID, 
	Name = t.Name, 
	Description = cast(NULL as varchar(max)),
	DefaultProviderTitle = cast(NULL as varchar(100))
FROM (
	SELECT m.DestID,
		Name = c.ServiceDefinitionDescription
	FROM
		AURORAX.ServiceDefinitionCode c JOIN
		AURORAX.MAP_ServiceDefID m on c.ServiceDefinitionCode = m.ServiceDefinitionCode LEFT JOIN
		IepServiceDef sd on m.DestID = sd.ID
	) t
UNION ALL
SELECT
	DestID = cast('1CF4FFF7-D17D-4B76-BAE4-9CD0183DD008' as uniqueidentifier), 
	Name = CONVERT(VARCHAR(100), 'Unknown'), 
	Description = cast(NULL as varchar(max)),
	DefaultProviderTitle = cast(NULL as varchar(100))
GO
