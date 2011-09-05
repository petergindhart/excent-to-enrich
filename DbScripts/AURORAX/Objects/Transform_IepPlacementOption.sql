-- ############################################################################# 
-- LRE Placement TYPE
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_IepPlacementTypeID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_IepPlacementTypeID
(
	PlacementTypeCode varchar(20) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE AURORAX.MAP_IepPlacementTypeID ADD CONSTRAINT
	PK_MAP_IepPlacementTypeID PRIMARY KEY CLUSTERED
	(
		PlacementTypeCode
	)
CREATE INDEX IX_MAP_IepPlacementTypeID_PlacementTypeCode on AURORAX.MAP_IepPlacementTypeID (PlacementTypeCode)

--  Hard-map IepPlacementType (this is the same everywhere as of 20110829
set nocount on;
insert AURORAX.MAP_IepPlacementTypeID values ('PK', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC') -- is it a safe assumption that this will be consistent throughout all installations?
insert AURORAX.MAP_IepPlacementTypeID values ('K12', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
set nocount off;
END
GO

-- ############################################################################# 
-- LRE Placement OPTION
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_IepPlacementOptionID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_IepPlacementOptionID
(
	PlacementTypeCode varchar(20) NOT NULL,
	PlacementOptionCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE AURORAX.MAP_IepPlacementOptionID ADD CONSTRAINT
PK_MAP_IepPlacementOptionID PRIMARY KEY CLUSTERED
(
	PlacementTypeCode,
	PlacementOptionCode
)

CREATE INDEX IX_MAP_IepPlacementOptionID_PlacementTypeCode_PlacementOptionCode on AURORAX.MAP_IepPlacementOptionID (PlacementTypeCode, PlacementOptionCode)
END
GO



IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_IepPlacementOption') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW AURORAX.Transform_IepPlacementOption
GO

create view AURORAX.Transform_IepPlacementOption
as
select 
	PlacementTypeCode = k.SubType,
	PlacementOptionCode = isnull(k.Code, convert(varchar(150), k.Label)), 
	StateCode = k.StateCode, -- ??
	DestID = coalesce(s.ID, t.ID, m.DestID),
	TypeID = coalesce(s.TypeID, t.TypeID, my.DestID),
	Sequence = coalesce(s.Sequence, t.Sequence, 99),
	Text = coalesce(s.Text, t.Text, k.Label),
	MinPercentGenEd = isnull(s.MinPercentGenEd, t.MinPercentGenEd),   
	MaxPercentGenEd = isnull(s.MaxPercentGenEd, t.MaxPercentGenEd),   
	DeletedDate = 
			CASE 
				WHEN s.ID IS NOT NULL THEN NULL -- Always show in UI where there is a StateID.  Period.
				ELSE 
					CASE WHEN k.DisplayInUI = 'Y' THEN NULL -- User specified they want to see this in the UI.  Let them.
					ELSE GETDATE()
					END
			END 
from 
	AURORAX.Lookups k LEFT JOIN
	AURORAX.MAP_IepPlacementTypeID my on k.SubType = my.PlacementTypeCode LEFT JOIN 
	dbo.IepPlacementOption s on 
		my.DestID = s.TypeID and
		k.StateCode = s.StateCode LEFT JOIN 
	AURORAX.MAP_IepPlacementOptionID m on 
		my.PlacementTypeCode = m.PlacementTypeCode and
		isnull(k.Code, convert(varchar(150), k.label)) = m.PlacementOptionCode LEFT JOIN
	dbo.IepPlacementOption t on m.DestID = t.ID
where k.Type = 'LRE' and
	k.SubType in ('PK', 'K12') 
go


/*


select * from AURORAX.Transform_IepPlacementOption
order by statecode, PlacementTypeCode, PlacementOptionCode


set nocount on;
declare @n varchar(100) ; select @n = 'IepPlacementOption'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	SourceTable = 'AURORAX.Transform_IepPlacementOption'	
	, HasMapTable = 1
	, MapTable = 'AURORAX.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'PlacementTypeCode, PlacementOptionCode'
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = 's.DestID in (select DestID from AURORAX.MAP_IepPlacementOptionID)'
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n



select d.* 
-- UPDATE IepPlacementOption SET DeletedDate=s.DeletedDate, Text=s.Text, MaxPercentGenEd=s.MaxPercentGenEd, StateCode=s.StateCode, Sequence=s.Sequence, TypeID=s.TypeID, MinPercentGenEd=s.MinPercentGenEd
FROM  IepPlacementOption d JOIN 
	AURORAX.Transform_IepPlacementOption  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from AURORAX.MAP_IepPlacementOptionID)

-- INSERT AURORAX.MAP_IepPlacementOptionID
SELECT PlacementTypeCode, PlacementOptionCode, NEWID()
FROM AURORAX.Transform_IepPlacementOption s
WHERE NOT EXISTS (SELECT * FROM IepPlacementOption d WHERE s.DestID=d.ID)

-- INSERT IepPlacementOption (ID, DeletedDate, Text, MaxPercentGenEd, StateCode, Sequence, TypeID, MinPercentGenEd)
SELECT s.DestID, s.DeletedDate, s.Text, s.MaxPercentGenEd, s.StateCode, s.Sequence, s.TypeID, s.MinPercentGenEd
FROM AURORAX.Transform_IepPlacementOption s
WHERE NOT EXISTS (SELECT * FROM IepPlacementOption d WHERE s.DestID=d.ID)

select * from IepPlacementOption order by case when deleteddate is null then 1 else 0 end, StateCode




*/


