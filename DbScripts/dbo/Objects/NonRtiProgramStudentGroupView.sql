--#include StudentUserProfile.sql
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[NonRtiProgramStudentGroupView]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[NonRtiProgramStudentGroupView]
GO

CREATE VIEW NonRtiProgramStudentGroupView 
AS

select 
	distinct StudentID, GroupID
from
(
	select
		g.ID [GroupID],
		b.StudentID
	from
		PrgItem b join	
		PrgItemTeamMember t on t.ItemID = b.ID join
		PrgInvolvement involv on involv.ID = b.InvolvementID join
		PrgVariant v on v.ID = involv.VariantID join
		Program prog on involv.ProgramID = prog.ID join
		StudentGroup g on g.OwnerID = t.PersonID
	where	
		prog.Abbreviation <> 'RTI' AND
		involv.EndDate is null AND 
		g.StudentGroupTypeID = 'F794FD43-8F92-4D82-90E3-C4D590C8B534' and
		g.Parameter = v.ID
	group by 
		g.ID, 
		b.StudentID
		
	UNION ALL

	select
		g.ID [GroupID],
		involv.StudentID
	from		
		PrgInvolvementTeamMember t join
		PrgInvolvement involv on involv.ID = t.InvolvementID join
		PrgVariant v on v.ID = involv.VariantID join
		Program prog on involv.ProgramID = prog.ID join
		StudentGroup g on g.OwnerID = t.PersonID		
	where	
		prog.Abbreviation <> 'RTI' AND
		involv.EndDate is null AND 
		g.StudentGroupTypeID = 'F794FD43-8F92-4D82-90E3-C4D590C8B534' and
		g.Parameter = v.ID
	group by 
		g.ID, 
		involv.StudentID
		
	UNION ALL
	
	select
		g.ID [GroupID],
		priv.StudentID
	from
		PrgInvolvement priv join
		Program prog on priv.ProgramID = prog.ID join
		StudentUserProfile classes on classes.StudentID = priv.StudentID join
		StudentGroup g on g.OwnerID = classes.UserProfileID
	where
		priv.EndDate is null AND 
		prog.Abbreviation <> 'RTI' and
		g.StudentGroupTypeID = 'F794FD43-8F92-4D82-90E3-C4D590C8B534' and
		g.Parameter = priv.VariantID
	group by g.ID, priv.StudentID
) T