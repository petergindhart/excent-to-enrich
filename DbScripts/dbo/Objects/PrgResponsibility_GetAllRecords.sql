IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgResponsibility_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgResponsibility_GetAllRecords]
GO

/*
<summary>
Retrieves all PrgResponsibility records
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.PrgResponsibility_GetAllRecords 
AS
	SELECT *
	FROM PrgResponsibility pr
	WHERE pr.DeletedDate IS NULL
GO