SELECT MIN([Date]) AS RecT, AVG(Value)
  FROM [FRIIB].[dbo].[ArchiveAnalog]
  GROUP BY (DATEPART(MINUTE, [Date]) / 10)
  ORDER BY RecT

1.
group by dateadd(minute, datediff(minute, 0, DT.[Date]) / 10 * 10, 0)

It works fine across long time intervals (no collision between years or anything), and if you include it as a term in the select, 
you'll have a full datetime column that is truncated at the point you specify. 
The 10 and minute terms can be changed to any number and datepart, respectively

1.
GROUP BY
DATEPART(YEAR, DT.[Date]),
DATEPART(MONTH, DT.[Date]),
DATEPART(DAY, DT.[Date]),
DATEPART(HOUR, DT.[Date]),
(DATEPART(MINUTE, DT.[Date]) / 10)

2.
I made it ROUND((DATEPART(MINUTE, DT.[Date]) / 5),0,1) * 5, so that when I look at the data it's correlated with the nearest time slot 



2.
DATEADD(MILLISECOND, -DATEDIFF(MILLISECOND, CAST(time AS DATE), time) % @msPerSlice, time)
This works by:
Getting the number of milliseconds between a fixed point and target time:
@ms = DATEDIFF(MILLISECOND, CAST(time AS DATE), time)
Taking the remainder of dividing those milliseconds into time slices:
@rms = @ms % @msPerSlice
Adding the negative of that remainder to the target time to get the slice time:
DATEADD(MILLISECOND, -@rms, time)

