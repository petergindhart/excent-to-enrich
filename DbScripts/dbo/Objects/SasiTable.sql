SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SasiTable]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[SasiTable]
GO


CREATE FUNCTION dbo.SasiTable ( @baseName AS VARCHAR(128) )
RETURNS VARCHAR(128)
AS
BEGIN

	DECLARE @prefix VARCHAR(50)
	DECLARE @suffix VARCHAR(50)
	
	SELECT TOP 1 @prefix = TablePrefix, @suffix = TableSuffix
	FROM SasiImportSetting
	
	RETURN @prefix + @baseName + @suffix

END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

