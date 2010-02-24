IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_IepEsy]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_IepEsy]
GO

CREATE VIEW [EXCENTO].[Transform_IepEsy]
AS
	SELECT 
		DestID = CAST(NULL as uniqueidentifier),
		DecisionID = CAST(NULL as uniqueidentifier),
		TbdDate = CAST(NULL as datetime),
		TbdNeededInformation = CAST(NULL as Text),
		Explanation = CAST(NULL as Text)

GO
