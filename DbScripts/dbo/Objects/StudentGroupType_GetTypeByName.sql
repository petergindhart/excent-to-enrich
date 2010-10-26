SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StudentGroupType_GetTypeByName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[StudentGroupType_GetTypeByName]
GO

/*
<summary>
Gets a StudentGroupType object based on its name.
</summary>
<param name="name">The name of the Student Group Type.</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Guid" />
*/
CREATE PROCEDURE dbo.StudentGroupType_GetTypeByName
	@name varchar(50)
AS
	SELECT [ID]
	FROM
		StudentGroupType 
	WHERE UPPER(Name) = UPPER(@name)


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

