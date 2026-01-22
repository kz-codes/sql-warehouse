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

IF NOT EXISTS (SELECT 1
FROM sys.schemas
WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze;')
END
GO

IF NOT EXISTS (SELECT 1
FROM sys.schemas
WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver;')
END
GO

IF NOT EXISTS (SELECT 1
FROM sys.schemas
WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold;')
END
GO