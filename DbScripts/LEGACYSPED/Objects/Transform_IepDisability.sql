-- All states, all districts
-- #############################################################################
-- Disability
IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepDisabilityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepDisabilityID
	(
	DisabilityCode nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 

ALTER TABLE LEGACYSPED.MAP_IepDisabilityID ADD CONSTRAINT
	PK_MAP_IepDisabilityID PRIMARY KEY CLUSTERED
	(
	DisabilityCode
	)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepDisability') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepDisability
GO

CREATE VIEW LEGACYSPED.Transform_IepDisability
AS
/*
	This view depends on dbo.IepDisability.StateCode being populated with the proper code.  
	This view will work in :  All states, all districts.
	IepDisability is maintained in the Template database and exported with the Template configuration.
		The code to update IepDisability.StateCode should be contained in file 0001a-ETLPrep_State_StateAbbr.sql
	The MAP table will contain only those records that are not a match on state-code.

	Table Aliases:  k for SelectLists, s for StateCode, m for Map, t for Target
	
*/
	SELECT
		DisabilityCode = ISNULL(k.LegacySpedCode,CONVERT(varchar(150), k.EnrichLabel)),
		DestID = coalesce(s.ID, t.ID, k.EnrichID, m.DestID), -- below this line it may not be necessary to use coalesce because we are only updating legacy data (use VC3ETL.LoadTable.DestTableFilter)
		Name = coalesce(s.name, t.name, k.EnrichLabel), 
		Definition = coalesce(s.Definition, t.Definition,''),
		DeterminationFormTemplateID = isnull(s.DeterminationFormTemplateID, t.DeterminationFormTemplateID),
		StateCode = coalesce(s.StateCode, t.StateCode, k.StateCode),
		DeletedDate = 
			CASE 
				WHEN s.ID IS NOT NULL THEN s.DeletedDate 
				WHEN t.ID IS NOT NULL then t.DeletedDate
					-- CASE WHEN k.DisplayInUI = 'Y' THEN NULL -- User specified they want to see this in the UI.  Let them.
				ELSE NULL
			END,
		IsOutOfState = cast(0 as bit)
	FROM
		LEGACYSPED.SelectLists k LEFT JOIN
		dbo.IepDisability s on isnull(k.StateCode,'kDisab') = isnull(s.StateCode,'sDisab') left join -- two NULLs does not a match make
		LEGACYSPED.MAP_IepDisabilityID m on k.LegacySpedCode = m.DisabilityCode left join
		dbo.IepDisability t on m.DestID = t.ID 
	WHERE
		k.Type = 'Disab' 
GO


/*

select * from LEGACYSPED.MAP_IepDisabilityID 


delete LEGACYSPED.MAP_IepDisabilityID 


select * from VC3ETL.LoadTable where DestTable = 'IepDisability'

select * from LEGACYSPED.SelectLIsts where type = 'Disab'




vc3etl.loadtable_run 'C258B587-87B6-40FA-83DB-946C55D48482', '', 1, 0

select s.*
-- UPDATE IepDisability SET Definition=s.Definition, DeletedDate=s.DeletedDate, Name=s.Name, DeterminationFormTemplateID=s.DeterminationFormTemplateID, IsOutOfState=s.IsOutOfState, StateCode=s.StateCode
FROM  IepDisability d JOIN 
	LEGACYSPED.Transform_IepDisability  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from LEGACYSPED.MAP_IepDisabilityID)

UPDATE STATISTICS IepDisability


INSERT LEGACYSPED.MAP_IepDisabilityID
SELECT DisabilityCode, NEWID()
FROM LEGACYSPED.Transform_IepDisability s
WHERE NOT EXISTS (SELECT * FROM IepDisability d WHERE s.DestID=d.ID)

UPDATE STATISTICS LEGACYSPED.MAP_IepDisabilityID

INSERT IepDisability (ID, Definition, DeletedDate, Name, DeterminationFormTemplateID, IsOutOfState, StateCode)
SELECT s.DestID, s.Definition, s.DeletedDate, s.Name, s.DeterminationFormTemplateID, s.IsOutOfState, s.StateCode
FROM LEGACYSPED.Transform_IepDisability s
WHERE NOT EXISTS (SELECT * FROM IepDisability d WHERE s.DestID=d.ID)

UPDATE STATISTICS IepDisability







*/





