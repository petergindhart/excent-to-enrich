IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GetClassRosterGradeBitMask]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[GetClassRosterGradeBitMask]
GO

CREATE FUNCTION dbo.GetClassRosterGradeBitMask
(
	@classRosterId uniqueidentifier
)
RETURNS int
AS
BEGIN
	declare @classBitMask int

	select
		@classBitMask = GradeBitMask
	from
		ClassRoster c
	where
		c.ID = @classRosterId

	if( @classBitMask is null )		
	begin		
			select 
				@classBitMask = (	
										select top 1 mask.BitMask 
										from 
											GradeRangeBitMask mask join
											GradeLevel glLow on mask.MinGradeId = glLow.Id join
											GradeLevel glHigh on mask.MaxGradeId = glHigh.Id
										where 
											glLow.Sequence = MIN(gl.Sequence) and 
											glHigh.Sequence  = MAX(gl.Sequence)
										ORDER BY
											mask.BitMask desc
								)
			from
				ClassRoster c join
				RosterYear y on c.RosterYearID = y.ID join
				StudentClassRosterHistory ch on ch.ClassRosterID = c.ID join
				Student s on ch.StudentID = s.ID join
				StudentGradeLevelHistory gh on gh.StudentID = s.ID and
					dbo.DateInRange( y.EndDate, gh.StartDate, gh.EndDate ) = 1	join
				GradeLevel gl on gl.Id = gh.GradeLevelId			
			where
				c.ID = @classRosterId
			group by
				c.ID
	end

	return isNull(@classBitMask, 0)
END
