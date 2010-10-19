ALTER TABLE dbo.PrgMeetingExcusal
DROP CONSTRAINT FK_PrgMeetingExcusal#Form#
GO

ALTER TABLE dbo.PrgMeetingExcusal
ADD CONSTRAINT FK_PrgMeetingExcusal#Form#Excusals
FOREIGN KEY(FormID) REFERENCES dbo.PrgItemForm(ID)
GO
