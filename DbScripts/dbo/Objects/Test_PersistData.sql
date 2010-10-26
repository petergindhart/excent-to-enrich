SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Test_PersistData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Test_PersistData]
GO


/*
<summary>
Executes a Transact-SQL statement against Test Table
</summary>
<param name="statement">statement to execute</param>
*/
CREATE PROCEDURE dbo.Test_PersistData 
	@statement varchar(8000)
AS

exec(@statement)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

