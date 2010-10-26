IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentRecordException_Find]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentRecordException_Find]
GO

CREATE PROCEDURE StudentRecordException_Find
(
	@showIgnoredExceptions bit,
	@showOnlyNewExceptions bit,
	@exceptionTypeFilterID char(1)
)
AS

SELECT
	*
FROM
	StudentRecordException
WHERE
	(@showIgnoredExceptions = 1 OR Ignore = 0) AND
	(@showOnlyNewExceptions = 0 OR FirstSeenDate >= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))) AND
	(@exceptionTypeFilterID is null OR  TypeID = @exceptionTypeFilterID)
	