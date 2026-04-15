--For bronze.crm_cust_info

-- Check for nulls or duplicates in primary key
--Expection: No Result

SELECT
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

--check for unwanted Spaces
--Expectation : No Result
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

--Expection : No 
--check nulls
SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_key !=TRIM(cst_key)


--Data Standardization & Consistency
SELECT DISTINCT cst_gndr 
FROM silver.crm_cust_info

SELECT * FROM silver.crm_cust_info

--For bronze.crm_prd_info

--Check for nulls or duplicates in primary key
--Expection: No Result

SELECT 
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

--check for unwanted spaces
--exception: No result
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm) --safe

--Expection : No 
--check nulls or negative numbers
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm !=TRIM(prd_nm) --safe

SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

--Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

--Check for Invalid Date Orders
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt


SELECT *
FROM silver.crm_prd_info


--For bronze.crm_sales_details

--check for Invalid Dates
SELECT
NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <=0
OR LEN(sls_order_dt)!=8
OR sls_order_dt > 20500101
OR sls_order_dt <19000101


--check for Invalid date orders
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt >sls_due_dt

-- Values nust not be NULL, zero , or negative

SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price<=0
ORDER BY sls_sales, sls_quantity , sls_price



--For bronze.erp_cust_az12

--Identify Out-of-range Dates
SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

--Data Standarization & Consistency
SELECT DISTINCT gen 
FROM bronze.erp_cust_az12


--For bronze.erp_loc_a101

SELECT 
REPLACE(cid,'-','') cid,
cntry
FROM bronze.erp_loc_a101 

--Data Standardization & Consistency
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101
ORDER BY cntry


--For bronze.erp_px_cat_g1v2
SELECT 
id,
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2

--check for unwanted spaces
SELECT 8 FROM bronze.erp_px_cat_g1v2
WHERE cat !=TRIM(cat) OR subcat !=TRIM(subcat) OR maintenance != TRIM(maintenance) 

--Data Standardization & Consistency
SELECT DISTINCT
cat, subcat, maintenance
FROM bronze.erp_px_cat_g1v2 --Everthing nice





