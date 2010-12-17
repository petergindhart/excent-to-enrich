IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'EXCENTO.Transform_ServiceDefID') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW EXCENTO.Transform_ServiceDefID
GO

CREATE VIEW EXCENTO.Transform_ServiceDefID 
AS
SELECT 
	DestID, 
	Name, 
	Description = cast(NULL as varchar(max)),
	DefaultProviderTitle = cast(NULL as varchar(100))
FROM (
	SELECT DISTINCT -- in case the same description exists for each usageid
		sd.DestID,
		Name = CONVERT(VARCHAR(100), m.Memo)
	FROM
		EXCENTO.MemoLook m LEFT JOIN
		EXCENTO.MAP_ServiceDefID sd on convert(varchar(100), m.Memo) = sd.Memo
	WHERE
		m.UsageID in ('FunAcademic', 'FunType')
	) t
UNION ALL
SELECT
	DestID = cast('1CF4FFF7-D17D-4B76-BAE4-9CD0183DD008' as uniqueidentifier), 
	Name = CONVERT(VARCHAR(100), 'Unknown'), 
	Description = cast(NULL as varchar(max)),
	DefaultProviderTitle = cast(NULL as varchar(100))
GO




