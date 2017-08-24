select 
    ArrivalDateTime = dateadd(mi,datediff(mi,0,ArrivalDateTime),0),
    rows = count(1)
 from srf_main.TradeMessage
 where ArrivalDateTime between '2013-01-04 00:00:00.000' and '2013-02-18 23:59:59.999'
 group by dateadd(minute,datediff(mi,0,ArrivalDateTime),0)
 order by rows desc

 select 
    SubmissionDateTime = dateadd(mi,datediff(mi,0,SubmissionDateTime),0),
    rows = count(1)
 from srf_main.TradeMessage
 where SubmissionDateTime between '2013-01-04 00:00:00.000' and '2013-02-18 23:59:59.999'
 group by dateadd(minute,datediff(mi,0,SubmissionDateTime),0)
 order by rows desc