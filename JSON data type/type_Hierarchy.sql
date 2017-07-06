-- Create the data type  IF EXISTS (SELECT * FROM sys.types WHERE name LIKE 'Hierarchy')
  DROP TYPE dbo.Hierarchy
go
CREATE TYPE dbo.Hierarchy AS TABLE
(
   element_id INT NOT NULL, /* internal surrogate primary key gives the order of parsing and the list order */
   sequenceNo [int] NULL, /* the place in the sequence for the element */
	   parent_ID INT,/* if the element has a parent then it is in this column. The document is the ultimate parent, so you can get the structure from recursing from the document */
   [Object_ID] INT,/* each list or object has an object id. This ties all elements to a parent. Lists are treated as objects here */
   NAME NVARCHAR(2000),/* the name of the object, null if it hasn't got one */
   StringValue NVARCHAR(MAX) NOT NULL,/*the string representation of the value of the element. */
   ValueType VARCHAR(10) NOT null /* the declared type of the value represented as a string in StringValue*/
    PRIMARY KEY (element_id)
)