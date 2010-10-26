-- =============================================

IF object_id(N'dbo.PrgItemView', 'V') IS NOT NULL
	DROP VIEW dbo.PrgItemView
GO

CREATE VIEW dbo.PrgItemView AS
	SELECT
		i.*,
		ItemTypeID = d.TypeID
	FROM
		PrgItem i join
		PrgItemDef d on i.DefID = d.ID
