if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'AURORAX' and o.name = 'Transform_PrgConsent')
drop VIEW AURORAX.Transform_PrgConsent
go

create View AURORAX.Transform_PrgConsent
as
select
	DestID = sec.ID,
	ConsentGrantedID = case when i.InitialConsentDate is null then NULL else 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' end,
	ConsentDate = convert(datetime, i.InitialConsentDate)
FROM AURORAX.Transform_IEP iep JOIN
	AURORAX.IEP_Data i on iep.IEPPKID = i.IEPPKID LEFT JOIN
	PrgSection sec on sec.ItemID = iep.DestID and sec.DefID = 'D83A4710-A69F-4310-91F8-CB5BFFB1FE4C' 	
GO
