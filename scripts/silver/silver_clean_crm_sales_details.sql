INSERT into silver.crm_sales_details
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
    CASE WHEN sls_order_dt = 0 OR len(sls_order_dt) != 8 THEN NULL
    ELSE CAST(CAST(sls_order_dt AS varchar) AS date)
    END as sls_order_dt,
    CASE WHEN sls_ship_dt = 0 OR len(sls_ship_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS varchar) AS date)
    END as sls_ship_dt,
    CASE WHEN sls_due_dt = 0 OR len(sls_due_dt) != 8 THEN NULL
         ELSE CAST(CAST(sls_due_dt AS varchar) AS date)
    END as sls_due_dt,
    CASE 
    WHEN sls_sales IS NULL OR sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price) 
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END as sls_sales,
    sls_quantity,
    CASE WHEN sls_price is NULL OR sls_price <= 0
        THEN sls_sales/nullif(sls_quantity, 0)
        ELSE sls_price
    END as sls_price
from bronze.crm_sales_details