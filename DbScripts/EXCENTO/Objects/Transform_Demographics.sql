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
		HomeDistrictID = hd.DestID,
		HomeSchoolID = hs.DestID
	FROM
		EXCENTO.Transform_Iep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = 'C26636EE-5939-45C7-A43A-D1D18049B9BD' JOIN --IEP Demographics
		EXCENTO.Student stu on stu.GStudentID = iep.GStudentID JOIN
		EXCENTO.MAP_DistrictID d on stu.DistrictID = d.GDistrictID JOIN
		EXCENTO.MAP_SchoolID s on stu.SchoolID = s.SchoolID LEFT JOIN
		EXCENTO.ReportStudentSchools sch on stu.GStudentID = sch.GStudentID LEFT JOIN 
		EXCENTO.MAP_DistrictID hd on sch.ResidDistCode = hd.GDistrictID LEFT JOIN
		EXCENTO.MAP_SchoolID hs on sch.ResidSchCode = hs.SchoolID 
		
GO
