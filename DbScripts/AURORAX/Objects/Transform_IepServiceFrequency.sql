IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_IepServiceFrequency') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_IepServiceFrequency
GO

CREATE VIEW AURORAX.Transform_IepServiceFrequency
AS
	SELECT 
		DestID = isf.ID, 
		Name = isf.Name, 
		Sequence = sfc.ServiceFrequencyCode, 
		WeekFactor = isf.WeekFactor
	FROM
		AURORAX.ServiceFrequencyCode sfc JOIN
	 dbo.IepServiceFrequency isf on sfc.ServiceFrequencyDescription+'ly' = isf.Name
go
