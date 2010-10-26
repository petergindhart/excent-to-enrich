if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].CreatePercentiles') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].CreatePercentiles
GO

CREATE PROCEDURE [dbo].CreatePercentiles
	@valueColumn as varchar(1000),
	@datasetColumn as varchar(1000) = null,
	@table as varchar(1000),
	@filter as varchar(4000) = null,
	@csvPercentilesList as varchar(1000),
	@calc int output
AS

--Control class, needs to be calculated away from the other datasets
declare @percentiles table (Idx int identity primary key, PctTile float)
declare @dataset table (DataSet uniqueidentifier primary key, n int)

-- What percentiles should be calculated?
insert into @percentiles (PctTile)
select *
from dbo.Split(@csvPercentilesList, ',')

-- Build values table that will be used to calculate the percentiles
declare @sql varchar(8000)
set @sql = 'select isnull(' + isnull(@datasetColumn, 'null') + ', ''00000000-0000-0000-0000-000000000000''), ' + @valueColumn + ' 
			from ' + @table + isnull('
			where ' + @filter, '') + '
			order by ' + isnull(@datasetColumn + ', ', '') + @valueColumn

create table #vals (Idx int identity(0,1) primary key, DataSet uniqueidentifier, Value float)
insert into #vals (DataSet, Value) exec(@sql)

-- Calculate some stats about each dataset for use during the percentile calculation
insert into @dataset(DataSet, n)
select DataSet, count(*)
from #vals
group by DataSet

-- determine which call id this is for this spid
select @calc = isnull(max(_Calc)+1, 0)
from Percentiles_Results
where _Spid = @@spid

insert into Percentiles_Results
select
	@@spid,
	@calc,
	pctTile.DataSet,
	PctTile,
	Value = (vLow.Value) + (Interpolation * (vHigh.Value - vLow.Value)),
	pctTile.DataSetCount,
	pctTile.Idx
from
	  (
	  -- determine indexes for each percentile/dataset pair
	  select
			ds.Dataset,
			PctTile,
			LowIdx			= ds.offset + floor(PctTile * (n-1)),
			HighIdx			= ds.offset + ceiling(PctTile * (n-1)),
			Interpolation	= (PctTile * (n-1)) - floor(PctTile * (n-1)),
			DataSetCount = ds.N,
			x.Idx
	  from
			@percentiles x cross join
			(	
				-- calculate base offset needed to reach values for each dataset
				select ds.*, Offset = isnull(sum(dsPrior.n), 0)
				from
					  @dataset ds left join
					  @dataset dsPrior on ds.DataSet > dsPrior.DataSet
				group by
					  ds.DataSet, ds.n
			) ds
	  ) pctTile join
	  #vals vLow on vLow.Idx = pctTile.LowIdx join
	  #vals vHigh on vHigh.Idx = pctTile.HighIdx

-- Cleanup
drop table #vals

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].DeletePercentiles') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].DeletePercentiles
GO

CREATE PROCEDURE [dbo].DeletePercentiles
	@calc int
as
	delete Percentiles_Results
	where _Spid = @@spid and _Calc = @calc
GO

IF OBJECT_ID (N'dbo.Percentiles') IS NOT NULL
    DROP FUNCTION dbo.Percentiles
GO

CREATE FUNCTION dbo.Percentiles(
	@calc int
)
RETURNS TABLE
AS RETURN
(
	SELECT *
	FROM Percentiles_Results
	WHERE _Calc = @calc and _spid = @@spid
)
GO

-- clean up left over results just in case there is a leak
delete Percentiles_Results



--delete from Percentiles_Results where _Spid = @@spid

--declare @calc int
--exec CreatePercentiles @datasetColumn = 'GradeLevelID', @valueColumn='MathSS', @table='T_PACT', @filter=null, @csvPercentilesList='.1,.3,.5,.7,.9', @calc=@calc output
--select * from dbo.Percentiles(@calc)
--
--exec DeletePercentiles @calc

--drop table Percentiles_Results
--go
--create table Percentiles_Results (_Spid int not null, _Calc int not null, DataSet uniqueidentifier not null, PctTile float not null, Value float, DataSetCount int, PctTileIndex int)
--go
--alter table Percentiles_Results add constraint PK_Percentiles_Results primary key clustered (_Spid, _Calc, DataSet, PctTile)


--exec CreatePercentiles @datasetColumn = null, @valueColumn='MathSS', @table='T_PACT', @csvPercentilesList='.25,.5,.75'


