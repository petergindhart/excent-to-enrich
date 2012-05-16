IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_IepEsy]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_IepEsy]
GO

CREATE VIEW [EXCENTO].[Transform_IepEsy]
AS
	SELECT
		  DestID = sec.ID,
		  DecisionID = x.EnumValueId,
		  TbdDate = o.ESYDeter,
		  TbdNeededInformation = CAST(NULL as Text),
		  Explanation = CAST(NULL as Text)
	FROM
		  EXCENTO.Transform_Iep iep JOIN
		  PrgSection sec ON
				sec.VersionID = iep.VersionDestID AND
				sec.DefID = '8E378CDD-D392-4952-A98F-F210346F657E' LEFT JOIN --IEP ESY
		  EXCENTO.IEPSpecialFactorTbl o ON iep.GStudentID = o.GStudentID LEFT JOIN
		  (
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
					  end, 'N') = x.Code 
	WHERE isnull(o.del_flag,0)=0
GO
-- NOTE:  it may be necessary to modify this view to select only one record per student