/*
=======================================================================================
Script Name: Database and Schema Setup
=======================================================================================
Description: 
    This script initializes the primary Data Warehouse environment. It ensures 
    a clean state by dropping any existing database named 'warehouse' and 
    recreating it from scratch. It also defines the logical layers (schemas) 
    required for the Medallion Architecture.

Architecture Layers:
    - Bronze: Raw data ingestion (Staging).
    - Silver: Cleansed, filtered, and standardized data.
    - Gold:   Business-ready aggregated data and Star Schemas (Reporting).

Logic:
    1. Switches context to 'master' to perform administrative tasks.
    2. Drops the 'warehouse' database if it exists (Clean Rebuild).
    3. Creates a fresh 'warehouse' database.
    4. Navigates into the new database.
    5. Dynamically creates the Bronze, Silver, and Gold schemas if they 
       do not already exist.
===================================================================================
CAUTION: 
    Executing this script will PERMANENTLY DELETE the entire 'warehouse' 
    database, including all tables, views, and data across all schemas.
=====================================================================================
*/
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