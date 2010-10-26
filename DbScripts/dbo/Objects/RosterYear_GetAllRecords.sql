
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'RosterYear_GetAllRecords' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.RosterYear_GetAllRecords
GO

/*
<summary>
Returns all roster year records. Ordered by start year.
</summary>

<returns>Returns all roster year records. Ordered by start year.</returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.RosterYear_GetAllRecords 
AS
	select *
	from RosterYear
	order by StartYear asc
GO
