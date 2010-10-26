if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProcessStep_GetAllActiveRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ProcessStep_GetAllActiveRecords]
GO

/*
<summary>
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.ProcessStep_GetAllActiveRecords 
AS
	SELECT *
	FROM ProcessStep
	WHERE StatusID <> '899A2042-7E5E-47CC-A404-572B6B6F3600'
GO
