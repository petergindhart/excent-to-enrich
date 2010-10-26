--#include StudentUserProfile.sql
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StudentGroup_CreateRtiGroup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[StudentGroup_CreateRtiGroup]
GO

 /*
<summary>
Creates a new student group for displaying active interventions assigned
to the specified user.
</summary>
<param name="userProfileId">The Guid ID of the user who will owner the new group</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE  PROCEDURE [dbo].[StudentGroup_CreateRtiGroup]
	@userProfileId uniqueidentifier,
	@variantId	uniqueidentifier
AS

declare
	@rtiGroupType uniqueidentifier,
	@currentDate datetime,
	@groupId uniqueidentifier,
	@variantName varchar(50),
	@programId uniqueidentifier
	
select
	@rtiGroupType = 'F794FD43-8F92-4D82-90E3-C4D590C8B534',
	@currentDate = getdate()

select top 1 @programId = p.ID 
from 
	Program p join
	PrgVariant pv on pv.ProgramID = p.ID 
where 
	pv.ID = @variantId

select @variantName = Name + ' Response to Intervention' from PrgVariant where ID = @variantId

-- save id of existing group
set @groupId = (
		select top 1 ID
		from StudentGroup
		where
			StudentGroupTypeID = @rtiGroupType and
			OwnerID = @userProfileId and
			Parameter = @variantId
	)

if (@groupId is null) set @groupId = newid()

-- Remove any existing RTI groups associated with the user
delete StudentGroup 
where
	StudentGroupTypeID = @rtiGroupType and
	OwnerID = @userProfileId and
	Parameter = @variantId

declare @recordCount int
select 
	@recordCount =COUNT(*)
FROM
(
	select 'involvement assigned' AS RecordType -- a direct RTI assignment this roster year
	from
		PrgInvolvement priv join
		PrgInvolvementTeamMember t on t.InvolvementID = priv.ID
	where			
		t.PersonID = @userProfileId and	-- this user
		priv.EndDate is null and 		--ongoing involvement			
		priv.VariantID = @variantId -- where the variants match
	UNION ALL
	select 'directly assigned' AS RecordType -- a direct assignment to an Item
	from
		PrgItem b join				
		PrgInvolvement priv on priv.ID = b.InvolvementID join 		
		PrgItemTeamMember t on t.ItemID = b.ID 
	where		
		t.PersonID= @userProfileId AND		
		b.ItemOutcomeID is null AND 
		priv.EndDate is null AND
		priv.VariantID = @variantId
	union all
	select 'associated as a teacher' AS RecordType-- a direct assignment this roster year
	from
		PrgInvolvement priv join		
		StudentTeacher st on st.StudentID = priv.StudentID join
		Teacher tch on tch.ID = st.TeacherID 
	where				
		tch.UserProfileID = @userProfileId AND -- this user is connected to the teacher, connected to the student
		priv.EndDate is null AND -- involvement still active
		priv.VariantID = @variantId AND	--	where the variants match
		CurrentClassCount > 0 -- currently teach them	
	) T 
	
if @recordCount > 0 
begin
	insert StudentGroup values ( @groupId, @userProfileId, @variantName, @rtiGroupType, @variantId)
end
