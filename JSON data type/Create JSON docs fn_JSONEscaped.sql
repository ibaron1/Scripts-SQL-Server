/* https://www.simple-talk.com/sql/t-sql-programming/consuming-json-strings-in-sql-server/

ToJSON. A function that creates JSON Documents
Firstly, we need a simple utility function:
*/

IF OBJECT_ID (N'dbo.parseJSON') IS NOT NULL     DROP FUNCTION dbo.JSONEscaped
GO
 
CREATE FUNCTION JSONEscaped ( /* this is a simple utility function that takes a SQL String with all its clobber and outputs it as a sting with all the JSON escape sequences in it.*/
  @Unescaped NVARCHAR(MAX) --a string with maybe characters that will break json
  )
RETURNS NVARCHAR(MAX)
AS 
BEGIN
  SELECT  @Unescaped = REPLACE(@Unescaped, FROMString, TOString)
  FROM    (SELECT
            '\"' AS FromString, '"' AS ToString
           UNION ALL SELECT '\', '\\'
           UNION ALL SELECT '/', '\/'
           UNION ALL SELECT  CHAR(08),'\b'
           UNION ALL SELECT  CHAR(12),'\f'
           UNION ALL SELECT  CHAR(10),'\n'
           UNION ALL SELECT  CHAR(13),'\r'
           UNION ALL SELECT  CHAR(09),'\t'
          ) substitutions
RETURN @Unescaped
END

go

--And now, the function that takes a JSON Hierarchy table and converts it to a JSON string.

CREATE FUNCTION ToJSON
	(
	      @Hierarchy Hierarchy READONLY
	)
	 
	/*
	the function that takes a Hierarchy table and converts it to a JSON string
	 
	Author: Phil Factor
	Revision: 1.5
	date: 1 May 2014
	why: Added a fix to add a name for a list.
	example:
	 
	Declare @XMLSample XML
	Select @XMLSample='
	  <glossary><title>example glossary</title>
	  <GlossDiv><title>S</title>
	   <GlossList>
	    <GlossEntry id="SGML"" SortAs="SGML">
	     <GlossTerm>Standard Generalized Markup Language</GlossTerm>
	     <Acronym>SGML</Acronym>
	     <Abbrev>ISO 8879:1986</Abbrev>
	     <GlossDef>
	      <para>A meta-markup language, used to create markup languages such as DocBook.</para>
	      <GlossSeeAlso OtherTerm="GML" />
	      <GlossSeeAlso OtherTerm="XML" />
	     </GlossDef>
	     <GlossSee OtherTerm="markup" />
	    </GlossEntry>
	   </GlossList>
	  </GlossDiv>
	 </glossary>'
	 
	DECLARE @MyHierarchy Hierarchy -- to pass the hierarchy table around
	insert into @MyHierarchy select * from dbo.ParseXML(@XMLSample)
	SELECT dbo.ToJSON(@MyHierarchy)
	 
	       */
	RETURNS NVARCHAR(MAX)--JSON documents are always unicode.
	AS
	BEGIN
	  DECLARE
	    @JSON NVARCHAR(MAX),
	    @NewJSON NVARCHAR(MAX),
	    @Where INT,
	    @ANumber INT,
	    @notNumber INT,
	    @indent INT,
	    @ii int,
	    @CrLf CHAR(2)--just a simple utility to save typing!
	      
	  --firstly get the root token into place 
	  SELECT @CrLf=CHAR(13)+CHAR(10),--just CHAR(10) in UNIX
	         @JSON = CASE ValueType WHEN 'array' THEN 
	         +COALESCE('{'+@CrLf+'  "'+NAME+'" : ','')+'[' 
	         ELSE '{' END
	            +@CrLf
	            + case when ValueType='array' and NAME is not null then '  ' else '' end
	            + '@Object'+CONVERT(VARCHAR(5),OBJECT_ID)
	            +@CrLf+CASE ValueType WHEN 'array' THEN
	            case when NAME is null then ']' else '  ]'+@CrLf+'}'+@CrLf end
	                ELSE '}' END
	  FROM @Hierarchy 
	    WHERE parent_id IS NULL AND valueType IN ('object','document','array') --get the root element
	/* now we simply iterat from the root token growing each branch and leaf in each iteration. This won't be enormously quick, but it is simple to do. All values, or name/value pairs withing a structure can be created in one SQL Statement*/
	  Select @ii=1000
	  WHILE @ii>0
	    begin
	    SELECT @where= PATINDEX('%[^[a-zA-Z0-9]@Object%',@json)--find NEXT token
	    if @where=0 BREAK
	    /* this is slightly painful. we get the indent of the object we've found by looking backwards up the string */ 
	    SET @indent=CHARINDEX(char(10)+char(13),Reverse(LEFT(@json,@where))+char(10)+char(13))-1
	    SET @NotNumber= PATINDEX('%[^0-9]%', RIGHT(@json,LEN(@JSON+'|')-@Where-8)+' ')--find NEXT token
	    SET @NewJSON=NULL --this contains the structure in its JSON form
	    SELECT  
	        @NewJSON=COALESCE(@NewJSON+','+@CrLf+SPACE(@indent),'')
	        +case when parent.ValueType='array' then '' else COALESCE('"'+TheRow.NAME+'" : ','') end
	        +CASE TheRow.valuetype
	        WHEN 'array' THEN '  ['+@CrLf+SPACE(@indent+2)
	           +'@Object'+CONVERT(VARCHAR(5),TheRow.[OBJECT_ID])+@CrLf+SPACE(@indent+2)+']' 
	        WHEN 'object' then '  {'+@CrLf+SPACE(@indent+2)
	           +'@Object'+CONVERT(VARCHAR(5),TheRow.[OBJECT_ID])+@CrLf+SPACE(@indent+2)+'}'
	        WHEN 'string' THEN '"'+dbo.JSONEscaped(TheRow.StringValue)+'"'
	        ELSE TheRow.StringValue
	       END 
	     FROM @Hierarchy TheRow 
	     inner join @hierarchy Parent
	     on parent.element_ID=TheRow.parent_ID
	      WHERE TheRow.parent_id= SUBSTRING(@JSON,@where+8, @Notnumber-1)
	     /* basically, we just lookup the structure based on the ID that is appended to the @Object token. Simple eh? */
	    --now we replace the token with the structure, maybe with more tokens in it.
	    Select @JSON=STUFF (@JSON, @where+1, 8+@NotNumber-1, @NewJSON),@ii=@ii-1
	    end
	  return @JSON
	end

go

/*
ToXML. A function that creates XML
The function that converts a hierarchy  table to XML gives us a JSON to XML converter. It is surprisingly similar to the previous function
*/

IF OBJECT_ID (N'dbo.ToXML') IS NOT NULL
   DROP FUNCTION dbo.ToXML
GO
CREATE FUNCTION ToXML
(
/*this function converts a Hierarchy table into an XML document. This uses the same technique as the toJSON function, and uses the 'entities' form of XML syntax to give a compact rendering of the structure */
      @Hierarchy Hierarchy READONLY
)
RETURNS NVARCHAR(MAX)--use unicode.
AS
BEGIN
  DECLARE
    @XMLAsString NVARCHAR(MAX),
    @NewXML NVARCHAR(MAX),
    @Entities NVARCHAR(MAX),
    @Objects NVARCHAR(MAX),
    @Name NVARCHAR(200),
    @Where INT,
    @ANumber INT,
    @notNumber INT,
    @indent INT,
    @CrLf CHAR(2)--just a simple utility to save typing!
      
  --firstly get the root token into place 
  --firstly get the root token into place 
  SELECT @CrLf=CHAR(13)+CHAR(10),--just CHAR(10) in UNIX
         @XMLasString ='<?xml version="1.0" ?>
@Object'+CONVERT(VARCHAR(5),OBJECT_ID)+'
'
    FROM @hierarchy 
    WHERE parent_id IS NULL AND valueType IN ('object','array') --get the root element
/* now we simply iterate from the root token growing each branch and leaf in each iteration. This won't be enormously quick, but it is simple to do. All values, or name/value pairs within a structure can be created in one SQL Statement*/
  WHILE 1=1
    begin
    SELECT @where= PATINDEX('%[^a-zA-Z0-9]@Object%',@XMLAsString)--find NEXT token
    if @where=0 BREAK
    /* this is slightly painful. we get the indent of the object we've found by looking backwards up the string */ 
    SET @indent=CHARINDEX(char(10)+char(13),Reverse(LEFT(@XMLasString,@where))+char(10)+char(13))-1
    SET @NotNumber= PATINDEX('%[^0-9]%', RIGHT(@XMLasString,LEN(@XMLAsString+'|')-@Where-8)+' ')--find NEXT token
    SET @Entities=NULL --this contains the structure in its XML form
    SELECT @Entities=COALESCE(@Entities+' ',' ')+NAME+'="'
     +REPLACE(REPLACE(REPLACE(StringValue, '<', '&lt;'), '&', '&amp;'),'>', '&gt;')
     + '"'  
       FROM @hierarchy 
       WHERE parent_id= SUBSTRING(@XMLasString,@where+8, @Notnumber-1) 
          AND ValueType NOT IN ('array', 'object')
    SELECT @Entities=COALESCE(@entities,''),@Objects='',@name=CASE WHEN Name='-' THEN 'root' ELSE NAME end
      FROM @hierarchy 
      WHERE [Object_id]= SUBSTRING(@XMLasString,@where+8, @Notnumber-1) 
    
    SELECT  @Objects=@Objects+@CrLf+SPACE(@indent+2)
           +'@Object'+CONVERT(VARCHAR(5),OBJECT_ID)
           --+@CrLf+SPACE(@indent+2)+''
      FROM @hierarchy 
      WHERE parent_id= SUBSTRING(@XMLasString,@where+8, @Notnumber-1) 
      AND ValueType IN ('array', 'object')
    IF @Objects='' --if it is a lef, we can do a more compact rendering
         SELECT @NewXML='<'+COALESCE(@name,'item')+@entities+' />'
    ELSE
        SELECT @NewXML='<'+COALESCE(@name,'item')+@entities+'>'
            +@Objects+@CrLf++SPACE(@indent)+'</'+COALESCE(@name,'item')+'>'
     /* basically, we just lookup the structure based on the ID that is appended to the @Object token. Simple eh? */
    --now we replace the token with the structure, maybe with more tokens in it.
    Select @XMLasString=STUFF (@XMLasString, @where+1, 8+@NotNumber-1, @NewXML)
    end
  return @XMLasString
  end

go

--This provides you the means of converting a JSON string into XML
DECLARE @MyHierarchy Hierarchy,@xml XML
INSERT INTO @myHierarchy 
select * from parseJSON('{"menu": {
  "id": "file",
  "value": "File",
  "popup": {
    "menuitem": [
      {"value": "New", "onclick": "CreateNewDoc()"},
      {"value": "Open", "onclick": "OpenDoc()"},
      {"value": "Close", "onclick": "CloseDoc()"}
    ]
  }
}}')
SELECT dbo.ToXML(@MyHierarchy)
SELECT @XML=dbo.ToXML(@MyHierarchy)
SELECT @XML




