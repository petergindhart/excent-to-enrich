IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgDocumentID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgDocumentID
(
	ItemID uniqueidentifier NOT NULL,
	SectionId uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgDocumentID ADD CONSTRAINT
PK_MAP_PrgDocumentID PRIMARY KEY CLUSTERED
(
	ItemID,SectionId
)
END

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgDocument') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgDocument
GO

CREATE VIEW LEGACYSPED.Transform_PrgDocument
AS
SELECT 
DestID = ISNULL(doc.ID,m.DestID),
DefID = '07E35E76-5608-4798-B889-52B29B20C1CE',  --DocumentDefID for ConvertedData
ItemID = it.ID,
SectionId = sec.ID
FROM 
PrgItem it 
LEFT JOIN  PrgItemDef itd on itd.ID = it.DefID
LEFT JOIN  PrgSection sec on sec.ItemID = it.ID 
LEFT JOIN  PrgSectionDef secd on secd.ID = sec.DefID
LEFT JOIN  PrgSectionType sect on sect.ID = secd.TypeID
LEFT JOIN LEGACYSPED.MAP_PrgDocumentID m ON m.ItemID = it.ID
LEFT JOIN PrgDocument doc ON doc.ID = m.DestID
WHERE itd.ID = '8011D6A2-1014-454B-B83C-161CE678E3D3' and sect.ID = '469601E0-B8E6-483A-9CE7-2A88DE0EAB78' and sec.OnLatestVersion =1

