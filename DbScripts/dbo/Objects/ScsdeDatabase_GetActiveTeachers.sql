if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ScsdeDatabase_GetActiveTeachers]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ScsdeDatabase_GetActiveTeachers]
GO


/*
<summary>
Gets all teachers which are currently assigned to a school
</summary>

<returns>All active teachers</returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.ScsdeDatabase_GetActiveTeachers
AS

SELECT
	DISTINCT(c.Number), T.*
FROM
	Teacher T INNER JOIN
	TeacherCertificate c ON t.Id = c.TeacherId
WHERE
	T.CurrentSchoolID IS NOT NULL
GO
