INSERT into silver.erp_cust_az12
    (
    cid,
    bdate,
    gen
    )
SELECT
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
         ELSE cid
    END AS cid,
    CASE WHEN bdate > GETDATE() THEN NULL
         ELSE bdate
    END as bdate,

    CASE WHEN UPPER(TRIM(gen)) LIKE 'F%' THEN 'Female'
         WHEN UPPER(TRIM(gen)) LIKE 'M%' THEN 'Male'
         ELSE 'n/a'
    END as gen
from bronze.erp_cust_az12