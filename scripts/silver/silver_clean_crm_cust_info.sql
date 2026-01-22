INSERT into silver.crm_cust_info
    (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_material_status,
    cst_gender,
    cst_create_date
    )
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname) as cst_firstname,
    TRIM(cst_lastname) as cst_lastname,
    CASE 
        WHEN LOWER(TRIM(cst_material_status)) = 's' then 'Single'
        when LOWER(TRIM(cst_material_status)) = 'm' then 'Married'
        else 'n/a'
    END 
    cst_material_status,
    CASE 
        WHEN LOWER(TRIM(cst_gender)) = 'f' then 'Female'
        when lower(TRIM(cst_gender)) = 'm' then 'Male'
        else 'n/a'
    END cst_gender,
    cst_create_date
FROM
    (
SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) rank
    FROM bronze.crm_cust_info 

)
t
WHERE rank =1