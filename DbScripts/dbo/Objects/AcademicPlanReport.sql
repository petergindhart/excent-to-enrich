IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'AcademicPlanReport')
    DROP VIEW dbo.AcademicPlanReport
GO

-- dynamically generate the view so that we can incorporate any status columns in the form of extended properties
DECLARE @sql VARCHAR(8000)
SET @sql = '
CREATE VIEW dbo.AcademicPlanReport
AS 
	select
		ap.ID,
		ap.StudentID,
		ap.RosterYearID,
		ap.SchoolID,
		ap.GradeLevelID,
		ap.ReasonID,
		ap.Street,
		ap.City,
		ap.State,
		ap.ZipCode,
		ap.PhoneNumber,
		ap.DetailedReason,
		ap.GeneratorID,
		SupersededByIEP						= ela.SupersededByIEP | math.SupersededByIEP | sci.SupersededByIEP | ss.SupersededByIEP,
		ReasonText							= case when ReasonID is not null then  (select Description from AcademicPlanReason where Id=ReasonID) else  DetailedReason end,

		ela_IsSelected						= ela.IsSelected,
		ela_StatusID						= ela.StatusID,
		ela_EndOfYearConsequenceID			= ela.EndOfYearConsequenceID,
		ela_EndOfSummerSchoolConsequenceID	= ela.EndOfSummerSchoolConsequenceID,
		ela_SecondYear						= ela.SecondYear,
		ela_SupersededByIEP					= ela.SupersededByIEP,
	
		math_IsSelected						= math.IsSelected,
		math_StatusID						= math.StatusID,
		math_EndOfYearConsequenceID			= math.EndOfYearConsequenceID,
		math_EndOfSummerSchoolConsequenceID	= math.EndOfSummerSchoolConsequenceID,
		math_SecondYear						= math.SecondYear,
		math_SupersededByIEP				= math.SupersededByIEP,
	
		sci_IsSelected						= sci.IsSelected,
		sci_StatusID						= sci.StatusID,
		sci_EndOfYearConsequenceID			= sci.EndOfYearConsequenceID,
		sci_EndOfSummerSchoolConsequenceID	= sci.EndOfSummerSchoolConsequenceID,
		sci_SecondYear						= sci.SecondYear,
		sci_SupersededByIEP					= sci.SupersededByIEP,
	
		ss_IsSelected						= ss.IsSelected,
		ss_StatusID							= ss.StatusID,
		ss_EndOfYearConsequenceID			= ss.EndOfYearConsequenceID,
		ss_EndOfSummerSchoolConsequenceID	= ss.EndOfSummerSchoolConsequenceID,
		ss_SecondYear						= ss.SecondYear,
		ss_SupersededByIEP					= ss.SupersededByIEP'
	
SELECT @sql = @sql + REPLACE(',

		ela_{ColumnName}ID							= ela.{ColumnName},
		math_{ColumnName}ID							= math.{ColumnName},
		sci_{ColumnName}ID							= sci.{ColumnName},
		ss_{ColumnName}ID							= ss.{ColumnName}', '{ColumnName}', ColumnName) 
FROM 
	ExtendedPropertyDefinition
WHERE 
	ExtendedPropertyTypeDefinitionID = '37138D7C-DED4-4170-8AAE-06571E69BF3B' AND EnumTypeId IS NOT NULL
	
SET @sql = @sql + '
	from 
		AcademicPlan ap join
		AcademicPlanSubject ela on ap.Id = ela.AcademicPlanID and ela.SubjectID = ''DF2274C7-1714-44C1-A8FC-61F29D5504AC'' join
		AcademicPlanSubject math on ap.Id = math.AcademicPlanID and math.SubjectID = ''7BC1F354-2787-4C88-83F1-888D93F0E71E'' join
		AcademicPlanSubject sci on ap.Id = sci.AcademicPlanID and sci.SubjectID = ''0351CAC6-40EE-479C-A506-DC84E77C6665'' join
		AcademicPlanSubject ss on ap.Id = ss.AcademicPlanID and ss.SubjectID = ''C90E81B1-30CB-4D2D-B301-F4AB6A1F5E75'''

EXEC(@sql)