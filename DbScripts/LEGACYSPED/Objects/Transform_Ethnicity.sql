
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
SELECT
	LegacySpedCode = ISNULL(l.LegacySpedCode,x.Code),
	StateCode = ISNUll( x.StateCode, l.StateCode),
	DestID = coalesce(x.ID, l.EnrichID, NEWID()),
	Name = l.EnrichLabel
FROM
	LEGACYSPED.SelectLists l LEFT JOIN
	EnumValue x on l.LegacySpedCode = x.Code -- this will not work for all states.  need a different approach.
WHERE l.Type = 'Ethnic' AND
	x.Type = (select t.ID from EnumType t where t.Type = 'ETH')
GO

--

/*

GEO.ShowLoadTables




*/

