-- =============================================
-- Create view basic template
-- =============================================
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'TestViewAuthenticationServiceView')
    DROP VIEW dbo.TestViewAuthenticationServiceView
GO

CREATE VIEW dbo.TestViewAuthenticationServiceView
AS 
	SELECT * 
	FROM AuthenticationService
	WHERE TypeID = 'T'
GO

