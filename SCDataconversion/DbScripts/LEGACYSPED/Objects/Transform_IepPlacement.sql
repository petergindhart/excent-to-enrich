IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_LRE') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW LEGACYSPED.Transform_LRE
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_LREPlacement') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW LEGACYSPED.Transform_LREPlacement
GO

-- ############################################################################# 
-- LRE Placement
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepPlacementID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepPlacementID
(
	IepRefID	varchar(150) NOT NULL,
	TypeId uniqueidentifier not null,
	DestID uniqueidentifier NOT NULL 
)

ALTER TABLE LEGACYSPED.MAP_IepPlacementID ADD CONSTRAINT
PK_MAP_IepPlacementID PRIMARY KEY CLUSTERED
(
	IepRefID,
	TypeId
)
END

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_MAP_IepPlacementID_DestID')
create nonclustered index IX_LEGACYSPED_MAP_IepPlacementID_DestID on LEGACYSPED.MAP_IepPlacementID (DestID)

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepPlacement') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW LEGACYSPED.Transform_IepPlacement
GO

CREATE VIEW LEGACYSPED.Transform_IepPlacement
AS
	SELECT 
		lre.IepRefID, 
		DestID = m.DestID,
		InstanceID = lre.DestID,
		TypeID = pt.ID,
		OptionID = case when po.TypeID = pt.ID then po.DestID else NULL End,
		SourceID = 'C9967875-E09B-4F3E-BE00-5BF2A97C7DAD', -- User Created:  Per Pete, use this in all cases as of 10/30/2012
		AsOfDate = CASE
			WHEN piep.StartDate >= DATEADD(YEAR, pt.MinAge, stu.DOB) THEN piep.StartDate
			ELSE DATEADD(YEAR, pt.MinAge, stu.DOB)
			END,
		IsDecOneCount = case when po.TypeID = pt.ID then 1 else 0 End,
		MinutesInstruction = lre.MinutesInstruction,
		UseLimitedValidation = cast (1 as bit),
		lre.DoNotTouch
	FROM LEGACYSPED.Transform_IepLeastRestrictiveEnvironment lre JOIN -- left join resulted in more rows returned.  did not investigate.  gg
		LEGACYSPED.Transform_IepPlacementOption po on 
			isnull(lre.AgeGroup,'a') = isnull(po.PlacementTypeCode,'b') AND
			isnull(lre.LRECode,'a') = isnull(po.PlacementOptionCode,'b') LEFT JOIN 
		LEGACYSPED.MAP_IepPlacementID m on 
			isnull(m.IepRefID,'a') = isnull(lre.IepRefID,'b') and 
			isnull(m.TypeID,'00000000-0000-0000-0000-000000000000') = isnull(po.TypeID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF') LEFT JOIN 
		dbo.IepPlacementType pt on po.TypeID = pt.ID left join
		dbo.IepPlacement t on isnull(lre.DestID,'00000000-0000-0000-0000-000000000000') = isnull(t.InstanceID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF')  LEFT JOIN  -- 1:24 for 23556 records.  Attempts to address performance issues not working well
		LEGACYSPED.Transform_PrgIep piep ON isnull(piep.IEPRefID,'a') =isnull(m.IepRefID,'b') LEFT JOIN  --For new LRE model
		dbo.Student stu ON stu.ID = isnull(piep.StudentID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF')
GO
--
