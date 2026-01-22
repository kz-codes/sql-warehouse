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
