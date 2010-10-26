if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ScsdeDatabase_InsertQualificationRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ScsdeDatabase_InsertQualificationRecord]
GO


/*
<summary>
Inserts a new record into the Scsde_TeacherQualification table with the specified values
</summary>
<param name="certNum">Value to assign to the CertNum field of the record</param>
<param name="acadProgram">Value to assign to the AcadProgram field of the record</param>
<param name="acadClass">Value to assign to the AcadClass field of the record</param>
<param name="yearsExp">Value to assign to the YearsExp field of the record</param>
<param name="techProfDate">Value to assign to the TechProfDate field of the record</param>
<param name="natBoardCert">Value to assign to the NatBoardCert field of the record</param>
<param name="dateLastUpdated">Value to assign to the NatBoardCert field of the record</param>
<param name="recordStatus">Value to assign to the NatBoardCert field of the record</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.ScsdeDatabase_InsertQualificationRecord 
	@certNum varchar(6),
	@acadProgram varchar(50),
	@acadClass varchar(50),
	@yearsExp float(8),
	@techProfDate datetime,
	@natBoardCertified varchar(35),
	@dateLastUpdated datetime,
	@recordStatus char(1)
AS
	INSERT INTO Scsde_TeacherQualification
	(
		CertNum,
		AcadProgram,
		AcadClass,
		YearsExp,
		TechProfDate,
		NatBoardCertified,
		DateLastUpdated,
		RecordStatus
	)
	VALUES
	(
		@certNum,
		@acadProgram,
		@acadClass,
		@yearsExp,
		@techProfDate,
		@natBoardCertified,
		@dateLastUpdated,
		@recordStatus
	)
GO
