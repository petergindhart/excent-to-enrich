UPDATE StudentGroupType
SET Name ='Program'
WHERE ID= 'F794FD43-8F92-4D82-90E3-C4D590C8B534'

-- purge all of the old "my intereventions" groups, will be replaced next 
DELETE StudentGroup
WHERE Name ='My Interventions'
GO

ALTER TABLE StudentGroup add
	Parameter uniqueidentifier null
GO