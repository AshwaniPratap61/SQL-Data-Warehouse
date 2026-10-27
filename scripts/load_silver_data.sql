
DECLARE @start_time DATETIME2, @end_time DATETIME2;
SET @start_time = SYSDATETIME();
PRINT '------------------------------------------------';
PRINT 'Loading CRM Tables';
PRINT '------------------------------------------------';
PRINT 'Truncation table: silver.crm_cust_info';
TRUNCATE TABLE silver.crm_cust_info;
PRINT 'Inserting table: silver.crm_cust_info';

INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
select
    cst_id,
    cst_key,
    trim(cst_firstname) as cst_firstname,
    trim(cst_lastname) as cst_lastname,
    case
        when upper(cst_marital_status) = 'M' then 'Married'
        when upper(cst_marital_status) = 'S' then 'Single'
        when cst_marital_status is null then 'Unknown'
        else 'n/a'
    end as cst_marital_status,
    case
        when upper(cst_gndr) = 'M' then 'Male'
        when upper(cst_gndr) = 'F' then 'Female'
        when cst_gndr is null then 'Unknown'
        else 'n/a'
    end as cst_gndr,
    cst_create_date
from(
select 
    *,
    row_number() over(partition by cst_id order by cst_create_date desc) as id_flag
from bronze.crm_cust_info
where cst_id is not null 
)t where id_flag = 1
SET @end_time = SYSDATETIME();
PRINT 'Exicution Time ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR) + ' ms'
PRINT '>> -------------';



-- ================================================================================================
PRINT '>> Truncating Table: silver.crm_prd_info';
TRUNCATE TABLE silver.crm_prd_info;
PRINT '>> Inserting Data Into: silver.crm_prd_info';
INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
select
    prd_id,
    replace(substring(prd_key, 1, 5), '-', '_') as cat_key,
    substring(prd_key, 7, len(prd_key)) as prd_key,
    trim(prd_nm) as prd_nm,
    isnull(prd_cost, 0) as prd_cost,
    case upper(trim(prd_line))
        when 'M' then 'Mountain'
        when 'R' then 'Roads'
        when 'S' then 'Other Sales'
        when 'T' then 'Touring'
        else 'n/a'
    end as prd_line,
    prd_start_dt,
    dateadd(day, -1, lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)) as prd_end_dt
from bronze.crm_prd_info;