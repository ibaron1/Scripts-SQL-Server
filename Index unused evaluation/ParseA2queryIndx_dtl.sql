if exists (select * from sysobjects where name='a2queryIndDef_dtl')
  drop table a2queryIndDef_dtl
go
create table a2queryIndDef_dtl
(ind varchar(50), tbl varchar(50), def varchar(2000), 
key1 varchar(50),key2 varchar(50) null,key3 varchar(50) null,key4 varchar(50) null,key5 varchar(50) null,key6 varchar(50) null,
key7 varchar(50) null,key8 varchar(50) null, key9 varchar(50) null,key10 varchar(50) null,key11 varchar(50) null,key12 varchar(50) null, 
key13 varchar(50) null,key14 varchar(50) null)

delete a2queryIndDef
where indDef is null
go

declare a2queryIndDef_crsr cursor for
select indDef from a2queryIndDef
--where substring(indDef,1,6) = 'CREATE'
go
set nocount on

declare @indDef varchar(2000), @indDefOut varchar(2000), @ind varchar(50), @indind int, @tbl varchar(50)
declare @keystring varchar(2000), @start int, @end int

declare @key1 varchar(50),@key2 varchar(50),@key3 varchar(50),@key4 varchar(50),@key5 varchar(50),@key6 varchar(50),
@key7 varchar(50),@key8 varchar(50), @key9 varchar(50),@key10 varchar(50),@key11 varchar(50),@key12 varchar(50), 
@key13 varchar(50),@key14 varchar(50)

open a2queryIndDef_crsr

fetch a2queryIndDef_crsr into @indDef

select @indind = patindex("%INDEX%",@indDef)
  
while @@sqlstatus <> 2
begin 
  if @indind > 0
  begin    
    select @ind = substring(@indDef, @indind+6, datalength(@indDef)-(@indind+6)+1)
    set @indDefOut = @indDef
  end
  else
  if patindex("%ON dbo%",@indDef) = 0
    set @indDefOut = @indDefOut+@indDef
  else
  begin
    set @indDefOut = @indDefOut+@indDef

    set @start = patindex("%(%",@indDef)+1

    set @tbl = substring(@indDef, 12, @start-13)

    set @end = patindex("%)%", @indDef) 
    set @keystring = substring(@indDef, @start, @end-@start)
      
    select @key1=null,@key2=null,@key3=null,@key4=null,@key5=null,@key6=null,@key7=null
    select @key8=null,@key9=null,@key10=null,@key11=null,@key12=null,@key13=null,@key14=null
    
    select @key1 = case when patindex("%,%", @keystring) > 0
                        then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                        else @keystring end 
         
    set @start = patindex("%,%", @keystring)

    if @start > 0
    begin
      select @keystring = substring(@keystring, @start+1,@end-@start)
      select @key2 = case when patindex("%,%", @keystring) > 0
                          then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                          else @keystring end
      set @start = patindex("%,%", @keystring)

      if @start > 0
      begin
        select @keystring = substring(@keystring, @start+1,@end-@start)
        select @key3 = case when patindex("%,%", @keystring) > 0
                            then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                            else @keystring end
        set @start = patindex("%,%", @keystring)

        if @start > 0
        begin
          select @keystring = substring(@keystring, @start+1,@end-@start)
          select @key4 = case when patindex("%,%", @keystring) > 0
                              then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                              else @keystring end
          set @start = patindex("%,%", @keystring)

          if @start > 0
          begin
            select @keystring = substring(@keystring, @start+1,@end-@start)
            select @key5 = case when patindex("%,%", @keystring) > 0
                                then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                                else @keystring end
            set @start = patindex("%,%", @keystring)

            if @start > 0
            begin
              select @keystring = substring(@keystring, @start+1,@end-@start)
              select @key6 = case when patindex("%,%", @keystring) > 0
                                  then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                                  else @keystring end
              set @start = patindex("%,%", @keystring)

              if @start > 0
              begin
                select @keystring = substring(@keystring, @start+1,@end-@start)
                select @key7 = case when patindex("%,%", @keystring) > 0
                                    then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                                    else @keystring end
                set @start = patindex("%,%", @keystring)

                if @start > 0
                begin
                  select @keystring = substring(@keystring, @start+1,@end-@start)
                  select @key8 = case when patindex("%,%", @keystring) > 0
                                      then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                                      else @keystring end
                  set @start = patindex("%,%", @keystring)

                  if @start > 0
                  begin
                    select @keystring = substring(@keystring, @start+1,@end-@start)
                    select @key9 = case when patindex("%,%", @keystring) > 0
                                        then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                                        else @keystring end
                    set @start = patindex("%,%", @keystring)
                    
                    if @start > 0
                    begin
                      select @keystring = substring(@keystring, @start+1,@end-@start)
                      select @key10 = case when patindex("%,%", @keystring) > 0
                                           then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                                           else @keystring end
                      set @start = patindex("%,%", @keystring)

                      if @start > 0
                      begin
                        select @keystring = substring(@keystring, @start+1,@end-@start)
                        select @key11 = case when patindex("%,%", @keystring) > 0
                                             then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                                             else @keystring end
                        set @start = patindex("%,%", @keystring)
                  
                        if @start > 0
                        begin
                          select @keystring = substring(@keystring, @start+1,@end-@start)
                          select @key12 = case when patindex("%,%", @keystring) > 0
                                               then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                                               else @keystring end
                          set @start = patindex("%,%", @keystring)
                  
                          if @start > 0
                          begin
                            select @keystring = substring(@keystring, @start+1,@end-@start)
                            select @key13 = case when patindex("%,%", @keystring) > 0
                                                 then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                                                 else @keystring end
                            set @start = patindex("%,%", @keystring)
                  
                            if @start > 0
                            begin
                              select @keystring = substring(@keystring, @start+1,@end-@start)
                              select @key14 = case when patindex("%,%", @keystring) > 0
                                                   then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                                                   else @keystring end
                              set @start = patindex("%,%", @keystring)                                    
                            end                   
                          end                       
                        end                       
                      end                                                      
                    end                                    
                  end
                end
              end
            end
          end
        end
      end
    end
    
  end

  
  fetch a2queryIndDef_crsr into @indDef
  
  select @indind = patindex("%INDEX%",@indDef)
  
  if @indind > 0
    insert a2queryIndDef_dtl
    select @ind, @tbl, @indDefOut, 
           @key1,@key2,@key3,@key4,@key5,@key6,@key7,
           @key8, @key9,@key10,@key11,@key12,@key13,@key14  
   
end

insert a2queryIndDef_dtl
select @ind, @tbl, @indDefOut, 
       @key1,@key2,@key3,@key4,@key5,@key6,@key7,
       @key8, @key9,@key10,@key11,@key12,@key13,@key14 

close a2queryIndDef_crsr
deallocate cursor a2queryIndDef_crsr

--select * from a2queryForeignKeyInd



