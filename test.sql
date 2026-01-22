-- SELECT cst_id, COUNT(*)
-- FROM bronze.crm_cust_info
-- GROUP BY cst_id
-- having COUNT(*) > 1;

-- with
--     cte_cst
--     as
--     (
--         SELECT cst_id, COUNT(*) as cnt
--         FROM bronze.crm_cust_info
--         GROUP BY cst_id
--         having COUNT(*) > 1 OR cst_id IS null

--     )
-- SELECT *
-- FROM bronze.crm_cust_info
-- WHERE cst_id IN (
--     SELECT cst_id
-- from cte_cst
-- );

SELECT
    *
FROM(
SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) rank
    FROM bronze.crm_cust_info

)t
WHERE rank = 1;
