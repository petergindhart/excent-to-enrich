if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgItem_GetDateRangeForStudent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgItem_GetDateRangeForStudent]
GO
