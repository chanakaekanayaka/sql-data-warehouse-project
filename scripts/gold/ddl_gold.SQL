/* ==============================================================================
   View: gold.dim_customers
   Description: Creates the customer dimension table for the Gold layer.
   Integration: Combines core CRM customer data with ERP demographic and 
                location data to create a unified customer profile.
============================================================================== */
CREATE VIEW gold.dim_customers AS
SELECT 
	-- Generate a surrogate key for the dimension
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_material_status AS material_status,
	
	-- Business Logic: CRM is the primary source of truth for Gender. 
	-- If CRM is missing the data ('n/a'), fallback to the ERP system data.
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr  --CRM is the Master for gender Info
		 ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid


/* ==============================================================================
   View: gold.dim_products
   Description: Creates the product dimension table for the Gold layer.
   Integration: Combines CRM product info with ERP category hierarchies.
============================================================================== */
CREATE VIEW gold.dim_products AS 
SELECT
	-- Generate a surrogate key based on start date and product key
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
	ON pn.cat_id = pc.id
-- Business Logic: Only include the current, active products. 
-- Filtering out historical records where an end date exists.
WHERE prd_end_dt IS NULL --FILTER out all historical data


/* ==============================================================================
   View: gold.fact_sales
   Description: Creates the core sales fact table for the Gold layer.
   Integration: Maps transactional sales data to the surrogate keys of the 
                newly created product and customer dimensions.
============================================================================== */
CREATE VIEW gold.fact_sales AS 
SELECT 
	sd.sls_ord_num AS order_number,
	-- Replace business keys with standard surrogate keys from the dimensions
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quanity,
	sd.sls_price
FROM silver.crm_sales_details sd
-- Join to Gold dimensions to resolve the surrogate keys
LEFT JOIN gold.dim_products pr
	ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
	ON sd.sls_cust_id = cu.customer_id
