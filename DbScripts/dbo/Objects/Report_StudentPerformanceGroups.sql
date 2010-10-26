SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_StudentPerformanceGroups]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_StudentPerformanceGroups]
GO



CREATE PROCEDURE dbo.Report_StudentPerformanceGroups
	@group uniqueidentifier, @groupType char, @user uniqueidentifier, @testScore uniqueidentifier, @administration uniqueidentifier
AS


-- Generate SQL
declare @sql varchar(8000)
exec Report_StudentPerformanceGroupsSql @group, @groupType, @user, @testScore, @administration, @sql output

-- Execute SQL
exec RunSql @sql, 1, 0


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

