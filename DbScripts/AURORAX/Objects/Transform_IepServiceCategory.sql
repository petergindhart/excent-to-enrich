/*

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_IepServiceCategory]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_IepServiceCategory]  
--GO  
  
CREATE VIEW [AURORAX].[Transform_IepServiceCategory]  
AS
	SELECT
		l.SubType,
		DestID = ISNULL(m.DestID, NEWID()),
		Name = ISNULL(s.Name, l.SubType),
		Sequence = ISNULL(s.Sequence, 99)
	FROM
		(
		SELECT SubType
		FROM AURORAX.Lookups
		WHERE Type = 'Service'
		GROUP BY SubType
		) l LEFT JOIN
		AURORAX.MAP_IepServiceCategoryID m ON l.SubType = m.SubType LEFT JOIN
		dbo.IepServiceCategory s on m.DestID = s.ID	
--GO
--
*/
