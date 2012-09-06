--#include {SpedDistrictInclude}\0002-Prep_District.sql
-- above task is to update the data file location column, which was populated with bogus data in the SetupETL file.

declare @spedprog uniqueidentifier ; select @spedprog = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C'
exec Util_VerifyProgramDataAssumptions @spedprog


