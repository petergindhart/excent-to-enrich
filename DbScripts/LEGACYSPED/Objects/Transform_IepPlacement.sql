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
		IsEnabled = case when po.TypeID = pt.ID then 1 else 0 End,
		SourceID = CASE
					WHEN piep.StartDate >=  DATEADD(YEAR, pt.MinAge, stu.DOB) 
													 THEN '3C5BFC1F-B3E6-4E69-BC32-FCFBA2E8185E' -- StartDate
													 ELSE '173E47D8-5B63-4A69-9430-8064759AAA47' -- Aged Up

				   END,
		AsOfDate = CASE

            WHEN piep.StartDate >= DATEADD(YEAR, pt.MinAge, stu.DOB) THEN piep.StartDate

            ELSE DATEADD(YEAR, pt.MinAge, stu.DOB)
			END,
		IsDecOneCount = case when po.TypeID = pt.ID then 1 else 0 End,
		MinutesInstruction = lre.MinutesInstruction,
		lre.DoNotTouch
	
	
	FROM dbo.IepPlacementType pt CROSS JOIN
		LEGACYSPED.Transform_IepLeastRestrictiveEnvironment lre LEFT JOIN -- attempting to address a performance issue when treating nulls in queries referencing this view
		LEGACYSPED.Transform_IepPlacementOption po on 
			isnull(lre.AgeGroup,'a') = isnull(po.PlacementTypeCode,'b') AND
			isnull(lre.LRECode,'a') = isnull(po.PlacementOptionCode,'b') LEFT JOIN 
		LEGACYSPED.MAP_IepPlacementID m on 
			isnull(m.IepRefID,'a') = isnull(lre.IepRefID,'b') and 
			isnull(m.TypeID,'00000000-0000-0000-0000-000000000000') = isnull(pt.ID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF') LEFT JOIN 
		dbo.IepPlacement t on isnull(lre.DestID,'00000000-0000-0000-0000-000000000000') = isnull(t.ID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF')  LEFT JOIN  -- 1:24 for 23556 records.  Attempts to address performance issues not working well
		LEGACYSPED.Transform_PrgIep piep ON isnull(piep.IEPRefID,'a') =isnull(m.IepRefID,'b') LEFT JOIN  --For new LRE model
		dbo.Student stu ON stu.ID = isnull(piep.StudentID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF')
		
GO
--
