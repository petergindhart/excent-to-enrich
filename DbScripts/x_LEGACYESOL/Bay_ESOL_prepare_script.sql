BULK
INSERT x_LEGACYESOL.ESOLStudent_LOCAL
FROM 'E:\DataFiles\FL\Bay\new\ELLStudents.csv'
WITH
(
FIELDTERMINATOR = '|',
FIRSTROW = 2,
ROWTERMINATOR = '\n'
)
GO

delete e
--select * 
from x_LEGACYESOL.ESOLStudent_LOCAL e where Startdate is null