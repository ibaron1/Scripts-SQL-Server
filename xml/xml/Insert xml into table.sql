You can use XML instead of flat file.

Sample structure and data:

create table XMLTable
(
  ID int,
  XMLData xml
)

insert into XMLTable values
(1, '<root>item1</root>'),
(2, '<root>item2</root>')

Query data using for xml auto:

select *
from XMLTable
for xml auto, elements

Result:

<XMLTable>
  <ID>1</ID>
  <XMLData>
    <root>item1</root>
  </XMLData>
</XMLTable>
<XMLTable>
  <ID>2</ID>
  <XMLData>
    <root>item2</root>
  </XMLData>
</XMLTable>

Load the XML to a XML data type variable in the target DB and use XQuery to insert data. Use .value() for regular columns and .query() for the XML column.

declare @XML xml

set @XML = 
'<XMLTable>
  <ID>1</ID>
  <XMLData>
    <root>item1</root>
  </XMLData>
</XMLTable>
<XMLTable>
  <ID>2</ID>
  <XMLData>
    <root>item2</root>
  </XMLData>
</XMLTable>'

insert into XMLTable(ID, XMLData)
select T.N.value('ID[1]', 'int'),
       T.N.query('XMLData/*')
from @XML.nodes('/XMLTable') as T(N)