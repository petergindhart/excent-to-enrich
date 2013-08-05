select StudentRefID = s.GStudentID, EPRefID = ic.IEPSeqNum,  StudentID = s.StudentiD, s.Firstname, s.Lastname, Birthdate = isnull(convert(varchar, s.Birthdate, 101), ''), 
	EPMeetingDate = isnull(convert(varchar, ic.MeetDate, 101), ''),
	-- EPInitDate = isnull(convert(varchar, ic.InitDate, 101),  ''),
	LastEPDate = isnull(convert(varchar, ic.LastIEPDate, 101),  ''),
	-- EPSpecReviewDate = isnull(convert(varchar, ic.ReEvalDate, 101),  ''),
	DurationDate = isnull(convert(varchar, ic.Durationdate, 101),  '')
from SpecialEdStudentsAndIEPs x 
join IEPCompleteTbl ic on x.iepseqnum = ic.iepseqnum
join student s on ic.gstudentid = s.gstudentid 
where x.SpedOrGifted = 'Gifted'
