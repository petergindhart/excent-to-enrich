SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CertificationSetCertificationView]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[CertificationSetCertificationView]
GO

CREATE VIEW dbo.CertificationSetCertificationView 
AS 

	/*
		Flattens the relationship between a certification set and related
		Certifications
		CertificationGroups
		CertificationTypes
	 */
	
	select
		s.CertificationSetID, s.CertificationID
	from
		CertificationSetCertification s
	union
	select
		s.CertificationSetID, c.CertificationID
	from
		CertificationSetCertificationGroup s join
		CertificationGroup g on s.CertificationGroupID = g.ID join
		CertificationGroupCertification c on c.CertificationGroupID = g.ID
	-- union
	-- select
	-- 	s.CertificationSetID, c.ID
	-- from
	-- 	CertificationSetCertificationType s join
	-- 	Certification c on c.TypeID = s.CertificationTypeID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

