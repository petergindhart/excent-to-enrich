-- =============================================

IF object_id(N'dbo.UserProfileView', 'V') IS NOT NULL
	DROP VIEW dbo.UserProfileView
GO

CREATE VIEW dbo.UserProfileView AS
SELECT
		up.*,
		p.FirstName, p.LastName, p.EmailAddress, p.TypeID, 
		p.Street,
		p.City,
		p.Zip,
		p.State,
		p.HomePhone,
		p.WorkPhone,
		p.CellPhone,
		p.ManuallyEntered,
		p.Agency,
		p.Title
	FROM
		UserProfile up join
		Person p on p.ID = up.ID
