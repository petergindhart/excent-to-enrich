
-- #############################################################################
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_EthnicityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_EthnicityID
	(
	EthnicityCode nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
ALTER TABLE AURORAX.MAP_EthnicityID ADD CONSTRAINT
	PK_MAP_IepEthnicityID PRIMARY KEY CLUSTERED
	(
	EthnicityCode
	)
END
GO


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
	EnumValue x on l.StateCode = x.Code -- this will not work for all states.  need a different approach.
WHERE l.Type = 'Ethnic' AND
	x.Type = (select t.ID from EnumType t where t.Type = 'ETH')
GO
--

/*

GEO.ShowLoadTables




*/

