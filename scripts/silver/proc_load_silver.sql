/*
================================================================
Stored Procedure: silver.load_silver
=================================================================

Description:
    This procedure orchestrates the Transformation and Loading (TL) process 
    from the 'Bronze' layer to the 'Silver' layer.

Data Transformation & Quality Rules:
    - Customer Data: 
        * Deduplication: Performs "Last Record Wins" using ROW_NUMBER() based on cst_id.
        * Standardization: Maps 'S'/'M' to 'Single'/'Married' and 'F'/'M' to full gender names.
        * Cleaning: Trims whitespace from name fields.
    - Product Data:
        * Key Parsing: Splits prd_key into cat_id and a cleaned prd_key.
        * Price Integrity: Replaces NULL costs with 0.
        * SCD Logic: Calculates prd_end_dt using LEAD() to create non-overlapping timelines.
    - Sales Data:
        * Date Casting: Converts integer dates (YYYYMMDD) to DATE format; handles invalid dates.
        * Financial Logic: Derives Sales/Price if values are NULL or mathematically inconsistent.
    - ERP Data:
        * Integration Prep: Trims prefixes ('NAS-') and removes dashes from IDs for joining.
        * Country Normalization: Consolidates various country spellings (e.g., 'USA', 'US') into standards.

Error Handling:
    - Implemented a TRY CATCH Block to capture load failures
    - Error Info: number, messsage and state
==============================================================================
Parameters: None
============================================================================
Execution:
    EXEC silver.load_silver;
================================================================================
*/

CREATE
OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    BEGIN TRY 
        DECLARE @start_time DATETIME, @end_time DATETIME 
        PRINT 'Truncating: silver.crm_cust_info' 
        TRUNCATE TABLE silver.crm_cust_info 
        PRINT 'Inserting data into silver.crm_cust_info'
        SET @start_time = GETDATE()
        INSERT INTO silver.crm_cust_info
        (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_material_status,
        cst_gender,
        cst_create_date
        )
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
        CASE
                WHEN LOWER(TRIM(cst_material_status)) = 's' THEN 'Single'
                WHEN LOWER(TRIM(cst_material_status)) = 'm' THEN 'Married'
                ELSE 'n/a'
            END AS cst_material_status,
        CASE
                WHEN LOWER(TRIM(cst_gender)) = 'f' THEN 'Female'
                WHEN lower(TRIM(cst_gender)) = 'm' THEN 'Male'
                ELSE 'n/a'
            END AS cst_gender,
        cst_create_date
    FROM
        (
        SELECT
            *,
            ROW_NUMBER() OVER(
                PARTITION BY cst_id
                ORDER BY
                    cst_create_date DESC
            ) rank
        FROM
            bronze.crm_cust_info
    ) t
    WHERE rank = 1
    SET @end_time = GETDATE() 
    PRINT 'Inserted in ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's' 
    
    PRINT 'Truncating: silver.crm_prd_info' 
    TRUNCATE TABLE silver.crm_prd_info 
    PRINT 'Inserting data into silver.crm_prd_info'
    SET @start_time = GETDATE()
    INSERT INTO
    silver.crm_prd_info
        (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
        )
    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
        SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
        prd_nm,
        ISNULL(prd_cost, 0) AS prd_cost,
        CASE
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,
        prd_start_dt,
        DATEADD(
        day,
        -1,
        LEAD(prd_start_dt) OVER(
            PARTITION BY prd_key
            ORDER BY
                prd_start_dt
        )
    ) AS prd_end_dt
    FROM
        bronze.crm_prd_info
    SET @end_time = GETDATE() 
    PRINT 'Inserted in ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's' 
    
    PRINT 'Truncating: silver.crm_sales_details' 
    TRUNCATE TABLE silver.crm_sales_details 
    PRINT 'Inserting data into silver.crm_sales_details'
    SET @start_time = GETDATE()
    INSERT INTO
    silver.crm_sales_details
        (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_Sales,
        sls_quantity,
        sls_price
        )
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE
        WHEN sls_order_dt = 0
            OR len(sls_order_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_order_dt AS varchar) AS date)
    END AS sls_order_dt,
        CASE
        WHEN sls_ship_dt = 0
            OR len(sls_ship_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS varchar) AS date)
    END AS sls_ship_dt,
        CASE
        WHEN sls_due_dt = 0
            OR len(sls_due_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_due_dt AS varchar) AS date)
    END AS sls_due_dt,
        CASE
        WHEN sls_sales IS NULL
            OR sls_sales <= 0
            OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
        sls_quantity,
        CASE
        WHEN sls_price IS NULL
            OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price
    FROM
        bronze.crm_sales_details
    SET @end_time = GETDATE() 
    PRINT 'Inserted in ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's' 
    
    PRINT 'Truncating: silver.erp_cust_az12' 
    TRUNCATE TABLE silver.erp_cust_az12 
    PRINT 'Inserting data into silver.erp_cust_az12'
    SET @start_time = GETDATE()
    INSERT INTO
    silver.erp_cust_az12
        (cid, bdate, gen)
    SELECT
        CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
        ELSE cid
    END AS cid,
        CASE
        WHEN bdate > GETDATE() THEN NULL
        ELSE bdate
    END AS bdate,
        CASE
        WHEN UPPER(TRIM(gen)) LIKE 'F%' THEN 'Female'
        WHEN UPPER(TRIM(gen)) LIKE 'M%' THEN 'Male'
        ELSE 'n/a'
    END AS gen
    FROM
        bronze.erp_cust_az12
    SET @end_time = GETDATE() 
    PRINT 'Inserted in ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's' 
    
    PRINT 'Truncating: silver.erp_loc_a101' 
    TRUNCATE TABLE silver.erp_loc_a101 
    PRINT 'Inserting data into silver.erp_loc_a101'
    SET @start_time = GETDATE()
    
    INSERT INTO
    silver.erp_loc_a101
        (cid, cntry)
    SELECT
        trim(REPLACE(cid, '-', '')) AS cid,
        CASE
        WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13), '')) IN ('USA', 'US', 'UNITED STATES') THEN 'USA'
        WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13), '')) IN('UK', 'UNITED KINGDOM') THEN 'United Kingdom'
        WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13), '')) = 'DE' THEN 'Germany'
        WHEN REPLACE(TRIM(cntry), CHAR(13), '') = '' THEN 'n/a'
        ELSE REPLACE(TRIM(cntry), CHAR(13), '')
    END AS cntry
    FROM
        bronze.erp_loc_a101;

    SET @end_time = GETDATE()
    PRINT 'Inserted in ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's' PRINT 'Truncating: silver.erp_px_cat_g1v2' 
    TRUNCATE TABLE silver.erp_px_cat_g1v2 
    PRINT 'Inserting data into silver.erp_px_cat_g1v2'
    SET @start_time = GETDATE()
    INSERT INTO
    silver.erp_px_cat_g1v2
        (id, cat, subcat, maintenance)
    SELECT
        id,
        cat,
        subcat,
        maintenance
    FROM
        bronze.erp_px_cat_g1v2;

    SET @end_time = GETDATE() 
    PRINT 'Inserted in ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's'
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