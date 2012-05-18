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
			'B18E5739-9242-498E-84A0-4FA79AC0627B', --IEP Present Levels
			'4F6B787A-A490-4769-8D09-D30A0573D116', --IEP Assessments
			'62BD2FF9-FC42-4295-8C7C-23ADB9417841', --IEP Accomodations
			'189AD8F1-47CF-4CA1-9823-6844276C6841', --IEP Special Factors
			'EEC339BC-F160-4D6C-B684-5E53386DE983', --IEP Services
			'32B89B05-C90E-4F62-A171-E5B282981948', --IEP Goals
			'8E378CDD-D392-4952-A98F-F210346F657E' --IEP ESY
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