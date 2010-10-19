ALTER TABLE PrgItemDef
ADD CONSTRAINT UN_PrgItemDef_Name UNIQUE
(
	ProgramID, Name, DeletedDate
)