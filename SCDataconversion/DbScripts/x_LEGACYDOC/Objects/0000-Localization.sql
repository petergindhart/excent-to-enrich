
--#include 0000-RunFirst.sql
--#include Transform_FileData.sql
--#include Transform_Attachment.sql


-- let's reset the counts for imported data so we know this script ran when we run dc from the ui
update et set LastSuccessfulCount = 0, CurrentCount = 0 from VC3ETL.ExtractTable et where ExtractDatabase = '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16' 
go
