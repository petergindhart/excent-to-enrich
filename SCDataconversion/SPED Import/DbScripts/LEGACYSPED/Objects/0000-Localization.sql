--#include {SpedStateInclude}\0010-Extract-Goal.sql
--#include {SpedStateInclude}\GoalAreaExists.sql
--#include {SpedStateInclude}\0001-Prep_State.sql
--#include {SpedStateInclude}\Transform_IepGoalAreaDef.sql
--#include {SpedDistrictInclude}\0002-Prep_District.sql
--#include Transform_ServiceFrequency.sql
--#include {SpedStateInclude}\StudentView.sql
--#include Transform_OrgUnit.sql
--#include Transform_School.sql
--#include Transform_GradeLevel.sql
--#include Transform_Student.sql
--#include Populate_MAP_StudentRefIDAll.sql
--#include EvaluateIncomingItems.sql
--#include {SpedDistrictInclude}\MAP_PrgStatus_ConvertedDataPlan.sql
--#include Transform_PrgInvolvement.sql
--#include Transform_PrgIep.sql
--#include Transform_IepServices.sql
--#include Transform_PrgSection.sql
--#include Transform_PrgGoals.sql
--#include PrimaryGoalAreaPerGoal.sql
--#include {SpedStateInclude}\Transform_IepGoalArea.sql
--#include Transform_PrgGoal.sql
--#include {SpedStateInclude}\Transform_IepGoalPostSchoolAreaDef.sql
--#include {SpedStateInclude}\Transform_IepGoalSubGoalAreaDef.sql
--#include Transform_IepPlacementOption.sql
--#include Transform_IepLeastRestrictiveEnvironment.sql
--#include Transform_IepPlacement.sql
--#include Transform_PrgLocation.sql
--#include Transform_IepServiceCategory.sql
--#include Transform_ServiceDef.sql
--#include Transform_ServiceProviderTitle.sql
--#include Transform_Schedule.sql
--#include Transform_PrgItemTeamMember.sql
--#include Transform_IepService.sql

-- these columns were removed from the database after the original ETL code was written.  Since the config update does not delete, we'll delete them here.
delete VC3ETL.LoadColumn where ID = '732EE249-76FA-474E-B32B-8F3C2D8981E0'
delete VC3ETL.LoadColumn where ID = '8192a392-2f4f-4411-b746-22285302d41e'
delete VC3ETL.LoadColumn where ID = 'F62B299C-FF4A-4A4D-A256-F367C189A9F1'
delete VC3ETL.LoadColumn where ID = '8AC5A6CE-E010-469E-B834-3C93A095951A'

-- let's reset the counts for imported data so we know this script ran when we run dc from the ui
update et set LastSuccessfulCount = 0, CurrentCount = 0 from VC3ETL.ExtractTable et where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' 
