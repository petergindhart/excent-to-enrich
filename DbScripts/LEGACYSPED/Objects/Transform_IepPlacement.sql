--#include Transform_IepPlacementOption.sql

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
	DestID uniqueidentifier NOT NULL -- this is the id of the iepplacement recod
)

ALTER TABLE LEGACYSPED.MAP_IepPlacementID ADD CONSTRAINT
PK_MAP_IepPlacement PRIMARY KEY CLUSTERED
(
	IepRefID,
	TypeId
)
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepPlacement') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW LEGACYSPED.Transform_IepPlacement
GO

CREATE VIEW LEGACYSPED.Transform_IepPlacement
AS
	SELECT
		iep.IepRefID,
		DestID = m.DestID,
		InstanceID = lre.DestID,
		TypeID = t.ID,
		OptionID = case when p.TypeID = t.ID then p.DestID else NULL End,
		IsEnabled = case when p.TypeID = t.ID then 1 else 0 End,
		IsDecOneCount = case when p.TypeID = t.ID then 1 else 0 End -- select t.ID TypeID
	FROM dbo.IepPlacementType t CROSS JOIN
		LEGACYSPED.Transform_PrgIep iep JOIN 
		LEGACYSPED.Transform_IepLeastRestrictiveEnvironment lre ON iep.IepRefID = lre.IepRefId LEFT JOIN 
		LEGACYSPED.Transform_IepPlacementOption p on 
			iep.AgeGroup = p.PlacementTypeCode AND
			iep.LRECode = p.PlacementOptionCode LEFT JOIN 
		LEGACYSPED.MAP_IepPlacementID m on m.IepRefID = iep.IepRefID and t.ID = m.TypeID LEFT JOIN 
		dbo.IepPlacement place on lre.DestID = place.ID 
GO
-- 