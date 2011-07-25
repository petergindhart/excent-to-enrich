--#include Transform_School.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Student]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Student]
GO

CREATE VIEW [AURORAX].[Transform_Student]
AS
 SELECT
  src.StudentRefID,
  DestID = isnull(dest.ID, ms.DestID), -- it seems I keep changing this.  may need to use isnull
  CurrentSchoolID = sch.DestID,  
  CurrentGradeLevelID = g.ID,  
  EthnicityID = me.DestID,  
  GenderID = (select ID from EnumValue where Type = 'D6194389-17AC-494C-9C37-FD911DA2DD4B' and Code = src.Sex), -- will error if more than one value
  Number = src.StudentLocalID,  
  src.FirstName,  
  src.MiddleName,  
  src.LastName,  
  SSN = cast(null as varchar),  
  DOB = src.Birthdate,  
  Street = cast(null as varchar),  
  City = cast(null as varchar),  
  State = cast(null as char),  
  ZipCode = cast(null as varchar),  
  PhoneNumber = cast(null as varchar),  
  GPA = cast(0 as float),  
  x_SunsNumber = cast(null as varchar),  
  x_GradDate = cast(NULL as datetime),  
  x_ESOLExitDate = cast(NULL as datetime),  
  x_USSchoolEntryDate = cast(NULL as datetime),  
  x_CountryOfOrigin = cast(NULL as uniqueidentifier),  
  x_HomeLanguage = cast(NULL as uniqueidentifier),  
  x_Retain = cast(0 as bit),  
  LinkedToAEPSi = cast(0 as bit),  
  x_spedExitDate = cast(NULL as datetime),  
  x_section504 = cast(0 as bit),  
  x_language = cast(NULL as uniqueidentifier),  
  x_IEP = cast(0 as bit),
  x_giftedTalented = cast(NULL as uniqueidentifier),
  x_englishProficiency = cast(NULL as uniqueidentifier),  
  x_DisabilityType = cast(NULL as uniqueidentifier),  
  x_FreeLunchID = cast(NULL as uniqueidentifier),  
  x_CSAP_A = cast(0 as bit),  
  ManuallyEntered = cast(isnull(dest.ManuallyEntered,1) as bit), -- cast(case when dest.ID is null then 1 else 0 end as bit),  
  IsActive = cast(isnull(dest.IsActive,1) as bit),  
  IsHispanic = case when src.IsHispanic = 'Y' then 1 else 0 end,  
  ImportPausedDate = cast(NULL as datetime),  
  ImportPausedByID = cast(NULL as uniqueidentifier)  
 FROM -- NOTE:  DO NOT TOUCH THE RECORDS ADDED BY SIS IMPORT.  SIS RECORDS DO NEED TO BE MAPPED.  NEW RECORDS FROM SPED NEED TO BE ADDED. 
  AURORAX.Student src JOIN  
  AURORAX.MAP_EthnicityID me on src.EthnicityCode = me.EthnicityCode JOIN  
  dbo.GradeLevel g on src.GradeLevelCode = g.Name JOIN  
  AURORAX.MAP_SchoolView sch on src.ServiceSchoolRefID = sch.SchoolRefID LEFT JOIN  
  AURORAX.MAP_StudentRefID ms on src.StudentRefID = ms.StudentRefID LEFT JOIN  
  dbo.Student dest on src.StudentLocalID = dest.Number and src.LastName = dest.LastName
GO
--
