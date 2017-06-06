

select object_name(p.id) Object_Name,
o.type,
case protecttype  when '205' then 'Grant'  
 when '206' then 'Deny'  
 else 'Grant' 
     end +  ' ' + 
      case action
 when '26'  then 'REFERENCES ' 
 when '178' then 'CREATE FUNCTION'
 when '193' then 'SELECT  ' 
 when '195' then 'INSERT  '
 when '196' then 'DELETE  '
 when '197' then 'UPDATE  '
 when '198' then 'CREATE TABLE'
 when '203' then 'CREATE DATABASE'
 when '207' then 'CREATE VIEW' 
 when '222' then 'CREATE PROCEDURE' 
 when '224' then 'EXECUTE  '
 when '233' then 'CREATE DEFAULT'
 when '236' then 'CREATE RULE' 
end  + '' +
 case protecttype
 when '204' then 'with Grant'  
 else '' 
     end as Permission,
user_name(p.uid) Grantee
 from sysprotects p join sysobjects o
on p.id = o.id
and object_name(o.id) not like 'dt[_]%' 
and object_name(o.id) <> 'dtproperties'
and object_name(o.id) not like 'sys%'
order by o.type, object_name(p.id)

