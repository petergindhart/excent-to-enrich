IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Ethnicity]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Ethnicity]
GO

-- should we update the statecode column of the enum value table and then join statecode to statecode?  in this case EnumValue.Code = AURORAX.Lookups.StateCode so we're doing the Q&D
create view AURORAX.Transform_Ethnicity
as
SELECT
	l.Code,
	l.StateCode,
	DestID = ISNULL(x.ID, NEWID()),
	Name = l.Label
FROM
	AURORAX.Lookups l LEFT JOIN
	EnumValue x on l.StateCode = x.Code
WHERE l.Type = 'Ethnic' AND
	x.Type = (select t.ID from EnumType t where t.Type = 'ETH')
GO
--