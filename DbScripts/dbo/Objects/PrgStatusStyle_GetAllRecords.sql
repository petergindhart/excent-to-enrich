SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgStatusStyle_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgStatusStyle_GetAllRecords]
GO

 /*
<summary>
Gets all records from the PrgStatusStyle table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.PrgStatusStyle_GetAllRecords
AS
	SELECT
		p.*
	FROM
		PrgStatusStyle p
	ORDER BY
		case p.Name when 'Default' then 0 else 1 end, p.Name
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

