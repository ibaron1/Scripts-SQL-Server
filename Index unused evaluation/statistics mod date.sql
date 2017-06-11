/************************ find date when statistics was modified for indexes & columns ***************/

select  object_name(id) 'table', moddate 'stats_moddate', colidarray, * 
from sysstatistics
where object_name(id) in
('pt_trmast')
order by moddate, colidarray


---- get column name & id to identify index

select name,colid from syscolumns
where id=object_id('pt_trmast')
