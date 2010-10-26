SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Token_GetAllTokens]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Token_GetAllTokens]
GO

/*
<summary>
Gets all Tokens in the system
</summary>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Token_GetAllTokens
AS

SELECT * FROM Token


GO
