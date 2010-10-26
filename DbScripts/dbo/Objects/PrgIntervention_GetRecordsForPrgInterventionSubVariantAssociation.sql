SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgIntervention_GetRecordsForPrgInterventionSubVariantAssociation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgIntervention_GetRecordsForPrgInterventionSubVariantAssociation]
GO


/*
<summary>
Gets records from the PrgIntervention table for the specified association 
</summary>
<param name="ids">Ids of the PrgSubVariant(s) </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgIntervention_GetRecordsForPrgInterventionSubVariantAssociation]
	@ids uniqueidentifierarray
AS
	SELECT 
		ab.SubVariantId, 
		i.*, 
		a.*
	FROM
		PrgInterventionSubVariant ab INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON ab.SubVariantId = Keys.Id INNER JOIN
		PrgIntervention a ON ab.InterventionId = a.Id INNER JOIN 
		PrgItemView i on i.Id = a.Id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

