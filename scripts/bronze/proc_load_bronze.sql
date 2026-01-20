CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME
    ;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT 'Loading Bronze Layer...';
        PRINT '-----------------------------';
        PRINT 'Loading crm/cust_info....';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '....';
        SET @start_time = GETDATE()
        BULK INSERT bronze.crm_cust_info
        FROM '/var/opt/mssql/datasets/source_crm/cust_info.csv'
        WITH ( 
            firstrow = 2,
            FIELDTERMINATOR = ',',
            tablock
        );
        SET @end_time = GETDATE()

        PRINT 'DONE in ' + cast(DATEDIFF(second, @start_time, @end_time) as nVARCHAR)+'s';
        PRINT '';

        PRINT 'Loading crm/prd_info...';

        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '....';
        SET @start_time = GETDATE();
        BULK INSERT bronze.crm_prd_info
        FROM '/var/opt/mssql/datasets/source_crm/prd_info.csv'
        WITH ( 
            firstrow = 2,
            FIELDTERMINATOR = ',',
            -- dateformat = 'mdy',
            tablock
        );
        SET @end_time = GETDATE();

        PRINT 'DONE in ' + cast(DATEDIFF(second, @start_time, @end_time) as nVARCHAR)+'s';

        PRINT '';

        PRINT 'Loading crm/sales_details...';

        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '....';
        SET @start_time = GETDATE();
        BULK INSERT bronze.crm_sales_details
        FROM '/var/opt/mssql/datasets/source_crm/sales_details.csv'
        WITH ( 
            firstrow = 2,
            FIELDTERMINATOR = ',',
            tablock
        );
        SET @end_time = GETDATE();

        
        PRINT 'DONE in ' + cast(DATEDIFF(second, @start_time, @end_time) as nVARCHAR)+'s';

        PRINT '';
        PRINT 'Loading erp/cust_az12...';

        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '....';
        SET @start_time = GETDATE();
        BULK INSERT bronze.erp_cust_az12
        FROM '/var/opt/mssql/datasets/source_erp/cust_az12.csv'
        WITH ( 
            firstrow = 2,
            FIELDTERMINATOR = ',',
            tablock
        );
        SET @end_time = GETDATE();
        PRINT 'DONE in ' + cast(DATEDIFF(second, @start_time, @end_time) as nVARCHAR)+'s';
        PRINT '';
        PRINT 'Loading erp/loc_a101...';

        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '....';
        SET @start_time = GETDATE();
        BULK INSERT bronze.erp_loc_a101
        FROM '/var/opt/mssql/datasets/source_erp/loc_a101.csv'
        WITH ( 
            firstrow = 2,
            FIELDTERMINATOR = ',',
            tablock
        );
        SET @end_time = GETDATE();
        PRINT 'DONE in ' + cast(DATEDIFF(second, @start_time, @end_time) as nVARCHAR)+'s';
        PRINT '';

        PRINT 'Loading erp/px_cat_g1v2...';

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '....';
        SET @start_time = GETDATE();
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/var/opt/mssql/datasets/source_erp/PX_CAT_G1V2.csv'
        WITH ( 
            firstrow = 2,
            FIELDTERMINATOR = ',',
            tablock
        );
        
        SET @end_time = GETDATE();
        PRINT 'DONE in ' + cast(DATEDIFF(second, @start_time, @end_time) as nVARCHAR)+'s';
        PRINT '-----------------------------';
        PRINT 'Bronze Layer loaded in ' + CAST(DATEDIFF(second, @batch_start_time, GETDATE()) as NVARCHAR) + 's'
        PRINT '-----------------------------';
    END TRY
    BEGIN CATCH
        PRINT '======================';
        PRINT 'Error: BRONZE layer';
        PRINT 'error msg: ' + ERROR_NUMBER();
        PRINT 'error no: '  + CAST(error_number() as NVARCHAR)
        PRINT 'error state: '  + CAST(error_state() as NVARCHAR)
        PRINT '======================';
    END CATCH
END