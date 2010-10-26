if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ScsdeDatabase_SetImportRecordsPending]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ScsdeDatabase_SetImportRecordsPending]
GO


/*
<summary>
Updates all Qualification records to have an update status of "Pending"
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.ScsdeDatabase_SetImportRecordsPending
AS
	UPDATE Scsde_TeacherQualification
	SET
		RecordStatus = 'P'


GO
