/****** Object:  StoredProcedure [dbo].[PrgMeeting_GetRecordsByTeamMember]    Script Date: 12/29/2009 09:33:49 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgMeeting_GetRecordsByTeamMember]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgMeeting_GetRecordsByTeamMember]
GO

/****** Object:  StoredProcedure [dbo].[PrgMeeting_GetRecordsByTeamMember]    Script Date: 12/29/2009 09:33:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 /*
<summary>
Gets records from the PrgMeeting table based upon the specified team member.
</summary>
<param name="teamMemberPersonId">Person ID of the team member.</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgMeeting_GetRecordsByTeamMember]
	@teamMemberPersonId	uniqueIdentifier
AS
	SELECT
		m.*,
		i.*
	FROM
		PrgMeeting m JOIN PrgItemView i ON m.ID = i.ID
		JOIN PrgItemTeamMember tm ON i.ID = tm.ItemID
	WHERE tm.PersonID = @teamMemberPersonId
		

GO


