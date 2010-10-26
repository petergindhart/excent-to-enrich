if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityRole_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityRole_GetAllRecords]
GO

/*
<summary>
Returns all security role records. Ordered by name.
</summary>

<returns>Returns all security role records. Ordered by name.</returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.SecurityRole_GetAllRecords 
AS
	select *
	from SecurityRole
	order by Name asc
GO








	
	