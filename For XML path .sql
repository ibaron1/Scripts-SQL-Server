declare @t table
(
    Id int,
    Name varchar(10)
)
insert into @t
select 1,'a' union all
select 1,'b' union all
select 2,'c' union all
select 2,'d' 

select ID,
stuff(
(
    select ','+ [Name] from @t where Id = t.Id for XML path('')
),1,1,'') 
from (select distinct ID from @t )t