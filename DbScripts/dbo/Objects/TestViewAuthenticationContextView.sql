-- =============================================
-- Create view basic template
-- =============================================
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'TestViewAuthenticationContextView')
    DROP VIEW dbo.TestViewAuthenticationContextView
GO

CREATE VIEW dbo.TestViewAuthenticationContextView
AS 
	SELECT *
	FROM AuthenticationContextView
	WHERE TypeID = 'T'
GO