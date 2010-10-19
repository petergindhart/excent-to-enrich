ALTER TABLE dbo.IepAccomodation
	DROP CONSTRAINT FK_IepAccomodation#Instance#Items
GO
ALTER TABLE dbo.IepAccomodation WITH NOCHECK ADD CONSTRAINT
	FK_IepAccomodation#Instance#Items FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepAccomodations
	(
	ID
	) ON DELETE  CASCADE 
	
GO


ALTER TABLE dbo.IepGoalProgress
	DROP CONSTRAINT FK_IepGoalProgress#Goal#ProgressReports
GO
ALTER TABLE dbo.IepGoalProgress ADD CONSTRAINT
	FK_IepGoalProgress#Goal#ProgressReports FOREIGN KEY
	(
	GoalID
	) REFERENCES dbo.IepGoal
	(
	ID
	) ON DELETE  CASCADE 
GO
