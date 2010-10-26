SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_GetTierCounts]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_GetTierCounts]
GO


/*
<summary>
Counts the number of students in each tier currently.
</summary>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Report_GetTierCounts
	@schoolId uniqueidentifier = null
AS

declare @totalStudents float

select @totalStudents = count(*)
from Student s
where 
	((@schoolID is null and s.CurrentSchoolID is not null) OR (@schoolID = s.CurrentSchoolID))


select
	TierID = t.ID,
	Students = isnull(count(studentTiers.MaxTierSequence), 0),
	StudentsPrct = isnull(count(studentTiers.MaxTierSequence), 0) / dbo.IntMax(@totalStudents, 1)
from
	Tier t left join
	(
		select
			s.ID, MaxTierSequence = max(isnull(t.Sequence, 0))
		from
			Student s left join
			StudentDomainTier sdt on s.ID = sdt.StudentID left join
			Tier t on t.ID = sdt.TierID
		where
			sdt.EndDate is null and
			((@schoolID is null and s.CurrentSchoolID is not null) OR (@schoolID = s.CurrentSchoolID))			
		group by
			s.ID
	) studentTiers on studentTiers.MaxTierSequence = t.Sequence
group by
	t.ID
GO

--exec [Report_GetTierCounts]


