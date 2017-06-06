declare @TabSpace table  
(TabName sysname
,[Rows] bigint
,Reserved varchar(38)
,Data varchar(38)
,Index_Size varchar(38)
,Unused varchar(38)
)

insert @TabSpace  
exec sp_msForEachTable 'sp_spaceused ''?'''

select * from @TabSpace
order by cast(left(Reserved, len(Reserved)-3) as int) desc
--or
select * from @TabSpace
order by cast(stuff(Reserved, charindex(' KB',Reserved,1),len(' KB'), '') as int) desc