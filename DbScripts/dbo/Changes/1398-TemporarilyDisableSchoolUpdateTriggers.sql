UPDATE VC3ETL.ExtractDatabaseTrigger
SET Enabled = 0
WHERE ID = '78237598-E4D6-4E47-808C-82E555BD0381'

UPDATE School
SET IsLocalOrg = 1, OrgUnitID = (select LocalOrgRootID from SystemSettings)