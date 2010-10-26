if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AcademicPlan_DeleteProcesses]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[AcademicPlan_DeleteProcesses]
GO

CREATE TRIGGER dbo.AcademicPlan_DeleteProcesses
ON AcademicPlan
FOR DELETE
AS 
BEGIN
	delete Process
	where TargetID in (select Id from deleted)

END
GO