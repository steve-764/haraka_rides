-- =============================================================================================================
-- ================================		Fleet_staging cleaning	================================================
-- =============================================================================================================

-- vehicle plate

select distinct vehicle_plate, 
		count(*) as plates_count 
from haraka.fleet_staging
group by vehicle_plate ;

/* case issue- standerdize to upper case. 
	leading whitespace issue */

SELECT  
    vehicle_plate  
FROM haraka.fleet_staging
WHERE vehicle_plate != UPPER(TRIM(vehicle_plate)); -- selecting all plates not in upper case or having a leading whitespace


UPDATE haraka.fleet_staging
SET vehicle_plate = UPPER(TRIM(vehicle_plate))      -- removing leading whitespace and setting case to upper using UPPER()
WHERE vehicle_plate != UPPER(TRIM(vehicle_plate));

-- 12 unique vehicle plates remain

-- =============================================================================================================

-- vehicle make 

select distinct vehicle_make , 
		count(*) as make_count 
from haraka.fleet_staging
group by vehicle_make ;

/* case issue- standerdize to proper case. 
	leading whitespace issue */

SELECT
    vehicle_make  
FROM haraka.fleet_staging
WHERE vehicle_make != INITCAP(TRIM(vehicle_make)); -- 27 rows with issues

UPDATE haraka.fleet_staging
SET vehicle_make = INITCAP(TRIM(vehicle_make))      -- removing leading whitespace and setting case to upper using INITCAP()
WHERE vehicle_make != INITCAP(TRIM(vehicle_make));

-- =============================================================================================================

-- vehicle model

select distinct vehicle_model , 
		count(*) as model_count 
from haraka.fleet_staging
group by vehicle_model ;

/* case issue- standerdize to proper case. 
	leading whitespace issue */

SELECT
    vehicle_model  
FROM haraka.fleet_staging
WHERE vehicle_model != INITCAP(TRIM(vehicle_model)); -- 36 rows with issues

UPDATE haraka.fleet_staging
SET vehicle_model = INITCAP(TRIM(vehicle_model))      -- removing leading whitespace and setting case to upper using INITCAP()
WHERE vehicle_model != INITCAP(TRIM(vehicle_model));

-- =============================================================================================================

-- vehicle year
select distinct vehicle_year,
		count(*) as year_count 
from haraka.fleet_staging
group by vehicle_year;

/* no issue observed */

-- =============================================================================================================

-- vehicle type

select distinct vehicle_type , 
		count(*) as type_count 
from haraka.fleet_staging
group by vehicle_type;

/* no issue observed */

-- =============================================================================================================

-- vehicle status

select distinct vehicle_status , 
		count(*) as status_count 
from haraka.fleet_staging
group by vehicle_status;

/* no issue observed */

-- =============================================================================================================

-- event type

select distinct event_type  , 
		count(*) as event_count 
from haraka.fleet_staging
group by event_type  ;

/* case issue- standerdize to proper case. 
	leading whitespace issue */

SELECT
    event_type  
FROM haraka.fleet_staging
WHERE event_type != INITCAP(TRIM(event_type)); -- 40 rows with issues

UPDATE haraka.fleet_staging
SET event_type = INITCAP(TRIM(event_type))      -- removing leading whitespace and setting case to upper using INITCAP()
WHERE event_type != INITCAP(TRIM(event_type));

-- =============================================================================================================

-- event date 

SELECT 
    event_date 
FROM haraka.fleet_staging t 
WHERE event_date NOT SIMILAR TO '[0-9]{4}-[0-9]{2}-[0-9]{2}'; -- checking dates not in frormat yyyy-mm-dd
-- total count is 50 dates not in proper format

-- checking dates with / separator

select event_date from haraka.fleet_staging t 
where t.event_date like '%/%';

/* 	some dates in dd/mm/yyyy
 	some dates in dd/mm/yy
*/

-- fixing date in form dd/mm/yy

select event_date from haraka.fleet_staging t 
where t.event_date like '%/%' and LENGTH(event_date) = 8; -- 13 dates in this format

UPDATE haraka.fleet_staging
SET event_date = TO_DATE(event_date,'DD/MM/YY')::TEXT
WHERE event_date LIKE '%/%' AND LENGTH(event_date) = 8;


-- fixing dates in format dd/mm/yyyy

select event_date from haraka.fleet_staging t 
where t.event_date like '%/%' and LENGTH(event_date) = 10; -- 23 dates in this format

UPDATE haraka.fleet_staging
SET event_date = TO_DATE(event_date,'DD/MM/YYYY')::TEXT
WHERE event_date LIKE '%/%' AND LENGTH(event_date) = 10;

--checking dates with - separator 

select event_date from haraka.fleet_staging t 
where t.event_date like '%-%';

/*   dates in mm-dd-yyyy
 * some dates in yyyy-mm-dd - the proper format for this dataset
 */

-- filtering out dates in  mm-dd-yyyy format

SELECT event_date
FROM haraka.fleet_staging t 
WHERE event_date LIKE '%-%'
  AND LENGTH(event_date) = 10
  AND SPLIT_PART(event_date,'-',2)::INTEGER > 12; -- 11 dates in this format
  

UPDATE haraka.fleet_staging t 
SET event_date = TO_DATE(event_date,'MM-DD-YYYY')::TEXT
WHERE event_date LIKE '%-%'
  AND LENGTH(event_date) = 10
  AND SPLIT_PART(event_date,'-',2)::INTEGER > 12;  


-- =============================================================================================================

-- fuel cost 

select fuel_cost from haraka.fleet_staging t ;

/* KES prefix present in some rows, to be removed.
 * comma (,) present in some values, to  be removed.
*/

select fuel_cost
from haraka.fleet_staging t 
where fuel_cost like 'KES%'; 		-- selecting rows starting with KES prefix -- 19 rows 


UPDATE haraka.fleet_staging t 
SET fuel_cost = REGEXP_REPLACE(fuel_cost,'[^0-9.]','','g') -- replacing all characters not in range 0-9 with empty value to remove them.
WHERE fuel_cost SIMILAR TO '%[^0-9.]%';

-- =============================================================================================================

-- station name

select distinct station_name, 
		count(*) as station_count 
from haraka.fleet_staging t
group by station_name ;

/* case issue- standerdize to proper case. 
	leading whitespace issue */


select station_name
from haraka.fleet_staging t 
where station_name != INITCAP(TRIM(t.station_name ));  -- 30 records found

update haraka.fleet_staging t 
set station_name = INITCAP(TRIM(station_name))
where station_name != INITCAP(TRIM(station_name));

-- =============================================================================================================

-- serive type

select distinct t.service_type , 
		count(*) as service_count 
from haraka.fleet_staging t
group by service_type ;

/* no issue found */

-- =============================================================================================================

-- maintenance_cost

select t.maintenance_cost  from haraka.fleet_staging t ;

/* KES prefix present in some rows, to be removed.
 * comma (,) present in some values, to  be removed.
*/

select maintenance_cost
from haraka.fleet_staging t 
where maintenance_cost like 'KES%';		-- selecting rows starting with KES prefix -- 6 rows 


UPDATE haraka.fleet_staging t 
SET maintenance_cost = REGEXP_REPLACE(maintenance_cost,'[^0-9.]','','g') -- replacing all characters not in range 0-9 with empty value to remove them.
WHERE maintenance_cost SIMILAR TO '%[^0-9.]%';

-- =============================================================================================================

-- mechanic name

select distinct t.mechanic_name , 
		count(*) as mechanic_count 
from haraka.fleet_staging t
group by mechanic_name ;

/* case issue- standerdize to proper case. 
	leading whitespace issue */

select mechanic_name
from haraka.fleet_staging t 
where mechanic_name != INITCAP(TRIM(t.mechanic_name ));  -- 19 records found

update haraka.fleet_staging t 
set mechanic_name = INITCAP(TRIM(mechanic_name))
where mechanic_name != INITCAP(TRIM(mechanic_name));


-- =============================================================================================================

-- next service due 

SELECT distinct
    t.next_service_due  
FROM haraka.fleet_staging t 
WHERE event_date NOT SIMILAR TO '[0-9]{4}-[0-9]{2}-[0-9]{2}';
-- 15 dates with issues

-- checking dates with / separator

select next_service_due from haraka.fleet_staging t 
where t.next_service_due like '%/%';

/* 	some dates in dd/mm/yyyy
 	some dates in dd/mm/yy
*/

-- fixing date in form dd/mm/yy

select next_service_due from haraka.fleet_staging t 
where t.next_service_due like '%/%' and LENGTH(next_service_due) = 8; -- 2 dates in this format

UPDATE haraka.fleet_staging
SET next_service_due = TO_DATE(next_service_due,'DD/MM/YY')::TEXT
WHERE next_service_due LIKE '%/%' AND LENGTH(next_service_due) = 8;


-- fixing dates in format dd/mm/yyyy

select next_service_due from haraka.fleet_staging t 
where t.next_service_due like '%/%' and LENGTH(next_service_due) = 10; -- 9 dates in this format

UPDATE haraka.fleet_staging
SET next_service_due = TO_DATE(next_service_due,'DD/MM/YYYY')::TEXT
WHERE next_service_due LIKE '%/%' AND LENGTH(next_service_due) = 10;

/*   dates in mm-dd-yyyy
 */
select next_service_due from haraka.fleet_staging t 
where t.next_service_due like '%-%';

-- filtering out dates in  mm-dd-yyyy format

SELECT next_service_due
FROM haraka.fleet_staging t 
WHERE next_service_due LIKE '%-%'
  AND LENGTH(next_service_due) = 10
  AND SPLIT_PART(next_service_due,'-',1)::INTEGER <= 12; -- 6 dates in this format
  

UPDATE haraka.fleet_staging t 
SET next_service_due = TO_DATE(next_service_due,'MM-DD-YYYY')::TEXT
WHERE next_service_due LIKE '%-%'
  AND LENGTH(next_service_due) = 10
  AND SPLIT_PART(next_service_due,'-',1)::INTEGER <= 12; 

-- =============================================================================================================
-- viewing log id that appear more than once in the table

select log_id,
		count(*) as log_count
from haraka.fleet_staging 
group by log_id 
having count(*) > 1;

/* log_id 4, 21, 56, and 41 appear twice */
/* confirming that the logs are replicated */ 

select * from haraka.fleet_staging t 
where log_id in ('4', '21', '41', '56')
order by log_id ;

/* removing the duplicates */

delete from haraka.fleet_staging 
where ctid not in 
	(select min(ctid) from haraka.fleet_staging group by log_id);
	
	
	
select * from haraka.fleet_staging;

