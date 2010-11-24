/*

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_IepMeasurableGoal]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_IepMeasurableGoal]
-- GO

CREATE VIEW [EXCENTO].[Transform_IepMeasurableGoal]
AS
	SELECT
		g.GoalSeqNum,
		ObjSeqNum = 0,
		g.DestID,
		GoalID = g.DestID,
		ProbeTypeID = cast(NULL as uniqueidentifier), -- revisit
		IndDefID = cast(NULL as uniqueidentifier), -- NULL
		IndTarget = cast(NULL as float), -- NULL
		NumericTarget = cast(NULL as float), -- NULL
		RubricTargetID = cast(NULL as uniqueidentifier), -- NULL
		FlagTarget = cast(0 as bit), -- DONE
		RatioPartTarget = cast(NULL as float), -- NULL
		RatioOutOfTarget = cast(NULL as float), -- NULL
		Sequence = 0
	FROM
		EXCENTO.Transform_IepGoal g LEFT JOIN
		IepMeasurableGoal m on 
			g.DestID = m.ID AND
			m.Sequence = 0
UNION ALL
	SELECT
		g.GoalSeqNum,
		o.ObjSeqNum,
		m.DestID,
		GoalID = g.DestID,
		ProbeTypeID = cast(NULL as uniqueidentifier), -- revisit
		IndDefID = cast(NULL as uniqueidentifier), -- NULL
		IndTarget = cast(NULL as float), -- NULL
		NumericTarget = cast(NULL as float), -- NULL
		RubricTargetID = cast(NULL as uniqueidentifier), -- NULL
		FlagTarget = cast(0 as bit), -- DONE
		RatioPartTarget = cast(NULL as float), -- NULL
		RatioOutOfTarget = cast(NULL as float), -- NULL
		Sequence = (
			SELECT count(*)
			FROM EXCENTO.ObjTbl
			WHERE GoalSeqNum = o.GoalSeqNum AND
				(IEPStatus = 1 and isnull(del_flag,0)=0) AND
				(
				(ObjOrder < o.ObjOrder)
				OR
				(ObjOrder = o.ObjOrder AND ObjSeqNum < o.ObjSeqNum)
				)
			)+1
	FROM
		EXCENTO.Transform_IepGoal g JOIN
		EXCENTO.ObjTbl o on
			g.GoalSeqNum = o.GoalSeqNum and
			(o.IEPStatus = 1 and isnull(o.del_flag,0)=0) LEFT JOIN
		EXCENTO.MAP_IepMeasurableGoalID m on
			o.GoalSeqNum = m.GoalSeqNum and
			o.ObjSeqNum = m.ObjSeqNum
	WHERE
		o.IEPStatus = 1 and isnull(o.del_flag,0)=0
-- GO

*/
