ALTER TABLE dbo.PrgSectionType ADD CONSTRAINT
FK_PrgSectionType#EffectiveEnd FOREIGN KEY (EffectiveEndId) 
REFERENCES dbo.EnumValue (ID) 
	ON UPDATE  NO ACTION
	ON DELETE  NO ACTION