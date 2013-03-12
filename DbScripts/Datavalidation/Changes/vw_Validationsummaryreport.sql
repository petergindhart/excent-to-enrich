IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Datavalidation.vw_ValidationSummaryreport') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW Datavalidation.vw_ValidationSummaryreport 
GO

CREATE VIEW Datavalidation.vw_ValidationSummaryreport 
AS
SELECT o.Sequence, vr.tablename, vr.errormessage, vr.NumberOfRecords
FROM DataValidation.ValidationSummaryReport vr
JOIN DataValidation.TableOrder o on vr.Tablename = o.TableName
--ORDER BY o.Sequence, vr.tablename, vr.errormessage
