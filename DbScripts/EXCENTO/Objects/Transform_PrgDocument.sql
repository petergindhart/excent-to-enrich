/*

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_PrgDocument]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_PrgDocument]
-- GO

CREATE VIEW [EXCENTO].[Transform_PrgDocument]
AS
SELECT
      DestID = ISNULL(doc.ID, NEWID()),
      DefId = 'E26B279A-4206-49F4-94C7-4933782A8E66',
      ItemId = fd.DocItemID,
      ContentFileId = fd.DestID,
      FinalizedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
      FinalizedDate = GETDATE(),
      VersionId = fd.DocVersionID
FROM
      EXCENTO.Transform_FileData fd LEFT JOIN
      PrgDocument doc ON doc.ContentFileId = fd.DestID AND doc.ItemId = fd.DestID
-- GO

*/
