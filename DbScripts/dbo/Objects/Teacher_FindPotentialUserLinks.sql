

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Teacher_FindPotentialUserLinks]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Teacher_FindPotentialUserLinks]
GO

 /*
<summary>
Finds teacher records that may be related to a user.  Results are sorted
in highest to lowest confidence order
</summary>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Teacher_FindPotentialUserLinks
	@userID				uniqueidentifier,
	@moreResults		bit
AS

declare @firstName varchar(50)
declare @lastName varchar(50)
declare @schoolID uniqueidentifier

select
	@firstName = FirstName,
	@lastName = LastName,
	@schoolID = SchoolID
from
	UserProfileView
where
	Id = @userId

select *
from
(
	select
		Confidence = (case
			-- exact FN and exact LN
			when FirstName = @firstName and LastName = @lastName then 1.0

			-- similar FN and exact LN
			when soundex(FirstName) = soundex(@firstName) and LastName = @lastName then 0.9

			-- exact FN and similar LN
			when FirstName = @firstName and soundex(LastName) = soundex(@lastName) then 0.8

			-- exact FN (to handle the marriage case)
			when FirstName = @firstName then 0.2

			-- no match
			else 0 end) 
			
			-- Less confidence when teacher is at a different school
			* (case when CurrentSchoolID = @schoolID then 1.0 else 0.75 end)

			-- Less confidence when teacher is already linked to another user
			* (case when UserProfileID is null then 1.0 else 0.75 end),
		*
	from
		Teacher
	where
		(UserProfileID <> @userId Or UserProfileID is null) and
		CurrentSchoolID is not null
) matches
where
	Confidence = 1 or (@moreResults = 1 and Confidence > 0)
order by
	Confidence desc, FirstName, LastName

GO
--
--select * from userprofile where id='EDD28DC1-DAD9-4C59-9115-0185EF26505B'
--exec Teacher_FindPotentialUserLinks 'EDD28DC1-DAD9-4C59-9115-0185EF26505B', 1
--exec Teacher_FindPotentialUserLinks 'EDD28DC1-DAD9-4C59-9115-0185EF26505B', 0
--
--
--select * from userprofile where id='FED8B564-6A62-4DCE-89A1-0556DC489AC1'
--exec Teacher_FindPotentialUserLinks 'FED8B564-6A62-4DCE-89A1-0556DC489AC1', 1
--exec Teacher_FindPotentialUserLinks 'FED8B564-6A62-4DCE-89A1-0556DC489AC1', 0
--
--select * from userprofile where id='34F89510-43CC-4530-BFFA-113D3A46D09F'
--exec Teacher_FindPotentialUserLinks '34F89510-43CC-4530-BFFA-113D3A46D09F', 1
--exec Teacher_FindPotentialUserLinks '34F89510-43CC-4530-BFFA-113D3A46D09F', 0
--
--
--select * from userprofile where id='C7E19004-A60C-4A60-AE3B-6E7CD6F37C19'
--exec Teacher_FindPotentialUserLinks 'C7E19004-A60C-4A60-AE3B-6E7CD6F37C19', 1
--exec Teacher_FindPotentialUserLinks 'C7E19004-A60C-4A60-AE3B-6E7CD6F37C19', 0
--
--
--select * from userprofile where id='80DD8ED2-EA98-4719-B06E-A8CA9196568B'
--exec Teacher_FindPotentialUserLinks '80DD8ED2-EA98-4719-B06E-A8CA9196568B', 1
--exec Teacher_FindPotentialUserLinks '80DD8ED2-EA98-4719-B06E-A8CA9196568B', 0

--select * from Teacher where userprofileid is not null order by lastname, firstname

--select * from userprofile where lastname = 'brown' and soundex(firstname) = soundex('christina')

