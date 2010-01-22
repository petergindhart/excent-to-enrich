--#include Transform_Iep.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_Demographics]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_Demographics]
GO

CREATE VIEW EXCENTO.Transform_Demographics
AS
	SELECT
		DestID = sec.ID,
		PrimaryLanguageID = lang.ID,
		PrimaryLanguageHomeID = langH.ID,
		ServiceDistrictID = distS.ID,
		ServiceSchoolID = schS.ID,
		HomeDistrictID = distH.ID,
		HomeSchoolID = schH.ID
	FROM
		EXCENTO.Transform_Iep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = 'C26636EE-5939-45C7-A43A-D1D18049B9BD' --IEP Demographics
		LEFT JOIN 
		IepLanguage lang ON lang.Name = 'Should Never Be True' LEFT JOIN
		IepLanguage langH ON langH.Name = 'Should Never Be True' LEFT JOIN
		IepDistrict distS ON distS.Name = 'Should Never Be True' LEFT JOIN
		IepDistrict schS ON schS.Name = 'Should Never Be True' LEFT JOIN
		IepDistrict distH ON distH.Name = 'Should Never Be True' LEFT JOIN
		IepDistrict schH ON schH.Name = 'Should Never Be True'
GO

