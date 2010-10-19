-- cascade delete IepServiceProvider
ALTER TABLE dbo.IepServiceProvider
	DROP CONSTRAINT FK_IepService#Providers
GO
ALTER TABLE dbo.IepServiceProvider
	DROP CONSTRAINT FK_UserProfile#AssignedServices
GO
ALTER TABLE dbo.IepServiceProvider ADD CONSTRAINT
	FK_UserProfile#AssignedServices FOREIGN KEY
	(
	UserProfileID
	) REFERENCES dbo.UserProfile
	(
	ID
	) ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.IepServiceProvider ADD CONSTRAINT
	FK_IepService#Providers FOREIGN KEY
	(
	ServiceID
	) REFERENCES dbo.IepService
	(
	ID
	) ON DELETE  CASCADE
GO
