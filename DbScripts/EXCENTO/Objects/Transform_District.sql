IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_District]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_District]
GO

CREATE VIEW EXCENTO.Transform_District
AS

	select
		DistrictID,
		DestID,
		Name = d.DistrictName,
		IsCustom = 0,
		MinutesInstruction = NULL
	from
		EXCENTO.District d left join
		EXCENTO.MAP_DistrictID m on d.DistrictID = m.GDistrictID


GO
