use riskworld
go

create partition function SimulationPFN(int) as range left for values (0, 1, 2, 3, 4)

--create partition scheme SimPosPScheme as partition SimulationPFN to (rw_zero, rw_one, rw_two, rw_three, rw_four, rw_five)

create partition scheme SimPosPScheme as partition SimulationPFN all to (primary)

go

create clustered index idx_simresultbase_tst_part on simresultbase_tst_part(simulationid, positionuid, part_id) on SimPosPScheme(part_id)