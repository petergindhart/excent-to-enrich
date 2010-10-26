SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgRule_DeleteRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgRule_DeleteRecord]
GO

 /*
<summary>
Deletes a PrgRule record
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.PrgRule_DeleteRecord
	@id uniqueidentifier
AS
	DELETE FROM 
		PrgRule
	WHERE
		Id = @id

	-- remove orphaned filters
	DELETE FROM
		PrgFilter
	WHERE ID NOT IN ( SELECT FilterID FROM PrgRule )		
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

