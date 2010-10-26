if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IsMarkNumFinal]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[IsMarkNumFinal]
GO

CREATE    FUNCTION [dbo].[IsMarkNumFinal]
(	
	@expression varchar(8000),
	@marknum int
)
RETURNS int
AS
BEGIN	
	declare @section varchar(12)
	set @section = dbo.ParseMarkNum(@expression,  @MarkNum)

      IF( (@section LIKE '%YR%' AND @section NOT LIKE '%EOC%' )or 
            @section LIKE '%Year%' or 
            @section LIKE '%Fn%' or
            @section LIKE '%Fin%'
      )
			return 1	
	RETURN 0
END