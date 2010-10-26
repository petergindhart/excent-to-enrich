IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentRecordException_GetStudentHistoryItems]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentRecordException_GetStudentHistoryItems]
GO

CREATE PROCEDURE [dbo].[StudentRecordException_GetStudentHistoryItems]
(
	@studentRecordExceptionID uniqueidentifier
)
AS

DECLARE @results table (
	Name varchar(50),          
	Student1EnrollmentTarget varchar(50),
	Student2EnrollmentTarget varchar(50),
	FinalEnrollmentTarget varchar(50)  , 
	Student1StartDate   datetime,    
	Student2StartDate   datetime,    
	FinalStartDate     datetime,     
	Student1EndDate     datetime,    
	Student2EndDate     datetime,    
	FinalEndDate      datetime,      
	Overlaps bit	
)

DECLARE @stu1 uniqueidentifier
DECLARE @stu2 uniqueidentifier

--DECLARE @studentRecordExceptionID uniqueidentifier
--SET @studentRecordExceptionID = 'ACFAEC13-5149-4028-98CD-80A01DDCF474'

SELECT
	@stu1 = Student1ID,
	@stu2 = Student2ID
FROM
	StudentRecordException
WHERE
	ID = @studentRecordExceptionID

insert into @results
select 
	Name = 'School Enrollment History',	
	Student1EnrollmentTarget = s1.Abbreviation,
	Student2EnrollmentTarget = s2.Abbreviation,
	FinalEnrollmentTarget = case when s1.Name is not null and s2.Name is not null then --overlap
								case when s1.EndDate is null then s1.Abbreviation 
									 when s2.EndDate is null then s2.Abbreviation		
									 when (s1.EndDate - s1.StartDate) > 	(s2.EndDate - s2.StartDate) then s1.Abbreviation 
									 else s2.Abbreviation END										
								else case when s1.Name is null then s2.Abbreviation else s1.Abbreviation end
							end,
	Student1StartDate = s1.StartDate,
	Student2StartDate = s2.StartDate,
	FinalStartDate = case when s1.Name is not null and s2.Name is not null then --overlap
							case when s1.EndDate is null then s1.StartDate -- s1 is still in progress
								 when s2.EndDate is null then s2.StartDate -- s2 is still in progress
								 when (s1.EndDate - s1.StartDate) > (s2.EndDate - s2.StartDate) then s1.StartDate --which one lasted longer
								 else s2.StartDate END
							else case when s1.StartDate is null then s2.StartDate else s1.StartDate end
					end,
	Student1EndDate = s1.EndDate,
	Student2EndDate = s2.EndDate,
	FinalEndDate = case when s1.Name is not null and s2.Name is not null then --overlap
						case when s1.EndDate is null OR s2.EndDate is null then null -- either is still in progress
							 when (s1.EndDate - s1.StartDate) > (s2.EndDate - s2.StartDate) then s1.EndDate
							 else s2.EndDate END		
						else case when s1.EndDate is null then s2.EndDate else s1.EndDate end
					end,
	Overlaps = case when s1.Name is not null and s2.Name is not null then 1 else 0 end
FROM
(
	SELECT
		sch.Abbreviation,
		sch.Name,
		StartDate = hist.StartDate,
		EndDate = hist.EndDate
	FROM
		StudentSchoolhistory hist join
		School sch on sch.ID = hist.SchoolID
	WHERE
		hist.StudentID = @stu1
) s1 full outer join
(	
	SELECT
		sch.Abbreviation,
		sch.Name,
		StartDate = hist.StartDate,
		EndDate = hist.EndDate
	FROM
		StudentSchoolhistory hist join
		School sch on sch.ID = hist.SchoolID
	WHERE
		hist.StudentID = @stu2
) s2 on dbo.DateRangesOverlap(s1.StartDate, s1.EndDate, s2.StartDate, s2.EndDate, null) = 1

insert into @results
select 
	Name = 'Grade Level History',	
	Student1EnrollmentTarget = s1.Name,
	Student2EnrollmentTarget = s2.Name,
	FinalEnrollmentTarget = case when s1.Name is not null and s2.Name is not null then --overlap
								case when s1.EndDate is null then s1.Name 
									 when s2.EndDate is null then s2.Name		
									 when (s1.EndDate - s1.StartDate) > 	(s2.EndDate - s2.StartDate) then s1.Name 
									 else s2.Name END										
								else case when s1.Name is null then s2.Name else s1.Name end
							end,
	Student1StartDate = s1.StartDate,
	Student2StartDate = s2.StartDate,
	FinalStartDate = case when s1.Name is not null and s2.Name is not null then --overlap
							case when s1.EndDate is null then s1.StartDate -- s1 is still in progress
								 when s2.EndDate is null then s2.StartDate -- s2 is still in progress
								 when (s1.EndDate - s1.StartDate) > (s2.EndDate - s2.StartDate) then s1.StartDate --which one lasted longer
								 else s2.StartDate END
							else case when s1.StartDate is null then s2.StartDate else s1.StartDate end
					end,
	Student1EndDate = s1.EndDate,
	Student2EndDate = s2.EndDate,
	FinalEndDate = case when s1.Name is not null and s2.Name is not null then --overlap
						case when s1.EndDate is null OR s2.EndDate is null then null -- either is still in progress
							 when (s1.EndDate - s1.StartDate) > (s2.EndDate - s2.StartDate) then s1.EndDate
							 else s2.EndDate END		
						else case when s1.EndDate is null then s2.EndDate else s1.EndDate end
					end,
	Overlaps = case when s1.Name is not null and s2.Name is not null then 1 else 0 end
FROM
(
	SELECT
		sch.Name,
		StartDate = hist.StartDate,
		EndDate = hist.EndDate
	FROM
		StudentGradeLevelHistory hist join
		GradeLevel sch on sch.ID = hist.GradeLevelID
	WHERE
		hist.StudentID = @stu1
) s1 full outer join
(	
	SELECT
		sch.Name,
		StartDate = hist.StartDate,
		EndDate = hist.EndDate
	FROM
		StudentGradeLevelHistory hist join
		GradeLevel sch on sch.ID = hist.GradeLevelID
	WHERE
		hist.StudentID = @stu2
) s2 on dbo.DateRangesOverlap(s1.StartDate, s1.EndDate, s2.StartDate, s2.EndDate, null) = 1 and s1.Name = s2.Name -- and s1.Name = s2.Name
	
select * from @results
Order by
	Name, FinalStartDate