set search_path to haraka;

-- =============================================================================================================

-- looking at the customer related data in the trips staging table


select customer_name,
		customer_phone,
		customer_area
from haraka.trip_staging ts
order by customer_name;

select distinct customer_name
from haraka.trip_staging ts;

-- some customer names have data in some customer phone and customer area but data is missing in some rows.
-- These customer names have to be standerdized during data insertion.

-- =============================================================================================================

-- creating Customers table

create table if not exists haraka.customers (
		customer_id 	SERIAL primary key,
		customer_name	VARCHAR(100),
		customer_phone	VARCHAR(100),
		customer_area	VARCHAR(100)
);

-- =============================================================================================================


-- inserting data into the customers table from trips staging

insert into haraka.customers (
		customer_name,
		customer_phone,
		customer_area
)
select INITCAP(TRIM(customer_name)) as customer_name,
			-- using max() function to filter where the customer phone is empty
		    MAX(
		        NULLIF(
		            REGEXP_REPLACE(TRIM(customer_phone), '[^0-9+]', '', 'g'),'')
		    ) AS customer_phone,
		    --using max() function to filter out where the customer area is empty.
    MAX(NULLIF(TRIM(customer_area), '')) AS customer_area
from haraka.trip_staging ts 
where ts.customer_name is not null 
group by INITCAP(TRIM(customer_name));


-- =============================================================================================================

select * from haraka.customers c;


