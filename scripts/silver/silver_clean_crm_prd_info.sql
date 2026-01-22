INSERT into silver.crm_prd_info
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
    REPLACE(SUBSTRING(prd_key, 1,5),'-','_') as cat_id,
    SUBSTRING(prd_key,7,LEN(prd_key)) as prd_key,
    prd_nm,
    ISNULL(prd_cost,0) as prd_cost,
    CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' then 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END as prd_line,
    prd_start_dt,
    DATEADD(day,-1,LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)) as prd_end_dt
from bronze.crm_prd_info 