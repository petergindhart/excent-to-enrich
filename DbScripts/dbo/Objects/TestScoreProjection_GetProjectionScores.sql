SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TestScoreProjection_GetProjectionScores]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TestScoreProjection_GetProjectionScores]
GO

/*
<summary>
Gets the Projection Scores for a particular test name and section name
</summary>
<param name="name">The name of the test.</param>
<param name="section">Math or Reading</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Guid" />
*/
CREATE PROCEDURE dbo.TestScoreProjection_GetProjectionScores
	@name varchar(25), 
	@section varchar(25) 
AS

SELECT a.[ID] 
	FROM TestScoreProjection a INNER JOIN TestSection b ON a.TestSectionID = b.[ID] 
WHERE b.[Name] = @name 
AND a.TestName = @name

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

