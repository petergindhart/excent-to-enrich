if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityTaskCategory_GetRootRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityTaskCategory_GetRootRecords]
GO


/*
<summary>
Returns all root security task category records.
</summary>

<returns>Returns all root security task category records.</returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.SecurityTaskCategory_GetRootRecords 
AS
	select *
	from SecurityTaskCategory
	where parentid is null
	order by [sequence]
GO