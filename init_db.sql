use master;
GO

IF EXISTS (SELECT 1
FROM sys.databases
WHERE name = 'warehouse')
BEGIN
    drop DATABASE warehouse;
END
GO

create DATABASE warehouse;
GO

use warehouse;
GO

CREATE SCHEMA bronze; 
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO