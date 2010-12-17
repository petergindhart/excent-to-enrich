-- #############################################################################
-- Service Frequency
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Map_ServiceFrequencyID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.Map_ServiceFrequencyID
GO

CREATE TABLE AURORAX.Map_ServiceFrequencyID
(
	ServiceFrequencyCode	varchar(5) NOT NULL,
	DestID uniqueidentifier NOT NULL
)
GO

ALTER TABLE AURORAX.Map_ServiceFrequencyID ADD CONSTRAINT
PK_Map_ServiceFrequencyID PRIMARY KEY CLUSTERED
(
	DestID
)
GO

CREATE INDEX IX_Map_ServiceFrequencyID_LRE on AURORAX.Map_ServiceFrequencyID (ServiceFrequencyCode)
GO

insert AURORAX.Map_ServiceFrequencyID values ('1','A2080478-1A03-4928-905B-ED25DEC259E6')
insert AURORAX.Map_ServiceFrequencyID values ('2','3D4B557B-0C2E-4A41-9410-BA331F1D20DD')
insert AURORAX.Map_ServiceFrequencyID values ('3','5F3A2822-56F3-49DA-9592-F604B0F202C3')
GO



-- #############################################################################
-- Service Frequency
-- 		ProviderTitle = NULL, -- populate the lookup














