IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_IepPostSchoolAreaDefID') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_IepPostSchoolAreaDefID
GO

CREATE VIEW AURORAX.Transform_IepPostSchoolAreaDefID
AS
/*
This transform assumes that unrelated codes and related descriptions exist in both the 
Clarity databbase and the Enrich CO-template database, but that the descriptions do not 
match word-for-word.

These codes will exist in 2 places:  The imported Clarity data and in the MAP table, the 
latter being inserted in the same query that creates the map table.  Thus, the mapping is 
done visually, and the GUIDs come from the CO-Template data.

*/
	SELECT
		c.PostSchoolAreaCode,
		m.DestID,
		Sequence = (
		 SELECT count(*)
		 FROM AURORAX.PostSchoolAreaCode
		 WHERE isnull(Sequence, PostSchoolAreaCode) < isnull(c.Sequence, c.PostSchoolAreaCode)
		),
		Name = convert(varchar(100), c.PostSchoolAreaDescription), 
		ga.Code 
	FROM
		AURORAX.PostSchoolAreaCode c LEFT JOIN
		AURORAX.MAP_IepPostSchoolAreaDefID m on c.PostSchoolAreaCode = m.PostSchoolAreaCode LEFT JOIN
		dbo.IepPostSchoolAreaDef ga on m.DestID = ga.ID
GO
-- select * from dbo.IepPostSchoolAreaDef
-- select * from AURORAX.Transform_IepPostSchoolAreaDefID
