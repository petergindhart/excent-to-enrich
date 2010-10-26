

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserProfile_FindMergableByUserProfile]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UserProfile_FindMergableByUserProfile]
GO

 /*
<summary>
Find records that could potentially be merged with the specified
user by:
	1) Same Email Address
	2) Less recent login activity
</summary>
<param name="userProfileId">Ids of the School(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.UserProfile_FindMergableByUserProfile
	@userProfileId uniqueidentifier
AS

select
	m.*
from
	UserProfileView u join
	UserProfileView m on
		m.Id <> u.Id and
		m.EmailAddress = u.EmailAddress and
		m.Deleted is null
where
	u.Id = @userProfileId and
	(select isnull(max(EventTime), getdate()) from AuditLogEntry where UserProfileID = u.ID)
	>= (select isnull(max(EventTime), getdate()) from AuditLogEntry where UserProfileID = m.ID)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

