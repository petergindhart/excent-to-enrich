IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Datavalidation.vw_ValidationSummaryreport') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW Datavalidation.vw_ValidationSummaryreport 
GO

CREATE VIEW Datavalidation.vw_ValidationSummaryreport 
AS
SELECT o.Sequence, vr.tablename, vr.errormessage, count(*) total
FROM DataValidation.ValidationReport vr
JOIN DataValidation.TableOrder o on vr.Tablename = o.TableName
GROUP BY o.Sequence, vr.tablename, vr.errormessage
