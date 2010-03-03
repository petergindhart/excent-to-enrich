IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_IepService]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_IepService]
GO

CREATE VIEW [EXCENTO].[Transform_IepService]
AS
	SELECT 
		DestID = isnull(iv.id, newid()),
		InstanceID = sec.ID,
		DefID = sec.DefID,
		DeliveryStatement = 
			isnull('Frequency : '+v.Frequency+char(13)+char(10), '')+
			isnull('Length	  : '+v.Length+char(13)+char(10), '')+
			isnull('DeliveryStatement : '+cast(case when v.Type = 'S' then v.Subject when v.Type = 'R' then convert(varchar(max), v.RelServDesc) end as varchar(max)), ''), 
		IsRelated = cast(case when v.Type = 'R' then 1 else 0 end as bit),
		IsDirect = cast(case when Include1 = 1 then 1 else 0 end as bit),
		Location = v.LocationDesc,
		StartDate = v.InitDate,
		EndDate = v.EndDate,
		Amount = cast(0 as int),
		UnitID = cast(NULL as uniqueidentifier),
		FrequencyID = cast(NULL as uniqueidentifier),
		ExcludesFromGenEd = cast(NULL as bit),
		ProviderTitle = v.ProvDesc,
		Sequence = cast(0 as int),
		IsEsy = cast(isnull(v.ESY,0) as bit)
	FROM
		EXCENTO.Transform_Iep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = 'EEC339BC-F160-4D6C-B684-5E53386DE983' LEFT JOIN --IEP Services
		dbo.IepService iv on
			iv.InstanceID = sec.ID LEFT JOIN
		EXCENTO.ServiceTbl v on 
			iep.GStudentID = v.GStudentID AND
			isnull(v.del_flag,0)=0
	WHERE
		isnull(v.del_flag,0)=0
GO
