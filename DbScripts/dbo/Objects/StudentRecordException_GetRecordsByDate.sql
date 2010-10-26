IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentRecordException_GetRecordsByDate]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentRecordException_GetRecordsByDate]
GO

CREATE PROCEDURE StudentRecordException_GetRecordsByDate
(
	@date	datetime
)
AS

SELECT
	*
FROM
	StudentRecordException
WHERE
	FirstSeenDate >= @date