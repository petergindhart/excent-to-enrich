--#include ..\Changes\0025-Extract-DisabilityLook.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_IepDisability]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW [EXCENTO].[Transform_IepDisability]
GO

CREATE VIEW EXCENTO.Transform_IepDisability
AS
	SELECT
		d.DisabilityID,
		DestID = m.DestID,
		Name = d.DisabDesc,
		Definition = d.DisabilityID,
		DeterminationFormTemplateID = CAST(NULL AS UNIQUEIDENTIFIER)
	FROM
		EXCENTO.DisabilityLook d LEFT JOIN
		EXCENTO.MAP_IepDisabilityID m on d.DisabilityID = m.DisabilityID
	WHERE d.StateCode IS NULL
GO
