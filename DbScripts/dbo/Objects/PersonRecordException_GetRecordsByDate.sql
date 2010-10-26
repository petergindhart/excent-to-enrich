IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PersonRecordException_GetRecordsByDate]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PersonRecordException_GetRecordsByDate]
GO

CREATE PROCEDURE [dbo].[PersonRecordException_GetRecordsByDate]
(
	@date datetime
)
AS

SELECT
	*
FROM
	PersonRecordException
WHERE
	FirstSeenDate >= @date