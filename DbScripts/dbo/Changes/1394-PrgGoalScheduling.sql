-- Add reference from PrgGoal->ProbeSchedule
ALTER TABLE dbo.PrgGoal ADD
	ProbeScheduleID uniqueidentifier NULL
GO
ALTER TABLE dbo.PrgGoal ADD CONSTRAINT
	FK_PrgGoal#ProbeSchedule# FOREIGN KEY
	(
	ProbeScheduleID
	) REFERENCES dbo.ProbeSchedule
	(
	ID
	) ON DELETE CASCADE
GO