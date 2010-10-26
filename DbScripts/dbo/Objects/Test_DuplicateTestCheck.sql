SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Test_DuplicateTestCheck]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Test_DuplicateTestCheck]
GO


/*
<summary>
Executes a Transact-SQL statement against Test Table 
for duplicate test based on studentid and datetaken
</summary>
<param name="test">test table to check</param>
<param name="studentID">studentID to compare</param>
<param name="dateTaken">dateTaken to compare</param>
<model returnType="System.Data.IDataReader"/>
*/
CREATE PROCEDURE dbo.Test_DuplicateTestCheck
	@test varchar(50),
	@studentID varchar(36),
	@dateTaken datetime
AS

DECLARE @statement varchar(500)

SET @statement =  'SELECT * FROM ' + @test + ' WHERE DateTaken = ''' + cast(@dateTaken as varchar(30)) + ''' AND StudentID= ''' + @studentID + ''''

exec(@statement)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

