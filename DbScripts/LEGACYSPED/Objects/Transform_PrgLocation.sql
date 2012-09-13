-- This file may be used in all states, all districts
-- ############################################################################# 
-- Service Location
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgLocationID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgLocationID
(
	ServiceLocationCode varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgLocationID ADD CONSTRAINT
PK_MAP_PrgLocationID PRIMARY KEY CLUSTERED
(
	ServiceLocationCode
)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgLocation') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgLocation  
GO  

CREATE VIEW LEGACYSPED.Transform_PrgLocation  
AS
/*
	The current SelectList handling strategy is to supply the customer with the defaults for any given state.  
		The defaults will always include state reporting elements.
		The file provided to the customer contains the Enrich ID.
		The customer provides Excent with the Legacy ID that maps to the Enrich ID.
	Assumptions
		All codes provided in addition to the Enrich default codes must be hidden from the UI (we can un-hide them later)
			Any codes not in the default set that have not been hidden from the UI have been requested by the customer to display in the UI.
		When Go-Live data conversion arrives, we will re-create the "SelectLists" file using the data NON-SOFT-DELETED data in the customer's database to produce the file
			This will be merged with new codes from the customer's legacy database
	Will rethink this strategy later.			

	Scenarios and their significance:
		1.  SelectLists.EnrichID and SelectLists.LegacySpedCode exist
			A match to the Enrich value was found in the legacy data
		2.  SelectLists.EnrichID exists but there is no corresponding SelectLists.LegacySpedCode
			There was no match for the Enrich value found in the legacy data
		3.  SelectLists.EnrichID exists but there is a SelectLists.LegacySpedCode
			Customer's data includes a value that does not yet exist in Enrich.
	
	Will consider re-instating the DisplayInUI field for the SelectLists file		

*/

	select 
		ServiceLocationCode = isnull(k.LegacySpedCode, convert(varchar(150), k.EnrichLabel)),
		DestID = coalesce(i.ID, n.ID, t.ID, m.DestID, k.EnrichID), -- we see instances where the assumed-to-exist EnrichID did not exist in the target database (Poudre).
		Name = coalesce(i.Name, n.Name, t.Name, k.EnrichLabel), 
		Description = isnull(i.Description, t.Description),
		MedicaidLocationID = coalesce(i.MedicaidLocationID, n.MedicaidLocationID, t.MedicaidLocationID),
		StateCode = coalesce(i.StateCode, n.StateCode, t.StateCode),
		DeletedDate = case when k.EnrichID is not null then NULL when coalesce(i.ID, n.ID, t.ID) is null then NULL else coalesce(i.DeletedDate, n.DeletedDate, t.DeletedDate) end
	from LEGACYSPED.SelectLists k left join
		dbo.PrgLocation i on k.EnrichID = i.ID left join 
		dbo.PrgLocation n on k.EnrichLabel = n.Name left join 
		LEGACYSPED.MAP_PrgLocationID m on k.LegacySpedCode = m.ServiceLocationCode left join  
		dbo.PrgLocation t on m.DestID = t.ID 
	where k.Type = 'ServLoc'
GO
-- last line
