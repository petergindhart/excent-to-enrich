
IF  EXISTS (SELECT 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'AURORAX' and o.name = 'MAP_SpedStaffMemberView')
	DROP VIEW AURORAX.MAP_SpedStaffMemberView
GO

CREATE VIEW AURORAX.MAP_SpedStaffMemberView
AS

	SELECT
		staff.SpedStaffRefID,
		UserProfileID = u.ID
	FROM
		AURORAX.SpedStaffMember staff JOIN
		Person p on p.EmailAddress = staff.Email JOIN
		UserProfile u on u.ID = p.ID JOIN
		(
		select pd.EmailAddress
		from Person pd
		where pd.ID = (
			select top 1 p1.ID
			from Person p1
			where p1.EmailAddress = pd.EmailAddress
			and p1.Deleted is null
			and p1.TypeID = 'U'
			and p1.EmailAddress is not null
			order by pd.ManuallyEntered
			)
		group by pd.EmailAddress
		) single_match ON p.EmailAddress = single_match.EmailAddress
GO
--

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_PrgItemTeamMember') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_PrgItemTeamMember
GO

CREATE VIEW AURORAX.Transform_PrgItemTeamMember
AS
	SELECT
		ItemID = iep.DestID,
		ResponsibilityID = u.PrgResponsibilityID,
		IsPrimary = CASE WHEN team.IsCaseManager = 'Y' THEN 1 ELSE 0 END,
		MtgAbsent = CAST(0 AS BIT),
		PersonID = u.ID,
		Agency = NULL,
		ExcusalFormId = CAST(NULL as uniqueidentifier)
	FROM
		AURORAX.Transform_PrgIep iep JOIN
		AURORAX.TeamMember team on team.StudentRefId = iep.StudentRefID JOIN
		AURORAX.MAP_SpedStaffMemberView staff on staff.SpedStaffRefID = team.SpedStaffRefId JOIN
		UserProfile u on u.ID = staff.UserProfileID
GO
--



/*





E18B4C88-951D-4558-9B6A-7388AF354449	11	0	AURORAX.Transform_PrgItemTeamMember	PrgItemTeamMember	0	NULL	NULL	NULL	1	0	1	NULL	ItemID in (select DestID from AURORAX.MAP_IepRefID)	NULL	2011-08-03 17:25:50.000	NULL	29D14961-928D-4BEE-9025-238496D144C6	2	0	0



-- note that the import type is 2


GEO.ShowLoadTables PrgItemTeamMember


set nocount on;
declare @n varchar(100) ; select @n = 'PrgItemTeamMember'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t

update t set 
	SourceTable = 'AURORAX.Transform_'+@n
	, HasMapTable = 0
	, MapTable = NULL
	, KeyField = NULL
	, DeleteKey = NULL -- we are deleting and the delete key is null?
	, DeleteTrans = 1
	, UpdateTrans = 0
	, DestTableFilter = 'ItemID in (select DestID from AURORAX.MAP_IepRefID)'
	, Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n

select *
-- DELETE 
FROM PrgItemTeamMember
 WHERE ItemID in (select DestID from AURORAX.MAP_IepRefID)

-- INSERT PrgItemTeamMember (ID, ResponsibilityID, ItemID, ExcusalFormId, Agency, PersonID, MtgAbsent, IsPrimary)
SELECT NEWID(), s.ResponsibilityID, s.ItemID, s.ExcusalFormId, s.Agency, s.PersonID, s.MtgAbsent, s.IsPrimary
FROM AURORAX.Transform_PrgItemTeamMember s


select * from PrgItemTeamMember







*/