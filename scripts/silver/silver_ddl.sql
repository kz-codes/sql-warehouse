/*
=================================================================================
Script Name: Initialize Silver Layer Tables
==================================================================================
Description:
    This script defines the Data Definition Language (DDL) for the 'Silver' 
    schema. It sets up the cleansed and standardized tables from bronze layer.

Logic:
   - Metadata Tracking:Added 'dwh_create_date' using DATETIME2 to track when records were processed into the warehouse.
    - Data Type Refinement: Dates and numeric fields are more strictly defined to ensure consistency
    - DataLineage: Prepared for standardized naming conventions and cleansed values.

Table Groups:
    - CRM: crm_cust_info, crm_prd_info, crm_sales_details.
    - ERP: erp_loc_a101, erp_cust_az12, erp_px_cat_g1v2.

==============================================================================
CAUTION:
    Running this script will TRUNCATE and DROP all existing data in the 
    Silver layer tables.
==============================================================================
*/


IF OBJECT_ID('silver.crm_cust_info','u') is NOT NULL DROP table  silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info
(
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_material_status NVARCHAR(50),
    cst_gender NVARCHAR(50),
    cst_create_date DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
)

GO
IF OBJECT_ID('silver.crm_prd_info','u') is NOT NULL DROP table  silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info
(
    prd_id INT,
    prd_key NVARCHAR(50),
    cat_id NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
)

GO
IF OBJECT_ID('silver.crm_sales_details','u') is NOT NULL DROP table  silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details
(
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()

);
GO
IF OBJECT_ID('silver.erp_loc_a101','u') is NOT NULL DROP table  silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101
(
    cid NVARCHAR(50),
    cntry NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()

);

GO
IF OBJECT_ID('silver.erp_cust_az12','u') is NOT NULL DROP table  silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12
(
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_px_cat_g1v2','u') is NOT NULL DROP table  silver.erp_px_cat_g1v2;

CREATE TABLE silver.erp_px_cat_g1v2
(
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()

);