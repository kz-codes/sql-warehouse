-- -- null  or multiple values of id
-- -- Expected nothing
-- SELECT
--     prd_id,
--     COUNT(*)
-- FROM bronze.crm_prd_info
-- GROUP BY prd_id
-- HAVING count(*) > 1 OR prd_id IS NULL;

-- -- string formatting is not right?
-- -- Expected nothing
-- SELECT prd_nm
-- from bronze.crm_prd_info
-- WHERE prd_nm != TRIM(prd_nm);

-- -- costs are negative or null
-- -- expected nothig
-- SELECT prd_cost
-- FROM bronze.crm_prd_info
-- WHERE prd_cost < 0 OR prd_cost is NULL;

-- -- invalid dates
-- -- expected nothing
-- SELECT *
-- FROM bronze.crm_prd_info
-- WHERE prd_end_dt < prd_start_dt;


-- null  or multiple values of id
-- Expected nothing
SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING count(*) > 1 OR prd_id IS NULL;

-- string formatting is not right?
-- Expected nothing
SELECT prd_nm
from silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- costs are negative or null
-- expected nothig
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost is NULL;

-- invalid dates
-- expected nothing
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


SELECT top 300
    *
from silver.crm_prd_info;