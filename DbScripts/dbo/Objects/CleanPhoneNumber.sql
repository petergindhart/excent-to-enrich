if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CleanPhoneNumber]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[CleanPhoneNumber]
GO

CREATE FUNCTION dbo.[CleanPhoneNumber] (@Number varchar(25))  
RETURNS varchar(25) AS  
BEGIN 
	Declare @Formatted varchar(18)

    IF LEN(@number) = 10
      BEGIN                
        SET @Formatted = '(' + LEFT(@number, 3) + ') ' + SUBSTRING(@number,4,3) + '-' + RIGHT(@number, 4)
        RETURN @Formatted
      END

    IF LEN(@number) = 7
      BEGIN
        SET @Formatted = LEFT(@number, 3) + '-' + RIGHT(@number, 4)
        RETURN @Formatted
      END
	
    IF LEN(@number) = 11 
      BEGIN                
        SET @Formatted = LEFT(@number, 1) + ' (' + SUBSTRING(@number, 2, 3) + ') ' + SUBSTRING(@number,4,3) + '-' + RIGHT(@number, 4)
        RETURN @Formatted
      END
    
    SET @Formatted = @Number
    RETURN @Formatted
END