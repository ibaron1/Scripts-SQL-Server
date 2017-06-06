IF EXISTS (SELECT *  

002 FROM   dbo.sysobjects  

003 WHERE  id = Object_id(N'[dbo].[GatherVirtualFileStats]')  

004 AND Objectproperty(id, N'IsProcedure') = 1)  

005 DROP PROCEDURE [dbo].[GatherVirtualFileStats]  

006    

007 GO  

008    

009 ---------------------------------------------------------------------------------------  

010 --  GatherVirtualFileStats  

011    

012 --  by: Wesley D. Brown  

013 --  date: 02/08/2011  

014 --  mod:  00/00/0000  

015    

016 --  description:  

017 --  This stored procedure is used to sample sys.dm_io_virtual_file_stats to track  

018 --  performance at a database file level. This is useful for finding  

019 --  hotspots on SAN's or under performing IO systems.  

020    

021 --  parameters:  

022 --    @Duration  = '01:00:00' How long to run before exiting  

023 --   @IntervalInSeconds = 120 Number of seconds between samples  

024 --@DB            = -1 DB_ID to monitor, -1 for all  

025 --@DBFile        = -1 File_ID of file to monitor, -1 for all  

026 --  usage:  

027 --      DECLARE @RC         INT,  

028 --          @StartTime  DATETIME,  

029 --          @databaseID INT  

030    

031 --  SELECT @StartTime = Getdate(),  

032 --         @databaseID = Db_id()  

033    

034 --  EXEC @RC = Gathervirtualfilestats  

035 --    '00:45:30',  

036 --    30,  

037 --    10,  

038 --    -1  

039    

040 --  SELECT *  

041 --  FROM   dbo.VirtualFileStats  

042 --  WHERE  DBID = 10  

043 --  ORDER  BY RecordID  

044    

045 --  platforms:  

046 --  SQL Server 2005  

047 --  SQL Server 2008  

048 --  SQL Server 2008 R2  

049 --  tested:  

050 --  SQL Server 2005 SP2  

051 --  SQL Server 2008 R2  

052 ---------------------------------------------------------------------------------------  

053 --  *** change log      ***  

054 --  *** end change log  ***  

055 -------------------------------------------------------------------------------------  

056 CREATE PROC dbo.Gathervirtualfilestats @Duration    DATETIME = '01:00:00',  

057                                        @IntervalInSeconds INT = 120,  

058                                        @DB          INT = -1,  

059                                        @DBFile      INT = -1  

060 AS  

061   DECLARE @StopTime                 DATETIME,  

062           @LastRecordedDateTime     DATETIME,  

063           @CurrentDateTime          DATETIME,  

064           @ErrorNumber              INT,  

065           @NumberOfRows             INT,  

066           @ErrorMessageText         NVARCHAR(4000),  

067           @CurrentServerName        VARCHAR(255),  

068           @DifferenceInMilliSeconds BIGINT  

069    

070   SELECT @CurrentServerName = CAST(Serverproperty('servername') AS VARCHAR(255))  

071    

072   SET @DifferenceInMilliSeconds = Datediff(ms, CONVERT(DATETIME, '00:00:00', 8), @Duration)  

073    

074   SELECT @StopTime = Dateadd(ms, @DifferenceInMilliSeconds, Getdate())  

075    

076   WHILE Getdate() <= @StopTime  

077     BEGIN  

078         SELECT @LastRecordedDateTime = @CurrentDateTime  

079    

080         SELECT @CurrentDateTime = Getdate()  

081    

082         INSERT INTO dbo.VirtualFileStats  

083                     (ServerName,  

084                      DBID,  

085                      FileID,  

086                      Reads,  

087                      ReadsFromStart,  

088                      Writes,  

089                      WritesFromStart,  

090                      BytesRead,  

091                      BytesReadFromStart,  

092                      BytesWritten,  

093                      BytesWrittenFromStart,  

094                      IostallInMilliseconds,  

095                      IostallInMillisecondsFromStart,  

096                      IostallReadsInMilliseconds,  

097                      IostallReadsInMillisecondsFromStart,  

098                      IostallWritesInMilliseconds,  

099                      IostallWritesInMillisecondsFromStart,  

100                      RecordedDateTime,  

101                      IntervalinMilliseconds,  

102                      FirstMeasureFromStart)  

103         SELECT @CurrentServerName,  

104                vfs.database_id -- Database ID  

105                ,  

106                vfs.[file_id] -- File ID  

107                ,  

108                vfs.num_of_reads - dbaf.ReadsFromStart                            AS Reads,  

109                vfs.num_of_reads                                                  AS ReadsFromStart,  

110                vfs.num_of_writes - dbaf.WritesFromStart                          AS Writes,  

111                vfs.num_of_writes                                                 AS WritesFromStart,  

112                vfs.num_of_bytes_read - dbaf.BytesReadFromStart                   AS BytesRead,  

113                vfs.num_of_bytes_read                                             AS BytesReadFromStart,  

114                vfs.num_of_bytes_written - dbaf.BytesWrittenFromStart             AS BytesWritten,  

115                vfs.num_of_bytes_written                                          AS BytesWrittenFromStart,  

116                vfs.io_stall - dbaf.IostallInMillisecondsFromStart                AS IostallInMilliseconds,  

117                vfs.io_stall                                                      AS IostallInMillisecondsFromStart,  

118                vfs.io_stall_read_ms - dbaf.IostallReadsInMillisecondsFromStart   AS IostallReadsInMilliseconds,  

119                vfs.io_stall_read_ms                                              AS IostallReadsInMillisecondsFromStart,  

120                vfs.io_stall_write_ms - dbaf.IostallWritesInMillisecondsFromStart AS IostallWritesInMilliseconds,  

121                vfs.io_stall_write_ms                                             AS IostallWritesInMillisecondsFromStart,  

122                @CurrentDateTime,  

123                CASE  

124                  WHEN @LastRecordedDateTime IS NULL THEN NULL  

125                  ELSE Datediff(ms, dbaf.RecordedDateTime, @CurrentDateTime)  

126                END                                                               AS IntervalInMilliseconds,  

127                CASE  

128                  WHEN @LastRecordedDateTime IS NULL THEN 1  

129                  ELSE 0  

130                END                                                               AS FirstMeasureFromStart  

131         FROM   sys.Dm_io_virtual_file_stats(@DB, @DBFile) vfs  

132                LEFT OUTER JOIN VirtualFileStats dbaf  

133                  ON vfs.database_id = dbaf.dbid  

134                     AND vfs.[file_id] = dbaf.fileid  

135         WHERE  ( @LastRecordedDateTime IS NULL  

136                   OR dbaf.RecordedDateTime = @LastRecordedDateTime )  

137    

138         SELECT @ErrorNumber = @@ERROR,  

139                @NumberOfRows = @@ROWCOUNT  

140    

141         IF @ErrorNumber != 0  

142           BEGIN  

143               SET @ErrorMessageText = 'Error ' + CONVERT(VARCHAR(10), @ErrorNumber) + ' failed to insert file stats data!'  

144    

145               RAISERROR (@ErrorMessageText,  

146                          16,  

147                          1) WITH LOG  

148    

149               RETURN @ErrorNumber  

150           END 

151    

152         WAITFOR DELAY @IntervalInSeconds  

153     END 

go

SELECT TOP 10 Db_name(dbid)                                          AS 'databasename',  

02               File_name(fileid)                                      AS 'filename',  

03               Reads / ( IntervalInMilliSeconds / 1000 )              AS 'readspersecond',  

04               Writes / ( IntervalInMilliSeconds / 1000 )             AS 'writespersecond',  

05               ( Reads + Writes ) / ( IntervalInMilliSeconds / 1000 ) AS 'iopersecond',  

06               CASE 

07                 WHEN ( Reads / ( IntervalInMilliSeconds / 1000 ) ) > 0  

08                      AND IostallReadsInMilliseconds > 0 THEN IostallReadsInMilliseconds / Reads  

09                 ELSE 0  

10               END                                                    AS 'iolatencyreads',  

11               CASE 

12                 WHEN ( Reads / ( IntervalInMilliSeconds / 1000 ) ) > 0  

13                      AND IostallWritesInMilliseconds > 0 THEN IostallWritesInMilliseconds / Writes  

14                 ELSE 0  

15               END                                                    AS 'iolatencywrites',  

16               CASE 

17                 WHEN ( ( Reads + Writes ) / ( IntervalInMilliSeconds / 1000 ) > 0  

18                        AND IostallInMilliseconds > 0 ) THEN IostallInMilliseconds / ( Reads + Writes )  

19                 ELSE 0  

20               END                                                    AS 'iolatency',  

21               RecordedDateTime  

22 FROM   management.dbo.VirtualFileStats  

23 WHERE  DBID = 10  

24        AND FirstMeasureFromStart = 0  

25 ORDER  BY RecordID 

go
