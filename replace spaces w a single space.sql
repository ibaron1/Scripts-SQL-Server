declare @a table(a varchar(400))

insert @a
select 'a   b c    '

select a,                                                    
       replace(replace(replace(a,' ','<>'),'><',''),'<>',' ')
from @a