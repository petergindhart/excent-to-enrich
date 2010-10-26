-- =============================================
-- Create procedure basic template
-- =============================================
-- creating the store procedure
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Util_AnalyzeSasiData' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.Util_AnalyzeSasiData
GO

CREATE PROCEDURE dbo.Util_AnalyzeSasiData
	@linkedServer 	varchar(3000)	= NULL,	-- Name of the linked server sasi is accessed through
	@tableSuffix	varchar(10)		= NULL
AS
	

if @linkedServer is null
	select @linkedServer = LinkedServer from SisDatabase

if @tableSuffix is null
	select @tableSuffix = TableSuffix from SisDatabase

print @linkedServer

declare @year table (Year int)
declare @yearsSeen table (Year int)
declare @tableType table (Name varchar(200), TableName varchar(200), Usage char(1), Description varchar(1000))
declare @msg table (Message varchar(4000))

--insert into @tableType values ('AENR', 'AENR{Y}{S}', 'U', 'Contains student grade level history. Not currently used by TestView.')
insert into @tableType values ('AATD', 'AATD{Y}{S}', 'R', 'Contains student attendance data by day.  Shown on academic plans.')
insert into @tableType values ('AATP', 'AATP{Y}{S}', 'R', 'Contains student attendance data by period.  Shown on academic plans.')
insert into @tableType values ('ACHS', 'ACHS{Y}{S}', 'R', 'Contains student transcript data.')
insert into @tableType values ('ACLS', 'ACLS{Y}{S}', 'R', 'Contains class roster data that associates students with classes in AMST.')
insert into @tableType values ('ADIS', 'ADIS{Y}{S}', 'R', 'Contains discipline information. Used to determine number of discipline referrals which is shown on academic plans.')
insert into @tableType values ('AMST', 'AMST{Y}{S}', 'R', 'Contains list of all classes and their teachers.')
insert into @tableType values ('ASCH', 'ASCH', 'R', 'Contains list of all schools. NOTE: This table does not need to be consolidated and doesn’t end in ‘D01’.')
insert into @tableType values ('ASTU', 'ASTU{Y}{S}', 'R', 'Contains student information including name, id, and address.')
insert into @tableType values ('ATBL', 'ATBL{Y}{S}', 'R', 'Contains “lookup” values used to display drop down lists in the application.')
insert into @tableType values ('ATCH', 'ATCH{Y}{S}', 'R', 'Contains a list of all teachers in the district. NOTE: Should have valid email addresses for all teachers for best results.')
insert into @tableType values ('SSCA', 'SSCA{Y}{S}', 'R', 'South Carolina Student Supplement table.  Extended student information is imported from this table.')

create table #consolidated (Table_Cat sysname null, Table_Schema sysname null, Table_Name sysname null, Table_Type varchar(32) null, Remarks varchar(254) null)
insert #consolidated execute sp_tables_ex @table_server=@linkedServer

-- Determine how many years of data we've got
insert into @year
select distinct 2000 + substring(found.Table_Name, 5, 1)
from #consolidated found
where len(found.Table_Name) > 4

-- determine # of recs per table
create table #recCount (Table_Name sysname, RecordCount int)

DECLARE @table_name varchar(300)
DECLARE tables_cursor CURSOR FOR 
SELECT Table_Name
FROM #consolidated

OPEN tables_cursor

FETCH NEXT FROM tables_cursor INTO @table_name

WHILE @@FETCH_STATUS = 0
BEGIN
	insert #recCount execute('select ''' + @table_name + ''', (select * from openquery(' + @linkedServer + ', ''select count(*) from ' + @table_name + '''))' )

	FETCH NEXT FROM tables_cursor INTO @table_name
END

close tables_cursor
deallocate tables_cursor

print 'Found the following years of SASI data:'
select * from @year order by Year desc

print 'SASI table status:'
select 	
	case when Name is not null then Name
		else Left(found.Table_Name ,4) End Abbr,

	isnull(y.Year, 2000 + substring(found.Table_Name, 5, 1)) Year,

	case when found.Table_Name is not null then found.Table_Name
		else Replace( Replace( t.TableName, '{Y}', right(cast(y.Year as varchar(4)), 1) ), '{S}', @tableSuffix) End TableName,

	case Usage
		when 'R' then -- Required
			case 
				when found.Table_Name is null then 'Error: Missing required table' 
				when RecordCount = 0 then 'Error: Required table has no records' 
				else 'OK' 
			end
		when 'O' then -- Optional
			case 
				when found.Table_Name is null then 'Warning: Missing optional table' 
				when RecordCount = 0 then 'Warning: Optional table is empty' 
				else 'OK' 
			end
		when 'U' then -- Unused
			case 
				when found.Table_Name is null 
				then 'OK'
				else 'OK'
			end
		else
			'OK (unknown table)'
	end	Status,

	case when found.Table_Name is not null then 1 else 0 end Consolidated,

	case Usage
		when 'R' then 'Required'
		when 'O' then 'Optional'
		when 'U' then 'Unused'
		end	Usage,

	rc.RecordCount,

	Description TableDesc
from 	
	@tableType t cross join
	@year y full outer join
	#consolidated found on found.Table_Name = Replace( Replace( t.TableName, '{Y}', right(cast(y.Year as varchar(4)), 1) ), '{S}', @tableSuffix) left join
	#recCount rc on rc.Table_Name = found.Table_Name
order by
	y.Year desc, Name

drop table #recCount
drop table #consolidated

go

