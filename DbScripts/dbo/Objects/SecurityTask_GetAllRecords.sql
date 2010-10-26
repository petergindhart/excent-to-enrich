

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityTask_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityTask_GetAllRecords]
GO


/*
<summary>
Returns all security task records. Ordered by name.
</summary>

<returns>Returns all security task records. Ordered by name.</returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.SecurityTask_GetAllRecords 
AS
	select *
	from SecurityTaskView
	order by [sequence]
GO