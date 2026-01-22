INSERT into silver.erp_loc_a101
    (cid,cntry)
SELECT
    trim(REPLACE(cid,'-','')) as cid,
    CASE 
        WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13), '')) IN ('USA', 'US', 'UNITED STATES') THEN 'USA'
        WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13), '')) IN('UK', 'UNITED KINGDOM') THEN 'United Kingdom'
        WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13), '')) = 'DE' THEN 'Germany'
        WHEN REPLACE(TRIM(cntry), CHAR(13), '') = '' THEN 'n/a'
        ELSE REPLACE(TRIM(cntry), CHAR(13), '')
END AS cntry
from bronze.erp_loc_a101;