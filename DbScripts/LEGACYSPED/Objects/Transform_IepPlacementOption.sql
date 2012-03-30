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
	TypeID = my.DestID,
	PlacementOptionCode = k.LegacySpedCode, 
	DestID = isnull(k.EnrichID, mo.DestID), 
	StateCode = isnull(t.StateCode, k.StateCode),
	Sequence = isnull(t.Sequence,99), -- t columns will be null until the map table is populated
	Text = isnull(t.Text, k.EnrichLabel), -- t columns will be null until the map table is populated
	MinPercentGenEd = t.MinPercentGenEd,   -- t columns will be null until the map table is populated
	MaxPercentGenEd = t.MaxPercentGenEd,   -- t columns will be null until the map table is populated
	DeletedDate = cast(case when k.EnrichID is null then getdate() else NULL end as datetime)	
	-- depends on when we want to hide from the UI

from 
	LEGACYSPED.SelectLists k LEFT JOIN
	LEGACYSPED.MAP_IepPlacementTypeID my on k.SubType = my.PlacementTypeCode left join
	LEGACYSPED.MAP_IepPlacementOptionID mo on my.PlacementTypeCode = mo.PlacementTypeCode and k.LegacySpedCode = mo.PlacementOptionCode LEFT JOIN 
-- 	dbo.IepPlacementOption t on isnull(k.EnrichID, mo.DestID) = t.ID
	dbo.IepPlacementOption t on k.EnrichID = t.ID
where k.Type = 'LRE' and
	k.SubType in ('PK', 'K12')
and LegacySpedCode is not null -- if the legacy sped code is null, there is nothing to do.  
go


-- set transaction isolation level read uncommitted

/*

select * from iepplacementoption




exists EnrichID LegacySpedCode


-- Show the map in the transform.
select *
from LEGACYSPED.SelectLists 
where Type = 'LRE'
and EnrichID is not null and LegacySpedCode is not null
order by SubType, case when EnrichID is null then 1 else 0 end, EnrichLabel


-- add these as soft-deleted records.  we're giving the customer the state-codes
select *
from LEGACYSPED.SelectLists 
where Type = 'LRE'
and EnrichID is null and LegacySpedCode is not null
order by SubType, case when EnrichID is null then 1 else 0 end, EnrichLabel


-- nothing to do here.  there is an EnrichID, but no legacy data needs it.
select *
from LEGACYSPED.SelectLists 
where Type = 'LRE'
and EnrichID is not null and LegacySpedCode is null
order by SubType, case when EnrichID is null then 1 else 0 end, EnrichLabel




*/











/*



select * from LEGACYSPED.SelectLists where Type = 'LRE' and isnumeric(isnull(statecode,'x')) = 0 order by SubType, Code
-- select * from LEGACYSPED.SelectLists where Type = 'LRE' and isnumeric(statecode) = 1 and label is not null

insert LEGACYSPED.SelectLists (Type, SubType, StateCode, Code, Label, Sequence, DisplayInUI)
select 
	Type = convert(varchar(20), rtrim(Type)), 
	SubType = convert(varchar(20), rtrim(SubType)), 
	StateCode = convert(varchar(10), rtrim(Label)), 
	Code = convert(varchar(150), rtrim(Code)), 
	Label = convert(varchar(254), rtrim(Code)), 
	Sequence = convert(varchar(3), rtrim(Sequence)), 
	DisplayInUI = convert(char(1), rtrim(DisplayInUI))
from LEGACYSPED.SelectLists 
where Type = 'LRE' and 
	isnumeric(statecode) = 1 and 
	label is not null


select d.* 
-- UPDATE IepPlacementOption SET DeletedDate=s.DeletedDate, Text=s.Text, MaxPercentGenEd=s.MaxPercentGenEd, StateCode=s.StateCode, Sequence=s.Sequence, TypeID=s.TypeID, MinPercentGenEd=s.MinPercentGenEd
FROM  IepPlacementOption d JOIN 
	LEGACYSPED.Transform_IepPlacementOption  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from LEGACYSPED.MAP_IepPlacementOptionID)

-- INSERT LEGACYSPED.MAP_IepPlacementOptionID -- select * from LEGACYSPED.MAP_IepPlacementOptionID
SELECT PlacementTypeCode, PlacementOptionCode, NEWID()
FROM LEGACYSPED.Transform_IepPlacementOption s
WHERE NOT EXISTS (SELECT * FROM IepPlacementOption d WHERE s.DestID=d.ID)

-- INSERT IepPlacementOption (ID, DeletedDate, Text, MaxPercentGenEd, StateCode, Sequence, TypeID, MinPercentGenEd)
SELECT s.DestID, s.DeletedDate, s.Text, s.MaxPercentGenEd, s.StateCode, s.Sequence, s.TypeID, s.MinPercentGenEd
FROM LEGACYSPED.Transform_IepPlacementOption s
WHERE NOT EXISTS (SELECT * FROM IepPlacementOption d WHERE s.DestID=d.ID)

select * from IepPlacementOption order by case when deleteddate is null then 0 else 1 end, StateCode




*/


