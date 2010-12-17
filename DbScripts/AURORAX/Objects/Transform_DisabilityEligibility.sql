IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_DisabilityEligibility') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_DisabilityEligibility
GO

CREATE VIEW AURORAX.Transform_DisabilityEligibility
AS
/*
	These records are to be associated with the elig determiniation record

*/
	SELECT 
		iep.IEPPKID,
		DestID = m.DestID, -- elig.ID, 
		InstanceID = sec.ID, 
		DisabilityID = isnull(dis.DestID, '54BF2BB3-05BC-44A6-95F5-1B2F7E4EBC72'), -- "cheating" where no matching disab
		Sequence = sd.DisabilitySequence, 
		IsEligibileID = cast(NULL as uniqueidentifier), -- get it and hardcode
		FormInstanceID = cast(NULL as uniqueidentifier)
-- select *
	FROM
		AURORAX.Transform_IEP iep JOIN
		PrgSection sec ON 
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A' JOIN
		AURORAX.StudentDisability sd on iep.IEPPKID = sd.IEPPKID JOIN 
		AURORAX.MAP_IepDisabilityID dis on sd.DisabilityCode = dis.DisabilityCode LEFT JOIN
		AURORAX.MAP_DisabilityEligibilityID m on 
			sd.IEPPKID = m.IEPPKID AND
			sd.DisabilitySequence = m.DisabilitySequence LEFT JOIN -- dis will require left join for cheat to work
		dbo.IepDisabilityEligibility elig on m.DestID = elig.ID
GO

-- select * from AURORAX.Transform_IepDisability 
--
--select * from AURORAX.Transform_IEP
--select * from PrgSection sec where sec.DefID = 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A'
-- select * from dbo.IepDisabilityEligibility 


-- select * from AURORAX.Transform_DisabilityEligibility -- 1582






/*


select 'PrgSection' Tbl, * from PrgSection where ID = 'C7711315-166A-4F7B-8E9C-005923F2D857'
	select 'PrgSectionDef' Tbl, * from PrgSectionDef where ID = 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A'
	select 'PrgVersion' Tbl, * from PrgVersion where ID = '8E0826CD-2627-4342-B7B2-D1CCD16455F2'
select 'PrgItem' Tbl, * from PrgItem where ID = 'E73A3034-0BD3-4C44-848D-D53A9BA4AFA8'
	select 'PrgItemDef' Tbl, * from PrgItemDef where ID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
	select 'PrgItemType' Tbl, * from PrgItemType where ID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870'


*/

--USE [Enrich_Sandbox2_CO]
--GO
--ALTER TABLE [dbo].[IepDisabilityEligibility]  WITH CHECK 
--	ADD  CONSTRAINT [FK_IepDisabilityEligibility#IsEligible#] FOREIGN KEY([IsEligibileID])
--	REFERENCES [dbo].[EnumValue] ([ID])
--
--select * from EnumValue 
--
--select * from EnumType where type like '%dis%'
--
--
--select * from EnumValue where Type = '668AF94A-A2D8-426C-A5D2-30E222E0BE0A'
--



