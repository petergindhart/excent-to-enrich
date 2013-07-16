update VC3ETL.ExtractDatabase set LastExtractDate = NULL, LastLoadDate = NULL where ID='29D14961-928D-4BEE-9025-238496D144C6'
update VC3ETL.ExtractTable set CurrentCount = 0, LastSuccessfulCount = 0 where ExtractDatabase='29D14961-928D-4BEE-9025-238496D144C6'
update VC3ETL.LoadTable set LastLoadDate = NULL where ExtractDatabase='29D14961-928D-4BEE-9025-238496D144C6'
