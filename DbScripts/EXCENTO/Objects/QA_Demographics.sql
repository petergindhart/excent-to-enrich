IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[QA_Demographics]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[QA_Demographics]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [EXCENTO].[QA_Demographics]
AS
	SELECT
		iep.IEPSeqNum, stu.GStudentID,
		sec.PrimaryLanguageHomeID,
		sec.PrimaryLanguageID,
		d.Name [ServiceDistrict],
		s.Name [ServiceSchool],
		sec.HomeDistrictID,
		sec.HomeSchoolID
	FROM
		EXCENTO.Transform_Iep iep JOIN
		EXCENTO.MAP_StudentID stu ON iep.StudentID = stu.DestID JOIN
		EXCENTO.Transform_Section secBase ON secBase.ItemID = iep.DestID JOIN
		-- replace [<section table>] below with table name in list
		[IepDemographics] sec ON sec.ID = secBase.DestID JOIN
		IepDistrict d on sec.ServiceDistrictID = d.ID JOIN
		IepSchool s on sec.ServiceSchoolID = s.ID
GO

