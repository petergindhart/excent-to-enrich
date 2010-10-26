if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Alert_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Alert_GetAllRecords]
GO

/*
<summary>
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.Alert_GetAllRecords 
AS
	SELECT *
	FROM Alert
GO
