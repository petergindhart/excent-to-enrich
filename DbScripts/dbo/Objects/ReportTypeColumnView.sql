
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'ReportTypeColumnView' 
	   AND 	  type = 'V')
    DROP VIEW dbo.ReportTypeColumnView
GO

CREATE VIEW dbo.ReportTypeColumnView
AS 
	SELECT
		rtc.*
	FROM
		VC3Reporting.ReportTypeColumn rtc

	UNION


	SELECT 
		rsc.Id,
		rtt.Id,
		rsc.Name,
		rsc.Sequence
	FROM
		VC3Reporting.ReportSchemaColumn rsc JOIN
		VC3Reporting.ReportSchemaTable rst ON rsc.SchemaTable = rst.Id JOIN
		VC3Reporting.ReportTypeTable rtt ON rst.Id = rtt.SchemaTable LEFT JOIN
		VC3Reporting.ReportTypeColumn rtc ON rtt.Id = rtc.ReportTypeTable
	WHERE
		rtc.SchemaColumn IS NULL



GO
