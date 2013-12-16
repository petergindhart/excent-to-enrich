
-- #############################################################################
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_EthnicityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_EthnicityID
	(
	EthnicityCode nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
ALTER TABLE LEGACYSPED.MAP_EthnicityID ADD CONSTRAINT
	PK_MAP_IepEthnicityID PRIMARY KEY CLUSTERED
	(
	EthnicityCode
	)
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_Ethnicity') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_Ethnicity
GO

-- should we update the statecode column of the enum value table and then join statecode to statecode?  in this case EnumValue.Code = LEGACYSPED.SelectLists.StateCode so we're doing the Q&D
create view LEGACYSPED.Transform_Ethnicity
as

-- join to EnumValue on MAP, EnrichID, StateCode
SELECT
	LegacySpedCode = coalesce(x.Code, isnull(l.LegacySpedCode, convert(varchar(150), l.EnrichLabel))),
	StateCode = coalesce( s.StateCode, x.StateCode, l.StateCode),
	DestID = coalesce(s.ID, x.ID, l.EnrichID, m.DestID),
	Name = coalesce(s.DisplayValue, x.DisplayValue, l.EnrichLabel)
FROM
	LEGACYSPED.SelectLists l LEFT JOIN
	dbo.EnumValue s on l.StateCode = s.StateCode and l.Type = 'Ethnic' and s.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and s.IsActive = 1 left join
	LEGACYSPED.MAP_EthnicityID m on l.LegacySpedCode = m.EthnicityCode left join
	dbo.EnumValue x on l.LegacySpedCode = x.Code AND 
	x.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535'
WHERE l.Type = 'Ethnic' 
GO

--
--select * from EnumType where Type = 'ETH'
--select * from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535'

--select * from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' order by Sequence





