IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_DATAVALIDATION.vw_ValidationSummaryreport') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_DATAVALIDATION.vw_ValidationSummaryreport 
GO

CREATE VIEW x_DATAVALIDATION.vw_ValidationSummaryreport 
AS
SELECT o.Sequence, vr.tablename, vr.errormessage, vr.NumberOfRecords
FROM x_DATAVALIDATION.ValidationSummaryReport vr
JOIN x_DATAVALIDATION.TableOrder o on vr.Tablename = o.TableName
--ORDER BY o.Sequence, vr.tablename, vr.errormessage
