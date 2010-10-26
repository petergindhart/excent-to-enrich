SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Student_UpdateRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Student_UpdateRecord]
GO


/*
<summary>
Updates a record in the Student table with the specified values
</summary>
<param name="id">Value to assign to the ID field of the record</param>
<param name="currentSchoolId">Value to assign to the CurrentSchoolID field of the record</param>
<param name="currentGradeLevelId">Value to assign to the CurrentGradeLevelID field of the record</param>
<param name="ethnicityId">Value to assign to the EthnicityID field of the record</param>
<param name="genderId">Value to assign to the GenderID field of the record</param>
<param name="number">Value to assign to the Number field of the record</param>
<param name="firstName">Value to assign to the FirstName field of the record</param>
<param name="middleName">Value to assign to the MiddleName field of the record</param>
<param name="lastName">Value to assign to the LastName field of the record</param>
<param name="ssn">Value to assign to the SSN field of the record</param>
<param name="dob">Value to assign to the DOB field of the record</param>
<param name="street">Value to assign to the Street field of the record</param>
<param name="city">Value to assign to the City field of the record</param>
<param name="state">Value to assign to the State field of the record</param>
<param name="zipCode">Value to assign to the ZipCode field of the record</param>
<param name="phoneNumber">Value to assign to the PhoneNumber field of the record</param>
<param name="gpa">Value to assign to the GPA field of the record</param>
<param name="linkedToAepSi">Value to assign to the LinkedToAEPSi field of the record</param>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.Student_UpdateRecord
                @id uniqueidentifier, 
                @currentSchoolId uniqueidentifier, 
                @currentGradeLevelId uniqueidentifier, 
                @ethnicityId uniqueidentifier, 
                @genderId uniqueidentifier, 
                @number varchar(50), 
                @firstName varchar(50), 
                @middleName varchar(50), 
                @lastName varchar(50), 
                @ssn varchar(9), 
                @dob datetime, 
                @street varchar(100), 
                @city varchar(50), 
                @state char(2), 
                @zipCode varchar(10), 
                @phoneNumber varchar(40), 
                @gpa float,
                @linkedToAepSi bit,
                @manuallyEntered bit,
				@isActive bit,
				@isHispanic bit				
AS
                UPDATE Student
                SET
                                CurrentSchoolID = @currentSchoolId, 
                                CurrentGradeLevelID = @currentGradeLevelId, 
                                EthnicityID = @ethnicityId, 
                                GenderID = @genderId, 
                                Number = @number, 
                                FirstName = @firstName, 
                                MiddleName = @middleName, 
                                LastName = @lastName, 
                                SSN = @ssn, 
                                DOB = @dob, 
                                Street = @street, 
                                City = @city, 
                                State = @state, 
                                ZipCode = @zipCode, 
                                PhoneNumber = @phoneNumber, 
                                GPA = @gpa,
                                LinkedToAEPSi = @linkedToAepSi,
								ManuallyEntered = @manuallyEntered,
								IsActive = @isActive,
								IsHispanic = @isHispanic
                WHERE 
                                ID = @id
GO
