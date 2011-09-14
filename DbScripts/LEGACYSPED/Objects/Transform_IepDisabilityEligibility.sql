--#include Transform_IepDisability.sql

-- ############################################################################# 
-- IepDisabilityEligibility
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepDisabilityEligibilityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepDisabilityEligibilityID 
(
	IepRefID varchar(150) not  null,
	DisabilityID	uniqueidentifier not null,
	DestID	uniqueidentifier not null
)
ALTER TABLE LEGACYSPED.MAP_IepDisabilityEligibilityID ADD CONSTRAINT
PK_MAP_IepDisabilityEligibilityID PRIMARY KEY CLUSTERED
(
	IepRefID, DisabilityID
)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.StudentDisabilityPivot') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.StudentDisabilityPivot
GO

create view LEGACYSPED.StudentDisabilityPivot
as
	select StudentRefID, DisabilityCode, DisabSeq = min(DisabSeq) -- avoid duplicate disabilities
	from (
		select StudentRefID, DisabilityCode = Disability1Code, DisabSeq = cast(1 as int) from LEGACYSPED.Student
		union all
		select StudentRefID, DisabilityCode = Disability2Code, 2 from LEGACYSPED.Student where Disability2Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability3Code, 3 from LEGACYSPED.Student where Disability3Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability4Code, 4 from LEGACYSPED.Student where Disability4Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability5Code, 5 from LEGACYSPED.Student where Disability5Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability6Code, 6 from LEGACYSPED.Student where Disability6Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability7Code, 7 from LEGACYSPED.Student where Disability7Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability8Code, 8 from LEGACYSPED.Student where Disability8Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability9Code, 9 from LEGACYSPED.Student where Disability9Code is not null
		) d
	group by StudentRefID, DisabilityCode
go



IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepDisabilityEligibility') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepDisabilityEligibility
GO

CREATE VIEW LEGACYSPED.Transform_IepDisabilityEligibility
AS
	SELECT
		iep.IepRefID,
		DestID = me.DestID,
		InstanceID = m.DestID, 
		DisabilityID = d.DestID, 
		Sequence = (select count(*)+1 from LEGACYSPED.StudentDisabilityPivot where StudentRefID = s.StudentRefID and DisabSeq < s.DisabSeq),
		IsEligibileID = 'B76DDCD6-B261-4D46-A98E-857B0A814A0C', -- Only Eligible disabilities provided  
		FormInstanceID = cast(NULL as uniqueidentifier) -- select iep.ieprefid
	FROM
		LEGACYSPED.Transform_PrgIep iep JOIN
		LEGACYSPED.MAP_PrgSectionID m on 
			m.DefID = 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A' and
			m.VersionID = iep.VersionDestID JOIN
		dbo.IepEligibilityDetermination ed on m.DestID = ed.ID JOIN -- Only purpose is to ensure that this record exists.  
		LEGACYSPED.StudentDisabilityPivot s on iep.StudentRefID = s.StudentRefID JOIN
		LEGACYSPED.Transform_IepDisability d on s.DisabilityCode = d.DisabilityCode left join
		LEGACYSPED.MAP_IepDisabilityEligibilityID me on 
			iep.IepRefID = me.IepRefID and
			d.DestID = me.DisabilityID

		--LEGACYSPED.Student s on s.StudentRefID = iep.StudentRefID JOIN
		--(
		--	select StateCode, DestID, hack.Sequence
		--	FROM
		--	LEGACYSPED.Transform_IepDisability CROSS JOIN
		--	(
		--		select 1 Sequence union
		--		select 2 Sequence union
		--		select 3 Sequence union
		--		select 4 Sequence union
		--		select 5 Sequence union
		--		select 6 Sequence union
		--		select 7 Sequence union
		--		select 8 Sequence union
		--		select 9 Sequence 
		--	) hack
		--) d ON
		--	(s.Disability1Code = d.StateCode and d.Sequence = 1) OR
		--	(s.Disability2Code = d.StateCode and d.Sequence = 2) OR
		--	(s.Disability3Code = d.StateCode and d.Sequence = 3) OR
		--	(s.Disability4Code = d.StateCode and d.Sequence = 4) OR
		--	(s.Disability5Code = d.StateCode and d.Sequence = 5) OR
		--	(s.Disability6Code = d.StateCode and d.Sequence = 6) OR
		--	(s.Disability7Code = d.StateCode and d.Sequence = 7) OR
		--	(s.Disability8Code = d.StateCode and d.Sequence = 8) OR
		--	(s.Disability9Code = d.StateCode and d.Sequence = 9) 
GO
--

/*


GEO.ShowLoadTables IepDisabilityEligibility

set nocount on;
declare @n varchar(100) ; select @n = 'IepDisabilityEligibility'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set enabled = 1
from VC3ETL.LoadTable t where t.ID = @t


	SourceTable = 'LEGACYSPED.Transform_'+@n
	, ImportType = 1 -- used to be 2
	, HasMapTable = 1
	, MapTable = 'LEGACYSPED.MAP_IepDisabilityEligibilityID '
	, KeyField = 'IepRefID, DisabilityID'
-- per Pete, after I made the ItemID part of the PK for MAP:      you'll need to avoid deleting sections for subsequent revisions of your converted IEPs though, right?
	--, DeleteKey = NULL
	--, DeleteTrans = 1
	, DeleteKey = 'DestID'
	, DeleteTrans = 1
	, UpdateTrans = 0
	, DestTableFilter = 'InstanceID in (select DestID from LEGACYSPED.Map_PrgSectionID)'
	, Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n

-- import type is 2

select d.*
-- DELETE LEGACYSPED.MAP_IepDisabilityEligibilityID 
FROM LEGACYSPED.Transform_IepDisabilityEligibility AS s RIGHT OUTER JOIN 
	LEGACYSPED.MAP_IepDisabilityEligibilityID  as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

-- INSERT LEGACYSPED.MAP_IepDisabilityEligibilityID 
SELECT IepRefID, DisabilityID, NEWID()
FROM LEGACYSPED.Transform_IepDisabilityEligibility s
WHERE NOT EXISTS (SELECT * FROM IepDisabilityEligibility d WHERE s.DestID=d.ID)

-- INSERT IepDisabilityEligibility (ID, InstanceID, FormInstanceID, IsEligibileID, DisabilityID, Sequence)
SELECT s.DestID, s.InstanceID, s.FormInstanceID, s.IsEligibileID, s.DisabilityID, s.Sequence
FROM LEGACYSPED.Transform_IepDisabilityEligibility s
WHERE NOT EXISTS (SELECT * FROM IepDisabilityEligibility d WHERE s.DestID=d.ID)


select * from IepDisabilityEligibility


select * from LEGACYSPED.Transform_IepDisability where DestID = '990188A8-AB86-4513-8A12-6EEDB1CE3A7C' -- not applicable! 

select * from IepDisabilityEligibility where DisabilityID = '990188A8-AB86-4513-8A12-6EEDB1CE3A7C'


*/


