SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[School_GetRecordByAbbreviation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[School_GetRecordByAbbreviation]
GO


/*
<summary>
Gets a school by its abbreviation
</summary>
<param name="abbreviation">The abbreviation to search for</param>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.School_GetRecordByAbbreviation 
	@abbreviation VARCHAR(10)
AS
	SELECT *
	FROM School
	WHERE Abbreviation = @abbreviation

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

