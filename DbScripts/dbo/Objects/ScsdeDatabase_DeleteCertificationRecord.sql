if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ScsdeDatabase_DeleteCertificationRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ScsdeDatabase_DeleteCertificationRecord]
GO


/*
<summary>
Deletes a Scsde_TeacherCertification record
</summary>
<param name="certNum">Id of the record to delete</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.ScsdeDatabase_DeleteCertificationRecord 
	@certNum varchar(6)
AS
	DELETE FROM Scsde_TeacherCertification
	WHERE CertNum = @certNum

GO
