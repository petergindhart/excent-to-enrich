-- =============================================
-- Create scalar function (FN)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'GetImportDate')
	DROP FUNCTION dbo.GetImportDate
GO

CREATE FUNCTION dbo.GetImportDate()
RETURNS datetime
AS
BEGIN
	declare @importDate datetime
	select @importDate = SnapshotDate from SisDatabase

	return @importDate
END
GO

