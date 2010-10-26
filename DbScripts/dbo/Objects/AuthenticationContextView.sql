-- =============================================
-- Create view basic template
-- =============================================
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'AuthenticationContextView')
    DROP VIEW dbo.AuthenticationContextView
GO

CREATE VIEW dbo.AuthenticationContextView
AS 
	SELECT
		c.*,
		s.TypeID 
	FROM 
		AuthenticationContext c JOIN
		AuthenticationService s ON c.ServiceID = s.Id
GO