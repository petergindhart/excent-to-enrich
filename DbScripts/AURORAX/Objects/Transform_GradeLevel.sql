-- use in all states, all districts.
-- #############################################################################
-- GradeLevel
IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_GradeLevelID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_GradeLevelID
	(
	GradeLevelCode nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 

ALTER TABLE AURORAX.MAP_GradeLevelID ADD CONSTRAINT
	PK_MAP_GradeLevelID PRIMARY KEY CLUSTERED
	(
	GradeLevelCode
	)
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_GradeLevel') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_GradeLevel
GO

CREATE VIEW AURORAX.Transform_GradeLevel 
AS
/*
	This view depends on GradeLevel.StateCode (the state reporting code) being populated in the target table.  
		The code to populate GradeLevel.StateCode should be contained in file 0001a-ETLPrep_State_[StateAbbr].sql
		The fact that we are returning rows where a StateCode match exists between Lookups and Target ensures that we don't duplicate these values in Target.
	Table Aliases:  k for Lookups, s for StateCode, m for Map, t for Target
	
*/
	SELECT
		GradeLevelCode = k.Code,
		DestID = coalesce(s.ID, t.ID, m.DestID), -- may not need to use coalesce below this line because we only touch legacy data
		Name = coalesce(s.Name, t.Name, left(k.Label, 10)),
		StateCode = k.StateCode,
		Bitmask = coalesce(s.Bitmask, t.Bitmask, NULL),
		Sequence = coalesce(s.Sequence, t.Sequence, 99),
		-- Active = coalesce(s.Active, t.Active, 0),
		Active = 
			CASE 
				WHEN s.ID IS NOT NULL THEN 1 -- Always show in UI where there is a StateID.  Period.
				ELSE 
					CASE WHEN k.DisplayInUI = 'Y' THEN 1 -- User specified they want to see this in the UI.  Let them.
					ELSE 0
					END
			END -- a benefit of this is that if a Disability record is absent in a subsequent legacy data import, the record will not be deleted, but Active will be set to 0.  Cool.
	FROM
		AURORAX.Lookups k LEFT JOIN
		GradeLevel s on isnull(k.StateCode, 'kGradeLevel') = isnull(s.StateCode, 'tGradeLevel') LEFT JOIN 
		AURORAX.MAP_GradeLevelID m on k.Code = m.GradeLevelCode LEFT JOIN
		GradeLevel t on m.DestID = t.ID
	WHERE
		k.Type = 'Grade' 
GO


/*


GEO.ShowLoadTables GradeLevel


set nocount on;
declare @n varchar(100) ; select @n = 'GradeLevel'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	HasMapTable = 1, 
	MapTable = 'AURORAX.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'GradeLevelCode'
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = 's.DestID in (select DestID from AURORAX.MAP_GradeLevelID)'
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n

select d.*
-- UPDATE GradeLevel SET Active=(0), BitMask=(NULL), Sequence=(99), Name=s.Name
FROM  GradeLevel d JOIN 
	AURORAX.Transform_GradeLevel  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from AURORAX.MAP_GradeLevelID)

-- INSERT AURORAX.MAP_GradeLevelID
SELECT GradeLevelCode, NEWID()
FROM AURORAX.Transform_GradeLevel s
WHERE NOT EXISTS (SELECT * FROM GradeLevel d WHERE s.DestID=d.ID)

-- INSERT GradeLevel (ID, Active, BitMask, Sequence, Name)
SELECT s.DestID, (0), (NULL), (99), s.Name
FROM AURORAX.Transform_GradeLevel s
WHERE NOT EXISTS (SELECT * FROM GradeLevel d WHERE s.DestID=d.ID)

select * from GradeLevel


*/

