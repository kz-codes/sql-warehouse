/*
==========================================================================================
Script Name: Initialize Gold Layer Views (Star Schema)
=====================================================================================
Description: 
    This script creates the final consumption layer for the Data Warehouse. 
    It defines 'Business Entities' by joining multiple Silver tables into 
    Dimensions and a Fact table. Star Schema

Views Created:
    1. gold.dim_customers: 
       - Integrates CRM profile data with ERP demographics and locations.
       - Generates a surrogate key (customer_key).
       - Implements COALESCE logic to fill gender gaps between systems.
    
    2. gold.dim_products:
       - Merges CRM product data with ERP category hierarchies.
       - Filters for 'Current' products (where prd_end_dt IS NULL).
       - Flattens the hierarchy (Category to Sub-category) for easy reporting.

    3. gold.fact_sales:
       - The central transactional table containing business metrics (Sales, Qty).
       - Replaces natural keys (IDs) with Surrogate keys from Dimensions
         to ensure referential integrity and performance.
*/


CREATE VIEW gold.dim_customers
AS
    (SELECT
        ROW_NUMBER() over(order by cci.cst_create_date) as customer_key,
        cci.cst_id as customer_id,
        cci.cst_key as customer_number,
        cci.cst_firstname as first_name,
        cci.cst_lastname as last_name,
        cci.cst_material_status AS material_status,
        cci.cst_create_date as create_date,
        eca.bdate as birth_date,
        ela.cntry as country,
        CASE 
        WHEN cci.cst_gender != 'n/a' THEN cci.cst_gender
        ELSE COALESCE(eca.gen, 'n/a') 
    END as gender
    FROM silver.crm_cust_info cci
        LEFT JOIN silver.erp_cust_az12 eca ON cci.cst_key = eca.cid
        LEFT JOIN silver.erp_loc_a101 ela ON cci.cst_key = ela.cid
)
GO

CREATE VIEW gold.dim_products
AS
    (SELECT
        ROW_NUMBER() over(order by cpi.prd_start_dt, cpi.prd_key) as product_key,
        cpi.prd_id as product_id,
        cpi.prd_key as product_number,
        cpi.prd_nm as product_name,
        cpi.prd_line as product_line,
        cpi.cat_id as category_id,
        epc.cat as category,
        epc.subcat as sub_category,
        epc.maintenance as maintenance,
        cpi.prd_cost as cost,
        cpi.prd_start_dt as start_date
    FROM silver.crm_prd_info cpi
        LEFT JOIN silver.erp_px_cat_g1v2 epc ON epc.id = cpi.cat_id
    WHERE cpi.prd_end_dt IS NULL 
)
GO
CREATE VIEW gold.fact_sales
AS
    (SELECT
        sd.sls_ord_num as order_number,
        -- sls_prd_key,
        pr.product_key,
        -- sls_cust_id,
        cust.customer_key,
        sd.sls_order_dt as order_date,
        sd.sls_ship_dt as shipping_date,
        sd.sls_due_dt as due_date,
        sd.sls_sales as sales,
        sd.sls_quantity as quantity,
        sd.sls_price as price
    from silver.crm_sales_details sd
        LEFT JOIN gold.dim_products pr ON pr.product_number = sd.sls_prd_key
        LEFT JOIN gold.dim_customers cust on cust.customer_id = sd.sls_cust_id )