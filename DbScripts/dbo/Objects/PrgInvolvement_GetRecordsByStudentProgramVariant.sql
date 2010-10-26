SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgInvolvement_GetRecordsByStudentProgramVariant]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgInvolvement_GetRecordsByStudentProgramVariant]
GO

 /*
<summary>
Gets records from the PrgInvolvement table
matching the specified parameters
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.PrgInvolvement_GetRecordsByStudentProgramVariant
	@studentId uniqueidentifier,
	@programId uniqueidentifier,
	@variantId uniqueidentifier
AS
	SELECT
		p.*
	FROM
		PrgInvolvement p
	WHERE
		( @studentId is null or p.StudentId = @studentId ) and
		( @programId is null or p.ProgramID = @programId ) and
		( @variantId is null or p.VariantId = @variantId )
	ORDER BY p.StartDate
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

