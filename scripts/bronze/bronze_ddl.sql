/*
=================================================================================
Script Name: Initialize Bronze Layer Tables
==================================================================================
Description:
    This script defines the Data Definition Language (DDL) for the 'Bronze' 
    schema. It sets up the raw staging tables for data ingested from 
    CRM and ERP source systems.

Logic:
    - Checks for the existence of each table using OBJECT_ID.
    - Drops existing tables to ensure a clean schema(Drop & Recreate pattern).
    - Creates tables with data types optimized for raw ingestion.

Source Systems:
    - CRM: Customer Info, Product Info, and Sales Details.
    - ERP:Location(a101), Demographics(az12), and Product Categories(g1v2).

Note:
    No constraints(Primary Keys/Foreign Keys) are applied at this stage to 
    allow for the ingestion of raw, non-validated data for later processing 
    in the Silver layer.
==============================================================================
CAUTION:
    Running this script will TRUNCATE and DROP all existing data in the 
    Bronze layer tables.
==============================================================================
*/

IF OBJECT_ID('bronze.crm_cust_info','u') is NOT NULL DROP table  bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info
(
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_material_status NVARCHAR(50),
    cst_gender NVARCHAR(50),
    cst_create_date DATE
)

GO
IF OBJECT_ID('bronze.crm_prd_info','u') is NOT NULL DROP table  bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info
(
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
)

GO
IF OBJECT_ID('bronze.crm_sales_details','u') is NOT NULL DROP table  bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details
(
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);
GO
IF OBJECT_ID('bronze.erp_loc_a101','u') is NOT NULL DROP table  bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101
(
    cid NVARCHAR(50),
    cntry NVARCHAR(50)
);

GO
IF OBJECT_ID('bronze.erp_cust_az12','u') is NOT NULL DROP table  bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12
(
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_px_cat_g1v2','u') is NOT NULL DROP table  bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2
(
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
);