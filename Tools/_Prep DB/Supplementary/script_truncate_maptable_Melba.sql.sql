/*
select 'SELECT * INTO ' + (select MapTable from VC3ETL.LoadTable maph WHERE ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' AND HasMapTable = 1 and lt.MapTable = maph.MapTable) + '_Melba FROM '+ (select MapTable from VC3ETL.LoadTable map WHERE ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' AND HasMapTable = 1 and lt.MapTable = map.MapTable) FROM  VC3ETL.LoadTable lt 
WHERE lt.ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' AND HasMapTable = 1
ORDER BY Sequence 

select 'TRUNCATE TABLE ' + (select MapTable from VC3ETL.LoadTable maph WHERE ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' AND HasMapTable = 1 and lt.MapTable = maph.MapTable)  FROM  VC3ETL.LoadTable lt 
WHERE lt.ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' AND HasMapTable = 1
ORDER BY Sequence 
*/
SELECT * INTO LEGACYSPED.SelectLists_LOCAL_Melba FROM LEGACYSPED.SelectLists_LOCAL
SELECT * INTO LEGACYSPED.District_LOCAL_Melba FROM LEGACYSPED.District_LOCAL
SELECT * INTO LEGACYSPED.School_LOCAL_Melba FROM LEGACYSPED.School_LOCAL
SELECT * INTO LEGACYSPED.Student_LOCAL_Melba FROM LEGACYSPED.Student_LOCAL
SELECT * INTO LEGACYSPED.IEP_LOCAL_Melba FROM LEGACYSPED.IEP_LOCAL
SELECT * INTO LEGACYSPED.SPEDStaffMember_LOCAL_Melba FROM LEGACYSPED.SPEDStaffMember_LOCAL
SELECT * INTO LEGACYSPED.Service_LOCAL_Melba FROM LEGACYSPED.Service_LOCAL
SELECT * INTO LEGACYSPED.Goal_LOCAL_Melba FROM LEGACYSPED.Goal_LOCAL
SELECT * INTO LEGACYSPED.Objective_LOCAL_Melba FROM LEGACYSPED.Objective_LOCAL
SELECT * INTO LEGACYSPED.TeamMember_LOCAL_Melba FROM LEGACYSPED.TeamMember_LOCAL
SELECT * INTO LEGACYSPED.StaffSchool_LOCAL_Melba FROM LEGACYSPED.StaffSchool_LOCAL
SELECT * INTO LEGACYSPED.MAP_OrgUnitID_Melba FROM LEGACYSPED.MAP_OrgUnitID
SELECT * INTO LEGACYSPED.MAP_SchoolID_Melba FROM LEGACYSPED.MAP_SchoolID
SELECT * INTO LEGACYSPED.MAP_GradeLevelID_Melba FROM LEGACYSPED.MAP_GradeLevelID
SELECT * INTO LEGACYSPED.MAP_IepDisabilityID_Melba FROM LEGACYSPED.MAP_IepDisabilityID
SELECT * INTO LEGACYSPED.MAP_IepPlacementOptionID_Melba FROM LEGACYSPED.MAP_IepPlacementOptionID
SELECT * INTO LEGACYSPED.MAP_IepServiceCategoryID_Melba FROM LEGACYSPED.MAP_IepServiceCategoryID
SELECT * INTO LEGACYSPED.MAP_PrgStatusID_Melba FROM LEGACYSPED.MAP_PrgStatusID
SELECT * INTO LEGACYSPED.MAP_PrgLocationID_Melba FROM LEGACYSPED.MAP_PrgLocationID
SELECT * INTO LEGACYSPED.MAP_ServiceDefID_Melba FROM LEGACYSPED.MAP_ServiceDefID
SELECT * INTO LEGACYSPED.MAP_ServiceFrequencyID_Melba FROM LEGACYSPED.MAP_ServiceFrequencyID
SELECT * INTO LEGACYSPED.MAP_ServiceProviderTitleID_Melba FROM LEGACYSPED.MAP_ServiceProviderTitleID
SELECT * INTO LEGACYSPED.MAP_StudentRefID_Melba FROM LEGACYSPED.MAP_StudentRefID
SELECT * INTO LEGACYSPED.MAP_PrgInvolvementID_Melba FROM LEGACYSPED.MAP_PrgInvolvementID
SELECT * INTO LEGACYSPED.MAP_IepStudentRefID_Melba FROM LEGACYSPED.MAP_IepStudentRefID
SELECT * INTO LEGACYSPED.MAP_PrgVersionID_Melba FROM LEGACYSPED.MAP_PrgVersionID
SELECT * INTO LEGACYSPED.MAP_FormInstance_Services_Melba FROM LEGACYSPED.MAP_FormInstance_Services
SELECT * INTO LEGACYSPED.MAP_FormInstanceInterval_Services_Melba FROM LEGACYSPED.MAP_FormInstanceInterval_Services
SELECT * INTO LEGACYSPED.MAP_FormInputValue_Services_Melba FROM LEGACYSPED.MAP_FormInputValue_Services
SELECT * INTO LEGACYSPED.MAP_PrgSectionID_NonVersioned_Melba FROM LEGACYSPED.MAP_PrgSectionID_NonVersioned
SELECT * INTO LEGACYSPED.MAP_PrgSectionID_Melba FROM LEGACYSPED.MAP_PrgSectionID
SELECT * INTO LEGACYSPED.MAP_PrgInvolvementTeamMemberID_Melba FROM LEGACYSPED.MAP_PrgInvolvementTeamMemberID
SELECT * INTO LEGACYSPED.MAP_IepGoalAreaDefID_Melba FROM LEGACYSPED.MAP_IepGoalAreaDefID
SELECT * INTO LEGACYSPED.MAP_IepPlacementID_Melba FROM LEGACYSPED.MAP_IepPlacementID
SELECT * INTO LEGACYSPED.MAP_IepDisabilityEligibilityID_Melba FROM LEGACYSPED.MAP_IepDisabilityEligibilityID 
SELECT * INTO LEGACYSPED.MAP_ScheduleID_Melba FROM LEGACYSPED.MAP_ScheduleID
SELECT * INTO LEGACYSPED.MAP_IepGoalAreaID_Melba FROM LEGACYSPED.MAP_IepGoalAreaID
SELECT * INTO LEGACYSPED.MAP_PrgGoalID_Melba FROM LEGACYSPED.MAP_PrgGoalID
SELECT * INTO LEGACYSPED.MAP_PrgGoalObjectiveID_Melba FROM LEGACYSPED.MAP_PrgGoalObjectiveID
SELECT * INTO LEGACYSPED.MAP_PersonID_Melba FROM LEGACYSPED.MAP_PersonID
--SELECT * INTO LEGACYSPED.MAP_OutcomeID_Melba FROM LEGACYSPED.MAP_OutcomeID

TRUNCATE TABLE LEGACYSPED.SelectLists_LOCAL
TRUNCATE TABLE LEGACYSPED.District_LOCAL
TRUNCATE TABLE LEGACYSPED.School_LOCAL
TRUNCATE TABLE LEGACYSPED.Student_LOCAL
TRUNCATE TABLE LEGACYSPED.IEP_LOCAL
TRUNCATE TABLE LEGACYSPED.SPEDStaffMember_LOCAL
TRUNCATE TABLE LEGACYSPED.Service_LOCAL
TRUNCATE TABLE LEGACYSPED.Goal_LOCAL
TRUNCATE TABLE LEGACYSPED.Objective_LOCAL
TRUNCATE TABLE LEGACYSPED.TeamMember_LOCAL
TRUNCATE TABLE LEGACYSPED.StaffSchool_LOCAL
TRUNCATE TABLE LEGACYSPED.MAP_OrgUnitID
TRUNCATE TABLE LEGACYSPED.MAP_SchoolID
TRUNCATE TABLE LEGACYSPED.MAP_GradeLevelID
TRUNCATE TABLE LEGACYSPED.MAP_IepDisabilityID
TRUNCATE TABLE LEGACYSPED.MAP_IepPlacementOptionID
TRUNCATE TABLE LEGACYSPED.MAP_IepServiceCategoryID
TRUNCATE TABLE LEGACYSPED.MAP_PrgStatusID
TRUNCATE TABLE LEGACYSPED.MAP_PrgLocationID
TRUNCATE TABLE LEGACYSPED.MAP_ServiceDefID
TRUNCATE TABLE LEGACYSPED.MAP_ServiceFrequencyID
TRUNCATE TABLE LEGACYSPED.MAP_ServiceProviderTitleID
TRUNCATE TABLE LEGACYSPED.MAP_StudentRefID
TRUNCATE TABLE LEGACYSPED.MAP_PrgInvolvementID
TRUNCATE TABLE LEGACYSPED.MAP_IepStudentRefID
TRUNCATE TABLE LEGACYSPED.MAP_PrgVersionID
TRUNCATE TABLE LEGACYSPED.MAP_FormInstance_Services
TRUNCATE TABLE LEGACYSPED.MAP_FormInstanceInterval_Services
TRUNCATE TABLE LEGACYSPED.MAP_FormInputValue_Services
TRUNCATE TABLE LEGACYSPED.MAP_PrgSectionID_NonVersioned
TRUNCATE TABLE LEGACYSPED.MAP_PrgSectionID
TRUNCATE TABLE LEGACYSPED.MAP_PrgInvolvementTeamMemberID
TRUNCATE TABLE LEGACYSPED.MAP_IepGoalAreaDefID
TRUNCATE TABLE LEGACYSPED.MAP_IepPlacementID
TRUNCATE TABLE LEGACYSPED.MAP_IepDisabilityEligibilityID 
TRUNCATE TABLE LEGACYSPED.MAP_ScheduleID
TRUNCATE TABLE LEGACYSPED.MAP_IepGoalAreaID
TRUNCATE TABLE LEGACYSPED.MAP_PrgGoalID
TRUNCATE TABLE LEGACYSPED.MAP_PrgGoalObjectiveID
TRUNCATE TABLE LEGACYSPED.MAP_PersonID
--TRUNCATE TABLE LEGACYSPED.MAP_OutcomeID



