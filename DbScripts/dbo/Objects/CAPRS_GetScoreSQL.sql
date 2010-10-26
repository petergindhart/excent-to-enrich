IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[CAPRS_GetScoreSQL]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[CAPRS_GetScoreSQL]
GO

CREATE FUNCTION [dbo].[CAPRS_GetScoreSQL] (
	@testDef uniqueidentifier,
	@scoreDefs varchar(8000), 
	@tableAlias varchar(50), 
	@columnPrefix varchar(50),
	@adminID uniqueidentifier)
RETURNS varchar(1000)

AS
-- place the body of the function here
BEGIN

declare @columns varchar(8000)
declare @i int
set @i = 1


select 
	@columns = 
		case when @adminID is null
		then 'null'
		else
			isnull(@columns + ', ', '') + 'Replace(''' +  Name + ''', ''percentile'', ''Pctile'') as ' + @columnPrefix + cast(@i as varchar(10)) + '_Name,' +   case 	
					when Type = 'EnumValue' then
						'(select dbo.CreateAcronym(DisplayValue) from EnumValue e where e.ID=' + @tableAlias + '.' + columnname + ')'
					when Type = 'GradeLevel' then
						'(select Name from GradeLevel gl where gl.ID=' + @tableAlias + '.' + columnname + ')'
					else
						@tableAlias + '.' + columnname 
				end
		end
		+ ' as ' + @columnPrefix + cast(@i as varchar(10)) + '_Label',

	@columns =
		case when @adminID is null
		then 'null'
		else
			isnull(@columns + ', ', '') + case 	
				when Type = 'EnumValue' then
					'(select Code from EnumValue e where e.ID=' + @tableAlias + '.' + columnname + ')'
				when Type = 'GradeLevel' then
					'(select Name from GradeLevel gl where gl.ID=' + @tableAlias + '.' + columnname + ')'
				else
					@tableAlias + '.' + columnname 
			end
		end
		+ ' as ' + @columnPrefix + cast(@i as varchar(10)) + '_Value',


	@i = @i + 1

from(
	select 
		tsd.ColumnName,
		tsd.Name,
		tsd.DataTypeID,
		tsdt.Type
	from 
		dbo.GetUniqueIdentifiers(@scoreDefs) scores join
		TestScoreDefinition tsd on scores.id = tsd.ID join
		TestScoreDataType tsdt on tsd.DataTypeID = tsdt.ID
	) cols


     RETURN(@columns)
END


--select dbo.CAPRS_GetScoreSQL('F785AD55-B8FA-4B42-9724-BB1BAF3B459E|C6FEA8CB-2543-4AAA-AA25-15A5AED1069C|260FCB7F-3BB3-48AA-85AC-92FCB4A01F30', 'pm1', 'Primary1Score')



