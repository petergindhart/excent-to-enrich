DECLARE @probeScoreCategoryID uniqueidentifier 
SET @probeScoreCategoryID = 'EF43FCEC-9334-413F-A89D-E25BB1F279F1'

UPDATE SecurityTaskCategory
SET Name = 'Manage Probe Scores'
WHERE ID = @probeScoreCategoryID

UPDATE t
SET CategoryID = @probeScoreCategoryID
FROM SecurityTask t JOIN
SecurityTaskCategory c ON c.ID = t.CategoryID
WHERE c.ParentID = @probeScoreCategoryID

DELETE FROM SecurityTaskCategory
WHERE ParentID = @probeScoreCategoryID
