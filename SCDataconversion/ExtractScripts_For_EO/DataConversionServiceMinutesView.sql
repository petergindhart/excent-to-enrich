if exists (select 1 from sys.objects where name = 'DataConversionServiceMinutesView')
drop view DataConversionServiceMinutesView
go

create view DataConversionServiceMinutesView
as
/*
	Purpose of the view is to parce a text field with the minutes of service. 
	Math is done to convert hours and fractions of hours to minutes.  
	Some of this data will not be accurate.
	This is a best-effort, and it should be understood that it will  not be 100% accurate.
	Some code gleaned from http://social.msdn.microsoft.com/Forums/sqlserver/en-US/06eb934c-4082-4d12-ab9b-5fbe68855061/removing-nonnumeric-characters-from-alphanumeric-string?forum=transactsql

*/

WITH Num1 (n) AS (SELECT 1 UNION ALL SELECT 1),
Num2 (n) AS (SELECT 1 FROM Num1 AS X, Num1 AS Y),
Num3 (n) AS (SELECT 1 FROM Num2 AS X, Num2 AS Y),
Num4 (n) AS (SELECT 1 FROM Num3 AS X, Num3 AS Y),
Nums (n) AS (SELECT ROW_NUMBER() OVER(ORDER BY n) FROM Num4),
Cleaner AS (
SELECT 
	IEPComplSeqNum, 
	ServSeqNum, 
	LeftNum, 
	Units, 
	Amount = (SELECT CASE WHEN SUBSTRING(LeftNum, n, 1) NOT LIKE '[^0-9]' THEN SUBSTRING(LeftNum, n, 1) ELSE '' END + ''
		FROM Nums
		WHERE n <= LEN(LeftNum)
		FOR XML PATH('')), 
	Fraction,
	Length
from (
	select IEPComplSeqNum, ServSeqNum, 
	LeftNum = 
		replace(
		replace(
		replace(
			case when v.length like '%.%' then 
				case when len(v.length) > 1 then
						left(v.Length, patindex('%.%', v.Length)-1)
				end
			else
				v.Length
			end,
		'1/4', ''),
		'1/2', ''),
		'3/4', ''),
	Fraction = 
		cast(case when v.Length like '% 1/4%' then 15
			when v.length like '% 1/2%' then 30
			when v.Length like '% 3/4%' then 45
			when v.Length like '1/4%h%r%' then 15
			when v.Length like '1/2%h%r%' then 30
			when v.Length like '3/4%h%r%' then 45
			when v.Length like '%[0-9].5%' then 30
			else 0
		end as int),
	v.length,
	Units = case when v.Length like '%min%' then 'minutes' when v.length like '%h[o][u]r%'  then 'hours' when v.length like '%hr%'  then 'hours' else 'times' end 
	from ICServiceTbl v 
	where Type in ('R', 'S')
	and isnull(v.del_flag,0)=0
	) t
) 

select IEPComplSeqNum, ServSeqNum, 
	Amount = case when Units = 'hours' then Amount*60 else Amount end+case when Units <> 'times' then Fraction else 0 end, Units = case when Units = 'hours' then 'minutes' else Units end, Length
from (
select IEPComplSeqNum, ServSeqNum, Amount = case when cast(isnull(Amount, '1') as int) > 1800 then 1 else cast(isnull(Amount, '1') as int) end, Fraction, Units, Length
from cleaner
) t
-- where Length like '%.5%'
-- group by case when Units = 'hours' then Amount*60 else Amount end+case when Units <> 'times' then Fraction else 0 end, Units, Length
; 
go