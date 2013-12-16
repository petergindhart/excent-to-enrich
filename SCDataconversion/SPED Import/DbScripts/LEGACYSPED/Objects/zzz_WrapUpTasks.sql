--#include {SpedDistrictInclude}\0002-Prep_District.sql
-- above task is to update the data file location column, which was populated with bogus data in the SetupETL file.

declare @spedprog uniqueidentifier ; select @spedprog = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C'
exec Util_VerifyProgramDataAssumptions @spedprog

-- select Enabled, * from vc3etl.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' order by Sequence

if (select count(*) from LEGACYSPED.MAP_ServiceFrequencyID) = 0
update VC3ETL.LoadTable set Enabled = 0 where ID = '28B98FE4-A7FF-42BE-AC0D-A05A728BBDB8' -- service frequency (re-think this later)

if (select Enabled from legacysped.ImportPrgSections where SectionDefID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F') = 0 -- services
begin

update VC3ETL.LoadTable set Enabled = 0 where ID in (
'0CFF91D7-4E85-46D7-AAF2-75A217AA7EDD',
'AB30ABAF-BA87-476C-95A0-206B63086B99',
'3D563C09-1DE4-4C36-8737-B54797B1D854',
'7A51CCC5-42ED-46B1-8ECC-820A8269006F',
'750CBA2A-CE1F-4653-9E43-9A450EAC3653',
'6DFDE603-5718-43F4-9B89-A0CA584640D2',
'015973B8-D4AC-40DF-B4FF-E8CBD787B8E8',
'8CF3EE0F-0A3B-4C16-8489-F43C011E94B1',
'BC3F2841-10B3-4D1A-9617-9230DC792F74' 
)

end

if (select Enabled from legacysped.ImportPrgSections where SectionDefID = '84E5A67D-CC9A-4D5B-A7B8-C04E8C3B8E0A') = 0 -- goals
begin

update VC3ETL.LoadTable set Enabled = 0 where ID in (
'78D7C5C4-DC7B-4443-BD00-297742CF435B',
'693C1715-6AE2-4E99-9CB2-687AF033F3B5',
'D3E7D208-362C-43BA-8903-DED80EEFA8E7',
'5A82CC4C-1687-4DAC-87C9-BB90830E055F',
'0EC64939-DEC1-4D0F-BC24-5767BCC85507',
'8AE59FB0-6BC1-4133-B6C4-A169CC1E6BF7',
'E4C145A9-8B79-41A5-823A-31ADBC4DBCA3',
'86F0BBBB-7DF6-47D3-AD4F-A979AC5C1E6D',
'1D683708-D043-4CE3-8427-E5E9AD0D6256',
'F0466D17-5566-46CF-8C9A-23812C86614F',
'E3D9165D-BB98-4AFA-AFEC-24BB833B8EC5'
)
end


