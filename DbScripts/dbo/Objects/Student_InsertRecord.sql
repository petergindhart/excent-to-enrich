SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Student_InsertRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Student_InsertRecord]
GO

/*
<summary>
Inserts a new record into the Student table with the specified values
</summary>
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
<returns>The identifiers for the inserted record</returns>
<model isGenerated="False" returnType="System.Guid" />
*/
CREATE PROCEDURE dbo.Student_InsertRecord               
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
                DECLARE @id as uniqueidentifier
                SET @id = NewID()
                
                INSERT INTO Student
                (
                                Id, 
                                CurrentSchoolId, 
                                CurrentGradeLevelId, 
                                EthnicityId, 
                                GenderId, 
                                Number, 
                                FirstName, 
                                MiddleName, 
                                LastName, 
                                Ssn, 
                                Dob, 
                                Street, 
                                City, 
                                State, 
                                ZipCode, 
                                PhoneNumber, 
                                Gpa,
                                LinkedToAepSi,
								ManuallyEntered,
								IsActive,
								IsHispanic
                )
                VALUES
                (
                                @id, 
                                @currentSchoolId, 
                                @currentGradeLevelId, 
                                @ethnicityId, 
                                @genderId, 
                                @number, 
                                @firstName, 
                                @middleName, 
                                @lastName, 
                                @ssn, 
                                @dob, 
                                @street, 
                                @city, 
                                @state, 
                                @zipCode, 
                                @phoneNumber, 
                                @gpa,
                                @linkedToAepSi,
								@manuallyEntered,
								@isActive,
								@isHispanic
                )

                SELECT @id
GO



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

