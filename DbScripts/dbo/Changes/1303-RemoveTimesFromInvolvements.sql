
update PrgInvolvement
set
	StartDate = CAST((STR(YEAR(StartDate) ) + '/' + STR(MONTH(StartDate)) + '/' +STR(DAY(StartDate))) AS DATETIME),
	EndDate = CAST((STR(YEAR(EndDate) ) + '/' + STR(MONTH(EndDate)) + '/' +STR(DAY(EndDate))) AS DATETIME)