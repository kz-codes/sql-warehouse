-- -- check in valid dates
-- SELECT
--     nullif(sls_order_dt, 0) sls_order_dt
-- FROM bronze.crm_sales_details
-- WHERE sls_order_dt <=0
--     or len(sls_order_dt) != 8
--     or sls_order_dt > 20500101
--     or sls_order_dt < 19000101

-- SELECT *
-- FROM bronze.crm_sales_details
-- WHERE sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;


-- -- Sales = quantity * price
-- SELECT distinct
--     sls_sales,
--     sls_quantity,
--     sls_price
-- from bronze.crm_sales_details
-- WHERE sls_sales is NULL or sls_quantity is NULL or sls_price is null
--     or sls_sales <= 0 or sls_quantity  <= 0 OR sls_price <= 0
--     or sls_sales != sls_quantity * sls_price;


-- check in valid dates

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;


-- Sales = quantity * price
SELECT distinct
    sls_sales,
    sls_quantity,
    sls_price
from silver.crm_sales_details
WHERE sls_sales is NULL or sls_quantity is NULL or sls_price is null
    or sls_sales <= 0 or sls_quantity  <= 0 OR sls_price <= 0
    or sls_sales != sls_quantity * sls_price;

SELECT top 300
    *
from silver.crm_sales_details;