IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_IepGoal]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_IepGoal]
GO

CREATE VIEW [EXCENTO].[Transform_IepGoal]
AS
	SELECT 
		iep.GStudentID,
		g.GoalSeqNum,
		DestID = isnull(ig.ID, newid()),
		InstanceID = sec.ID,
		Sequence = (
				SELECT count(*)+1
				FROM EXCENTO.GoalTbl
				WHERE GStudentID = g.GStudentID AND
				(ISNULL(del_flag,0)=0 AND IEPStatus = 1) AND
				GoalSeqNum < g.GoalSeqNum 
			), -- join to itself 
		TargetDate = iep.PlannedEndDate, -- If not exists, use IEP target end date
		GoalStatement = g.GoalDesc,
		IsEsy = isnull(g.ESY,0),
		GoalAreaID = isnull(ga.ID, 'CFD77237-0E1D-4055-B557-AA6978B3A21B'), -- created a row for "No Goal Area" Selected in the IepGoalArea table
		HasObjectives = cast(0 as bit),
		PostSchoolAreaID = cast(NULL as uniqueidentifier)
	FROM 
		EXCENTO.Transform_Iep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = '32B89B05-C90E-4F62-A171-E5B282981948' JOIN --IEP Goals
		EXCENTO.GoalTbl g on 
			iep.GStudentID = g.GStudentID AND
			(isnull(g.del_flag,0)=0 and g.IEPStatus = 1) LEFT JOIN
		EXCENTO.MAP_IepGoalID m on
			g.GoalSeqNum = m.GoalSeqNum LEFT JOIN
		dbo.IepGoal ig on
			sec.ID = ig.InstanceID LEFT JOIN
		EXCENTO.MAP_IepGoalAreaID gm on
			g.BankDesc = gm.BankDesc LEFT JOIN
		dbo.IepGoalArea ga on 
			g.BankDesc = ga.Name
	WHERE
		isnull(g.del_flag,0)=0
GO
