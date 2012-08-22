/*
		Run this script on a database that has been upgraded according to the current specification of your import type (for example, Special Ed Data)
		Set the @schemaName and @extractDatabase variables to the proper values for your project.
		Use the generated XML output in conjunction with the 


*/

set nocount on;
DECLARE @fileContent varchar(max), @tableName varchar(100), @schemaName varchar(100), @extractDatabase uniqueidentifier
select @fileContent = '', 
	@schemaName = 'LEGACYSPED', 
	@extractDatabase = '29D14961-928D-4BEE-9025-238496D144C6'
print '<?xml version="1.0" encoding="utf-8" ?>

<FileFormat FieldDelimiter=''|'' FieldQualifier=''"'' FieldQualifierRequired="false" >
	<Files>'

DECLARE tempCursor CURSOR FOR -- DECLARE @extractDatabase uniqueidentifier, @schemaName varchar(100) ; SELECT @extractDatabase = '29D14961-928D-4BEE-9025-238496D144C6', @schemaName = 'LEGACYSPED'
SELECT  t.TABLE_NAME from information_schema.tables t join (
	select ScriptNumber, 
		--ScriptName, 
		--left(ScriptName, len(ScriptName)-4),
		--reverse(left(ScriptName, len(ScriptName)-4)),
		--patindex('%-%', reverse(left(ScriptName, len(ScriptName)-4)))-1,
		--left(reverse(left(ScriptName, len(ScriptName)-4)), patindex('%-%', reverse(left(ScriptName, len(ScriptName)-4)))-1),
		--reverse(left(reverse(left(ScriptName, len(ScriptName)-4)), patindex('%-%', reverse(left(ScriptName, len(ScriptName)-4)))-1)),
		Table_name = reverse(left(reverse(left(ScriptName, len(ScriptName)-4)), patindex('%-%', reverse(left(ScriptName, len(ScriptName)-4)))-1))+'_LOCAL'
	from VC3Deployment.Version v where v.Module = 'LEGACYSPED' and v.ScriptNumber > 0
	) v on t.TABLE_NAME = v.Table_name
where
	table_schema=@schemaName and
	--table_name ='students_local'
	t.TABLE_TYPE ='base table' and 
	t.TABLE_NAME not like 'map%' and 
	t.TABLE_NAME like '%[_]LOCAL' 
order by v.ScriptNumber


--select ScriptNumber, 
--	--ScriptName, 
--	--left(ScriptName, len(ScriptName)-4),
--	--reverse(left(ScriptName, len(ScriptName)-4)),
--	--patindex('%-%', reverse(left(ScriptName, len(ScriptName)-4)))-1,
--	--left(reverse(left(ScriptName, len(ScriptName)-4)), patindex('%-%', reverse(left(ScriptName, len(ScriptName)-4)))-1),
--	--reverse(left(reverse(left(ScriptName, len(ScriptName)-4)), patindex('%-%', reverse(left(ScriptName, len(ScriptName)-4)))-1)),
--	reverse(left(reverse(left(ScriptName, len(ScriptName)-4)), patindex('%-%', reverse(left(ScriptName, len(ScriptName)-4)))-1))+'_LOCAL'
--from VC3Deployment.Version v where v.Module = 'LEGACYSPED' and v.ScriptNumber > 0

OPEN tempCursor

FETCH NEXT FROM tempCursor INTO @tableName
WHILE @@FETCH_STATUS = 0
BEGIN

-- print 'NOW WORKING ON '+@tableName
-- declare @tableName varchar(100) , @fileContent varchar(max) ; select @tableName = 'District_LOCAL', @fileContent = ''
	select 
		@fileContent = '		<File Name="' + ffet.FileName + '" Required="' + case when et.IgnoreMissing = 0 then 'true' else 'false' end + '" Include="true">'
	FROM
		vc3etl.ExtractTable et join -- select * from vc3etl.ExtractTable et where DestSchema = 'LEGACYSPED'
		vc3etl.flatFileExtractTable ffet on et.ID = ffet.ID -- select * from vc3etl.flatFileExtractTable
	where
		et.ExtractDatabase=@extractDatabase 
		and
		et.DestTable= replace(@tableName,'_LOCAL','')
	
	select @fileContent = @fileContent + char(13) + char(10) + '			<Columns>'
		
	select
		@fileContent = @fileContent + char(13) + char(10) +
			'				<Column Required="' + case when col.IS_NULLABLE = 'no' then 'true' else 'false' end + '" Name="' + col.Column_Name + '" DataType="' + col.DATA_TYPE + '" DataLength="' + case when col.Character_Maximum_length is null then '0' else cast(col.Character_Maximum_length as varchar(5)) end  + '" ' + case when pks.Column_Name is not null then 'IsPrimaryKey="true"'else'' end +' />'
	FROM
	information_schema.columns col left join
	(
		SELECT
			distinct c.Column_Name, c.Table_Name, c.Table_Schema
		FROM 
			INFORMATION_SCHEMA.TABLE_CONSTRAINTS cons join
			INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE usa on cons.CONSTRAINT_NAME = usa.CONSTRAINT_NAME join
			information_schema.COLUMNS c on c.Table_Name = cons.Table_Name and c.table_Schema = @schemaName and c.Column_Name = usa.Column_Name
		WHERE		
			CONSTRAINT_TYPE = 'PRIMARY KEY' and c.Table_Name not like '%MAP[_]%'
	) pks on col.Table_name = pks.Table_Name AND col.Column_Name = pks.Column_Name and col.table_schema=pks.Table_Schema
	where col.Table_schema=@schemaName and col.table_name =@tableName

	select @fileContent = @fileContent + char(13) + char(10) +'			</Columns>'
	select @fileContent = @fileContent + char(13) + char(10) +'		</File>'

	select @fileContent
	
	SET @fileContent = ''
	FETCH NEXT FROM tempCursor INTO @tableName

END
CLOSE tempCursor
DEALLOCATE tempCursor

print '	</Files>
</FileFormat>'


