-- =============================================
-- Create view basic template
-- =============================================
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'LdapAuthenticationServiceView')
    DROP VIEW dbo.LdapAuthenticationServiceView
GO

CREATE VIEW dbo.LdapAuthenticationServiceView
AS 
	SELECT a.*,
		Server,
		Username,
		Password,
		SchemaTypeID,
		UseEncryption
	FROM
		AuthenticationService a INNER JOIN
		LdapAuthenticationService l ON a.ID = l.ID
GO
