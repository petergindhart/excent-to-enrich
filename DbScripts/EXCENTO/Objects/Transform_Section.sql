IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_Section]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_Section]
GO

CREATE VIEW EXCENTO.Transform_Section
AS
	SELECT
		DefID = d.ID,
		ItemID = i.DestID,
		VersionID = i.VersionDestID,
		DestID = s.ID
	FROM
		EXCENTO.Transform_Iep i CROSS JOIN
		PrgSectionDef d LEFT JOIN
		PrgSection s ON 
			s.VersionID = i.VersionDestID AND
			s.DefID = d.ID
	WHERE
		d.ID IN 
			(
			'C26636EE-5939-45C7-A43A-D1D18049B9BD', --IEP Demographics
			'E34A618E-DC70-465D-84FE-3663D524B0F7', --IEP LRE
			'0666ECBD-47D9-4536-B8A5-AA8E83C2BA2C', --IEP Dates
			'2DFA76AD-9139-4129-A1B2-EB19E0190B5A' -- IEP Present Levels
			/*
			-- SUPPORTED SECTION DEFINITION OPTIONS --
			select '''' + CAST(d.ID as varchar(36)) + ''', --' + t.Name
			from
				PrgSectionType t join
				PrgSectionDef d on
					d.TypeID = t.ID and
					d.ItemDefID = '251DA756-A67A-453C-A676-3B88C1B9340C' -- IEP
			*/
			)
GO


	
