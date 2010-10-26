
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityZone_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityZone_GetAllRecords]
GO


/*
<summary>
Returns all security zone records. Ordered by sequence.
</summary>

<returns>Returns all security zone records. Ordered by sequence.</returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.SecurityZone_GetAllRecords 
AS
	select *
	from SecurityZone
	order by [sequence]
GO