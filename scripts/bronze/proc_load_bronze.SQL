/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure orchestrates the ingestion of raw data from external 
    CSV files into the 'bronze' schema. It serves as the entry point for the 
    Data Warehouse ETL process.

    Key Actions:
    - Performance Logging: Captures start/end times for each table load.
    - Data Refresh: Truncates existing data to ensure a fresh full load.
    - Bulk Ingestion: Uses 'BULK INSERT' for high-performance data movement.
    - Error Handling: Implements a TRY...CATCH block to capture and report 
      load failures including Error Messages and States.

Parameters:
    None. 

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/


-- Now run the procedure separately
EXEC bronze.load_bronze;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY
    PRINT '===========================================================================================================';
    PRINT 'Loading Bronze Layer';
    PRINT '===========================================================================================================';
    
    PRINT '===========================================================================================================';
    PRINT 'Loading CRM Tables';
    PRINT '===========================================================================================================';

    -- CRM Table Loading
    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;
    PRINT 'Inserting Table: bronze.crm_cust_info';
    BULK INSERT bronze.crm_cust_info FROM 'D:\Data Science Projects\Data Engineering project\Project materials\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\cust_info.csv' WITH(FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
    SET @end_time = GETDATE();
    PRINT '>>Load Duration: '+CAST(DATEDIFF(second,@start_time, @end_time)AS NVARCHAR)+'seconds';
    PRINT '>>----------------------------------------------------';

    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info;
    PRINT 'Inserting Table: bronze.crm_prd_info';
    BULK INSERT bronze.crm_prd_info FROM 'D:\Data Science Projects\Data Engineering project\Project materials\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\prd_info.csv' WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
    SET @end_time = GETDATE();
    PRINT '>>Load Duration: '+CAST(DATEDIFF(second,@start_time, @end_time)AS NVARCHAR)+'seconds';
    PRINT '>>----------------------------------------------------';

    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;
    PRINT 'Inserting Table: bronze.crm_sales_details';
    BULK INSERT bronze.crm_sales_details FROM 'D:\Data Science Projects\Data Engineering project\Project materials\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\sales_details.csv' WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
    SET @end_time = GETDATE();
    PRINT '>>Load Duration: '+CAST(DATEDIFF(second,@start_time, @end_time)AS NVARCHAR)+'seconds';
    PRINT '>>----------------------------------------------------';

    PRINT '-----------------------------------------------------------------------------------------------------------';
    PRINT 'Loading ERP Tables';
    PRINT '-----------------------------------------------------------------------------------------------------------';

    -- ERP Table Loading
    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: bronze.erp_cust_az12';
    TRUNCATE TABLE bronze.erp_cust_az12;
    PRINT 'Inserting Table: bronze.erp_cust_az12';
    BULK INSERT bronze.erp_cust_az12 FROM 'D:\Data Science Projects\Data Engineering project\Project materials\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv' WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
    SET @end_time = GETDATE();
    PRINT '>>Load Duration: '+CAST(DATEDIFF(second,@start_time, @end_time)AS NVARCHAR)+'seconds';
    PRINT '>>----------------------------------------------------';

    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: bronze.erp_loc_a101';
    TRUNCATE TABLE bronze.erp_loc_a101;
    PRINT 'Inserting Table: bronze.erp_loc_a101';
    BULK INSERT bronze.erp_loc_a101 FROM 'D:\Data Science Projects\Data Engineering project\Project materials\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv' WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
    SET @end_time = GETDATE();
    PRINT '>>Load Duration: '+CAST(DATEDIFF(second,@start_time, @end_time)AS NVARCHAR)+'seconds';
    PRINT '>>----------------------------------------------------';

    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    PRINT 'Inserting Table: bronze.erp_px_cat_g1v2';
    BULK INSERT bronze.erp_px_cat_g1v2 FROM 'D:\Data Science Projects\Data Engineering project\Project materials\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv' WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
    SET @end_time = GETDATE();
    PRINT '>>Load Duration: '+CAST(DATEDIFF(second,@start_time, @end_time)AS NVARCHAR)+'seconds';
    PRINT '>>----------------------------------------------------';

    SET @batch_end_time = GETDATE();
    PRINT '===========================================================================================================';
    PRINT 'Loading Bronze Layer is completed';
    PRINT '  -Toatal Load Duration :'+ CAST(DATEDIFF(second, @batch_start_time, @batch_end_time)AS NVARCHAR)+'seconds';
    PRINT '===========================================================================================================';

     

    END TRY
    BEGIN CATCH
     PRINT '==========================================================================================================='
     PRINT 'ERROR OCCUR DURING BRONZE LAYER'
     PRINT 'Error Message' + ERROR_MESSAGE();
     PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
     PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
     PRINT '==========================================================================================================='
    END CATCH

END
-- <--- THIS IS CRITICAL. It separates the CREATE from the EXEC

