if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Teacher_GetRecordsBySearchText]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Teacher_GetRecordsBySearchText]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
<summary>
Gets records from the Teacher table that match the specified search text
</summary>
<param name="searchText"></param>
<returns>List of matching teachers</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Teacher_GetRecordsBySearchText]
	@searchText VARCHAR(100)
AS
	declare @searchTextNormal varchar(250)
	set @searchTextNormal = Replace(Replace(ltrim(rtrim(@searchText)), ',', ' '), '-', ' ')

	declare @searchTextPattern varchar(250)
	set @searchTextPattern = '%' + Replace(dbo.Clean(@searchTextNormal, '\'), ' ', '% ') + '%'

	SELECT 
		* 
	FROM 
		Teacher t 
	WHERE 
		(t.FirstName + ' ' + t.LastName LIKE @searchTextPattern ESCAPE '\')
	ORDER BY 
		t.LastName, t.FirstName

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
