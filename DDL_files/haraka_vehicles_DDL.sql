set search_path to haraka;

-- =============================================================================================================

-- creating vehicles table

create table if not exists haraka.vehicles(
		vehicle_id 		SERIAL			 primary key,
		vehicle_plate 	VARCHAR(50)		 not null unique,
		vehicle_make 	VARCHAR(100),
		vehicle_model	VARCHAR(100),
		vehicle_year	INTEGER,
		vehicle_type 	VARCHAR(100),
		vehicle_status	VARCHAR(100)
);


-- =============================================================================================================

-- inserting vehicles data from the fleet staging table

insert into haraka.vehicles ( 
	vehicle_plate,
	vehicle_make,
	vehicle_model,
	vehicle_year,
	vehicle_type,
	vehicle_status
)
select distinct on (vehicle_plate) TRIM(UPPER(vehicle_plate)) as vehicle_plate,
					vehicle_make,
					vehicle_model,
					vehicle_year::INTEGER,
					vehicle_type,
					vehicle_status 
from haraka.fleet_staging
where vehicle_plate is not null
order by vehicle_plate;

-- =============================================================================================================

select * from haraka.vehicles v;
				
