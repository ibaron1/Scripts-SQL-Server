#!/bin/ksh
set -x
###################################
# 2 parameters:
#
# 1 - proc name
# 2 - how many times to execute it
###################################

N=$2

if [[ -z "$N" ]]
then
  N=1
fi

chmod 400 p

isql -Ubaroneli -SLNQ_DARWIN2 -o$1.${N}times.out -P`cat p` <<EOF

declare @a datetime,  @i int

select @a=getdate(), @i=1

set triggers off

while @i <= $N
begin
  exec $1
  set @i = @i + 1
end

select '$1' as SP,
datediff(ms, @a, getdate()) as 'Time exec it $N times in ms'
go
EOF

chmod 000 p