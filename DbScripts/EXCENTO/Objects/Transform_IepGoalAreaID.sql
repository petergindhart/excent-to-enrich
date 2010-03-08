IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_IepGoalAreaID]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_IepGoalAreaID]
GO

CREATE VIEW [EXCENTO].[Transform_IepGoalAreaID]
AS
	SELECT
		DestID = cast('CFD77237-0E1D-4055-B557-AA6978B3A21B' as uniqueidentifier), 
		Sequence = cast(0 as int),
		Name = CONVERT(VARCHAR(100), 'No Bank Selected'),
		AllowCustomProbes = cast(1 as bit)
UNION ALL
	SELECT
		ga.DestID,
		Sequence = cast(1 as int), -- join target table to "itself" in this query
		Name = convert(varchar(100), m.LookDesc),
		AllowCustomProbes = cast(0 as bit)
	FROM
		EXCENTO.CodeDescLook m LEFT JOIN
		EXCENTO.MAP_IepGoalAreaID ga on convert(varchar(100), m.LookDesc) = ga.BankDesc 
		-- LEFT JOIN -- do we really need the Sequence?
--		dbo.IepGoalAreaID a on 
--			m.LookDesc = a.Name AND
	WHERE
		m.UsageID = 'Banks'
GO
