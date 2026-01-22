# Insights

## Silver Layer

- `crm_prd_info`: `prd_key` can be multiple but `prd_id` is different
  - `prd_cost`, `prd_start_dt` and `prd_end_dt` are different.
  - **SCD type 2** => History
- First 5 characters of `crm_prd_info.prd_key` is the same as `erp_px_cat_g1v2`
- The rest of characters are `sls_product_key` in `crm_sales_details` table
- Invalid dates
  - Start > end in prd_info
  - Instead of end time let the end date be (start of next record - 1).
  - **Window** => LEAD
- `sales_details` has inconsistent sales, quantity and price data
  - as per sales = quantity \* data
  - also, many of the values are NULL or Negative
- RULES - pattern to be noted
  - if price is negative, convert to positive
  - if sales is invalid, derive it from quantity and price
  - if price is invalid, derive it from sales and price
- `erp_cust_az12` has inconsistent `cid` as some have NAS in front
- => remove as it should match with `crm _cust_info`
- `erp_loc_a101` the cid has a '-' inside it replace it with ''.
- `cntry` column has values that end with `\r` which the TRIM() method doesn't remove
