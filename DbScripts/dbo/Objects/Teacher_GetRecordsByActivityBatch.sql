if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Teacher_GetRecordsByActivityBatch]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Teacher_GetRecordsByActivityBatch]
GO

/*
<summary>
Gets records from the Teacher table
</summary>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Teacher_GetRecordsByActivityBatch]
	@batchId UNIQUEIDENTIFIER
AS
	SELECT DISTINCT t.*
	FROM 
		PrgActivityBatch b JOIN 
		PrgActivity a ON a.BatchId = b.Id JOIN 
		PrgItem i ON i.Id = a.ItemId JOIN 
		PrgItemTeamMember itm ON itm.ItemId = i.Id JOIN 
		UserProfile u ON u.ID = itm.PersonID JOIN 
		Teacher t ON t.UserProfileID = u.Id
	WHERE 
		u.Deleted IS NULL AND 
		b.Id = @batchId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
