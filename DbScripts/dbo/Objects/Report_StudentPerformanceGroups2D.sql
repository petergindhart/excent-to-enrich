SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_StudentPerformanceGroups2D]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_StudentPerformanceGroups2D]
GO



CREATE PROCEDURE dbo.Report_StudentPerformanceGroups2D
	@group					uniqueidentifier,
	@groupType				char,
	@user					uniqueidentifier,
	@testScore				uniqueidentifier,
	@administration			uniqueidentifier,
	@testScore2				uniqueidentifier,
	@administration2		uniqueidentifier
AS

-- Generate SQL for 1st dimension
declare @dim1 varchar(8000)
exec Report_StudentPerformanceGroupsSql @group, @groupType, @user, @testScore, @administration, @dim1 output

-- Generate SQL for 2nd dimension
declare @dim2 varchar(8000)
exec Report_StudentPerformanceGroupsSql @group, @groupType, @user, @testScore2, @administration2, @dim2 output


-- Build final query with data from all dimensions
declare @sql varchar(8000)

set @sql =
	'select
		Category = d1.Category, CategorySequence = d1.CategorySequence, Score=d1.Score, TestID=d1.TestID,
		Category2 = d2.Category, CategorySequence2 = d2.CategorySequence, Score2=d2.Score, TestID2=d2.TestID,
		d1.StudentID, d1.FirstName, d1.LastName 
	from
	(' + @dim1 + ') d1 full outer join
	(' + @dim2 + ') d2 on d1.StudentID = d2.StudentID'


-- Execute
exec RunSql @sql, 1, 0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

