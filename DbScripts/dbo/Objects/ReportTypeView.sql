if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportTypeView]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[ReportTypeView]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.ReportTypeView
AS 
	SELECT 
		vrt.*,
		rt.ContextTypeID,
		rt.Summary,
		rt.PreviewImg,
		rt.IsDistinct,
		rt.Sequence,
		rt.ViewTaskID,
		rt.ViewFeatureId,
		rtt.Id PrimaryTable
	FROM
		ReportType rt join		
		VC3Reporting.ReportType vrt on vrt.Id = rt.id left join
		VC3Reporting.ReportTypeTable rtt on rtt.ReportType = rt.Id
	WHERE
		rtt.JoinTable is null



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO