IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_Demographics') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_Demographics
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepDemographics') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepDemographics
GO

CREATE VIEW LEGACYSPED.Transform_IepDemographics
AS
	SELECT
		iep.StudentRefID,
		DestID = m.DestID,
		ServiceDistrictID = ss.OrgUnitID,
		ServiceSchoolID = ss.DestID,
		HomeDistrictID = sh.OrgUnitID,
		HomeSchoolID = sh.DestID,
		iep.DoNotTouch
	FROM
		LEGACYSPED.Transform_PrgIep iep LEFT JOIN
		LEGACYSPED.MAP_PrgSectionID m on 
			m.DefID = '3BD3B039-2805-4983-948A-F3BFA86A72C9' and
			m.VersionID = iep.VersionDestID LEFT JOIN
		LEGACYSPED.Student s on s.StudentRefID = iep.StudentRefID LEFT JOIN
		LEGACYSPED.Transform_School ss on s.ServiceSchoolCode = ss.SchoolCode and s.ServiceDistrictCode = ss.DistrictCode/* and ss.DeletedDate is null */ LEFT JOIN
		LEGACYSPED.Transform_School sh on s.HomeSchoolCode = sh.SchoolCode and s.HomeDistrictCode = sh.DistrictCode /* and sh.DeletedDate is null */ LEFT JOIN
		dbo.School dss on ss.DestID = dss.ID /* and dss.ManuallyEntered = 1 */ left join
		dbo.School dsh on sh.DestID = dsh.ID /* and dsh.ManuallyEntered = 1 */
GO
--

