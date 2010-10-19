
--SecurityZone_GetContextIdentifiersByUserProfileID
CREATE NONCLUSTERED INDEX IX_ClassRosterTeacherHistory_TeacherCovered
ON [dbo].[ClassRosterTeacherHistory] ([TeacherID], [ClassRosterID],[StartDate],[EndDate])

CREATE NONCLUSTERED INDEX IX_Teacher_UserProfile
ON [dbo].[Teacher] ([UserProfileID])

CREATE NONCLUSTERED INDEX IX_PrgItemTeamMember_PersonItem
ON [dbo].[PrgItemTeamMember] ([PersonID], ItemID)