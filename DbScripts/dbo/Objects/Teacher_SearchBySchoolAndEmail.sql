if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Teacher_SearchBySchoolAndEmail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Teacher_SearchBySchoolAndEmail]
GO
