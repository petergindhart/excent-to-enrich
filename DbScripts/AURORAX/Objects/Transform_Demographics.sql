--#include Transform_Iep.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_Demographics') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_Demographics
GO

CREATE VIEW AURORAX.Transform_Demographics
AS
	SELECT
		DestID = m.DestID,
		PrimaryLanguageID = cast(NULL as uniqueidentifier),
		PrimaryLanguageHomeID = cast(NULL as uniqueidentifier),
		ServiceDistrictID = ds.DestID,
		ServiceSchoolID = ss.DestID,
		HomeDistrictID = dh.DestID,
		HomeSchoolID = sh.DestID,
		InterpreterNeededID = cast(NULL as uniqueidentifier),
		LimittedEnglishProficiencyID = cast(NULL as uniqueidentifier)
	FROM
		AURORAX.Transform_Iep iep LEFT JOIN
		AURORAX.Map_SectionID m on 
			m.DefID = '427AF47C-A2D2-47F0-8057-7040725E3D89' and
			m.VersionID = iep.VersionDestID LEFT JOIN
		AURORAX.Student s on s.StudentRefID = iep.StudentRefID LEFT JOIN
		AURORAX.MAP_OrgUnit ds on s.ServiceDistrictRefID = ds.DistrictRefID LEFT JOIN
		AURORAX.MAP_OrgUnit dh on s.HomeDistrictRefID = dh.DistrictRefID LEFT JOIN
		AURORAX.MAP_SchoolView ss on s.ServiceSchoolRefID = ss.SchoolRefId LEFT JOIN
		AURORAX.MAP_SchoolView sh on s.HomeSchoolRefID = sh.SchoolRefId
GO
--