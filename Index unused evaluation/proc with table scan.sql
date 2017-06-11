/****
  on GLSRD ; uses index  in GPS, GPS4; table scan on pt_trmast in GPS3

use GPS3
go
set showplan on
go
set fmtonly on
go
imssp_amortization_ytm 'PEING','','12/31/2007','1/29/2008','I',@sorting= 0,@secids='',@smtype='',@LongShort='B',@DefaultStatus='B',@debug=0


/*
showplan for spid 674

 

QUERY PLAN FOR STATEMENT 21 (at line 226).

 

 

    STEP 1

        The type of query is INSERT.

        The update mode is direct.

 

        FROM TABLE

            pt_trmast

            tm

        Nested iteration.

        Table Scan.

        Forward scan.

        Positioning at start of table.

        Using I/O Size 16 Kbytes for data pages.

        With LRU Buffer Replacement Strategy for data pages.

 

        FROM TABLE

            pt_lot_move_shares

            lms

        Nested iteration.

        Using Clustered Index.

        Index : x1_lot_move_shares

        Forward scan.

        Positioning by key.

        Keys are:

            acid  ASC

            tmid  ASC

        Using I/O Size 2 Kbytes for index leaf pages.

        With LRU Buffer Replacement Strategy for index leaf pages.

        Using I/O Size 2 Kbytes for data pages.

        With LRU Buffer Replacement Strategy for data pages.

 

        FROM TABLE

            #acids

            a

        Nested iteration.

        Table Scan.

        Forward scan.

        Positioning at start of table.

        Using I/O Size 16 Kbytes for data pages.

        With LRU Buffer Replacement Strategy for data pages.

 

        FROM TABLE

            pt_lot_move_costs

            lmc

        Nested iteration.

        Using Clustered Index.

        Index : x1_lot_move_costs

        Forward scan.

        Positioning by key.

        Keys are:

            acid  ASC

            tmid  ASC

            lotid  ASC

        Using I/O Size 2 Kbytes for index leaf pages.

        With LRU Buffer Replacement Strategy for index leaf pages.

        Using I/O Size 2 Kbytes for data pages.

        With LRU Buffer Replacement Strategy for data pages.

 

        FROM TABLE

            GPS..pr_secmast

        Nested iteration.

        Using Clustered Index.

        Index : xc_secmast

        Forward scan.

        Positioning by key.

        Keys are:

            smsecid  ASC

 

        Run subquery 1 (at nesting level 1).

        Using I/O Size 2 Kbytes for data pages.

        With LRU Buffer Replacement Strategy for data pages.

        TO TABLE

            #results

        Using I/O Size 2 Kbytes for data pages.

    STEP 1

*/