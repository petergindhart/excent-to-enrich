if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ScsdeDatabase_DeleteQualificationRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ScsdeDatabase_DeleteQualificationRecord]
GO


/*
<summary>
Deletes a Scsde_TeacherQualification record
</summary>
<param name="certNum">Id of the record to delete</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.ScsdeDatabase_DeleteQualificationRecord 
	@certNum varchar(6)
AS
	DELETE FROM Scsde_TeacherQualification
	WHERE CertNum = @certNum

GO