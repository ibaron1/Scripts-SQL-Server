#Find procs w forced indexes
cd a2query_Procs
grep \(index * > /ms/user/b/baroneli/QueryPlan/ProcsWForcedIndexes

cut -f2 -d':' ProcsWForcedIndexes|sort -u > ForcedIndexList.txt
