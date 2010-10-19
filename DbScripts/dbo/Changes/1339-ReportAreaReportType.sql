CREATE TABLE ReportAreaReportType
(
	ReportAreaID uniqueidentifier NOT NULL,
	ReportTypeID char NOT NULL	
)

ALTER TABLE dbo.ReportAreaReportType ADD CONSTRAINT
PK_ReportAreaReportType PRIMARY KEY CLUSTERED
(
	ReportAreaID, ReportTypeID
)

ALTER TABLE dbo.ReportAreaReportType ADD CONSTRAINT
FK_ReportArea#ReportTypes FOREIGN KEY (ReportAreaID) 
REFERENCES dbo.ReportArea (ID) 
	ON UPDATE  NO ACTION
	ON DELETE  CASCADE

ALTER TABLE dbo.ReportAreaReportType ADD CONSTRAINT
FK_ReportType#ReportAreas FOREIGN KEY (ReportTypeID) 
REFERENCES dbo.ReportType (ID) 
	ON UPDATE  NO ACTION 
	ON DELETE  CASCADE

--Action: RTI Program History
INSERT INTO ReportAreaReportType
VALUES('66474355-2DD2-4515-81A8-7E890E188ADF','T')

--Action: Special Ed Program History
INSERT INTO ReportAreaReportType
VALUES('808D7789-2B13-4A82-992B-C949D68EB1D1','T')

--Intervention Tools: RTI Program History
INSERT INTO ReportAreaReportType
VALUES('66474355-2DD2-4515-81A8-7E890E188ADF','N')

--Intervention Tools: RTI Strategy Effectiveness
INSERT INTO ReportAreaReportType
VALUES('0609C598-0466-4E9F-8413-9DEC50CFD8E9','N')

--Meetings: RTI Scheduling and Mgmt
INSERT INTO ReportAreaReportType
VALUES('1A5E2B3E-D3E3-4C1B-B502-81120CE5F878','M')

--Plans: RTI Program History
INSERT INTO ReportAreaReportType
VALUES('66474355-2DD2-4515-81A8-7E890E188ADF','P')

--Plans: RTI Scheduling and Mgmt
INSERT INTO ReportAreaReportType
VALUES('1A5E2B3E-D3E3-4C1B-B502-81120CE5F878','P')

--Plans: RTI Strategy Effectiveness
INSERT INTO ReportAreaReportType
VALUES('0609C598-0466-4E9F-8413-9DEC50CFD8E9','P')


INSERT INTO ReportArea
VALUES('0A325943-9C28-44D9-9363-7FBAE26C50BC', 'Teacher Certifications', NULL)

--Teacher Certification Status
INSERT INTO ReportAreaReportType
VALUES('0A325943-9C28-44D9-9363-7FBAE26C50BC','C')

--Teacher Certifications
INSERT INTO ReportAreaReportType
VALUES('0A325943-9C28-44D9-9363-7FBAE26C50BC','A')

--Teacher Evaluations
INSERT INTO ReportAreaReportType
VALUES('0A325943-9C28-44D9-9363-7FBAE26C50BC','E')

--Teacher Exams
INSERT INTO ReportAreaReportType
VALUES('0A325943-9C28-44D9-9363-7FBAE26C50BC','B')


INSERT INTO ReportArea
VALUES('0ABA081F-98BD-48CF-B0F4-AB6CC7BA07B9', 'Test Scores', NULL)

--Test Score Distribution
INSERT INTO ReportAreaReportType
VALUES('0ABA081F-98BD-48CF-B0F4-AB6CC7BA07B9','Y')

--Test Scores
INSERT INTO ReportAreaReportType
VALUES('0ABA081F-98BD-48CF-B0F4-AB6CC7BA07B9','S')