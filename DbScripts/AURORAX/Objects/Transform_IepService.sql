IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_IepService') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_IepService
GO

CREATE VIEW AURORAX.Transform_IepService
AS
	SELECT
		iep.SASID,
		DestID = m.DestID,
		InstanceID = sec.ID,
		v.PKID,
		DefID = '1CF4FFF7-D17D-4B76-BAE4-9CD0183DD008',
		DeliveryStatement = cast(NULL as text),
		Location = loc.ServiceLocationDescription, -- there is no Lookup in Enrich.  Get from APS file
		StartDate = v.BeginDate,
		EndDate = v.EndDate,
		Amount = cast(v.ServiceTime as float)*60, -- must convert to int.  Provided in hours, calculate minutes
		UnitID = '347548AB-489D-47C4-BE54-63FCF3859FD7', -- APS provides in hrs, converting to minutes
		FrequencyID = freq.DestID, 
		ProviderTitle = prov.PositionDescription, 
		Sequence = (
				SELECT count(*)+1
				FROM AURORAX.Service_Data
				WHERE SASID = v.SASID AND
				PKID < v.PKID 
			),
		RelatedID = case when isnull(v.IsRelated,0) = 0 then '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7' else '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD' end,
		DirectID = case when isnull(v.IsDirect,0) = 0 then '1A8BF908-E3ED-45B0-8EEC-99CB1AD0806F' else 'A7061714-ADA3-44F7-8329-159DD4AE2ECE' end, 
		ExcludesID = case when isnull(v.ExcludesFromGenEd,0) = 0 then '235C3167-A3E6-4D1D-8AAB-0B2B57FD5160' else '493713FB-6071-42D4-B46A-1B09037C1F8B' end, 
		EsyID = case when isnull(v.IsESY,0) = 0 then 'F7E20A86-2709-4170-9810-15B601C61B79' else 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' end
FROM
	AURORAX.Transform_Iep iep JOIN
	PrgSection sec ON
		sec.VersionID = iep.VersionDestID AND
		sec.DefID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F' JOIN --IEP Services
	AURORAX.Service_Data v on iep.SASID = v.SASID LEFT JOIN
	AURORAX.ServiceLocationCode loc on rtrim(v.ServiceLocationCode) = rtrim(loc.ServiceLocationCode) LEFT JOIN
	AURORAX.Map_ServiceFrequencyID freq on v.ServiceFrequencyCode = freq.ServiceFrequencyCode LEFT JOIN
	AURORAX.PositionId prov on v.ProviderTitleID = prov.PositionId LEFT JOIN
	AURORAX.MAP_IepServiceID m on v.PKID = m.PKID LEFT JOIN
	-- dbo.IepServiceDef sd on v.ServDesc = sd.Name -- we don't have this data yet
	dbo.IepService dv on m.DestID = dv.ID
GO
