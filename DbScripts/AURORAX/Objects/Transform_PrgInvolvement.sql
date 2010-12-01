IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_PrgInvolvement]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_PrgInvolvement]
GO

CREATE VIEW [AURORAX].[Transform_PrgInvolvement]
AS
	SELECT 
		DestID = cast(NULL as uniqueidentifier), 
		StudentID = cast(NULL as uniqueidentifier), 
		ProgramID = cast(NULL as uniqueidentifier), 
		VariantID = cast(NULL as uniqueidentifier), 
		StartDate = cast(NULL as datetime), 
		EndDate = cast(NULL as datetime)
--	FROM

GO
