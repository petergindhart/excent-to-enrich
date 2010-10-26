/****** Object:  UserDefinedFunction [dbo].[TestBinding_CleanName]    Script Date: 08/12/2008 17:31:02 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TestBinding_CleanName]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[TestBinding_CleanName]
GO

CREATE FUNCTION [dbo].[TestBinding_CleanName] (@name varchar(100))
RETURNS varchar(100)
AS
BEGIN
	return Replace(Replace(Replace(Replace(Replace(Replace(Replace(@name, ' ', ''), '*', ''), '''', ''), '-', ''), '.', ''), ',', ''), '`', '')	
END
