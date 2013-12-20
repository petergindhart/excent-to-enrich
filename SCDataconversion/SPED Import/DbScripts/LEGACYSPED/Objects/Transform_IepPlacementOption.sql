-- ############################################################################# 
-- LRE Placement TYPE
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepPlacementTypeID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepPlacementTypeID
(
	PlacementTypeCode varchar(20) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepPlacementTypeID ADD CONSTRAINT
	PK_MAP_IepPlacementTypeID PRIMARY KEY CLUSTERED
	(
		PlacementTypeCode
	)
CREATE INDEX IX_MAP_IepPlacementTypeID_PlacementTypeCode on LEGACYSPED.MAP_IepPlacementTypeID (PlacementTypeCode)

END
GO

--  Hard-map IepPlacementType (this is the same everywhere as of 20110829
set nocount on;
if not exists (select 1 from LEGACYSPED.MAP_IepPlacementTypeID where DestID = 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC')
insert LEGACYSPED.MAP_IepPlacementTypeID values ('PK', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC') -- is it a safe assumption that this will be consistent throughout all installations?

if not exists (select 1 from LEGACYSPED.MAP_IepPlacementTypeID where DestID = 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
insert LEGACYSPED.MAP_IepPlacementTypeID values ('K12', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
set nocount off;


-- ############################################################################# 
-- LRE Placement OPTION
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepPlacementOptionID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepPlacementOptionID
(
	PlacementTypeCode varchar(20) NOT NULL,
	PlacementOptionCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepPlacementOptionID ADD CONSTRAINT
PK_MAP_IepPlacementOptionID PRIMARY KEY CLUSTERED
(
	PlacementTypeCode,
	PlacementOptionCode
)

CREATE INDEX IX_MAP_IepPlacementOptionID_PlacementTypeCode_PlacementOptionCode on LEGACYSPED.MAP_IepPlacementOptionID (PlacementTypeCode, PlacementOptionCode)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepPlacementOption') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW LEGACYSPED.Transform_IepPlacementOption
GO

create view LEGACYSPED.Transform_IepPlacementOption
as
select 
	PlacementTypeCode = k.SubType, 
	PlacementOptionCode = k.LegacySpedCode, 
	TypeID = my.DestID,
	DestID = isnull(k.EnrichID, mo.DestID), 
	StateCode = isnull(t.StateCode, k.StateCode),
	Sequence = isnull(t.Sequence,99), -- t columns will be null until the map table is populated
	Text = isnull(t.Text, k.EnrichLabel), -- t columns will be null until the map table is populated
	MinPercentGenEd = t.MinPercentGenEd,   -- t columns will be null until the map table is populated
	MaxPercentGenEd = t.MaxPercentGenEd,   -- t columns will be null until the map table is populated
	DeletedDate = cast(NULL as datetime)	
	-- depends on when we want to hide from the UI
from 
	LEGACYSPED.SelectLists k LEFT JOIN
	LEGACYSPED.MAP_IepPlacementTypeID my on k.SubType = my.PlacementTypeCode left join
	LEGACYSPED.MAP_IepPlacementOptionID mo on k.SubType = mo.PlacementTypeCode and k.LegacySpedCode = mo.PlacementOptionCode LEFT JOIN 
-- 	dbo.IepPlacementOption t on isnull(k.EnrichID, mo.DestID) = t.ID
	dbo.IepPlacementOption t on k.EnrichID = t.ID
where k.Type = 'LRE' and
	k.SubType in ('PK', 'K12')
and LegacySpedCode is not null -- if the legacy sped code is null, there is nothing to do.  
go

-- select * from IepPlacementOption

