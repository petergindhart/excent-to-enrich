if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AlertRule_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AlertRule_GetAllRecords]
GO

/*
<summary>
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.AlertRule_GetAllRecords 
AS
	SELECT *
	FROM AlertRule
GO
