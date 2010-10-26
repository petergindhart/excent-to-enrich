/****** Object:  StoredProcedure [dbo].[UserProfile_UpdateUserNames]    Script Date: 08/04/2009 09:15:45 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[UserProfile_UpdateUserNames]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[UserProfile_UpdateUserNames]

GO
 /*
<summary>
Updates a record in the Absence table with the specified values
</summary>
<param name="find">Pattern to replace</param>
<param name="replace">New text</param>
<model isGenerated="false" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[UserProfile_UpdateUserNames]
	@find varchar(300), 
	@replace varchar(300)
AS
	UPDATE UserProfile
	SET
		UserName = Replace(UserName, @find, @replace)
	WHERE 
		Deleted is null and
		UserName like '%' + @find + '%'
GO


