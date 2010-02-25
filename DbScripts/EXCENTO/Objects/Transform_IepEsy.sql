IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_IepEsy]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_IepEsy]
GO

CREATE VIEW [EXCENTO].[Transform_IepEsy]
AS
	SELECT 
		DestID = iep.DestID,
		DecisionID = x.EnumValueId,
		TbdDate = o.ESYDeter,
		TbdNeededInformation = CAST(NULL as Text),
		Explanation = CAST(NULL as Text)
	FROM
		dbo.PrgSectionType t JOIN 
		dbo.PrgSectionDef d on t.ID = d.TypeId JOIN
		dbo.PrgSection sec on d.ID = sec.DefId JOIN 
		EXCENTO.Transform_Iep iep on sec.VersionID = iep.VersionDestID LEFT JOIN 
		EXCENTO.IEPSpecialFactorTbl o ON iep.GStudentID = o.GStudentID JOIN (
			SELECT 
				ev.ID EnumValueID, ev.Code
			FROM 
				dbo.EnumType et JOIN 
				dbo.EnumValue ev on et.ID = ev.Type
			WHERE
				ev.IsActive = 1 and 
				et.Type = 'IEP.EsyDecision'
			) X on 
				isnull(case when Considered8 = 1 then 'Y'
					when Considered8 = 0 then 'N'
					when ESYDeter is not null then 'TBD'
					else NULL
				end, 'N') = x.Code -- IF there is no Special Factors record for the student or there is no selection for ESY, we set ESY to No
	WHERE 
		isnull(o.del_flag,0)=0 AND
		t.Name = 'IEP Dates'
GO
