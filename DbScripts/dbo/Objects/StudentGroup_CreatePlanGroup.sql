-- =============================================
-- Create procedure dbo.basic template
-- =============================================
-- creating the store procedure
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'StudentGroup_CreatePlanGroup' 
	   AND 	  type = 'P')
    DROP PROCEDURE StudentGroup_CreatePlanGroup
GO




/*
<summary>
Creates a New Student Group for Displaying Academic Plans.
</summary>
<param name="userProfileId">The Guid ID of the user who will owner the new group</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE  PROCEDURE dbo.StudentGroup_CreatePlanGroup 
	@userProfileId uniqueidentifier 
AS

declare @academicPlanGroupType uniqueidentifier
set @academicPlanGroupType = 'D86861C5-9B1E-4758-AE33-2D3FFBD20566'

-- Re-create all of the automatic student groups for this user.
-- Delete to handle user-teacher disassociations

-- Remove any old auto student groups associated with the user
delete StudentGroup 
where
	StudentGroupTypeID = @academicPlanGroupType and OwnerID = @userProfileId or
	Id in (select Id from Teacher where UserProfileID=@userProfileId)

declare @groupCount int
select @groupCount = count(*) from Teacher where UserProfileID=@userProfileId

if @groupCount > 0
begin
	-- Add auto student groups back for the user
	insert into StudentGroup(Id, OwnerID, Name, StudentGroupTypeID)
	select
		t.Id,
		UserProfileID, 
		'My ' + (case when @groupCount > 1 then isnull(sch.Abbreviation + ' ', '') else '' end) + 'Students With Academic Plans',
		@academicPlanGroupType
	from
		Teacher t left join
		School sch on t.CurrentSchoolID = sch.ID
	where
		UserProfileID=@userProfileId
end

GO
