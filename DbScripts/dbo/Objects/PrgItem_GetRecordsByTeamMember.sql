SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgItem_GetRecordsByTeamMember]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgItem_GetRecordsByTeamMember]
GO

 /*
<summary>
Gets records from the PrgItem table based upon the specified team member.
</summary>
<param name="teamMemberPersonId">Person ID of the team member.</param>
<param name="itemTypeId">Optional paramater of item type.</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.PrgItem_GetRecordsByTeamMember
	@teamMemberPersonId	uniqueIdentifier,
	@itemTypeId uniqueIdentifier = NULL
AS
	SELECT
		iv.*
	FROM
		PrgItemView iv
		JOIN PrgItemTeamMember tm ON iv.ID = tm.ItemID
	WHERE tm.PersonID = @teamMemberPersonId 
		AND ((@itemTypeId IS NULL) OR (iv.ItemTypeID = @itemTypeId))
	
	UNION

	SELECT
		iv.*
	FROM
		PrgItemView iv JOIN
		PrgActivity a on a.ID = iv.ID JOIN
		PrgItemTeamMember tm ON a.ItemId = tm.ItemID
	WHERE (tm.PersonID = @teamMemberPersonId)
		AND ((@itemTypeId IS NULL) OR (iv.ItemTypeID = @itemTypeId))
		
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

