IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplate_SynchronizeFormInstances]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormTemplate_SynchronizeFormInstances]
GO

/*
<summary>
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[FormTemplate_SynchronizeFormInstances]
	@id uniqueidentifier
AS

-- Handle deleted subjects
delete sfis
from
	SubjectFormInputStatus sfis join
	FormInstanceInterval fii on fii.ID = sfis.IntervalID join
	FormInterval i on i.ID = fii.IntervalID join
	FormInstance fi on fi.ID = fii.InstanceID left join
	FormTemplateLayout ftl on ftl.TemplateID = fi.TemplateID left join
	SubjectFormInputArea sfia on sfia.ID = ftl.ControlID and sfis.SubjectID = sfis.SubjectID left join
	FormTemplateControlProperty cci on cci.ControlID = ftl.ControlID and cci.Name = 'CollectCummulativeIntervals'
where
	fi.TemplateID = @id and
	sfia.ID is null and
	(i.CumulativeUpTo is null or cci.Value = 'True')


-- Handle new subjects
insert SubjectFormInputStatus(Id, SubjectID, IntervalId)
select newid(), sfia.SubjectID, fii.ID
from
	FormInterval i join
	FormInstanceInterval fii on i.ID = fii.IntervalID join
	FormInstance fi on fi.ID = fii.InstanceID join
	FormTemplateLayout ftl on ftl.TemplateID = fi.TemplateID join
	SubjectFormInputArea sfia on sfia.ID = ftl.ControlID left join
	SubjectFormInputStatus sfis on fii.ID = sfis.IntervalID and sfia.SubjectID = sfis.SubjectID left join
	FormTemplateControlProperty cci on cci.ControlID = ftl.ControlID and cci.Name = 'CollectCummulativeIntervals'
where
	fi.TemplateID = @id and
	sfis.ID is null and
	(i.CumulativeUpTo is null or cci.Value = 'True')
group by
	sfia.SubjectID, fii.ID


-- Remove any orphaned controls
DELETE FormTemplateControl
FROM
	FormTemplateControl control left join
	FormTemplateLayout layout on layout.controlID = control.ID	
where
	layout.ID IS NULL AND IsShared  = 0
