IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PersonRecordException_MergeDependencies]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PersonRecordException_MergeDependencies]
GO

 /*
<summary>
Merges the depedencies of a "picked" Person record with the "non-picked" persons
</summary>
<param name="ids">Ids of the Person(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PersonRecordException_MergeDependencies]
	@pickedID uniqueidentifier,
	@ids	uniqueidentifierarray
AS
	UPDATE prtm
	SET PersonID = @pickedID
	FROM
		PrgItemTeamMember prtm join
		GetUniqueidentifiers(@ids) Keys ON prtm.PersonId = Keys.Id
		
	DELETE pre
	FROM
		PersonRecordException pre join
		GetUniqueidentifiers(@ids) Keys ON (PersonBID = Keys.Id) OR (PersonAID = Keys.Id)
