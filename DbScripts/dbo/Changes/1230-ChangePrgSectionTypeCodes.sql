BEGIN TRAN
SET XACT_ABORT ON

UPDATE PrgSectionType SET Code = 'Assessments' WHERE Code = 'iepassess'
UPDATE PrgSectionType SET Code = 'Goals' WHERE Code = 'iepgoals'
UPDATE PrgSectionType SET Code = 'PostSchool' WHERE Code = 'ieppostsch'
UPDATE PrgSectionType SET Code = 'Accomodations' WHERE Code = 'iepaccoms'
UPDATE PrgSectionType SET Code = 'Demographics' WHERE Code = 'iepdemo'
UPDATE PrgSectionType SET Code = 'Services' WHERE Code = 'iepserv'
UPDATE PrgSectionType SET Code = 'LRE' WHERE Code = 'ieplre'
UPDATE PrgSectionType SET Code = 'SpecialFactors' WHERE Code = 'iepspfact'
UPDATE PrgSectionType SET Code = 'PresentLevels' WHERE Code = 'ieppreslvl'

SELECT * FROM PrgSectionType

--ROLLBACK
COMMIT
