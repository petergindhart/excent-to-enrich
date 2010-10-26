SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Tokens_GetValueByName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Tokens_GetValueByName]
GO



/*
<summary>
Gets a Token Value by Name
</summary>
<param name="name">The name of the Token to retrieve.</param>
<model isGenerated="False" returnType="System.Guid" />
*/
CREATE PROCEDURE dbo.Tokens_GetValueByName
	@name varchar(50)
AS

SELECT [ID] FROM Tokens WHERE Name = @name


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

