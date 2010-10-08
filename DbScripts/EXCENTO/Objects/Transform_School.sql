IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_School]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_School]
GO

CREATE VIEW EXCENTO.Transform_School
AS

select
	s.SchoolID,	
	m.DestID,
	DistrictID = d.DestID,
	Name = s.SchoolName,
	MinutesInstruction = NULL
from
	EXCENTO.School s join
	EXCENTO.MAP_DistrictID d on s.DistrictID = d.GDistrictID left join
	EXCENTO.MAP_SchoolID m on s.SchoolID = m.SchoolID
	
GO
