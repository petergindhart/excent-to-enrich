IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_IepServices]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_IepServices]
GO

CREATE VIEW [EXCENTO].[Transform_IepServices]
AS
SELECT
	IEP.GStudentID,
	DestID = sec.ID,
	DeliveryStatement = v.MinDesc -- MinDesc is a description of minutes that the services is delivered and may not apply to DeliveryStatement
FROM
	EXCENTO.Transform_Iep iep JOIN
	PrgSection sec ON
		sec.VersionID = iep.VersionDestID AND
		sec.DefID = 'EEC339BC-F160-4D6C-B684-5E53386DE983' LEFT JOIN --IEP Services
	dbo.IepServices iv on
		iv.ID = sec.ID LEFT JOIN
	EXCENTO.IEPServiceMainTbl_SC v on 
		iep.GStudentID = v.GStudentID AND
		isnull(v.del_flag,0)=0 AND
		v.RecNum = (
			select min(RecNum) 
			from IEPServiceMainTbl_SC 
			where GStudentID = v.GStudentID
			and isnull(del_flag,0)=0
			) 
GO
