select distinct object_name(i.id), db_name(m.DBID)
from master..monOpenObjectActivity m,
     sysindexes i
where  db_name(m.DBID) = 'GPS'
and    m.ObjectID = i.id
and    m.IndexID  = i.indid
and object_name(i.id) = i.name
and m.OptSelectCount = 0