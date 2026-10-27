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


