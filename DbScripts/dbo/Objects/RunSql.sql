
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'RunSql' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.RunSql
GO

/*
<summary>

</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.RunSql
	@sql varchar(8000),
	@execute bit = 1,
	@print bit = 0
AS
		IF @print = 1
			print(@sql)
		
		IF @execute = 1
		begin
			exec(@sql)
		end

	RETURN @@ERROR
GO
