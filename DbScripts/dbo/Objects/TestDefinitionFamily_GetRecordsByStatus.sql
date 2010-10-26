/*
 * 1. Saveas: C:\Projects\VC3\TestView\Product\Mainline\Database\Objects\TestDefinitionFamily_GetRecordsByStatus.sql
 * 2. Register to visual source safe. 
 */

IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'TestDefinitionFamily_GetRecordsByStatus' 
	   AND 	  type = 'P')
    DROP PROCEDURE TestDefinitionFamily_GetRecordsByStatus
GO


/*
<summary>
Get all the records in TestDefinitionFamily table having the same family status. 
</summary>
<param name="status">The status of test definition family</param>
<model returnType="System.Data.IDataReader"/>
*/

CREATE PROCEDURE dbo.TestDefinitionFamily_GetRecordsByStatus 
	@status char
AS

SELECT
	* 
FROM 
	TestDefinitionFamily
WHERE
	Status = @status
ORDER BY 
	Name

GO
