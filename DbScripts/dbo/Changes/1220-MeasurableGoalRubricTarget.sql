EXECUTE sp_rename N'dbo.IepMeasurableGoal.RubricTarget', N'Tmp_RubricTargetID', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.IepMeasurableGoal.Tmp_RubricTargetID', N'RubricTargetID', 'COLUMN' 
GO
ALTER TABLE dbo.IepMeasurableGoal ADD CONSTRAINT
	FK_IepMeasurableGoal#RubricTarget# FOREIGN KEY
	(
	RubricTargetID
	) REFERENCES dbo.ProbeRubricValue
	(
	ID
	)
GO

-- options for IepESY.Decision
insert EnumType values( '0D403BF3-1699-43F6-BCDD-E92BE50B157A', 'IEP.EsyDecision', 0, 0, NULL)
insert EnumValue values( '96B38252-7807-47A0-95A5-CC2AE969AD24', '0D403BF3-1699-43F6-BCDD-E92BE50B157A', 'Yes', 'Y', 1, 0 )
insert EnumValue values( '2CE2602D-BD8C-418E-852B-18EFB1ABBA85', '0D403BF3-1699-43F6-BCDD-E92BE50B157A', 'No', 'N', 1, 1 )
insert EnumValue values( '79B2FA0F-07EB-4DFC-8AA8-DC0EF9056BC3', '0D403BF3-1699-43F6-BCDD-E92BE50B157A', 'TBD', 'TBD', 1, 2 )
GO
