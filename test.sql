-- cid valid?
SELECT
    cid,
    cntry
from bronze.erp_loc_a101;

-- DAta consistency
SELECT distinct
    cntry
from bronze.erp_loc_a101;


-- cid valid?
SELECT
    cid,
    cntry
from silver.erp_loc_a101;

-- DAta consistency
SELECT distinct
    cntry
from silver.erp_loc_a101;

