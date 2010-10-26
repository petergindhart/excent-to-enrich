if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_GetRecordsForRecipient]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_GetRecordsForRecipient]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*
<summary>
Gets a list of shared reports for the specified user
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.Report_GetRecordsForRecipient
	@userProfiles uniqueidentifierarray
AS
	select 
		receipients.RecipientID, 
		r.*
	from
		ReportView r join
		(
			select ids.Id RecipientID, share.ReportID
			from
				ReportUserRecipient share join
				dbo.GetUniqueIdentifiers(@userprofiles) ids on share.UserProfileID = ids.Id

			union

			select ids.Id RecipientID, share.ReportID
			from
				ReportGroupRecipient share join
				UserProfile u on 
					(share.SecurityRoleID is null OR u.RoleID = share.SecurityRoleID) and
					(share.SchoolID is null OR u.SchoolID = share.SchoolID) join
				dbo.GetUniqueIdentifiers(@userprofiles) ids on ids.Id = u.Id

			union

			select ids.Id RecipientID, r.ID
			from
				Report r cross join
				dbo.GetUniqueIdentifiers(@userprofiles) ids
			where
				r.IsSharedWithEveryone = 1
			
		) receipients on receipients.ReportID = r.Id
	where
		r.IsSharingEnabled = 1 AND
		r.Owner <> receipients.RecipientID

GO
