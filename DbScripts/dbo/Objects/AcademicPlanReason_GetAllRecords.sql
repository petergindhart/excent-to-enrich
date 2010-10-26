SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AcademicPlanReason_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AcademicPlanReason_GetAllRecords]
GO


/*
<summary>
Retrieves all AcademicPlanReason records
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.AcademicPlanReason_GetAllRecords 
AS
	SELECT *
	FROM AcademicPlanReason
GO