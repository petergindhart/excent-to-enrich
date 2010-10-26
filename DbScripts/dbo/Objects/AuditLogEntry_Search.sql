SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AuditLogEntry_Search]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AuditLogEntry_Search]
GO



/*
<summary>
Gets a list of audit log entries for a user sorted
by EventTime descending
</summary>
<param name="userProfileID">Matches audit log entries based on used id</param>
<param name="orderBy">Order by clause</param>
<param name="limit">Limits the number of matches</param>
<returns>List of matching audit log entries</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.AuditLogEntry_Search
	@userProfileID UNIQUEIDENTIFIER,
	@orderBy VARCHAR(100),
	@limit INT = NULL
AS
	DECLARE @sql VARCHAR(8000)

	IF @userProfileID IS NULL AND @orderBy IS NULL AND @limit IS NULL
		SELECT TOP 0 * FROM AuditLogEntry
	ELSE
	BEGIN
		IF @limit IS NULL
			SET @sql = 	'SELECT *'
		ELSE
			SET @sql = 	'SELECT TOP ' + CAST(@limit AS VARCHAR(10)) +' *'
	
		SET @sql = @sql + ' FROM AuditLogEntry'
	
		IF @userProfileID IS NOT NULL
			SET @sql = @sql + ' WHERE UserProfileID = ''' + CAST(@userProfileID AS VARCHAR(36)) + ''''
	
		SET @sql = @sql + ' order by ' + ISNULL(dbo.Clean( @orderBy, NULL ), 'EventTime DESC')
	
		EXEC(@sql)
	END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

