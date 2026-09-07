set search_path to haraka;

-- =============================================================================================================

-- looking at driver related data in trips staging data

select distinct driver_name, driver_phone
from haraka.trip_staging ts
order by driver_name;


select distinct driver_name
from haraka.trip_staging ts
order by driver_name;

-- =============================================================================================================

-- create drivers table

create table if not exists haraka.drivers(
		driver_id		SERIAL  primary key,
		driver_name		VARCHAR(100),
		driver_phone	VARCHAR(100)
);

-- =============================================================================================================

-- insert data into drivers table from the trips staging table

insert into haraka.drivers(
		driver_name,
		driver_phone
)
select INITCAP(TRIM(driver_name)) as driver_name,
		-- using max() function to standerdize where the driver phone is empty
		    MAX(
		        NULLIF(
		            REGEXP_REPLACE(TRIM(driver_phone), '[^0-9+]', '', 'g'),'')
		    ) AS driver_phone
from haraka.trip_staging ts 
where driver_name is not null
group by INITCAP(TRIM(driver_name));

-- =============================================================================================================

-- viewing the drivers table

select * from haraka.drivers d;
