IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ReportView]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[ReportView]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[ReportView]
AS 
	SELECT 
		v.*,
		r.Owner,
		r.IsPublished,
		r.SecurityZone,
		r.IsSharingEnabled,
		r.IsSharedWithEveryone,
		r.RunAsOwner,
		r.IsHidden,
		r.OmitNulls,
		r.DateCreated,
		r.ViewFeatureID
	FROM
		VC3Reporting.Report v join
		Report r on r.Id = v.Id
GO
