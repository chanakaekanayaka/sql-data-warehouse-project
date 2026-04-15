/* ==============================================================================
   Data Profiling: Gender Fallback Logic
   Description: Validates the logic used to determine a customer's gender.
                It compares the CRM gender side-by-side with the ERP gender 
                to ensure the fallback 'new_gen' column calculates correctly.
============================================================================== */
SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr  --CRM is the Master for gender Info
		 ELSE COALESCE(ca.gen, 'n/a')
	END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid
ORDER BY 1,2;


/* ==============================================================================
   Data Validation: Gold Customer Dimension
   Description: Selects all records from the final Gold customer dimension view 
                to verify the transformation and column outputs.
============================================================================== */
SELECT * FROM gold.dim_customers;


/* ==============================================================================
   Data Profiling: Active Products Filter
   Description: Checks the silver product table to ensure the logic for filtering 
                out historical products (where prd_end_dt IS NULL) is returning 
                only the current, active records.
============================================================================== */
SELECT 
	pn.prd_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pn.prd_end_dt
FROM silver.crm_prd_info pn
WHERE prd_end_dt IS NULL; --FILTER out all historical data


/* ==============================================================================
   Data Validation: Gold Product Dimension
   Description: Selects all records from the final Gold product dimension view 
                to verify the transformations, surrogate keys, and active status.
============================================================================== */
SELECT * FROM gold.dim_products;


/* ==============================================================================
   Data Validation: Gold Sales Fact Table
   Description: Selects all records from the final Gold sales fact view to 
                verify the transaction data and ensure surrogate keys mapped correctly.
============================================================================== */
SELECT * FROM gold.fact_sales;
