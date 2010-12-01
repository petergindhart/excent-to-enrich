IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Section]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Section]
GO

CREATE VIEW AURORAX.Transform_Section
AS
	SELECT
		DefID = d.ID,
		ItemID = i.DestID,
		VersionID = i.VersionDestID,
		DestID = s.ID,
	   FormInstanceID = fi.ID
	FROM
		AURORAX.Transform_Iep i CROSS JOIN
		PrgSectionDef d LEFT JOIN
		PrgSection s ON 
			s.VersionID = i.VersionDestID AND
			s.DefID = d.ID LEFT JOIN
	 FormInstance fi ON 
		  s.FormInstanceID = fi.ID -- is it necessary to join to PrgItemForm ?
	WHERE
		d.ID IN 
			(
			'0108601F-4978-450A-AA26-7324B7A685CC', --IEP Dates
			'1A58E911-5016-471F-BBA5-04FB374D6145' --IEP Demographics
			/*
			-- SUPPORTED SECTION DEFINITION OPTIONS --
				select '''' + CAST(d.ID as varchar(36)) + ''', --' + t.Name
				from
					 PrgSectionType t join
					 PrgSectionDef d on
					 d.TypeID = t.ID and
					 d.ItemDefID = '128417C8-782E-4E91-84BE-C0621442F29E' -- IEP - Direct Placement
			*/
			)
GO
