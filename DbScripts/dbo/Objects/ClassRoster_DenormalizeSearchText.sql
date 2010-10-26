if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClassRoster_DenormalizeSearchText]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ClassRoster_DenormalizeSearchText]
GO

/*
<summary>
Denormalizes class roster and teacher data into a text column for searching
</summary>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[ClassRoster_DenormalizeSearchText]
AS
	-- Create a table variable of the ID and teacher text for each class roster --
	------------------------------------------------------------------------------
	DECLARE @classRosters table(ID uniqueidentifier, Teachers VARCHAR(500))
	INSERT INTO @classRosters
	SELECT ID, NULL FROM ClassRoster

	-- Update search text for classes with current teachers --
	----------------------------------------------------------
	UPDATE c 
	SET Teachers = ISNULL(', ' + Teachers, '') + t.LastName + ', ' + t.FirstName
	FROM 
		@classRosters c JOIN 
		ClassRoster cr ON c.ID = cr.ID JOIN  
		ClassRosterTeacherHistory th ON cr.ID = th.ClassRosterID JOIN 
		Teacher t ON t.id = th.TeacherID 
	WHERE 
		th.EndDate IS NULL	

	UPDATE cr
	SET SearchText = Teachers +  ' ' + ClassName + ' ' + SectionName 
	FROM
		ClassRoster cr JOIN 
		@classRosters c ON c.ID = cr.ID
	WHERE 
		Teachers IS NOT NULL

	-- Delete records from the table variable now that they have been updated --
	----------------------------------------------------------------------------
	DELETE FROM @classRosters WHERE Teachers IS NOT NULL

	-- Update search text for classes without a current teacher --
	--------------------------------------------------------------
	UPDATE c 
	SET Teachers = ISNULL(', ' + Teachers, '') + t.LastName + ', ' + t.FirstName
	FROM 
		@classRosters c JOIN 
		ClassRoster cr ON c.ID = cr.ID JOIN 
		(
			SELECT 
				cr.ID, 
				MAX(EndDate) EndDate
			FROM 
				ClassRoster cr JOIN 
				ClassRosterTeacherHistory th ON th.ClassRosterID = cr.ID 
			GROUP BY 
				cr.ID
		) lastTaught ON lastTaught.ID = cr.ID JOIN 
		ClassRosterTeacherHistory th ON cr.ID = th.ClassRosterID AND th.EndDate = lastTaught.EndDate JOIN 
		Teacher t ON t.id = th.TeacherID 

	UPDATE cr
	SET SearchText = Teachers +  ' ' + ClassName + ' ' + SectionName 
	FROM
		ClassRoster cr JOIN 
		@classRosters c ON c.ID = cr.ID
	WHERE 
		Teachers IS NOT NULL

	-- Delete records from the table variable now that they have been updated --
	----------------------------------------------------------------------------
	DELETE FROM @classRosters WHERE Teachers IS NOT NULL

	-- Update search text for classes without a current or past teacher --
	----------------------------------------------------------------------
	UPDATE cr
	SET SearchText = ClassName + ' ' + SectionName 
	FROM
		ClassRoster cr JOIN 
		@classRosters c ON c.ID = cr.ID

GO
