--#include Transform_Iep.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_Demographics]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_Demographics]
GO

CREATE VIEW EXCENTO.Transform_Demographics
AS
	SELECT
		DestID = sec.ID,
		PrimaryLanguageID = cast(NULL as uniqueidentifier),
		PrimaryLanguageHomeID = cast(NULL as uniqueidentifier),
		ServiceDistrictID = d.DestID,
		ServiceSchoolID = s.DestID,
		HomeDistrictID = cast(NULL as uniqueidentifier),
		HomeSchoolID = cast(NULL as uniqueidentifier)
	FROM
		EXCENTO.Transform_Iep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = 'C26636EE-5939-45C7-A43A-D1D18049B9BD' JOIN --IEP Demographics
		EXCENTO.Transform_Involvement inv on inv.DestID = iep.InvolvementID JOIN
		EXCENTO.Student stu on stu.GStudentID = inv.GStudentID JOIN
		EXCENTO.MAP_DistrictID d on stu.DistrictID = d.GDistrictID JOIN
		EXCENTO.MAP_SchoolID s on stu.SchoolID = s.SchoolID
GO

