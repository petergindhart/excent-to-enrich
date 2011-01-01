IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'AURORAX.Service_Data_LOCAL') AND type in (N'U'))
DROP TABLE AURORAX.Service_Data_LOCAL
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'AURORAX.Service_Data'))
DROP VIEW AURORAX.Service_Data
GO

CREATE TABLE AURORAX.Service_Data_LOCAL(
PKID							INT,
SASID							varchar(20),
BeginDate					datetime,
EndDate						datetime,
IsRelated					varchar(1), -- should be a bit?
IsDirect						varchar(1),
ExcludesFromGenEd			varchar(1),
ServiceLocationCode		varchar(5),
ProviderTitleID			varchar(10),
Sequence						varchar(5),
IsEsy							varchar(1),
ServiceTime					varchar(10),
ServiceTimeUnitCode		varchar(1),
ServiceFrequencyCode    varchar(3),
ServiceProviderSSN		varchar(15)
)
GO


CREATE VIEW AURORAX.Service_Data
AS
	SELECT * FROM AURORAX.Service_Data_LOCAL
GO

-- #############################################################################

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'AURORAX.MAP_IepServiceID') AND type in (N'U'))
DROP TABLE AURORAX.MAP_IepServiceID
GO

CREATE TABLE AURORAX.MAP_IepServiceID (
PKID INT not null,
DestID	uniqueidentifier not null
)


