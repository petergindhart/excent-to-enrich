if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATATEAM' and o.name = 'StudentRecordException_MergeNoConflictRecords_DeleteTests')
DROP PROCEDURE [x_DATATEAM].[StudentRecordException_MergeNoConflictRecords_DeleteTests]
GO


CREATE PROCEDURE x_DATATEAM.StudentRecordException_MergeNoConflictRecords_DeleteTests
(
	@pickedStudent uniqueidentifier,
	@notPickedStudent uniqueidentifier
)
AS
declare @victim varchar(36) ; set @victim = @notPickedStudent 

/***********************************
***   AuditLogEntry				***
***********************************/
UPDATE AuditLogEntry
SET ContextID = @pickedStudent
WHERE ContextID = @notPickedStudent

UPDATE AuditLogEntry
SET TargetID = @pickedStudent
WHERE TargetID = @notPickedStudent


/***********************************
***   Absence					***
***********************************/
UPDATE Absence
SET StudentID = @pickedStudent
WHERE StudentID = @notPickedStudent	


/***********************************
***   DisciplineIncident		 ***
***********************************/
UPDATE DisciplineIncident
SET StudentID = @pickedStudent
WHERE StudentID = @notPickedStudent


/***********************************
***   ReportCardScore			 ***
***********************************/
-- Purge report cards from the non-picked student, that will conflict with the picked student during update
delete rcsNotPicked
from 
	ReportCardScore rcsPicked join
	ReportCardScore rcsNotPicked on 
		rcsPicked.ClassRoster = rcsNotPicked.ClassRoster and 
		rcsPicked.ReportCardItem  = rcsNotPicked.ReportCardItem
WHERE
	rcsPicked.Student = @pickedStudent AND
	rcsNotPicked.Student = @notPickedStudent
	
UPDATE ReportCardScore
SET Student = @pickedStudent
WHERE Student = @notPickedStudent


/***********************************
***   TranscriptCourse			***
***********************************/
UPDATE TranscriptCourse
SET StudentID = @pickedStudent
WHERE StudentID = @notPickedStudent


/***********************************
***   StudentGroupStudent		 ***
***********************************/
INSERT INTO StudentGroupStudent
select  
	StudentGroupID,
	@pickedStudent
From 
	StudentGroupStudent g1 
WHERE 
	g1.StudentID = @notPickedStudent and
	g1.StudentGroupID not in
	(
		SELECT Distinct StudentGroupID FROM StudentGroupStudent g2 WHERE g2.StudentID = @pickedStudent
	)

DELETE StudentGroupStudent
WHERE StudentID = @notPickedStudent


/***********************************
***   StudentForm				***
***********************************/
UPDATE StudentForm
SET StudentID = @pickedStudent
WHERE
	StudentID = @notPickedStudent
		AND
	RosterYearID NOT IN ( select distinct RosterYearID from StudentForm where StudentID = @pickedStudent )
	
-- Purge the instance record and it will cascade upward
DELETE fi
FROM
	FormInstance fi join
	StudentForm sf on sf.Id= fi.Id
WHERE
	StudentID = @notPickedStudent


/***********************************
***   AcademicPlan				***
***********************************/
UPDATE AcademicPlan
SET StudentID = @pickedStudent
where 
	StudentID = @notPickedStudent
		AND
	RosterYearID NOT IN (SELECT RosterYearID FROM AcademicPlan WHERE StudentID = @pickedStudent)

DELETE AcademicPlan
WHERE
	StudentID = @notPickedStudent

/***********************************
***   PrgInvolvement			***
***********************************/
UPDATE PrgInvolvement
SET StudentID = @pickedStudent
WHERE StudentID = @notPickedStudent

/***********************************
***   ProbeTime				 	***
***********************************/
UPDATE ProbeTime
SET StudentID = @pickedStudent
WHERE StudentID = @notPickedStudent

/***********************************
***   PrgItem					 ***
***********************************/
UPDATE PrgItem
SET StudentID = @pickedStudent
WHERE StudentID = @notPickedStudent

--Merge Histories
--Bring over ONLY records that don't overlap with the existing history of the "picked" student
/***********************************
***   StudentSchoolHistory		 ***
***********************************/
INSERT INTO StudentSchoolHistory (StudentID, SchoolID, StartDate, EndDate)
SELECT
	distinct 
	@pickedStudent,
	histToss.SchoolID,	
	histToss.StartDate,
	histToss.EndDate
FROM
	StudentSchoolHistory histKeep left join
	StudentSchoolHistory histToss on dbo.DateRangesOverlap(histKeep.StartDate, histKeep.EndDate, histToss.StartDate, histToss.EndDate, null) = 0
WHERE
	histKeep.StudentID = @pickedStudent AND
	histToss.StudentID = @notPickedStudent AND
	histToss.StartDate NOT IN 
	(	
		select 
			histKeep.StartDate
		FROM
			StudentSchoolhistory histKeep join
			(
				SELECT
					StudentID  = @pickedStudent,
					dbo.GetCleanDate(StartDate) AS StartDate
				FROM
					StudentSchoolhistory
				WHERE
					StudentID = @notPickedStudent	
			) histToss on histKeep.StudentID = histToss.StudentID AND dbo.GetCleanDate(histKeep.StartDate) = histToss.StartDate
		WHERE
			histKeep.StudentID = @pickedStudent	
	)
	
-- Purge future orphans
DELETE StudentSchoolHistory
WHERE StudentID = @notPickedStudent


/***********************************
***   StudentSchool				 ***
***********************************/
UPDATE StudentSchool
SET StudentID = @pickedStudent
WHERE  StudentID = @notPickedStudent AND
RosterYearID NOT IN ( select RosterYearID from StudentSchool where studentID = @pickedStudent)

delete StudentSchool
WHERE StudentID = @notPickedStudent


/***********************************
***   StudentGradeLevelHistory	 ***
***********************************/
UPDATE StudentGradeLevelHistory
SET StudentID = @pickedStudent
WHERE  StudentID = @notPickedStudent AND
GradeLevelID NOT IN ( select distinct GradeLevelID from StudentGradeLevelHistory where studentID = @pickedStudent)
	
-- Purge future orphans
DELETE StudentGradeLevelHistory
WHERE StudentID = @notPickedStudent


/***********************************
***   StudentRosterYear  ***
***********************************/
UPDATE StudentRosterYear
SET StudentID  = @pickedStudent
WHERE StudentID = @notPickedStudent AND
RosterYearID NOT IN ( select RosterYearID from StudentRosterYear where studentID = @pickedStudent)

delete StudentRosterYear
WHERE StudentID = @notPickedStudent


/***********************************
***   StudentPhoto				 ***
***********************************/
UPDATE StudentPhoto
SET StudentID = @pickedStudent
WHERE  StudentID = @notPickedStudent AND
RosterYearID NOT IN ( select RosterYearID from StudentPhoto where studentID = @pickedStudent)

delete StudentPhoto
WHERE StudentID = @notPickedStudent


/***********************************
***   StudentTeacher			 ***
***********************************/
UPDATE StudentTeacher
SET StudentID = @pickedStudent
WHERE  StudentID = @notPickedStudent AND
TeacherID NOT IN ( select distinct TeacherID from StudentTeacher where studentID = @pickedStudent)

delete StudentTeacher
WHERE StudentID = @notPickedStudent


/***********************************
***   StudentTeacherClassRoster  ***
***********************************/
UPDATE StudentTeacherClassRoster
SET StudentID = @pickedStudent
WHERE  StudentID = @notPickedStudent AND
RosterYearID NOT IN ( select distinct RosterYearID from StudentTeacherClassRoster where studentID = @pickedStudent)

delete StudentTeacherClassRoster
WHERE StudentID = @notPickedStudent


/***********************************
***   StudentClassRosterHistory  ***
***********************************/
UPDATE StudentClassRosterHistory
SET StudentID = @pickedStudent
WHERE  StudentID = @notPickedStudent AND
ClassRosterID NOT IN ( select distinct ClassRosterID from StudentClassRosterHistory where studentID = @pickedStudent)

DELETE StudentClassRosterHistory
WHERE  StudentID = @notPickedStudent

UPDATE TestBindingStudent
SET StudentID = @pickedStudent
WHERE StudentID = @notPickedStudent
	AND
	BindingID NOT IN (
		SELECT bindingID from TestBindingStudent WHERE StudentID = @pickedStudent
	)
	
DELETE TestBindingStudent
WHERE  StudentID = @notPickedStudent



/***********************************
***			StudentRace			 ***
***********************************/
DELETE StudentRace
WHERE StudentID = @notPickedStudent



/***********************************
***   ServicePlan				 ***
***********************************/
UPDATE ServicePlan
SET StudentID = @pickedStudent
WHERE StudentID = @notPickedStudent

/***********************************
***   ServiceDeliveryStudent	 ***
***********************************/
UPDATE ServiceDeliveryStudent
SET StudentID = @pickedStudent
WHERE StudentID = @notPickedStudent

/***********************************
***	PrgItemIntent/PrgVersionIntent *
***********************************/
DELETE v
FROM PrgVersionIntent v JOIN PrgItemIntent i ON v.ItemIntentId = i.ID
WHERE i.StudentId = @notPickedStudent

DELETE PrgItemIntent
WHERE StudentId = @notPickedStudent

/***********************************
***	Attachment					   *
***********************************/
UPDATE Attachment
SET StudentID = @pickedStudent
WHERE StudentID = @notPickedStudent

DELETE Attachment
WHERE StudentId = @notPickedStudent


/***********************************
***	MedicaidAuthorization		   *
***********************************/
--Assign medicaid authorizations where they dont't overlap
UPDATE maNotPicked
SET StudentID = @pickedStudent
FROM
	MedicaidAuthorization maNotPicked left join
	MedicaidAuthorization maPicked on dbo.DateRangesOverlap(maNotPicked.StartDate, maNotPicked.EndDate, maPicked.StartDate, maPicked.EndDate, null) = 0
WHERE
	maNotPicked.StudentID = @notPickedStudent AND
	maPicked.StudentID = @pickedStudent

DELETE MedicaidAuthorization
WHERE StudentId = @notPickedStudent

UPDATE maNotPicked
SET StudentID = @pickedStudent
FROM
	MedicaidEligibilityHistory maNotPicked left join
	MedicaidEligibilityHistory maPicked on dbo.DateRangesOverlap(maNotPicked.StartDate, maNotPicked.EndDate, maPicked.StartDate, maPicked.EndDate, null) = 0
WHERE
	maNotPicked.StudentID = @notPickedStudent AND
	maPicked.StudentID = @pickedStudent

DELETE MedicaidEligibilityHistory
WHERE StudentId = @notPickedStudent

/***********************************
***	ProbeType					   *
***********************************/
UPDATE ProbeType
SET CustomForStudentID = @pickedStudent
WHERE CustomForStudentID = @notPickedStudent


/***********************************
***	StudentRecordTransfer   	   *
***********************************/
UPDATE StudentRecordTransfer
SET StudentID = @pickedStudent
WHERE StudentID = @notPickedStudent

set nocount on;
/***********************************
***	Test tables	                   *
***********************************/
-- declare @notPickedStudent uniqueidentifier, @victim varchar(36) ;  set @notPickedStudent = '441DFF46-EAA1-4AF0-B153-36F372E137F4'; set @victim = @notPickedStudent
declare @ttbl varchar(100), @tcol varchar(100)
declare T cursor for 
select TestTable = t.name, TestColumn = 'StudentID' -- , /* lt.DestTable, */ lt.MapTable
from (select o.name from sys.schemas s join sys.objects o on s.schema_id = o.schema_id join sys.columns c on o.object_id = c.object_id where s.name = 'dbo' and o.name like 'T[_]%' and c.name='StudentID' and o.type = 'U') t 
left join vc3etl.LoadTable lt on t.name = lt.DestTable 
union all
select lt.MapTable, 'DestID'
from (select o.name from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name like 'T[_]%' and o.type = 'U') t 
left join vc3etl.LoadTable lt on t.name = lt.DestTable 
where lt.MapTable is not null

open T
fetch T into @ttbl, @tcol
while @@FETCH_STATUS = 0
begin 

exec ('delete '+@ttbl+' where '+@tcol+' = '''+@victim+'''')

fetch T into @ttbl, @tcol
end
close T
deallocate T

/***********************************
***	StudentRecordException         *
***********************************/
delete StudentRecordException where Student1ID = @notPickedStudent or Student2ID = @notPickedStudent


set nocount off;
/***********************************
***	Delete Student	               *
***********************************/
delete Student where ID = @notPickedStudent
go

