/*

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_PresentLevels]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_PresentLevels]
-- GO

CREATE VIEW EXCENTO.Transform_PresentLevels
AS
SELECT
	DestID = sec.ID,
	StrengthsPreferencesInterest = pl.Strength
FROM
	EXCENTO.Transform_Iep iep JOIN
	PrgSection sec ON
		sec.VersionID = iep.VersionDestID AND
		sec.DefID = 'B18E5739-9242-498E-84A0-4FA79AC0627B' LEFT JOIN -- IEP Present Levels
	(
		SELECT pl.GStudentID, max(pl.IEPPLSeqNum) IEPPLSeqNum
		FROM EXCENTO.IEPPresLevelTbl pl
		WHERE
			isnull(pl.del_flag,0)=0  AND
			case when len(isnull(convert(varchar(10), pl.Strength),'')) = 0 then 0 else 1 end = (
				SELECT max(case when len(isnull(convert(varchar(10), plIn.Strength),'')) = 0 then 0 else 1 end) HasStr
				FROM
					EXCENTO.IEPPresLevelTbl plIn
				WHERE
					plIn.GStudentID = pl.GStudentID AND
					isnull(pl.del_flag,0)=0
				)
		GROUP BY pl.GStudentID
	) pStr on iep.GStudentID = pStr.GStudentID JOIN
	EXCENTO.IEPPresLevelTbl pl on pStr.IEPPLSeqNum = pl.IEPPLSeqNum
-- GO

*/
