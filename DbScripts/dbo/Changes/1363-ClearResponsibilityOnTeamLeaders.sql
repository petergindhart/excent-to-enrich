UPDATE PrgItemTeamMember
SET ResponsibilityID = null
where IsPrimary = 1 and ResponsibilityID is not null

UPDATE PrgInvolvementTeamMember
SET ResponsibilityID = null
where IsPrimary = 1 and ResponsibilityID is not null

EXEC sp_rename 'Program.AllowProgramLevelTeams', 'UseProgramLevelTeams'

ALTER TABLE PrgSchoolTeamMember
DROP COLUMN SelectedForNewItems