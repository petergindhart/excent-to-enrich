IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'EXCENTO.Transform_ServiceDefID') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW EXCENTO.Transform_ServiceDefID
GO

CREATE VIEW EXCENTO.Transform_ServiceDefID 
AS
SELECT DestID, Name, CONVERT(Text, Description) Description, DefaultProviderTitle
FROM (
	SELECT DISTINCT -- in case the same description exists for each usageid
		DestID,
		Name = CONVERT(VARCHAR(100), m.Memo),
		Description = cast(NULL as varchar(max)),
		DefaultProviderTitle = cast(NULL as varchar(100))
	FROM
		Richland1_ExcentOnline.dbo.MemoLook m LEFT JOIN
		EXCENTO.MAP_ServiceDefID sd on convert(varchar(100), m.Memo) = sd.Memo 
	WHERE
		m.UsageID in ('FunAcademic', 'FunType')
	) t
GO
