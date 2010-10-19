CREATE NONCLUSTERED INDEX [PrgInvolvement_VariantEndDate]
ON [dbo].[PrgInvolvement] ([VariantID],[EndDate])
GO

CREATE NONCLUSTERED INDEX [PrgItem_Involvement]
ON [dbo].[PrgItem] ([InvolvementID])
GO

CREATE NONCLUSTERED INDEX [PrgItemTeamMember_ItemPerson]
ON [dbo].[PrgItemTeamMember] ([ItemID],[PersonID])
GO