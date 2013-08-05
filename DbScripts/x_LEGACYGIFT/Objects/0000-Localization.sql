--#include {SpedObjectsInclude}\0000-Localization.sql
--#include {GiftStateInclude}\0010-Extract-Goal.sql
--#include {GiftStateInclude}\GoalAreaExists.sql
--#include {GiftStateInclude}\0001-Prep_State.sql
--#include {GiftDistrictInclude}\0002-Prep_District.sql
--#include {GiftDistrictInclude}\MAP_GiftedProgramID.sql
--#include Transform_Student.sql
--#include {GiftDistrictInclude}\MAP_PrgStatus_ConvertedEP.sql
--#include Transform_PrgInvolvement.sql
--#include Transform_PrgItem.sql
--#include Transform_IepServices.sql
--#include Transform_FormInstance.sql
--#include Transform_FormInputValue.sql
--#include Transform_FormInput_EPDates_Date.sql
--#include Transform_FormInput_EPDates_SingleSelect.sql
--#include Transform_PrgSection.sql
--#include Transform_PrgGoals.sql
--#include PrimaryGoalAreaPerGoal.sql
--#include {GiftStateInclude}\Transform_IepGoalArea.sql
--#include Transform_PrgGoal.sql
--#include {GiftStateInclude}\Transform_IepGoalPostSchoolAreaDef.sql
--#include {GiftStateInclude}\Transform_IepGoalSubGoalAreaDef.sql

----#include Transform_IepServiceCategory.sql
--#include {SpedObjectsInclude}\Transform_ServiceDef.sql
----#include Transform_ServiceProviderTitle.sql
--#include Transform_Schedule.sql
--#include Transform_IepService.sql
--#include Create_IepServiceSnapshot.sql
--#include Transform_FormInput_EP_Present_Levels_Text.sql
-- let's reset the counts for imported data so we know this script ran when we run dc from the ui
update et set LastSuccessfulCount = 0, CurrentCount = 0 from VC3ETL.ExtractTable et where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' 
