IF OBJECT_ID(N'dbo.PrgSectionView', 'V') IS NOT NULL
	DROP VIEW dbo.PrgSectionView
GO

CREATE VIEW PrgSectionView
AS
SELECT 
	s.*,
	sb.SectionFinalizedDate,
	sb.ExpirationDate,
	CAST(
		CASE
			WHEN sb.SectionFinalizedDate IS NOT NULL AND sb.SectionFinalizedDate <= GETDATE() AND
				(sb.ExpirationDate IS NULL OR sb.ExpirationDate >= GETDATE()) THEN 1
			ELSE 0
		END
	AS Bit) AS IsActive
FROM
(
	SELECT 
		s.ID,
		CASE
			WHEN -- Item versioned and not finalized
				(SELECT COUNT(*)
				FROM PrgVersion iv 
				WHERE iv.ItemID = i.ID) > 0
				AND
				(SELECT COUNT(*) 
				FROM PrgVersion iv 
				WHERE iv.ItemID = i.ID AND
					iv.DateFinalized IS NOT NULL)	= 0
				THEN NULL
			ELSE --Item not versioned or item is finalized
				CASE --Section versioned
					WHEN sd.IsVersioned = 1 THEN v.DateFinalized --Versioned
					ELSE --Section not versioned
						CASE
							WHEN pa.PrgItemTypeAttributeID IS NOT NULL THEN i.StartDate --Plan
							ELSE i.EndDate --Not Plan
						END
				END
		END	AS SectionFinalizedDate,
		CASE --Expiration Date
			WHEN st.EffectiveEndId = '364E5196-810F-46D2-ABF5-2BC62FCCC5D9' THEN i.EndDate --Active till item end
			WHEN st.EffectiveEndId = '48604F5D-D24E-4B21-AD0C-859C04706733' THEN inv.EndDate --Active till involvement end
			ELSE 0
		END AS ExpirationDate
	FROM PrgSection s JOIN
	PrgSectionDef sd ON sd.ID = s.DefID JOIN
	PrgSectionType st ON st.ID = sd.TypeID JOIN
	PrgItem i ON i.ID = s.ItemID JOIN
	PrgInvolvement inv ON inv.ID = i.InvolvementID JOIN
	PrgItemDef id ON id.ID = i.DefID LEFT JOIN
	PrgItemTypeAttributes pa ON pa.PrgItemTypeID = id.TypeID AND 
		pa.PrgItemTypeAttributeID = '8E414520-B1D5-4543-8331-FD3E778C98D4' LEFT JOIN --plan attribute
	PrgVersion v ON v.ID = s.VersionID
) sb JOIN
PrgSection s ON s.ID = sb.ID 

GO