UPDATE i
SET VariantID = v.ID
FROM PrgInvolvement i JOIN
	PrgVariant v on v.ProgramID = i.ProgramID 
WHERE i.VariantID IS NULL AND 
	(select COUNT(*) from PrgVariant vc where vc.ProgramId = i.ProgramID) = 1