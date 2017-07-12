create table a(a int identity constraint PK_a primary key,
b int);

create table b(a int constraint FK_a references a(a), b int);

insert a(b) values(2)

insert b values(scope_identity(), 4)

select * from a
select * from b