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

--  Hard-map IepPlacementType (this is the same everywhere as of 20110829
set nocount on;
insert LEGACYSPED.MAP_IepPlacementTypeID values ('PK', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC') -- is it a safe assumption that this will be consistent throughout all installations?
insert LEGACYSPED.MAP_IepPlacementTypeID values ('K12', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
set nocount off;
END
GO

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
	PlacementOptionCode = isnull(k.LegacySpedCode, convert(varchar(150), k.EnrichLabel)), 
	StateCode = coalesce(s.StateCode, t.StateCode, k.StateCode), -- ??
	DestID = coalesce(s.ID, t.ID, m.DestID),
	TypeID = coalesce(s.TypeID, t.TypeID, my.DestID),
	Sequence = coalesce(s.Sequence, t.Sequence, 99),
	Text = coalesce(s.Text, t.Text, k.EnrichLabel),
	MinPercentGenEd = isnull(s.MinPercentGenEd, t.MinPercentGenEd),   
	MaxPercentGenEd = isnull(s.MaxPercentGenEd, t.MaxPercentGenEd),   
	DeletedDate = 
			CASE 
				WHEN s.ID IS NOT NULL THEN s.DeletedDate -- Always show in UI where there is a StateID.  Period.
				WHEN t.ID IS NOT NULL THEN t.DeletedDate
				ELSE NULL
					--CASE WHEN k.DisplayInUI = 'Y' THEN NULL -- User specified they want to see this in the UI.  Let them.
					--ELSE GETDATE() -- We have removed the DisplayInUI in the new Dataspec 20120319.
					--END
			END 
from 
	LEGACYSPED.SelectLists k LEFT JOIN
	LEGACYSPED.MAP_IepPlacementTypeID my on k.SubType = my.PlacementTypeCode LEFT JOIN 
	dbo.IepPlacementOption s on 
		my.DestID = s.TypeID and
		k.StateCode = s.StateCode LEFT JOIN 
	LEGACYSPED.MAP_IepPlacementOptionID m on 
		my.PlacementTypeCode = m.PlacementTypeCode and
		isnull(k.LegacySpedCode, convert(varchar(150), k.Enrichlabel)) = m.PlacementOptionCode LEFT JOIN
	dbo.IepPlacementOption t on m.DestID = t.ID
where k.Type = 'LRE' and
	k.SubType in ('PK', 'K12') 
go


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


