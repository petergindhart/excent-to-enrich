-- add PrgItemFormType table to replace EnumValue reference of PrgItemForm.AssociationTypeID
ALTER TABLE dbo.PrgItemForm
	DROP CONSTRAINT FK_PrgItemForm#AssociationType#
GO
CREATE TABLE dbo.PrgItemFormType
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgItemFormType ADD CONSTRAINT
	PK_PrgItemFormType PRIMARY KEY CLUSTERED 
	(
	ID
	)
GO

INSERT PrgItemFormType VALUES( '059F9485-7907-47C7-A71F-E857828E7B8C', 'Item' )
INSERT PrgItemFormType VALUES( 'DE0AFD97-84C8-488E-94DC-E17CAAA62082', 'Section' )
INSERT PrgItemFormType VALUES( 'C49ED3A4-05EF-434F-9C14-6232A41E250A', 'Special Factor' )

UPDATE f
	SET AssociationTypeID = CASE
		WHEN e.Code = 'I' THEN '059F9485-7907-47C7-A71F-E857828E7B8C'
		WHEN e.Code = 'S' THEN 'DE0AFD97-84C8-488E-94DC-E17CAAA62082'
		WHEN e.Code = 'F' THEN 'C49ED3A4-05EF-434F-9C14-6232A41E250A'
	END
FROM
	PrgItemForm f JOIN
	EnumValue e ON f.AssociationTypeID = e.ID
GO


ALTER TABLE dbo.PrgItemForm ADD CONSTRAINT
	FK_PrgItemForm#AssociationType# FOREIGN KEY
	(
	AssociationTypeID
	) REFERENCES dbo.PrgItemFormType
	(
	ID
	) 
GO
