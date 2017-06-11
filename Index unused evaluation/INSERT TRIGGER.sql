create trigger ins_indexusage
on indexusage
for insert
as
delete indexusage
where ReportDate <= convert(char(8), dateadd(day,-30,getdate()),112)