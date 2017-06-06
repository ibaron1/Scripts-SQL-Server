create table table_list_GPS(tbl varchar(30))
create table table_list_globalrep(tbl varchar(30))
create table table_list_CUSTOM(tbl varchar(30))


select name as tbl, user_name(p.uid) grantee,         --563
case action when 193 then 'select' when 195 then 'insert'
            when 196 then 'delete' when 197 then 'update' end as action
into GPS..RevokedTblPermiss
from sysobjects o, sysprotects p
where type='U'
and not exists
  (select '1' from tempdb4..table_list_GPS 
   where tbl = o.name)
and o.name = object_name(p.id)
and name not like 'rs[_]%'