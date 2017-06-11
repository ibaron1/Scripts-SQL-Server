select * from monitordb..indexusage --collected for each run

select * from monitordb..indexusage_summary


select * from monitordb..indexusage_summary
where QryPlanCount = 0 and UsedCount = 0
order by Note desc
