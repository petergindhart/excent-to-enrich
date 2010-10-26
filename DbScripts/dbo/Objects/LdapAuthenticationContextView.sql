-- =============================================
-- Create view basic template
-- =============================================
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'LdapAuthenticationContextView')
    DROP VIEW dbo.LdapAuthenticationContextView
GO

CREATE VIEW dbo.LdapAuthenticationContextView
AS 
	SELECT
		a.*,
		UserContainer,
		SearchSubContainers,
		UserGroup
	FROM AuthenticationContextView a JOIN
		LdapAuthenticationContext l ON a.Id = l.Id
GO

