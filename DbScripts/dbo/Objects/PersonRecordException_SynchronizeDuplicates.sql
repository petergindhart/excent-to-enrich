IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PersonRecordException_SynchronizeDuplicates]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PersonRecordException_SynchronizeDuplicates]
GO


CREATE PROCEDURE [dbo].[PersonRecordException_SynchronizeDuplicates]
AS

SET NOCOUNT ON

DECLARE @date datetime
SET @date = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))

DECLARE @matchedDupes table (
	studentA uniqueidentifier,
	studentB uniqueidentifier,
	MatchedOnEmail int, 
	MatchedOnPhone int, 
	MatchedOnStreet int
)

insert @matchedDupes
SELECT		
	searchStudent = p1.ID,
    foundStudent = p2.ID, 
	(case when p1.EmailAddress <> p2.EmailAddress then 0 else 1 end) AS MatchedOnEmail,
	(case when substring(p1.HomePhone, LEN(p1.HomePhone) -6,7) <> substring(p2.HomePhone, LEN(p2.HomePhone) -6,7) then 0 else 1 end) AS MatchedOnPhone,
	(case when replace(lower(p1.Street),' ','') <> replace(lower(p2.Street),' ','') then 0 else 1 end) AS MatchedOnStreet	
FROM
	Person p1 join
	Person p2 on
		p1.FirstName = p2.FirstName AND
		p1.LastName = p2.LastName AND
		(
			p1.ManuallyEntered = 1 OR p2.ManuallyEntered = 1
		) AND
		p1.ID < p2.ID left outer join
	PersonRecordException pre on
		(pre.PersonAID = p1.ID and pre.PersonBID = p2.ID) OR
		(pre.PersonBID = p1.ID and pre.PersonAID = p2.ID)
where
	pre.ID is null
	
INSERT PersonRecordException
select 
	ID = NEWID(),
	TypeID = 'D',
	ReasonID = case 
					when  MatchedOnEmail = 1 AND MatchedOnPhone = 1 AND MatchedOnStreet = 1 then 'A'
					when  MatchedOnEmail + MatchedOnStreet + MatchedOnPhone > 1 then 'M'
					when  MatchedOnEmail = 1 then 'E'
					when  MatchedOnPhone = 1 then 'H'
					when  MatchedOnStreet = 1 then 'S'
					ELSE 'N'
				END,
	0,
	@date,
	studentA,
	studentB
From 
	@matchedDupes md