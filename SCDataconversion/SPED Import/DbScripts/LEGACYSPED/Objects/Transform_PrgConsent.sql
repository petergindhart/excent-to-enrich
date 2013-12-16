IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgConsent') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgConsent
GO

CREATE VIEW LEGACYSPED.Transform_PrgConsent
AS
	SELECT
		DestID = m.DestID,
		ConsentGrantedID = CASE WHEN iep.ConsentForServicesDate IS NOT NULL THEN CAST('B76DDCD6-B261-4D46-A98E-857B0A814A0C' AS uniqueidentifier) ELSE NULL END,
		ConsentDate = 
			case m.DefID 
				when 'D83A4710-A69F-4310-91F8-CB5BFFB1FE4C' then CAST(isnull(iep.ConsentForServicesDate, iep.StartDate) as DATETIME) -- sped consent services
				when (select SectionDefID from LEGACYSPED.ImportPrgSections where SectionDefName = 'Sped Consent Evaluation') then cast(iep.ConsentForEvaluationDate as datetime) -- consent for evaluation 
			end, 
		iep.DoNotTouch
	FROM
		LEGACYSPED.Transform_PrgIep iep JOIN
		LEGACYSPED.MAP_PrgSectionID_NonVersioned m on 
			m.DefID in (
				--'D83A4710-A69F-4310-91F8-CB5BFFB1FE4C', --Sped Consent Services
				--'47958E63-10C4-4124-A5BA-8C1077FB2D40' --Sped Consent Evaluation (I have requested VC3 to add this SectionDef to all instance of Enrich in every state with this ID).  gg  20130122
				select SectionDefID from LEGACYSPED.ImportPrgSections where SectionDefName like '%Consent%'
				) and
			m.ItemID = iep.DestID
GO
--
