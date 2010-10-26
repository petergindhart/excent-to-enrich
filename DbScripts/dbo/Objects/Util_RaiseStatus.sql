SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Util_RaiseStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Util_RaiseStatus]
GO

create procedure Util_RaiseStatus
	@BeginTime datetime,
	@Msg varchar(100)
AS

declare
	@CurrentTime datetime,
	@DeltaTime int

set @CurrentTime = getdate()
set @DeltaTime = datediff( ss, @BeginTime, @CurrentTime )
set @Msg = @Msg + '	{' + cast( @DeltaTime as varchar(20) ) + ' sec}'

raiserror( @Msg, 0, 1 ) WITH NOWAIT


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

