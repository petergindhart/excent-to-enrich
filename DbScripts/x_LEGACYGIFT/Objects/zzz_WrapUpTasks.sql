----#include {SpedDistrictInclude}\0002-Prep_District.sql
-- above task is to update the data file location column, which was populated with bogus data in the SetupETL file.

-- declare @spedprog uniqueidentifier ; select @spedprog = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C'
-- exec Util_VerifyProgramDataAssumptions @spedprog

-- select Enabled, * from vc3etl.LoadTable where ExtractDatabase = '35612529-9F3D-4971-A3DD-90E795E39080' order by Sequence

if (not exists (select Enabled from x_LEGACYGIFT.ImportPrgSections where SectionType = 'IEP Services') -- EP services
	or
	(select Enabled from x_LEGACYGIFT.ImportPrgSections where SectionType = 'IEP Services') = 0
	)
begin

update VC3ETL.LoadTable set Enabled = 0 where ID in (
'5A9F9AAF-9EDB-458F-A8B7-9C7A1C9BC259',
'CD90E95D-A6CC-4547-9E70-945E2606B5BC',
'FFC428C9-76EB-456D-9763-A8FA1278B785',
'49CA42B9-3341-4CDA-9E25-7851F0606329',
'9AFAF185-132A-4763-8E0B-A9CD85E23B0C',
'96AB7D6B-83C3-470F-A946-DA7D043CC367',
'D83C523B-4AE7-4AFE-A326-1927026DDAFC',
'020B9CFE-0A76-4923-B861-0FFB2E83EE19',
'66EA733B-F51F-4E50-AC95-3A68124959E7'
)

end

if (not exists (select Enabled from x_LEGACYGIFT.ImportPrgSections where SectionType = 'IEP Goals') -- EP goals
	or
	(select Enabled from x_LEGACYGIFT.ImportPrgSections where SectionType = 'IEP Goals') = 0
	)
begin
update VC3ETL.LoadTable set Enabled = 0 where ID in (
'6A8B29C3-426E-4EBE-919B-A9F5538A7864',
'61F62864-634B-466E-9E05-49E7F0140246',
'81915010-8362-490A-B35B-34195F8CA87F',
'67FBBBCE-F59D-4502-806C-DD5F849CBC69',
'46A3FF82-52D9-45A0-976F-1D458FC38608',
'AE4D2FB2-DCBC-4F13-85CC-D21993C77A6C',
'3A617CBA-74A1-4792-9AAA-FA5B7878B89D',
'C28CD005-4304-4597-A2A6-6BC602BA47DF',
'3E06E409-0109-4679-976A-F8423F61AFB7',
'9FE8A8A2-5F9C-4960-B23C-144A4BC012CB',
'5B1516D1-F419-4E68-8DA6-2D774E18A113'
)
end


