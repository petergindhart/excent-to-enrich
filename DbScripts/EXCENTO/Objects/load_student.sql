
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_StudentID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[MAP_StudentID]
GO

CREATE TABLE [EXCENTO].[MAP_StudentID]
	(
	GStudentID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE [EXCENTO].[MAP_StudentID] ADD CONSTRAINT
	[PK_MAP_StudentID] PRIMARY KEY CLUSTERED 
	(
	GStudentID
	) ON [PRIMARY]

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Match_Students]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Match_Students]
GO

CREATE VIEW [EXCENTO].[Match_Students]
AS
	SELECT a.GStudentID, b.ID [DestID]
	from
		EXCENTO.Student a join
		dbo.Student b on
			a.StudentID = b.Number and
			a.Lastname = b.LastName and
			a.Deletedate is null
GO
