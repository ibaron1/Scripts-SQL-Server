truncate table loadtest.FileLoadHistory
-- truncate table loadtest.LoggerErrorHistory

insert loadtest.LoggerError
select * from loadtest.LoggerErrorHistory

update loadtest.LoggerError
set replay = 2

update loadtest.FileLoad
set replay = replay -- 4 -> no matter what value will be assign for update the actual updated value will be replay+1
where loadId = 12

select * from loadtest.FileLoad
where loadId = 12
select * from loadtest.LoggerError
where loadId = 12


select * from loadtest.FileLoadHistory
where loadId = 12
select * from loadtest.LoggerErrorHistory
where loadId = 12

