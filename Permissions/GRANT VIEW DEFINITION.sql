/**** 
Troubleshooting Metadata Visibility,  To Let Users View Metadata
****/

-- on server level
use master
go
GRANT VIEW ANY DEFINITION TO public;


-- on database level

use riskworld
go
GRANT VIEW DEFINITION ON SCHEMA :: sys to public

GRANT VIEW DEFINITION TO public;