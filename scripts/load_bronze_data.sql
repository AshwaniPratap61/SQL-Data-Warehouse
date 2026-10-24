
CREATE OR ALTER PROCEDURE bronze.load_bronze AS   -- Creating Stored Procedure
BEGIN
DECLARE @start_time DATETIME2(3),
        @end_time DATETIME2(3);

    SET @start_time = SYSDATETIME();
    BEGIN TRY
        PRINT '============================================='
        PRINT 'Loading Bronze Layer..'
        PRINT '============================================='

    
        PRINT '----------------------------------------------'
        PRINT 'Loading Source crm..'
        PRINT '----------------------------------------------'  
        PRINT '>>Truncate and Inserting Tabel: bronze.crm_cust_info' 
        -- Inserting data into table bronze.crm_cust_info
        TRUNCATE TABLE bronze.crm_cust_info
        BULK INSERT bronze.crm_cust_info
        FROM "C:\Users\ashwa\OneDrive\Desktop\sql-data-warehouse-project\01_datasets\source_crm\cust_info.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );


        PRINT '>>Truncate and Inserting Tabel: bronze.crm_prd_info'
        -- Inserting data into table bronze.crm_prd_info
        TRUNCATE TABLE bronze.crm_prd_info
        BULK INSERT bronze.crm_prd_info
        FROM "C:\Users\ashwa\OneDrive\Desktop\sql-data-warehouse-project\01_datasets\source_crm\prd_info.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );


        PRINT '>>Truncate and Inserting Tabel: bronze.crm_sales_details'
        -- Inserting data into tablebronze.crm_sales_details
        TRUNCATE TABLE bronze.crm_sales_details
        BULK INSERT bronze.crm_sales_details
        FROM "C:\Users\ashwa\OneDrive\Desktop\sql-data-warehouse-project\01_datasets\source_crm\sales_details.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );



        PRINT '----------------------------------------------'
        PRINT 'Loading Source erp..'
        PRINT '______________________________________________'
        PRINT '>>Truncate and Inserting Tabel: bronze.erp_cust_az12'
        -- Inserting data into table bronze.erp_cust_az12
        TRUNCATE TABLE bronze.erp_cust_az12
        BULK INSERT bronze.erp_cust_az12
        FROM "C:\Users\ashwa\OneDrive\Desktop\sql-data-warehouse-project\01_datasets\source_erp\CUST_AZ12.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );


        PRINT '>>Truncate and Inserting Tabel: bronze.erp_loc_a101'
        -- Inserting data into table bronze.erp_loc_a101
        TRUNCATE TABLE bronze.erp_loc_a101
        BULK INSERT bronze.erp_loc_a101
        FROM "C:\Users\ashwa\OneDrive\Desktop\sql-data-warehouse-project\01_datasets\source_erp\LOC_A101.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );


        PRINT '>>Truncate and Inserting Tabel: bronze.erp_px_cat_g1v2'
        -- Inserting data into table bronze.erp_px_cat_g1v2
        TRUNCATE TABLE bronze.erp_px_cat_g1v2
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM "C:\Users\ashwa\OneDrive\Desktop\sql-data-warehouse-project\01_datasets\source_erp\PX_CAT_G1V2.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
    END TRY
    BEGIN CATCH
        PRINT '================================================'
        PRINT 'Error Message ' + Error_MESSAGE();
        PRINT '================================================'
    END CATCH
    SET @end_time = SYSDATETIME();
    PRINT 'Total Execution Time: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS VARCHAR(20))+ ' ms';
END

-- Execute Stored Procedure
EXEC bronze.load_bronze