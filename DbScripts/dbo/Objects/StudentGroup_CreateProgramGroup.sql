--#include StudentUserProfile.sql
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentGroup_CreateProgramGroup]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentGroup_CreateProgramGroup]
GO

 /*
<summary>
Creates a new student group for displaying active interventions assigned
to the specified user.
</summary>
<param name="userProfileId">The Guid ID of the user who will owner the new group</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE  PROCEDURE [dbo].[StudentGroup_CreateProgramGroup]
	@userProfileId uniqueidentifier,
	@programId uniqueidentifier
AS

declare
	@programGroupType uniqueidentifier,
	@currentDate datetime
	
select
	@programGroupType = 'F794FD43-8F92-4D82-90E3-C4D590C8B534',
	@currentDate = getdate()

DECLARE @count int
SET @count = 1

DECLARE @groupId uniqueidentifier
DECLARE @programName varchar(50)	
DECLARE @variantId uniqueidentifier

--NOTE: This does not support programs with multiple variants in the current form
select 
	top 1 
		@programName = 
			-- If there is only one variant for this program, then use the program name, otherwise, use the variant name
			case when (select COUNT(*) from Program p join PrgVariant pv on p.ID = pv.ProgramID where p.ID = @programId) = 1 
				then p.Name
				else pv.Name 
			end,
		@variantId = pv.ID		
FROM
	PrgVariant pv join
	Program p on pv.ProgramID = p.ID
where 
	p.ID = @programId
	
-- save id of existing group
set @groupId = (
		select top 1 ID
		from StudentGroup sg
		where
			StudentGroupTypeID = @programGroupType and
			OwnerID = @userProfileId and			
			Parameter = @variantId
	)

if (@groupId is null) set @groupId = newid()

-- Remove any existing groups associated with the user and the variant
delete StudentGroup 
where
	StudentGroupTypeID = @programGroupType and
	OwnerID = @userProfileId and
	Parameter = @variantId

-- create group if user is relevant to program
declare @recordCount int
select 
	@recordCount =COUNT(*)
FROM
(
	select 'directly assigned' AS RecordType
	from
		PrgItem b join						
		PrgInvolvement priv on priv.ID = b.InvolvementID join		
		PrgItemTeamMember t on t.ItemID = b.ID
	where			
		t.PersonID = @userProfileId and -- this user
		b.ItemOutcomeID is null and --ongoing item		
		priv.VariantID = @variantId -- where the variants match
	union all
	select 'involvement assigned' AS RecordType
	from
		PrgInvolvement priv join							
		PrgInvolvementTeamMember t on t.InvolvementID = priv.ID
	where			
		t.PersonID = @userProfileId and	-- this user
		priv.EndDate is null and 		--ongoing involvement			
		priv.VariantID = @variantId -- where the variants match
	union all
	select 'associated as a teacher' AS RecordType
	from
		PrgInvolvement priv join
		StudentTeacher st on st.StudentID = priv.StudentID join
		Teacher tch on tch.ID = st.TeacherID 
	where		
		tch.UserProfileID = @userProfileId and -- this user is connected to the teacher, connected to the student
		priv.EndDate is null AND -- involvement still active
		priv.VariantID = @variantId AND	--	where the variants match
		CurrentClassCount > 0 -- currently teach them		
	) T 
	
	print '@recordCount ' + cast(@recordCount as varchar(3)) 
if @recordCount > 0 
begin
	insert StudentGroup values ( @groupId, @userProfileId, @programName, @programGroupType, @variantId)	
end