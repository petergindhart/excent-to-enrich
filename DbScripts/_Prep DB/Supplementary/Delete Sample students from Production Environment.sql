Begin tran delStud

declare @zg uniqueidentifier ; select @zg = '00000000-0000-0000-0000-000000000000'

declare @SaveStudents table (StudentID uniqueidentifier null, OldNumber varchar(50) not null, OldFirstname varchar(50) not null, OldLastname varchar(50) not null, NewNumber varchar(50), NewFirstname varchar(50) not null, NewLastname varchar(50) not null) ; 
-- insert @SaveStudents (OldNumber, OldLastname, OldFirstname, NewNumber, NewLastname, NewFirstname) values ('3632271715', 'Ceotto', 'Sara', '0000000001', 'Student', 'Samantha')
-- select 'insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('''+convert(varchar(36), ID)+''', '''', '''', '''', '''', '''+FirstName+''', '''+LastName+''')' from Student where LastName = 'Sample'
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('4424BD98-0022-45FB-BDD5-E2B4F4E3CAF9', '', '', '', '', 'Early Childhood', 'Sample')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('0B75426F-8DA0-41F3-A504-97ABDAC03B5F', '', '', '', '', 'School Age', 'Sample')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('9DA82836-6E53-44CB-B764-FBC10CC9236F', '', '', '', '', 'Shelly', 'Sample')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('79FE1005-228D-4925-8ED9-6F99B1AA0602', '', '', '', '', 'Transition Age', 'Sample')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('D1390550-E3B3-4BB2-8FAC-13348C01CA56', '', '', '', '', 'Status', 'Sample')


-- select 'insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('''+convert(varchar(36), ID)+''', '''', '''', '''', '''', '''+FirstName+''', '''+LastName+''')' from Student where LastName = 'RtI'
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('5A65F8FD-C7A5-421A-9F0B-0493E7FB5385', '', '', '', '', 'Student1', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('0EDADF0B-6CC8-40BA-AB98-D6025BD65C61', '', '', '', '', 'Student2', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('A2A1F6FD-359C-4080-B6AE-12960F918585', '', '', '', '', 'Student3', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('66372922-0819-4B78-AF76-E23ED467CD58', '', '', '', '', 'Student4', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('6AF83FD1-9022-4A5A-A048-A596BC37DB73', '', '', '', '', 'Student5', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('69B8893B-1F3C-4689-931C-3521F6682377', '', '', '', '', 'Student6', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('2F9B39F2-3ED2-475C-8175-F2A427B8E91B', '', '', '', '', 'Student7', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('A5760B31-687F-48C8-B711-253B45E2B161', '', '', '', '', 'Student8', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('6C4FFBC4-8322-4D9D-82EE-D4643865F3E4', '', '', '', '', 'Student9', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('9499CA51-AFA8-4713-AF34-84CD36BD715D', '', '', '', '', 'Student10', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('74A439C4-E236-432A-ADDC-41B2BF7E4113', '', '', '', '', 'Student11', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('3E2253FD-9750-4F4D-891B-75E497B218B7', '', '', '', '', 'Student12', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('79C59142-2BE8-4D0A-8830-DD79C08A18D8', '', '', '', '', 'Student13', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('2456EBE0-A7BC-4238-A24C-C5C95E18CA97', '', '', '', '', 'Student14', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('C542F1C9-5C09-4866-B715-02DBE310E4C2', '', '', '', '', 'Student15', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('E2FE8019-C50D-4E52-9952-476F74430A44', '', '', '', '', 'Student16', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('E191093C-46DE-4A19-9029-30D5EC945546', '', '', '', '', 'Student17', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('E9324BD7-4733-4617-8B87-1D509786906F', '', '', '', '', 'Student18', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('3BAF0A76-1A51-4E6B-8741-49799C7958F2', '', '', '', '', 'Student19', 'Rti')
insert @SaveStudents (StudentID, OldNumber, OldFirstname, OldLastname, NewNumber, NewFirstname, NewLastname) values ('4F075DE6-ADA4-443E-87D8-3DCD0ECD3C63', '', '', '', '', 'Student20', 'Rti')

-- show students to be preserved.
select isnull(StudentID, @zg) from @SaveStudents


-- delete sample student guardians from the mapping table
delete m from EFF.Map_StudentGuardianID m join EFF.StudentGuardians g on m.ID = g.GuardianID join @SaveStudents s on g.StudentID = s.OldNumber ; print 'Delete Guardian ID from MAP table : ' + convert(varchar(10), @@rowcount)

--select * from @SaveStudents -- test it

delete x from Attachment x left join PrgItem i on x.ItemID = i.ID where x.StudentID in (
	select isnull(y.StudentID, @zg) 
	from @SaveStudents y
	union 
	select isnull(z.StudentID, @zg) 
	from @SaveStudents z join PrgItem on z.StudentID = i.StudentID) ; print 'Attachment : ' + convert(varchar(10), @@rowcount)

delete x from PrgDocument x join PrgItem i on x.ItemID = i.ID where i.StudentID  in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgDocument : ' + convert(varchar(10), @@rowcount)

delete x from IepDisabilityEligibility x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID  where i.StudentID  in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepDisabilityEligibility : ' + convert(varchar(10), @@rowcount)
delete x from IepGoal x join PrgGoal g on x.ID = g.ID join PrgSection ps on g.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID  where i.StudentID  in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepGoal : ' + convert(varchar(10), @@rowcount)
delete x from IepGoalArea x join PrgGoals gs on x.InstanceID = gs.ID join PrgSection ps on gs.ID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID  in (select isnull(StudentID, @zg) from @SaveStudents)  ; print 'IepGoalArea : ' + convert(varchar(10), @@rowcount)

delete x from IepJustification x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID  in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepJustification : ' + convert(varchar(10), @@rowcount)
delete x from IepPostSchoolArea x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepPostSchoolArea : ' + convert(varchar(10), @@rowcount)
delete x from IepSpecialFactor x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepSpecialFactor : ' + convert(varchar(10), @@rowcount)
delete x from IepTestAccom x join IepAccommodation ia on x.AccommodationID = ia.ID join IepAccommodationCategory iac on ia.CategoryID = iac.ID join PrgSection ps on ia.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepTestAccom : ' + convert(varchar(10), @@rowcount)
delete x from IntvGoal x join PrgItem i on x.InterventionID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IntvGoal : ' + convert(varchar(10), @@rowcount)

-- delete x from MosRelatedService x join PrgMatrixOfServices pms on x.MatrixOfServicesID = pms.ID join PrgItem i on pms.ID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'MosRelatedService : ' + convert(varchar(10), @@rowcount)
delete x from PrgActivity x join PrgItem i on x.ID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivity : ' + convert(varchar(10), @@rowcount)
delete x from PrgActivitySchedule x join PrgItem i on x.ItemId = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivitySchedule : ' + convert(varchar(10), @@rowcount)
delete x from PrgGoal x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemId = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgGoal : ' + convert(varchar(10), @@rowcount)
delete x from PrgInterventionSubVariant x join PrgItem i on x.InterventionID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgInterventionSubVariant : ' + convert(varchar(10), @@rowcount)


delete x from PrgItemRel x join PrgItem i on x.InitiatingItemID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgItemRel : ' + convert(varchar(10), @@rowcount)
delete x from PrgItemTeamMember x join PrgItem i on x.ItemID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents)  ; print 'PrgItemTeamMember : ' + convert(varchar(10), @@rowcount)
-- delete x from PrgMatrixOfServices x join PrgItem i on x.ID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgMatrixOfServices : ' + convert(varchar(10), @@rowcount)
delete x from PrgMilestone x join PrgItem i on x.StartingItemID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgMilestone : ' + convert(varchar(10), @@rowcount)
-- found out what PrgMilestone is

delete x from PrgActivityBatch x join PrgItem i on x.ID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivityBatch : ' + convert(varchar(10), @@rowcount)
delete x from MedicaidExtractIssue x join ServiceDeliveryStudent y on y.ID = x.ServiceDeliveryStudentID where y.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'MedicaidExtractIssue : ' + convert(varchar(10), @@rowcount)
delete x from ServiceDeliveryStudent x where x.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ServiceDeliveryStudent : ' + convert(varchar(10), @@rowcount)

delete x from ServicePlanDiagnosisCode x join ServicePlan y on x.PlanID = y.ID where y.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ServicePlanDiagnosisCode : ' + convert(varchar(10), @@rowcount)

delete x from IepServicePlan x join ServicePlan sp on x.ID = sp.ID where sp.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepServicePlan : ' + convert(varchar(10), @@rowcount)
delete x from ServicePlan x where x.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ServicePlan : ' + convert(varchar(10), @@rowcount)

delete x from PrgSection x join PrgItem i on x.ItemID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgSection : ' + convert(varchar(10), @@rowcount)


-- set nocount off;
delete x from ServiceSchedule x where ID not in (select z.ID from ServiceSchedule z join ServiceScheduleServicePlan sssp on z.ID = sssp.ScheduleID join ServicePlan sp on sssp.ServicePlanID = sp.ID  where sp.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) )  ; print 'ServiceSchedule : ' + convert(varchar(10), @@rowcount)-- ??
--Msg 547, Level 16, State 0, Line 115
--The DELETE statement conflicted with the REFERENCE constraint "FK_PrgGoal#ProbeSchedule#". The conflict occurred in database "Enrich_DCB2_CO_Mesa51", table "dbo.PrgGoal", column 'ProbeScheduleID'.
-- delete x from Schedule x 



--select distinct ProbeScheduleID from PrgGoal 
--select * from PrgGoal g join PrgSection s on g.InstanceID = s.ID join PrgItem i on s.ItemID = i.ID left join @SaveStudents ss on i.StudentID = ss.StudentID where ss.StudentID is null


--delete s from Student s join LEGACYSPED.MAP_StudentRefID m on m.DestID = s.ID where m.LegacyData = 1 ; print 'Student : ' + convert(varchar(10), @@rowcount) -- s.ManuallyEntered = 1 -- is there any benefit in attempting to delete Legacy data?

delete x from ServiceDef sd join IepServiceDef x on sd.ID = x.ID where sd.DeletedDate is not null and sd.ID not in (select DefID from ServicePlan where StudentID in (select isnull(StudentID, @zg) from @SaveStudents)) ; print 'IepServiceDef : ' + convert(varchar(10), @@rowcount) 
delete x from ServiceDef sd join UserProfileServiceDefPermission x on sd.ID = x.ServiceDefID where sd.DeletedDate is not null and sd.ID not in (select DefID from ServicePlan where StudentID in (select isnull(StudentID, @zg) from @SaveStudents)) ; print 'UserProfileServiceDefPermission : ' + convert(varchar(10), @@rowcount) 
delete x from ServiceDef sd join ServiceDefDiagnosisCode x on sd.ID = x.ServiceDefID where sd.ID   in (select ID from ServiceDef where DeletedDate is not null )and sd.ID not in (select DefID from ServicePlan where StudentID in (select isnull(StudentID, @zg) from @SaveStudents))
delete x from ServiceDef sd join ServiceDefProcedure x on sd.ID = x.ServiceDefID where sd.ID  in (select ID from ServiceDef where DeletedDate is not null ) and sd.ID not in (select DefID from ServicePlan where StudentID in (select isnull(StudentID, @zg) from @SaveStudents))
delete sd from ServiceDef sd where DeletedDate is not null and sd.ID in (select ID from ServiceDef where DeletedDate is not null ) and sd.ID not in (select DefID from ServicePlan where StudentID in (select isnull(StudentID, @zg) from @SaveStudents)) ; print 'ServiceDef : ' + convert(varchar(10), @@rowcount) 
--Msg 547, Level 16, State 0, Line 142
--The DELETE statement conflicted with the REFERENCE constraint "FK_ServicePlan#Def#Plans". The conflict occurred in database "Enrich_DCB2_CO_Mesa51", table "dbo.ServicePlan", column 'DefID'.
	-- we are handling this separately in Prepare DB ServiceDef
	

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


delete x from ServiceDelivery x join ServiceDeliveryStudent sds on x.ID = sds.DeliveryID where sds.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ServiceDelivery : ' + convert(varchar(10), @@rowcount)
delete x from PrgVersionIntent x join PrgItemIntent i on x.ItemIntentId = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents); print 'PrgVersionIntent : ' + convert(varchar(10), @@rowcount)
delete x from PrgItemIntent x where x.StudentId in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgItemIntent : ' + convert(varchar(10), @@rowcount)

delete x from ProbeScore x join ProbeTime t on x.ProbeTimeID = t.ID  where t.StudentId in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ProbeScore : ' + convert(varchar(10), @@rowcount)
delete x from ProbeTime x where x.StudentId in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ProbeTime : ' + convert(varchar(10), @@rowcount)

delete x from PrgGoalProgress x join PrgGoal g on x.GoalID = g.ID join PrgSection ps on g.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentId in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgGoalProgress : ' + convert(varchar(10), @@rowcount)
delete x from FormInstanceBatch x join FormInstance fi on x.Id = fi.FormInstanceBatchId join StudentForm sf on fi.Id = sf.Id where sf.StudentId in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'FormInstanceBatch : ' + convert(varchar(10), @@rowcount)
-- ??
delete x from FormInstanceInterval x join PrgItemForm pif on x.InstanceId = pif.ID join PrgItem i on pif.ItemID = i.ID where i.StudentId in (select isnull(StudentID, @zg) from @SaveStudents)  ; print 'FormInstanceInterval : ' + convert(varchar(10), @@rowcount)

delete x from StudentFormInstanceBatch x join FormInstance fi on x.id = fi.FormInstanceBatchID join StudentForm sf on fi.ID = sf.ID where sf.StudentId in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'StudentFormInstanceBatch : ' + convert(varchar(10), @@rowcount)

delete x from PrgSection x join PrgItem y on y.ID = x.ItemID where y.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgSection : ' + convert(varchar(10), @@rowcount)

delete x from FormInstance x join PrgItemForm pif on x.Id = pif.ID join PrgItem i on pif.ItemID = i.ID where i.StudentId in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'FormInstance : ' + convert(varchar(10), @@rowcount)
-- assume PrgItemForm, a subclass of FormInstance, is cascade deleted

delete x from PrgActivitySchedule x join PrgItem y on y.ID = x.ItemId where y.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivitySchedule : ' + convert(varchar(10), @@rowcount)

delete x from PrgActivitySchedule x join IntvTool y on y.ID = x.ToolID join PrgItem z on z.ID = y.InterventionID where z.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivitySchedule : ' + convert(varchar(10), @@rowcount)

delete x from IntvTool x join PrgItem y on y.ID = x.InterventionID where y.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivitySchedule : ' + convert(varchar(10), @@rowcount)

-- moved this commented line here because there was an FK error on InitiatingIepID.  Not sure why it was commented out previously
delete x from PrgMatrixOfServices x join PrgItem i on x.ID = i.ID where i.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgMatrixOfServices : ' + convert(varchar(10), @@rowcount)
-- moved prgitem here because other deletion queries depend on it
delete x from PrgItem x where x.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgItem : ' + convert(varchar(10), @@rowcount)
delete x from PrgInvolvement x where x.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgInvolvement : ' + convert(varchar(10), @@rowcount)

declare @delstudents table (StudentID uniqueidentifier not null)
insert @delstudents
select x.ID
from Student x 
where x.ManuallyEntered = 1
and ID in (select isnull(StudentID, @zg) from @SaveStudents)

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join 
StudentRosterYear x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
StudentGradeLevelHistory x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
StudentSchoolHistory x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
StudentTeacherClassRoster x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
TranscriptCourse x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
StudentClassRosterHistory x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
StudentGroupStudent x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
T_CSAP x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
T_COGAT x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
StudentRecordException x on n.StudentID = x.Student2ID

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
T_ACT x on n.StudentID = x.StudentID

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
T_CELA x on n.StudentID = x.StudentID

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
DisciplineIncident x on n.StudentID = x.StudentID

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
ReportCardScore x on n.StudentID = x.Student

	delete x
	-- select x.*
	from @delstudents n join
	Student x on n.StudentID = x.ID


--rollback tran test2

-- delete x from AuditLogEntry x ; print 'AuditLogEntry : ' + convert(varchar(10), @@rowcount) --- ?? do not understand this table.  -- select * from AuditLogEntry
-- delete Person where TypeID = 'P' and ManuallyEntered = 1 ; print 'Attachment : ' + convert(varchar(10), @@rowcount) -- ?


-- select * from PrgVersionIntent
-- select * from VC3Deployment.Version

-- delete duplicate schools imported previously


commit tran delStud

--rollback tran delStud



