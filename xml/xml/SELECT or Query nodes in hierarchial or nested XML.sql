DECLARE @xml XML
 
SET @xml=N'<Root>
    <orderHRD ID="101">
        <custID>501</custID>
        <orderDTL ID="201">
            <prodID>1</prodID>
            <qty>5</qty>
            <cost>25.12</cost>
        </orderDTL>
        <orderDTL ID="202">
            <prodID>2</prodID>
            <qty>3</qty>
            <cost>30.00</cost>
        </orderDTL>
    </orderHRD>
    <orderHRD ID="102">
        <custID>502</custID>
        <orderDTL ID="203">
            <prodID>11</prodID>
            <qty>12</qty>
            <cost>140.78</cost>
        </orderDTL>
    </orderHRD>
    <orderHRD ID="103">
        <custID>503</custID>
        <orderDTL ID="204">
            <prodID>6</prodID>
            <qty>8</qty>
            <cost>60.35</cost>
        </orderDTL>
        <orderDTL ID="205">
            <prodID>9</prodID>
            <qty>2</qty>
            <cost>10.50</cost>
        </orderDTL>
        <orderDTL ID="206">
            <prodID>10</prodID>
            <qty>6</qty>
            <cost>120.89</cost>
        </orderDTL>
    </orderHRD>
</Root>';
 
-- Method #1: Query nested XML nodes by traversing backward and forward.
-- Query Cost: 81%
select
    Tab.Col.value('../@ID', 'int') as OrderHDR_ID,
    Tab.Col.value('../custID[1]', 'int') as Cust_ID,
    Tab.Col.value('@ID', 'int') as OrderDTL_ID,
    Tab.Col.value('prodID[1]', 'int') as Prod_ID,
    Tab.Col.value('qty[1]', 'int') as QTY,
    Tab.Col.value('cost[1]', 'float') as Cost,
    Tab.Col.value('count(../orderDTL)', 'int') as Cust_Ord_Count
from @xml.nodes('/Root/orderHRD/orderDTL') Tab(Col)
 
-- Method #2: Query nested XML nodes by using CROSS APPLY on appropriate node.
-- Query Cost: 19%
select
    Tab.Col.value('@ID', 'int') as OrderHDR_ID,
    Tab.Col.value('custID[1]', 'int') as Cust_ID,
    Tab1.Col1.value('@ID', 'int') as OrderDTL_ID,
    Tab1.Col1.value('prodID[1]', 'int') as Prod_ID,
    Tab1.Col1.value('qty[1]', 'int') as QTY,
    Tab1.Col1.value('cost[1]', 'float') as Cost,
    Tab.Col.value('count(./orderDTL)', 'int') as Cust_Ord_Count
from @xml.nodes('/Root/orderHRD') as Tab(Col)
cross apply Tab.Col.nodes('orderDTL') as Tab1(Col1)
GO

Output:-
OrderHDR_ID Cust_ID OrderDTL_ID Prod_ID QTY Cost
101	    501	    201		1	5   25.12
101	    501	    202		2	3   30
102	    502	    203		11	12  140.78
103	    503	    204		6	8   60.35
103	    503	    205		9	2   10.5
103	    503	    206		10	6   120.89
Method #2 is much more effecient than first one. As 1st method uses forward-backward traversal approach. The 2nd method uses APPLY operator which gets Nodes information from a specific parent.