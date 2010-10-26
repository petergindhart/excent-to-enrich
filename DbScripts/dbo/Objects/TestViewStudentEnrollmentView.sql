IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TestViewStudentEnrollmentView]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].TestViewStudentEnrollmentView
GO

CREATE VIEW TestViewStudentEnrollmentView
AS
SELECT
	studentID,
	MIN(startDate) AS StartDate,
	case when MAX(case when EndDate is null then '2050-08-20 00:00:00.000' else EndDate end) = '2050-08-20 00:00:00.000' then null else MAX(case when EndDate is null then '2050-08-20 00:00:00.000' else EndDate end) end EndDate
FROM
	StudentGradeLevelHistory
GROUP BY
	studentID