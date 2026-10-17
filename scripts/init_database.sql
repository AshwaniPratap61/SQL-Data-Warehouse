/*
    WARNING:
    This script permanently deletes the existing DataWarehouse database,
    including all tables, schemas, stored procedures, and stored data.

    Use this script only when you intentionally want to reset the database
    and start from scratch. All existing data will be lost.
*/

USE master;
GO

-- Check whether the DataWarehouse database already exists.
IF DB_ID('DataWarehouse') IS NOT NULL
BEGIN
    -- Restrict the database to a single connection and disconnect
    -- other active sessions, rolling back their uncommitted transactions.
    ALTER DATABASE DataWarehouse
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    -- Permanently delete the existing database and all its contents.
    DROP DATABASE DataWarehouse;
END;
GO

-- Create a fresh DataWarehouse database
CREATE DATABASE DataWarehouse;
GO

-- Switch the active database context to DataWarehouse.
USE DataWarehouse;
GO

-- Create the Bronze schema to store raw source data.
CREATE SCHEMA bronze;
GO

-- Create the Silver schema to store cleaned and transformed data.
CREATE SCHEMA silver;
GO

-- Create the Gold schema to store business-ready, analytical data.
CREATE SCHEMA gold;
GO