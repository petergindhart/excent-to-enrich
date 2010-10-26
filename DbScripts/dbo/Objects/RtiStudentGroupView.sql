--#include StudentUserProfile.sql
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RtiStudentGroupView]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[RtiStudentGroupView]
GO

CREATE VIEW dbo.RtiStudentGroupView
AS

select 
	distinct StudentID, GroupID
from
(
	select
		g.ID [GroupID],
		priv.StudentID
	from	
		PrgInvolvement priv join		
		PrgItem i on i.InvolvementID = priv.ID join
		PrgItemTeamMember t on t.ItemID = i.ID join
		Program prog on priv.ProgramID = prog.ID join
		StudentGroup g on g.OwnerID = t.PersonID
	where	
		prog.Abbreviation = 'RTI' AND
		priv.EndDate is null AND 		
		g.StudentGroupTypeID = 'F794FD43-8F92-4D82-90E3-C4D590C8B534' and
		g.Parameter = priv.VariantID
	group by g.ID, priv.StudentID

	UNION ALL

	select
		g.ID [GroupID],
		priv.StudentID
	from	
		PrgInvolvement priv join				
		PrgInvolvementTeamMember t on t.InvolvementID = priv.ID join
		Program prog on priv.ProgramID = prog.ID join
		StudentGroup g on g.OwnerID = t.PersonID
	where	
		prog.Abbreviation = 'RTI' AND
		priv.EndDate is null AND 		
		g.StudentGroupTypeID = 'F794FD43-8F92-4D82-90E3-C4D590C8B534' and
		g.Parameter = priv.VariantID
	group by g.ID, priv.StudentID
	
	UNION ALL
	
	select
		g.ID [GroupID],
		priv.StudentID
	from
		PrgInvolvement priv join		
		StudentUserProfile classes on classes.StudentID = priv.StudentID join
		Program prog on priv.ProgramID = prog.ID join
		StudentGroup g on g.OwnerID = classes.UserProfileID
	where
		prog.Abbreviation = 'RTI' AND
		priv.EndDate is null AND 		
		g.StudentGroupTypeID = 'F794FD43-8F92-4D82-90E3-C4D590C8B534' and
		g.Parameter = priv.VariantID
	group by g.ID, priv.StudentID
) T


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
