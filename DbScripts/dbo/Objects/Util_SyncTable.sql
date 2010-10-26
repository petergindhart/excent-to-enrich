-- =============================================
-- Create procedure basic template
-- =============================================
-- creating the store procedure
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Util_SyncTable' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.Util_SyncTable
GO

--'Student:#Map_Student; Teacher:#Map_Teacher;'

CREATE PROCEDURE dbo.Util_SyncTable
	@srcDb		varchar(300),
	@tblList	varchar(8000),
	@idmapList	varchar(8000),
	@runSql 	bit = 0,
	@printSql	bit = 1
AS

begin tran

declare @tbl table (Name varchar(300), Sequence int identity)

insert into @tbl (Name)
select ltrim(rtrim(Item)) 
from dbo.Split(@tblList, ',')

declare @idmap table (RefTbl varchar(300),  MapTbl varchar(300))

if not(@idmapList is null)
	insert into @idmap
	select
		RefTbl 	= rtrim(ltrim(left(Item, charindex(':', Item) - 1))),
		MapTbl	= rtrim(ltrim(right(Item, len(Item)-charindex(':', Item))))
	from 
		dbo.Split(@idmapList, ',') item

declare @srcTbl		varchar(300)
declare @destTbl	varchar(8000)
declare @sql		varchar(8000)
declare @insCols	varchar(8000)
declare @insVals	varchar(8000)
declare @insTbls	varchar(8000)
declare @insFltr	varchar(8000)
declare @mnum		int
declare @col 		varchar(300)
declare @refTbl 	varchar(300)
declare @refCol		varchar(300)
declare @mapTbl		varchar(300)


-- DELETE
declare tbl_cursor cursor for
select 
	@srcDb + '..' + Name,
	Name
from @tbl
order by Sequence ASC

open tbl_cursor

fetch next from tbl_cursor into @srcTbl, @destTbl

while @@fetch_status = 0
begin
	set @sql = 	'delete from ' + @destTbl
	exec RunSql @sql, @runSql, @printSql
	
	if @@error <> 0
	begin
		close tbl_cursor
		deallocate tbl_cursor
		goto HandleError
	end

	fetch next from tbl_cursor into @srcTbl, @destTbl
end 

close tbl_cursor
deallocate tbl_cursor


-- INSERT in reverse order
declare tbl_cursor cursor for
select 
	@srcDb + '..' + Name,
	Name
from @tbl
order by Sequence DESC

open tbl_cursor

fetch next from tbl_cursor into @srcTbl, @destTbl

while @@fetch_status = 0
begin
	set @insCols 	= null
	set @insVals 	= null
	set @insTbls	= ''
	set @insFltr	= null

	set @mnum 		= 1

	declare col_cursor cursor for
	select 
		col.COLUMN_NAME, 
		Pk_TABLE_NAME, 
		PK_COLUMN_NAME,
		mid.MapTbl
	from 
		INFORMATION_SCHEMA.Columns col left join 
		(
			select
				fk.TABLE_NAME 	FK_TABLE_NAME,
				fk.COLUMN_NAME 	FK_COLUMN_NAME,
				pk.TABLE_NAME 	PK_TABLE_NAME, 
				pk.COLUMN_NAME 	PK_COLUMN_NAME
			from
				INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE fk join
				INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS cons on fk.Constraint_Name = cons.Constraint_Name join
				INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE pk on cons.Unique_Constraint_Name = pk.Constraint_Name
		) ref on col.TABLE_NAME = ref.FK_TABLE_NAME and col.COLUMN_NAME = ref.FK_COLUMN_NAME left join
		@idmap mid on mid.RefTbl = PK_TABLE_NAME
	where 
		col.TABLE_NAME = @destTbl

	open col_cursor
	
	fetch next from col_cursor 
	into @col, @refTbl, @refCol, @mapTbl
	
	while @@fetch_status = 0
	begin	

		set @insCols = isnull(@insCols + ', ', '') + @col
	
		if @mapTbl is not null
		begin
			set @insVals = isnull(@insVals + ', ', '') + 'm' + cast(@mnum as varchar(10)) + '.DestID'
			set @insTbls = @insTbls + ' left join' + char(13) + @mapTbl + ' m' + cast(@mnum as varchar(10)) + ' on m' + cast(@mnum as varchar(10)) + '.SrcID = s.' + @col
			set @insFltr = isnull(@insFltr + ' and ', '') + '((m' + cast(@mnum as varchar(10)) + '.DestID is NOT null and s.' + @col + ' is NOT null) OR (m' + cast(@mnum as varchar(10)) + '.DestID is null and s.' + @col + ' is null))'

			set @mnum = @mnum + 1
		end
		else
			set @insVals = isnull(@insVals + ', ', '') + 's.' + @col


		fetch next from col_cursor 
		into @col, @refTbl, @refCol, @mapTbl
	end
	close col_cursor
	deallocate col_cursor

	set @sql =	'insert into ' + @destTbl + ' (' + @insCols + ')' + char(13) + 
				'select ' + @insVals + char(13) +
				'from ' + @srcTbl + ' s' +  @insTbls + char(13) +
				isnull( 'where ' + @insFltr , '')
	
	exec RunSql @sql, @runSql, @printSql

	if @@error <> 0
	begin
		close tbl_cursor
		deallocate tbl_cursor
		goto HandleError
	end

	fetch next from tbl_cursor into @srcTbl, @destTbl
end 

close tbl_cursor
deallocate tbl_cursor

commit transaction
return

HandleError:
	rollback transaction
GO

-- =============================================
-- example to execute the store procedure
-- =============================================
/*
EXECUTE Util_SyncTable 
	'TestView_SC_Richland2_After', 
	'T_PACT_3, TestImport, StudentGroupStudent', 
	'Student: #Map_Student, Teacher: #Map_Teacher'
*/
GO
