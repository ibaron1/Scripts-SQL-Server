
if object_id('tfm.trg_FileLoadReplay') is not null
  drop trigger tfm.trg_FileLoadReplay
GO
/********************************************
Author. Eli Baron
Date created. 10-24-2017
Purpose. To maintain replay and its history 
********************************************/
create trigger tfm.trg_FileLoadReplay
on tfm.FileLoad 
after update
as

set nocount on

if update(replay)
begin
	insert tfm.FileLoadHistory
	select * from deleted

	delete le
	output deleted.* into tfm.LoggerErrorHistory
	from LoggerError as le
	join deleted as d
	on le.loadId = d.loadId
	and (le.replay = d.replay or le.replay is null and d.replay is null)

	delete le
	output deleted.* into tfm.LoadErrorHistory
	from LoadError as le
	join deleted as d
	on le.loadId = d.loadId
	and (le.replay = d.replay or le.replay is null and d.replay is null)

	update fl
	set replay = isnull(d.replay,0) + 1
	from tfm.FileLoad as fl
	join deleted as d
	on fl.loadId = d.loadId
end


if trigger_nestlevel(object_id('tfm.trg_FileLoadReplay') , 'AFTER' , 'DML' ) <= 1 
  return


GO
