DELETE g
FROM
IntvGoal g JOIN
ProbeScore s ON s.ID = g.BaselineScoreID JOIN
ProbeTime t ON t.ID = s.ProbeTimeID JOIN
ProbeType ty ON t.ProbeTypeID = ty.ID
Where DataTypeID = '1074B7AE-D0A2-468C-9D3D-DDF4E3210A7B'

DELETE t
FROM
ProbeTime t JOIN
ProbeType ty ON t.ProbeTypeID = ty.ID
Where DataTypeID = '1074B7AE-D0A2-468C-9D3D-DDF4E3210A7B'

DELETE FROM ProbeDataType
WHERE ID = '1074B7AE-D0A2-468C-9D3D-DDF4E3210A7B'