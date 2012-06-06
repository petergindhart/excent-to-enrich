/*

This code is a work in progress.  Some code may be specific to certain environments or states, and as such, should be modified to use
"if exists" clauses where necessary.

*/

set nocount on; -- set nocount off;

begin tran

set xact_abort on

-- select * from Student where LastName = 'Student' and FirstName = 'sam'
-- declare @StudentID uniqueidentifier ; select @StudentID = ID from Student where LastName = 'Student' and FirstName = 'Sam'
-- select * from Student where ID = @StudentID
--select x.* from FormInstanceInterval x join PrgItemForm pif on x.InstanceId = pif.ID join PrgItem i on pif.ItemID = i.ID 


-- select * from student where lastname = 'student'

-- delete manually entered students from previous LEGACYSPED imports
delete ServicePlan where StudentID in (select DestID from LEGACYSPED.MAP_StudentRefID)
delete PrgItem where StudentID in (select DestID from LEGACYSPED.MAP_StudentRefID)
delete PrgInvolvement where StudentID in (select DestID from LEGACYSPED.MAP_StudentRefID)
delete PrgVersionIntent where ItemIntentId in (select ID from PrgItemIntent where StudentID in (select DestID from LEGACYSPED.MAP_StudentRefID))
delete PrgItemIntent where StudentID in (select DestID from LEGACYSPED.MAP_StudentRefID)
delete T_FCAT_ReadingAndMath where StudentID in (select DestID from LEGACYSPED.MAP_StudentRefID)
delete T_FL_Alt where StudentID in (select DestID from LEGACYSPED.MAP_StudentRefID)
delete StudentRosterYear where StudentID in (select DestID from LEGACYSPED.MAP_StudentRefID)
delete StudentClassRosterHistory where StudentID in (select DestID from LEGACYSPED.MAP_StudentRefID)
delete StudentGradeLevelHistory where StudentID in (select DestID from LEGACYSPED.MAP_StudentRefID)
delete Student where ID in (select DestID from LEGACYSPED.MAP_StudentRefID)

declare @zg uniqueidentifier ; select @zg = '00000000-0000-0000-0000-000000000000'

declare @SaveStudents table (StudentID uniqueidentifier null, OldNumber varchar(50) not null, OldFirstname varchar(50) not null, OldLastname varchar(50) not null, NewNumber varchar(50), NewFirstname varchar(50) not null, NewLastname varchar(50) not null) ; 
-- insert @SaveStudents (OldNumber, OldLastname, OldFirstname, NewNumber, NewLastname, NewFirstname) values ('3632271715', 'Ceotto', 'Sara', '0000000001', 'Student', 'Samantha')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('3384C724-6449-411E-9A9A-45EDAE354F9F', '', '', '', '', 'Sam', 'Student')


-- delete sample student guardians from the mapping table
delete m from EFF.Map_StudentGuardianID m join EFF.StudentGuardians g on m.ID = g.GuardianID join @SaveStudents s on g.StudentID = s.OldNumber ; print 'Delete Guardian ID from MAP table : ' + convert(varchar(10), @@rowcount)

select * from @SaveStudents -- test it

delete x from Attachment x left join PrgItem i on x.ItemID = i.ID where x.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) and i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'Attachment : ' + convert(varchar(10), @@rowcount)
delete x from PrgDocument x join PrgItem i on x.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgDocument : ' + convert(varchar(10), @@rowcount)

delete x from IepDisabilityEligibility x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID  where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepDisabilityEligibility : ' + convert(varchar(10), @@rowcount)
delete x from IepGoal x join PrgGoal g on x.ID = g.ID join PrgSection ps on g.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID  where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepGoal : ' + convert(varchar(10), @@rowcount)
delete x from IepGoalArea x join PrgGoals gs on x.InstanceID = gs.ID join PrgSection ps on gs.ID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents)  ; print 'IepGoalArea : ' + convert(varchar(10), @@rowcount)

delete x from IepJustification x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepJustification : ' + convert(varchar(10), @@rowcount)
delete x from IepPostSchoolArea x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepPostSchoolArea : ' + convert(varchar(10), @@rowcount)
delete x from IepSpecialFactor x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepSpecialFactor : ' + convert(varchar(10), @@rowcount)
delete x from IepTestAccom x join IepAccommodation ia on x.AccommodationID = ia.ID join IepAccommodationCategory iac on ia.CategoryID = iac.ID join PrgSection ps on ia.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepTestAccom : ' + convert(varchar(10), @@rowcount)
delete x from IntvGoal x join PrgItem i on x.InterventionID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IntvGoal : ' + convert(varchar(10), @@rowcount)

-- delete x from MosRelatedService x join PrgMatrixOfServices pms on x.MatrixOfServicesID = pms.ID join PrgItem i on pms.ID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'MosRelatedService : ' + convert(varchar(10), @@rowcount)
delete x from PrgActivity x join PrgItem i on x.ID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivity : ' + convert(varchar(10), @@rowcount)
delete x from PrgActivitySchedule x join PrgItem i on x.ItemId = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivitySchedule : ' + convert(varchar(10), @@rowcount)
delete x from PrgGoal x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemId = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'Attachment : ' + convert(varchar(10), @@rowcount)
delete x from PrgInterventionSubVariant x join PrgItem i on x.InterventionID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgInterventionSubVariant : ' + convert(varchar(10), @@rowcount)

delete x from PrgItemRel x join PrgItem i on x.InitiatingItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgItemRel : ' + convert(varchar(10), @@rowcount)
delete x from PrgItemTeamMember x join PrgItem i on x.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents)  ; print 'PrgItemTeamMember : ' + convert(varchar(10), @@rowcount)
-- delete x from PrgMatrixOfServices x join PrgItem i on x.ID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgMatrixOfServices : ' + convert(varchar(10), @@rowcount)
delete x from PrgMilestone x join PrgItem i on x.StartingItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgMilestone : ' + convert(varchar(10), @@rowcount)

delete x from PrgActivityBatch x join PrgItem i on x.ID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivityBatch : ' + convert(varchar(10), @@rowcount)
delete x from MedicaidExtractIssue x join ServiceDeliveryStudent y on y.ID = x.ServiceDeliveryStudentID where y.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'MedicaidExtractIssue : ' + convert(varchar(10), @@rowcount)
delete x from ServiceDeliveryStudent x where x.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ServiceDeliveryStudent : ' + convert(varchar(10), @@rowcount)

delete x from ServicePlanDiagnosisCode x join ServicePlan y on x.PlanID = y.ID where y.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ServicePlanDiagnosisCode : ' + convert(varchar(10), @@rowcount)

delete x from IepServicePlan x join ServicePlan sp on x.ID = sp.ID where sp.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepServicePlan : ' + convert(varchar(10), @@rowcount)
delete x from ServicePlan x where x.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ServicePlan : ' + convert(varchar(10), @@rowcount)

delete x from PrgSection x join PrgItem i on x.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgSection : ' + convert(varchar(10), @@rowcount)

delete x from IepDisability x where deleteddate is not null  ; print 'IepDisability : ' + convert(varchar(10), @@rowcount) -- maintained by config import
delete x from IepPlacementOption x where DeletedDate is not null  ; print 'IepPlacementOption : ' + convert(varchar(10), @@rowcount)-- maintained by config import


-- set nocount off;
delete x from ServiceSchedule x where ID not in (select z.ID from ServiceSchedule z join ServiceScheduleServicePlan sssp on z.ID = sssp.ScheduleID join ServicePlan sp on sssp.ServicePlanID = sp.ID  where sp.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) )  ; print 'ServiceSchedule : ' + convert(varchar(10), @@rowcount)-- ??
delete x from ServiceSchedule x where ID not in (select z.ID from ServiceSchedule z join PrgLocation pl on z.LocationID = pl.ID where pl.DeletedDate is not null) ; print 'ServiceSchedule (for PrgLocation) : ' + convert(varchar(10), @@rowcount)-- ??
delete x from Schedule x where ID not in (select ID from ServiceSchedule) ; print 'Schedule : ' + convert(varchar(10), @@rowcount)-- ??

-- delete x from Schedule x 

delete PrgLocation where DeletedDate is not null ; print 'PrgLocation : ' + convert(varchar(10), @@rowcount) -- is there any benefit in attempting to delete Legacy data?
delete ServiceFrequency where DeletedDate is not null  /* Sequence = 99 */ ; print 'ServiceFrequency : ' + convert(varchar(10), @@rowcount) -- is there any benefit in attempting to delete Legacy data?
delete t from ServiceProviderTitle t where t.DeletedDate is not null and t.ID not in (select distinct p.ProviderTitleID from UserProfile p where p.ProviderTitleID is not null) ; print 'ServiceProviderTitle : ' + convert(varchar(10), @@rowcount) -- is there any benefit in attempting to delete Legacy data?

--delete s from Student s join LEGACYSPED.MAP_StudentRefID m on m.DestID = s.ID where m.LegacyData = 1 ; print 'Student : ' + convert(varchar(10), @@rowcount) -- s.ManuallyEntered = 1 -- is there any benefit in attempting to delete Legacy data?

delete x from ServiceDef sd join IepServiceDef x on sd.ID = x.ID where sd.DeletedDate is not null ; print 'IepServiceDef : ' + convert(varchar(10), @@rowcount) 
delete x from ServiceDef sd join UserProfileServiceDefPermission x on sd.ID = x.ServiceDefID where sd.DeletedDate is not null ; print 'UserProfileServiceDefPermission : ' + convert(varchar(10), @@rowcount) 
delete ServiceDef where DeletedDate is not null ; print 'ServiceDef : ' + convert(varchar(10), @@rowcount) 

/*


Msg 547, Level 16, State 0, Line 80
The DELETE statement conflicted with the REFERENCE constraint "FK_UserProfile#ServiceProviderTitle#Users". 
	The conflict occurred in database "Enrich_DC3_FL_Polk", table "dbo.UserProfile", column 'ProviderTitleID'.



Msg 547, Level 16, State 0, Line 72
The DELETE statement conflicted with the REFERENCE constraint "FK_ServiceSchedule#Location#ServiceSchedules". The conflict occurred in database "Enrich_DC7_FL_Lee", table "dbo.ServiceSchedule", column 'LocationID'.
Msg 3902, Level 16, State 1, Line 7
The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION.

select * from serviceschedule


Msg 547, Level 16, State 0, Line 79
The DELETE statement conflicted with the REFERENCE constraint "FK_IepServiceDef_ServiceDef". The conflict occurred in database "Enrich_DC7_FL_Lee", table "dbo.IepServiceDef", column 'ID'.
Msg 3902, Level 16, State 1, Line 7
The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION.

Msg 547, Level 16, State 0, Line 80
The DELETE statement conflicted with the REFERENCE constraint "FK_UserProfileServiceDefPermission#ServiceDef#". The conflict occurred in database "Enrich_DC7_FL_Lee", table "dbo.UserProfileServiceDefPermission", column 'ServiceDefID'.
Msg 3902, Level 16, State 1, Line 7
The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION.

select * from UserProfileServiceDefPermission



*/

-- moved PrgInvolvement
-- delete PrgItemTeamMember ; print 'PrgItemTeamMember : ' + convert(varchar(10), @@rowcount) -- ?.												Duplicate
delete x from Schedule x left join (
	select g.ID, g.ProbeScheduleID, i.StudentID
	from PrgGoal g join 
		PrgSection ps on g.InstanceID = ps.ID join 
		PrgItem i on ps.ItemID = i.ID 
	) g on x.ID = g.ProbeScheduleID left join (
	select sp.ID ServicePlanID, ss.ID ServiceScheduleID, sp.StudentID
	from ServiceSchedule ss join
		ServiceScheduleServicePlan sssp on ss.ID = sssp.ScheduleID join 
		ServicePlan sp on sssp.ServicePlanID = sp.ID
	) v on x.ID = v.ServiceScheduleID
where not (v.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) or g.StudentID in (select isnull(StudentID, @zg) from @SaveStudents)) ; print 'Schedule : ' + convert(varchar(10), @@rowcount) -- ?

delete x from MedicaidCertification x ; print 'MedicaidCertification : ' + convert(varchar(10), @@rowcount)

delete x from ServiceDelivery x join ServiceDeliveryStudent sds on x.ID = sds.DeliveryID where sds.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ServiceDelivery : ' + convert(varchar(10), @@rowcount)
delete x from PrgVersionIntent x join PrgItemIntent i on x.ItemIntentId = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents); print 'PrgVersionIntent : ' + convert(varchar(10), @@rowcount)
delete x from PrgItemIntent x where x.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgItemIntent : ' + convert(varchar(10), @@rowcount)

delete x from ProbeScore x join ProbeTime t on x.ProbeTimeID = t.ID  where t.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ProbeScore : ' + convert(varchar(10), @@rowcount)
delete x from ProbeTime x where x.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ProbeTime : ' + convert(varchar(10), @@rowcount)

delete x from PrgGoalProgress x join PrgGoal g on x.GoalID = g.ID join PrgSection ps on g.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgGoalProgress : ' + convert(varchar(10), @@rowcount)
delete x from FormInstanceBatch x join FormInstance fi on x.Id = fi.FormInstanceBatchId join StudentForm sf on fi.Id = sf.Id where sf.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'FormInstanceBatch : ' + convert(varchar(10), @@rowcount)
-- ??
delete x from FormInstanceBatchRule x ; print 'FormInstanceBatchRule : ' + convert(varchar(10), @@rowcount)
delete x from FormInstanceInterval x join PrgItemForm pif on x.InstanceId = pif.ID join PrgItem i on pif.ItemID = i.ID where i.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents)  ; print 'FormInstanceInterval : ' + convert(varchar(10), @@rowcount)

delete x from StudentFormInstanceBatch x join FormInstance fi on x.id = fi.FormInstanceBatchID join StudentForm sf on fi.ID = sf.ID where sf.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'StudentFormInstanceBatch : ' + convert(varchar(10), @@rowcount)

delete x from PrgSection x join PrgItem y on y.ID = x.ItemID where y.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgSection : ' + convert(varchar(10), @@rowcount)

delete x from FormInstance x join PrgItemForm pif on x.Id = pif.ID join PrgItem i on pif.ItemID = i.ID where i.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'FormInstance : ' + convert(varchar(10), @@rowcount)
-- assume PrgItemForm, a subclass of FormInstance, is cascade deleted

delete x from PrgActivitySchedule x join PrgItem y on y.ID = x.ItemId where y.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivitySchedule : ' + convert(varchar(10), @@rowcount)

delete x from PrgActivitySchedule x join IntvTool y on y.ID = x.ToolID join PrgItem z on z.ID = y.InterventionID where z.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivitySchedule : ' + convert(varchar(10), @@rowcount)

delete x from IntvTool x join PrgItem y on y.ID = x.InterventionID where y.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivitySchedule : ' + convert(varchar(10), @@rowcount)

-- moved this commented line here because there was an FK error on InitiatingIepID.  Not sure why it was commented out previously
delete x from PrgMatrixOfServices x join PrgItem i on x.ID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgMatrixOfServices : ' + convert(varchar(10), @@rowcount)
-- moved prgitem here because other deletion queries depend on it
delete x from PrgItem x where x.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgItem : ' + convert(varchar(10), @@rowcount)
delete x from PrgInvolvement x where x.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgInvolvement : ' + convert(varchar(10), @@rowcount)

delete PrgStatus where DeletedDate is not null and Sequence = 99 and IsExit = 1 ; print 'PrgStatus : ' + convert(varchar(10), @@rowcount) 


-- select * from MosRatingDef m 

--51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7

--select * 
--from IepGoalAreaDef d left join 
--MosRatingDef m on d.ID = m.IepGoalAreaDefID 
--where DeletedDate is not null and d.Sequence = 99

--set nocount off;
--begin tran test2
delete x from MosRatingDef x join IepGoalAreaDef d on x.IepGoalAreaDefID = x.ID where d.DeletedDate is not null and d.Sequence = 99

delete x from IepGoalAreaDef x where x.DeletedDate is not null and x.Sequence = 99 -- IN FLA DO NOT DELETE under Sequence 99!!!

--rollback tran test2

-- delete x from AuditLogEntry x ; print 'AuditLogEntry : ' + convert(varchar(10), @@rowcount) --- ?? do not understand this table.  -- select * from AuditLogEntry
-- delete Person where TypeID = 'P' and ManuallyEntered = 1 ; print 'Attachment : ' + convert(varchar(10), @@rowcount) -- ?


-- select * from PrgVersionIntent
-- select * from VC3Deployment.Version

-- delete duplicate schools imported previously

delete pts
-- select pts.*
from (select Number from School where deleteddate is null group by Number having COUNT(*) > 1) n
join School h on n.Number = h.Number and h.ManuallyEntered = 1 
join ProbeTypeSchool pts on h.ID = pts.SchoolID ; print 'ProbeTypeSchool : ' + convert(varchar(10), @@rowcount) 

delete h
-- select h.*
from (select Number from School where deleteddate is null group by Number having COUNT(*) > 1) n
join School h on n.Number = h.Number and h.ManuallyEntered = 1 ; print 'School : ' + convert(varchar(10), @@rowcount)

-- delete soft-deleted schools
delete pts
-- select pts.*
from (select Number from School where deleteddate is not null ) n
join School h on n.Number = h.Number and h.ManuallyEntered = 1 
join ProbeTypeSchool pts on h.ID = pts.SchoolID ; print 'ProbeTypeSchool : ' + convert(varchar(10), @@rowcount) 

delete x
-- select *
from (select Number from School where deleteddate is not null) n
join School h on n.Number = h.Number and h.ManuallyEntered = 1 join
Student x on h.ID = x.CurrentSchoolID and x.ManuallyEntered = 1


delete h
-- select h.*
from (select Number from School where deleteddate is not null) n
join School h on n.Number = h.Number and h.ManuallyEntered = 1 and h.ID not in (select SchoolID from dbo.T_FCAT_ReadingAndMath) ; print 'School : ' + convert(varchar(10), @@rowcount)

/*

Msg 547, Level 16, State 0, Line 222
The DELETE statement conflicted with the REFERENCE constraint "FK_T_FCAT_ReadingAndMath_SchoolID". 
	The conflict occurred in database "Enrich_DC3_FL_Polk", table "dbo.T_FCAT_ReadingAndMath", column 'SchoolID'.
Msg 3902, Level 16, State 1, Line 7
The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION.

*/

-- delete duplicate student records 
delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentRecordException x on s.ID = x.Student2ID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null ; print 'StudentRecordException : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentTeacherClassRoster x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null  ; print 'StudentTeacherClassRoster : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentRosterYear x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null  ; print 'StudentRosterYear : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
TranscriptCourse x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null  ; print 'TranscriptCourse : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
DisciplineIncident x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null  ; print 'DisciplineIncident : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentClassRosterHistory x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null  ; print 'StudentClassRosterHistory : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentGradeLevelHistory x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.StudentID is null  ; print 'StudentGradeLevelHistory : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentSchoolHistory x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.StudentID is null  ; print 'StudentSchoolHistory : ' + convert(varchar(10), @@rowcount)

-- the from and where clauses must match for the next 2 queries
delete sgs
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentGroupStudent sgs on s.ID = sgs.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.StudentID is null ; print 'StudentGroupStudent by Number : ' + convert(varchar(10), @@rowcount)

delete s
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 left join
@SaveStudents z on s.ID = z.StudentID ; print 'Student by Number : ' + convert(varchar(10), @@rowcount)

-- the from and where clauses must match for the next 2 queries
delete sgs
from (select FirstName, LastName, DOB from Student where IsActive = 1 group by FirstName, LastName, DOB having COUNT(*) > 1 ) fld join 
Student s on fld.FirstName = s.FirstName and fld.LastName = s.LastName and fld.DOB = s.DOB and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentGroupStudent sgs on s.ID = sgs.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null ; print 'StudentGroupStudent by Last, First, DOB : ' + convert(varchar(10), @@rowcount)

delete s
-- select s.ManuallyEntered, s.*
from (select FirstName, LastName, DOB from Student where IsActive = 1 group by FirstName, LastName, DOB having COUNT(*) > 1 ) fld join 
Student s on fld.FirstName = s.FirstName and fld.LastName = s.LastName and fld.DOB = s.DOB and s.ManuallyEntered = 1 and s.IsActive = 1 left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null and
s.ID not in (select Student2ID from StudentRecordException) ; print 'Student by Last, First, DOB : ' + convert(varchar(10), @@rowcount)


--ContentAreaRequirement

--select distinct g.*
--from ContentAreaRequirement c join 
--GradeLevel g on c.MinGradeID = g.ID



delete g
from GradeLevel g left join 
Student s on g.ID = s.CurrentGradeLevelID left join
IepStandard t on g.ID = t.MinGradeID left join 
ContentAreaRequirement c on g.ID = c.MinGradeID 
where Active = 0
and s.ID is null
and t.ID is null
and c.Id is null



-- break the association between the mosratingdef and iepgoalareas that will be deleted.  is this okay?
update dbo.MosRatingDef set IepGoalAreaDefID = NULL where IepGoalAreaDefID in (select ID from dbo.IepGoalAreaDef where DeletedDate is not null ) -- is this okay?
delete dbo.IepGoalAreaDef where DeletedDate is not null -- 



-- clean out map table records if no dest rec

-- drop all of the data conversion objects in preparation for a fresh import

declare @d varchar(254) 
declare D cursor for 
select 
	'drop '+
	case o.Type when 'U' then 'table ' when 'V' then 'view ' when 'P' then 'proc ' else NULL end+
	s.name+'.'+o.name 
from sys.schemas s join
sys.objects o on s.schema_id = o.schema_id
where s.name in ('AURORAX')
-- and (o.type in ('V', 'P') or o.Type = 'U' and o.name like 'MAP_%')
and o.type in ('V', 'P', 'U') 
order by s.name, case o.Type when 'P' then 0 when 'V' then 1 when 'U' then 2 end

open D
fetch D into @d
while @@fetch_status = 0
begin

exec (@d)

fetch D into @d
end 
close D
deallocate D

delete VC3Deployment.Version where Module in ('AURORAX')
delete VC3Deployment.ModuleDependency where Uses in ('AURORAX')
delete VC3Deployment.Module where ID in ('AURORAX')


if exists (select 1 from sys.schemas where name = 'AURORAX')
drop schema AURORAX
go

--if exists (select 1 from sys.schemas where name = 'LEGACYSPED')
--drop schema LEGACYSPED
--go


commit tran
--rollback tran

-- select * from PrgSection
-- select * from IEPDisability


-- delete orphaned map table records (mostly for lookups) -- select * from LEGACYSPED.MAP_IepRefID

if exists (select 1 from sys.schemas where name = 'LEGACYSPED')
begin

print 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX DELETING LEGACYSPED XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'





delete x -- select *
from LEGACYSPED.MAP_IepRefID x -- map
where DestID not in (select ID from PrgItem) -- destination
print 'LEGACYSPED.MAP_IepRefID : ' +convert(varchar(10), @@rowcount)

if exists (select 1 from sys.objects where name = 'LEGACYSPED.MAP_PrgSectionID_NonVersioned')
begin
delete x -- select *
from LEGACYSPED.MAP_PrgSectionID_NonVersioned x -- map
where DestID not in (select ID from PrgSection) -- destination
print 'LEGACYSPED.MAP_PrgSectionID_NonVersioned : ' +convert(varchar(10), @@rowcount)
end

delete x -- select *
from LEGACYSPED.MAP_OrgUnitID x -- map
where DestID not in (select ID from OrgUnit) -- destination
print 'LEGACYSPED.MAP_OrgUnitID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_StudentRefID s join
dbo.Student x on s.DestID = x.ID 
where x.ManuallyEntered = 1
print 'dbo.Student (manually entered) : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_StudentRefID x -- map
--where DestID not in (select ID from Student) -- destination ------------------------------ we want all of them gone.  what about their manually added student records?
print 'LEGACYSPED.MAP_StudentRefID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_PrgVersionID x -- map
where DestID not in (select ID from PrgVersion) -- destination
print 'LEGACYSPED.MAP_PrgVersionID : ' +convert(varchar(10), @@rowcount)

-- new
if exists (select 1 from sys.objects where name = 'LEGACYSPED.MAP_IepGoalAreaDefID' and type = 'U')
begin
delete x -- select *
from LEGACYSPED.MAP_IepGoalAreaDefID x -- map
where DestID not in (select ID from PrgGoal) -- destination
print 'LEGACYSPED.MAP_IepGoalAreaDefID : ' +convert(varchar(10), @@rowcount)
end

delete x -- select *
from LEGACYSPED.MAP_PrgGoalID x -- map
where DestID not in (select ID from PrgGoal) -- destination
print 'LEGACYSPED.MAP_PrgGoalID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_IepPlacementID x -- map
where DestID not in (select ID from IepPlacement) -- destination
print 'LEGACYSPED.MAP_IepPlacementID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_ServiceProviderTitleID x -- map
where DestID not in (select ID from ServiceProviderTitle) -- destination
print 'LEGACYSPED.MAP_ServiceProviderTitleID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_ScheduleID x -- map
where DestID not in (select ID from Schedule) -- destination
print 'LEGACYSPED.MAP_ScheduleID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_ServicePlanID x -- map
where DestID not in (select ID from ServicePlan) -- destination
print 'LEGACYSPED.MAP_ServicePlanID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_IepDisabilityEligibilityID  x -- map
where DestID not in (select ID from IepDisabilityEligibility) -- destination
print 'LEGACYSPED.MAP_IepDisabilityEligibilityID  : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_PrgLocationID x -- map
where DestID not in (select ID from PrgLocation) -- destination
print 'LEGACYSPED.MAP_PrgLocationID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_IepDisabilityID x -- map
where DestID not in (select ID from IepDisability) -- destination
print 'LEGACYSPED.MAP_IepDisabilityID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_GradeLevelID x -- map
where DestID not in (select ID from GradeLevel) -- destination
print 'LEGACYSPED.MAP_GradeLevelID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_ServiceFrequencyID x -- map
where DestID not in (select ID from ServiceFrequency) -- destination
print 'LEGACYSPED.MAP_ServiceFrequencyID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_IepServiceCategoryID x -- map
where DestID not in (select ID from IepServiceCategory) -- destination
print 'LEGACYSPED.MAP_IepServiceCategoryID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_PrgInvolvementID x -- map
where DestID not in (select ID from PrgInvolvement) -- destination
print 'LEGACYSPED.MAP_PrgInvolvementID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_IepGoalArea x -- map
where DestID not in (select ID from IepGoalArea) -- destination
print 'LEGACYSPED.MAP_IepGoalArea : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_SchoolID x -- map
where DestID not in (select ID from School) -- destination
print 'LEGACYSPED.MAP_SchoolID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_PrgGoalObjectiveID x -- map
where DestID not in (select ID from PrgGoal) -- destination
print 'LEGACYSPED.MAP_PrgGoalObjectiveID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_PrgSectionID x -- map
where DestID not in (select ID from PrgSection) -- destination
print 'LEGACYSPED.MAP_PrgSectionID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_ServiceDefID x -- map
where DestID not in (select ID from ServiceDef) -- destination
print 'LEGACYSPED.MAP_ServiceDefID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_IepPlacementOptionID x -- map
where DestID not in (select ID from IepPlacementOption) -- destination
print 'LEGACYSPED.MAP_IepPlacementOptionID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from LEGACYSPED.MAP_PrgStatusID x -- map
where DestID not in (select ID from PrgStatus) -- destination
print 'LEGACYSPED.MAP_PrgStatusID : ' +convert(varchar(10), @@rowcount)

if exists (select 1 from sys.objects where name = 'LEGACYSPED.Lookups')
begin
drop view LEGACYSPED.Lookups
drop table LEGACYSPED.Lookups_LOCAL
end

-- truncate all of the legacysped tables
declare @d varchar(254) 
declare D cursor for 
select 'truncate table '+s.name+'.'+o.name 
from sys.schemas s join
sys.objects o on s.schema_id = o.schema_id
where s.name in ('LEGACYSPED')
and o.type in ('U') 
order by s.name, case o.Type when 'P' then 0 when 'V' then 1 when 'U' then 2 end

open D
fetch D into @d
while @@fetch_status = 0
begin

exec (@d)
-- print @d

fetch D into @d
end 
close D
deallocate D



end


-- fail orphaned data import tasks
update t set StatusID = 'F'
-- select * 
from VC3TaskScheduler.ScheduledTask t
where TaskTypeID = 'F03A0C51-7294-4B57-AFB7-AFF136E4025F' 
and (isnull(StatusID,'P') in ('P', 'R'))


delete t
-- select * 
from VC3TaskScheduler.ScheduledTask t
where TaskTypeID = 'F03A0C51-7294-4B57-AFB7-AFF136E4025F' -- order by starttime desc
and StartTime is null

-- select * from VC3TaskScheduler.ScheduledTaskSchedule s where s.TaskTypeID = 'F03A0C51-7294-4B57-AFB7-AFF136E4025F'


--drop view LEGACYSPED.District
--drop view LEGACYSPED.School
--if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id and s.name = 'LEGACYSPED' and o.name = 'Lookups')
--drop view LEGACYSPED.Lookups
--drop view LEGACYSPED.Student
--drop view LEGACYSPED.IEP
--drop view LEGACYSPED.Objective
--drop view LEGACYSPED.Goal
--drop view LEGACYSPED.Service
--drop view LEGACYSPED.TeamMember
--drop view LEGACYSPED.SpedStaffMember


--drop table LEGACYSPED.District_LOCAL
--drop table LEGACYSPED.School_LOCAL
--if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id and s.name = 'LEGACYSPED' and o.name = 'Lookups_LOCAL')
--drop table LEGACYSPED.Lookups_LOCAL
--drop table LEGACYSPED.Student_LOCAL
--drop table LEGACYSPED.IEP_LOCAL
--drop table LEGACYSPED.Objective_LOCAL
--drop table LEGACYSPED.Goal_LOCAL
--drop table LEGACYSPED.Service_LOCAL
--drop table LEGACYSPED.TeamMember_LOCAL
--drop table LEGACYSPED.SpedStaffMember_LOCAL

--drop table LEGACYSPED.MAP_OrgUnitID
--drop table LEGACYSPED.MAP_SchoolID
--drop view LEGACYSPED.MAP_SpedStaffMemberView


declare @o varchar(100), @ut char(1), @n varchar(5), @q varchar(max); select @n = '
'
declare O cursor for 
select o.name, o.type from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.type in ('U', 'V') order by o.type desc, o.name

open O
fetch O into @o, @ut

while @@fetch_status = 0
begin

set @q = 'if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = ''LEGACYSPED'' and o.name = '''+@o+''')
drop '+case when @ut = 'V' then 'view ' else 'table ' end+ 'LEGACYSPED.'+ @o+@n+@n

exec (@q)

fetch O into @o, @ut
end
close O
deallocate O


delete v
-- select * 
from VC3Deployment.Version v
where Module = 'LEGACYSPED' 
	and scriptnumber > 0
	
UPDATE SystemSettings SET SecurityRebuiltDate = NULL




/*

Delete Guardian ID from MAP table : 0
Attachment : 0
PrgDocument : 0
IepDisabilityEligibility : 0
IepGoal : 0
IepGoalArea : 0
IepJustification : 0
IepPostSchoolArea : 0
IepSpecialFactor : 0
IepTestAccom : 0
IntvGoal : 0
PrgActivity : 0
PrgActivitySchedule : 0
Attachment : 0
PrgInterventionSubVariant : 0
PrgItemRel : 0
PrgItemTeamMember : 0
PrgMilestone : 0
PrgActivityBatch : 0
MedicaidExtractIssue : 0
ServiceDeliveryStudent : 0
ServicePlanDiagnosisCode : 0
IepServicePlan : 0
ServicePlan : 0
PrgSection : 0
IepDisability : 0
IepPlacementOption : 0
ServiceSchedule : 18481
ServiceSchedule (for PrgLocation) : 0
Schedule : 18535
PrgLocation : 1
ServiceFrequency : 0
ServiceProviderTitle : 0
IepServiceDef : 2
UserProfileServiceDefPermission : 0
ServiceDef : 2
Schedule : 0
MedicaidCertification : 0
ServiceDelivery : 0
PrgVersionIntent : 0
PrgItemIntent : 0
ProbeScore : 0
ProbeTime : 0
PrgGoalProgress : 0
FormInstanceBatch : 0
FormInstanceBatchRule : 0
FormInstanceInterval : 0
StudentFormInstanceBatch : 0
PrgSection : 0
FormInstance : 0
PrgActivitySchedule : 0
PrgActivitySchedule : 0
PrgActivitySchedule : 0
PrgMatrixOfServices : 0
PrgItem : 0
PrgInvolvement : 0
PrgStatus : 14
ProbeTypeSchool : 0
School : 0
ProbeTypeSchool : 12
School : 5
StudentRecordException : 0
StudentTeacherClassRoster : 0
StudentRosterYear : 0
TranscriptCourse : 0
DisciplineIncident : 0
StudentClassRosterHistory : 0
StudentGradeLevelHistory : 0
StudentSchoolHistory : 0
StudentGroupStudent by Number : 0
Student by Number : 0
StudentGroupStudent by Last, First, DOB : 0
Student by Last, First, DOB : 0
Msg 547, Level 16, State 0, Line 370
The DELETE statement conflicted with the REFERENCE constraint "FK_MosRatingDef#IepGoalAreaDef#". The conflict occurred in database "Enrich_DC5_CO_Poudre", table "dbo.MosRatingDef", column 'IepGoalAreaDefID'.
Msg 3902, Level 16, State 1, Line 7
The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION.




*/



