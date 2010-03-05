IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_IepService]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_IepService]
GO

CREATE VIEW [EXCENTO].[Transform_IepService]
AS
	SELECT
		iep.GStudentID,
		DestID = isnull(iv.id, newid()),
		InstanceID = sec.ID,
		v.ServSeqNum,
		DefID = isnull(sd.ID, '1CF4FFF7-D17D-4B76-BAE4-9CD0183DD008'),
		DeliveryStatement =
			isnull('Frequency : '+v.Frequency+char(13)+char(10), '')+
			isnull('Length	  : '+v.Length+char(13)+char(10), '')+
			isnull('DeliveryStatement : '+cast(case when v.Type = 'S' then v.Subject when v.Type = 'R' then convert(varchar(max), v.RelServDesc) end as varchar(max)), ''), 
		IsRelated = cast(case when v.Type = 'R' then 1 else 0 end as bit),
		IsDirect = cast(case when Include1 = 1 then 1 else 0 end as bit),
		Location = convert(varchar(50), v.LocationDesc),
		StartDate = v.InitDate,
		EndDate = v.EndDate,
		Amount = cast(0 as int),
		UnitID = cast(NULL as uniqueidentifier),
		FrequencyID = cast(NULL as uniqueidentifier),
		ExcludesFromGenEd = cast(0 as bit),
		ProviderTitle = convert(varchar(100), v.ProvDesc),
		Sequence = (
				SELECT count(*)+1
				FROM EXCENTO.ServiceTbl
				WHERE GStudentID = v.GStudentID AND
				ISNULL(del_flag,0)=0 AND
				ServSeqNum < v.ServSeqNum 
			),
		IsEsy = cast(isnull(v.ESY,0) as bit)
FROM
	EXCENTO.Transform_Iep iep JOIN
	PrgSection sec ON
		sec.VersionID = iep.VersionDestID AND
		sec.DefID = 'EEC339BC-F160-4D6C-B684-5E53386DE983' JOIN --IEP Services
	EXCENTO.ServiceTbl v on 
		iep.GStudentID = v.GStudentID AND
		isnull(v.del_flag,0)=0 LEFT JOIN
	EXCENTO.MAP_IepServiceID m on
		v.ServSeqNum = m.ServSeqNum LEFT JOIN
	dbo.IepService iv on
		sec.ID = iv.InstanceID LEFT JOIN
	dbo.IepServiceDef sd on
		v.ServDesc = sd.Name
WHERE
	isnull(v.del_flag,0)=0
GO
