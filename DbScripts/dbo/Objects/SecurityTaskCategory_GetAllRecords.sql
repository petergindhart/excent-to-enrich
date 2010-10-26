if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityTaskCategory_CreateCategoriesForPrgItemDefs]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityTaskCategory_CreateCategoriesForPrgItemDefs]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityTaskCategory_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityTaskCategory_GetAllRecords]
GO


/*
<summary>
Returns all security task category records.
</summary>

<returns>Returns all security task category records.</returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.SecurityTaskCategory_GetAllRecords
AS
	select *
	from SecurityTaskCategory
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
