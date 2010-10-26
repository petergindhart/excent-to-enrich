IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentRecordException_SynchronizeDuplicates]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentRecordException_SynchronizeDuplicates]
GO

CREATE PROCEDURE StudentRecordException_SynchronizeDuplicates
AS

SET NOCOUNT ON

DECLARE @records table  ( searchStu uniqueidentifier, foundStu uniqueidentifier, typeid char(1))

--store off found records
INSERT @records
select 
      searchStudent = s1.ID,
      foundStudent = s2.ID, 
      typeId = 'N'
from 
      Student s1 join
      Student s2 on           
      (
            s1.FirstName= s2.FirstName and
            s1.LastName= s2.LastName and
            s1.Dob = s2.DOb AND
                  (
					(IsNull(s1.SSN,'left') <> IsNull(s2.SSN,'right')) OR
					s1.SSN = '000000000' OR 
					s2.SSN = '000000000'
                  )
      )
where
      s1.ID < s2.ID AND
        (
                  s1.IsActive = 1 OR s2.IsActive = 1
        )
            
UNION ALL

select 
      searchStudent = s1.ID,
      foundStudent = s2.ID,
      typeId = 'S'
from 
      Student s1 join
      Student s2 on
                  (IsNull(s1.SSN,'left') = IsNull(s2.SSN,'right')) AND
                  (
                      s1.FirstName= s2.FirstName OR
                              s1.LastName= s2.LastName OR
                              s1.Dob = s2.DOb               
                  )
where
      s1.ID < s2.ID  AND
      s1.SSN <> '000000000' AND s2.SSN <> '000000000' AND
        (
                  s1.IsActive = 1 OR s2.IsActive = 1
        )

DECLARE @date datetime
SET @date = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))

-- insert records that were NOT there before, this is the first time the import has detected this duplication
INSERT StudentRecordException
SELECT
	ID = newID(),
	Student1ID = rec.searchStu,
	Student2ID = rec.foundStu,
	TypeID = rec.TypeID,
	Ignore = 0,
	FirstSeenDate = @date
	 --not implemented because of performance impact of calculating degree of certainty with match
FROM
	@records rec left outer join
	StudentRecordException  sre on 
		(sre.Student1ID = rec.searchStu and sre.Student2ID = rec.foundStu) OR
		(sre.Student2ID = rec.searchStu and sre.Student1ID = rec.foundStu)
WHERE
	sre.ID is null	

--Remove records that are no longer duplicated from the table
DELETE sre
FROM
	@records rec right outer join
	StudentRecordException sre on 
		(sre.Student1ID = rec.searchStu and sre.Student2ID = rec.foundStu) OR
		(sre.Student2ID = rec.searchStu and sre.Student1ID = rec.foundStu)
WHERE
	rec.searchStu is null

-- remove records where the duplicate student 1 is also another duplicate later
DELETE sre
from StudentRecordException sre
where
	Student1ID in
	(
		select Student2ID from StudentRecordException
	)	
GO