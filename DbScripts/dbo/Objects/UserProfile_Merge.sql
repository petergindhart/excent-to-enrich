IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[UserProfile_Merge]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[UserProfile_Merge]
GO

 /*
<summary>
Merges one user profile into another
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[UserProfile_Merge]
	@userToKeep uniqueidentifier,
	@userToDelete uniqueidentifier
AS

begin tran

-- update all records so they no longer refer to the old user
update AcademicPlanGen set GeneratedByID = @userToKeep where GeneratedByID = @userToDelete
update AuditLogEntry set UserProfileID = @userToKeep where UserProfileID = @userToDelete
update ChangeHistory set UserID = @userToKeep where UserID = @userToDelete
update Comment set UserID = @userToKeep where UserID = @userToDelete
update Process set CreatedBy = @userToKeep where CreatedBy = @userToDelete
update ProcessStepComment set UserID = @userToKeep where UserID = @userToDelete
update QualificationPlan set CreatedBy = @userToKeep where CreatedBy = @userToDelete

-- IsPublished=0 will cause security to be reevaluated next time the report is viewed
update Report set Owner = @userToKeep, IsPublished = 0 where Owner = @userToDelete

-- delete the automatic student groups assigned to the old user first
delete from StudentGroup where OwnerID = @userToDelete and StudentGroupTypeID = 'D86861C5-9B1E-4758-AE33-2D3FFBD20566' -- academic plan group
update StudentGroup set OwnerID = @userToKeep where OwnerID = @userToDelete

update Teacher set UserProfileID = @userToKeep where UserProfileID = @userToDelete
update UserPassword set UserProfileID = @userToKeep where UserProfileID = @userToDelete

update PrgItemTeamMember set PersonID = @userToKeep where PersonID = @userToDelete


-- These tables are unique per user
update old
set
	old.UserID = @userToKeep
from
	AnnouncementViewing old left join
	AnnouncementViewing new on old.AnnouncementID = new.AnnouncementID and @userToKeep = new.UserID
where
	old.UserID = @userToDelete and
	new.UserID is null

update old
set
	old.UserID = @userToKeep
from
	ProcessRoleUserProfile old left join
	ProcessRoleUserProfile new on old.RoleID = new.RoleID and @userToKeep = new.UserID
where
	old.UserID = @userToDelete and
	new.UserID is null


update old
set
	old.UserProfileID = @userToKeep
from
	UserProfileAlert old left join
	UserProfileAlert new on old.AlertID = new.AlertID and @userToKeep = new.UserProfileID
where
	old.UserProfileID = @userToDelete and
	new.UserProfileID is null


update old
set
	old.UserProfileID = @userToKeep
from
	ReportFavorite old left join
	ReportFavorite new on old.ReportID = new.ReportID and @userToKeep = new.UserProfileID
where
	old.UserProfileID = @userToDelete and
	new.UserProfileID is null


update old
set
	old.UserProfileID = @userToKeep
from
	ReportUserRecipient old left join
	ReportUserRecipient new on old.ReportID = new.ReportID and @userToKeep = new.UserProfileID
where
	old.UserProfileID = @userToDelete and
	new.UserProfileID is null



-- Delete the old user profile
exec UserProfile_DeleteRecord @userToDelete

commit tran
GO

--
--
--select * from UserProfile where username like '%robert%'
--select * from teacher where emailaddress='patricia.sinclair@vc3.com'
--
--UserProfile
--
