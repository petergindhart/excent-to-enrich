IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_IepSpecialFactor]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_IepSpecialFactor]
GO

CREATE VIEW [EXCENTO].[Transform_IepSpecialFactor]
AS
	SELECT
		eosf.GStudentID, 
		DestID = sf.ID,
		InstanceID = sec.ID,
		DefID = sfd.ID,
		AnswerID = 	CASE WHEN  
			(SFD.SEQUENCE = 0 AND eosf.CONSIDERED2 = 1) OR  
			(SFD.SEQUENCE = 1 AND eosf.Considered3 = 1) OR  
			(SFD.SEQUENCE = 2 AND eosf.Considered4 = 1) OR  
			(SFD.SEQUENCE = 5 AND eosf.LEP = 1) OR  
			(SFD.SEQUENCE = 6 AND eosf.Considered1 = 1)   
			THEN 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' ELSE 'F7E20A86-2709-4170-9810-15B601C61B79' END,
		Text = cast(NULL as text),
		FormInstanceId = cast(NULL as uniqueidentifier),
		DocumentId = cast(NULL as uniqueidentifier)
	FROM
		EXCENTO.Transform_Iep iep JOIN
		dbo.PrgSection sec ON 
				sec.VersionID = iep.VersionDestID AND
				sec.DefID = '189AD8F1-47CF-4CA1-9823-6844276C6841' CROSS JOIN 
		dbo.IepSpecialFactorDef sfd LEFT JOIN
		dbo.IepSpecialFactor sf on 
			sf.DefID = sfd.ID AND
			sf.InstanceID = sec.ID LEFT JOIN
		EXCENTO.IEPSpecialFactorTbl eosf on 
			iep.GStudentID = eosf.GStudentID AND
			isnull(eosf.del_flag,0)=0
--	WHERE
--		(sfd.Sequence in (0, 1, 2, 5, 6))
GO
