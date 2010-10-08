IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_IepAccomodations]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_IepAccomodations]
GO

CREATE VIEW [EXCENTO].[Transform_IepAccomodations]
AS
SELECT
	DestID = sec.ID,
	IEPModSeq = a.IEPModSeq,
	Explanation = isnull('Accommodations (supplementary aids) needed:'+char(13)+char(10)+
	convert(varchar(max), SupplementAids)+char(13)+char(10)+char(13)+char(10),'')+
	isnull('Required program modifications in the general curriculum:'+char(13)+char(10)+
	convert(varchar(max), Modifications)+char(13)+char(10)+char(13)+char(10),'')
FROM 
	EXCENTO.Transform_Iep iep JOIN
	dbo.PrgSection sec ON
		sec.VersionID = iep.VersionDestID AND
-- 		sec.DefID = '8E378CDD-D392-4952-A98F-F210346F657E' LEFT JOIN --IEP Assessments.    uh, this is supposed to be accomodations.
		sec.DefID = '62BD2FF9-FC42-4295-8C7C-23ADB9417841' LEFT JOIN --IEP Accomodations
	EXCENTO.IEPModTbl_SC a on iep.GStudentID = a.GStudentID AND
	a.IEPModSeq = (
	SELECT
		max(b.IEPModSeq) IEPModSeq
	FROM 
		EXCENTO.IEPModTbl_SC b
	WHERE 
	isnull(b.del_flag,0)=0 AND 
	b.gstudentid = a.gstudentid AND 
	isnull(b.ModifyDate, 0) = (
		SELECT max(isnull(c.ModifyDate,0)) ModifyDate
		FROM 
			EXCENTO.IEPModTbl_SC c 
		WHERE
			isnull(c.del_flag,0)=0 AND 
			b.gstudentid = c.gstudentid
		)
	)
GO
-- last line