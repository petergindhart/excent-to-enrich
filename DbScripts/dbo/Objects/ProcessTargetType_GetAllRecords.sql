if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProcessTargetType_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ProcessTargetType_GetAllRecords]
GO

/*
<summary>
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.ProcessTargetType_GetAllRecords 
AS
	SELECT *
	FROM ProcessTargetType
GO
