-- fix various report column errors found in testing

-- remove extra DateTaken columns added in 1037
delete from VC3Reporting.ReportColumn where SchemaColumn = '79557DA7-11FE-464E-9DD1-EAF0264DA390'; delete from VC3Reporting.ReportSchemaColumn where Id='79557DA7-11FE-464E-9DD1-EAF0264DA390'; --table=TeacherCertificationExam
delete from VC3Reporting.ReportColumn where SchemaColumn = '514665B7-02F3-458F-BC74-B4F545E85A2C'; delete from VC3Reporting.ReportSchemaColumn where Id='514665B7-02F3-458F-BC74-B4F545E85A2C'; --table=(select * from StudentRosterYear where RosterYearID={Roster Year} or {Roster Year} is null)
delete from VC3Reporting.ReportColumn where SchemaColumn = '6D017605-D273-4839-AA57-07676CDB8659'; delete from VC3Reporting.ReportSchemaColumn where Id='6D017605-D273-4839-AA57-07676CDB8659'; --table=(select sglh.StudentID, sglh.GradeLevelID, ry.ID RosterYearID from StudentGradeLevelHistory sglh join RosterYear ry on dbo.DateRangesOverlap(ry.StartDate, ry.EndDate, sglh.StartDate, sglh.EndDate, @now) = 1 where ry.ID={Roster Year} or {Roster Year} is null)
delete from VC3Reporting.ReportColumn where SchemaColumn = 'C3D6FB83-DE91-471C-B07A-C69537D3C5F6'; delete from VC3Reporting.ReportSchemaColumn where Id='C3D6FB83-DE91-471C-B07A-C69537D3C5F6'; --table=Student
delete from VC3Reporting.ReportColumn where SchemaColumn = '6A5CBACD-4F4E-4457-B3F8-1F93D7193504'; delete from VC3Reporting.ReportSchemaColumn where Id='6A5CBACD-4F4E-4457-B3F8-1F93D7193504'; --table=(select * from TeacherEvaluation where RosterYearID = {Roster Year})
delete from VC3Reporting.ReportColumn where SchemaColumn = 'BC22E18A-42B9-46F3-A28B-C968EB44FC61'; delete from VC3Reporting.ReportSchemaColumn where Id='BC22E18A-42B9-46F3-A28B-C968EB44FC61'; --table=TeacherCertificate
delete from VC3Reporting.ReportColumn where SchemaColumn = '362ED671-7C32-4748-AE9A-740D097788CC'; delete from VC3Reporting.ReportSchemaColumn where Id='362ED671-7C32-4748-AE9A-740D097788CC'; --table=(select ta.Id AdministrationID, StudentID from TestAdministration ta, TestViewStudentEnrollmentView glh where dbo.DateRangesOverlap(ta.StartDate, ta.EndDate, glh.StartDate, glh.EndDate, null) = 1)
delete from VC3Reporting.ReportColumn where SchemaColumn = 'DE944F32-C275-4E70-8A61-B972B83184EB'; delete from VC3Reporting.ReportSchemaColumn where Id='DE944F32-C275-4E70-8A61-B972B83184EB'; --table=(select * from AcademicPlanReport where RosterYearID={Roster Year} or {Roster Year} is null)
delete from VC3Reporting.ReportColumn where SchemaColumn = '621F57D4-5270-41E2-AC24-292DB0CBEDA6'; delete from VC3Reporting.ReportSchemaColumn where Id='621F57D4-5270-41E2-AC24-292DB0CBEDA6'; --table=Teacher
delete from VC3Reporting.ReportColumn where SchemaColumn = 'FDB226E8-B127-41D9-B6B0-38765636968D'; delete from VC3Reporting.ReportSchemaColumn where Id='FDB226E8-B127-41D9-B6B0-38765636968D'; --table=StudentGroupStudentView
delete from VC3Reporting.ReportColumn where SchemaColumn = 'AB628C16-D74C-4E53-BDCB-B6F9399A059F'; delete from VC3Reporting.ReportSchemaColumn where Id='AB628C16-D74C-4E53-BDCB-B6F9399A059F'; --table=CertificationExam
delete from VC3Reporting.ReportColumn where SchemaColumn = 'BACA7761-CFED-4024-8A29-D0BCB4802170'; delete from VC3Reporting.ReportSchemaColumn where Id='BACA7761-CFED-4024-8A29-D0BCB4802170'; --table=Certification
delete from VC3Reporting.ReportColumn where SchemaColumn = '8239DF67-FF7D-48FC-ABAF-9020B45F03B9'; delete from VC3Reporting.ReportSchemaColumn where Id='8239DF67-FF7D-48FC-ABAF-9020B45F03B9'; --table=(select * from StudentTeacherClassRoster)
delete from VC3Reporting.ReportColumn where SchemaColumn = 'D5D3687D-BA60-4937-A3E2-041E84625087'; delete from VC3Reporting.ReportSchemaColumn where Id='D5D3687D-BA60-4937-A3E2-041E84625087'; --table=School
delete from VC3Reporting.ReportColumn where SchemaColumn = '0EE234AD-38A6-4048-923F-CA6BDBE12A40'; delete from VC3Reporting.ReportSchemaColumn where Id='0EE234AD-38A6-4048-923F-CA6BDBE12A40'; --table=(select * from StudentTeacherClassRoster where RosterYearID={Roster Year} or {Roster Year} is null)
delete from VC3Reporting.ReportColumn where SchemaColumn = 'CC773DBF-8B2D-4A41-95C4-3FD9FD49BCBB'; delete from VC3Reporting.ReportSchemaColumn where Id='CC773DBF-8B2D-4A41-95C4-3FD9FD49BCBB'; --table=TeacherCertification

-- 504Plan -> Has504Plan
update VC3Reporting.ReportSchemaColumn
set 
	ValueExpression = 'Has504Plan',
	DisplayExpression = 'case when {this}.Has504Plan = 1 then ''Yes'' else ''No'' end'
where Id='fa49d045-4470-44c0-b563-7059b0d9a8d9'

-- fix DRA columns
update VC3Reporting.ReportSchemaColumn set DisplayExpression='(select  LastName + '', '' + FirstName from Teacher where ID = dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken,''7BC1F354-2787-4C88-83F1-888D93F0E71E''))', ValueExpression='dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken,''7BC1F354-2787-4C88-83F1-888D93F0E71E'')' where Id='54847ACC-1ED2-4B7E-8825-18ADCC03936D'; --Mathematics Teacher (when tested)
update VC3Reporting.ReportSchemaColumn set DisplayExpression='(select  LastName + '', '' + FirstName from Teacher where ID = dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken,''DF2274C7-1714-44C1-A8FC-61F29D5504AC''))', ValueExpression='dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken,''DF2274C7-1714-44C1-A8FC-61F29D5504AC'')' where Id='17162DBC-92F3-4E78-8840-304DEFD7A73F'; --Language Arts Teacher (when tested)
update VC3Reporting.ReportSchemaColumn set DisplayExpression='(select  LastName + '', '' + FirstName from Teacher where ID = dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken,''C90E81B1-30CB-4D2D-B301-F4AB6A1F5E75''))', ValueExpression='dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken,''C90E81B1-30CB-4D2D-B301-F4AB6A1F5E75'')' where Id='3B02108D-9CAC-4A8E-90AD-469C00A7FCAA'; --Social Studies Teacher (when tested)
update VC3Reporting.ReportSchemaColumn set DisplayExpression='(select  LastName + '', '' + FirstName from Teacher where ID = dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken,''0351CAC6-40EE-479C-A506-DC84E77C6665''))', ValueExpression='dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken,''0351CAC6-40EE-479C-A506-DC84E77C6665'')' where Id='0CB31069-0B7E-49D6-861F-A796F9D6A70F'; --Science Teacher (when tested)



