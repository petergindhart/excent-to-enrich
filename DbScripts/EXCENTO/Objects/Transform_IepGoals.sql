IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_IepGoals]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_IepGoals]
GO

CREATE VIEW [EXCENTO].[Transform_IepGoals]
AS
	SELECT 
		iep.GStudentID,
		DestID = sec.ID,
		ReportFrequencyID = cast(NULL as uniqueidentifier)
	FROM
	EXCENTO.Transform_Iep iep JOIN
	PrgSection sec ON
		sec.VersionID = iep.VersionDestID AND
		sec.DefID = '32B89B05-C90E-4F62-A171-E5B282981948' --IEP Goals
GO
