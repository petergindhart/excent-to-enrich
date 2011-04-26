--#include Transform_Iep.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_Demographics') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_Demographics
GO

CREATE VIEW AURORAX.Transform_Demographics
AS
	SELECT
		DestID = sec.ID,
		PrimaryLanguageID = cast(NULL as uniqueidentifier),
		PrimaryLanguageHomeID = cast(NULL as uniqueidentifier),
		ServiceDistrictID = '6531EF88-352D-4620-AF5D-CE34C54A9F53',
		ServiceSchoolID = iep.SchoolID,
		HomeDistrictID = '6531EF88-352D-4620-AF5D-CE34C54A9F53',
		HomeSchoolID = iep.SchoolID,
		  InterpreterNeededID = cast(NULL as uniqueidentifier),
		  LimittedEnglishProficiencyID = cast(NULL as uniqueidentifier)
	FROM
		AURORAX.Transform_Iep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = '427AF47C-A2D2-47F0-8057-7040725E3D89' --IEP Demographics
GO
--