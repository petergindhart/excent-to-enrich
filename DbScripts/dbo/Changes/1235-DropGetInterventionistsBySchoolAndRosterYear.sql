if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserProfile_GetInterventionistsBySchoolAndRosterYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UserProfile_GetInterventionistsBySchoolAndRosterYear]
GO