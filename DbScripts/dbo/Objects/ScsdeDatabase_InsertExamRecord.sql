if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ScsdeDatabase_InsertExamRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ScsdeDatabase_InsertExamRecord]
GO


/*
<summary>
Inserts a new record into the Scsde_TeacherExam table with the specified values
</summary>
<param name="certNum">Value to assign to the CertNum field of the record</param>
<param name="description">Value to assign to the Description field of the record</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.ScsdeDatabase_InsertExamRecord 
	@certNum varchar(6),
	@description varchar(100)
AS
	INSERT INTO Scsde_TeacherExam
	(
		CertNum,
		Description
	)
	VALUES
	(
		@certNum,
		@description
	)


GO
