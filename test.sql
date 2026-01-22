-- Valed cid?
SELECT
    cid,
    bdate,
    gen
from bronze.erp_cust_az12
WHERE cid NOT in (select distinct cst_key
from silver.crm_cust_info);


-- out of range dates
SELECT distinct bdate
from bronze.erp_cust_az12
WHERE bdate < '1916-01-01' OR bdate > GETDATE();


--- data standardization and consistency
SELECT distinct
    gen
FROM bronze.erp_cust_az12;

-- Valed cid?
SELECT
    cid,
    bdate,
    gen
from silver.erp_cust_az12
WHERE cid NOT in (select distinct cst_key
from silver.crm_cust_info);


-- out of range dates
SELECT distinct bdate
from silver.erp_cust_az12
WHERE bdate < '1916-01-01' OR bdate > GETDATE();


--- data standardization and consistency
SELECT distinct
    gen
FROM silver.erp_cust_az12;


SELECT top 300
    *
from silver.erp_cust_az12;