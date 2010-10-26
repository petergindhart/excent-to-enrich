if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ScsdeDatabase_InsertCertificationRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ScsdeDatabase_InsertCertificationRecord]
GO


/*
<summary>
Inserts a new record into the Scsde_TeacherCertification table with the specified values
</summary>
<param name="certNum">Value to assign to the CertNum field of the record</param>
<param name="area">Value to assign to the Area field of the record</param>
<param name="beginDate">Value to assign to the BeginDate field of the record</param>
<param name="endDate">Value to assign to the EndDate field of the record</param>
<param name="hq">Value to assign to the HQ field of the record</param>
<param name="endorsement">Value to assign to the Endorsement field of the record</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.ScsdeDatabase_InsertCertificationRecord 
	@certNum varchar(6),
	@area varchar(50),
	@beginDate datetime,
	@endDate datetime,
	@hq bit,
	@endorsement bit
AS
	INSERT INTO Scsde_TeacherCertification
	(
		CertNum,
		Area,
		BeginDate,
		EndDate,
		HQ,
		Endorsement
	)
	VALUES
	(
		@certNum,
		@area,
		@beginDate,
		@endDate,
		@hq,
		@endorsement
	)
GO