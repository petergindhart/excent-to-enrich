IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Section]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Section]
GO

CREATE VIEW AURORAX.Transform_Section
AS
	SELECT
		DestID = isnull(s.ID, newid()),
		ItemID = i.DestID,
		DefID = d.ID,
		VersionID = i.VersionDestID,
		FormInstanceID = fi.ID
	FROM
		AURORAX.Transform_Iep i CROSS JOIN
		PrgSectionDef d LEFT JOIN -- left join???????
		PrgSection s ON 
			s.VersionID = i.VersionDestID AND
			s.DefID = d.ID LEFT JOIN
		FormInstance fi ON 
			s.FormInstanceID = fi.ID -- is it necessary to join to PrgItemForm ?
	WHERE
		d.ID IN 
			(
				'9AC79680-7989-4CC9-8116-1CCDB1D0AE5F', --IEP Services
				'0CBA436F-8043-4D22-8F3D-289E057F1AAB', --IEP LRE
				'F050EF5E-3ED8-43D5-8FE7-B122502DE86A', --Sped Eligibility Determination
				'EE479921-3ECB-409A-96D7-61C8E7BA0E7B', --IEP Dates
				'427AF47C-A2D2-47F0-8057-7040725E3D89' --IEP Demographics
				/*
				-- SUPPORTED SECTION DEFINITION OPTIONS --
				select '''' + CAST(d.ID as varchar(36)) + ''', --' + t.Name, d.ItemDefID, t.*
				from
				PrgSectionType t join
				PrgSectionDef d on
				d.TypeID = t.ID and
				d.ItemDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' -- IEP - Direct Placement
				order by t.Name

				*/
		)
GO
