IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_Demographics') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_Demographics
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepDemographics') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepDemographics
GO

CREATE VIEW LEGACYSPED.Transform_IepDemographics
AS
	SELECT
		iep.StudentRefID,
		DestID = m.DestID,
		PrimaryLanguageID = cast(NULL as uniqueidentifier),
		PrimaryLanguageHomeID = cast(NULL as uniqueidentifier),
		ServiceDistrictID = dss.OrgUnitID,
		ServiceSchoolID = ss.DestID,
		HomeDistrictID = dsh.OrgUnitID,
		HomeSchoolID = sh.DestID,
		InterpreterNeededID = cast(NULL as uniqueidentifier),
		LimittedEnglishProficiencyID = cast(NULL as uniqueidentifier) 
	FROM
		LEGACYSPED.Transform_PrgIep iep LEFT JOIN
		LEGACYSPED.MAP_PrgSectionID m on 
			m.DefID = '427AF47C-A2D2-47F0-8057-7040725E3D89' and
			m.VersionID = iep.VersionDestID LEFT JOIN
		LEGACYSPED.Student s on s.StudentRefID = iep.StudentRefID LEFT JOIN
		LEGACYSPED.Transform_School ss on s.ServiceSchoolRefID = ss.SchoolRefId /* and ss.DeletedDate is null */ LEFT JOIN
		LEGACYSPED.Transform_School sh on s.HomeSchoolRefID = sh.SchoolRefId /* and sh.DeletedDate is null */ LEFT JOIN
		dbo.School dss on ss.DestID = dss.ID /* and dss.ManuallyEntered = 1 */ left join
		dbo.School dsh on sh.DestID = dsh.ID /* and dsh.ManuallyEntered = 1 */
GO
--


/*


GEO.ShowLoadTables IepDemographics


set nocount on;
declare @n varchar(100) ; select @n = 'IepDemographics'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set enabled = 1
from VC3ETL.LoadTable t where t.ID = @t

update t set 
	SourceTable = 'LEGACYSPED.Transform_'+@n
	, HasMapTable = 0
	, MapTable = NULL
	, KeyField = NULL
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = NULL
	, Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.*
-- UPDATE IepDemographics SET PrimaryLanguageHomeID=s.PrimaryLanguageHomeID, HomeDistrictID=s.HomeDistrictID, PrimaryLanguageID=s.PrimaryLanguageID, InterpreterNeededID=s.InterpreterNeededID, ServiceDistrictID=s.ServiceDistrictID, HomeSchoolID=s.HomeSchoolID, LimittedEnglishProficiencyID=s.LimittedEnglishProficiencyID, ServiceSchoolID=s.ServiceSchoolID
FROM  IepDemographics d JOIN 
	LEGACYSPED.Transform_IepDemographics  s ON s.DestID=d.ID

-- INSERT IepDemographics (ID, PrimaryLanguageHomeID, HomeDistrictID, PrimaryLanguageID, InterpreterNeededID, ServiceDistrictID, HomeSchoolID, LimittedEnglishProficiencyID, ServiceSchoolID)
SELECT s.DestID, s.PrimaryLanguageHomeID, s.HomeDistrictID, s.PrimaryLanguageID, s.InterpreterNeededID, s.ServiceDistrictID, s.HomeSchoolID, s.LimittedEnglishProficiencyID, s.ServiceSchoolID
FROM LEGACYSPED.Transform_IepDemographics s
WHERE NOT EXISTS (SELECT * FROM IepDemographics d WHERE s.DestID=d.ID)


select * from IepDemographics




*/


