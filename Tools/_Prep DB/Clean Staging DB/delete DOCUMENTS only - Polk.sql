




delete a
-- select a.* 
from x_LEGACYDOC.MAP_AttachmentID m 
join Attachment a on m.DestID = a.ID -- 6174

delete f
-- select m.* 
from x_LEGACYDOC.MAP_FileDataID m 
join dbo.FileData f on m.DestID = f.ID -- 81949

drop table x_LEGACYDOC.MAP_AttachmentID 
drop table x_LEGACYDOC.MAP_FileDataID 


-- compile the new x_LEGACYDOC transforms


/*				RUN THE FOLLOWING LoadTable queries

select * from vc3etl.loadtable where ExtractDatabase = '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16'

vc3etl.loadtable_run 'BD05E043-13D4-4250-85E2-D2976EDAB08F', '', 1, 0


begin tran
DELETE x_LEGACYDOC.MAP_FileDataID
FROM x_LEGACYDOC.Transform_FileData AS s RIGHT OUTER JOIN 
	x_LEGACYDOC.MAP_FileDataID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

UPDATE STATISTICS x_LEGACYDOC.MAP_FileDataID


INSERT x_LEGACYDOC.MAP_FileDataID -- select * from  x_LEGACYDOC.MAP_FileDataID
SELECT DocumentRefID, StudentRefID, DocumentType, NEWID()
FROM x_LEGACYDOC.Transform_FileData s
WHERE NOT EXISTS (SELECT * FROM FileData d WHERE s.DestID=d.ID)

UPDATE STATISTICS x_LEGACYDOC.MAP_FileDataID

INSERT FileData (ID, Content, ReceivedDate, MimeType, OriginalName, isTemporary)
SELECT s.DestID, s.Content, s.ReceivedDate, s.MimeType, s.OriginalName, s.isTemporary
FROM x_LEGACYDOC.Transform_FileData s
WHERE NOT EXISTS (SELECT * FROM FileData d WHERE s.DestID=d.ID)

UPDATE STATISTICS FileData

------------------------------------------------------------------------------------------------------------------------

DELETE x_LEGACYDOC.MAP_AttachmentID
FROM x_LEGACYDOC.Transform_Attachment AS s RIGHT OUTER JOIN 
	x_LEGACYDOC.MAP_AttachmentID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

UPDATE STATISTICS x_LEGACYDOC.MAP_AttachmentID


INSERT x_LEGACYDOC.MAP_AttachmentID
SELECT DocumentRefID, StudentRefID, DocumentType, NEWID()
FROM x_LEGACYDOC.Transform_Attachment s
WHERE NOT EXISTS (SELECT * FROM Attachment d WHERE s.DestID=d.ID)

UPDATE STATISTICS x_LEGACYDOC.MAP_AttachmentID

INSERT Attachment (ID, VersionID, UploadUserID, Label, FileID, ItemID, StudentID)
SELECT s.DestID, s.VersionID, s.UploadUserID, s.Label, s.FileID, s.ItemID, s.StudentID
FROM x_LEGACYDOC.Transform_Attachment s
WHERE NOT EXISTS (SELECT * FROM Attachment d WHERE s.DestID=d.ID)


UPDATE STATISTICS Attachment


rollback


commit




--(0 row(s) affected)

--(81938 row(s) affected)
--Msg 547, Level 16, State 0, Line 17
--The INSERT statement conflicted with the FOREIGN KEY constraint "FK_Attachment#Student#Attachments". The conflict occurred in database "Enrich_DC3_FL_Polk", table "dbo.Student", column 'ID'.
--The statement has been terminated.


*/


select f.StudentID, s.Number, count(*) tot
from Attachment f
join Student s on f.StudentID = s.ID
join PrgItem i on s.ID = i.StudentID and i.DefID = '69942840-0E78-498D-ADE3-7454F69EA178'
left join (
	select t.StudentID, t.Label
	from Attachment t
	group by t.StudentID, t.Label
	having count(*) > 1
	) u on f.StudentID = u.StudentID and f.Label = u.Label 
where u.StudentID is null
and exists (														-- change to Not exists to see examples of students with only GIFTED plan
	select 1 
	from PrgItem iep
	where f.StudentID = iep.StudentID and iep.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
	)
group by f.StudentID, s.Number
having count(*) > 1
order by tot desc



