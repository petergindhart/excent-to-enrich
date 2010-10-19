DELETE d 
FROM PrgItemTeamMember d
WHERE 
	--Has Duplicates Check
	(SELECT COUNT(*) 
		FROM PrgItemTeamMember c 
		WHERE c.PersonID = d.PersonID AND 
		c.ItemID = d.ItemID AND 
		c.ID <> d.ID) > 0  AND
	--Order duplicates by their value
	(SELECT TOP 1 ID
		FROM PrgItemTeamMember tm
		WHERE 
			tm.PersonID = d.PersonID AND 
			tm.ItemID = d.ItemID
		ORDER BY ItemID, IsPrimary DESC, MtgInvitee DESC, ResponsibilityID DESC, Agency DESC) <> d.ID -- Delete where ID does not equal the most valuable record