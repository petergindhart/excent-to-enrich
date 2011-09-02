-- All states, all districts
-- #############################################################################
-- Disability
IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_IepDisabilityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_IepDisabilityID
	(
	DisabilityCode nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 

ALTER TABLE AURORAX.MAP_IepDisabilityID ADD CONSTRAINT
	PK_MAP_IepDisabilityID PRIMARY KEY CLUSTERED
	(
	DisabilityCode
	)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_IepDisability]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_IepDisability]
GO

CREATE VIEW [AURORAX].[Transform_IepDisability]
AS
/*
	This view depends on dbo.IepDisability.StateCode being populated with the proper code.  
	This view will work in :  All states, all districts.
	IepDisability is maintained in the Template database and exported with the Template configuration.
		The code to update IepDisability.StateCode should be contained in file 0001a-ETLPrep_State_[StateAbbr].sql
	The MAP table will contain only those records that are not a match on state-code.

	Table Aliases:  k for Lookups, s for StateCode, m for Map, t for Target
	
*/
	SELECT
		DisabilityCode = k.Code,
		DestID = coalesce(s.ID, t.ID, m.DestID), -- below this line it may not be necessary to use coalesce because we are only updating legacy data (use VC3ETL.LoadTable.DestTableFilter)
		Name = k.Label, 
		Definition = coalesce(s.Definition, t.Definition,''),
		DeterminationFormTemplateID = isnull(s.DeterminationFormTemplateID, t.DeterminationFormTemplateID),
		StateCode = k.StateCode,
		DeletedDate = 
			CASE 
				WHEN s.ID IS NOT NULL THEN NULL -- Always show in UI where there is a StateID.  Period.
				ELSE 
					CASE WHEN k.DisplayInUI = 'Y' THEN NULL -- User specified they want to see this in the UI.  Let them.
					ELSE GETDATE()
					END
			END -- a benefit of this is that if a Disability record is absent in a subsequent legacy data import, the record will not be deleted, but DeletedDate will be set.  Cool.
	FROM
		AURORAX.Lookups k LEFT JOIN
		dbo.IepDisability s on isnull(k.StateCode,'kDisab') = isnull(s.StateCode,'sDisab') left join -- two NULLs does not a match make
		AURORAX.MAP_IepDisabilityID m on k.Code = m.DisabilityCode left join
		dbo.IepDisability t on m.DestID = t.ID 
	WHERE
		k.Type = 'Disab' 
GO


/*


GEO.ShowLoadTables IepDisability


set nocount on;
declare @n varchar(100) ; select @n = 'IepDisability'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	HasMapTable = 1, 
	MapTable = 'AURORAX.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'DisabilityCode'
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = 's.DestID in (select DestID from AURORAX.MAP_IepDisabilityID)'
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.*
-- UPDATE IepDisability SET Definition=s.Definition, DeletedDate=s.DeletedDate, Name=s.Name, DeterminationFormTemplateID=s.DeterminationFormTemplateID, StateCode=s.StateCode
FROM  IepDisability d JOIN 
	AURORAX.Transform_IepDisability  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from AURORAX.MAP_IepDisabilityID)

-- INSERT AURORAX.MAP_IepDisabilityID
SELECT DisabilityCode, NEWID()
FROM AURORAX.Transform_IepDisability s
WHERE NOT EXISTS (SELECT * FROM IepDisability d WHERE s.DestID=d.ID)

-- INSERT IepDisability (ID, Definition, DeletedDate, Name, DeterminationFormTemplateID, StateCode)
SELECT s.DestID, s.Definition, s.DeletedDate, s.Name, s.DeterminationFormTemplateID, s.StateCode
FROM AURORAX.Transform_IepDisability s
WHERE NOT EXISTS (SELECT * FROM IepDisability d WHERE s.DestID=d.ID)


select * from IepDisability





*/





