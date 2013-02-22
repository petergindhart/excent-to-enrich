set nocount on;

SELECT s.Email ,SchoolID
FROM StaffSchool ss JOIN Staff s ON s.StaffGID = ss.StaffGID 
WHERE ss.DeleteID is NULL 

