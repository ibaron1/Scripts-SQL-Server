select 'select '+"'dbname: "+name+"'"+char(10)+'exec '+name+'..sp_spaceused syslogs' 
from master..sysdatabases
