IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FileData_DeleteTemporaryRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FileData_DeleteTemporaryRecords]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 /*
<summary>
Deletes temporary FileData records based on their age
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[FileData_DeleteTemporaryRecords] 
	@ageInHours int = 24
AS

DELETE f
FROM
	FileData f
WHERE
	f.IsTemporary = 1 AND
	DATEDIFF(HOUR, f.ReceivedDate, GETDATE()) > @ageInHours AND
	f.ID NOT IN (
		select ID
		from
		(
			SELECT ContentFileId [ID] FROM PrgDocument UNION
			SELECT TemplateFileId FROM PrgDocumentDef UNION
			SELECT PhotoID FROM StudentPhoto UNION
			SELECT DistrictLogoID FROM SystemSettings
		) T
		WHERE ID IS NOT NULL
	)

GO


