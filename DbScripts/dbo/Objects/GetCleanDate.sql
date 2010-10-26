IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GetCleanDate]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[GetCleanDate]
GO

CREATE FUNCTION [dbo].[GetCleanDate] (@date datetime)
RETURNS datetime
AS
BEGIN
	RETURN ( select DATEADD(dd, 0, DATEDIFF(dd, 0, @date)))
END